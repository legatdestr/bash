#!/bin/bash

function installNodejs () {
  info 'Установка NodeJS';
  curl --location https://rpm.nodesource.com/setup_5.x | bash - ;
  yum -y install nodejs;
  if [ -n "${C_PROXY_URI}" ]; then
      npm config set proxy "${C_PROXY_URI}";
  fi;
}
