# array lenght is number of items in the array, so -1 for [0..n]
let actual_length=(array_length-1)

# Loop through the array and execute the simulations
for i in `seq 0 1 ${actual_length}`;
do
    echo
    echo $header_line
    echo "** Starting ${script_array[$i]} at "$(date +"%H:%M:%S")
    echo $header_line
    echo
    $simpath/Scenario-Setup/${scenario_name}/${model_set}.sh "$@"
    $simpath/Simulation-Sets/${simulation_name}/${script_array[$i]}.sh "$@"
    $simpath/Scenario-Setup/${scenario_name}/${scenario_stop}.sh "$@"
    echo
    echo $header_line
    echo "** Completed ${script_array[$i]} at "$(date +"%H:%M:%S")
    echo $header_line
    echo
done

