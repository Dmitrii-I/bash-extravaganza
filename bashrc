# .bashrc is loaded for interactive and non-interactive shell (unless you prevent it)
# .bash_profile is loaded for login shells
# we use .bashrc only to ensure that a file is always loaded no matter the shell type

PATH=$PATH:/usr/sbin:$HOME/.local/bin:$HOME/bin
export PATH

source ~/bash-scripts/lib-bash-generic.sh

if is_interactive_shell; then 
        # this allows you to cycle through autocompletion instead of typing
        bind TAB:menu-complete 
        [ -e ~/.bashrc_local_interactive ] && source ~/.bashrc_local_interactive
fi

alias ll='ls -lh --color=auto'

export TERM=xterm-256color
eval `dircolors ~/dircolors-solarized/dircolors.ansi-dark`


# easier grepping through processes
function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; } 


# append history
shopt -s histappend
# enable bash completion in interactive shells
if ! shopt -oq posix; then
 if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# do not store consecutive duplicates
export HISTCONTROL=ignoredups
# keep only unique commands:
#export HISTCONTROL=erasedups
# number of lines to save for a session
export HISTSIZE=999999
# number of most recent lines to keep in history file (default: .bash_hsitory)
export HISTFILESIZE=9999999
# keep history in sync accross all sessions:
#export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"





# load stuff needed on local machine only
source ~/.bashrc_local # this should be on the very last line
