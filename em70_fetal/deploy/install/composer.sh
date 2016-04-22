#!/bin/bash

function installComposer () {
  wget https://getcomposer.org/composer.phar;
  process_step 'Скачаивание composer.phar для PHP Composer';
  mv composer.phar /usr/local/bin/composer;
  process_step 'Перемещение composer.phar  в /usr/local/bin/composer . Делаем глобально доступным.';
  chmod +x /usr/local/bin/composer;
  process_step 'Делаем composer исполняемым';
  php /usr/local/bin/composer global require "fxp/composer-asset-plugin:~1.1.1" ;
  process_step 'Установка пакета fxp/composer-asset-plugin для Composer';
  if command -v composer >/dev/null 2>&1 ; then
    info 'Composer установлен';
  else
    warning 'Composer. Установка не удалась';
  fi;
}
