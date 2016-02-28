if [ "X"$testpath == "X" ]; then
    echo "ERROR: testpah is not defined!"
    echo ""
    echo "Before running this script, ensure that testpath is defined:"
    echo ""
    echo "  export testpath=/path/to/studyTest"
    echo
    exit 1
fi

source $testpath/includes/variables.sh
source $testpath/includes/general_ports.sh
source $testpath/includes/config_logging_fn.sh
source $testpath/includes/run_docker_fn.sh
source $testpath/includes/run_docker_phone_fn.sh
source $testpath/includes/start_phone_fn.sh
source $testpath/includes/screen_decorations.sh
source $testpath/includes/pre_test_fn.sh
source $testpath/includes/post_test_fn.sh
source $testpath/includes/curl_fn.sh
source $testpath/includes/bolded_message_fn.sh

echo
set +e
bolded_message "Setup for Test Set 1. Begins at $(date)"
set -e

source $testpath/includes/validate_docker_network.sh

run_docker $loggerPort "logger" "Logger"
sleep 2

do_delete '{'$genKey'}' $loggerPort '/v1_00/log' "Clear logs."
sleep 1

run_docker $bluePort "bluetooth" "Bluetooth"                   # Bluetooth
run_docker $locPort "location_service" "Location_Service"      # Location Service
run_docker $monitorPort "monitor_app" "Monitor_App"            # Monitor App
run_docker $notesvcPort "notification" "Notification_Service"  # Notification Service
run_docker_phone                                               # Start the phone

echo ""
echo -n "Pausing to let services complete start-up: "
sleep 2
echo "done."

echo ""
echo "${underline}Starting phone screens${normal}"
echo ""
# Setup Jing to be able to see the phone
start_phone Jing

# Setup Bob to be able to see the phone
start_phone Bob

echo ""
echo "${underline}Configure logging.${normal}"
echo ""
config_logging $bluePort "Bluetooth"                 # Bluetooth
config_logging $locPort "Location Service"           # Location Service
config_logging $monitorPort "Monitor App"            # Monitor App
config_logging $notesvcPort "Notification Service"   # Notification Service
config_logging $phonePort "Phone"                    # Phone
echo ""
echo "Logging configured."
echo ""

set +e
bolded_message "Setup for Test Set 1. Ends at $(date)."
echo
