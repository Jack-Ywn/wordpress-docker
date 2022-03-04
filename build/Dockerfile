#基础镜像
FROM debian:11.1

#设置国内软件源
COPY sources.list /etc/apt/

#apt-get安装期间不询问任何问题/对话框
ENV DEBIAN_FRONTEND noninteractive

#安装Apache、PHP8.0、PHP拓展
RUN apt update \
&& apt install --yes --no-install-recommends \
apache2 vim wget \
libapache2-mod-php7.4 \
php7.4 \
php7.4-fpm \
php7.4-json \
php7.4-mysqlnd \
php7.4-zip \
php7.4-xml \
php7.4-gd \
php7.4-curl \
php7.4-dom \
php7.4-exif \
php7.4-fileinfo \
php7.4-imagick \
php7.4-mbstring \
&& rm -rf /var/lib/apt/lists/*

#设置挂载目录
VOLUME /var/www/html/wordpress

#暴露端口
EXPOSE 80

#配置运行脚本
COPY wordpress-start.sh /opt/
RUN chmod +x /opt/wordpress-start.sh
CMD /opt/wordpress-start.sh && tail -f
