#!/bin/bash
if [ "X"$simpath == "X" ]; then
    echo "ERROR: simpath is not defined!"
    echo ""
    echo "Before running this script, ensure that simpath is defined:"
    echo ""
    echo "  export simpath=/path/to/studySim"
    echo
    exit 1
fi

source $simpath/includes/variables.sh
source $simpath/includes/general_ports.sh

COMMAND_LINE="$@"
if [ "X$@" == "X" ]; then
    COMMAND_LINE="--logger "$serverIPName":"$loggerPort"/v1_00/log"
fi

NAME="LV"$(date +%d%m%Y%H%M%S%N)
docker run -it \
    --name $NAME \
    --net isolated_nw \
    dsanderscan/mscit_stage2_log_viewer $COMMAND_LINE
docker rm -f $NAME

