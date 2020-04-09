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

[Source](https://stackoverflow.com/questions/24309526/how-to-change-the-docker-image-installation-directory/34731550#34731550)
