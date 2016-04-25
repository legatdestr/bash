#!/bin/bash

if [ -n "${C_PROXY_URI}" ]; then
    info 'Настройка proxy (настройки считываются из config.cfg)';

    if ! grep -Fxq "${C_PROXY_STRING}" '/etc/yum.conf' ; then
      echo "${C_PROXY_STRING}" >> '/etc/yum.conf' ;
      process_step 'Установка PROXY для yum';
    fi ;
    
else
    info 'Proxy не был задан.';
fi;
