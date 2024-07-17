#!/usr/bin/env bash

#
# QadSSH v1 - Simple quick-and-dirty SSH script
# Copyright (c) 2022 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/qadssh
# GitLab: https://gitlab.com/urbanware-org/qadssh
#

version="1.2.0"

network="192.168"             # without trailing dot
user_default="$(whoami)"      # used if no username was given

vlan="$1"
host="$2"
user="$3"

if [ -z "$vlan" ]; then
     echo "error: Missing VLAN information"
     exit 1
elif [ -z "$host" ]; then
     echo "error: Missing host information"
     exit 1
elif [ -z "$user" ]; then
     # Fallback if no username was given. You can either use the one with
     # whom this script was started (using the 'whoami' command) or
     # explicitly set a specific one (see 'user_default' variable above).
     user="$user_default"
fi

echo "Quick-and-dirty SSH, connecting to $network.$vlan.$host with"\
     "user '$user'."
ssh $user@$network.$vlan.$host

# EOF
