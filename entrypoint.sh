#!/bin/sh
set -xe
echo "$CRON_SCHEDULE /scripts/smart-backup.sh" > /var/spool/cron/crontabs/root
echo "$CRON_SCHEDULE sleep 30; /scripts/raw-backup.sh" >> /var/spool/cron/crontabs/root
echo "$CRON_SCHEDULE sleep 60; /scripts/restic-forget.sh" >> /var/spool/cron/crontabs/root

exec tini -- crond -f -d 8
