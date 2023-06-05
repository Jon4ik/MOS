#!/bin/bash

if [ ! $(whoami) == 'root' ]; then
	echo -e "\e[31mДанный скрипт должен быть запущен от root\e[0m"
    exit 1
fi

echo -e "\e[96mscript by Dmitry Nikishin"
echo -e "\e[96mhttps://t.me/Jon4ik"
echo -e "\e[96mhttps://github.com/Jon4ik/MOS"

for n in {3..0}; do
  printf "\r\e[92mОжидание запуска скрипта <%s> " $n
  sleep 1
done

mkdir /root/temp_chrome_install

cd /root/temp_chrome_install

wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm &> /dev/null && dnf install /root/temp_chrome_install/google-chrome-stable_current_x86_64.rpm -y &> /dev/null

if [ id teacher &> /dev/null]; then
	cd /home/teacher/'Рабочий стол' && ln -sf /usr/share/applications/google-chrome.desktop google-chrome.desktop && echo -e "\e[92mСоздан значек на рабочем столе Учителя\e[0m"
	
elif [ id student &> /dev/null]; then
	cd /home/student/'Рабочий стол' && ln -sf /usr/share/applications/google-chrome.desktop google-chrome.desktop && echo -e "\e[92mСоздан значек на рабочем столе Ученика\e[0m"

else
	echo -e "\e[31mНе удалось найти пользователей teacher и student\e[0m"
	echo -e "\e[92mДля создания ярлыка выполните следующую команду: cd /home/<you user>/'Рабочий стол' && ln -sf /usr/share/applications/google-chrome.desktop google-chrome.desktop\e[0m"
    exit 1
fi

rm -Rf /root/temp_chrome_install
