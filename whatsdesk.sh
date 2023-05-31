#!/bin/bash
###
###	@script_author Dmitry Nikishin
### https://t.me/Jon4ik
### https://github.com/Jon4ik/MOS
###

if [ ! $(whoami) == 'root' ]; then
	echo -e "\e[31mДанный скрипт должен быть запущен от root\e[0m"
    exit 1
fi

os_version="$(grep '^VERSION=' /etc/os-release)"

if [ $os_version != 'VERSION="12"' ]; then
	echo -e "\e[31mДанный скрипт написан для M OS 12\e[0m"
    exit 1
fi

dnf install snapd -y

service snapd start
systemctl enable snapd

echo -e "\e[92mУстановлен и запущен Snap\e[0m"

snap install whatsdesk

echo -e "\e[92mУстановлен Whatsapp\e[0m"

rm -f /var/cache/fontconfig/*
rm -f ~/.cache/fontconfig/*

echo -e "\e[92mУдаляем КЭШ шрифтов\e[0m"

cd /home/teacher/'Рабочий стол'/ && ln -sf /var/lib/snapd/desktop/applications/whatsdesk_whatsdesk.desktop &&  echo -e "\e[92mЯрлык на рабочем столе создан\e[0m"

echo -e "\e[92mПерезагрузка\e[0m" && reboot
