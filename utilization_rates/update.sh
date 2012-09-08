#!/bin/bash

if [ -f config.sh ]; then
    . config.sh
else
    echo "Missing config!"
    exit 1
fi

# Returns date in given format from given strings
# in format of .*YYYYMMDDhhmmss.* (discarding rest)
# arg1 string
# arg2 format
parse_date()
{
    T="([0-9]{2})"
    DATE_STR=`echo "$1"| sed -r "s/.*([0-9]{4})$T$T$T$T$T.*/\1-\2-\3 \4:\5:\6/"`
    date "$2" -d "$DATE_STR"
}

parse_csvtime()
{
    parse_date "$1" "+%Y-%m-%d %H:%M:%S"
}

parse_epoch()
{
    parse_date "$1" "+%s"
}

# arg1 houseid
# arg2 rawdatafile
parse_file()
{
    SECS=`parse_epoch "$2"`
    FREE=`parse_free $1 "$2"`
    echo "$SECS:$FREE"
}

# arg1 houseid, arg2 rawdatafile
parse_free()
{
    REALNAME=${names["$1"]}
    FREE=`grep "$REALNAME" $2|sed -r 's/.*,([0-9]+)/\1/'`
    echo $FREE
}

# updates collection
# handles both RRD & CSV
# arg1 file
handle_file()
{
    SECS=`parse_epoch "$1"`
    PASEMA=`parse_free pasema "$1"`
    PCYGNAEUS=`parse_free pcygnaeus "$1"`
    PKOLMIKULMA=`parse_free pkolmikulma "$1"`
    PMATKAKESKUS=`parse_free pmatkakeskus "$1"`
    PPAVILJONKI2=`parse_free ppaviljonki2 "$1"`
    PSOKOS=`parse_free psokos "$1"`
    PTORI=`parse_free ptori "$1"`
    rrdupdate $DB \
        -t pasema:pcygnaeus:pkolmikulma:pmatkakeskus:ppaviljonki2:psokos:ptori \
        $SECS:$PASEMA:$PCYGNAEUS:$PKOLMIKULMA:$PMATKAKESKUS:$PPAVILJONKI2:$PSOKOS:$PTORI
    echo "rrdupdate $DB updated with $1's contents"

    CSV_TIME=`parse_csvtime "$1"`
    echo "$CSV_TIME;$PASEMA;$PCYGNAEUS;$PKOLMIKULMA;$PMATKAKESKUS;$PPAVILJONKI2;$PSOKOS;$PTORI" >> $CSV
}


import_all()
{
    # First put a CSV header
    echo "datetime;pasema;pcygnaeus;pkolmikulma;pmatkakeskus;ppaviljonki2;psokos;ptori" >> $CSV

    for f in `ls $RAW_DATA_DIR/2012*`
    do
        handle_file $f
    done
}

case "$1" in
    all)
        import_all
        ;;
    *)
        handle_file $1
        ;;
esac
