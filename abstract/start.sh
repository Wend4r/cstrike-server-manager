#!/bin/bash

# Current directory in bash file.
my_dir="$(dirname "$0")"

cd $my_dir;

# File with server list.
servers_file="servers.txt"

# Async thread number
async_thread=2

cpu_max_threads=$(grep -c ^processor /proc/cpuinfo)
cpu_thread_id=$((cpu_max_threads - 1))			# The last cpu threads are most often free

while read server; do
	echo "\"$server\" starts on $cpu_thread_id thread id";
	taskset -c $cpu_thread_id,$async_thread ./s -start $server
	if [[ $cpu_thread_id -eq 0 ]]; then
		cpu_thread_id=$cpu_max_threads;
	else
		(( cpu_thread_id -= 1 ));
	fi
done < $servers_file
