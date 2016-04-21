#!/bin/bash

function installGit () {
  info 'Установка Git';
  yum install git -y;
}
