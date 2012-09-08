#!/bin/bash

if [ -f config.sh ]; then
    . config.sh
else
    echo "Missing config!"
    exit 1
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

# arg1 houseid, arg2 rawdatafile
parse_file()
{
    SECS=`parse_date "$2"`
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

# updates collection, arg1 file
handle_file()
{
    SECS=`parse_date "$1"`
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
}


import_all()
{
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
        for h in $HOUSES;
        do
            handle_file $h $1
        done
        ;;
esac
