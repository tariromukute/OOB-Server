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
# Usage: setup DOMAIN_NAME DOMAIN_IP
#        setup foo.bid 1.1.1.1
#        setup -h
#        setup --help

# Set initial placeholder value for the user domain
DOMAIN_NAME=""
DOMAIN_IP=""

# Config for /etc/bind/named.conf.log
readonly BIND_NAMED_CONF_LOG="
"

# Load utility shells
source "$(dirname "$0")/inc/log.sh"
source "$(dirname "$0")/inc/utils.sh"
source "$(dirname "$0")/inc/color.sh"

function usage_general {
  echo -e "
Usage: ${0#\.\/} DOMAIN_NAME DOMAIN_IP
       ${0#\.\/} foo.bid 1.1.1.1
       ${0#\.\/} -h
       ${0#\.\/} --help

Provision Bind9 for specified domain name to act as an open DNS resolver.

Options:
  -h, --help                           Print this help message
"
  exit
}

# Update all Bind9 (and other) configs to setup
function update_configs {
    log "IN" "Updating all Bind9 configurations"
    local -r BASE_BIND_PATH="/etc/bind"

    # log "DB" "Adding db.local to ${BASE_BIND_PATH}/db.local"
    # verify_file_exists "${BASE_BIND_PATH}/db.local"
    # truncate -s 0 ${BASE_BIND_PATH}/db.local
    # awk -v domain_name="${DOMAIN_NAME}" -v domain_ip="${DOMAIN_IP}" '{ gsub("DOMAIN_NAME", domain_name); gsub("DOMAIN_IP", domain_ip); print $0 }' "${PWD}/_config/db.local" > "${BASE_BIND_PATH}/db.local"

    # Add the domain zone into the list of zones to have permission to answer to queries
    echo "
zone \"${DOMAIN_NAME}\" {
      type master;
      file \"/etc/bind/db.${DOMAIN_NAME}\";
};
    " >> "${BASE_BIND_PATH}/named.conf.local"


    log "DB" "Adding named.conf.options to ${BASE_BIND_PATH}/named.conf.options"
    verify_file_exists "${BASE_BIND_PATH}/named.conf.options"
    truncate -s 0 "${BASE_BIND_PATH}/named.conf.options"
    cat "${PWD}/_config/named.conf.options" > "${BASE_BIND_PATH}/named.conf.options"

    echo "
\$TTL   604800
@	IN	SOA	${DOMAIN_NAME}.	root.${DOMAIN_NAME}.(
            2019032700          ; Serial    
            604800              ; Refresh
            86400               ; Retry
            2419200             ; Expire
            604800 )            ; Negative Cache TTL
;
@	IN	NS	ns.${DOMAIN_NAME}
@	IN	A	${DOMAIN_IP}
@	IN	AAAA	::1
ns  IN  A   ${DOMAIN_IP} 
    " >> "${BASE_BIND_PATH}/db.${DOMAIN_NAME}"

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

# Preflight checks

# Show usage if no arguments are passed
if [ "$1" = "" ]; then
    usage_general
fi

case $1 in
    -h | --help ) usage_general
esac

DOMAIN_NAME="${1}"
DOMAIN_IP="${2}"

main
