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

epm ei --auto
epm play chrome --auto

if [ id teacher &> /dev/null]; then
	cd /home/teacher/'Рабочий стол' && ln -sf /usr/share/applications/google-chrome.desktop google-chrome.desktop && echo -e "\e[92mСоздан значек на рабочем столе Учителя\e[0m"
	
elif [ id student &> /dev/null]; then
	cd /home/student/'Рабочий стол' && ln -sf /usr/share/applications/google-chrome.desktop google-chrome.desktop && echo -e "\e[92mСоздан значек на рабочем столе Ученика\e[0m"

else
	echo -e "\e[31mНе удалось найти пользователей teacher и student\e[0m"
	echo -e "\e[92mДля создания ярлыка выполните следующую команду: cd /home/<you user>/'Рабочий стол' && ln -sf /usr/share/applications/google-chrome.desktop google-chrome.desktop\e[0m"
    exit 1
fi

