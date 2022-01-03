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

# Update APT repository and install Bind9 package
function install_dependencies {
    log "IN" "Update APT and installing Bind9 package"
    apt update
    apt install bind9 logrotate dnsutils systemctl -y
}

# Setup any paths that are required, such as log path
function setup_paths {
    log "IN" "Setting up paths and permissions for Bind9 logs"
    mkdir -p /var/log/named
    chown -R bind:root /var/log/named
    chmod -R 775 /var/log/named
}

function main {
    install_dependencies
    setup_paths
}

main
