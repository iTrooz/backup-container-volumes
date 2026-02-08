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

echo "$0: Starting backup process"

SMART_BACKUP_DIR="/tmp/smart-backups"
rm -rf $SMART_BACKUP_DIR
mkdir $SMART_BACKUP_DIR

for CONTAINER in $POSTGRES_CONTAINERS; do
  mkdir $SMART_BACKUP_DIR/$CONTAINER
  echo "Dumping postgres container $CONTAINER"
  docker exec -t $CONTAINER sh -c 'PGPASSWORD=$POSTGRES_PASSWORD pg_dumpall -c -U $POSTGRES_USER' > $SMART_BACKUP_DIR/$CONTAINER/all-databases.sql
  echo "Dumped postgres container $CONTAINER"
done

for CONTAINER in $MARIADB_CONTAINERS; do
  mkdir $SMART_BACKUP_DIR/$CONTAINER
  echo "DumpingPOSTGRES_CONTAINERS mariadb container $CONTAINER"
  SCRIPT='
  if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
    USER="root"
    PASSWORD=$MYSQL_ROOT_PASSWORD
  else
    USER=$MYSQL_USER
    PASSWORD=$MYSQL_PASSWORD
  fi
  mysqldump -u $USER --password=$PASSWORD --all-databases
  '
  docker exec -t $CONTAINER sh -c "$SCRIPT" > $SMART_BACKUP_DIR/$CONTAINER/all-databases.sql
  echo "Dumped mariadb container $CONTAINER"
done

echo "$0: Backuping up to restic"
restic backup $SMART_BACKUP_DIR
echo "$0: Backed up to restic"
