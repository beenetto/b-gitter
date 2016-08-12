#!/bin/bash

SELFDIR="$(dirname "$0")"
REPOS=`find $ROOTDIR -type d -name '.git' -print | sed 's/.git//g'`

if [[ -n "${1/[ ]*\n/}" ]]; then

    SEARCHBRANCH="$1"

    source "${SELFDIR}"/b-gitter-options.sh
    source "${SELFDIR}"/b-gitter-checkout.sh
else
    source "${SELFDIR}"/b-gitter-create.sh
fi


