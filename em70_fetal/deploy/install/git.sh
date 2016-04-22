#!/bin/bash

function installGit () {
  yum install git -y;
  process_step 'Установка git';
}
