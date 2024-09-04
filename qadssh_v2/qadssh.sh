#!/usr/bin/env bash

#
# QadSSH v2 - Enhanced quick-and-dirty SSH script
# Copyright (c) 2024 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub:   https://github.com/urbanware-org/qadssh
# GitLab:   https://gitlab.com/urbanware-org/qadssh
# Codeberg: https://codeberg.org/urbanware-org/qadssh
#

version="2.0.0"

script_dir=$(dirname $(readlink -f $0))
script_file=$(basename "$0")
script_config="$script_dir/ssh_users.conf"
whoami=$(whoami)

remote_ip="$1.$2"
username="$3"

ssh_connection() {
    if [ -z "$username" ]; then
        exit
    else
        echo -e "Quick-and-dirty SSH, connecting to \e[96m${remote_ip}\e[0m" \
                "with user \e[93m${username}\e[0m."
        ssh ${username}@${remote_ip}
    fi
    exit $?
}

# Main entry point

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "usage: qadssh.sh NETWORK_PREFIX HOST_IP [USERNAME]"
    exit 1
fi

if [ ! -z "$username" ]; then
    ssh_connection
else
    if [ ! -f "$script_config" ]; then
        username=$whoami
        ssh_connection
    fi
fi

if [ ! -f "$script_config" ]; then
    echo -e "Quick-and-dirty SSH, connecting to \e[96m${remote_ip}\e[0m" \
            "with user \e[93m${username}\e[0m."
    ssh_connection
fi

echo
echo -e "\e[94mQuick-and-dirty SSH interactive connector\e[0m"
echo

echo -e "Connecting to \e[96m${remote_ip}\e[0m."
echo
echo -e "Please select a user to establish the connection with"
echo

list_counter=0
while read line; do
    line=$(sed -e "s/\ //g" <<< $line)
    if [ -z "$line" ]; then
        continue
    fi
    line_counter=$(( line_counter + 1 ))
    echo -e "  \e[90m[\e[96m${line_counter}\e[90m]\e[0m \e[93m${line}\e[0m"
done < $script_config

echo -e "  \e[90m[\e[96m0\e[90m]\e[0m \e[92mCurrent user\e[0m" \
           "(\e[93m${whoami}\e[0m)"
echo
echo -e "or enter the username manually (default is \e[93m${whoami}\e[0m)."
echo

while read -p "→ " user_id; do
    echo -en "\033[1A\033[2K"
    if [ -z "$user_id" ] || [ "$user_id" = "0" ]; then
        username=$whoami
    else
        if [[ "$user_id" =~ ^[0-9]+$ ]]; then
            username=$(sed -n -e ${user_id}p $script_config)
        else
            username="$user_id"
        fi
    fi
    break
done
echo -e "→ \e[93m${username}\e[0m"
echo

ssh_connection

