#!/bin/sh

repo_name=$1
readme=$2

test -z $repo_name && echo "Repo name required." 1>&2 && exit 1

curl -u 'micakce' https://api.github.com/user/repos -d "{\"name\":\"$repo_name\"}"

if [ ${#readme} -gt 0 ]; then
    echo $readme > README.md
fi

git remote add origin https://github.com/micakce/$repo_name.git
