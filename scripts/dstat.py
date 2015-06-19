#!/usr/bin/env python

# Prelude {{{1

### This program is free software; you can redistribute it and/or modify
### it under the terms of the GNU Library General Public License as published by
### the Free Software Foundation; version 2 only
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
### GNU Library General Public License for more details.
###
### You should have received a copy of the GNU Library General Public License
### along with this program; if not, write to the Free Software
### Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
### Copyright 2004-2007 Dag Wieers <dag@wieers.com>

from __future__ import generators
try:
	import sys, os, time, sched, re
	import types, resource, getpass, glob
except KeyboardInterrupt, e:
	pass

VERSION = '0.7.0'
theme = {
	'colors_lo': ('\x1b[0;37m', '\x1b[0;33m', '\x1b[1;31m', '\x1b[0;31m'),
}

class Options:
	delay = 1
	output = None
op = Options

# Stats definitions {{{1

class dstat:
	vars = None
	name = None
	nick = None
	type = 'f'
	width = 5
	scale = 1024
	cols = 0

	def prepare(self):
		if callable(self.discover):
			self.discover = self.discover()
		if callable(self.vars):
			self.vars = self.vars()
		if not self.vars:
			raise Exception, 'No counter objects to monitor'
		if callable(self.name):
			self.name = self.name()
		if callable(self.nick):
			self.nick = self.nick()
		if not self.nick:
			self.nick = self.vars

		self.val = {}; self.set1 = {}; self.set2 = {}
		if self.cols <= 0:
			for name in self.vars:
				self.val[name] = self.set1[name] = self.set2[name] = 0
		else:
			for name in self.vars + [ 'total', ]:
				self.val[name] = range(self.cols)
				self.set1[name] = range(self.cols)
				self.set2[name] = range(self.cols)
				for i in range(self.cols):
					self.val[name][i] = self.set1[name][i] = self.set2[name][i] = 0

	def open(self, *filenames):
		"Open stat file descriptor"
		self.file = []
		self.fd = []
		for filename in filenames:
			try:
				fd = dopen(filename)
				if fd:
					self.file.append(filename)
					self.fd.append(fd)
			except:
				pass
		if not self.fd:
			raise Exception, 'Cannot open file %s' % filename

	def readlines(self):
		"Return lines from any file descriptor"
		for fd in self.fd:
			fd.seek(0)
			for line in fd.readlines():
				yield line

	def splitlines(self, delim=None, replace=None):
		"Return split lines from any file descriptor"
		for fd in self.fd:
			fd.seek(0)
			for line in fd.readlines():
				if replace and delim:
					yield line.replace(replace, delim).split(delim)
				elif replace:
					yield line.replace(replace, ' ').split()
				else:
					yield line.split(delim)

	def statwidth(self):
		"Return complete stat width"
		if self.cols:
			return len(self.vars) * self.colwidth() + len(self.vars) - 1
		else:
			return len(self.nick) * self.colwidth() + len(self.nick) - 1

	def colwidth(self):
		"Return column width"
		if isinstance(self.name, types.StringType):
			return self.width
		else:
			return len(self.nick) * self.width + len(self.nick) - 1

	def title(self):
		if isinstance(self.name, types.StringType):
			width = self.statwidth()
			return self.name[0:width].center(width).replace(' ', '-')
		for i, name in enumerate(self.name):
			width = self.colwidth()
			ret = ret + name[0:width].center(width).replace(' ', '-')
			if i + 1 != len(self.name):
				ret = ret + char['space']
		return ret

	def subtitle(self):
		ret = ''
		if isinstance(self.name, types.StringType):
			for i, nick in enumerate(self.nick):
				ret = ret + nick[0:self.width].center(self.width)
				if i + 1 != len(self.nick): ret = ret + char['space']
			return ret
		else:
			for i, name in enumerate(self.name):
				for j, nick in enumerate(self.nick):
					ret = ret + nick[0:self.width].center(self.width)
					if j + 1 != len(self.nick): ret = ret + char['space']
				if i + 1 != len(self.name): ret = ret + char['colon']
			return ret

	def csvtitle(self):
		if isinstance(self.name, types.StringType):
			return '"' + self.name + '"' + ',' * (len(self.nick) - 1)
		else:
			ret = ''
			for i, name in enumerate(self.name):
				ret = ret + '"' + name + '"' + ',' * (len(self.nick) - 1)
				if i + 1 != len(self.name): ret = ret + ','
			return ret

	def csvsubtitle(self):
		ret = ''
		if isinstance(self.name, types.StringType):
			for i, nick in enumerate(self.nick):
				ret = ret + '"' + nick + '"'
				if i + 1 != len(self.nick): ret = ret + ','
			return ret
		else:
			for i, name in enumerate(self.name):
				for j, nick in enumerate(self.nick):
					ret = ret + '"' + nick + '"'
					if j + 1 != len(self.nick): ret = ret + ','
				if i + 1 != len(self.name): ret = ret + ','
			return ret

	def check(self):
		"Check if stat is applicable"
		if not self.vars:
			raise Exception, 'No objects found, no stats available'
		if not self.discover:
			raise Exception, 'No objects discovered, no stats available'
		if self.colwidth():
			return True
		raise Exception, 'Unknown problem, please report'

	def discover(self, *objlist):
		return True

	def show(self):
		"Display stat results"
		line = ''
		for i, name in enumerate(self.vars):
			if isinstance(self.val[name], types.TupleType) or isinstance(self.val[name], types.ListType):
				line = line + cprintlist(self.val[name], self.type, self.width, self.scale)
				sep = char['colon']
			else:
				line = line + cprint(self.val[name], self.type, self.width, self.scale)
				sep = char['space']
			if i + 1 != len(self.vars):
				line = line + sep
		return line

	def showend(self, totlist, vislist):
		if self is not vislist[-1]:
			return char['pipe']
		elif totlist != vislist:
			return char['gt']
		return ''

	def showcsv(self):
		def printcsv(var):
			if var != round(var):
				return '%.3f' % var
			return '%s' % round(var)

		line = ''
		for i, name in enumerate(self.vars):
			if isinstance(self.val[name], types.ListType) or isinstance(self.val[name], types.TupleType):
				for j, val in enumerate(self.val[name]):
					line = line + printcsv(val)
					if j + 1 != len(self.val[name]):
						line = line + ','
			elif isinstance(self.val[name], types.StringType):
				line = line + self.val[name]
			else:
				line = line + printcsv(self.val[name])
			if i + 1 != len(self.vars):
				line = line + ','
		return line

	def showcsvend(self, totlist, vislist):
		if self is not vislist[-1]:
			return ','
		elif self is not totlist[-1]:
			return ','
		return ''

class dstat_aio(dstat):
	def __init__(self):
		self.name = 'async'
		self.type = 'd'
		self.width = 5;
		self.open('/proc/sys/fs/aio-nr')
		self.nick = ('#aio',)
		self.vars = ('aio',)

	def extract(self):
		for l in self.splitlines():
			if len(l) < 1: continue
			self.val['aio'] = long(l[0])

class dstat_cpu(dstat):
	def __init__(self):
		self.type = 'p'
		self.width = 5
		self.scale = 30
		self.open('/proc/stat')
		self.cols = 2
		self.vars = ['user', 'sys']
		self.name = 'total'
		self.old = dict(user=0, sys=0, total=0)

	def extract(self):
		for l in self.splitlines():
			if l[0] != 'cpu': continue
			l = map(float, l[1:])
			self.set2['user'] = l[0] + l[1]
			self.set2['sys'] = l[2] + l[4] + l[5] + l[6]
			self.set2['total'] = self.set2['user'] + self.set2['sys'] + l[3]
		for name in self.vars:
			self.val[name] = 100.0 * (self.set2[name] - self.old[name]) / (self.set2['total'] - self.old['total'])
		self.old.update(self.set2)

class dstat_freespace(dstat):
	def __init__(self):
		self.type = 'p'
		self.scale = 30
		self.width = 5
		self.name = 'hdd'
		self.vars = ['used%']

	def extract(self):
		res = os.statvfs('/var')
		self.val['used%'] = 100 * (1 - float(res.f_bavail) / float(res.f_blocks))

class dstat_io(dstat):
	def __init__(self):
		self.type = 'p'
		self.width = 5
		self.scale = 30
		self.diskfilter = re.compile('(dm-[0-9]+|md[0-9]+|[hs]d[a-z]+[0-9]+)')
		self.name = 'i/o'
		self.open('/sys/block/sda/stat')
		self.vars = ['read', 'writ']
		self.old = dict(read=0, writ=0)

	def extract(self):
		for l in self.splitlines():
			self.set2 = dict(read=float(l[3]), writ=float(l[7]))
			for name in self.vars:
				self.val[name] = (self.set2[name] - self.old[name]) / 1000
		self.old.update(self.set2)

class dstat_ipc(dstat):
	def __init__(self):
		self.name = 'sysv ipc'
		self.type = 'd'
		self.width = 3
		self.scale = 10
		self.vars = ('msg', 'sem', 'shm')

	def extract(self):
		for name in self.vars:
			self.val[name] = len(dopen('/proc/sysvipc/'+name).readlines()) - 1

class dstat_load(dstat):
	def __init__(self):
		self.name = 'load avg'
		self.type = 'f'
		self.width = 4
		self.scale = 0.5
		self.open('/proc/loadavg')
		self.nick = ('1m', '5m', '15m')
		self.vars = ('load1', 'load5', 'load15')

	def extract(self):
		for l in self.splitlines():
			if len(l) < 3: continue
			self.val['load1'] = float(l[0])
			self.val['load5'] = float(l[1])
			self.val['load15'] = float(l[2])

class dstat_mem(dstat):
	def __init__(self):
		self.type = 'p'
		self.scale = 30
		self.name = 'mem'
		self.open('/proc/meminfo')
		self.vars = ('used%',)

	def extract(self):
		lines = self.splitlines()
		total = float(lines.next()[1])
		free = float(lines.next()[1])
		buffers = float(lines.next()[1])
		cached = float(lines.next()[1])
		self.val['used%'] = 100 * (total - free - buffers - cached) / total

class dstat_net(dstat):
	def __init__(self):
		self.open('/proc/net/dev')
		self.type = 'd'
		self.nick = ('recv', 'send')
		self.totalfilter = re.compile('^(lo|bond[0-9]+|face|.+\\.[0-9]+)$')
		self.cols = 2

	def discover(self, *objlist):
		ret = []
		for l in self.splitlines(replace=':'):
			if len(l) < 17: continue
			if l[2] == '0' and l[10] == '0': continue
			name = l[0]
			if name not in ('lo', 'face'):
				ret.append(name)
		ret.sort()
		for item in objlist: ret.append(item)
		return ret

	def vars(self):
		ret = []
		varlist = ('total',)
		for name in varlist:
			if name in self.discover + ['total', 'lo']:
				ret.append(name)
		if not ret:
			raise Exception, "No suitable network interfaces found to monitor"
		return ret

	def name(self):
		return ['net/'+name for name in self.vars]

	def extract(self):
		self.set2['total'] = [0, 0]
		for l in self.splitlines(replace=':'):
			if len(l) < 17: continue
			if l[2] == '0' and l[10] == '0': continue
			name = l[0]
			if name in self.vars :
				self.set2[name] = ( long(l[1]), long(l[9]) )
			if not self.totalfilter.match(name):
				self.set2['total'] = ( self.set2['total'][0] + long(l[1]), self.set2['total'][1] + long(l[9]))
		if update:
			for name in self.set2.keys():
				self.val[name] = (
					(self.set2[name][0] - self.set1[name][0]) * 1.0 / elapsed,
					(self.set2[name][1] - self.set1[name][1]) * 1.0 / elapsed,
				 )
		if step == op.delay:
			self.set1.update(self.set2)

class dstat_raw(dstat):
	def __init__(self):
		self.name = 'raw'
		self.type = 'd'
		self.width = 3
		self.scale = 100
		self.open('/proc/net/raw')
		self.nick = ('raw',)
		self.vars = ('sockets',)

	def extract(self):
		lines = -1
		for line in self.readlines():
			lines = lines + 1
		self.val['sockets'] = lines

class dstat_socket(dstat):
	def __init__(self):
		self.name = 'sockets'
		self.type = 'd'
		self.width = 3
		self.scale = 100
		self.open('/proc/net/sockstat')
		self.nick = ('tot', 'tcp', 'udp', 'raw', 'frg')
		self.vars = ('sockets:', 'TCP:', 'UDP:', 'RAW:', 'FRAG:')

	def extract(self):
		for l in self.splitlines():
			if len(l) < 3: continue
			self.val[l[0]] = long(l[2])
		self.val['other'] = self.val['sockets:'] - self.val['TCP:'] - self.val['UDP:'] - self.val['RAW:'] - self.val['FRAG:']

class dstat_tcp(dstat):
	def __init__(self):
		self.name = 'tcp sockets'
		self.type = 'd'
		self.width = 3
		self.scale = 100
		self.open('/proc/net/tcp', '/proc/net/tcp6')
		self.nick = ('lis', 'act', 'syn', 'tim', 'clo')
		self.vars = ('listen', 'established', 'syn', 'wait', 'close')

	def extract(self):
		for name in self.vars: self.val[name] = 0
		for l in self.splitlines():
			if len(l) < 12: continue
			### 01: established, 02: syn_sent,    03: syn_recv, 04: fin_wait1,
			### 05: fin_wait2,     06: time_wait, 07: close,      08: close_wait,
			### 09: last_ack,     0A: listen,    0B: closing
			if l[3] in ('0A',): self.val['listen'] = self.val['listen'] + 1
			elif l[3] in ('01',): self.val['established'] = self.val['established'] + 1
			elif l[3] in ('02', '03', '09',): self.val['syn'] = self.val['syn'] + 1
			elif l[3] in ('06',): self.val['wait'] = self.val['wait'] + 1
			elif l[3] in ('04', '05', '07', '08', '0B',): self.val['close'] = self.val['close'] + 1

class dstat_udp(dstat):
	def __init__(self):
		self.name = 'udp'
		self.type = 'd'
		self.width = 3
		self.scale = 100
		self.open('/proc/net/udp', '/proc/net/udp6')
		self.nick = ('lis', 'act')
		self.vars = ('listen', 'established')

	def extract(self):
		for name in self.vars: self.val[name] = 0
		for l in self.splitlines():
			if l[3] == '07': self.val['listen'] = self.val['listen'] + 1
			elif l[3] == '01': self.val['established'] = self.val['established'] + 1

class dstat_unix(dstat):
	def __init__(self):
		self.name = 'unix sockets'
		self.type = 'd'
		self.width = 3
		self.scale = 100
		self.open('/proc/net/unix')
		self.nick = ('dgm', 'str', 'lis', 'act')
		self.vars = ('datagram', 'stream', 'listen', 'established')

	def extract(self):
		for name in self.vars: self.val[name] = 0
		for l in self.splitlines():
			if l[4] == '0002':
				self.val['datagram'] = self.val['datagram'] + 1
			elif l[4] == '0001':
				self.val['stream'] = self.val['stream'] + 1
				if l[5] == '01':
					self.val['listen'] = self.val['listen'] + 1
				elif l[5] == '03':
					self.val['established'] = self.val['established'] + 1

class dstat_top_cpu(dstat):
	def __init__(self):
		self.name = 'most expensive'
		self.type = 's'
		self.width = 16
		self.scale = 0
		self.vars = ('cpu process',)
		self.pid = str(os.getpid())
		self.pidset1 = {}; self.pidset2 = {}

	def extract(self):
		self.val['max'] = 0.0
		self.val['cpu process'] = ''
		for pid in os.listdir('/proc/'):
			try:
				### Is it a pid ?
				int(pid)

				### Filter out dstat
				if pid == self.pid: continue

				### Using dopen() will cause too many open files
				l = open('/proc/%s/stat' % pid).read().split()

			except ValueError:
				continue
			except IOError:
				continue

			if len(l) < 15: continue

			### Reset previous value if it doesn't exist
			if not self.pidset1.has_key(pid):
				self.pidset1[pid] = 0

			self.pidset2[pid] = int(l[13]) + int(l[14])
			usage = (self.pidset2[pid] - self.pidset1[pid]) * 1.0 / elapsed / cpunr

			### Is it a new topper ?
			if usage < self.val['max']: continue

			name = l[1][1:-1]

			self.val['max'] = usage
			self.val['pid'] = pid
			self.val['name'] = getnamebypid(pid, name)

		if self.val['max'] != 0.0:
			self.val['cpu process'] = '%-*s%s' % (self.width-3, self.val['name'][0:self.width-3], cprint(self.val['max'], 'f', 3, 34))

		if step == op.delay:
			self.pidset1.update(self.pidset2)

	def showcsv(self):
		return '%s / %d%%' % (self.val['name'], self.val['max'])

class dstat_top_mem(dstat):
	def __init__(self):
		self.name = 'most expensive'
		self.type = 's'
		self.width = 17
		self.scale = 0
		self.vars = ('memory process',)
		self.pid = str(os.getpid())

	def extract(self):
		self.val['max'] = 0.0
		for pid in os.listdir('/proc/'):
			try:
				### Is it a pid ?
				int(pid)

				### Filter out dstat
				if pid == self.pid: continue

				### Using dopen() will cause too many open files
				l = open('/proc/%s/stat' % pid).read().split()

			except ValueError:
				continue
			except IOError:
				continue

			if len(l) < 23: continue
			usage = int(l[23]) * pagesize

			### Is it a new topper ?
			if usage <= self.val['max']: continue

			self.val['max'] = usage
			self.val['name'] = getnamebypid(pid, l[1][1:-1])
			self.val['pid'] = pid

		self.val['memory process'] = '%-*s%s' % (self.width-5, self.val['name'][0:self.width-5], cprint(self.val['max'], 'f', 5, 1024))

	def showcsv(self):
		return '%s / %d%%' % (self.val['name'], self.val['max'])

class dstat_top_bio(dstat):
	def __init__(self):
		self.name = 'most expensive'
		self.type = 's'
		self.width = 22
		self.scale = 0
		self.vars = ('block i/o process',)
		self.pid = str(os.getpid())
		self.pidset1 = {}; self.pidset2 = {}

	def check(self):
		if not os.access('/proc/self/io', os.R_OK):
			raise Exception, 'Kernel has no I/O accounting, use at least 2.6.20'

	def extract(self):
		self.val['usage'] = 0.0
		self.val['block i/o process'] = ''
		for pid in os.listdir('/proc/'):
			try:
				### Is it a pid ?
				int(pid)

				### Filter out dstat
				if pid == self.pid: continue

				### Reset values
				if not self.pidset2.has_key(pid):
					self.pidset2[pid] = {'read_bytes:': 0, 'write_bytes:': 0}
				if not self.pidset1.has_key(pid):
					self.pidset1[pid] = {'read_bytes:': 0, 'write_bytes:': 0}

				### Extract name
				name = open('/proc/%s/stat' % pid).read().split()[1][1:-1]

				### Extract counters
				for line in open('/proc/%s/io' % pid).readlines():
					l = line.split()
					if len(l) != 2: continue
					self.pidset2[pid][l[0]] = int(l[1])

			except ValueError:
				continue
			except IOError:
				continue

			read_usage = (self.pidset2[pid]['read_bytes:'] - self.pidset1[pid]['read_bytes:']) * 1.0 / elapsed
			write_usage = (self.pidset2[pid]['write_bytes:'] - self.pidset1[pid]['write_bytes:']) * 1.0 / elapsed
			usage = read_usage + write_usage

			### Get the process that spends the most jiffies
			if usage > self.val['usage']:
				self.val['usage'] = usage
				self.val['read_usage'] = read_usage
				self.val['write_usage'] = write_usage
				self.val['pid'] = pid
				self.val['name'] = getnamebypid(pid, name)
#                st = os.stat("/proc/%s" % pid)

		if step == op.delay:
			for pid in self.pidset2.keys():
				self.pidset1[pid].update(self.pidset2[pid])

		if self.val['usage'] != 0.0:
			self.val['block i/o process'] = '%-*s%s %s' % (self.width-11, self.val['name'][0:self.width-11], cprint(self.val['read_usage'], 'd', 5, 1024), cprint(self.val['write_usage'], 'd', 5, 1024))

	def showcsv(self):
		return '%s / %d:%d' % (self.val['name'], self.val['read_usage'], self.val['write_usage'])

# Main {{{1

char = {
	'pipe': '|',
	'colon': ':',
	'gt': '>',
	'space': ' ',
	'dash': '-',
	'plus': '+',
}

def ticks():
	"Return the number of 'ticks' since bootup"
	try:
		for line in open('/proc/uptime', 'r', 0).readlines():
			l = line.split()
			if len(l) < 2: continue
			return float(l[0])
	except:
		for line in dopen('/proc/stat').readlines():
			l = line.split()
			if len(l) < 2: continue
			if l[0] == 'btime':
				return time.time() - long(l[1])

def improve(devname):
	"Improve a device name"
	if devname.startswith('/dev/mapper/'):
		devname = devname.split('/')[3]
	elif devname.startswith('/dev/'):
		devname = devname.split('/')[2]
	return devname

def dopen(filename):
	"Open a file for reuse, if already opened, return file descriptor"
	global fds
	if not os.path.exists(filename):
		raise Exception, 'File %s does not exist' % filename
	if 'fds' not in globals().keys():
		fds = {}
	if file not in fds.keys():
		fds[filename] = open(filename, 'r', 0)
	else:
		fds[filename].seek(0)
	return fds[filename]

def dclose(filename):
	"Close an open file and remove file descriptor from list"
	global fds
	if not 'fds' in globals().keys(): fds = {}
	if filename in fds:
		fds[filename].close()
		del(fds[filename])

def dpopen(cmd):
	"Open a pipe for reuse, if already opened, return pipes"
	global pipes
	if 'pipes' not in globals().keys(): pipes = {}
	if cmd not in pipes.keys():
		pipes[cmd] = os.popen3(cmd, 't', 0)
	return pipes[cmd]

def readpipe(fileobj, tmout = 0.001):
	"Read available data from pipe in a non-blocking fashion"
	ret = ''
	while not select.select([fileobj.fileno()], [], [], tmout)[0]:
		pass
	while select.select([fileobj.fileno()], [], [], tmout)[0]:
		ret = ret + fileobj.read(1)
	return ret.split('\n')

def greppipe(fileobj, str, tmout = 0.001):
	"Grep available data from pipe in a non-blocking fashion"
	ret = ''
	while not select.select([fileobj.fileno()], [], [], tmout)[0]:
		pass
	while select.select([fileobj.fileno()], [], [], tmout)[0]:
		character = fileobj.read(1)
		if character != '\n':
			ret = ret + character
		elif ret.startswith(str):
			return ret
		else:
			ret = ''
	return None

def matchpipe(fileobj, string, tmout = 0.001):
	"Match available data from pipe in a non-blocking fashion"
	ret = ''
	regexp = re.compile(string)
	while not select.select([fileobj.fileno()], [], [], tmout)[0]:
		pass
	while select.select([fileobj.fileno()], [], [], tmout)[0]:
		character = fileobj.read(1)
		if character != '\n':
			ret = ret + character
		elif regexp.match(ret):
			return ret
		else:
			ret = ''
	return None

def dchg(var, width, base):
	"Convert decimal to string given base and length"
	c = 0
	while True:
		ret = str(long(round(var)))
		if len(ret) <= width:
			break
		var = var / base
		c = c + 1
	else:
		c = -1
	return ret, c

def fchg(var, width, base):
	"Convert float to string given scale and length"
	c = 0
	while True:
		if var == 0:
			ret = str('0')
			break
		ret = str(long(round(var, width)))
		if len(ret) <= width:
			i = width - len(ret) - 1
			while i > 0:
				ret = ('%%.%df' % i) % var
				if len(ret) <= width and ret != str(long(round(var, width))):
					break
				i = i - 1
			else:
				ret = str(long(round(var)))
			break
		var = var / base
		c = c + 1
	else:
		c = -1
	return ret, c

def cprintlist(varlist, type, width, scale):
	"Return all columns color printed"
	ret = sep = ''
	for var in varlist:
		ret = ret + sep + cprint(var, type, width, scale)
		sep = ' '
	return ret

def cprint(var, type = 'f', width = 4, scale = 1000):
	"Color print one column"

	base = 1000
	if scale == 1024:
		base = 1024

	### Use units when base is exact 1000 or 1024
	unit = False
	if scale in (1000, 1024) and width >= len(str(base)):
		unit = True
		width = width - 1

	if base == 1024:
		units = ('B', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y')
	else:
		units = (' ', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y')

	colors = theme['colors_lo']

	### Convert value to string given base and field-length
	if type in ('d', 'p'):
		ret, c = dchg(var, width, base)
	elif type in ('f'):
		ret, c = fchg(var, width, base)
	elif type in ('s'):
		ret, c = str(var), colors[0]
	elif type in ('t'):
		ret, c = '%2dh%02d' % (var / 60, var % 60), colors[0]
	else:
		raise Exception, 'Type %s not known to dstat.' % type

	### Set the counter color
	if scale <= 0:
		color = colors[0]
	elif scale not in (1000, 1024):
		color = colors[int(var/scale)%len(colors)]
	elif type in ('p'):
		color = colors[int(round(var)/scale)%len(colors)]
	elif type in ('d', 'f'):
		color = colors[c%len(colors)]
	else:
		color = ctext

	### Justify value to left if string
	if type in ('s',):
		ret = color + ret.ljust(width)
	else:
		ret = color + ret.rjust(width)

	### Add unit to output
	if unit:
		if c != -1 and round(var) != 0:
			ret += units[c]
		else:
			ret += ' '

	return ret

def header(totlist, vislist):
	line = ''
	### Process title
	for o in vislist:
		line += o.title()
		if o is not vislist[-1]:
			line += char['space']
		elif totlist != vislist:
			line += char['gt']
	line += '\n'
	### Process subtitle
	for o in vislist:
		line += o.subtitle()
		if o is not vislist[-1]:
			line += char['pipe']
		elif totlist != vislist:
			line += char['gt']
	return line + '\n'

def csvheader(totlist):
	line = ''
	### Process title
	for o in totlist:
		line = line + o.csvtitle()
		if o is not totlist[-1]:
			line = line + ','
	line += '\n'
	### Process subtitle
	for o in totlist:
		line = line + o.csvsubtitle()
		if o is not totlist[-1]:
			line = line + ','
	return line + '\n'

def info(level, str):
	"Output info message"
	print >>sys.stderr, str

def die(ret, str):
	"Print error and exit with errorcode"
	print >>sys.stderr, str
	exit(ret)

def initterm():
	"Initialise terminal"
	global termsize

	try:
		global fcntl, struct, termios
		import fcntl, struct, termios
		termios.TIOCGWINSZ
	except:
		try:
			curses.setupterm()
			curses.tigetnum('lines'), curses.tigetnum('cols')
		except:
			pass
		else:
			termsize = None, 2
	else:
		termsize = None, 1

def gettermsize():
	"Return the dynamic terminal geometry"
	global termsize

	if not termsize[0]:
		try:
			if termsize[1] == 1:
				s = struct.pack('HHHH', 0, 0, 0, 0)
				x = fcntl.ioctl(sys.stdout.fileno(), termios.TIOCGWINSZ, s)
				return struct.unpack('HHHH', x)[:2]
			elif termsize[1] == 2:
				curses.setupterm()
				return curses.tigetnum('lines'), curses.tigetnum('cols')
			else:
				termsize = (int(os.environ['LINES']), int(os.environ['COLUMNS']))
		except:
			termsize = 25, 80
	return termsize

def gettermcolor(color=True):
	if color and sys.stdout.isatty():
		try:
			import curses
			curses.setupterm()
			if curses.tigetnum('colors') < 0:
				return False
		except:
			print >>sys.stderr, 'Color support is disabled, python-curses is not installed.'
			return False
	return color

### We only want to filter out paths, not ksoftirqd/1
def basename(name):
	if name[0] in ('/', '.'):
		return os.path.basename(name)
	return name

def getnamebypid(pid, name):
	ret = None
	try:
		cmdline = open('/proc/%s/cmdline' % pid).read().split('\0')
		ret = basename(cmdline[0])
		if ret in ('bash', 'csh', 'ksh', 'perl', 'python', 'ruby', 'sh'):
			ret = basename(cmdline[1])
		if ret.startswith('-'):
			ret = basename(cmdline[-2])
			if ret.startswith('-'): raise
		if not ret: raise
	except:
		ret = basename(name)
	return ret

def getcpunr():
	"Return the number of CPUs in the system"
	cpunr = -1
	for line in dopen('/proc/stat').readlines():
		if line[0:3] == 'cpu':
			cpunr = cpunr + 1
	if cpunr < 0:
		raise "Problem finding number of CPUs in system."
	return cpunr

### FIXME: Add scsi support too and improve
def sysfs_dev(device):
	"Convert sysfs device names into device names"
	m = re.match('ide/host([0-9])/bus([0-9])/target([0-9])/lun([0-9])/disc', device)
	if m:
		l = m.groups()
		# ide/host0/bus0/target0/lun0/disc -> 0 -> hda
		# ide/host0/bus1/target0/lun0/disc -> 2 -> hdc
		nr = int(l[1]) * 2 + int(l[3])
		return 'hd' + chr(ord('a') + nr)
	m = re.match('placeholder', device)
	if m:
		return 'sdX'
	return device

def main():
	global pagesize, cpunr, hz, theme, outputfile
	global totlist, inittime
	global update

	pagesize = resource.getpagesize()
	cpunr = getcpunr()
	hz = os.sysconf('SC_CLK_TCK')
	interval = 1

	user = getpass.getuser()
	hostname = os.uname()[1]

	### Disable line-wrapping (does not work ?)
	sys.stdout.write('\033[7l')

	### Write term-title
	if sys.stdout.isatty():
		shell = os.getenv('XTERM_SHELL')
		term = os.getenv('TERM')
		if shell == '/bin/bash' and term and re.compile('(screen*|xterm*)').match(term):
			sys.stdout.write('\033]0;(%s@%s) %s %s\007' % (user, hostname, os.path.basename(sys.argv[0]), ' '.join(op.args)))

	### Prepare CSV output file
	if op.output:
		if os.path.exists(op.output):
			outputfile = open(op.output, 'a', 0)
			outputfile.write('\n\n')
		else:
			outputfile = open(op.output, 'w', 0)
			outputfile.write('"Dstat %s CSV output"\n' % VERSION)
			outputfile.write('"Author:","Dag Wieers <dag@wieers.com>",,,,"URL:","http://dag.wieers.com/home-made/dstat/"\n')

		outputfile.write('"Host:","%s",,,,"User:","%s"\n' % (hostname, user))
		outputfile.write('"Cmdline:","dstat %s",,,,"Date:","%s"\n\n' % (' '.join(op.args), time.strftime('%d %b %Y %H:%M:%S %Z', time.localtime())))

	### Build list of requested plugins
	linewidth = 0
	totlist = []
	for mod in (dstat_cpu(), dstat_top_cpu(), dstat_mem(), dstat_top_mem(), dstat_io(), dstat_top_bio(), dstat_freespace()):
		mod.check()
		mod.prepare()
		linewidth = linewidth + mod.statwidth() + 1
		totlist.append(mod)

	if not totlist:
		die(8, 'None of the stats you selected are available.')

	if op.output:
		outputfile.write(csvheader(totlist))

	scheduler = sched.scheduler(time.time, time.sleep)
	inittime = time.time()

	update = 0

	### Let the games begin
	while True:
		scheduler.enterabs(inittime + update, 1, perform, (update,))
		scheduler.run()
		sys.stdout.flush()
		update += interval

def perform(update):
	global totlist, oldvislist, vislist, showheader, rows, cols
	global elapsed, totaltime, starttime
	global loop, step

	starttime = time.time()

	loop = (update - 1 + op.delay) / op.delay
	step = ((update - 1) % op.delay) + 1

	### Get current time (may be different from schedule) for debugging
	curwidth = 0

	### Initialise certain variables
	if loop == 0:
		elapsed = ticks()
		rows, cols = 0, 0
		vislist = []
		oldvislist = []
		showheader = True
	else:
		elapsed = step

	vislist = totlist

	### The first step is to show the definitive line if necessary
	newline = '\r'

	### Display header
	if showheader:
		if loop == 0 and totlist != vislist:
			print >>sys.stderr, 'Terminal width too small, trimming output.'
		showheader = False
		sys.stdout.write(newline)
		newline = header(totlist, vislist)

	### Calculate all objects (visible, invisible)
	line = newline
	oline = ''
	for o in totlist:
		o.extract()
		if o in vislist:
			line = line + o.show() + o.showend(totlist, vislist)
		if op.output and step == op.delay:
			oline = oline + o.showcsv() + o.showcsvend(totlist, vislist)

	### Print stats
	sys.stdout.write(line)
	if op.output and step == op.delay:
		outputfile.write(oline + '\n')

### Main entrance
try:
	initterm()
	main()
except KeyboardInterrupt, e:
	sys.stdout.write(theme['default'])
