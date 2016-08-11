source ./options.sh

echo "${ROOTDIR}"
echo "${SEARCHBRANCH}"

REPOS=`find $ROOTDIR -type d -name '.git' -print | sed 's/.git//g'`
while read -r repo; do
    echo "=== ${repo} ==="
    BRANCHES=`git -C $repo branch | grep $SEARCHBRANCH`
    if (( `echo "${BRANCHES}" | wc -l` > 1 )); then
        echo "MULTIPLE BRANCHES IN REPO"
        echo "Multiple branches found @repo(${repo}) Make your selection:"
        arr=()
        while read -r branch; do
           arr+=("$branch")
           echo "${#arr[@]}) ${branch}"
        done <<< "$BRANCHES"

        read input </dev/tty
        selectedbranch="${arr["$((input - 1))"]//[ *]/}"

        STASH=`git -C $repo stash save "Changes stashed by bcheckout"`
        CHECKOUT=`git -C $repo checkout $selectedbranch`

    elif [[ -n "${BRANCHES/[ ]*\n/}" ]]; then
        echo "SINGLE BRANCH IN REPO ${BRANCHES//[ *]/}"

        STASH=`git -C $repo stash "Changes stashed by bcheckout"`
        CHECKOUT=`git -C $repo checkout ${BRANCHES//[ *]/}`
    else
        echo "NO BRANCH FOUND"
        DEVELOP=`git -C $repo branch | grep "develop"`

        if [[ -n "${DEVELOP/[ ]*\n/}" ]]; then
            STASH=`git -C $repo stash "Changes stashed by bcheckout"`
            CHECKOUT=`git -C $repo checkout ${DEVELOP//[ *]/}`
        fi
    fi
    echo ""
done <<< "$REPOS"
