#!/bin/bash

cnt_fail=0
cnt_ok=0
mail=0
for i in `while true; tail -1 tail.log  | awk '{print $4}'`
do
 if [ $i -gt 10 ];
  then
   ((cnt_fail = cnt_fail + 1))
   if [ $cnt_fail -ge 3 ];
   then
     ((mail = 1))
     echo 'send mail about problem'
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
        echo 'send mail about ok'
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
