#!/bin/sh

# Repository secrets
export B2_ACCOUNT_ID=
export B2_ACCOUNT_KEY=
export RESTIC_PASSWORD=

# Backup config
REPOSITORY=
BACKUP_PATH=
LOG_FILE=

# Keep policy
KEEP_DAILY=7
KEEP_WEEKLY=4
KEEP_MONTHLY=12
KEEP_YEARLY=7

timestamp() {
  date "+%b %d %Y %T %Z"
}

print_seperator() {
  printf "\n\n"
  echo "-------------------------------------------------------------------------------" | tee -a $LOG_FILE
}

print_without_new_line() {
  echo $1 | tee -a $LOG_FILE
}

print_after_new_line() {
  printf "\n\n"
  echo $1 | tee -a $LOG_FILE
}

run_backup() {
  print_seperator
  print_without_new_line "$(timestamp): restic.sh started"

  print_after_new_line "Starting backup..."
  restic -r $REPOSITORY backup $BACKUP_PATH
  print_after_new_line "Applying backup policy..."
  restic -r $REPOSITORY forget --keep-daily $KEEP_DAILY --keep-weekly $KEEP_WEEKLY --keep-monthly $KEEP_MONTHLY --keep-yearly $KEEP_YEARLY | tee -a $LOG_FILE
  print_after_new_line "Pruning..."
  restic -r $REPOSITORY prune
  print_after_new_line "Checking repository for errors..."
  restic -r $REPOSITORY check | tee -a $LOG_FILE

  # insert timestamp into log
  print_seperator
  print_without_new_line "$(timestamp): restic.sh finished"
}

run_backup
