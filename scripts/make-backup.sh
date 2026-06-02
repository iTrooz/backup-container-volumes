#!/bin/sh
set -e
SCRIPT_DIR=$(realpath $(dirname $0))

$SCRIPT_DIR/raw-backup.sh
$SCRIPT_DIR/smart-backup.sh
