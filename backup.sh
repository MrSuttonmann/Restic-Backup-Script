#!/bin/sh

export B2_ACCOUNT_ID=
export B2_ACCOUNT_KEY=
export RESTIC_PASSWORD=

REPOSITORY=
BACKUP_PATH=
LOG_FILE=

timestamp() {
  date "+%b %d %Y %T %Z"
}

printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a $LOG_FILE
echo "$(timestamp): restic.sh started" | tee -a $LOG_FILE


restic -r $REPOSITORY backup $BACKUP_PATH
restic -r $REPOSITORY forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 7 | tee -a $LOG_FILE
restic -r $REPOSITORY prune
restic -r $RESPOSITORY check | tee -a $LOG_FILE

# insert timestamp into log
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a $LOG_FILE
echo "$(timestamp): restic.sh finished" | tee -a $LOG_FILE
