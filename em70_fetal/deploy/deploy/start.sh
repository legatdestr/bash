#!/usr/bin/env bash

TIME=$(date +%s);

C_CONFIG_FILE_PATH='../config.cfg';
C_LIB_DIR="../lib";
C_INSTALLATION_DIR='installAllEnvironment';


# Файл конфигурации
source "${C_CONFIG_FILE_PATH}";
if [[ $? -ne 0  ]]; then
  echo "Ошибка подключения файла конфигурации: ${C_CONFIG_FILE_PATH}";
  exit 1;
fi;

# Общие функции
source "${C_LIB_DIR}"/"common.sh";
if [[ $? -ne 0  ]] ; then
   echo "Ошибка подключения библиотеки: ${C_LIB_DIR}/common.sh";
   exit 1;
fi;
process_step 'Подключение библиотеки функций - common.sh';

# Вызывается при завершении работы скрипта.
# Здесь можно гарантированно удалить временные директории к примеру
function cleanup_before_exit () {
  if [[ $? -ne 0  ]] ; then
    alert "ОШИБКА. Что-то пошло не так.  Время выполнения: $(($(date +%s)-${TIME})) сек.";
    exit 1;
  else
    notice $(echo -e "Работа скрипта завершена. Похоже все ОК. Время выполнения: $(($(date +%s)-${TIME})) сек.");
  fi;

}
trap cleanup_before_exit EXIT;
trap exit ERR;


# ==================================MAIN========================================

# Установка прокси текущего пользователя
source "${C_LIB_DIR}/proxyUser.sh";
# Модули установки:#
#     Репозиторий.
#        Проверить, выгружен ли он? Если нет выгрузить, создать файл git_revision.txt
#        записать туда текущую ревизию.
#     инструмент миграции. Подтянуть зависимости, проверить наличие БД пакетов, если надо.
#     API, проверяем глобальные зависимости PHP, composer, подтягиваем локальные зависимости
#     SPA,  глобальные зависисмости NodeJs, Ember-cli, подтягиваем локальные зависимости
#     chart, проверяем глобальные
#
#
# проверить что все установлено:
#   пакет GIT
#   БД, пакет БД установлен, есть доступ в БД на уровне пользователя (elecard)
#   Apache
#   PHP
#   composer
#   ember-cli


source "./repository.sh";
source "${__dir}/deploy/spa.sh";
source "${__dir}/deploy/api.sh";
source "${__dir}/deploy/migration_setup.sh";
