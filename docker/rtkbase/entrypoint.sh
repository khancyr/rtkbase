#!/bin/sh

echo '################################'
echo 'Trying to configure GPS'
echo '################################'
/rtkbase/docker/rtkbase/gps_detect.sh

echo '################################'
echo 'Done !'
echo '################################'

/usr/local/bin/supervisord -c /rtkbase/docker/rtkbase/supervisord.conf