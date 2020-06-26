DOCKIT_JQ_PATTERN=".[0] | { Id: .Id, Mounts: .Mounts, Config: {CMD: .Config }}"
FZF_DOCKIT_PREVIEW="--preview=docker inspect {1} | jq -C '$DOCKIT_JQ_PATTERN'"

# Select one or more docker container(s) to remove
function dcrm() {
    for s in $(docker ps -a | fzf $FZF_DOCKIT_PREVIEW \
        --bind "alt-i:execute(docker inspect {1} | jq -C . | less -R > /dev/tty)" \
        --header="Remove container(s)" \
        --header-lines=1 -m -q "$1" | awk '{print $1}');
    do docker rm $s;
    done;
}

function dct() { # docker container test

    docker ps -a | fzf \
        --header="Select container to run" \
        --bind "alt-i:execute(docker inspect {1} | jq -C . | less -R > /dev/tty)" \
        --bind "ctrl-y:execute-silent(echo -n {1} | xclip -selection clipboard )+abort" \
        --header-lines=1 -m | awk '{print $1}'
}


function dcl() {
    # https://unix.stackexchange.com/questions/29724/how-to-properly-collect-an-array-of-lines-in-zsh
    local cid_array=("${(@f)$(docker ps -a | fzf $FZF_DOCKIT_PREVIEW \
        --bind "ctrl-y:execute-silent(echo -n {1} | xclip -selection clipboard )+abort" \
        --bind "alt-i:execute(docker inspect {1} | jq -C . | less -R > /dev/tty)" \
        --header="Select container to run" \
        --preview-window="down:50%" \
        --header-lines=1 -m | awk '{print $1}')}")

    if [ "${cid_array[1]}" -eq "" 2> /dev/null ]; then
        return
    fi
    local cmd=$(echo "rm\ninspect" | fzf --header="Select command")
    print -z docker container $cmd ${cid_array[@]}
}

# Select one or more running docker container to stop
function dcs() {
    for s in $(docker ps | fzf $FZF_DOCKIT_PREVIEW \
        --header="Stop  container(s)" \
        --header-lines=1 -m -q "$1" | awk '{print $1}')
    do docker stop $s;
    done;
}

# Select a docker container to start and attach to
function dcsa() {
    local cid=$(docker ps -a | fzf $FZF_DOCKIT_PREVIEW \
        --header="Start and attacht to container" \
        --header-lines=1 -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}


function dce() {
    local cid cname opts
    read cid cname <<< $(docker ps | fzf $FZF_DOCKIT_PREVIEW \
        --header="Exec command in running container" \
        --header-lines=1 | awk '{print $1" "$2}')
    opts="-it"
    if [[ $cid != '' ]]; then
        echo "Docker container:" $cname
        vared -p "Options: " opts
        read 'cmd?Command: '
    [ -n "$cmd" ] && print -z docker exec "$opts" "$cid" "$cmd"
    fi
}

# Select a docker image to remove
function dirm() {
    local inspect="--bind=ctrl-o:execute(docker inspect {3} | jq -C . | less -R > /dev/tty)"
    for img in $(docker image ls -a $@ | fzf $inspect \
        --bind='ctrl-a:toggle-all' \
        --header="Remove image(s)" \
        --header-lines=1 -m | awk '{print $3}');
    do docker rmi $img ;
    done;
}

function dil() { #docker image list
    # https://unix.stackexchange.com/questions/29724/how-to-properly-collect-an-array-of-lines-in-zsh
    local cid_array=("${(@f)$(docker image ls $@ | fzf \
        --preview="docker inspect {3} | jq -C '$DOCKIT_JQ_PATTERN'" \
        --preview-window="down:50%" \
        --bind "ctrl-y:execute-silent(echo -n {3} | xclip -selection clipboard )+abort" \
        --bind "alt-i:execute(docker inspect {3} | jq -C . | less -R > /dev/tty)" \
        --header="Docker image list " \
        --header-lines=1 -m | awk '{print $3}')}")
    if [ "${cid_array[1]}" -eq "" 2> /dev/null ]; then
        return
    fi
    local cmd=$(echo "rm\ninspect" | fzf --header="Select command")
    print -z docker image $cmd ${cid_array[@]}
}

function dnl() {
    # https://unix.stackexchange.com/questions/29724/how-to-properly-collect-an-array-of-lines-in-zsh
    local cid_array=("${(@f)$(docker network ls $@ | fzf $FZF_DOCKIT_PREVIEW \
        --bind "ctrl-y:execute-silent(echo -n {1} | xclip -selection clipboard )+abort" \
        --bind "alt-i:execute(docker inspect {1} | jq -C . | less -R > /dev/tty)" \
        --header="Docker networks" \
        --preview-window="down:50%" \
        --header-lines=1 -m | awk '{print $1}')}")

    if [ "${cid_array[1]}" -eq "" 2> /dev/null ]; then
        return
    fi
    local cmd=$(echo "rm\ninspect" | fzf --header="Select command")
    print -z docker network $cmd ${cid_array[@]}
}

function jqit() { # jq interactive filtering
JQ_PREFIX=" cat $1 | jq -C "
INITIAL_QUERY=""
FZF_DEFAULT_COMMAND="$JQ_PREFIX '$INITIAL_QUERY'" fzf \
    --bind "change:reload:$JQ_PREFIX {q} || true" \
    --bind "ctrl-r:reload:$JQ_PREFIX ." \
    --ansi --phony
}

function RG() { # fzf as filter and not fuzzy finder
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY=""
FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" fzf \
    --bind "change:reload:$RG_PREFIX {q} || true" \
    --ansi --phony --query "$INITIAL_QUERY"
}
bindkey -s '\C-f' 'RG\n'

# COMPLETION

export DOCKER_FZF_PREFIX="--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"

_fzf_complete_docker_image_post() {
  awk '{ if ($1=="<none>") print $3; else print $1":"$2 }'
}

_fzf_complete_docker_image () {
    _fzf_complete "$DOCKER_FZF_PREFIX \
        --preview=\"docker inspect \$(echo {} | awk '{print "'$3'"}') | jq -C '$DOCKIT_JQ_PATTERN'\" \
        -m --header-lines=1" "$@" < <(
        docker images
    )
}

_fzf_complete_docker_container_post() {
    awk '{print $NF}'
}

_fzf_complete_docker_container () {
    _fzf_complete "$DOCKER_FZF_PREFIX \
        --preview=\"docker container inspect \$(echo {} | awk '{print "'$1'"}') | jq -C '$DOCKIT_JQ_PATTERN'\" \
        -m --header-lines=1" "$@" < <(
        docker ps -a
    )
}

_fzf_complete_docker_container_running_post() {
    awk '{print $NF}'
}

_fzf_complete_docker_container_running () {
    _fzf_complete "$DOCKER_FZF_PREFIX \
        --preview=\"docker container inspect \$(echo {} | awk '{print "'$1'"}') | jq -C '$DOCKIT_JQ_PATTERN'\" \
        -m --header-lines=1" "$@" < <(
        docker ps
    )
}

_fzf_complete_docker_container_stopped_post() {
    awk '{print $NF}'
}

_fzf_complete_docker_container_stopped () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker ps --filter "status=exited" --filter="status=created"
    )
}

# https://github.com/kwhrtsk/docker-fzf-completion
_fzf_complete_docker() {
    local tokens docker_command
    setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
    tokens=(${(z)LBUFFER})
    if [ ${#tokens} -le 2 ]; then
        return
    fi
    docker_command=${tokens[2]}
    case "$docker_command" in
        exec|attach|kill|pause|unpause|port|stats|stop|top|wait)
            _fzf_complete_docker_container_running "$@"
            return
        ;;
        start)
            _fzf_complete_docker_container_stopped "$@"
            return
        ;;
        commit|cp|diff|export|logs|rename|restart|rm|update)
            _fzf_complete_docker_container "$@"
            return
        ;;
        run|save|push|pull|tag|rmi|history|inspect|create)
            _fzf_complete_docker_image "$@"
            return
        ;;
        container)
            if [ ${#tokens} -le 3 ]; then
                return
            fi
            docker_command=${tokens[3]}
            case "$docker_command" in
                exec|attach|kill|pause|unpause|port|stats|stop|top|wait)
                    _fzf_complete_docker_container_running "$@"
                    return
                ;;
                start)
                    _fzf_complete_docker_container_stopped "$@"
                    return
                ;;
                commit|cp|diff|export|inspect|logs|rename|restart|rm|update)
                    _fzf_complete_docker_container "$@"
                    return
                ;;
                run|create)
                    _fzf_complete_docker_image "$@"
                    return
                ;;
            esac
        ;;
        image)
            if [ ${#tokens} -le 3 ]; then
                return
            fi
            docker_command=${tokens[3]}
            case "$docker_command" in
                save|push|pull|tag|rm|history|inspect)
                    _fzf_complete_docker_image "$@"
                    return
                ;;
            esac
        ;;
    esac
}
