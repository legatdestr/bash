#!/bin/bash

function setWebServerDocumentRootRights() {
  echo 'Установка прав на documentRoot';
}


function createUserGroups(){
  if ! isUserGroupExists "${C_USER_GROUP}"; then
       echo 'Создание групп';
       groupadd "${C_USER_GROUP}" ;
       process_step "Создание группы пользователей: ${C_USER_GROUP}";
     else
       process_step "Группа пользователей: ${C_USER_GROUP} уже существует";
  fi;
}

function createUser(){
  if ! isUserExists "${C_DEPLOY_USER}" ; then
    # создать юзера, добавить его в группу
    echo 'Я не работаю. Допиши меня!';
  fi;
}
