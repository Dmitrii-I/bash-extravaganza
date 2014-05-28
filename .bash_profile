# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
bind TAB:menu-complete # this allows you to cycle through autocompletion options

export PS1="\[\e[00;35m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[00;35m\]\H\[\e[0m\]\[\e[00;37m\]:\[\e[0m\]\[\e[00;36m\]\w\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]"


alias ll='ls -alh --color=auto'
