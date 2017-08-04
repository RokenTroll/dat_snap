#!/bin/bash

. includes/functions.sh
. includes/variables.sh

display_logo
echo -e "${cyan}Backup in progress${normal}"

tar --warning=none -cpPzf "$(pwd)/$archive_name.tar.gz" --exclude-from=$(pwd)/.excluded-paths / 2> "$log_file"

lftp -d -e "cd $rs_path; \
            put $(pwd)/$archive_name.tar.gz; \
            bye" -u $rs_user,$rs_pass -p $rs_port sftp://$rs_host 2> "$log_file" > /dev/null

rm $(pwd)/$archive_name.tar.gz