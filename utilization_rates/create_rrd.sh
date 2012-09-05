#!/bin/bash

START=1345495899
HALF_HOUR=1800


# Three archives:
#  * last 24 hours: interval 1 (half hour), 48 points
#  * last 1 week:   interval 6 (3 hours),   112 points
#  * last 1 month:  interval 12 (6 hours),  120 points

do_single_db()
{
    rrdtool create $1.rrd \
        --start $START \
        --step $HALF_HOUR \
        DS:$1:GAUGE:3600:1:1000 \
        RRA:MIN:0.5:1:48 \
        RRA:MIN:0.5:6:112 \
        RRA:MIN:0.5:12:120
}

do_collection_db()
{
    rrdtool create collection.rrd \
        --start $START \
        --step $HALF_HOUR \
        DS:pasema:GAUGE:3600:0:1000 \
        DS:pcygnaeus:GAUGE:3600:0:1000 \
        DS:pkolmikulma:GAUGE:3600:0:1000 \
        DS:pmatkakeskus:GAUGE:3600:0:1000 \
        DS:ppaviljonki2:GAUGE:3600:0:1000 \
        DS:psokos:GAUGE:3600:0:1000 \
        DS:ptori:GAUGE:3600:0:1000 \
        RRA:MIN:0.5:1:48 \
        RRA:MIN:0.5:6:112 \
        RRA:MIN:0.5:12:120

}

case "$1" in
    collection)
        do_collection_db
        ;;
    *)
        do_single_db $1
        ;;
esac
