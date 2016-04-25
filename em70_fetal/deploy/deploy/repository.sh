#!/bin/bash



function runRepositoryModule(){
  if ! isPackageInstalled 'git'; then
    PrintPackageNotInstalled 'git';
  else
    # пакет GIT умтановлен.
    echo "${C_GIT_CLONE_DIR}";
     if [ ! -d "${C_GIT_CLONE_DIR}" ]; then
       # Директория репозитория не создана
       mkdir -p "${C_GIT_CLONE_DIR}";
       process_step 'Создание директории репозитория: '"${C_GIT_CLONE_DIR}";
       git clone  "${C_GIT_CLONE_STRING}" "${C_GIT_CLONE_DIR}" ;
       process_step 'Клонирование репозитория';
     else
       # Директория репозитория существует
       cd "${C_GIT_CLONE_DIR}";
       process_step 'Смена текущей директории на директорию репозитория: '"${C_GIT_CLONE_DIR}";
       echo  "$(git rev-parse HEAD)" > "${C_GIT_REVISION_FILE}";
       # запись ревизии в файл
       git pull;
       process_step 'Pull репозитория';
     fi;
  fi;
}

runRepositoryModule;