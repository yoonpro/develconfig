#!/bin/zsh
#

# Zsh funciton
#
precmd () {
if [[ "$TERM" = "screen" || "$TERM" = "xterm-color" ]]; then
local SHORTPWD="`basename $PWD`"
local HOMEDIR="`basename $HOME`"
if [[ "${SHORTPWD}" = "${HOMEDIR}" ]]; then
SHORTPWD="~"
fi
if [[ -n "$TMUX" ]]; then
tmux setenv TMUXPWD_$(tmux display -p "#I") $PWD
fi
echo -ne "\ek${SHORTPWD}/\e\\"
fi
}
preexec () {
if [[ "$TERM" = "screen" || "$TERM" = "xterm-color" ]]; then
local CMD="${1}"
if [[ "${${(z)CMD}[1]}" = "vi" ]]; then
CMD="${${(z)CMD}[2]}"
fi
if [[ ${#CMD} -ge 20 ]]; then
CMD="${${(z)CMD}[1]}${${(z)CMD}[2]}${${(z)CMD}[3]} _"
fi
echo -ne "\ek${CMD}\e\\"
fi
}

_greps () {
if [[ "${2}" = "" ]]; then
    echo "gr pattern file"
else
    echo "find . -name \"${2}\" -exec grep --color=auto -nH${3} \"${1}\" {} \;"
    eval "find . -name \"${2}\" -exec grep --color=auto -nH${3} \"${1}\" {} \;"
fi
}

greps () {
if [[ "${1}" = "i" ]]; then
    _greps ${2} ${3} ${1}
else
    _greps ${1} ${2}
fi
}

seds () {
if [[ "${3}" = "" ]]; then
    echo "se org dst file"
else
    eval "find . -name \"${3}\" -exec sed -i 's/${1}/${2}/g' {} \;"
fi
}

slog () {
if [[ "${1}" = "" ]]; then
    echo "slog number [file]"
elif [[ "${2}" = "" ]]; then
    DATE=`date +%F --date "${1} days ago"`
    svn log -r HEAD:{$DATE} -v
else
    DATE=`date +%F --date "${1} days ago"`
    svn log -r HEAD:{$DATE} -v ${2}
fi
}

mytail() {
if [[ "${1}" = "-F" ]]; then
    echo "tail ${1} ${2} | awk -f ~/develconfig/colorawk"
    tail ${1} ${2} | awk -f ~/develconfig/colorawk
else
    echo "tail -F ${1} | awk -f ~/develconfig/colorawk"
    tail -F ${1} | awk -f ~/develconfig/colorawk
fi
}

ps-right-toggle () {
    if [[ "${PS_RIGHT}" = "detail" ]]; then
        export PS_RIGHT="compact"
    elif [[ "${PS_RIGHT}" = "compact" ]]; then
        export PS_RIGHT="noinfo"
    else
        export PS_RIGHT="detail"
    fi
}

zle -N ps-right-toggle

# Default rc loading
#
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi

# Zsh environment
#
HISTSIZE=100000
SAVEHIST=10000
HISTFILE=~/.zsh/history
setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_no_store
setopt hist_no_functions
setopt no_hist_beep
setopt hist_save_no_dups
bindkey "^[[24~" 'ps-right-toggle'


# Alias
#
alias gr='noglob greps'
alias gri='noglob greps i'
alias se='noglob seds'
alias vi='vim -T xterm-color -u ~/.vimrc'
alias history='history -i -1000'
alias slog='slog'
alias cpanplus='perl -MCPAN -eshell'
alias ctail='noglob mytail'
alias cscope="cd ~/xcat;ctags --sort=foldcase --regex-perl='/^[ \t]*method[ \t]+([^\ \t;\(]+)/\1/m,method,methods/' -R ~/xcat;cd -"

# Bind
#
if [ -d ~/.oh-my-zsh ]; then
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
alias c=z
fi

# export
#
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib64:/lib:/usr/lib64:/usr/lib:/usr/local/lib64:/usr/local/lib:/usr/X11R6/lib64:/usr/X11R6/lib

export LEIN_ROOT=1
export ERLANG=/opt/erlang/bin
export HEROKU=/usr/local/heroku/bin
export GIT_SSL_NO_VERIFY=true
export TERM=xterm-color
export PS_RIGHT=detail # detail / compact / noinfo

PATH=.:$PATH:/bin:/usr/bin:/usr/local/bin:$HOME:$ERLANG:$CLOJURE:$HEROKU
export PATH

export SVNEDITOR=vi

if [[ "$PWD" =~ "^\/root$" || "$PWD" =~ "^$HOME$" ]]; then
    cd ~
fi

if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi

