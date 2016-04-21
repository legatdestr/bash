#!/bin/bash

if [ `systemctl is-enabled httpd` !='enabled' ]; then
  warning 'Служба Apache не запустилась.';
fi;
