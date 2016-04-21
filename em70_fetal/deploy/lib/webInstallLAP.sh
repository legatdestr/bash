#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# proxy
#C_PROXY_URI='http://proxy:6666';
C_PROXY_STRING="proxy=${C_PROXY_URI}";
if [ -n "${C_PROXY_URI}" ]; then
    echo "${C_PROXY_STRING}" >> '/etc/yum.conf' ;
    export http_proxy="${C_PROXY_STRING}";
    export https_proxy="${C_PROXY_STRING}";
    touch ~/.curlrc;
    echo "http_proxy=${C_PROXY_STRING}" >> ~/.curlrc;
fi;


yum install httpd -y -y;
systemctl start httpd;

#включим автозапуск службы
systemctl enable httpd

# проверка запущена ли служба Apache
systemctl is-enabled httpd


# установка PHP
echo 'Ставим PHP';

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm;
yum install php56w php56w-opcache php56w-common php56w-mbstring php56w-pdo php56w-pgsql php56w-pecl-memcache -y -y;

service httpd restart;

yum install git -y;

yum install wget -y;

wget https://getcomposer.org/composer.phar;
mv composer.phar /usr/local/bin/composer;
chmod +x /usr/local/bin/composer;

php /usr/local/bin/composer global require "fxp/composer-asset-plugin:~1.1.1" ;


# ставим Nodejs

curl --location https://rpm.nodesource.com/setup_5.x | bash - ;
yum -y install nodejs;

if [ -n "${C_PROXY_URI}" ]; then
    npm config set proxy "${C_PROXY_URI}";
fi;

echo 'Ставим Ember-cli';
npm install -g ember-cli;

touch ~/.bowerrc
if [ -n "${C_PROXY_URI}" ]; then
    echo {"proxy': '${C_PROXY_URI}', 'https-proxy':'${C_PROXY_URI}' }" >> ~/.bowerrc;
fi;
