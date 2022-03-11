#!/bin/bash

# Current directory in bash file.
my_dir="$(dirname "$0")"

cd $my_dir;

# File with server list.
server_file="servers.txt"

while read server; do
	./s -stop $server
done < $server_file
