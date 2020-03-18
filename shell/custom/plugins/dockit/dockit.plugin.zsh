# Select one or more docker container(s) to remove
function dcrm() {
    for s in $(docker ps -a | fzf --header="Remove container(s)" --header-lines=1 -m -q "$1" | awk '{print $1}');
    do docker rm $s;
    done;
}

# Select one or more running docker container to stop
function dcs() {
    for s in $(docker ps -a | fzf --header="Stop  container(s)" --header-lines=1 -m -q "$1" | awk '{print $1}');
    do docker stop $s;
    done;
    # local cid
    # cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')
    # [ -n "$cid" ] && docker stop "$cid"
}

# Select a docker container to start and attach to
function dcsa() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf --header="Start and attacht to container" -1 -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a docker image to remove
function dirm() {
    for img in $(docker image ls -a | fzf --header="Remove image(s)" --header-lines=1 -m -q "$1" | awk '{print $3}');
    do docker rmi $img;
    done;
}

function dce() {
    local cid cname opts
    read cid cname <<< $(docker ps -a | fzf --header="Exec command in running container" --header-lines=1 -1 -q "$1" | awk '{print $1" "$2}')
    opts="-it"
    if [[ $cid != '' ]]; then
        echo "Docker container:" $cname
        vared -p "Options: " opts
        read 'cmd?Command: '
    # [ -n "$cmd" ] && docker exec "$opt" "$cid" "$cmd"
    [ -n "$cmd" ] && print -z docker exec "$opts" "$cid" "$cmd"
    fi
}

function dca() {
    cid=$(docker ps | sed 1d | fzf --header="Attach to running container" -1 -q "$1" | awk '{print $1}')
    [ -n "$cid" ] && docker exec -it "$cid" /bin/bash
}
