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
function start_named {
    log "IN" "Reloading logrotate to take effect on new Bind9 logs"
    logrotate -d "/etc/logrotate.d/bind"

    log "IN" "Restarting Bind9 service"
    systemctl restart named
}

function main {
    start_named
}

main
