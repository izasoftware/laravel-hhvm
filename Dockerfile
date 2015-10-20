# DOCKER-VERSION 1.0.0
FROM    centos:centos6

# Install dependencies for HHVM
RUN yum update -y >/dev/null
RUN yum install -y http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm  && curl -L -o /etc/yum.repos.d/hop5.repo "http://www.hop5.in/yum/el6/hop5.repo"

# Install supervisor
RUN yum install -y python-meld3 http://dl.fedoraproject.org/pub/epel/6/i386/supervisor-2.1-8.el6.noarch.rpm

#install nginx, php, mysql, hhvm
RUN ["yum", "-y", "install", "nginx", "php", "php-sqlite", "php-devel", "php-gd", "php-pecl-memcache", "php-pspell", "php-snmp", "php-xmlrpc", "php-xml","hhvm"]

# Create folder for server and add index.php file to for nginx
RUN mkdir -p /var/www/public && chmod a+r /var/www/public && echo "<?php phpinfo(); ?>" > /var/www/public/index.php

#Setup hhvm - add config for hhvm
ADD docker/config.hdf /etc/hhvm/config.hdf

RUN mkdir -p /var/hhvm; chmod 755 /var/hhvm
RUN touch /var/hhvm/hhvm.pid

RUN service hhvm restart

# ADD Nginx config
ADD docker/nginx.conf /etc/nginx/conf.d/default.conf

# Add files for Google
COPY docker/ok.txt /usr/share/www/_ah/ok.txt

# ADD supervisord config with hhvm setup
ADD docker/supervisord.conf /etc/supervisord.conf

#set to start automatically - supervisord, nginx
RUN yum install supervisor -y
RUN chkconfig supervisord on
RUN chkconfig nginx on

ADD docker/scripts/run.sh /run.sh

RUN chmod a+x /run.sh

ADD docker/mime.types /etc/nginx/mime.types

# Install local memcached
RUN yum install memcached -y

# Start memcached
ADD docker/memcached /etc/init.d/memcached
RUN chkconfig --levels 235 memcached on
RUN /usr/bin/memcached -d -s /var/run/memcached.sock -m 64 -c 1024 -u root

EXPOSE 8080

#Start supervisord (which will start hhvm), nginx
RUN service nginx start
ENTRYPOINT ["/run.sh"]


# run this docker
# sudo docker run --name=hhvm -v /e/websites/website-name:/var/www -p 8080:8080 ganey/laravel-hhvm