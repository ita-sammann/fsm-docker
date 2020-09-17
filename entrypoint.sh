#!/bin/sh

init_config() {
    jq_cmd='.'

    if [ -n $ADMIN_USER ]; then
        jq_cmd="${jq_cmd} | .username = \"$ADMIN_USER\""
        echo "Admin username is '$ADMIN_USER'"
    fi
    if [ -n $ADMIN_PASS ]; then
        jq_cmd="${jq_cmd} | .password = \"$ADMIN_PASS\""
        echo "Admin password is '$ADMIN_PASS'"
    fi
    echo "IMPORTANT! Please create new user and delete default admin user ASAP."

    if [ -z $RCON_PASS ]; then
        RCON_PASS="$(random_pass)"
    fi
    jq_cmd="${jq_cmd} | .rcon_pass = \"$RCON_PASS\""
    echo "Factorio rcon password is '$RCON_PASS'"

    if [ -z $COOKIE_ENCRYPTION_KEY ]; then
        COOKIE_ENCRYPTION_KEY="$(random_pass)"
    fi
    jq_cmd="${jq_cmd} | .cookie_encryption_key = \"$COOKIE_ENCRYPTION_KEY\""

    jq_cmd="${jq_cmd} | .database_file = \"/opt/fsm-data/auth.leveldb\""
    jq_cmd="${jq_cmd} | .log_file = \"/opt/fsm-data/factorio-server-manager.log\""

    jq "${jq_cmd}" /opt/fsm/conf.json >/opt/fsm-data/conf.json
}

random_pass() {
    LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 24 | head -n 1
}

update_game() {
    current=`/opt/factorio/bin/x64/factorio --version | grep 'Version:' | awk '{ print $2 }'`
    latest=`curl -sS https://factorio.com/api/latest-releases | jq ".experimental.headless" | tr -d '"'`
    echo "Current game version: $current, Latest game version: $latest"

    if verlt $current $latest; then
        echo "There is new Factorio version available. Starting update process."

        curl --location "https://www.factorio.com/get-download/latest/headless/linux64" --output /tmp/factorio_latest.tar.xz \
        && tar -xf /tmp/factorio_latest.tar.xz \
        && rm /tmp/factorio_latest.tar.xz

        echo "Update successfull."
    else
        echo "Current Factorio version is up to date."
    fi
}

verlte() {
    [  "$1" = `echo -e "$1\n$2" | sort -V | head -n1` ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}

if [ ! -f /opt/fsm-data/conf.json ]; then
    init_config
fi

if [ "$UPDATE" == "true" ]; then
    update_game
fi

cd /opt/fsm && ./factorio-server-manager -conf /opt/fsm-data/conf.json -dir /opt/factorio -port 80

