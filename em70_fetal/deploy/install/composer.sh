#!/bin/bash

function installComposer () {
  info 'Установка composer';
  wget https://getcomposer.org/composer.phar;
  mv composer.phar /usr/local/bin/composer;
  chmod +x /usr/local/bin/composer;
  php /usr/local/bin/composer global require "fxp/composer-asset-plugin:~1.1.1" ;
  if command -v composer >/dev/null 2>&1 ; then
    info 'Composer установлен';
  else
    warning 'Composer. Установка не удалась';
  fi;
}
