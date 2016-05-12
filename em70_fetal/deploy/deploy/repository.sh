#!/bin/bash

function runRepositoryModule(){
  if ! isPackageInstalled 'git'; then
    PrintPackageNotInstalled 'git';
  else
     if [ ! -d "${C_GIT_CLONE_DIR}" ]; then
       # Директория репозитория не создана
       mkdir -p "${C_GIT_CLONE_DIR}";
       process_step 'GIT. Создание директории репозитория: '"${C_GIT_CLONE_DIR}";
       info 'GIT. Клонируем репозиторий: ${C_GIT_CLONE_STRING}  ...';
       git clone -q  "${C_GIT_CLONE_STRING}" "${C_GIT_CLONE_DIR}" ;
       process_step 'GIT. Клонирование репозитория';
     else
       # Директория репозитория существует
       cd "${C_GIT_CLONE_DIR}";
       process_step 'GIT. Смена текущей директории на директорию репозитория: '"${C_GIT_CLONE_DIR}";
       git clean -f;
       process_step 'GIT. Удаление не отслеживаемых файлов (если кто-то забыл правильно настроить .gitignore)';
       git reset --hard HEAD ;
       git pull;
       process_step 'GIT. Pull репозитория'; 
     fi;
  fi;
}

function updateGitRevisionFile () {
   cd "${C_GIT_CLONE_DIR}";
   echo  "$(git rev-parse HEAD)" > "${C_GIT_REVISION_FILE}";
   process_step 'Запись ревизии в файл';
}