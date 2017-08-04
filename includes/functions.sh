#!/bin/bash

compil_lftp () {

    mkdir /tmp/lftp
    cd /tmp/lftp
    apt install openssl build-essential libreadline-dev libssl-dev ncurses-dev libgnutls28-dev pkg-config
    wget http://lftp.yar.ru/ftp/$(wget -O- http://lftp.yar.ru/ftp/ | egrep -o 'lftp-[0-9\.]+.tar.gz' | sort -V  | tail -1)
    tar zxvf lftp-*.tar.gz
    cd lftp-*
    ./configure --with-openssl
    make -j$(nproc)
    make install
    echo 'set sftp:auto-confirm yes' > /usr/local/etc/lftp.conf
    
}

display_logo () {

    clear

    printf "${green}${bold}"
    echo '       __      __                             '
    echo '  ____/ /___ _/ /_     _________  ____ _____  '
    echo ' / __  / __ `/ __/    / ___/ __ \/ __ `/ __ \ '
    echo '/ /_/ / /_/ / /_     (__  ) / / / /_/ / /_/ / '
    echo '\__,_/\__,_/\__/____/____/_/ /_/\__,_/ .___/  '
    echo '              /_____/               /_/       '
    printf "${normal}"
    echo '                     https://datno.de         '
    echo ''
}

loading() {
    
    echo -ne '[-] \r'
    sleep 0.1
    echo -ne '[\]\r'
    sleep 0.1
    echo -ne '[|]\r'
    sleep 0.1
    echo -ne '[/]\r'
    sleep 0.1
    echo -ne '[-] \r'
    sleep 0.1
    echo -ne '[\]\r'
    sleep 0.1
    echo -ne '[|]\r'
    sleep 0.1
    echo -ne '[/]\r'
    sleep 0.1
    echo -ne '[-] \r'
    sleep 0.1
    echo -ne '[\]\r'
    sleep 0.1
    echo -ne '[|]\r'
    sleep 0.1
    
}