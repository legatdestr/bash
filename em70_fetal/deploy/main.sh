#!/usr/bin/env bash

TIME=$(date +%s);

C_CONFIG_FILE_PATH='./config.cfg';
C_LIB_DIR="./lib";


# Файл конфигурации
source "${C_CONFIG_FILE_PATH}";
[[ $? -ne 0  ]] && echo "Error: ${C_CONFIG_FILE_PATH}" && exit 1;

# Общие функции
source "${C_LIB_DIR}"/"common.sh";
process_step 'Подключение common.sh';

# Функции для работы со SPA
source "${C_LIB_DIR}"/"spa.sh";
process_step 'Подключение spa.sh';


# Функции для работы с GIT проекта
source "${C_LIB_DIR}"/"git.sh";
process_step 'Подключение git.sh'

# Функции для работы с БД
source "${C_LIB_DIR}"/"db.sh";
process_step 'Подключение db.sh'



# Вызывается при завершении работы скрипта.
# Здесь можно чистить временные директории к примеру
function cleanup_before_exit () {
  if [[ $? -ne 0  ]] ; then
    alert "ОШИБКА. Работа скрипта завершена.";
    exit 1;
  else
    notice "Работа скрипта завершена. Похоже все ОК";
  fi;
  cd "${__dir}";
}
trap cleanup_before_exit EXIT;
trap exit ERR;

info "__file: ${__file}";
info "__dir: ${__dir}";
info "__os: ${__os}";


if ! isRepositoryCloned ; then
   process_step 'Инициализация. Клонируем репозиторий';
   cloneGit;
else
  :;
  process_step 'Каталог репозитория найден. Клонировать не нужно.';
fi;

#process_step "Подготовка SPA";
#initSpa;
#process_step "Сборка SPA";
#buildSpa;
#deploySpa;

testDbEnvironment;

info "Скрипт выполнен за $(($(date +%s)-$TIME)) сек.";
