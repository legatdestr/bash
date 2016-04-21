#!/bin/bash

TIME=$(date +%s)

DATE=`date +%F`
HOME_DIR='/home/git'
GIT_DIR='/home/git/dev_misbars'
HTML_DIR='/var/www/html'
DIF_DIR='/home/git/differences'
DEVELOPER=$1
MESSAGE_CREATE () {
        case $2 in
        info)
                MESSAGE_INFO=`echo "${MESSAGE_INFO}${1}"\\\n`
        ;;
        warn)
                MESSAGE_WARN=`echo "${MESSAGE_WARN}${1}"\\\n`
        ;;
        err)
                MESSAGE_ERR=`echo "${MESSAGE_ERR}${1}"\\\n`
        ;;
        esac
}
MESSAGE_FORMAT () {
	echo $1 | sed "s///"
}
MESSAGE_SEND () {
	curl -H "Content-Type: application/json" -X POST -d '{"list": [{"message": "'"$1"'", "markdown": false, "recipient": ["'"$2"'"]}], "suid": "56436dcc-8f6d-11e5-aa8d-002590d470dd"}' https://telegram.em70.ru/send &>/dev/null
}





MESSAGE_CREATE "<<<<<<<<<<Тестовая МИС>>>>>>>>>>" info


ADD_FILES=`diff -rq $GIT_DIR $HTML_DIR | grep "Only in $HTML_DIR" | sed "s/Only in //" | sed "s/: /\//"`
for FILES in $ADD_FILES; do
	MESSAGE_CREATE ">>> $FILES" warn
done
ADD="add_files_${DATE}_`date +%H:%M:%S`.tgz"
if [ "$ADD_FILES" != "" ]; then
	MESSAGE_CREATE "Добавленные файлы - http://testmis.med/diff/$ADD" warn
	tar czvf "$DIF_DIR/$ADD" $ADD_FILES &> /dev/null
fi


DEL_FILES=`diff --exclude=".git" -rq $GIT_DIR $HTML_DIR | grep "Only in $GIT_DIR" | sed "s/Only in //" | sed "s/: /\//"`
for FILES in $DEL_FILES; do
        MESSAGE_CREATE ">>> $FILES" warn
done
DEL="del_files_${DATE}_`date +%H:%M:%S`.tgz"
if [ "$DEL_FILES" != "" ]; then
	MESSAGE_CREATE "Удалённые файлы - http://testmis.med/diff/$DEL" warn
	tar czvf "$DIF_DIR/$DEL" $DEL_FILES &> /dev/null
fi


DIF_FILES=`diff -rq $GIT_DIR $HTML_DIR | grep "Files" | awk -F " " '{print $4}'`
for FILES in $DIF_FILES; do
        MESSAGE_CREATE ">>> $FILES" warn
done
DIF="dif_files_${DATE}_`date +%H:%M:%S`.tgz"
if [ "$DIF_FILES" != "" ]; then
	MESSAGE_CREATE "Изменённые файлы - http://testmis.med/diff/$DIF" warn
	tar czvf "$DIF_DIR/$DIF" $DIF_FILES &> /dev/null
fi



cd $GIT_DIR

git pull
WORK_TREE=`git log | sed q | sed 's/commit /\/home\/git\//g'`
mkdir $WORK_TREE
MESSAGE_CREATE "Директория для загрузки - $WORK_TREE" info
git --work-tree=$WORK_TREE checkout -f master

if [ $? -eq 0 ]; then
	ln -sfn $WORK_TREE /home/git/html

	cd $HOME_DIR
	LIST=`find -maxdepth 1 -type d -mtime +1 | sed -rn '/.{40,}/p' | sed 's/.\///'`
	for FOLDER in $LIST; do
		rm -rf $FOLDER
	done

	MESSAGE_CREATE "Готово!" info
	MESSAGE_CREATE "Скрипт выполнен за $(($(date +%s)-$TIME)) сек." info
	MESSAGE_CREATE "Не забывайте актуализировать кэш браузера - CTRL+F5" info
else
	MESSSAGE_CREATE "Что-то пошло не так... Обратитесь к системному администратору." err
	exit 0
fi
MESSAGE_CREATE ">>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<" info

MESSAGE_SEND "$MESSAGE_INFO" $DEVELOPER
MESSAGE_SEND "$MESSAGE_WARN" "otdel_razrab_bars"
MESSAGE_SEND "$MESSAGE_ERR" $DEVELOPER
