#!/bin/bash

function installWget () {
  info 'Установка Wget';
  yum install wget -y;
}
