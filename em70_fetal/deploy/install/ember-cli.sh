#!/bin/bash

function installEmberCli () {
  npm install -g ember-cli;
  process_step 'Установка ember-cli';
  if [ -n "${C_PROXY_URI}" ]; then
      touch ~/.bowerrc;
      process_step 'Установка PROXY для Bower. Создание файла ~/.bowerrc';
      echo {"proxy': '${C_PROXY_URI}', 'https-proxy':'${C_PROXY_URI}' }" >> ~/.bowerrc;
      process_step 'Установка PROXY для Bower. Запись настроек в файл ~/.bowerrc';
  fi;
}
