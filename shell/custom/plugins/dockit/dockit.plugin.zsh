DOCKIT_JQ_PATTERN=".[0] | { Id: .Id, Mounts: .Mounts, Config: {CMD: .Config.Cmd }}"
FZF_DOCKIT_PREVIEW="--preview=docker container inspect \$(echo {} | awk '{print "'$1'"}') | jq -C '$DOCKIT_JQ_PATTERN'"

# Select one or more docker container(s) to remove
function dcrm() {
    for s in $(docker ps -a | fzf $FZF_DOCKIT_PREVIEW \
        --header="Remove container(s)" \
        --header-lines=1 -m -q "$1" | awk '{print $1}');
    do docker rm $s;
    done;
}

# Select one or more running docker container to stop
function dcstop() {
    for s in $(docker ps | fzf $FZF_DOCKIT_PREVIEW \
        --header="Stop  container(s)" \
        --header-lines=1 -m -q "$1" | awk '{print $1}')
    do docker stop $s;
    done;
}

# Select a docker container to start and attach to
function dcsa() {
    local cid
    cid=$(docker ps -a | fzf $FZF_DOCKIT_PREVIEW \
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
    for img in $(docker image ls -a $@ | fzf \
        --bind='ctrl-a:toggle-all' \
        --header="Remove image(s)" \
        --header-lines=1 -m | awk '{print $3}');
    do docker rmi $img ;
    done;
}

function dit() { # docker inspect filter test
JQ_PREFIX="docker container inspect 8235cc373374 | jq "
INITIAL_QUERY=""
FZF_DEFAULT_COMMAND="$JQ_PREFIX '$INITIAL_QUERY'" \
    fzf --bind "change:reload:$JQ_PREFIX '.[0].$(echo {q})' || true" \
    --bind "ctrl-r:reload:$JQ_PREFIX ." \
    --ansi --phony --query "$INITIAL_QUERY"
}

function RG() { # fzf as filter and not fuzzy finder
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY=""
FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
  fzf --bind "change:reload:$RG_PREFIX {q} || true" \
      --ansi --phony --query "$INITIAL_QUERY"
}



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
