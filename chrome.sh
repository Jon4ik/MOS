#!/bin/bash

if [ ! $(whoami) == 'root' ]; then
	echo -e "\e[31mДанный скрипт должен быть запущен от root\e[0m"
    exit 1
fi

function install_chrome()
{
	dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm &> /dev/null
	
	echo -e "\e[92m[✔] Chrome скачен и установлен\e[0m"
	
	create_link "/usr/share/applications/google-chrome.desktop google-chrome.desktop"
}

function install_chrome_flatpak()
{
	echo -e "\e[92mОбновление и настройка Flatpack\e[0m"
    dnf install flatpak -y &> /dev/null
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &> /dev/null
    flatpak  update &> /dev/null
	
	echo -e "\e[92mУстановка Chrome\e[0m"
    flatpak install flathub com.google.Chrome -y &> /dev/null
	echo -e "\e[92m[✔] Chrome установлен\e[0m"
	create_link "/var/lib/flatpak/exports/share/applications/com.google.Chrome.desktop"
  
}

function remove_chrome()
{
	dnf remove google-chrome-stable -y &> /dev/null
	flatpak remove flathub com.google.Chrome -y &> /dev/null
	
	search_link "remove_link" 
}

function create_link()
{
	if [ id teacher &> /dev/null]; then
		cd /home/teacher/'Рабочий стол' && ln -sf $1 && echo -e "\e[92mСоздан ярлык на рабочем столе Учителя\e[0m"
	
	elif [ id student &> /dev/null]; then
		cd /home/student/'Рабочий стол' && ln -sf $1 && echo -e "\e[92mСоздан ярлык на рабочем столе Ученика\e[0m"
	
	else
		echo -e "\e[31mНе удалось найти пользователей teacher и student\e[0m"
		echo -e "\e[92mДля создания ярлыка выполните следующую команду: cd /home/<you user>/'Рабочий стол' && ln -sf $1\e[0m"
		exit 1
	fi
}

function remove_link()
{
	if [ id teacher &> /dev/null]; then
		rm -Rf /home/teacher/'Рабочий стол'/$1 && echo -e "\e[92mУдален ярлык на рабочем столе Учителя\e[0m"
	
	elif [ id student &> /dev/null]; then
		cd /home/student/'Рабочий стол'/$1 && echo -e "\e[92mУдален ярлык на рабочем столе Ученика\e[0m"

	else
		echo -e "\e[31mНе удалось найти пользователей teacher и student\e[0m"
		echo -e "\e[92mУдалите ярлык на рабочем столе вручную!\e[0m"
		exit 1
	fi
}

function search_link()
{
	if [ -f "/var/lib/flatpak/exports/share/applications/com.google.Chrome.desktop" ]; then
		$1 "/var/lib/flatpak/exports/share/applications/com.google.Chrome.desktop"
	elif [ -f "/usr/share/applications/google-chrome.desktop" ]; then
		$1 "/usr/share/applications/google-chrome.desktop"
	else
		echo -e "\e[31mНе удалось найти Chrome\e[0m"
		exit 1
	fi
}	

echo -e "\e[96mscript by Dmitry Nikishin"
echo -e "\e[96mhttps://t.me/Jon4ik"
echo -e "\e[96mhttps://github.com/Jon4ik/MOS"

for n in {3..0}; do
  printf "\r\e[92mОжидание запуска скрипта <%s> " $n
  sleep 1
done

echo -e "\033[0m"
PS3="Какую команда необходимо выполнить?: "
select model in "Установить Chrome" "Установить Chrome из flatpack" "Удалить Chrome" "Создать ярлык на Chrome"

do
  case $model in
          "Установить Chrome")
               install_chrome
               ;;
          "Установить Chrome из flatpack")
               install_chrome_flatpak
               ;;
           "Удалить Chrome")
              remove_chrome
               ;;
			"Создать ярлык на Chrome")
              search_link "create_link"
               ;;
              *)
              echo -e "Я Вас не понял. Пожалуйста, попробуйте ещё раз.";;
   esac
done
