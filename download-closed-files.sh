#!/bin/bash

# This script fetches files from a remote server that are closed. Closed
# is defined as not appearing in the list when lsof command is run.
#
# Arguments: remote host name, directory on the remote host to look in
# and the filename pattern.
#
# Example usage: ./download-closed-files.sh 127.0.0.1 /home/john/data *csv


host="$1"
dir="$2"
pattern="$3"

echo "$dir/$pattern"
files_to_download=$(ssh $host '
        all_files=$(ls -1 '$dir/$pattern')
        for file in $all_files; do
                num_file_handles=$(/usr/sbin/lsof -f -- $file | wc -l)
                if [ $num_file_handles -lt 1 ]; then echo $file; fi
        done
')

echo Going to fetch these files:
echo "$files_to_download"

for file in $files_to_download; do
        scp $host:$file ./
done




