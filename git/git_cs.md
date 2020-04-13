View changes in files after pull

Suppose you're pulling to master. You can refer to the previous position of master by master@{1} (or even master@{10.minutes.ago};
see the specifying revisions section of the git-rev-parse man page), so that you can do things like

```bash

See all of the changes: git diff master@{1} master

See the changes to a given file: git diff master@{1} master <file>

See all the changes within a given directory: git diff master@{1} master <dir>

See the summary of changes again: git diff --stat master@{1} master
```
