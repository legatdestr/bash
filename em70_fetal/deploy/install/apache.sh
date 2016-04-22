#!/bin/bash

function installApache() {
  yum install httpd -y -y;
  process_step 'Установка Apache';
  systemctl start httpd;
  process_step 'Запуск службы httpd';
  #автозапуск службы
  systemctl enable httpd;
  process_step 'Включение автозапуска службы httpd';
  if [ `systemctl is-enabled httpd` !='enabled' ]; then
    warning 'Служба Apache не запустилась.';
  fi;
}
