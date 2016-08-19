# b-gitter
A tool for working on multiple repos. Let's say you are working on a project which have several repos and these repos all have a branch name in common. For instance you adding a new feature but it requires changes in different repos so it would make sense to name the relevant branches the same. b-gitter can be handy to sync multiple repos. It will checkout the branches for you and stash any changes before. It can also refresh your branches by pulling in any updated remote branch.

Options:

```-rd, --rootdir``` the path to the directory which should be scanned for git repos.

```-pask, --pullask``` this option will walk you through all repos and pull a fresh develop into the specified branch after it is checked out.

```-sskip, --stashskip``` this option turns of auto stashing.

```-sask, --stashask``` this option will walk you though all repos and ask you if you want to stash the changes on your current branch.

Usage:
  ```bash
  export PATH="$PATH:/path/to/b-gitter"
  cd /path/to/b-gitter
  chmod u+x b-gitter
  ```

  Simple use cases:

  Get the status of your current branch in all repos:
  ```bash
  b-gitter -st
  ```
  or
  ```bash
  b-gitter --status
  ```

  Create new branches in confirmed repos:
  ```bash
  b-gitter your_new_branch_name -cr
  ```
  or
  ```bash
  b-gitter your_new_branch_name --create
  ```

  Checking out branches in all repos:
  ```bash
  b-gitter BRANCH-123 -rd ~/projects
  ```

  With stash ask (```-sask or --stashask```) it will ask you to confirm if you want to stash:

  ```bash
  b-gitter BRANCH-123 -rd ~/projects -sask
  ```

  With pull ask (```-pask or --pullask```) it will ask you to confirm if you want to refresh your branches the third option ```b``` will let you specify a different branch name other than ```develop``` :

  ```bash
  b-gitter BRANCH-123 -rd ~/projects -pask
  ```
