pwd
REPOS=`find ./projects/ -type d -name '.git' -print | sed 's/.git//g'`
while read -r repo; do
    BRANCHES=`git -C $repo branch | grep $1`
    if (( `echo "${BRANCHES}" | wc -l` > 1 )); then
        # MULTIPLE BRANCHES IN REPO
        echo "Multiple branches found @repo(${repo}) Make your selection:"
        arr=()
        while read -r branch; do
           arr+=("$branch")
           echo "${#arr[@]}) ${branch}"
        done <<< "$BRANCHES"

        read input </dev/tty
        selectedbranch="${arr["$((input - 1))"]}"

        STASH=`git -C $repo stash`
        OPR=`git -C $repo checkout $selectedbranch`

    elif [[ -n "${BRANCHES/[ ]*\n/}" ]]; then
        # SINGLE BRANCH IN REPO
        STASH=`git -C $repo stash`
        OPR=`git -C $repo checkout $BRANCHES`
    else
        # NO BRANCH FOUND
        STASH=`git -C $repo stash`
        OPR=`git -C $repo checkout develop`
    fi
done <<< "$REPOS"
