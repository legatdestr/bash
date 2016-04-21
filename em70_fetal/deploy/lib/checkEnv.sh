#!/bin/bash

#Проверка установленных пакетов из списка
#-----------------------------------------
#
#Вариант с командой dpkg -l

lst="nonexisting-package git"

dpkg -l 2>/dev/null > ls.tmp

for items in $lst
do
  cmd=$(grep "\ $items\ " ls.tmp)
  if [ $? == 0 ]
    then
      echo "$items installed (установлен)"
    else
      echo "$items NOT installed (не установлен)"
  fi
done

rm ls.tmp

exit 0