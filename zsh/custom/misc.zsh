function jwt_decode(){
    jq -R 'split(".") | .[1] | @base64d | fromjson' <<< "$1"
}

function curlit() {

  usage() {
    echo "Usage: $(basename "$0") [-j <jq_query>] [-d <string>] [-h]" >&2
    echo "Options:" >&2
    echo "  -j <jq_query>    JQ query to filter input" >&2
    echo "  -q <jq_query>    JQ query to filter input" >&2
    echo "  -d <variable>    Variable to save query result" >&2
    echo "  -h               Print usage instructions" >&2
  }

  local jq_query=""
  local variable=""

  while getopts ":j:d:h:q" opt; do
    case ${opt} in
      j )
        jq_query="$OPTARG"
        ;;
      q )
        query="$OPTARG"
        ;;
      d )
        variable="$OPTARG"
        ;;
      h )
        usage
        return 0
        ;;
      \? )
        echo "Invalid option: -$OPTARG" >&2
        usage
        return 1
        ;;
      : )
        echo "Option -$OPTARG requires an argument." >&2
        usage
        return 1
        ;;
    esac
  done

  if [ -n "$variable" ] && [ -z "$jq_query" ]; then
    echo "Error: You must pass the -j flag when using the -d flag" >&2
    usage
    return 1
  fi

  local response="$(cat)"

  echo -E "$response" | awk '/^HTTP/{if($2~/2../)print "\033[32m"$0"\033[0m"; else if($2~/3../)print "\033[33m"$0"\033[0m"; else if($2~/4../)print "\033[31m"$0"\033[0m"; else if($2~/5../)print "\033[35m"$0"\033[0m"; else print}'
  local body=$(echo -E "$response" | sed '1,/^\r$/d' | jq -r '. as $raw | try fromjson catch $raw ')

  echo -E "$body" | jq

  # status_code=$(echo "$response" | awk '/^HTTP/{print $2}')
  # if [ "$status_code" != "200" ]; then
  #   return 1
  # fi

  if [ -n "$jq_query" ] && [ -n "$variable" ]; then
    echo -E "$body" | jq -r "$jq_query" > "$variable"
    jq_query=""
  fi

  if [ -n "$jq_query" ]; then
    echo -E "$body" | jq -r "$jq_query"
  fi

  if [ -n "$query" ]; then
    echo -E "$body" | jq -r "$query"
  fi

}

mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

mkfile() { mkdir -p "$(dirname "$1")" && touch "$1" ;  }


# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  nvim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}

