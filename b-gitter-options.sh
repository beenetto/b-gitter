#!/bin/bash


while [ -n "$1" ]; do
        # Copy so we can modify it (can't modify $1)
        OPT="$1"
        # Detect argument termination
        if [ x"$OPT" = x"--" ]; then
                shift
                for OPT ; do
                        REMAINS="$REMAINS \"$OPT\""
                done
                break
        fi
        # Parse current opt
        while [ x"$OPT" != x"-" ] ; do
                case "$OPT" in
                        # Handle --flag=value opts like this
                        -rd=* | --rootdir=* )
                                ROOTDIR="${OPT#*=}"
                                shift
                                ;;
                        # and --flag value opts like this
                        -rd* | --rootdir )
                                ROOTDIR="$2"
                                shift
                                ;;
                        -pall* | --pullall )
                                PULLALL=true
                                ;;
                        -pask* | --pullask )
                                PULLASK=true
                                ;;
                        -sskip* | --stashskip )
                                STASHSKIP=true
                                ;;
                        -sask* | --stashask )
                                STASHASK=true
                                ;;
                        -st* | --status )
                                STATUS=true
                                ;;
                        # Anything unknown is recorded for later
                        * )
                                REMAINS="$REMAINS \"$OPT\""
                                break
                                ;;
                esac
                # Check for multiple short options
                # NOTICE: be sure to update this pattern to match valid options
                NEXTOPT="${OPT#-[cfr]}" # try removing single short opt
                if [ x"$OPT" != x"$NEXTOPT" ] ; then
                        OPT="-$NEXTOPT"  # multiple short opts, keep going
                else
                        break  # long form, exit inner loop
                fi
        done
        # Done with that param. move to next
        shift
done
# Set the non-parameters back into the positional parameters ($1 $2 ..)
eval set -- $REMAINS

if [[ -n "${1/[ ]*\n/}" ]] && [ "${STATUS}" = false ]; then

    SEARCHBRANCH="$1"

elif [ "${STATUS}" = true ]; then

    SEARCHBRANCH='\"*\"'

else
    echo >&2 "ERROR: You need to specify a search therm for the branch name."
    echo "...exiting"
    exit
fi

if [[ -z "${ROOTDIR}" ]]; then
    echo >&2 "ERROR: No root directory specified. Use -rd or --rootdir"
    echo "...exiting"
    exit
fi
