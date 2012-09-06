#!/bin/bash

# This is just my cronjob script for using scraper & plotter.

SCRAPER_HOME=/home/deggis/proj/misc.jyvasparkki/utilization_rates
DATASET_DIR=$SCRAPER_HOME/rawdata


FILE=$DATASET_DIR/`date "+%Y%m%d%H%M%S"`_tilanne
curl -s http://www.jyvasparkki.fi/inc/js/default.php|grep "garagearray.*nimi" |sed 's/.*<b>\(.*\)<\/b>.*<strong>\(.*\)<\/strong>.*/\1,\2/' |grep -v -i "garage" > $FILE

cd $SCRAPER_HOME
./update.sh $FILE
./graph.sh

# The script that uploads stuff to web.
./send.sh
