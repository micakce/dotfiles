#!/bin/sh

token=$(cat $1)
repo_name=$2

curl -H "Content-Type:application/json" https://gitlab.com/api/v3/projects?private_token=$token -d "{ \"name\": \"$repo_name\" }"

git remote add origin https://gitlab.com/micakce/$repo_name.git


'''
Git global setup
git config --global user.name "Dangelo Guanipa"
git config --global user.email "micakce@gmail.com"

Create a new repository
git clone https://gitlab.com/micakce/clitestrepo.git
cd clitestrepo
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master

Existing folder
cd existing_folder
git init
git remote add origin https://gitlab.com/micakce/clitestrepo.git
git add .
git commit -m "Initial commit"
git push -u origin master

Existing Git repository
cd existing_repo
git remote rename origin old-origin
git remote add origin https://gitlab.com/micakce/clitestrepo.git
git push -u origin --all
git push -u origin --tags
'''

