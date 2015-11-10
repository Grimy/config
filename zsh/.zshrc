# Basic configuration and options
setopt chase_links autocd autopushd pushdsilent pushdtohome
setopt noclobber
setopt null_glob globdots
setopt hist_ignore_all_dups hist_reduce_blanks
setopt interactivecomments
setopt prompt_subst prompt_percent
autoload compinit && compinit
setopt menu_complete
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

LISTMAX=0
WORDCHARS=.+-~_
HISTSIZE=65535
SAVEHIST="$HISTSIZE"
MAIL='$(mail -e 2>/dev/null && printf "\e[33mYou’ve got mail! ")'
PROMPT="%(???%F{red}(%?%) )$MAIL%f%T %(##%F{red}%m:#%F{green})%~%f%% "

# Keybindings
bindkey -e
bindkey '^I' complete-word
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
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

export XDG_CACHE_HOME="$HOME/.cache"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql"
export CARGO_HOME="$XDG_CACHE_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export LESSHISTFILE=-
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export PENTADACTYL_INIT=":source $PENTADACTYL_RUNTIME/init"
export PENTADACTYL_RUNTIME="$XDG_CONFIG_HOME/pentadactyl"
#export XAUTHORITY="$XDG_RUNTIME_DIR"/X11/xauthority
#export XINITRC="$XDG_CONFIG_HOME/xinitrc"
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nv"

# Plugin config
source "$XDG_CONFIG_HOME/zsh/highlighting/zsh-syntax-highlighting.zsh"
source "$XDG_CONFIG_HOME/zsh/autosuggestions/autosuggestions.zsh"
AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1
zle-line-init() { zle autosuggest-start }
zle -N zle-line-init

# Aliases
alias :q='exit'
alias add='git add'
alias amend='git commit -v --amend --no-edit'
alias bisect='git bisect'
alias branch='git branch -f'
alias conf='cd ~/.config'
alias cherry='git cherry-pick'
alias clean='git clean -dfX'
alias clone='git clone --recursive'
alias clop='feh ~/p0'
alias commit='git commit -v'
alias cp='/bin/cp -i'
alias cpan='sudo perl -MCPAN -e'
alias diff='git diff --patience'
alias dnf='sudo dnf'
alias dnfy='sudo dnf install -y'
alias f='find . -name'
alias fzf='/usr/bin/ruby ~/.nvim/bundle/fzf/fzf'
alias gpg='rlwrap gpg2 --expert'
alias gs='rlwrap gs'
alias gsql='ssh gerrit gerrit gsql'
alias k='k -A'
alias l='ls -GAhl --color=auto'
alias ll='ls -GAhl --color=auto'
alias mv='/bin/mv -i'
alias push='git push'
alias pushf='git push --force-with-lease'
alias reflog='git reflog'
alias remote='git remote -v'
alias s='git status'
alias show='git show'
alias stash='git stash'
alias stats='git show --oneline --stat'
alias tab='gvim --remote-tab-silent'
alias tag='git tag -f'
alias v="nvim -O"
alias vim="nvim -O"
alias yay='ponysay -f Fluttershy yay'
