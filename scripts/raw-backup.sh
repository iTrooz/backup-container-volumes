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

RAW_BACKUP_DIR="/raw-backups"
SCRIPT_DIR=$(realpath $(dirname $0))

echo "$0: Backuping up to restic"
EXCLUDE_FLAGS=$(find $RAW_BACKUP_DIR -name ".resticignore" -exec printf -- '--exclude-file=%s ' {} \;)
set -x
restic backup $RAW_BACKUP_DIR --verbose --exclude-file <($SCRIPT_DIR/gen-exclusion-list.sh $RAW_BACKUP_DIR) $@ # You shouldn't need these extra args
set +x
echo "$0: Backed up to restic"
