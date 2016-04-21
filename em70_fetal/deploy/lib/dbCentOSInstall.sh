#!/bin/bash

# sudo su;
touch /etc/yum.repos.d/CentOS-Base.repo;
echo 'exclude=postgresql*' >> /etc/yum.repos.d/CentOS-Base.repo;
yum localinstall https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm -y;
yum install postgresql95-server -y;

# init db
/usr/pgsql-9.5/bin/postgresql95-setup initdb

# автозапуск:
chkconfig postgresql-9.5 on

# старт сервиса:
service postgresql-9.5 start

echo 'Конец работы скрипта';
