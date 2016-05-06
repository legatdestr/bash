#!/bin/bash


function disableSeLinuxPermissionSystem () {
  if [ -f  '/etc/selinux/config' ] ; then 
      sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config;  
      process_step 'Отключение (если включена) системы контроля доступа SELinux';
      shutdown 2 -r 1>/dev/null ;
      critical 'Система будет перезагружена через 2 минуты!';
    else 
      info 'Файл конфигурации SELinux не найден. Изменения в системе SELinux не были сделаны';
  fi;
}

function setWebServerDocumentRootRights () {
  chown -R "${C_DEPLOY_USER}:${C_DEPLOY_USER_GROUP}" /var/www;
  chmod -R g+rwxs /var/www;
  process_step 'Установка прав на documentRoot';
}


function createUserGroups (){
  if ! isUserGroupExists "${C_DEPLOY_USER_GROUP}"; then
       echo 'Создание групп';
       groupadd "${C_DEPLOY_USER_GROUP}" ;
       process_step "Создание группы пользователей: ${C_DEPLOY_USER_GROUP}";
     else
       notice "Группа пользователей: ${C_DEPLOY_USER_GROUP} уже существует";
  fi;
}

function createUser (){
  if ! isUserExists "${C_DEPLOY_USER}" ; then
    # создать юзера, добавить его в группу
    useradd -G "${C_DEPLOY_USER_GROUP}"  "${C_DEPLOY_USER}"
    #-p"${C_DEPLOY_USER_PASSWD}";
    echo -e "${C_DEPLOY_USER_PASSWD}\n${C_DEPLOY_USER_PASSWD}" | passwd "${C_DEPLOY_USER}";
    process_step "Создать пользователя: ${C_DEPLOY_USER}, добавить его в группу ${C_DEPLOY_USER_GROUP}, задать пароль (см. config.cfg)";
  else
    notice "Пользователь ${C_DEPLOY_USER} уже существует. Ничего с ним не делаем";
  fi;
}


function addApacheUserToFetalGroup() {
    usermod -a -G "${C_DEPLOY_USER_GROUP}" apache;
    process_step "Добавляем пользователя apache в группу ${C_DEPLOY_USER_GROUP}";
}
