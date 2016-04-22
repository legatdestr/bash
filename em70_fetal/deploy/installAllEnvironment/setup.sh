#!/usr/bin/env bash

TIME=$(date +%s);

C_CONFIG_FILE_PATH='../config.cfg';
C_LIB_DIR="../lib";
C_INSTALLATION_DIR='installAllEnvironment';

# Файл конфигурации
source "${C_CONFIG_FILE_PATH}";
[[ $? -ne 0  ]] && echo "Ошибка подключения файла конфигурации: ${C_CONFIG_FILE_PATH}" && exit 1;

# Общие функции
source "${C_LIB_DIR}"/"common.sh";
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
# Выходим если не админ

regectIfNoRights ;

# Proxy
if [ -n "${C_PROXY_URI}" ]; then
    info 'Настройка proxy';

    if ! grep -Fxq "${C_PROXY_STRING}" '/etc/yum.conf' ; then
      echo "${C_PROXY_STRING}" >> '/etc/yum.conf' ;
      process_step 'Установка PROXY для yum';
    fi ;

    export http_proxy="${C_PROXY_STRING}";
    export https_proxy="${C_PROXY_STRING}";
    touch ~/.curlrc;

    if ! grep -Fxq "proxy=${C_PROXY_URI}" ~/.curlrc ; then
      echo "proxy=${C_PROXY_URI}" >> ~/.curlrc;
      process_step 'Установка PROXY для curl';
    fi ;

else
    info 'Proxy не установлен';
fi;


##########################################################################

source "${__dir}"/"${C_INSTALLATION_DIR}/postgresql.sh";

if  ! isPackageInstalled 'postgresql*-server'; then
  PrintPackageNotInstalled 'postgresql*-server';
  installPostgreSQL;
  initPostgreSQL;
else
  PrintPackageInstalled 'postgresql*-server';
  initPostgreSQL;
fi;

exit 0;
##########################################################################

if  ! isPackageInstalled 'httpd' ; then
  PrintPackageNotInstalled 'Apache';
  source "${__dir}"/"${C_INSTALLATION_DIR}/apache.sh";
  installApache;
else
  PrintPackageInstalled 'Apache';
fi;


if ! isPackageInstalled 'php5*'; then
  PrintPackageNotInstalled 'php5*';
  source "${__dir}"/"${C_INSTALLATION_DIR}/php.sh";
  installPhp5 ;
else
  PrintPackageInstalled 'php5';
fi;


if ! isPackageInstalled 'git'; then
  PrintPackageNotInstalled 'git';
  source "${__dir}"/"${C_INSTALLATION_DIR}/git.sh";
  installGit ;
else
  PrintPackageInstalled 'git';
fi;

if ! isPackageInstalled 'wget'; then
  PrintPackageNotInstalled 'wget';
  source "${__dir}"/"${C_INSTALLATION_DIR}/wget.sh";
  installWget ;
else
  PrintPackageInstalled 'wget';
fi;


if ! isPackageInstalled 'nodejs'; then
  PrintPackageNotInstalled 'nodejs';
  source "${__dir}"/"${C_INSTALLATION_DIR}/nodejs.sh";
  installNodejs ;
else
  PrintPackageInstalled 'nodejs';
fi;



if command -v composer >/dev/null 2>&1 ; then
  PrintPackageNotInstalled 'composer';
  source "${__dir}"/"${C_INSTALLATION_DIR}/composer.sh";
  installComposer ;
else
  PrintPackageInstalled  'composer';
fi;


if ! hash ember 2>/dev/null ; then
  PrintPackageNotInstalled 'ember-cli';
  source "${__dir}"/"${C_INSTALLATION_DIR}/ember-cli.sh";
  installEmberCli ;
else
  PrintPackageInstalled  'ember-cli';
fi;

source "${__dir}"/"${C_INSTALLATION_DIR}/postgresql.sh";
if  ! isPackageInstalled 'postgresql*-server'; then
  PrintPackageNotInstalled 'postgresql*-server';
  installPostgreSQL;
  initPostgreSQL;
else
  PrintPackageInstalled 'postgresql*-server';
  initPostgreSQL;
fi;


# ===============================END==MAIN======================================
