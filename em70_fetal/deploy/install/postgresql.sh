#!/bin/bash

function initPostgreSQL () {

  local dbDataDir='/var/lib/pgsql/9.5/data';

  [ "$(ls -A ${dbDataDir})" ] && warning "PostgreSQL data directory is exists and not empty!" || /usr/pgsql-9.5/bin/postgresql95-setup initdb ;
  # автозапуск:
  chkconfig postgresql-9.5 on;
  # старт сервиса:
  service postgresql-9.5 start;
  service postgresql-9.5 restart;

  echo "
host    all             all             127.0.0.1/32            md5
local   all             all                                     md5
local   all             all             ::1                     md5
" > /var/lib/pgsql/9.5/data/pg_hba.conf ;
   sudo -u postgres psql -d template1 -h localhost -c "ALTER USER postgres WITH PASSWORD '${C_DB_POSTGRES_USER_PASSWORD}';"
   # Создание пользователя elecard
   sudo -u postgres psql -d template1 -h localhost -c "CREATE USER ${C_DB_USER_ADMIN} WITH password '${C_DB_USER_PASSWORD}' createdb createuser;"
   info 'Создан пользователь elecard';
}

function installPostgreSQL () {
  info 'Установка PostgreSQL';
  touch /etc/yum.repos.d/CentOS-Base.repo;

  if ! grep -Fxq 'exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo ; then
  # code if not found
    info 'adding "exclude=postgresql*" to /etc/yum.repos.d/CentOS-Base.repo';
    echo 'exclude=postgresql*' >> /etc/yum.repos.d/CentOS-Base.repo;
  fi ;

  if  ! isPackageInstalled 'pgdg-centos95-9*' ; then
    PrintPackageNotInstalled 'pgdg-centos95-9*';
    yum localinstall https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm -y;
  else
    PrintPackageInstalled 'pgdg-centos95-9*';
  fi;

  if  ! isPackageInstalled 'postgresql95-server' ; then
    PrintPackageNotInstalled 'postgresql95-server';
    yum install postgresql95-server -y;
  else
    PrintPackageInstalled 'postgresql95-server';
  fi;

  if  ! isPackageInstalled 'postgresql-contrib' ; then
    PrintPackageNotInstalled 'postgresql-contrib';
    yum install postgresql-contrib -y;
  else
    PrintPackageInstalled 'postgresql-contrib';
  fi;

  initPostgreSQL;
  info 'Бд установлена';
}
