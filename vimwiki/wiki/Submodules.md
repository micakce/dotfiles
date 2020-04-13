## Submodules

Have one or more repositories inside another repo and manage them independently

Once all set with the main repository you can start adding the inner respos as
submodules:

`git submodule add https://github.com/micakce/<foo>`

repos will be seeing as standalone files with no details of its inner structure.
Notice the `.gitmodules` file.

```
git add .
git commit -am "Added submodule <foo>"
git push origin master
```

Another usefull commands
```
git diff --cached DbConnector
git diff --cached --submodule
```


## Cloning a project with submodules

Use the following commands
```zsh
git clone https://github.com/micakce/<main_repo>
git submodule init
git submodule update
# last two can also be
git submodel init -- update

# to do it all in one command
`git clone --recurse-submodules https://github.com/micakce/<main_repo>`
```

## Pulling changes from submodule remote

```zsh
# from within the submodule (<main_repo>/<foo>/)
git fetch
git merge origin/master

# from within the root repo (<main_repo>/)
git submodule update --remote <foo>
```
More [here](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
