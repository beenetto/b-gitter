#!/usr/bin/env bash

# NOTICE: Uncomment if your script depends on bashisms.
#if [ -z "$BASH_VERSION" ]; then bash $0 $@ ; exit $? ; fi

echo "Before"
for i ; do echo - $i ; done


# Code template for parsing command line parameters using only portable shell
# code, while handling both long and short params, handling '-f file' and
# '-f=file' style param data and also capturing non-parameters to be inserted
# back into the shell positional parameters.

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
                        -c=* | --config=* )
                                CONFIGFILE="${OPT#*=}"
                                shift
                                ;;
                        # and --flag value opts like this
                        -c* | --config )
                                CONFIGFILE="$2"
                                shift
                                ;;
                        -f* | --force )
                                FORCE=true
                                ;;
                        -r* | --retry )
                                RETRY=true
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


echo -e "After: \n configfile='$CONFIGFILE' \n force='$FORCE' \n retry='$RETRY' \n remains='$REMAINS'"
for i ; do echo - $i ; done
