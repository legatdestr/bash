#!/bin/bash

function applyMigrations () {
    if [ ! -d "${C_GIT_MIGRATION_TOOL_DIR}" ]; then
      process_step 'Директория миграций задана не верно : '"${C_GIT_MIGRATION_TOOL_DIR}";
    else
      cd "${C_GIT_MIGRATION_TOOL_DIR}";
      process_step "Смена директории: ${C_GIT_MIGRATION_TOOL_DIR}";
      ./yii migrate --interactive=0
    fi;
}