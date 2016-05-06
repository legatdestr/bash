#!/bin/bash

function installComposer () {
  cd /tmp;
  curl -sS https://getcomposer.org/installer | php ;
  process_step 'Скачивание composer.phar для PHP Composer';
  mv composer.phar /usr/local/bin/composer && chmod ugo+x /usr/local/bin/composer;
  process_step 'Перемещение composer.phar  в /usr/local/bin/composer . Делаем глобально доступным и даем права.';
  /usr/local/bin/composer global require "fxp/composer-asset-plugin:~1.1.1" ;
  process_step 'Установка пакета fxp/composer-asset-plugin для Composer';
  if command -v composer >/dev/null 2>&1 ; then
    info 'Composer установлен';
  else
    warning 'Composer. Команда composer для su не доступна';
    if [ -f /usr/local/bin/composer ]; then
      warning 'Если команда composer у вас не работает, вызывайте так: /usr/local/bin/composer';
    fi;
  fi;
}
