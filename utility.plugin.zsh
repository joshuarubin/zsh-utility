#
# Defines general aliases and functions.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Suraj N. Kurapati <sunaku@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Correct commands.
setopt CORRECT

#
# Aliases
#

# Disable correction.
alias ack='nocorrect ack'
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias ebuild='nocorrect ebuild'
alias gcc='nocorrect gcc'
alias gist='nocorrect gist'
alias grep='nocorrect grep'
alias heroku='nocorrect heroku'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias mysql='nocorrect mysql'
alias rm='nocorrect rm'
alias grunt='nocorrect grunt'

# Disable globbing.
alias bower='noglob bower'
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rake='noglob rake'
alias rsync='noglob rsync'

# Define general aliases.
#alias sudo='sudo '
alias _='sudo '
alias b='${(z)BROWSER}'
alias cp="${aliases[cp]:-cp} -i"

# alias e='${(z)VISUAL:-${(z)EDITOR}}'
alias ln="${aliases[ln]:-ln} -i"
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias mv="${aliases[mv]:-mv} -i"
alias p='${(z)PAGER}'
alias po='popd'
alias pu='pushd'
#alias rm="${aliases[rm]:-rm} -i"
alias type='type -a'
alias reload!='. ~/.zshrc'
alias gn='geeknote'

alias rg='rg --smart-case'

# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g C='| wc -l'
#alias -g H='| head'
alias -g L="| less"
alias -g N="| /dev/null"
alias -g S='| sort'
alias -g G='| grep' # now you can do: ls foo G something

alias l="ls -lAh"
# alias ll="ls -l"
alias la="ls -A"
alias v="ls -l"
alias c="clear"
alias cdc="cd && clear"
alias screen="screen -T ${TERM}"
alias json="python -mjson.tool"

stty -ixon

# ls
if is-callable 'dircolors'; then
  # GNU Core Utilities
  alias ls='ls --group-directories-first'

  if zstyle -t ':prezto:module:utility:ls' color; then
    if [[ -s "$HOME/.dir_colors" ]]; then
      eval "$(dircolors --sh "$HOME/.dir_colors" 2> /dev/null)"
    else
      eval "$(dircolors --sh 2> /dev/null)"
    fi

    alias ls="${aliases[ls]:-ls} --color=auto"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
else
  # BSD Core Utilities
  if zstyle -t ':prezto:module:utility:ls' color; then
    # Define colors for BSD ls.
    export LSCOLORS='exfxcxdxbxGxDxabagacad'

    # Define colors for the completion system.
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

    alias ls="${aliases[ls]:-ls} -G"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
fi

alias l='ls -1A'         # Lists in one column, hidden files.
# alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'        # Lists sorted by extension (GNU only).
alias lk='ll -Sr'        # Lists sorted by size, largest last.
alias lt='ll -tr'        # Lists sorted by date, most recent last.
alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
alias sl='ls'            # I often screw this up.

# Grep
if zstyle -t ':prezto:module:utility:grep' color; then
  export GREP_COLOR='1;33'            # BSD.
  export GREP_COLORS="mt=$GREP_COLOR" # GNU.

  alias grep="${aliases[grep]:-grep} --color=auto"
fi

# Mac OS X Everywhere
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
  alias listeners='lsof -nPiTCP | grep LISTEN'
  alias tmux='tmux -f ~/.tmux-osx.conf'
elif [[ "$OSTYPE" == cygwin* ]]; then
  alias o='cygstart'
  alias pbcopy='tee > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
else
  alias o='xdg-open'

  if (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif (( $+commands[xsel] )); then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

# File Download
if (( $+commands[curl] )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
  alias get='wget --continue --progress=bar --timestamping'
fi

# Resource Usage
alias df='df -kh'
alias du='du -kh'

if (( $+commands[htop] )); then
  alias top=htop
else
  if [[ "$OSTYPE" == (darwin*|*bsd*) ]]; then
    alias topc='top -o cpu'
    alias topm='top -o vsize'
  else
    alias topc='top -o %CPU'
    alias topm='top -o %MEM'
  fi
fi

# Miscellaneous

# Serves a directory via HTTP.
alias http-serve='python -m SimpleHTTPServer'

#
# Functions
#

# Makes a directory and changes to it.
function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pushes an entry onto the directory stack and lists its contents.
function pushdls {
  builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pops an entry off the directory stack and lists its contents.
function popdls {
  builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Prints columns 1 2 3 ... n.
function slit {
  awk "{ print ${(j:,:):-\$${^@}} }"
}

# Finds files and executes a command on them.
function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Displays user owned processes status.
function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# (f)ind by (n)ame
# usage: fn foo
# to find all files containing 'foo' in the name
function fn {
  ls -d **/*$1*
}

# termtile
if [ -e ~/.termtile/tile.scpt ]; then
  alias ul='osascript ~/.termtile/tile.scpt up left'
  alias ur='osascript ~/.termtile/tile.scpt up right'
  alias dl='osascript ~/.termtile/tile.scpt down left'
  alias dr='osascript ~/.termtile/tile.scpt down right'
  alias ll='osascript ~/.termtile/tile.scpt left'
  alias rr='osascript ~/.termtile/tile.scpt right'
  alias up='osascript ~/.termtile/tile.scpt up'
  alias down='osascript ~/.termtile/tile.scpt down'
  alias big='osascript ~/.termtile/resize.scpt '
  alias cen='osascript ~/.termtile/center.scpt '
  alias max='osascript ~/.termtile/maximize.scpt '
fi

local fdir=$0:A:h/functions
fpath+=$fdir
autoload -Uz $fdir/*(:t)

export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

autoload run-help
HELPDIR=/usr/local/share/zsh/help
