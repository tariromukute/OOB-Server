#!/bin/bash
# Bind9 Basic Setup
#

# Config for /etc/bind/named.conf.log
readonly BIND_NAMED_CONF_LOG="
"

# Load utility shells
source "$(dirname "$0")/inc/log.sh"
source "$(dirname "$0")/inc/utils.sh"
source "$(dirname "$0")/inc/color.sh"

# Update all Bind9 (and other) configs to setup
function stop_named {
    log "IN" "Restarting Bind9 service"
    systemctl stop named
}

function main {
    stop_named
}

main
