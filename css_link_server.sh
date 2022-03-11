#!/bin/bash
# Servers creator system by Wend4r (v1.0.0)
#######################################

# General prefix game dir name
prefix_game_dir='csgo'

# First arg
first_arg=$1

# Two arg
two_arg=$2

# Three arg
three_arg=$3

# Current dir on user
current_dir=$PWD

# Text color alias
RED='\033[0;31m' # Red
GREEN='\033[0;32m' # Green
YELLOW='\033[1;33m' # Yellow
NC='\033[0m' # Default

# Functions
message ()
{
	echo -e "$1";
}

help ()
{
	message "Usage: ${GREEN}$0 <link_dir> <new_dir>${NC}";
	message "       ${GREEN}$0 -update <from> <target>${NC}";
	message "       ${GREEN}$0 -rm <target_dir>${NC}";
}

die ()
{
	cd $current_dir/ && exit;
}

if [ "$first_arg" == "-h" ] || [ "$first_arg" == "-help" ] || ( [ "1" -gt "$#" ] && [ "$#" -lt "4" ] ); then
	help;
	die;
elif [ "$first_arg" == "-rm" ]; then
	rm -rf $current_dir/$two_arg;
	die;
elif [ "$first_arg" == "-update" ]; then

	if [ "$#" -ne "3" ]; then
		help;
		die;
	fi

	# Target dir from arg
	from_dir=$current_dir/$two_arg/$prefix_game_dir;
	update_dir=$current_dir/$three_arg/$prefix_game_dir;

	cd $update_dir/;

	ln -fs $from_dir/pak*_*.vpk ./;

	die;
fi

echo $first_arg;

# Link dir from 1 arg
link_dir=$current_dir/$first_arg;

# Link dir from 1 arg
target_dir=$two_arg;

# Target dir from 2 arg
new_dir=$current_dir/$target_dir

if [ -e $new_dir ]; then
	message ">> ${RED}Error! ${NC}Folder ${GREEN}$target_dir ${NC}already exists!";
	die;
fi

# Main copy logic

mkdir $new_dir;
cd $new_dir
ln -s $link_dir/bin ./;
ln -s $link_dir/platform ./;
ln -s $link_dir/steamapps ./;
ln -f -s $link_dir/srcds_linux ./;
ln -f -s $link_dir/srcds_run ./;

# From csgo_handler.sh
if [ -e $link_dir/start_params.conf ]; then
	cp -r -p $link_dir/start_params.conf ./;
fi

ln -f -s $link_dir/steam_appid.txt ./;

link_game_dir=$link_dir/$prefix_game_dir;
new_game_dir=$new_dir/$prefix_game_dir;

mkdir $new_game_dir;
cd $new_game_dir/;

if [ -e $link_game_dir/addons ]; then
	cp -r -p $link_game_dir/addons ./;
fi

ln -s $link_game_dir/bin ./;
ln -s $link_game_dir/maps ./;
cp -r -p $link_game_dir/materials ./;
cp -r -p $link_game_dir/models ./;
ln -s $link_game_dir/resource ./;
ln -s $link_game_dir/scripts ./;
ln -s -f $link_game_dir/botchatter.db ./;
ln -s -f $link_game_dir/botprofile.db ./;
ln -s -f $link_game_dir/botprofilecoop.db ./;
cp -p $link_game_dir/bspconvar_whitelist.txt ./;
ln -s -f $link_game_dir/gameinfo.txt ./;
ln -s -f $link_game_dir/gamemodes.txt ./;
cp -p $link_game_dir/mapcycle.txt ./;
cp -p $link_game_dir/maplist.txt ./;
cp -p $link_game_dir/motd.txt ./;
ln -s $link_game_dir/pak*_*.vpk ./;
cp -p $link_game_dir/pure_server_whitelist.txt ./;
ln -s -f $link_game_dir/steam.inf ./;

mkdir ./cfg;
cd ./cfg;
ln -s $link_game_dir/cfg/coop ./coop
ln -s $link_game_dir/cfg/survival ./survival

if [ -e $link_game_dir/cfg/sourcemod ]; then
	cp -r -p $link_game_dir/cfg/sourcemod ./sourcemod;
fi

if [ -e $link_game_dir/cfg/autoexec.cfg ]; then
	cp -p $link_game_dir/cfg/autoexec.cfg ./;
fi

ln -s -f $link_game_dir/cfg/default.cfg ./;
ln -s -f $link_game_dir/cfg/gamemode_*.cfg ./;
ln -s -f $link_game_dir/cfg/op08_*.cfg ./;

if [ -e $link_game_dir/cfg/server.cfg ]; then
	cp -p $link_game_dir/cfg/server.cfg ./;
fi

ln -s -f $link_game_dir/cfg/valve.rc ./;

message ">> Successful is copied the server from ${GREEN}$link_dir/${NC} to ${GREEN}$new_dir/${NC} !";

die;
