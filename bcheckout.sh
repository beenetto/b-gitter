source ./options.sh

PULLBRANCH="develop"
DEFAULTBRANCH="develop"


stash () {

    local MSG="Changes stashed by bcheckout"

    if [ "${STASHSKIP}" = false ]
    then

        if [ "${STASHASK}" = true ]
        then
            echo "Do you want to stash your changes? (y/n)"

            read input </dev/tty

            if [ "$input" = "n" ]; then
                return 1
            elif [ "$input" = "y" ]; then
                :
            else
                echo >&2 "WARNING: Bad option, not stashing."
                return 1
            fi
        fi
        STASH=`git -C ${1} stash save "${MSG}"`
        echo "${STASH}"
    fi
}

checkout () {

    if [ "${PULLSKIP}" = false ]
    then
        if [ "${PULLASK}" = true ]
        then
            echo "Do you want to pull develop? (y/n)"

            read input </dev/tty

            if [ "$input" = "n" ]; then
                # return 1
                :
            elif [ "$input" = "y" ]; then
                :
            else
                echo >&2 "WARNING: Bad option, not pulling."
                # return 1
                :
            fi
        fi
    fi

    CHECKOUT=`git -C "${1}" checkout ${2}`
    echo "${CHECKOUT}"
}


REPOS=`find $ROOTDIR -type d -name '.git' -print | sed 's/.git//g'`
while read -r repo; do
    echo "=== ${repo} ==="
    BRANCHES=`git -C $repo branch | grep $SEARCHBRANCH`
    if (( `echo "${BRANCHES}" | wc -l` > 1 )); then
        echo "Multiple branches found @repo(${repo}) Make your selection:"
        arr=()
        while read -r branch; do
           arr+=("$branch")
           echo "${#arr[@]}) ${branch}"
        done <<< "$BRANCHES"

        read input </dev/tty
        selectedbranch="${arr["$((input - 1))"]//[ *]/}"

        stash $repo
        checkout $repo $selectedbranch

    elif [[ -n "${BRANCHES/[ ]*\n/}" ]]; then
        echo "SINGLE BRANCH IN REPO ${BRANCHES//[ *]/}"

        stash $repo
        checkout $repo ${BRANCHES//[ *]/}
    else
        echo "NO BRANCH FOUND"
        DEVELOP=`git -C $repo branch | grep "develop"`

        if [[ -n "${DEVELOP/[ ]*\n/}" ]]; then

            stash $repo
            checkout $repo ${DEVELOP//[ *]/}
        fi
    fi
    echo ""
done <<< "$REPOS"
