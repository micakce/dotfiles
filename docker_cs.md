## Change images folder:

Modify/create the following file /etc/docker/daemon.json with this text:

```json
{
    "graph": "/mnt",
    "storage-driver": "overlay2"
}
```

But first check default values,

```bash
docker info | grep Root
docker info | grep Storage
```

Then restart docker daemon and check again.


[Source](https://stackoverflow.com/questions/24309526/how-to-change-the-docker
-image-installation-directory/34731550#34731550)

-----

## How to keep changer in docker container

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
