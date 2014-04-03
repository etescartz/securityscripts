#!/bin/bash

#============================================#
#        User configuration section          #
#============================================#

# email subject for detection of infected items
SUBJECT="CKKROOTKIT findings on `hostname`!!!"
# Email To ?
EMAIL="example@domain.com"
# Log location
LOG=/tmp/chkrootkit.log

#============================================#

check_scan () {

ionice -c3 nice -n 19 /usr/sbin/chkrootkit -q > ${LOG}

EMAILMESSAGE=`mktemp /tmp/rkhunter-virus-alert.XXXXX`
                           echo "To: ${EMAIL}" >>  ${EMAILMESSAGE}
                           echo "From: root@localhost.localdomain" >>  ${EMAILMESSAGE}
                           echo "Subject: ${SUBJECT}" >>  ${EMAILMESSAGE}
                           echo "Importance: High" >> ${EMAILMESSAGE}
                           echo "X-Priority: 1" >> ${EMAILMESSAGE}
                           echo "`tail -n 29 ${LOG}`" >> ${EMAILMESSAGE}
                           sendmail -t < ${EMAILMESSAGE}
}

check_scan