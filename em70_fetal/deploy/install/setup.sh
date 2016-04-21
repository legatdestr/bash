#!/usr/bin/env bash

TIME=$(date +%s);

C_CONFIG_FILE_PATH='../config.cfg';
C_LIB_DIR="../lib";

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
      info 'Настраиваем прокси для yum';
      # code if not found
      echo "${C_PROXY_STRING}" >> '/etc/yum.conf' ;
    fi ;

    export http_proxy="${C_PROXY_STRING}";
    export https_proxy="${C_PROXY_STRING}";
    touch ~/.curlrc;

    if ! grep -Fxq "proxy=${C_PROXY_URI}" ~/.curlrc ; then
    # code if not found
      info 'Настраиваем прокси для curl';
      echo "proxy=${C_PROXY_URI}" >> ~/.curlrc;
    fi ;

else
    info 'Proxy не установлен';
fi;


if  ! isPackageInstalled 'httpd' ; then
  PrintPackageNotInstalled 'Apache';
  source "${__dir}"/"install/apache.sh";
  installApache;
else
  PrintPackageInstalled 'Apache';
fi;


if ! isPackageInstalled 'php5*'; then
  PrintPackageNotInstalled 'php5*';
  source "${__dir}"/"install/php.sh";
  installPhp5 ;
else
  PrintPackageInstalled 'php5';
fi;


if ! isPackageInstalled 'git'; then
  PrintPackageNotInstalled 'git';
  source "${__dir}"/"install/git.sh";
  installGit ;
else
  PrintPackageInstalled 'git';
fi;

if ! isPackageInstalled 'wget'; then
  PrintPackageNotInstalled 'wget';
  source "${__dir}"/"install/wget.sh";
  installWget ;
else
  PrintPackageInstalled 'wget';
fi;


if ! isPackageInstalled 'nodejs'; then
  PrintPackageNotInstalled 'nodejs';
  source "${__dir}"/"install/nodejs.sh";
  installNodejs ;
else
  PrintPackageInstalled 'nodejs';
fi;



if command -v composer >/dev/null 2>&1 ; then
  PrintPackageNotInstalled 'composer';
  source "${__dir}"/"install/composer.sh";
  installComposer ;
else
  PrintPackageInstalled  'composer';
fi;


if ! hash ember 2>/dev/null ; then
  PrintPackageNotInstalled 'ember-cli';
  source "${__dir}"/"install/ember-cli.sh";
  installEmberCli ;
else
  PrintPackageInstalled  'ember-cli';
fi;

if  ! isPackageInstalled 'postgresql*-server'; then
  PrintPackageNotInstalled 'postgresql*-server';
  source "${__dir}"/"install/postgresql.sh";
  installPostgreSQL;
else
  PrintPackageInstalled 'postgresql*-server';
fi;


# ===============================END==MAIN======================================
