#!/bin/bash

function installNodejs () {
  curl --location https://rpm.nodesource.com/setup_5.x | bash - ;
  process_step 'Скачивание и установка rpm для NodeJS';
  yum -y install nodejs;
  process_step 'Установка NodeJS';
  if [ -n "${C_PROXY_URI}" ]; then
      npm config set proxy "${C_PROXY_URI}";
      process_step 'Установка PROXY для npm';
  fi;
}
