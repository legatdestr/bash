#!/bin/bash

if [ -n "${C_PROXY_URI}" ]; then
    info 'Настройка proxy текущего пользователя (настройки считываются из config.cfg)';
    
    export http_proxy="${C_PROXY_STRING}";
    export https_proxy="${C_PROXY_STRING}";
    process_step 'Установка сессионных переменных: http_proxy, https_proxy';

    touch ~/.curlrc;
    process_step 'Создание файла настроек ~/.curlrc (если еще не существует)';

    if ! grep -Fxq "proxy=${C_PROXY_URI}" ~/.curlrc ; then
      echo "proxy=${C_PROXY_URI}" >> ~/.curlrc;
      process_step 'Установка PROXY для curl (~/.curlrc)';
    fi ;

fi;
