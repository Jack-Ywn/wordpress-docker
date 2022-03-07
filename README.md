## 使用[docker](https://hub.docker.com/repository/docker/jackywn/wordpress)部署

```shell
#创建带有卷的MariaDB容器
docker run --name -d wordpress-db \
--hostname wordpress-db \
-e MARIADB_ROOT_PASSWORD="abc123%%" \
-e MARIADB_DATABASE="wordpress" \
-e MARIADB_USER="wordpress" \
-e MARIADB_PASSWORD="wordpress" \
--volume /data/wordpress/mariadb:/var/lib/mysql  
mariadb:10.7

#运行wordpress容器并且链接数据库
docker run --name -d wordpress-www \
--hostname wordpress-www \ 
--link wordpress-db:wordpress-db \
--volume /data/wordpress/html:/var/www/html/wordpress \ 
--env " TIMEZONE=Asia/Shanghai " \
-p 8000:80
jackywn/wordpress
```

## 使用docker-compose部署

```shell
#全新环境初始化部署
git clone https://github.com/Jack-Ywn/wordpress-docker.git
cd wordpress-docker
docker-compose up -d

#直接使用已经初始化好数据（由于网络原因导致容器无法下载wordpress源码的）
git clone https://github.com/Jack-Ywn/wordpress-docker.git
cd wordpress-docker
tar xf wordpress.tar.gz
docker-compose up -d

#访问http://ip:8000即可初始化安装wordpress
```

## 构建容器镜像

```shell
git clone https://github.com/Jack-Ywn/wordpress-docker.git
cd wordpress-docker/build
docker image build -t "jackywn/wordpress" .
```

## Nginx反向代理wordpress容器

```shell
server {
    listen 80;
    listen 443 ssl http2;

    server_name                example.com;
    server_name_in_redirect    on;
    port_in_redirect           on;

    if ( $scheme = http ) { return 301 https://$host$request_uri; }

    ssl_certificate          example.com.cer;
    ssl_certificate_key      example.com.key;

    location / {
        proxy_pass  http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
    }
}
```
