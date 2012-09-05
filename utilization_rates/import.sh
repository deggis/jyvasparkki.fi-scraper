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


# Real name like P-Sokos for psokos.
REALNAME=${names["$1"]}

for f in `ls datasets/2012*`
do
    DATA=`handle_file "$f" $REALNAME`
    rrdupdate $1.rrd $DATA
done
