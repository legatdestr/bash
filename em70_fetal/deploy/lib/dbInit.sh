#!/bin/bash

# Задание пароля пользователю БД Postgres

C_DB_USER_NEW_PASSWORD='postgres';
sudo -u postgres psql -d template1 -c "ALTER USER postgres WITH PASSWORD '${C_DB_USER_NEW_PASSWORD}';"

# Создание пользователя elecard
C_DB_USER_NEW_PASSWORD='cnjk120cv';
sudo -u postgres psql -d template1 -c "CREATE USER elecard WITH password '${C_DB_USER_NEW_PASSWORD}' createdb createuser;"

