#!/bin/sh
export DEVICES="tcp://localhost:5015"

# Other options you want to pass to gpsd
# read only mode
export GPSD_OPTIONS="-b -G -N -D3"

# disable hotplug
export USBAUTO="false"

export START_DAEMON="false"
