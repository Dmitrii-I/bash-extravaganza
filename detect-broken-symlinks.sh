#!/bin/bash

# This script echoes a message if it finds broken symlink
# in a directory. Default dir is $HOME/bin

dir=${@:-"$HOME/bin"}

for f in $(ls -1 "$dir"); do 
    [ ! -e "$dir/$f" ]  && echo Broken symlink: "$dir/$f"
done
