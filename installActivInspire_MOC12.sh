#!/usr/bin/env bash

# Скрипт для МОС12 на базе РОСА Линукс
# скрипт устанавливает Promethean ActivInspire в домашнюю директорю пользователя
# запускать от root, поскольку скрипт устанавилвает системные пакеты с зависимостями и создает ссылки для библиотек
# $ su -
# # bash installActivInspire.sh


# создать временную директорию

workdir=$TMPDIR/install-ActivInspire
rm -rf $workdir
mkdir $workdir
cd $workdir


# скачать пакеты

links=(
    "https://activsoftware.co.uk/linux/repos/ubuntu/pool/bionic/a/ac/activinspire_1804-2.23.69368-1-amd64.deb"
	"https://git.altlinux.org/tasks/archive/done/_193/197757/build/100/x86_64/rpms/libicu60-6.0.2-alt1.x86_64.rpm"
)

for link in ${links[*]}; do
    wget -q --show-progress $link
done


# установить пакеты с зависимостями

rpm -i libicu60-6.0.2-alt1.x86_64.rpm > /dev/null

dnf --refresh install -y -q lib64crypto10 lib64ssl10 lib64jpeg8 icu71-data lib64icuuc71 lib64icutu71 lib64icuio71 p7zip &&
echo 'Установлены пакеты с зависимостями.'


# создать символические ссылки на динамические библиотеки

cd /lib64
ln -sf libcrypto.so.10 libcrypto.so.1.0.0 &&
ln -sf libssl.so.10 libssl.so.1.0.0 &&
echo 'Созданы ссылки на динамические библиотеки.'
ldconfig
cd $workdir


# распаковать пакет с ActivInspire и скопировать файлы

deb="activinspire_1804-2.23.69368-1-amd64.deb"
7z e -so $deb | tar x &&
echo 'Распакован архив с файлами ActivInspire.'

rm -rf /var/Promethean
mkdir /var/Promethean
user=$(id -nu 500)
rm -rf /home/$user/.local/bin/{activsoftware,inspire,activityplayer}
# TODO cleanup local share
cp -rf usr/local/bin /home/$user/.local/ &&
cp -rf usr/share /home/$user/.local/ &&
echo 'Скопированы файлы ActivInspire.'


# изменить файлы для запуска из домашней директории пользователя

cat > /home/$user/.local/bin/inspire << EOF
#!/usr/bin/env bash
export LD_LIBRARY_PATH="\$HOME/.local/bin/activsoftware:/lib64:/usr/lib64"
\$HOME/.local/bin/activsoftware/Inspire "\$*"
EOF

cat > /home/$user/.local/bin/activplayer << EOF
#!/usr/bin/env bash
export LD_LIBRARY_PATH="\$HOME/.local/bin/activsoftware:/lib64:/usr/lib64"
sleep 1s && kill $$ &
\$HOME.local/bin/activsoftware/activplayer "\$*"
EOF

desktop_files=(
    "/home/$user/.local/share/applications/activsoftware.desktop"
    "/home/$user/.local/share/applications/activsoftware-nc.desktop"
    "/home/$user/.local/share/applications/activplayer.desktop"
)

for file in ${desktop_files[@]}; do
    sed -i "s/\/usr\/local\/bin/\/home\/$user\/.local\/bin/
            s/\/usr\/share/\/home\/$user\/.local\/share/" $file
done

cd /home/$user/'Рабочий стол' &&
ln -sf /home/$user/.local/share/applications/activsoftware.desktop activsoftware.desktop &&
echo 'Создан значек на рабочем столе.'

chown -R $user:$user /home/$user/.local


# обновить кеш различных десктопных файлов

su -l -c '
    update-mime-database $HOME/.local/share/mime &&
    kbuildsycoca5 > /dev/null 2>&1
' $user &&
echo 'Обновлен кеш приложений.'

# удалить временную директорию

cd
rm -rf $workdir


# заметки

# так можно проверить слинкованные исполняемым файлом библиотеки и их отсутствие в системе
# в переменной указываются пути по которым находятся библиотеки
# LD_LIBRARY_PATH="$HOME/.local/bin/activsoftware:/lib64:/usr/lib64" ldd ~/.local/bin/activsoftware/Inspire

# пакеты с зависимостями и ссылки на них
# крипто есть только на 9 платформе
# libjpeg8
# ibcrypto10 p9  https://git.altlinux.org/tasks/296706/build/300/x86_64/rpms/libcrypto10-1.0.2u-alt1.p9.2.x86_64.rpm
# libssl10 p9  https://git.altlinux.org/tasks/296706/build/300/x86_64/rpms/libssl10-1.0.2u-alt1.p9.2.x86_64.rpm
# icu 6.0.2 https://git.altlinux.org/tasks/197757/build/100/x86_64/log https://git.altlinux.org/tasks/archive/done/_193/197757/build/100/x86_64/rpms/libicu60-6.0.2-alt1.x86_64.rpm

