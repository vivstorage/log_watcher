#!/bin/bash
#mailx package required

cnt_fail=0
cnt_ok=0
mail_sent=false
watch_row=0
FILE=$1
EMAIL=$2

if [ -z $FILE ] || [ $FILE == '--help' ] || [ $FILE == '-help' ] || [ $FILE == '--about' ] || [ $FILE == '-about' ];
 then
 echo 'please specify log file path, ex log_watcher.sh <file path> <alert email>'
 exit 1
elif [ ! -f $FILE ]; then
 echo "$FILE file not exist"
 exit 1
fi

if [ -z $EMAIL ]; then
 echo 'alerts email was not specified'
 exit 1
fi

tail -Fn0 $FILE |  \
while read LINE;
do
 ((watch_row = `echo $LINE | awk '{print $4}'`))
 if [ $watch_row -gt 10 ];
  then
   ((cnt_fail = cnt_fail + 1))
   if [ $cnt_fail -ge 3 ] && [ ! $mail_sent ];
   then
     ((mail_sent = true))
     mail -s "NOTIFICATION: DOWN" $EMAIL
     #echo "send mail about problem $EMAIL"
     ((cnt_fail = 0))
   fi
  elif [ $watch_row -le 10 ];
  then
    ((cnt_fail = 0))
    if [ $mail_sent ];
    then
      ((cnt_ok = cnt_ok + 1))
      if [ $cnt_ok -ge 3 ];
      then
        #echo "send mail about ok $EMAIL"
        mail -s "NOTIFICATION: UP" $EMAIL
        ((mail_sent = false))
      fi
    else
     continue
    fi
  else
  ((cnt_fail = 0))
   continue
  fi
done
