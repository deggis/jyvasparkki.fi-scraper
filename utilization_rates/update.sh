#!/bin/bash

if [ -f config.sh ]; then
    . config.sh
else
    echo "Missing config!"
    exit
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

parse_file()
{
    SECS=`parse_date $1`
    FREE=`grep "$2" $1|sed -r 's/.*,([0-9]+)/\1/'`
    echo "$SECS:$FREE"
}

# arg1 psokos, arg2 rawdatafile
handle_file()
{
    REALNAME=${names["$1"]}
    DATA=`parse_file "$2" $REALNAME`
    rrdupdate $DB_DIR/$1.rrd $DATA
    echo "rrdupdate $DB_DIR/$1.rrd $DATA"
}

import_all()
{
    # Single garage db's
    for h in $HOUSES;
    do
        # Real name like P-Sokos for psokos.

        for f in `ls $RAW_DATA_DIR/2012*`
        do
            handle_file $h $f
        done
    done

    # TODO: Import collection
}

case "$1" in
    all)
        import_all
        ;;
    *)
        for h in $HOUSES;
        do
            handle_file $h $1
        done
        ;;
esac


