function start_phone {
    # $1 - stage
    # $2 - Phone Screen viewer, e.g. Bob, Jing, or David, etc.
    echo -n "Add "${2}" as a phone screen viewer. Output will be in ${2}.txt: "
    check_docker ${1}"phone_screen_"${2}   # sets $DOCKER_CHECK
    if [ "X" == "${DOCKER_CHECK}" ]; then
        docker run --name $1"phone_screen_"${2} \
            --net=isolated_nw \
            -t dsanderscan/mscit_$1phone_screen \
            /Phone_Screen/Phone_Screen.py --server "$serverIP" --port 16379 > "${2}.txt" &
        sleep 2
        echo "started."
    else
        echo "Phone screen already running."
    fi
}


