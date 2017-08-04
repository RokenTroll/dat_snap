#!/bin/bash

if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"
    purple="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    grey="$(tput setaf 7)"
    bold="$(tput bold)"
    normal="$(tput sgr0)"
else
    red=""
    green=""
    yellow=""
    blue=""
    bold=""
    normal=""
fi

log_file="$(pwd)/log_file"

archive_name="$(hostname -f)_$(date +%d.%m.%Y_%H-%M)"

rs_host=''
rs_user=''
rs_pass=''
rs_port=''
rs_path=''