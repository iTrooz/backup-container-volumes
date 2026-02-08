#!/bin/sh
set -e
trap 'on_exit $?' EXIT
on_exit() {
    status=$1
    if [ $status -eq 0 ]; then
        echo "$0: Success"
    else
        echo "$0: Failure: $status"
    fi
}

restic forget --keep-daily 3 --keep-weekly 4 --keep-monthly 2 --prune
