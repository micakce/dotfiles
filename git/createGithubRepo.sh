#!/bin/bash

# function to parse the error json response from curl command
function jsonValue() {
KEY=$1
num=$2
awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | \
    sed -n ${num}p
}

# import user and password variables
. git_credentials

# if not passed as first argument, current repo root folder name is taken
if test $1; then
    repo_name=$1
else
    repo_name=$(basename `git rev-parse --show-toplevel` 2>/dev/null)
    err=$?
    if [ $err -gt 0 ]; then
        echo "Execute script from repository or pass repository name" && exit
    fi
fi


# curl command to create repo
response=`curl -s -u $user:$password https://api.github.com/user/repos \
    -d "{\"name\":\"$repo_name\"}"`

# if repo creation fails, parse response to get error message, display it and exit
message=`echo $response | jsonValue message`
if [ ${#message} -gt 0 ]; then
    echo $message
    exit
fi

# #  Repo creation response has all repo info, you can save this to a file, or not.
# echo $response > git.json

echo "El repositorio se ha creado exitosamente"

# url for setting the origin
url="https://github.com/micakce/$repo_name.git"
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
