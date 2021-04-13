#!/bin/sh

echo '################################'
echo 'Trying to configure GPS'
echo '################################'
#/rtkbase/docker/gps_detect.sh

echo '################################'
echo 'Done !'
echo '################################'

/usr/local/bin/supervisord -c /rtkbase/docker/supervisord.conf