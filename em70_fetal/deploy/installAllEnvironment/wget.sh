#!/bin/bash

function installWget () {
  yum install wget -y;
  process_step 'Установка Wget';
}
