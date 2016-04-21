#!/bin/bash

CONFIG_DIR='./config.cfg';

BASE_DIR=$(dirname $(readlink -f $0));
if [[ ! -d $BASE_DIR ]]; then
  echo "${BASE_DIR} directory does not exists (BASE_DIR)" 1>&2;
  exit 1;
fi;
source ${BASE_DIR}/"${CONFIG_DIR}";
. ${BASE_DIR}/common.sh;


ASK_YES_NO 'Вы уверены, что хотите запустить скрипт?' || exit;

exit 0;


if [[ ! -e ${GIT_DIR} ]]; then
    mkdir -p ${GIT_DIR};
    echo "${GIT_DIR} has been created directories" 1>&2
elif [[ ! -d $dir ]]; then
    echo "${GIT_DIR} already exists but is not a directory" 1>&2
fi

cd ${GIT_DIR};

if [ "$?" != "0" ]; then
  echo "Cannot change directory!" 1>&2;
  exit 1;
fi

#git clone ${GIT_CLONE_STRING} ;
#git clone
