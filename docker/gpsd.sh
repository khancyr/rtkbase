#!/bin/sh
DEVICES="tcp://localhost:5015"

# Other options you want to pass to gpsd
# read only mode
GPSD_OPTIONS="-b -G -N -D3"

# disable hotplug
USBAUTO="false"

START_DAEMON="false"

killall -9 gpsd
/usr/sbin/gpsd $GPSD_OPTIONS $DEVICES
