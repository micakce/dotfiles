# Create repo from command line using GitHub API

### Use

Execute script from existing repository, will take root folder name, you can also pass
repository name as first_argument.

Note, you can create a file containing your repository credentials and source them in the
script:
```bash
# import user and password variables
. git_credentials

# curl command to create repo
response=`curl -s -u $user:$password https://api.github.com/user/repos \
    -d "{\"name\":\"$repo_name\"}"`
```

you could hard code both in the script or indicate the user and it will prompt to enter
passoword manually
```bash
curl -s -u username https://api.github.com/user/repos -d "{\"name\":\"$repo_name\"}"

Enter host password for user 'username':
```

# Create ctags based on hooks

`git_template/hooks` containes scripts that automatically generates tags in the repos
base on defined actions. Implementation based on [TPope blog post](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
