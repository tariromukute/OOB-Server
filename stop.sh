#!/bin/bash
# Bind9 Basic Setup
#

# Update all Bind9 (and other) configs to setup
function stop_named {
    log "IN" "Restarting Bind9 service"
    systemctl stop named
}

function main {
    stop_named
}

main
