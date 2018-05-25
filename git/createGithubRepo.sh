#!/bin/bash

function jsonValue() {
KEY=$1
num=$2
awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p
}

repo_name=$1
readme=$2
url="https://github.com/micakce/$repo_name.git"

test -z $repo_name && echo "Repo name required." 1>&2 && exit 1

# curl -u 'micakce' https://api.github.com/user/repos -d "{\"name\":\"$repo_name\"}"
response=`curl -s -u 'micakce' https://api.github.com/user/repos -d "{\"name\":\"$1\"}" | jsonValue message`

if [ ${#response} -gt 0 ]; then
    echo $response
    exit
fi

echo "El repositorio se ha creado exitosamente"

if [ ${#readme} -gt 0 ]; then
    echo $readme > README.md
else
    echo "Remember to ad a Readme.md file"
fi

OUT=`git remote 2> /dev/null`
err=$?

if [ $err -gt 0 ]; then
    echo "Not in a git repositorie"
elif [ ${#OUT} -eq 0 ]; then
    git remote add origin $url
    echo "Origin $url Added"
else
    echo "There is already a origin"
fi
