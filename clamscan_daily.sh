#!/bin/bash

#============================================#
#        User configuration section          #
#============================================#

# email subject for detection of infected items
SUBJECT="VIRUS DETECTED ON `hostname`!!!"
#email subject for no infected items
SUBJECTOK="ClamAV daily scan on `hostname` = OK"
# Email To ?
EMAIL="example@domain.com"
# Log location
LOG=/var/log/clamav/scan.log

#============================================#

check_scan () {

    # Check the last set of results. If there are any "Infected" counts that aren't zero, we have a problem.
    if [ `tail -n 12 ${LOG}  | grep Infected | grep -v 0 | wc -l` != 0 ]
    then
        EMAILMESSAGE=`mktemp /tmp/virus-alert.XXXXX`
        echo "To: ${EMAIL}" >>  ${EMAILMESSAGE}
        echo "From: root@localhost.localdomain" >>  ${EMAILMESSAGE}
        echo "Subject: ${SUBJECT}" >>  ${EMAILMESSAGE}
        echo "Importance: High" >> ${EMAILMESSAGE}
        echo "X-Priority: 1" >> ${EMAILMESSAGE}
        echo "`tail -n 50 ${LOG}`" >> ${EMAILMESSAGE}
        sendmail -t < ${EMAILMESSAGE}
    else
    	EMAILMESSAGE=`mktemp /tmp/virus-alert.XXXXX`
    	echo "To: ${EMAIL}" >>  ${EMAILMESSAGE}
    	echo "From: root@localhost.localdomain" >>  ${EMAILMESSAGE}
    	echo "Subject: ${SUBJECTOK}" >>  ${EMAILMESSAGE}
    	echo "X-Priority: 1" >> ${EMAILMESSAGE}
    	echo "Daily scan completed with 0 infected items discovered" >> ${EMAILMESSAGE}
    	sendmail -t < ${EMAILMESSAGE}
    fi

}

ionice -c3 nice -n 19 clamscan -r / --exclude-dir=/sys/ --quiet --infected --log=${LOG}

check_scan
