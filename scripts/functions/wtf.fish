function wtf
	git commit -am (curl -s http://whatthecommit.com | perl -p0e '($_)=m{<p>(.+?)</p>}s')
end
