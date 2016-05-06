#!/bin/bash


function runApiModule(){

  if [ ! -d "${C_GIT_API_DIR}" ]; then
    process_step 'Директория API указана неверно: '"${C_GIT_API_DIR}";
    exit 1;
  else
     cd "${C_GIT_API_DIR}";
     /usr/local/bin/composer install;

      if [ ! -d "${C_API_FRAMEWORK_DIR}" ]; then
          mkdir  -p "${C_API_FRAMEWORK_DIR}";
          process_step "Создание директории ${C_API_FRAMEWORK_DIR}";
        else
          rm -rf "${C_API_FRAMEWORK_DIR}/*";
          process_step "Очистка директории ${C_API_FRAMEWORK_DIR}";
      fi;

      cp -R "${C_GIT_API_DIR}/." "${C_API_FRAMEWORK_DIR}" ;
      process_step "Копирование файлов директории ${C_GIT_API_DIR}/. в ${C_API_FRAMEWORK_DIR}";

      
      if [ ! -d  "${C_API_FRAMEWORK_DIR}/runtime" ]; then
         warning "Директория ${C_API_FRAMEWORK_DIR}/runtime не существует.";
         mkdir -p "${C_API_FRAMEWORK_DIR}/runtime";
         process_step "Создание директории ${C_API_FRAMEWORK_DIR}/runtime";
      fi;
      
      chmod ug+rwx "${C_API_FRAMEWORK_DIR}/runtime";
      process_step "Установка прав для директории ${C_API_FRAMEWORK_DIR}/runtime";
      
      mkdir -p "${C_API_FRAMEWORK_DIR}/runtime/logs";
      process_step "Создание директории ${C_API_FRAMEWORK_DIR}/runtime/logs если она не существует";
      
      if [ ! -d  "${C_API_FRAMEWORK_DIR}/assets" ]; then
         warning "Директория ${C_API_FRAMEWORK_DIR}/assets не существует.";
         mkdir -p "${C_API_FRAMEWORK_DIR}/assets";
         process_step "Создание директории ${C_API_FRAMEWORK_DIR}/assets";
      fi;
      
      chmod ug+rwx "${C_API_FRAMEWORK_DIR}/assets";
      process_step "Установка прав для директории ${C_API_FRAMEWORK_DIR}/assets";
      
      

      if [ ! -d "${C_API_DEPLOY_DIR}" ]; then
          mkdir  -p "${C_API_DEPLOY_DIR}";
          process_step "Создание директории ${C_API_DEPLOY_DIR}";
        else
          rm -rf "${C_API_DEPLOY_DIR}/*";
          process_step "Очистка директории ${C_API_DEPLOY_DIR}";
      fi;
     cp -R web/* "${C_API_DEPLOY_DIR}/";
     process_step "Копирование файлов директории web/* в ${C_API_DEPLOY_DIR}/";
     sed -i  "s#require(__DIR__ . '/../vendor/autoload.php');#require('${C_API_FRAMEWORK_DIR}/vendor/autoload.php');#g" "${C_API_DEPLOY_DIR}/index.php";
     process_step 'Настройка path к autoload';
     sed -i  "s#require(__DIR__ . '/../vendor/yiisoft/yii2/Yii.php');#require('${C_API_FRAMEWORK_DIR}/vendor/yiisoft/yii2/Yii.php');#g" "${C_API_DEPLOY_DIR}/index.php";
     process_step 'Настройка path к фрэймворку';
     sed -i  "s#\$config = require(__DIR__ . '/../config/web.php');#require('${C_API_FRAMEWORK_DIR}/config/web.php');#g" "${C_API_DEPLOY_DIR}/index.php";
     process_step 'Настройка path к config';
     
     chmod ug+rwx "${C_API_DEPLOY_DIR}/assets";
     process_step "Установка прав для ${C_API_DEPLOY_DIR}/assets";
     
  fi;


}

