#!/bin/bash
# Servers update system by Wend4r (v1.0.0)
#######################################

# Current directory in bash file.
my_dir="$(dirname "$0")"/

echo $my_dir;

# Game dir.
game_dir="csgo"

# Version file.
version_file="steam.inf"

# File with server list.
servers_file="servers.txt"

# Main.
cd $my_dir;

# Main server. Where do they come from links.
main_server="$(cat main_server.txt)"

# Functions.
update_server ()
{
	./s -update $1;
}

# Functions.
update_link_server ()
{
	./cls -update $main_server $1;
}

full_version_path=$main_server/$game_dir/$version_file

echo "full_version_path="$full_version_path;

cp $full_version_path $full_version_path'.temp';

update_server $main_server

if cmp -s $full_version_path $full_version_path'.temp'
then
	echo "Updates is not found";
else
	while read server; do
		update_link_server $server;
	done < $servers_file
fi

# After cp.
rm -f $full_version_path'.temp';
