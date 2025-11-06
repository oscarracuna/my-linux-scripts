#!/bin/bash

#TODO: function to determine dnf vs apt

echo 'downloading git...'
sudo dnf install git -y

echo 'downloading curl'
sudo dnf install curl -y

echo 'downloading fuse'
sudo dnf install fuse -y

echo 'downloading zsh'
sudo dnf install zsh -y

echo 'downloading wget'

echo 'downloading oh-my-zsh'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo 'downloading nvim app image'
wget 'https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.appimage'

echo 'renaming nvim app image, making it executable and moving to /usr/bin/'
sudo mv nvim-linux-x86_64.appimage /usr/bin/nvim.appimage 
sudo chmod +x /usr/bin/nvim.appimage

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

grep -v 'plugins' ~/.zshrc > tmpfile && mv tmpfile ~/.zshrc
echo 'plugins=(git zsh-syntax-highlighting)' >> ~/.zshrc
