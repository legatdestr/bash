#!/bin/bash

function installPhp5 () {
  if ! isPackageInstalled 'epel-release-7-6*'; then
    PrintPackageNotInstalled 'epel-release-7-6*';
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
    process_step 'Установка epel-release-7-6 для PHP5';
  else
    PrintPackageInstalled 'epel-release-7-6*';
  fi;

  if ! isPackageInstalled 'webtatic-release'; then
    PrintPackageNotInstalled 'webtatic-release';
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm;
    process_step 'Установка webtatic-release для PHP5';
  else
    PrintPackageInstalled 'webtatic-release';
  fi;

  yum install php56w php56w-opcache php56w-common php56w-mbstring php56w-pdo php56w-pgsql php56w-pecl-memcache -y -y;
  process_step 'Установка PHP5';

  sed -i "s#    DirectoryIndex index.html#    DirectoryIndex index.php index.html#g" /etc/httpd/conf/httpd.conf;
  process_step 'Установка DirectoryIndex index.php index.html';

  service httpd restart;
  process_step 'Рестарт Apache (httpd)';
}
