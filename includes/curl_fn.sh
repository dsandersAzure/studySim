function do_log {
    # $1 - message
    # $2 - Test Number

    sender='"sender":"SIM-ENGINE"'
    logtype='"log-type":"normal"'
    message='"message":"*** SIMENGINE '$1'"'
    data='{'$genKey', '$logtype', '$sender', '$message'}'

    pre_test $2 "${1}"
    curl -X POST \
        -d "${data}" \
        $serverName:$loggerPort/$presentAs/log

    post_test
}

function do_post {
    # $1 - data string
    # $2 - portNumber
    # $3 - URL
    # $4 - Heading
    # $5 - Test Number
    pre_test $5 "${4}"
    curl -X POST \
        -d "${1}" \
        $serverName:$2$3
    post_test
}

function do_put {
    # $1 - data string
    # $2 - portNumber
    # $3 - URL
    # $4 - Heading
    # $5 - Test Number
    pre_test $5 "${4}"
    curl -X PUT \
        -d "${1}" \
        $serverName:$2$3
    post_test
}

function do_delete {
    # $1 - data string
    # $2 - portNumber
    # $3 - URL
    # $4 - Heading
    # $5 - Test Number
    pre_test $5 "${4}"
    curl -X DELETE \
        -d "${1}" \
        $serverName:$2$3
    post_test
}

function do_get {
    # $1 - data string
    # $2 - portNumber
    # $3 - URL
    # $4 - Heading
    # $5 - Test Number

    pre_test $5 "${4}"
    curl -X GET \
        -d "${1}" \
        $serverName:$2$3
    post_test
}

