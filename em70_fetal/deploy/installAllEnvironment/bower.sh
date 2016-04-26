#!/bin/bash

function installBowerOnNodejs(){
   npm install -g bower;
   process_step 'Установка bower';
}
