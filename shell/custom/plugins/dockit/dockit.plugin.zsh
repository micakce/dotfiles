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
    for s in $(docker image ls -a | fzf --header="Remove image(s)" --header-lines=1 -m -q "$1" | awk '{print $3}');
    do docker rmi $s;
    done;
}

# function dce() {
#     cid=$(docker ps -a | sed 1d | fzf --header="Start and attacht to container" -1 -q "$1" | awk '{print $1}')
#     if [[ $cid != '' ]]; then
#         echo "Docker container:" $container
#         read 'opt?Options: '
#         read 'cmd?Command: '
#     [ -n "$cmd" ] && docker exec "$opt" "$cid" "$cmd"
#     fi
# }

function dca() {
    cid=$(docker ps | sed 1d | fzf --header="Attach to container" -1 -q "$1" | awk '{print $1}')
    [ -n "$cid" ] && docker exec -it "$cid" /bin/bash
}
