#!/bin/sh
USERNAME=myUsername
DIR_TO_BACKUP=/home/$USERNAME
HOW_MANY=3

#BACKUP_LOCATION= Add name of backup folder, here ( example: /media/externalHDD )
BACKUP_LOCATION=
DATE=`date +%Y-%m-%d`
FILENAME="$USERNAME_$DATE.tar.gz"
  
OLD_DATE=`date -d "-$HOW_MANY days" "+%Y-%m-%d"`
OLD_FILE="$USERNAME_$OLD_DATE.tar.gz"
BACKUP_FILE=$BACKUP_LOCATION/$FILENAME
OLD_BACKUP_FILE=$BACKUP_LOCATION/$OLD_FILE
     
echo "Creating backup file $BACKUP_FILE"
tar czf $BACKUP_FILE $DIR_TO_BACKUP 2>>error_$DATE.log
     
if [ -f $BACKUP_FILE ]
then
echo "Backup Done"
else
echo "Something went wrong"
`cat error_$DATE.log`
fi
 
if [ -f $OLD_BACKUP_FILE ]
then
echo "Removing File that is $HOW_MANY days old"
rm $OLD_BACKUP_FILE
echo "Removed $OLD_FILE"
fi

