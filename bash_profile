# .bash_profile is loaded for login shells only

if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi



# this allows you to cycle through autocompletion instead of typing
bind TAB:menu-complete 

# set custom bash prompt
export PS1="\[\e[00;35m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[00;35m\]\H\[\e[0m\]\[\e[00;37m\]:\[\e[0m\]\[\e[00;36m\]\w\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]"


alias ll='ls -alh --color=auto'

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH


export TERM=xterm-256color
eval `dircolors ~/dircolors-solarized/dircolors.ansi-dark`

source ~/bash-scripts/libbash-generic.sh

# easier grepping through processes
function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; } 

