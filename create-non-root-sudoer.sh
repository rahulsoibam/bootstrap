#!/usr/bin/env bash
source ./lib/bot.sh

read -r -p "Enter the username: " username

adduser $username

usermod -aG sudo $username

read -r -p "Make sudo user passwordless? [y|N]: " response

if [[ $response =~ (yes|y|Y) ]];then
    sudo cp /etc/sudoers /etc/sudoers.bak
    echo "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
    bot "User $username can now run sudo commands without password"
fi

bot "Symlinking ssh keys to new user"
mkdir -p /home/$username/.ssh/
cat /root/.ssh/authorized_keys >> /home/$username/.ssh/authorized_keys
chown $username:$username /home/$username/.ssh/authorized_keys
chmod 400 /home/$username/.ssh/authorized_keys
bot "Exit this session and login using the new user"