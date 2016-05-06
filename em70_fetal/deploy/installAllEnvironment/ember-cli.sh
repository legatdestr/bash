#!/bin/bash

function setupProxyForNpmAndNodeModules () {
  if [ -n "${C_PROXY_URI}" ]; then
      npm config set proxy "${C_PROXY_URI}";
      process_step 'Установка PROXY для npm';
      touch ~/.bowerrc;
      process_step 'Установка PROXY для Bower. Создание файла ~/.bowerrc';
      echo {"proxy': '${C_PROXY_URI}', 'https-proxy':'${C_PROXY_URI}' }" > ~/.bowerrc;
      process_step 'Установка PROXY для Bower. Запись настроек в файл ~/.bowerrc';
  fi;
}


function installSpecificModules () {
   npm install -g jshint;
   process_step 'NodeJs. Установка глобально модуля jshint';
   npm install -g node-gyp;
   process_step 'NodeJs. Установка глобально модуля node-gyp';
   npm install -g marked ;
   process_step 'NodeJs. Установка глобально модуля marked';
   npm install -g lodash-node;
   process_step 'NodeJs. Установка глобально модуля lodash-node';  
}

function installEmberCli () {
  setupProxyForNpmAndNodeModules ;
  installSpecificModules ;
  npm install -g ember-cli;
  process_step 'Установка ember-cli';  
}