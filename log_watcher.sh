#!/bin/bash

cnt_fail=0
cnt_ok=0
mail=0
i=0
EMAIL=$2

if [ -z $1 ] || [ $1 == '--help' ] || [ $1 == '-help' ] || [ $1 == '--about' ] || [ $1 == '-about' ];
 then
 echo 'please specify log file path, ex log_watcher.sh <file path> <alert email>'
 exit 1
elif [ ! -f $1 ]; then
 echo "$1 file not exist"
 exit 1
fi

if [ -z $2 ]; then
 echo 'alerts email was not specified'
 exit 1
fi

tail -Fn0 $1 |  \
while read LINE;
do
 ((i = `echo $LINE | awk '{print $4}'`))
 if [ $i -gt 10 ];
  then
   ((cnt_fail = cnt_fail + 1))
   if [ $cnt_fail -ge 3 ] && [ $mail -eq 0 ];
   then
     ((mail = 1))
     mail -s "NOTIFICATION: DOWN" $EMAIL
     #echo "send mail about problem $EMAIL"
     ((cnt_fail = 0))
   fi
  elif [ $i -le 10 ];
  then
    ((cnt_fail = 0))
    if [ $mail -eq 1 ];
    then
      ((cnt_ok = cnt_ok + 1))
      if [ $cnt_ok -ge 3 ];
      then
        #echo "send mail about ok $EMAIL"
        mail -s "NOTIFICATION: UP" $EMAIL
        ((mail = 0))
      fi
    else
     continue
    fi
  else
  ((cnt_fail = 0))
   continue
  fi
done
