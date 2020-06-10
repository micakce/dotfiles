#!/bin/bash

if [ `whoami` == root ]; then
    echo "DONT run this script as root, or using sudo"
    exit
fi

echo ""
echo "*************************************"
echo "* Setting up ideal Dev environment *"
echo "*************************************"
echo ""

BASEDIR=$(cd "$(dirname "$0")"; pwd)

# Installing vim
echo "===>  Installing VIM  <==="
sudo apt-get install vim > /dev/null # we need the non-system vim
sudo apt-get install curl > /dev/null # we need the non-system vim
echo ""

echo "===>  Installing ripgrep  <==="
snap install ripgrep --classic

FILE=$HOME/.vimrc
if test -f "$FILE"; then
    echo "--->  Backing up any previous .vimrc"
    mv $HOME/.vimrc $HOME/.vimrc.bak
    echo "--->  Linking .vimrc"
    ln -sf $BASEDIR/vim/.vimrc $HOME/.vimrc
else
    echo "--->  Linking .vimrc"
    ln -sf $BASEDIR/vim/.vimrc $HOME/.vimrc
fi

FILE=$HOME/.gvimrc
if test -f "$FILE"; then
    echo "--->  Backing up any previous .gvimrc"
    mv $HOME/.gvimrc $HOME/.gvimrc.bak
    echo "--->  Linking .gvimrc"
    ln -sf $BASEDIR/vim/.gvimrc $HOME/.gvimrc
else
    echo "--->  Linking .gvimrc"
    ln -sf $BASEDIR/vim/.gvimrc $HOME/.gvimrc
fi

# Installing tmux
echo ""
echo "===>  Installing tmux <==="
sudo apt-get install tmux -y > /dev/null
FILE=$HOME/.tmux.conf
if test -f "$FILE"; then
    echo "--->  Making backup of .tmux.conf"
    mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
    echo "--->  Linking .tmux.conf"
    ln -sf $BASEDIR/tmux/.tmux.conf $HOME/.tmux.conf
    echo "--->  Instaling TPM"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "--->  Linking .tmux.conf"
    ln -sf $BASEDIR/tmux/.tmux.conf $HOME/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# echo "--->  Making backup of .tmux folder"
# mv -f $HOME/.tmux $HOME/.tmux_bak
# echo "--->  Linking .tmux folder"
# ln -sf $BASEDIR/tmux/.tmux $HOME/.tmux

# Installing zsh
echo ""
echo "===>  Installing zsh  <==="
sudo apt-get install zsh -y > /dev/null
echo "===>  Installing oh-my-zsh  <==="
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

FILE=$HOME/.zshrc
if test -f "$FILE"; then
    echo "--->  Making backup of zshrc"
    mv $HOME/.zshrc $HOME/.zshrc.bak
    echo "--->  Linking .zshrc"
    ln -sf $BASEDIR/shell/zshrc $HOME/.zshrc
else
    echo "--->  Linking .zshrc"
    ln -sf $BASEDIR/shell/zshrc $HOME/.zshrc
fi

echo "--->  Installing customized theme"
ln -sf $BASEDIR/shell/custom/theme/micakce.zsh-theme $BASEDIR/shell/oh-my-zsh/themes/micakce.zsh-theme

echo ""
echo "====  Successfully installed environment  ===="
echo "====  Plese reboot your system ===="
