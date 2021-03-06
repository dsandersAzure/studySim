#!/bin/bash
#    Simulation Set: Sending text raising notifications
#    ------------------------------------------------------------------------
#    Author:      David J. Sanders
#    Student No:  H00035340
#    Date:        12 Apr 2016
#    ------------------------------------------------------------------------
#    Overivew:   Jing is using a smart phone to receive notifications. He is
#                travelling on a train with his friend Bob. At certain points in
#                the train journey, Bob can see Jing's phone. The objective of 
#                the simulation is to understand if Bob sees any sensitive or 
#                confidential notifications during the journey.
#
#                Bob's view of the phone is saved in Bob.txt
#                Jing's view of the phone is saved in Jing.txt\
#                Logs and the actual phone screen are saved at the end of the
#                simulation set. 
#
#    Revision History
#    --------------------------------------------------------------------------
#    Date         | By             | Reason
#    --------------------------------------------------------------------------
#    12 Apr 2016  | D Sanders      | Revised structure for simulations.
#
#
#================= Scenario Init - Validate $simpath exists ====================
#
# Simulation Setup
#
if [ "X"$simpath == "X" ]; then
    echo "ERROR: simpath is not defined!"
    echo ""
    echo "Before running this script, ensure that simpath is defined:"
    echo ""
    echo "  export simpath=/path/to/studySim"
    echo
    exit 1
fi

simulation="1"
simulation_includes=$simpath/Simulation-Sets/Notifications/includes
source $simpath/includes/check_params.sh
source $simpath/includes/setup.sh
source $simpath/includes/set_version.sh
source $simpath/includes/set_outputs.sh
#
# Simulation 2 Configuration
#
sim_heading="Simulation 1: Sending texts and raising notifications."
over_view="Jing is using a smart phone to receive notifications. He is travelling "
over_view=$over_view"on a train (or car) with his friend Bob. At certain points in the train journey, "
over_view=$over_view"Bob can see Jing's phone. The objective of the simulation is to "
over_view=$over_view"understand if Bob sees any sensitive or confidential notifications "
over_view=$over_view"during the journey.\n\n"
over_view=$over_view"Bob's view of the phone is saved in Bob.txt\n"
over_view=$over_view"Jing's view of the phone is saved in Jing.txt\n"
over_view=$over_view"Logs and the actual phone screen are saved at the end of the "
over_view=$over_view"simulation"

echo
echo "Simulation Overview"
echo "==================="
printf "$over_view"
echo

pause "Please ensure setup has been run before the simulation "

set +e
start_message "${sim_heading}"

# Setup the phone for monitored apps
source $simulation_includes/configure-monitored-apps.sh

# Starting Jing's phone screen
let test_id=test_id+1
pre_test $test_id "Sarting Jing's phone screen."
# Phone Screen must be version 3
start_phone Jing "v3_00"

let test_id=test_id+1
do_log "Log Jing phone screen started." $test_id

# Lock the phone
let test_id=test_id+1
data='{'$genKey'}'
do_post "${data}" \
        $phonePort \
        "/"$presentAs"/config/lock" \
        "Jing locks his phone and places it on the train table." \
        $test_id

# Bob sits with Jing and can see the phone screen
let test_id=test_id+1
pre_test $test_id "Bob sits with Jing and can see the phone screen."
# Phone Screen must be version 3
start_phone Bob "v3_00"

let test_id=test_id+1
do_log "Log Bob phone screen started." $test_id

# Send an SMS Message to the phone
let test_id=test_id+1
recipient='"recipient":"'$serverIPName':'$phonePort'/'$presentAs'/notification"'
sender='"sender":"SMS Service"'
action='"action":"Read Text"'
message='"message":"This is a text message received via SMS"'
data='{'$genKey', '$recipient', '$sender', '$action', '$message'}'
do_post "${data}" \
         $notesvcPort \
         "/"$presentAs"/notification" \
         "Jing receives an SMS (text) Message." \
         $test_id

# Send an SMS Message to the phone
let test_id=test_id+1
recipient='"recipient":"'$serverIPName':'$phonePort'/'$presentAs'/notification"'
sender='"sender":"SMS Service"'
action='"action":"Read Text"'
message='"message":"profanity !!**!! What a day I have had"'
data='{'$genKey', '$recipient', '$sender', '$action', '$message'}'
do_post "${data}" \
         $notesvcPort \
         "/"$presentAs"/notification" \
         "Jing receives an SMS (text) Message with a profanity." \
         $test_id

# Unlock the phone
let test_id=test_id+1
data='{'$genKey'}'
do_put "${data}" \
       $phonePort \
       "/"$presentAs"/config/unlock" \
       "Jing unlocks the phone to use it." \
       $test_id

# Launch the Facebook client - A Notification will NOT be issued
let test_id=test_id+1
data='{'$genKey'}'
do_post "${data}" \
        $phonePort \
        "/"$presentAs"/config/launch/facebook" \
        "Jing launches Facebook on his phone and uses the app." \
        $test_id

# Launch Grindr - A Notification will be issued
let test_id=test_id+1
data='{'$genKey'}'
do_post "${data}" \
        $phonePort \
        "/"$presentAs"/config/launch/grindr" \
        "By mistake, Jing launches Grindr and a notification on safe sex appears. Can Bob see it?" \
        $test_id

# Pause for 5 seconds to let the notification be detected
let test_id=test_id+1
pre_test $test_id "It is 30 seconds before Jing notices the notification."
sleep 30
echo

# Lock the phone
let test_id=test_id+1
data=""
do_post "${data}" \
         $phonePort \
         "/"$presentAs"/config/lock" \
         "Jing rapidly locks his phone" \
         $test_id

# Send an SMS Message to the phone
let test_id=test_id+1
recipient='"recipient":"'$serverIPName':'$phonePort'/'$presentAs'/notification"'
sender='"sender":"SMS Service"'
action='"action":"Read Text"'
message='"message":"I am still at Starbucks. Pick me up, please? Clair and Gordon."'
data='{'$genKey', '$recipient', '$sender', '$action', '$message'}'
do_post "${data}" \
         $notesvcPort \
         "/"$presentAs"/notification" \
         "Jing receives another SMS Message" \
         $test_id

# Bob can no longer see the screen
let test_id=test_id+1
pre_test $test_id "Bob says bye to Jing and leaves the train at his stop. Bob can no longer see Jing's phone screen."
stop_phone Bob

# Log Bob has left Jing
let test_id=test_id+1
do_log "Log Bob phone screen stopped." $test_id

# Pause for 5 seconds to let the notification be detected
let test_id=test_id+1
pre_test $test_id "Sleeping for 5 seconds to persist notifications."
sleep 5
echo

# Unlock the phone - will cause stored notifications to be processed.
let test_id=test_id+1
data='{'$genKey'}'
do_put "${data}" \
       $phonePort \
       "/"$presentAs"/config/unlock" \
       "Jing unlocks the phone to use it - stored notifications will be shown." \
       $test_id

# Pause for 10 seconds to allow any notifications to be detected.
let test_id=test_id+1
pre_test $test_id "Pause for 10 seconds to allow any notifications to be detected."
sleep 10
echo

# Disconnect the phone from monitored apps
source $simulation_includes/unconfigure-monitored-apps.sh

# Stopping Jing's phone screen
let test_id=test_id+1
pre_test $test_id "Jing arrives at his destination and is going into a meeting, so switches his phone off."
stop_phone Jing

# Write to the log that Jing's phone has stopped
let test_id=test_id+1
do_log "Log Jing phone screen stopped." $test_id

# Get the standard outputs
source $simpath/includes/get_standard_outputs.sh

# End simulation
let test_id=test_id+1
pre_test $test_id "Simulation completed. Remember to view the logs."
echo
stop_message "${sim_heading}"

