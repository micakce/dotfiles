## Create and mount EBS on EC2 instance

1. Create EBS under Volumes tab, right click and select attach to
corresponding EC2 instance.

2. List the blocks to see if it is there `lsblk`

```bash
xvda    202:0    0    8G  0 disk
-xvda1 202:1    0    8G  0 part /
*xvdf    202:80   0   12G  0 disk*
```

3. Verify if is has a file system, if not create on `file -s /dev/xvdf`

```bash
*/dev/xvdf: data*
```
it says data, so has no file system, we create one `mkfs -t ext4 /dev/xvdf`
(-t, indicates the file system to use)

4. Create new folder where to mount the new storage:
`mkdir /z`
`mount /dev/xvdf /z`
`df -hT` to list stoarage (h: huma readable, T: show Type)

5. Make mounting permanent:
edit file */etc/fstab*, and add line:
`/dev/xvdf /z ext4 defaults,nofail, 0 0`
save it and run `mount -a` to check everything is ok (`df -hT`)
