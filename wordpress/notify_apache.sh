#!/bin/bash 

while inotifywait -e attrib,modify /opt/httpd/httpd-vhosts.conf -e attrib,modify,create,delete,move ; do
     /usr/local/apache2/bin/apachectl -k  graceful && echo "`date -u --rfc-3339=seconds` apache -k graceful"
done
