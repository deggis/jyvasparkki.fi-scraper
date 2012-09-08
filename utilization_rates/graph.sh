#!/bin/bash

if [ -f config.sh ]; then
    . config.sh
else
    echo "Missing config!"
    exit 1
fi


#COLOR="3030B1"
DATESTR=`date|sed 's/:/\\\\:/g'`

# arg1 houseid
do_graph_house_scopes()
{
    house "$1" "day" "end-86400s" "käytetyt parkkiruudut, 24 tuntia."
    house "$1" "week" "end-604800s" "käytetyt parkkiruudut, 7 päivää, 3 tunnin maksimit."
    house "$1" "month" "end-2592000s" "käytetyt parkkiruudut, 30 päivää, 6 tunnin maksimit."
}

# arg1 houseid
# arg2 file postfix
# arg3 (end-#s)
# arg4 comment
house()
{
    NAME=${names["$1"]}
    CAPACITY=${limits["$1"]}
    COLOR=${colors["$1"]}

    rrdtool graph "$IMAGE_DIR/$1_$2.png" \
        DEF:val=$DB:$1:MIN \
        CDEF:used=$CAPACITY,val,- \
        -s "$3" \
        -e now \
        --lower-limit 0 \
        --upper-limit "$CAPACITY" \
        --rigid \
        "AREA:used#$COLOR" \
        "COMMENT: $NAME\: $4" \
        "COMMENT: $NAME\: tilavuus $CAPACITY." \
        "COMMENT: $DATESTR"
}


do_graph_all_combined()
{
    collection "day" "end-86400s" "sum" "Käytetyt parkkiruudut, vuorokausi."
    collection "week" "end-604800s" "sum"  "Käytetyt parkkiruudut, 7 päivää, 3 tunnin maksimit."
    collection "month" "end-2592000s" "sum" "Käytetyt parkkiruudut, 30 päivää, 6 tunnin maksimit."
    collection "day" "end-86400s" "rel" "Käytetyt parkkiruudut, vuorokausi."
    collection "week" "end-604800s" "rel"  "Käytetyt parkkiruudut, 7 päivää, 3 tunnin maksimit."
    collection "month" "end-2592000s" "rel" "Käytetyt parkkiruudut, 30 päivää, 6 tunnin maksimit."
}

# arg1 file postfix, arg2 (end-#s), arg3 sum/rel, arg4 comment
collection()
{

    # XXX: These values aren't updated dynamically atm.
    if [ $3 = "sum" ]
    then
        UPPER=3933
    else
        UPPER=7
    fi

    rrdtool graph "$IMAGE_DIR/collection-$3_$1.png" \
        DEF:pasemaval=$DB:pasema:MIN \
        DEF:pcygnaeusval=$DB:pcygnaeus:MIN \
        DEF:pkolmikulmaval=$DB:pkolmikulma:MIN \
        DEF:pmatkakeskusval=$DB:pmatkakeskus:MIN \
        DEF:ppaviljonki2val=$DB:ppaviljonki2:MIN \
        DEF:psokosval=$DB:psokos:MIN \
        DEF:ptorival=$DB:ptori:MIN \
        CDEF:pasemasum=${limits["pasema"]},pasemaval,- \
        CDEF:pcygnaeussum=${limits["pcygnaeus"]},pcygnaeusval,- \
        CDEF:pkolmikulmasum=${limits["pkolmikulma"]},pkolmikulmaval,- \
        CDEF:pmatkakeskussum=${limits["pmatkakeskus"]},pmatkakeskusval,- \
        CDEF:ppaviljonki2sum=${limits["ppaviljonki2"]},ppaviljonki2val,- \
        CDEF:psokossum=${limits["psokos"]},psokosval,- \
        CDEF:ptorisum=${limits["ptori"]},ptorival,- \
        CDEF:pasemarel=pasemasum,${limits["pasema"]},/ \
        CDEF:pcygnaeusrel=pcygnaeussum,${limits["pcygnaeus"]},/ \
        CDEF:pkolmikulmarel=pkolmikulmasum,${limits["pkolmikulma"]},/ \
        CDEF:pmatkakeskusrel=pmatkakeskussum,${limits["pmatkakeskus"]},/ \
        CDEF:ppaviljonki2rel=ppaviljonki2sum,${limits["ppaviljonki2"]},/ \
        CDEF:psokosrel=psokossum,${limits["psokos"]},/ \
        CDEF:ptorirel=ptorisum,${limits["ptori"]},/ \
        -s "$2"  \
        -e now \
        --lower-limit 0 \
        --height 200 \
        --upper-limit "$UPPER" \
        --rigid \
        "AREA:pasema$3#${colors["pasema"]}:P-Asema" \
        "STACK:pcygnaeus$3#${colors["pcygnaeus"]}:P-Cygnaeus" \
        "STACK:pkolmikulma$3#${colors["pkolmikulma"]}:P-Kolmikulma" \
        "STACK:pmatkakeskus$3#${colors["pmatkakeskus"]}:P-Matkakeskus" \
        "STACK:ppaviljonki2$3#${colors["ppaviljonki2"]}:P-Paviljonki 2" \
        "STACK:psokos$3#${colors["psokos"]}:P-Sokos" \
        "STACK:ptori$3#${colors["ptori"]}:P-Tori" \
        "COMMENT: $4" \
        "COMMENT: $DATESTR"
}



graph_all()
{
    for h in $HOUSES;
    do
        do_graph_house_scopes $h
    done
}

graph_all
do_graph_all_combined
