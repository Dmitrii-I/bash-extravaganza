#!/bin/bash

# Environment variables set by this script are prepended with _LBG_ to avoid
# potentially overwriting existent ones.


numcols() {
    # Returns number of columns/fields in a tab-delimited file and the number of lines
    # with that particular number of columns.
    file="$1"
    awk '{print gsub(/\t/, "")}' $file | sort | uniq -c
}


traffic_tic() {
    # set the environment variables _LBG_RX_BYTES and _LBG_TX_BYTES
    # Arguments: optional, network device, defaults to eth0
    _LBG_NET_DEVICE=${@:-"eth0"}
    _LBG_RX_BYTES_TIC=$(cat /sys/class/net/"$_LBG_NET_DEVICE"/statistics/rx_bytes)
    _LBG_TX_BYTES_TIC=$(cat /sys/class/net/"$_LBG_NET_DEVICE"/statistics/tx_bytes)
}


traffic_toc() {
    # Print MB sent and received since last call to traffic_tic
    _LBG_RX_BYTES_TOC=$(cat /sys/class/net/"$_LBG_NET_DEVICE"/statistics/rx_bytes)
    _LBG_TX_BYTES_TOC=$(cat /sys/class/net/"$_LBG_NET_DEVICE"/statistics/tx_bytes)

    mb_sent=$(echo "($_LBG_TX_BYTES_TOC - $_LBG_TX_BYTES_TIC) / 1024^2" | bc)
    mb_received=$(echo "($_LBG_RX_BYTES_TOC - $_LBG_RX_BYTES_TIC) / 1024^2" | bc)
    
    echo "MB sent: $mb_sent; MB recieved: $mb_received"
}


dec2hex() {
    # Convert decimal integer to hexadecimal integer
    # Prepend 0 to achieve minimum fields width of 2 characters
    decimal_integer="$1"
    printf "%.2x\n" $decimal_integer
}


detect_broken_symlinks() {
    # Detect broken symlinks, recursing into directories
    # Arguments: a directory

    dir="$@"
    # Exit function if no directory supplied
    [ "$#" -lt 1 ] && { echo "Please supply a directory"; return; }

    for f in $(find "$dir" -type l); do 
        [ ! -e "$f" ]  && echo Broken symlink: "$f" || echo "OK $f"
    done
}


date_yesterday() {
    # This function returns yesterday's date, e.g. 2015-04-01 on 2015-04-02
    # All arguments (optional), are interpreted as format specification for date
    date_format=${@:-"%Y-%m-%d"}
    date -d "$(date +%Y-%m-%d) - 1 day" +$date_format
}


dates_sequence() {
    # Generate a sequence of dates, separated by space, starting with date_from
    # and ending with date_until (so date_until is inclusive).
    # Usage: dates_sequence <date_from> <date_until> [<date_format>] 
    # Arguments:
    # date_from     first date of the sequence
    # date_until    last date of the sequence
    # date_format   optional format string for the date, suitable for
    #               input to `date`. Default is %Y-%m-%d
    #
    # Usage: 
    # dates_sequence 2014-01-01 2014-02-13
    # dates_sequence 2014-01-01 2014-02-13 %Y %m %d
    # dates_sequence 2014-01-01 2014-02-13 "%Y %m %d"

    # For convenience, the dates within this function are in
    # integer format %Y%m%d
    date_from=$(date -d "$1" +%Y%m%d)
    date_until=$(date -d "$2" +%Y%m%d)

    shift
    shift
    date_format=${@:-"%Y-%m-%d"}

    if [ $date_until -ge $date_from ]; then
        date -d "$date_from" +"$date_format"
        while [ $date_from != $date_until ]; do 
            date_from=$(date -d "$date_from + 1 day" +%Y%m%d)
            date -d "$date_from" +"$date_format"
        done
    fi
}


timestamp() {
	date +"%Y-%m-%d %H:%M:%S.%N"
}


is_file_open() {
    # Returns 0 if file is open; 1 in all other cases
    # Arguments: full file path, no tildes
    #
    # As we are using `lsof` to determine whether file is open, we have these 3 cases:
    # 1. `lsof` exit code: 0 and output to stdout
    # 2. `lsof` exit code: 1 and no output to stdout
    # 3. `lsof` exit code: 1 and output to stderr
    # Case 1 occurs when file is open. Case 2 occurs when file exists and is not open.
    # Case 3 occurs when something went wrong and `lsof` failed.
    # In this function we want to return 0 only if case 1 occured, and return 1 if
    # case 2 or case 3 occurred.

    file_path="$1"
    lsof_output=$(lsof -f -- $file_path 2>&1)
    exit_code_lsof=$?
    
    if [ $exit_code_lsof -eq 0 ]; then
        return 0
    else
        return 1
    fi
}


is_file_closed() {
    # Returns 0 if file is closed; 1 in all other cases
    # Arguments: full file path, no tildes
    #
    # As we are using `lsof` to determine whether file is open, we have these 3 cases:
    # 1. `lsof` exit code: 0 and output to stdout
    # 2. `lsof` exit code: 1 and no output to stdout
    # 3. `lsof` exit code: 1 and output to stderr
    # Case 1 occurs when file is open. Case 2 occurs when file exists and is not open.
    # Case 3 occurs when something went wrong and `lsof` failed.
    # In this function we want to return 0 only if case 2 occured, and 1 if
    # case 1 or case 3 occurred.

    file_path="$1"
    lsof_output=$(lsof -f -- $file_path 2>&1)
    exit_code_lsof=$?
    
    if [ $exit_code_lsof -eq 0 ]; then
        return 1
    else
        if [ -z "$lsof_output" ]; then
            return 0;
        else
            return 1;
        fi
    fi
}


is_login_shell() {
	if shopt -q login_shell; then return 0; else return 1; fi
}


is_empty() {
        # Returns true if its one and only argument is empty
        # Example usage: x=""; if is_empty $x; then echo empty; else echo not empty; fi
        [ -z "$1" ] && return 0 || return 1
}


is_interactive_shell() {
        [ -z "$PS1" ] && return 1 || return 0
}


closed_files() {
        # pattern should be between double quotes to prevent too early processing of meta-characters like *
        dir=${1:-.}
        pattern=${2:-*}
        all_files=$(find $dir -maxdepth 1 -type f -name "$pattern")

        # If there are no matched files, exit successfully, otherwise proceed
        [ -z "$all_files" ] && return 0 || all_files=$(echo "$all_files" | xargs -L1 basename)
        for file in $all_files; do
                num_file_handles=$(lsof -f -- $dir/$file | wc -l)
		if [ $num_file_handles -lt 1 ]; then echo $file; fi
        done
}


download_files() {
        while read -t 3 line; do
                scp -C "$line" .
        done
}


append() {
        postfix="$1"
        while read -t 3 line; do
                echo "$line$postfix"
        done
}


prepend() {
        prefix="$1"
        while read -t 3 line; do
                echo "${prefix}${line}"
        done
}


s() {
        # This function sources this script
        source ~/bash-scripts/lib-bash-generic.sh
}


write_log() {
        # This function reads global variables $LOG, $SCRIPT_NAME,
        # and $@ (all the arguments passed to it). It then 
        # constructs a tab-delimited one-line message and appends
        # it to $LOG.
        ts=$(timestamp)
        logmsg="$ts\tINFO\t$SCRIPT_NAME\t$@\n"
        echo -ne "$logmsg" >> $LOG
}
