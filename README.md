# b-gitter
A tool for working on multiple repos. Let's say you are working on a project which have several repos and these repos all have a branch name in common. For instance you adding a new feature but it requires changes in different repos so it would make sense to name the relevant branches the same. b-gitter can be handy to sync multiple repos. It will checkout the branches for you and stash any changes before. It can also refresh your branches by pulling in any updated remote branch.

Note: This project is still in an early phase so not all the features are implemented as intended.

Usage:
  ```bash
  export PATH="$PATH:/path/to/b-gitter"
  cd /path/to/b-gitter
  chmod u+x b-gitter.sh
  ```

  Simple use case:

  ```bash
  b-gitter.sh BRANCH-123 -rd ~/projects
  ```

  With stash ask (```-sask or --stashask```) it will ask you to confirm if you want to stash:

  ```bash
  b-gitter.sh BRANCH-123 -rd ~/projects -sask
  ```

  With pull ask (```-pask or --pullask```) it will ask you to confirm if you want to refresh your branches the third option ```b``` will let you specify a different branch name other than ```develop``` :

  ```bash
  b-gitter.sh BRANCH-123 -rd ~/projects -pask
  ```
