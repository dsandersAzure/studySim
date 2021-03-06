if [ "X"$simpath == "X" ]; then
    echo "ERROR: simpath is not defined!"
    echo ""
    echo "Before running this script, ensure that simpath is defined:"
    echo ""
    echo "  export simpath=/path/to/studySim"
    echo
    exit 1
fi

STAGE_PATH="stage2"
STAGE=$STAGE_PATH"_"
SIM_HEADING="Simulation set 1 shutdown"

source $simpath/$STAGE_PATH/includes/includes.sh

clear
set +e
start_message "${SIM_HEADING}"
set -e

echo "Stopping services."
echo ""
stop_service $STAGE $phonePort "phone"
stop_service $STAGE $bluePort "bluetooth"
stop_service $STAGE $locPort "location_service"
stop_service $STAGE $monitorPort "monitor_app"
stop_service $STAGE $notesvcPort "notification"
stop_service $STAGE $loggerPort "logger"
stop_phone $STAGE Jing
stop_phone $STAGE Bob
echo "Services stopped."
echo ""
set +e

stop_message "${SIM_HEADING}"

