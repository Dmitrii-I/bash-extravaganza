#!/bin/bash


# This script fetches files from remote server that are closed.
# We do not want open files because they may still be written to.

host=$1
files_to_fetch=$(ssh $host '
        all_data_files=$(ls -1 ~/bitstamp-recorder/*bitstamp_data*)
        for file in $all_data_files; do
                num_file_handles=$(/usr/sbin/lsof -f -- $file | wc -l)
                if [ $num_file_handles -lt 1 ]; then echo $file; fi
        done
')

echo Going to fetch these files:
echo "$files_to_fetch"

for file in $files_to_fetch; do
        scp $host:$file ./
done




