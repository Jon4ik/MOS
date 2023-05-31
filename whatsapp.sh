#!/bin/bash

if [ ! $(whoami) == 'root' ]; then
    echo -e "\e[31mДанный скрипт должен быть запущен от root\e[0m"
    exit 1
fi

os_version="$(grep '^VERSION=' /etc/os-release)"

if [ $os_version != 'VERSION="12"' ]; then
    echo -e "\e[31mДанный скрипт написан для M OS 12\e[0m"
    exit 1
fi


function install_flatpak()
{
    echo -e "\e[92mОбновление и настройка FlatPak\e[0m"
    dnf install flatpak -y &> /dev/null
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &> /dev/null
    flatpak  update &> /dev/null

   install_whatsapp
}

function create_link()
{
    if [id teacher &> /dev/null]; then
        cd /home/teacher/'Рабочий стол'/ && ln -sf /var/lib/flatpak/exports/share/applications/com.github.eneshecan.WhatsAppForLinux.desktop &&  echo -e "\e[92m[✔] Ярлык на рабочем столе создан\e[0m"
    else
        echo -e "\e[31mНе удалось найти пользователя teacher\e[0m"
        echo -e "\e[92mДля создания ярлыка выполните следующую команду: \033[0mcd /home/<you user>/'Рабочий стол' && ln -sf /var/lib/flatpak/exports/share/applications/com.github.eneshecan.WhatsAppForLinux.desktop\e[0m"
    fi
    exit
}

function install_whatsapp()
{
    echo -e "\e[92mУстановка Whatsapp\e[0m"
    flatpak install flathub com.github.eneshecan.WhatsAppForLinux -y &> /dev/null
    echo -e "\e[92m[✔] Установлен Whatsapp\e[0m"

    create_link
}

function remove_whatsapp()
{
    echo -e "\e[92mУдаление Whatsapp\e[0m"
    flatpak remove com.github.eneshecan.WhatsAppForLinux -y  &> /dev/null
    echo -e "\e[92m[✔] Whatsapp удален\e[0m"

    if [id teacher &> /dev/null]; then
        rm -f /home/teacher/'Рабочий стол'/com.github.eneshecan.WhatsAppForLinux.desktop &&  echo -e "\e[92m[✔] Ярлык на рабочем столе удален\e[0m"
    else
        echo -e "\e[31mНе удалось найти пользователя teacher\e[0m"
        echo -e "\e[92mДля удаления ярлыка выполните следующую команду: \033[0mrm -f /home/teacher/'Рабочий стол'/com.github.eneshecan.WhatsAppForLinux.desktop\e[0m"
    fi

    exit
}

echo -e "\e[96mscript by Dmitry Nikishin and Maksim Marinin"
echo -e "\e[96mhttps://t.me/Jon4ik and https://t.me/darkmaxoff"
echo -e "\e[96mhttps://github.com/Jon4ik/MOS"

for n in {3..0}; do
  printf "\r\e[92mОжидание запуска скрипта <%s> " $n
  sleep 1
done

echo -e "\033[0m"
PS3="Какую команда необходимо выполнить?: "
select model in "Установить Whatsapp" "Удалить Whatsapp" "Создать ярлык на Whatsapp"

do
  case $model in
          "Установить Whatsapp")
               install_flatpak
               ;;
          "Удалить Whatsapp")
               remove_whatsapp
               ;;
           "Создать ярлык на Whatsapp")
              create_link
               ;;
              *)
              echo -e "Я Вас не понял. Пожалуйста, попробуйте ещё раз.";;
   esac
done
