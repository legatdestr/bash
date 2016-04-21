#!/bin/bash

function installApache() {
  yum install httpd -y -y;
  systemctl start httpd;
  #автозапуск службы
  systemctl enable httpd;
  if [ `systemctl is-enabled httpd` !='enabled' ]; then
    warning 'Служба Apache не запустилась.';
  fi;
}
