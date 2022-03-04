#!/bin/bash
#设置PHP时区
if [[ -z "${TIMEZONE}" ]]; then echo "TIMEZONE is unset";
else
echo "date.timezone = \"$TIMEZONE\"" > /etc/php/7.4/apache2/conf.d/timezone.ini;
echo "date.timezone = \"$TIMEZONE\"" > /etc/php/7.4/cli/conf.d/timezone.ini;
fi

#下载wordpress源码
if [ "$(ls /var/www/html/wordpress/index.php)" ];
then
        echo "wordpress is already installed"
else
        wget --no-check-certificate -P /opt https://cn.wordpress.org/latest-zh_CN.tar.gz
        tar xf /opt/*.tar.gz -C /opt
        mv /opt/wordpress/* /var/www/html/wordpress/
        rm -rf /opt/{*.tar.gz,wordpress}
fi
#设置站点目录权限
chown -R www-data:www-data /var/www/html/wordpress

#设置Apache配置文件
echo -e "<VirtualHost *:80>\n\tDocumentRoot /var/www/html/wordpress\n\n\t<Directory /var/www/html/wordpress>\n\t\tAllowOverride All\n\t\tOrder Allow,Deny\n\t\tAllow from all\n\t</Directory>\n\n\tErrorLog /var/log/apache2/error-wordpress.log\n\tLogLevel warn\n\tCustomLog /var/log/apache2/access-wordpress.log combined\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

#启动服务
service php7.4-fpm start
service apache2 start

