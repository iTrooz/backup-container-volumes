#!/bin/sh
set -e

# Get the raw backup directory from the first argument
RAW_BACKUP_DIR=$1
echo "Using raw backup folder $RAW_BACKUP_DIR" >&2

# Find all .resticignore files under the backup directory
find "$RAW_BACKUP_DIR" -name '.resticignore' -type f | while read -r ignore_file; do
    echo "Found file $ignore_file" >&2
    ignore_dir=$(dirname "$ignore_file")
    # Read each line in the .resticignore file
    while read -r line; do
        # If the line is not empty
        [ -n "$line" ] && {
            case "$line" in
                # If the line starts with '!', keep the '!' in first position
                '!'*) echo "!${ignore_dir}/${line#!}" ;;
                # Otherwise, prepend the directory path
                *) echo "${ignore_dir}/${line}" ;;
            esac
        }
    done < "$ignore_file"
done