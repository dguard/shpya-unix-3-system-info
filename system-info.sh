#!/usr/bin/env bash

echo "Список последних входивших пользователей:"
last -n 10 | head -10 | awk '{print $1, $4, $5, $6, $7}'

echo -e "\nКоличество процессов:"
ps -e | wc -l

function get_status() {
    if [[ `ps aux | grep ${1} | wc -l` -ge "2" ]];
    then
        echo "* ${1} is running"
    elif [ ! -f /etc/init.d/${1} ]; then
        echo "* ${1} is not installed"
    else
        echo "* ${1} is stopped"
    fi
}

echo -e "\nСтатус сервисов:"
get_status apache2
get_status nginx
get_status mysql
get_status gunicorn
get_status ssh
get_status apport
get_status lightdm
get_status samba

echo -e "\nIP-адреса сетевых интерфейсов"
ifconfig | grep encap -A 1 | sed -re "s|\s+\S+\sencap.+||g" \
    | sed -re "s#\s+inet addr:(\w+.\w+.\w+.\w+).+#\1#g" | tail -n +4

echo -e "\nИнформация RAM:"
free | head -2

echo -e "\nИнформация о устройствах:"
df -h | awk '{print $1, $2, $3, $5, $6}' | column -t