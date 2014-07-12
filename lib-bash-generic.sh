#!/bin/bash

# Bash library containing generic functions


timestamp() {
	date +"%Y-%m-%d %H:%M:%S.%N"
}

is_login_shell() {
	if shopt -q login_shell; then echo TRUE
	else echo FALSE; fi
}

is_interactive_shell() {
        [ -z "$PS1" ] && echo FALSE || echo TRUE
}

closed_files() {
        # pattern should be between double quotes to prevent too early processing of meta-characters like *
        dir=${1:-.}
        pattern=${2:-*}
        all_files=$(find $dir -maxdepth 1 -type f -name "$pattern")                                                 
        for file in $all_files; do
                num_file_handles=$(lsof -f -- $file | wc -l)
                if [ $num_file_handles -lt 1 ]; then echo $file; fi
        done
}
