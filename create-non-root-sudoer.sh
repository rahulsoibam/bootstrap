#!/usr/bin/env bash

read -r -p "Enter the username" username

adduser $username

usermod -aG sudo $username

read -r -p "Make sudo user passwordless? [y|N]" response

if [[ $response =~ (yes|y|Y) ]];then
    sudo cp /etc/sudoers /etc/sudoers.bak
    echo "$(username) ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
    bot "User $(username) can now run sudo commands without password"
fi

bot "Exit this session and login using the new user"