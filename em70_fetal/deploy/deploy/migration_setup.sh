#!/bin/bash

function setupMigrationConfig () {
  # Cоздать копию файла настроек db.php 
  # Поместить его во временную директорию 
  # 
   if [ ! -d "${C_GIT_MIGRATION_TOOL_DIR}" ]; then
      process_step 'Директория миграций задана не верно : '"${C_GIT_MIGRATION_TOOL_DIR}";
    else
      cd "${C_GIT_MIGRATION_TOOL_DIR}";
      if [ ! -d  "${C_MIGRATION_TOOL_CONFIG_DIR}" ]; then 
         process_step "Каталог не найден: ${C_GIT_MIGRATION_TOOL_DIR}";                  
      fi;      
      
      if [ ! -f "${C_MIGRATION_TOOL_CONFIG_DB_DEPLOY_FILE}" ]; then
         info "Файл не найден: ${C_MIGRATION_TOOL_CONFIG_DB_DEPLOY_FILE}";
         if [ ! -f "${C_MIGRATION_TOOL_CONFIG_DB_FILE}" ] ; then
           process_step "Файл-образец не найден: ${C_MIGRATION_TOOL_CONFIG_DB_FILE} . Используется в качестве шаблона для миграций";
         fi;
         cp "${C_MIGRATION_TOOL_CONFIG_DB_FILE}" "${C_MIGRATION_TOOL_CONFIG_DB_DEPLOY_FILE}";
         process_step 'Создание файла настроек БД для миграций';
      fi; 
      
      sed -i "s/pgsql:host=.*/pgsql:host=${C_DB_HOST_URI};dbname=${C_DB_DB_NAME}'/g" "${C_MIGRATION_TOOL_CONFIG_DB_DEPLOY_FILE}";
      process_step 'Настройка dsn БД';
      sed -i "s/'username'.*/'username' => '${C_DB_USER_DEPLOY}'/g" "${C_MIGRATION_TOOL_CONFIG_DB_DEPLOY_FILE}";
      process_step "Задание имени пользователя - ${C_DB_USER_DEPLOY}";
      sed -i "s/'password'.*/'password' => '${C_DB_USER_DEPLOY_PASSWORD}'/g" "${C_MIGRATION_TOOL_CONFIG_DB_DEPLOY_FILE}";
      process_step "Задание пароля для пользователя ${C_DB_USER_DEPLOY}";
   fi;
}


function runMigrationModule(){
   if [ ! -d "${C_GIT_MIGRATION_TOOL_DIR}" ]; then
      process_step 'Директория миграций задана не верно : '"${C_GIT_MIGRATION_TOOL_DIR}";
    else
      setupMigrationConfig ;
      # этот модуль ставится локально для текущего пользователя, поэтому лишний раз перестрахуемся
      /usr/local/bin/composer global require "fxp/composer-asset-plugin:~1.1.1" ;
      cd "${C_GIT_MIGRATION_TOOL_DIR}";
      composer update;
      chmod ug+x yii;
   fi;
}