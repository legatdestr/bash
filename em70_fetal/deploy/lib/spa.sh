#!/bin/bash


# Проверяет существование каталога развертывания SPA приложения 
function makeSpaDeployDir(){
  if ! isDirectory "${C_SPA_DEPLOY_DIR}" ; then
    notice "Каталог развертывания SPA не найден ${C_SPA_DEPLOY_DIR} "; 
    mkdir -p "${C_SPA_DEPLOY_DIR}";
    process_step "Создаем каталог ${C_SPA_DEPLOY_DIR}";
  fi;
}


# Подтягивает зависимости для сборки SPA проекта
function initSpa() {
   if ! isDirectory "${C_GIT_SPA_DIR}" ; then 
      process_step "Каталог SPA приложения в репозитории не найден: ${C_GIT_SPA_DIR}";
      return 1;
    else 
      cd "${C_GIT_SPA_DIR}";
      process_step "Инициализация SPA - модули NodeJs";
      npm update;
      process_step "Инициализация SPA - модули Bower";
      bower install;      
      makeSpaDeployDir;
      return 0;  
    fi;
}

# Выкладывает собранное приложение 
function deploySpa() {
  cd "${C_SPA_DEPLOY_DIR}";
  process_step "Чистим каталог ${C_SPA_DEPLOY_DIR}";
  rm -rf *;
  process_step "Копируем содержимое каталога ${C_GIT_SPA_DIST_DIR} в ${C_SPA_DEPLOY_DIR}";
  cp -Rf "${C_GIT_SPA_DIST_DIR}/." "${C_SPA_DEPLOY_DIR}";
  
}

# Собирает SPA приложение
function buildSpa() {
  if ! isDirectory "${C_GIT_SPA_DIR}" ; then 
      process_step "Каталог SPA приложения в репозитории не найден: ${C_GIT_SPA_DIR}";
      return 1;
    else 
      cd "${C_GIT_SPA_DIR}";
      process_step "Собираем SPA";
      ember build --environment=production;      
      return 0;  
    fi;  
}

