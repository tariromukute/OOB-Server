#!/bin/bash
# Bind9 Basic Setup
#

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
