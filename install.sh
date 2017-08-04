#!/bin/bash

. includes/functions.sh
. includes/variables.sh

display_logo

echo ""
echo -e "${cyan}Verification of prerequisites : ${normal}" 
loading

# check_root

if [[ $EUID -ne 0 ]]; then
    display_logo
	echo -e "${red}This script must be run as root.${normal}" 1>&2
	echo""
    exit 1
fi

command -v lftp > /dev/null 2>&1
if [ $? != 0 ]; then
    while true; do
        display_logo
        echo -e "${red}LFTP must be installed.${normal}"           
        read -rp "Would you like to install it ? ( yes / no ) : " check_install_var
        if [[ "$check_install_var" = "yes" ]] || [[ "$check_install_var" = "y" ]]; then
            display_logo
            apt install lftp -y
            echo 'set sftp:auto-confirm yes' > /etc/lftp.conf
            break
        elif [[ "$check_install_var" = "no" ]] || [[ "$check_install_var" = "n" ]]; then
            display_logo
            exit 0
        else
            display_logo
            echo -e "${red}Please enter yes or no.${normal}"
            sleep 3
        fi
    done
else
    echo 'set sftp:auto-confirm yes' >> /etc/lftp.conf
fi

command -v gpg > /dev/null 2>&1
if [ $? != 0 ]; then
    while true; do
        display_logo
        echo -e "${red}GnuPG must be installed.${normal}"           
        read -rp "Would you like to install it ? ( yes / no ) : " check_install_var
        if [[ "$check_install_var" = "yes" ]] || [[ "$check_install_var" = "y" ]]; then
            display_logo
            apt install gpg -y
            break
        elif [[ "$check_install_var" = "no" ]] || [[ "$check_install_var" = "n" ]]; then
            display_logo
            exit 0
        else
            display_logo
            echo -e "${red}Please enter yes or no.${normal}"
            sleep 3
        fi
    done
fi

clear
    display_logo
    echo ""
    read -rp "SFTP remote server : " rs_host
    read -rp "SFTP port ( 22 by default ) : " rs_port
    read -rp "SFTP remote path : " rs_path
    read -rp "SFTP remote user : " rs_user
    read -srp "SFTP password : " rs_pass

    if [[ "$rs_port" = "" ]]; then
        rs_port="22"
fi

until  lftp -d -e "ls; bye" -u $rs_user,$rs_pass -p $rs_port sftp://$rs_host 2> "$log_file" > /dev/null
		do
    grep -i "150\(.*\)connection" $log_file

    if [[ $? -eq 0 ]]; then
        break
    fi

    clear
    display_logo

    echo ""
    loading
    clear
    display_logo
    echo""
    echo -e "${red}Connection error.${normal}" 1>&2
    echo -e "${red}Please check $log_file.${normal}" 1>&2
    exit 1
done

display_logo
loading

display_logo
echo -e "${green} Connection OK.${normal}"
echo ""
sleep 2

display_logo

echo -e "${cyan}Updates to connection settings.${normal}"
loading
sed -i -e "s/\(rs_host=\).*/\1'$rs_host'/" \
       -e "s/\(rs_user=\).*/\1'$rs_user'/" \
       -e "s/\(rs_pass=\).*/\1'$rs_pass'/" \
       -e "s/\(rs_port=\).*/\1'$rs_port'/" \
       -e "s/\(rs_path=\).*/\1'$rs_path'/" includes/variables.sh

cat > $(pwd)/.excluded-paths <<EOF
/dev
/lost+found
/media
/mnt
/proc
/run
/sys
/tmp
/var/cache
/var/backup
/opt/dat_snap
EOF

display_logo
echo ""
echo "0 23 * * * cd /opt/dat_snap ; /opt/dat_snap/backup.sh >/dev/null 2>&1"
