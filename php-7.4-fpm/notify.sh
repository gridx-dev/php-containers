#!/bin/bash 

while inotifywait -e attrib,modify /opt/httpd/php-fpm.d -e attrib,modify,create,delete,move ; do
    killall -HUP php-fpm && echo "`date -u --rfc-3339=seconds` php-fpm.d -k graceful"
done
