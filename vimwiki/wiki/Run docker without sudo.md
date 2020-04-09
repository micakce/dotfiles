## Run docker without sudo

Create the docker group.

`sudo groupadd docker`
Add your user to the docker group.

`sudo usermod -aG docker $USER`
Log out and log back in so that your group membership is re-evaluated.

If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

On a desktop Linux environment such as X Windows, log out of your session completely and then log back in.

On Linux, you can also run the following command to activate the changes to groups:

`newgrp docker`
Verify that you can run docker commands without sudo.

`docker run hello-world`
[Source](https://docs.docker.com/install/linux/linux-postinstall/)
