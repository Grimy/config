# Basic configuration and options
setopt chase_links autocd autopushd pushdsilent pushdtohome
setopt noclobber
setopt null_glob globdots
setopt hist_ignore_all_dups hist_reduce_blanks
setopt interactivecomments
setopt prompt_subst prompt_percent
autoload compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

LISTMAX=0
WORDCHARS=.+-~_
HISTSIZE=65535
SAVEHIST="$HISTSIZE"
HISTFILE="$ZDOTDIR/history"
mail='$(mail -e 2>&- && printf "\e[33mYou’ve got mail! ")'
PROMPT="%(???%F{red}(%?%) )$mail%f%T %(##%F{red}%m #%F{green})%~%f> "

# Keybindings
zlebind() { autoload "$2"; zle -N "$2"; bindkey "$@"; }
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
export TERM=xterm-256color
export LANG=en_US.UTF-8
export EDITOR=nvim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export RUST_BACKTRACE=1
export FZF_DEFAULT_COMMAND='ag -l -g ""'
export PATH="$HOME/bin:$XDG_CONFIG_HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin"

export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql"
export CARGO_HOME="$XDG_CACHE_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/Gimp"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export LESSHISTFILE=-
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export PENTADACTYL_INIT=":source $XDG_CONFIG_HOME/pentadactyl/init"
export PENTADACTYL_RUNTIME="$XDG_CONFIG_HOME/pentadactyl"
export PYLINTHOME="$XDG_CONFIG_HOME/pylint"
export PYLINTRC="$PYLINTHOME/pylintrc"
export RLWRAP_HOME="$XDG_CACHE_HOME/rlwrap"
#export XAUTHORITY="$XDG_RUNTIME_DIR"/X11/xauthority
#export XINITRC="$XDG_CONFIG_HOME/xinitrc"
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nv"

# Plugin config
# source "$XDG_CONFIG_HOME/zsh/highlighting/zsh-syntax-highlighting.zsh"

# Aliases
alias :q='exit'
alias add='git add'
alias amend='git commit -v --amend --no-edit'
alias bisect='git bisect'
alias branch='git branch -f'
alias cherry='git cherry-pick'
alias clean='git clean -dfX'
alias clone='git clone --recursive'
alias clop='feh ~/p0'
alias co='git checkout'
alias commit='git commit -v'
alias conf='cd ~/.config'
alias cp='/bin/cp -i'
alias cpan='sudo perl -MCPAN -e'
alias crontab='nvim /var/spool/cron/$USER'
alias diff='git diff --patience'
alias dnf='sudo dnf'
alias dnfy='sudo dnf install -y'
alias dow='watch -n1 -d "ls -sh ~/Downloads/*.part"'
alias f='find . -name'
alias fzf='/usr/bin/ruby ~/.nvim/bundle/fzf/fzf'
alias gpg='rlwrap gpg2 --expert'
alias gs='rlwrap gs'
alias gsql='ssh gerrit gerrit gsql'
alias hcf='sudo shutdown -h 0'
alias k='k -A'
alias l='ls -GAhl --color=auto'
alias ll='ls -GAhl --color=auto'
alias mv='/bin/mv -i'
alias push='git push'
alias pushf='git push --force-with-lease'
alias rainbow='echo -e "\033["{,1}\;3{0,1,2,3,4,5,6,7}moOOo'
alias reflog='git reflog'
alias remote='git remote -v'
alias s='git status'
alias show='git show'
alias stash='git stash'
alias stats='git show --oneline --stat'
alias tab='gvim --remote-tab-silent'
alias updatedb='sudo updatedb'
alias v="nvim -O"
alias vim="nvim -O"
alias yay='ponysay -f Fluttershy yay'
cb()     { git rev-parse --abbrev-ref HEAD; }
del()    { git branch -D "$@" || git tag -d "$@"; }
fes()    { git submodule foreach "git $* &"; }
fetch()  { git fetch --prune "${@---all}"; }
ff()     { git merge --ff-only "${@-origin/$(cb)}"; }
fuck()   { [ -f "${@##* }" ] && git checkout "$@" || git reset --hard "$@"; }
man()    { command man -w "${@:?}" >&- && nvim +"Man $*"; }
merge()  { git merge --no-ff "$@" && git branch -d "$@"; }
p()      { perf stat -d -e{task-clock,page-faults,cycles,instructions,branch,branch-misses} "$@"; }
pull()   { fetch "${@-origin}" && ff "${@-origin}/$(cb)"; }
rebase() { git rebase "${@-origin/$(cb)}"; }
tag()    { git tag ${@:+-f} "$@"; }
wtf()    { curl -s http://whatthecommit.com | perl -p0e '($_)=m{<p>(.+?)</p>}s'; }
x()      { atool -x "$@" && rm "$@"; }
