#!/bin/bash


function initPostgreSQL () {

  local dbDataDir='/var/lib/pgsql/9.5/data';

  if [ "$(ls -A ${dbDataDir})" ] ; then
     warning "PostgreSQL data directory не пуста (Бд уже проинициализирована)!";
   else
     /usr/pgsql-9.5/bin/postgresql95-setup initdb ;
     process_step 'Инициализация БД';
  fi;

  chkconfig postgresql-9.5 on;
  process_step 'Автозапуск сервиса postgresql-9.5.service';
  /bin/systemctl stop postgresql-9.5.service;
  process_step 'Стоп сервиса postgresql-9.5.service';

  if ! grep -Fxq 'host    all         all         10.10.0.0/24          md5' /var/lib/pgsql/9.5/data/pg_hba.conf ; then
    echo "
local   all         postgres                          peer
local   all         all                               peer
host    all         all               0.0.0.0/0       md5
host    all         ${C_DB_USER_DEPLOY}           localhost      md5
" > /var/lib/pgsql/9.5/data/pg_hba.conf ;
  process_step 'Создание настроек доступа в файле pg_hba.conf. Файл перезаписывается.';
  fi ;

    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/9.5/data/postgresql.conf;
    process_step 'Разрешаем pgsql принимать коннекты по сети: ред. файл: /var/lib/pgsql/9.5/data/postgresql.conf';

   /bin/systemctl start postgresql-9.5.service;
   process_step 'Старт сервиса postgresql-9.5.service';

   sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${C_DB_POSTGRES_USER_PASSWORD}';"
   process_step 'Задание пароля пользователю postgres';

  # Создание пользователя admin
  if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${C_DB_USER_ADMIN}'; " | grep -q 1 ; then
      process_step 'Пользователь '"${C_DB_USER_ADMIN}"' уже существует. Не трогаем.';
    else
      sudo -u postgres psql -c "CREATE USER ${C_DB_USER_ADMIN} WITH password '${C_DB_USER_PASSWORD}' createdb createuser login;";
      process_step 'Создание пользователя: '"${C_DB_USER_ADMIN}";
  fi;
  
  # Создание пользователя который деплоит
  if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${C_DB_USER_DEPLOY}'; " | grep -q 1 ; then
      process_step 'Пользователь '"${C_DB_USER_DEPLOY}"' уже существует. Не трогаем.';
    else
      sudo -u postgres psql -c "CREATE USER ${C_DB_USER_DEPLOY} WITH password '${C_DB_USER_DEPLOY_PASSWORD}' createdb createuser login;";
      process_step 'Создание пользователя который деплоит БД: '"${C_DB_USER_DEPLOY}";
  fi;
  

   /bin/systemctl restart postgresql-9.5.service; # service postgresql-9.5 start;
   process_step 'Перезапуск сервиса postgresql-9.5.service';

   process_step 'Инициализация БД';
}

function installPostgreSQL () {
  info 'Старт установки PostgreSQL';
  touch /etc/yum.repos.d/CentOS-Base.repo;
  process_step 'Создание /etc/yum.repos.d/CentOS-Base.repo';

  if ! grep -Fxq 'exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo ; then
    echo 'exclude=postgresql*' >> /etc/yum.repos.d/CentOS-Base.repo;
    process_step 'Добавляем строку "exclude=postgresql*" в /etc/yum.repos.d/CentOS-Base.repo';
  fi ;

  if  ! isPackageInstalled 'pgdg-centos95-9*' ; then
    PrintPackageNotInstalled 'pgdg-centos95-9*';
    yum localinstall https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm -y;
    process_step 'Установка пакета pgdg-centos95-9.5-2';
  else
    PrintPackageInstalled 'pgdg-centos95-9*';
  fi;

  if  ! isPackageInstalled 'postgresql95-server' ; then
    PrintPackageNotInstalled 'postgresql95-server';
    yum install postgresql95-server -y;
    process_step 'Установка пакета postgresql95-server';
  else
    PrintPackageInstalled 'postgresql95-server';
  fi;

  if  ! isPackageInstalled 'postgresql-contrib' ; then
    PrintPackageNotInstalled 'postgresql-contrib';
    yum install postgresql-contrib -y;
    process_step 'Установка пакета postgresql-contrib';
  else
    PrintPackageInstalled 'postgresql-contrib';
  fi;

  info 'Бд установлена';
}
