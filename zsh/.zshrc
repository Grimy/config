#!zshrc
# Basic configuration and options
emulate sh
setopt no_auto_remove_slash
setopt interactive_comments no_ignore_braces bang_hist equals
setopt no_unset null_glob glob_dots
setopt no_clobber no_rm_star_silent
setopt chase_links auto_cd auto_pushd pushd_silent pushd_to_home
setopt hist_ignore_all_dups hist_reduce_blanks
setopt prompt_subst prompt_percent

emulate zsh -c 'setopt glob_dots; autoload -Uz compinit' && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

LISTMAX=0
WORDCHARS=.+-~_
HISTSIZE=65535
SAVEHIST="$HISTSIZE"
HISTFILE="$ZDOTDIR/history"
mail='$(mail -e 2>&- && printf "\e[33mYou got mail! ")'
PROMPT="%(???%F{red}(%?%) )$mail%f%T %(##%F{red}%m #%F{green})%~%f> "
format='%C(bold yellow)%h %Creset%Cblue%aN, %ad%Cgreen%d%Creset %<(80,trunc)%s'

# Keybindings
zlebind() { autoload -Uz "$2"; zle -N "$2"; bindkey "$@"; }
bindkey -e
bindkey '^I' complete-word
bindkey '^U' vi-kill-line
zlebind '^[[A' up-line-or-beginning-search
zlebind '^[[B' down-line-or-beginning-search
bindkey '^[[F' end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[1;5A' insert-last-word
bindkey '^[[1;5B' POPD
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~'   delete-char
bindkey '^[[3;5~' delete-word

POPD() { popd; zle reset-prompt; }
zle -N POPD

# Environment
export XDG_CONFIG_HOME="$HOME/config"
export XDG_CACHE_HOME="$HOME/data"
export XDG_DATA_HOME="$HOME/data"

export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_COLLATE=C
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export RUST_BACKTRACE=1
export FZF_DEFAULT_COMMAND='ag -l -g ""'
export PATH="$HOME/bin:$XDG_CONFIG_HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/bin/site_perl"

export CARGO_HOME="$XDG_CACHE_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export EDITOR="vim -Nu $XDG_CONFIG_HOME/vim/init.vim"
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/Gimp"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export LESSHISTFILE=-
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql"
export PYLINTHOME="$XDG_CONFIG_HOME/pylint"
export PYLINTRC="$PYLINTHOME/pylintrc"
export RLWRAP_HOME="$XDG_CACHE_HOME/rlwrap"
export VIMPERATOR_INIT=":source $XDG_CONFIG_HOME/vimperator/init"
export VIMPERATOR_RUNTIME="$XDG_CONFIG_HOME/vimperator"
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nv"

# Aliases
alias abort='git merge --abort||git rebase --abort||git cherry-pick --abort'
alias add='git add'
alias ag='ag -t'
alias amend='git commit -v --amend --no-edit'
alias bisect='git bisect'
alias branch='git branch -f'
alias cherry='git cherry-pick'
alias clean='git clean -diX'
alias clone='git clone --recursive'
alias clop='feh -FZ ~/p0'
alias co='git checkout'
alias commit='git commit -v'
alias cp='cp -i'
alias cpan='sudo -E perl -MCPAN -e'
alias crontab='v /var/spool/cron/$USER'
alias dow='watch -n1 -d "ls -sh ~/Downloads/*.part"'
alias f='find . -name'
alias feh='feh -FZ --no-fehbg'
alias gpg='rlwrap gpg2 --expert'
alias gs='rlwrap gs'
alias hcf='sudo shutdown -h 0'
alias l='ls -phAl --color=auto'
alias ll='ls -phAl --color=auto'
alias mv='mv -i'
alias ple='perl -ple'
alias push='git push'
alias pushf='git push --force-with-lease'
alias rainbow='echo -e \\033[{3,9}{o\\n,{0,1,2,3,4,5,6,7}moO0o}'
alias reflog='git reflog'
alias remote='git remote -v'
alias s='git status'
alias show='git show'
alias startx='xinit "$XDG_CONFIG_HOME/xinitrc" -- =X :0 vt1 -keeptty -nolisten tcp'
alias stash='git stash'
alias stats='git show --oneline --stat'
alias unstage='git reset -q HEAD --'
alias updatedb='sudo updatedb'
alias yay='ponysay -f Fluttershy yay'

cb()     { git rev-parse --abbrev-ref HEAD; }
del()    { git branch -D "$@" || git tag -d "$@"; }
diff()   { git diff --patience "$@"; }
fetch()  { git fetch --prune "${@---all}"; }
ff()     { git merge --ff-only "${@-origin/$(cb)}"; }
fuck()   { git reset --hard "${@-HEAD}"; }
g()      { git log --graph --topo-order --date=short --pretty=format:"$format" "${@:---all}"; }
hoc()    { git log --format= --shortstat | perl -040pe '$\+=$_}{'; }
man()    { command man -w "${@:?}" >/dev/null && $EDITOR -c "Man $*"; }
merge()  { git merge --no-ff "$@" && git branch -d "$@"; }
p()      { perf stat -d -e{task-clock,page-faults,cycles,instructions,branch,branch-misses} "$@"; }
pull()   { fetch "${@-origin}" && ff; }
rebase() { git rebase "${@:-origin/$(cb)}"; }
sloc()   { git diff --stat 4b825dc642cb6eb9a060e54bf8d69288fbee4904 "${1-HEAD}"; }
tag()    { git tag ${1+-f} "$@"; }
twitch() { livestreamer http://www.twitch.tv/"${1#*tv/}" "${2-best}"; }
v()      { [ "${*#-}" = "${1-X}" ] && set -- "+O $1"; $EDITOR -O "$@"; }
wtf()    { git commit -m "$(curl -s http://whatthecommit.com | perl -p0e '($_)=m{<p>(.+?)</p>}s')" "$@"; }
x()      { atool -x "$@" && rm "$@"; }
