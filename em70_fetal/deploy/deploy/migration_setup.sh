#!/bin/bash

function runMigrationSetup(){
   echo 'migration setup';
   if [ ! -d "${C_GIT_MIGRATION_TOOL_DIR}" ]; then
      process_step 'Директория Миграций не верная : '"${C_GIT_MIGRATION_TOOL_DIR}";
    else
      cd "${C_GIT_MIGRATION_TOOL_DIR}";
      php ~/composer.phar install;
   fi;
}

runMigrationSetup;
