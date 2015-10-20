#!/bin/bash
set -e -x
echo "setting status"
cp -R /usr/share/www/_ah /var/www/public/_ah
echo "starting nginx"
service nginx restart
/usr/bin/memcached -d -s /var/run/memcached.sock -m 64 -c 1024 -u root
echo "starting supervisor in foreground"
supervisord -n
