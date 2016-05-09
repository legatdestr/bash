#!/bin/bash

function setupLocalhost() {
   echo '127.0.0.1  localhost localhost.localdomain localhost4 localhost4.localdomain4 ::1 localhost localhost.localdomain localhost6 localhost6.localdomain6' > /etc/host ;
   process_step 'Запись в /etc/host - localhost. Для корректной работы БД';    
}
