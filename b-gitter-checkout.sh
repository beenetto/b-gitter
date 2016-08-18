#!/bin/bash

PULLBRANCH="develop" # default refresh branch
DEFAULTBRANCH="develop"

status () {
    ST=`git -C ${1} status`
    echo "${ST}"
}

stash () {

    local MSG="Changes stashed by bcheckout"

    if [ "${STASHSKIP}" = false ]
    then

        if [ "${STASHASK}" = true ]
        then
            echo "Do you want to stash your changes? [y, n]"
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

    CHECKOUT=`git -C "${1}" checkout ${2}`
    echo "${CHECKOUT}"

    if [ "${PULLASK}" = true ]
    then
        echo "Do you want to pull '$PULLBRANCH'? [y, n, b]"

        read input </dev/tty

        if [ "$input" = "n" ]; then
            return 1

        elif [ "$input" = "y" ]; then

            PULL=`git -C "${1}" pull origin develop`
            echo "${CHECKOUT}"

        elif [ "$input" = "b" ]; then
            read inputbranch </dev/tty
            if [[ -n "${inputbranch/[ ]*\n/}" ]]; then

                PULL=`git -C "${1}" pull origin develop`
                echo "${PULL}"

            fi
        else
            echo >&2 "WARNING: Bad option, not pulling."
            :
        fi
    fi
}


REPOS=`find $ROOTDIR -type d -name '.git' -print | sed 's/.git//g'`
while read -r repo; do
    echo ""
    echo -e "=== \033[1m${repo}\033[0m ==="
    BRANCH=`git -C $repo branch | grep $SEARCHBRANCH`

    if [ "${STATUS}" = true ]; then
        status $repo
        continue
    fi

    if (( `echo "${BRANCH}" | wc -l` > 1 )); then
        echo "Multiple branches found @repo(${repo}) Make your selection:"
        arr=()
        while read -r branch; do
           arr+=("$branch")
           echo "${#arr[@]}) ${branch}"
        done <<< "$BRANCH"

        read input </dev/tty
        selectedbranch="${arr["$((input - 1))"]//[ *]/}"

        stash $repo
        checkout $repo $selectedbranch

    elif [[ -n "${BRANCH/[ ]*\n/}" ]]; then
        echo "SINGLE BRANCH IN REPO ${BRANCH//[ *]/}"

        stash $repo
        checkout $repo ${BRANCH//[ *]/}
    else
        DEVELOP=`git -C $repo branch | grep "${DEFAULTBRANCH}"`
        if [[ -n "${DEVELOP/[ ]*\n/}" ]]; then

            stash $repo
            checkout $repo ${DEVELOP//[ *]/}
        fi
    fi
    echo ""
done <<< "$REPOS"
