#!/bin/bash

function initDb () {
  if  [ ! -d "${C_GIT_DB_DEPLOY_INIT_FILES_DIR}" ]; then
     process_step 'Директория файлов инициализации БД указана неверно: '"${C_GIT_DB_DEPLOY_INIT_FILES_DIR}";
  fi;
  
  psql -U "${C_DB_USER_DEPLOY}" -h "${C_DB_HOST_URI}" -d "template1"  -f "${C_GIT_DB_DEPLOY_INIT_FILES_DIR}/00init"
  process_step "Инициализация БД. Создание ролей и логинов доступа";
   
  local initSqlFile;
    # Поиск файлов
    # %f prints the filename, %p the whole path.
    # '###' is just a marker, to help cutting.
    # '-printf' to output name and path
    # cutoff the name in a last step 
  for initSqlFile in `find ${C_GIT_DB_DEPLOY_INIT_FILES_DIR} -type f -regex [0-9]*.* ! -name 00init -printf "%f###%p\n" | sort -n | sed 's/.*###//'` ; do
    if [ -f "${initSqlFile}" ] ; then
        psql -U "${C_DB_USER_DEPLOY}" -h "${C_DB_HOST_URI}" -d "${C_DB_DB_NAME}"  -f "${initSqlFile}";
        process_step "Инициализация БД. Применение файла ${initSqlFile}"; 
    fi;
  done;  
}