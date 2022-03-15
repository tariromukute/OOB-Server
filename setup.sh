#!/bin/bash
# Bind9 Basic Setup
#
# Description: The following shell script sets up Bind9 with basic configuration
#              primarily having the server act as an open DNS resolver for certain
#              vulnerabilities (i.e. DNSRCE).
#
# Author: Juxhin Dyrmishi Brigjaj
# Version: 1.0.0
#


# Config for /etc/bind/named.conf.log
readonly BIND_NAMED_CONF_LOG="
"

# Load utility shells
source "$(dirname "$0")/inc/log.sh"
source "$(dirname "$0")/inc/utils.sh"
source "$(dirname "$0")/inc/color.sh"

# Update all Bind9 (and other) configs to setup
function update_configs {
    log "IN" "Updating all Bind9 configurations"
    local -r BASE_BIND_PATH="/etc/bind"


    log "DB" "Adding named.conf.options to ${BASE_BIND_PATH}/named.conf.options"
    verify_file_exists "${BASE_BIND_PATH}/named.conf.options"
    truncate -s 0 "${BASE_BIND_PATH}/named.conf.options"
    cat "${PWD}/_config/named.conf.options" > "${BASE_BIND_PATH}/named.conf.options"

    log "DB" "Creating named.conf.log and including it in named.conf"
    touch "${BASE_BIND_PATH}/named.conf.log"
    cat "${PWD}/_config/named.conf.log" > "${BASE_BIND_PATH}/named.conf.log"
    echo "include \"/etc/bind/named.conf.log\";" >> "${BASE_BIND_PATH}/named.conf"

    log "DB" "Setting up lograte for bind"
    touch "/etc/logrotate.d/bind"
    cat "${PWD}/_config/logrotate" > "/etc/logrotate.d/bind"

    log "DB" "Overwrite Bind9 default file"
    cat "${PWD}/_config/bind9" > "/etc/default/bind9"
}

function main {
    update_configs
}

main
