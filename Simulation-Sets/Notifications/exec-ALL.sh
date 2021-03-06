script_array=("1-Sending-Texts-Raising-Notifications" \
              "2-Hot-Spot-Notifications" \
              "3-Bluetooth-Sending-Texts-Raising-Notifications" \
              "4-Bluetooth-Hot-Spot-Notifications" \
              )
model_sets=("1-no-context-start" \
            "2-obfuscation-start" \
            "3-obfuscation-lock-start" \
            "4-context-start"
           )

# array lenght is number of items in the array, so -1 for [0..n]
simulation_name="Notifications"
model_set_length=${#model_sets[*]}

top_header_line=$(printf "%0.s=" {1..77})

let actual_length=(model_set_length-1)

# Loop through the array and execute the simulations
for i in `seq 0 1 ${actual_length}`;
do
    let vtu=(i+1)   # vtu = verstion to use
    echo
    echo ${top_header_line}
    echo "* Starting ${model_sets[$i]} at "$(date +"%H:%M:%S")
    echo ${top_header_line}
    $simpath/Simulation-Sets/${simulation_name}/exec-model-${vtu}.sh -v v${vtu}"_00"
    echo
done

