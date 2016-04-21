#!/bin/bash

# Модуль для работы с БД

C_DB_CONFIG_FILE_PATH='./dbConfig.cfg';

# Подключение файла настроек БД
source "${C_DB_CONFIG_FILE_PATH}";
process_step 'Подключение dbConfig.sh';





function testDbEnvironment(){    
     psql -U "${C_DB_USER_NAME}" -d "${C_DB_DBNAME}" -h "${C_DB_HOST}";
     process_step 'Тест подключения к БД';    
}