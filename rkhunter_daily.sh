#!/bin/bash

# email subject for detection of infected items
SUBJECT="VIRUS DETECTED ON `hostname`!!!"
#email subject for no infected items
SUBJECTOK="rkhunter Daily Run `hostname` = OK"
# Email To ?
EMAIL="example@domain.com"
# Log location
LOG=/var/log/rkhunter.log

rkunter_scan () {
ionice -c3 nice -n 19 /usr/local/bin/rkhunter --versioncheck
ionice -c3 nice -n 19 /usr/local/bin/rkhunter --update
ionice -c3 nice -n 19 /usr/local/bin/rkhunter -c -sk
}

check_scan () {

    # Check the last set of results. If there are any "Infected" counts that aren't zero, we have a problem.
    if [ `tail -n 19 ${LOG}  | grep Suspect | grep files | awk '{ print $4 }'` != 0 ] ||  [ `tail -n 19 ${LOG} | grep Possible | grep rootkits | awk '{ print $4 }'` != 0 ] || [ `tail -n 19 ${LOG} | grep Suspect | grep applications | awk '{ print $4 }'` != 0 ];
                      then
                           EMAILMESSAGE=`mktemp /tmp/rkhunter-virus-alert.XXXXX`
                           echo "To: ${EMAIL}" >>  ${EMAILMESSAGE}
                           echo "From: root@localhost.localdomain" >>  ${EMAILMESSAGE}
                           echo "Subject: ${SUBJECT}" >>  ${EMAILMESSAGE}
                           echo "Importance: High" >> ${EMAILMESSAGE}
                           echo "X-Priority: 1" >> ${EMAILMESSAGE}
                           echo "`tail -n 19 ${LOG}`" >> ${EMAILMESSAGE}
                           sendmail -t < ${EMAILMESSAGE}
                      else
    	                   EMAILMESSAGE=`mktemp /tmp/virus-virus-alert.XXXXX`
    	                   echo "To: ${EMAIL}" >>  ${EMAILMESSAGE}
    	                   echo "From: root@localhost.localdomain" >>  ${EMAILMESSAGE}
    	                   echo "Subject: ${SUBJECTOK}" >>  ${EMAILMESSAGE}
    	                   echo "X-Priority: 1" >> ${EMAILMESSAGE}
    	                   echo "Daily rkhunters scan completed with 0 infected items discovered" >> ${EMAILMESSAGE}
    	                   sendmail -t < ${EMAILMESSAGE}
     fi

}

rkunter_scan

check_scan
