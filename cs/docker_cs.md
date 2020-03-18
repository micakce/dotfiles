## Change images folder:

Check default values,

```bash
docker info | grep Root
docker info | grep Storage
```

Modify/create the following file /etc/docker/daemon.json with this text:

```json
{
    "graph": "/path/to/new/folder",
    "storage-driver": "overlay2"
}
```

Then restart docker daemon and check again values.

[Source](https://stackoverflow.com/questions/24309526/how-to-change-the-docker
        -image-installation-directory/34731550#34731550)


### Migrate current populated docker folder to a new one

1. Stop the docker daemon
`sudo service docker stop`
2. Add a configuration file to tell the docker daemon what is the location of the data directory
Using your preferred text editor add a file named *daemon.json under the directory /etc/docker*. The file should have this content:
`{
   "graph": "/path/to/your/docker"
}`
of course you should customize the location “/path/to/your/docker” with the path you want to use for your new docker data directory.

3. Copy the current data directory to the new one
`sudo rsync -aP /var/lib/docker/ /path/to/your/docker`

4. Rename the old docker directory
`sudo mv /var/lib/docker /var/lib/docker.old`

This is just a sanity check to see that everything is ok and docker daemon will effectively use the new location for its data.

5. Restart the docker daemon
`sudo service docker start`

6. Test
If everything is ok you should see no differences in using your docker containers. When you are sure that the new directory is being used correctly by docker daemon you can delete the old data directory.
`sudo rm -rf /var/lib/docker.old`

[Source](https://www.guguweb.com/2019/02/07/how-to-move-docker-data-directory-to-another-location-on-ubuntu/)


-----

## How to keep changes in docker container

When you use docker run to start a container, it actually creates a new
container based on the image you have specified.

Besides the other useful answers here, note that you can restart an existing
container after it exited and your changes are still there.

```bash
docker start <container-id> # restart it in the background
docker attach <container-id> # reattach the terminal & stdin
```

To get the docker ID, while running type

```bash
docker ps -a

```

Another option is to create a new image including the changes made:

```
sudo docker commit <container_id> new_image_name:tag_name(optional)
```

[Source](https://stackoverflow.com/questions/19585028/i-lose-my-data-when-
the-container-exits)

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


## Cleaning up commands:

``
``
