## Run visual tools from within container

You have two options:
1. Quick solution for eventual user:

```bash
docker run -it \
           --user $(id -u) \
           -e DISPLAY=unix$DISPLAY \
           --workdir=/app \
           --volume="$PWD:/app" \
           --volume="/etc/group:/etc/group:ro" \
           --volume="/etc/passwd:/etc/passwd:ro" \
           --volume="/etc/shadow:/etc/shadow:ro" \
           --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           <docker-image> [<command>]
```

[source](https://github.com/tzutalin/labelImg)

2. Better solution for heavily used containers:

    1. Create a docker file to build an image than handle user creation:

        ```docker
        FROM <your_image>

        ARG USER_ID
        ARG GROUP_ID

        RUN addgroup --gid $GROUP_ID user
        RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
        USER user
        ```
    2. Build the image passing the corresponding build-time arguments and then
    run it

        ```docker

            docker build -t myimage \
                --build-arg USER_ID=$(id -u) \
                --build-arg GROUP_ID=$(id -g) .

            docker run -it \
                -e DISPLAY=unix$DISPLAY \
                --workdir=/app \
                --volume="$PWD:/app" \
                -v /tmp/.X11-unix:/tmp/.X11-unix \
                <docker-image> [<command>]

        ```

        this last approach actually is a solution to avoid user permission
        conflicts inside the container and out of it for files created with root user
        (not running `chwon` anymore). See the full post [here](https://vsupalov.com/docker-shared-permissions/)
