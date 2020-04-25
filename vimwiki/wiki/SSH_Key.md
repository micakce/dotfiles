## Connecting to github through ssh

### Creating the key pair
1. Create new ssh-key
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
2. Add created ssh key to `ssh-agent`
    1. Start ssh agent in background
    ```bash
    eval "$(ssh-agent -s)"
    > Agent pid 59566
    ```
    2. Add the key
    ```bash
    ssh-add ~/.ssh/id_rsa
    ```
    [Source](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

### Add the key to your github  account
1. [Go here](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)
2. Test you newly created/added ssh key
```bash
$ ssh -T git@github.com
# Attempts to ssh to GitHub

# You may see this
> The authenticity of host github.com (IP ADDRESS) cant be established.
> RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.
> Are you sure you want to continue connecting (yes/no)?

# or this
> The authenticity of host github.com (IP ADDRESS) cant be established.
> RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
> Are you sure you want to continue connecting (yes/no)?

# after entering "yes" you should see this
> Hi username! Youve successfully authenticated, but GitHub does not
> provide shell access.
```
[Source](https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection)

### Moving from HTTPS to SSH

1. List remots you wish to change
```bash
$ git remote -v
> origin  https://github.com/USERNAME/REPOSITORY.git (fetch)
> origin  https://github.com/USERNAME/REPOSITORY.git (push)
```
2. Use git remote set-url to properly change urls
```bash
$ git remote set-url origin git@github.com:USERNAME/REPOSITORY.git
```
3. Verificar que la URL remota ha cambiado.
```bash
$ git remote -v
# Verify new remote URL
> origin  git@github.com:USERNAME/REPOSITORY.git (fetch)
> origin  git@github.com:USERNAME/REPOSITORY.git (push)
```
[Source](https://help.github.com/es/github/using-git/changing-a-remotes-url#switching-remote-urls-from-https-to-ssh)

### Adding or changin passphrase

1. You can change it or create it without generating new keys
```bash
ssh-keygen -p
# Start the SSH key creation process
> Enter file in which the key is (/Users/you/.ssh/id_rsa): [Hit enter]
> Key has comment '/Users/you/.ssh/id_rsa'
> Enter new passphrase (empty for no passphrase): [Type new passphrase]
> Enter same passphrase again: [One more time for luck]
> Your identification has been saved with the new passphrase.
```
