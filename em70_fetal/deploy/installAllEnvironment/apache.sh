#!/bin/bash


function apacheEnableModRewrite () {
  info 'Apache. Попытка включить поддержку mod_rewrite...';
  local destFileName='httpd.conf_tmp';
  sed -e '/<Directory "\/var\/www\/html">/,/<\/Directory>/c\<Directory "\/var\/www\/html">\n   Options Indexes FollowSymLinks\n  AllowOverride All\n  Require all granted\n</Directory>' /etc/httpd/conf/httpd.conf >/tmp/"${destFileName}" ;    
  process_step 'Apache. Патчинг httpd.conf и сохранение в tmp';
  mv -f /tmp/"${destFileName}" /etc/httpd/conf/httpd.conf;
  process_step 'Apache. Перезапись /etc/httpd/conf/httpd.conf из tmp';
}

function installApache() {
  yum install httpd -y -y;
  process_step 'Apache. Установка.';
  systemctl start httpd;
  process_step 'Apache. Запуск службы httpd';
  #автозапуск службы
  systemctl enable httpd;
  process_step 'Apache. Включение автозапуска службы httpd';
  if [ `systemctl is-enabled httpd` !='enabled' ]; then
    warning 'Apache. Служба Apache не запустилась.';
  fi;
}
