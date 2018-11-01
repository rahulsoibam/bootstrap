#!/usr/bin/env bash

# include library helpers for colorized echo and installer
source ./lib/bot.sh
source ./lib/installer.sh
bot "I need you to enter your sudo password so I can install and configure some things:"
sudo -v

# Keep-alive: update existing sudo timestamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "Do you want me to setup this machine to allow you to run sudo without a password?"
read -r -p "Make sudo passwordless? [y|N] " response

if [[ $response =~ (yes|y|Y) ]];then
    sudo cp /etc/sudoers /etc/sudoers.bak
    echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
    bot "You can now run sudo commands without password"
fi

bot "Installing python, git, zsh and others"
apt update
require_apt python3 python3-dev python3-pip
pip3 install thefuck
require_apt tmux
require_apt git
require_apt zsh
require_apt curl
require_apt build-essential
require_apt cmake

bot "Changing default shell to zsh"
CURRENTSHELL=$SHELL
if [[ "$CURRENTSHELL" != "/usr/bin/zsh" ]]; then
  bot "setting zsh (/usr/bin/zsh) as your shell (password required)"
  sudo bash -c 'echo "/usr/bin/zsh" >> /etc/shells'
  chsh -s /usr/bin/zsh
  ok
fi

bot "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

if [[ ! -d "~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [[ ! -d "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

bot "Creating symlinks dotfiles"
pushd .dotfiles > /dev/null 2>&1
now=$(date +"%Y.%m.%d.%H.%M.%S")

for file in .*; do
    if [[ $file == "." || $file == ".." ]]; then
        continue
    fi
    running "~/$file"
    # if the file exists
    if [[ -e ~/$file ]]; then
        mkdir -p ~/.dotfiles_backup/$now
        mv ~/$file ~/.dotfiles_backup/$now/$file
        echo "Backup saved as ~/.dotfiles_backup/$now/$file"
    fi

    # symlink might still exist
    unlink ~/$file > /dev/null 2>&1
    # create the link
    ln -s ~/bootstrap/.dotfiles/$file ~/$file
    echo -en '\tlinked';ok
done

popd > /dev/null 2>&1

bot "Installing vim plugins"
vim +'PlugInstall --sync' +qa > /dev/null 2>&1
python3 ~/.vim/plugged/YouCompleteMe/install.py --all
ok

bot "All done. Kill this terminal and launch a new one"