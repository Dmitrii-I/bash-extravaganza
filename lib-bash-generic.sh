#!/bin/bash

# Bash library containing generic functions


timestamp() {
	date +"%Y-%m-%d %H:%M:%S.%N"
}

is_login_shell() {
	if shopt -q login_shell; then return 0; else return 1; fi
}

is_interactive_shell() {
        [ -z "$PS1" ] && return 1 || return 0
}

closed_files() {
        # pattern should be between double quotes to prevent too early processing of meta-characters like *
        dir=${1:-.}
        pattern=${2:-*}
        all_files=$(find $dir -maxdepth 1 -type f -print -name "$pattern" | xargs -L1 readlink -f)                                                 
        for file in $all_files; do
                num_file_handles=$(lsof -f -- $file | wc -l)
                if [ $num_file_handles -lt 1 ]; then echo $file; fi
        done
}

download_files() {
        while read -t 3 line; do
                echo "$line"
                scp -C "$line" .
        done
}


prepend() {
        prefix="$1"
        while read -t 3 line; do
                echo "${prefix}${line}"
        done
}

s() {
        source ~/bash-scripts/lib-bash-generic.sh
}
