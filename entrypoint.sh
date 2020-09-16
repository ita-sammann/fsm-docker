#!/bin/sh

init_config() {
    jq_cmd='.'

    if [ -n $ADMIN_USER ]; then
        jq_cmd="${jq_cmd} | .username = \"$ADMIN_USER\""
    fi
    if [ -n $ADMIN_PASS ]; then
        jq_cmd="${jq_cmd} | .password = \"$ADMIN_PASS\""
    fi

    if [ -z $RCON_PASS ]; then
        RCON_PASS="$(random_pass)"
    fi
    jq_cmd="${jq_cmd} | .rcon_pass = \"$RCON_PASS\""

    if [ -z $COOKIE_ENCRYPTION_KEY ]; then
        COOKIE_ENCRYPTION_KEY="$(random_pass)"
    fi
    jq_cmd="${jq_cmd} | .cookie_encryption_key = \"$COOKIE_ENCRYPTION_KEY\""

    jq_cmd="${jq_cmd} | .database_file = \"/opt/fsm-data/auth.leveldb\""
    jq_cmd="${jq_cmd} | .log_file = \"/opt/fsm-data/factorio-server-manager.log\""

    echo "JQ CMD: $jq_cmd"
    jq "$jq_cmd" /opt/fsm/conf.json >/opt/fsm-data/conf.json
}

random_pass() {
    LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 24 | head -n 1
}

if [ ! -f /opt/fsm-data/conf.json ]; then
    init_config
fi

cd /opt/fsm && ./factorio-server-manager -conf /opt/fsm-data/conf.json -dir /opt/factorio

