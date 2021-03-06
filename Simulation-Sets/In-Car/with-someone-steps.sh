# Starting Sue's phone screen
let test_id=test_id+1
pre_test $test_id "Starting Sue's phone screen."
# Phone Screen must be version 3
start_phone Sue "v3_00" $phone2RedisPort

let test_id=test_id+1
do_log "Log Sue phone screen started." $test_id

# Starting Andrews's phone screen
let test_id=test_id+1
pre_test $test_id "Starting Andrew's phone screen."
# Phone Screen must be version 3
start_phone Andrew "v3_00" $phone3RedisPort

let test_id=test_id+1
do_log "Log Andrew phone screen started." $test_id

# Log Bob and Sue enter car
let test_id=test_id+1
do_log "Log Bob and Sue enter the car" $test_id

#Pair Bob phone to Bluetooth
let test_id=test_id+1
bluetooth_device='"bluetooth":"'$serverIPName':'$bluePort'/'$presentAs'"'
data='{'$genKey', '$bluetooth_device'}'
do_post "${data}" \
        $phonePort \
        "/"$presentAs"/config/pair" \
        "Bob's phone is paired to the car Bluetooth system" \
        $test_id

# Log Bob can hear Bluetooth
let test_id=test_id+1
do_log "Log Bob is listening to Bluetooth" $test_id

# Log Sue can hear Bluetooth
let test_id=test_id+1
do_log "Log Sue is listening to Bluetooth" $test_id

# The Bluetooth system asks phones who is near. Sue's phone responds she is
# near Bob.
let test_id=test_id+1
do_post '{"ignore":"me"}' \
        $bluePort \
        "/"$presentAs"/imnear/Sue" \
        $test_id

# Lock Bob's phone
let test_id=test_id+1
data='{'$genKey'}'
do_post "${data}" \
        $phonePort \
        "/"$presentAs"/config/lock" \
        "Bob locks his phone and places it in his hands-free craddle." \
        $test_id

# Sleep to emulate driving
let test_id=test_id+1
pre_test $test_id "Emulating driving. Sleeping for 10 seconds"
sleep 10

# Send an SMS Message to the phone
let test_id=test_id+1
recipient='"recipient":"'$serverIPName':'$phonePort'/'$presentAs'/notification"'
sender='"sender":"SMS Service"'
action='"action":"Read Text"'
message='"message":"Hey Bob, my car has broken down. Any chance you can pick me up en-route? Andrew."'
data='{'$genKey', '$recipient', '$sender', '$action', '$message'}'
do_post "${data}" \
         $notesvcPort \
         "/"$presentAs"/notification" \
         "Bob receives an SMS from Andrew asking to be picked up." \
         $test_id

# Send a Medical Alert to the phone
let test_id=test_id+1
recipient='"recipient":"'$serverIPName':'$phonePort'/'$presentAs'/notification"'
sender='"sender":"Medical Alert"'
action='"action":"Suggest Exercises"'
message='"message":"Bob, your blood pressure is high. You need to relax, try these exercises"'
sensitivity='"sensitivity":true'
data='{'$genKey', '$recipient', '$sender', '$action', '$message', '$sensitivity'}'
do_post "${data}" \
         $notesvcPort \
         "/"$presentAs"/notification" \
         "Bob receives an alert from his medical monitoring system" \
         $test_id

# Sleep to emulate driving
let test_id=test_id+1
pre_test $test_id "Emulating driving. Sleeping for 10 seconds"
sleep 10

# Andrew gets in the car
let test_id=test_id+1
pre_test $test_id "Bob and Sue pick up Andrew"

# Log Andrew can hear Bluetooth
let test_id=test_id+1
do_log "Log Andrew is listening to Bluetooth" $test_id

# The Bluetooth system asks phones who is near. Sue and Andrew's phone responds
# they are near Bob.
let test_id=test_id+1
do_post '{"ignore":"me"}' \
        $bluePort \
        "/"$presentAs"/imnear/Sue" \
        $test_id

let test_id=test_id+1
do_post '{"ignore":"me"}' \
        $bluePort \
        "/"$presentAs"/imnear/Andrew" \
        $test_id

# Sleep to emulate driving
let test_id=test_id+1
pre_test $test_id "Emulating driving. Sleeping for 5 seconds"
sleep 5

# Send a Medical Alert to the phone
let test_id=test_id+1
recipient='"recipient":"'$serverIPName':'$phonePort'/'$presentAs'/notification"'
sender='"sender":"Medical Alert"'
action='"action":"Take Medication"'
message='"message":"Bob, your heart rate is dangerously high and you have not taken your medication yet. Please do so, now!"'
sensitivity='"sensitivity":true'
urgency='"urgency":true'
data='{'$genKey', '$recipient', '$sender', '$action', '$message', '$sensitivity','$urgency'}'
do_post "${data}" \
         $notesvcPort \
         "/"$presentAs"/notification" \
         "Bob receives an urgent alert from his medical monitoring system" \
         $test_id

# Sleep to emulate driving
let test_id=test_id+1
pre_test $test_id "Emulating driving. Sleeping for 5 seconds"
sleep 5

# Andrew can no longer see the screen
let test_id=test_id+1
pre_test $test_id "Andrew says bye to Bob and Sue as he leaves them. Andrew can no longer hear notifications."

let test_id=test_id+1
do_delete '{"ignore":"me"}' \
        $bluePort \
        "/"$presentAs"/imnear/Andrew" \
        "Andrew is no longer near Bob" \
        $test_id

# Sleep to emulate driving
let test_id=test_id+1
pre_test $test_id "Emulating driving. Sleeping for 5 seconds"
sleep 5

# Send a Medical Alert to the phone
let test_id=test_id+1
recipient='"recipient":"'$serverIPName':'$phonePort'/'$presentAs'/notification"'
sender='"sender":"Medical Alert"'
action='"action":"Confirmation Required"'
message='"message":"Bob, please confirm you have taken your medication."'
sensitivity='"sensitivity":true'
urgency='"urgency":true'
data='{'$genKey', '$recipient', '$sender', '$action', '$message', '$sensitivity','$urgency'}'
do_post "${data}" \
         $notesvcPort \
         "/"$presentAs"/notification" \
         "Bob receives an urgent alert from his medical monitoring system" \
         $test_id

# Log Jing's phone screen has started
let test_id=test_id+1
do_log "Log Andrew can no longer hear Bluetooth output." $test_id

# Sleep to emulate driving
let test_id=test_id+1
pre_test $test_id "Emulating driving. Sleeping for 10 seconds"
sleep 10

# Bob and Sue leave the car
let test_id=test_id+1
pre_test $test_id "Bob and Sue arrive at their destination and leave the car."

# Disconnect Phone from Bluetooth
let test_id=test_id+1
data='{'$genKey'}'
do_delete "${data}" \
        $phonePort \
        "/"$presentAs"/config/pair" \
        "The phone is no longer paired to the Bluetooth controller" \
        $test_id

# Log Bob can no longer hear Bluetooth
let test_id=test_id+1
do_log "Log Sue can no longer hear Bluetooth output." $test_id

# Log Sue can no longer hear Bluetooth
let test_id=test_id+1
do_log "Log Bob can no longer hear Bluetooth output." $test_id

#
# End of simulation, so shut down phone screens.
#

# Bob switches his phone off.
let test_id=test_id+1
pre_test $test_id "Bob switches his phone screen off."
stop_phone Bob

# Log it
let test_id=test_id+1
do_log "Log Bob phone screen stopped." $test_id

# Sue switches his phone off.
let test_id=test_id+1
pre_test $test_id "Sue switches her phone screen off."
stop_phone Sue $presentAs $phone2RedisPort

# Log it
let test_id=test_id+1
do_log "Log Sue phone screen stopped." $test_id

# Andrew switches his phone off.
let test_id=test_id+1
pre_test $test_id "Andrew switches his phone screen off."
stop_phone Andrew $presentAs $phone3RedisPort

# Log it
let test_id=test_id+1
do_log "Log Andrew phone screen stopped." $test_id

# Get the standard outputs
source $simpath/includes/get_standard_outputs.sh

# End simulation
let test_id=test_id+1
pre_test $test_id "Simulation completed. Remember to view the logs."
echo
stop_message "${sim_heading}"

exit







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


