#!/bin/bash


function runApiModule(){

  if [ ! -d "${C_GIT_API_DIR}" ]; then
    process_step 'Директория API указана неверно: '"${C_GIT_API_DIR}";
  else
     cd "${C_GIT_API_DIR}";
     php ~/composer.phar install;

      if [ ! -d "${C_API_FRAMEWORK_DIR}" ]; then
          mkdir  -p "${C_API_FRAMEWORK_DIR}";
        else
          rm -rf "${C_API_FRAMEWORK_DIR}/*";
      fi;

      cp -R "${C_GIT_API_DIR}/." "${C_API_FRAMEWORK_DIR}" ;

      if [ ! -d "${C_API_DEPLOY_DIR}" ]; then
          mkdir  -p "${C_API_DEPLOY_DIR}";
        else
          rm -rf "${C_API_DEPLOY_DIR}/*";
      fi;
      cp -R web/* "${C_API_DEPLOY_DIR}/";

     sed -i  "s#require(__DIR__ . '/../vendor/autoload.php');#require('${C_API_FRAMEWORK_DIR}/vendor/autoload.php');#g" "${C_API_DEPLOY_DIR}/index.php";
     sed -i  "s#require(__DIR__ . '/../vendor/yiisoft/yii2/Yii.php');#require('${C_API_FRAMEWORK_DIR}/vendor/yiisoft/yii2/Yii.php');#g" "${C_API_DEPLOY_DIR}/index.php";
     sed -i  "s#\$config = require(__DIR__ . '/../config/web.php');#require('${C_API_FRAMEWORK_DIR}/config/web.php');#g" "${C_API_DEPLOY_DIR}/index.php";


  fi;


}

runApiModule;
