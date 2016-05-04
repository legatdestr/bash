#!/bin/bash

function runMigrationSetup(){
   info 'migration setup';
   if [ ! -d "${C_GIT_MIGRATION_TOOL_DIR}" ]; then
      process_step 'Директория Миграций не верная : '"${C_GIT_MIGRATION_TOOL_DIR}";
    else
      cd "${C_GIT_MIGRATION_TOOL_DIR}";
      composer update;
   fi;
}

runMigrationSetup;
