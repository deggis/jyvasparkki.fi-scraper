# Requires bash >= 4

# Garages with data available
HOUSES="pasema pcygnaeus pkolmikulma pmatkakeskus ppaviljonki2 psokos ptori"

declare -A limits
limits=(
    ["pasema"]="460"
    ["pcygnaeus"]="120"       
    ["pkolmikulma"]="521"     
    ["pmatkakeskus"]="432"    
    ["ppaviljonki1"]="320"    
    ["ppaviljonki2"]="540"    
    ["psairaala"]="570"       
    ["psokos"]="485"          
    ["ptori"]="485"
    )

declare -A colors
colors=(
    ["pasema"]="65ff00"
    ["pcygnaeus"]="FFdc00"       
    ["pkolmikulma"]="FF5a00"     
    ["pmatkakeskus"]="FF0080"
    ["ppaviljonki1"]="FF06F0"
    ["ppaviljonki2"]="00ffa8"    
    ["psairaala"]="00b4ff"
    ["psokos"]="0022ff"
    ["ptori"]="9b0000"
    )


declare -A names
names=(
    ["pasema"]="P-Asema"
    ["pcygnaeus"]="P-Cygnaeus"       
    ["pkolmikulma"]="P-Kolmikulma"
    ["pmatkakeskus"]="P-Matkakeskus"
    ["ppaviljonki1"]="P-Paviljonki 1"    
    ["ppaviljonki2"]="P-Paviljonki 2"    
    ["psairaala"]="P-Sairaala"
    ["psokos"]="P-Sokos" 
    ["ptori"]="P-Tori"
    )

DIR=/home/deggis/proj/misc.jyvasparkki/utilization_rates
IMAGE_DIR=$DIR/images
DB=$DIR/dbs/collection.rrd
CSV=$DIR/dbs/collection.csv
RAW_DATA_DIR=$DIR/rawdata
