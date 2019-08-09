
#!/bin/bash

echo "--->  Changing default shell to zsh"
IAM=`whoami`
sudo chsh -s `which zsh`
sudo chsh -s `which zsh` $IAM
/usr/bin/env zsh
source ~/.zshrc
