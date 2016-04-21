#!/bin/bash

MESSAGE_CREATE () {
        case $2 in
        info)
                MESSAGE_INFO=`echo "${MESSAGE_INFO}${1}"\\\n`;
        ;;
        warn)
                MESSAGE_WARN=`echo "${MESSAGE_WARN}${1}"\\\n`
        ;;
        err)
                MESSAGE_ERR=`echo "${MESSAGE_ERR}${1}"\\\n`
        ;;
        esac
}



PROCESS_STEP () {
  
}

# ASK_YES_NO "Ты уверен, что хочешь запустить это?" || exit
ASK_YES_NO()
{
local AMSURE
if [ -n "$1" ] ; then
   read -n 1 -p "$1 (y/[n]): " AMSURE
else
   read -n 1 AMSURE
fi
echo "" 1>&2
if [ "$AMSURE" = "y" ] ; then
   return 0
else
   return 1
fi
}



CHECK_DIR()
{
  if ! [ -d "$1" ] ; then
     if [ -z "$2" ] ; then
        echo "!!Нет директории $1 - продолжение невозможно. Выходим." 1>&2
     else
        echo "$2" 1>&2
     fi
     exit 1
  fi
}



CHECK_FILE()
{
  if ! [ -f "$1" ] ; then
     if [ -z "$2" ] ; then
        echo "!!Нет файла $1 - продолжение невозможно. Выходим." 1>&2
     else
        echo "$2" 1>&2
     fi
     exit 1
  fi
}
