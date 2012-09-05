#!/bin/bash

if [ -f config.sh ]; then
    . config.sh
else
    echo "Missing config!"
fi


COLOR="3030B1"

do_graph()
{
    NAME=${names["$1"]}
    CAPACITY=${limits["$1"]}

    rrdtool graph "$1_day.png" \
        DEF:val=$1.rrd:$1:MIN \
        CDEF:used=$CAPACITY,val,- \
        -s end-86400s \
        -e now \
        --lower-limit 0 \
        --upper-limit "$CAPACITY" \
        --rigid \
        "AREA:used#$COLOR" \
        "COMMENT: $NAME\: käytetyt parkkiruudut, 24 tuntia." \
        "COMMENT: $NAME\: tilavuus $CAPACITY."

    rrdtool graph "$1_week.png" \
        DEF:val=$1.rrd:$1:MIN \
        CDEF:used=$CAPACITY,val,- \
        -s end-604800s \
        -e now \
        --lower-limit 0 \
        --upper-limit "$CAPACITY" \
        --rigid \
        "AREA:used#$COLOR" \
        "COMMENT: $NAME\: käytetyt parkkiruudut, 7 päivää, 3 tunnin maksimit." \
        "COMMENT: $NAME\: tilavuus $CAPACITY."

    rrdtool graph "$1_month.png" \
        DEF:val=$1.rrd:$1:MIN \
        CDEF:used=$CAPACITY,val,- \
        -s end-2592000s \
        -e now \
        --lower-limit 0 \
        --upper-limit "$CAPACITY" \
        --rigid \
        "AREA:used#$COLOR" \
        "COMMENT: $NAME\: käytetyt parkkiruudut, 30 päivää, 6 tunnin maksimit." \
        "COMMENT: $NAME\: tilavuus $CAPACITY."
}

graph_all()
{
    HOUSES="pasema pcygnaeus pkolmikulma pmatkakeskus ppaviljonki2 psokos ptori"
    for h in $HOUSES;
    do
        if [ -f "$h.rrd" ]
        then
            echo "$h exists, creating graph."
            do_graph $h
        fi
    done
}

graph_all
