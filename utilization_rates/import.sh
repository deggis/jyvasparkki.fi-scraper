#!/bin/bash

if [ -f config.sh ]; then
    . config.sh
else
    echo "Missing config!"
fi

# Returns seconds from epoch from given strings
# in format of .*YYYYMMDDhhmmss.* (discarding rest)
parse_date()
{
    T="([0-9]{2})"
    DATE_STR=`echo "$1"| sed -r "s/.*([0-9]{4})$T$T$T$T$T.*/\1-\2-\3 \4:\5:\6/"`
    date '+%s' -d "$DATE_STR"
}

# parse_date "20120822000001_tilanne"

handle_file()
{
    SECS=`parse_date $1`
    FREE=`grep "$2" $1|sed -r 's/.*,([0-9]+)/\1/'`
    echo "$SECS:$FREE"
}


import_all()
{
    # Single garage db's
    for h in $HOUSES;
    do
        # Real name like P-Sokos for psokos.
        REALNAME=${names["$h"]}

        for f in `ls $RAW_DATA_DIR/2012*`
        do
            DATA=`handle_file "$f" $REALNAME`
            rrdupdate $DB_DIR/$h.rrd $DATA
            echo "rrdupdate $DB_DIR/$h.rrd $DATA"
        done
    done

    # TODO: Import collection
}

import_all


