#!/bin/bash

# Репозиторий уже существует?
function isRepositoryCloned () {
    if ! isDirectory "${C_GIT_CLONE_DIR}" ; then 
      process_step 'Проект не проинициализирован.'
      return 1;
    else 
      return 0;  
    fi;
}


# Клонирует репозиторий проекта
function cloneGit() {
    git clone "${C_GIT_CLONE_STRING}" "${C_GIT_CLONE_DIR}";
}