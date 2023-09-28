#!/bin/bash
# Servers creator system by Wend4r (v1.0.0)
#######################################

# General prefix game dir name
PREFIX_GAME_DIR="game"

# First arg
FIRST_ARG="$1"

# Two arg
TWO_ARG="$2"

# Three arg
THREE_ARG="$3"

# Current dir on user
CURRENT_DIR="$PWD"

# Text color alias
RED="\033[0;31m"; # Red
GREEN="\033[0;32m"; # Green
YELLOW="\033[1;33m"; # Yellow
NC="\033[0m"; # Default

# Functions
message ()
{
	echo -e "$1";
}

help ()
{
	message "Usage: ${GREEN}$0 <link dir> <new dir>${NC}";
	message "       ${GREEN}$0 -update <from> <target>${NC}";
	message "       ${GREEN}$0 -rm <target dir>${NC}";
}

die ()
{
	cd $CURRENT_DIR/ && exit;
}

if [ "$FIRST_ARG" == "-h" ] || [ "$FIRST_ARG" == "-help" ] || ( [ "1" -gt "$#" ] && [ "$#" -lt "4" ] ); then
	help;
	die;
elif [ "$FIRST_ARG" == "-rm" ]; then
	rm -rf $CURRENT_DIR/$TWO_ARG;
	die;
elif [ "$FIRST_ARG" == "-update" ]; then

	if [ "$#" -ne "3" ]; then
		help;
		die;
	fi

	# Target dir from arg
	FROM_DIR="$CURRENT_DIR/$TWO_ARG/$PREFIX_GAME_DIR/csgo"
	UPDATE_DIR="$CURRENT_DIR/$THREE_ARG/$PREFIX_GAME_DIR/csgo"

	cd "$UPDATE_DIR";

	ln -fs "$FROM_DIR"/pak*_*.vpk ./;
	ln -fs "$FROM_DIR"/shaders_*_*.vpk ./;

	die;
fi

echo $FIRST_ARG

# Link dir from 1 arg
LINK_DIR="$CURRENT_DIR/$FIRST_ARG";

# Link dir from 1 arg
TARGET_DIR="$TWO_ARG";

# Target dir from 2 arg
NEW_DIR="$CURRENT_DIR/$TARGET_DIR";

if [ -e "$NEW_DIR" ]; then
	message ">> ${RED}Error! ${NC}Folder ${GREEN}\"$TARGET_DIR\" ${NC}already exists!";
	die;
fi

# Main copy logic

NEW_GAME_DIR="$NEW_DIR/$PREFIX_GAME_DIR";
LINK_GAME_DIR="$LINK_DIR/$PREFIX_GAME_DIR";

mkdir -p "$NEW_GAME_DIR";
cd "$NEW_GAME_DIR";

ln -s "$LINK_GAME_DIR/bin" ./;
ln -s "$LINK_GAME_DIR/core" ./;
ln -s "$LINK_GAME_DIR/csgo_core" ./;
ln -f -s "$LINK_GAME_DIR/csgo_imported" ./;
ln -f -s "$LINK_GAME_DIR/csgo_lv" ./;

# From csgo_handler.sh
if [ -e "$LINK_DIR/start_params.conf" ]; then
	cp -r -p "$LINK_DIR/start_params.conf" ./;
fi

NEW_GAME_CSGO_DIR="$NEW_GAME_DIR/csgo";
LINK_GAME_CSGO_DIR="$LINK_GAME_DIR/csgo";

mkdir -p "$NEW_GAME_CSGO_DIR";
cd "$NEW_GAME_CSGO_DIR";

if [ -e "$LINK_GAME_CSGO_DIR/addons" ]; then
	cp -r -p "$LINK_GAME_CSGO_DIR/addons" ./;
fi

ln -s "$LINK_GAME_CSGO_DIR/bin" ./;
ln -s "$LINK_GAME_CSGO_DIR/maps" ./;
ln -s "$LINK_GAME_CSGO_DIR/panorama" ./;
ln -s "$LINK_GAME_CSGO_DIR/resource" ./;
cp -p "$LINK_GAME_CSGO_DIR/gameinfo.gi" ./;
ln -s -f "$LINK_GAME_CSGO_DIR/gameinfo_branchspecific.gi" ./;
ln -s $LINK_GAME_CSGO_DIR/pak*_*.vpk ./;
ln -s $LINK_GAME_CSGO_DIR/shaders*_*.vpk ./;
ln -s -f "$LINK_GAME_CSGO_DIR/steam.inf" ./;

mkdir ./cfg;
cd ./cfg;

if [ -e $LINK_GAME_CSGO_DIR/cfg/sourcemod ]; then
	cp -r -p "$LINK_GAME_CSGO_DIR/cfg/sourcemod" ./sourcemod;
fi

if [ -e $LINK_GAME_CSGO_DIR/cfg/autoexec.cfg ]; then
	cp -p "$LINK_GAME_CSGO_DIR/cfg/autoexec.cfg" ./;
fi

ln -s -f $LINK_GAME_CSGO_DIR/cfg/gamemode_*.cfg ./;
ln -s -f "$LINK_GAME_CSGO_DIR/cfg/machine_convars_default.vcfg" ./;
ln -s -f "$LINK_GAME_CSGO_DIR/cfg/perftest.cfg" ./;

if [ -e "$LINK_GAME_CSGO_DIR/cfg/server.cfg" ]; then
	cp -p "$LINK_GAME_CSGO_DIR/cfg/server.cfg" ./;
fi

ln -s "$LINK_GAME_CSGO_DIR/cfg/server_default.cfg" ./;

message ">> Successful is copied the server from ${GREEN}\"$LINK_DIR\"${NC} to ${GREEN}\"$NEW_DIR\"${NC} !";

die;
