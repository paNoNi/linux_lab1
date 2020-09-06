#!/bin/sh 

# 1
# Создание каталога test в домашнем каталоге пользователя

mkdir ~/test

# 2
# Создание файла с списком всех файлов в подкаталоге /etc

ls -RFa /etc > ~/test/list

# 3
# Подсчёт подкаталогов в /etc

echo "===========================================" >> ~/test/list
echo "Кол-во подкаталогов в /etc" >> ~/test/list

find /etc -mindepth 1 -type d | grep -v  "/\." | wc -l >> ~/test/list

# Подсчёт скрытых файлов в /etc

echo "===========================================" >> ~/test/list
echo "Кол-во скрытых файлов в /etc" >> ~/test/list

find /etc -maxdepth 1 -type f -name '.*' | wc -l >> ~/test/list

# 4
# Создание каталога ~/test/links

mkdir ~/test/links

# 5
# Создание жёсткой ссылки

ln ~/test/list ~/test/links/list_hlink

# 6
# Создание символической ссылки

ln -s ~/test/list ~/test/links/list_slink

# 7
# Вывод кол-ва имён ссылок
echo "Кол-во имён жёстких ссылок в list_hlink: "
ls -l ~/test/links/list_hlink | cut -d " " -f2
echo "Кол-во имён жёстких ссылок в list: "
ls -l ~/test/list | cut -d " " -f2
echo "Кол-во имён жёстких ссылок в list_slink: "
ls -l ~/test/links/list_slink | cut -d " " -f2

# 8
# Кол-во строк в list
wc -l ~/test/list | cut -d " " -f1 >> list_hlink

# 9
# Сравнение list_hlink и list_slink

if diff ~/test/links/list_hlink ~/test/links/list_slink;
then 
    echo "Yes";
else
    echo "No"
fi;

# 10
# Переименовать файл

mv ~/test/list ~/test/list1

# 11
# Сравнение list_hlink и list_slink
if diff ~/test/links/list_hlink ~/test/links/list_slink;
then 
    echo "Yes";
else
    echo "No"
fi;

# 12
# Создание жёсткой ссылки в домашнем каталоге пользователя

ln ~/test/links/list_hlink ~/list1

# 13
# Создание в домашнем каталоге файл list_conf, содержащий список файлов с расширением .conf, из каталога /etc и всех его подкаталогов.

mkdir ~/conc_lists

ls /etc -Ra | grep "\.conf$" > ~/conc_lists/list_conf

# 14 
# Создание в домашнем каталоге файл list_d, содержащий список всех подкаталогов каталога /etc, расширение которых .d.

ls /etc -Ra | grep "\.d$" > ~/conc_lists/list_d

# 15
# Создание файл list_conf_d, включив в него последовательно содержимое list_conf и list_d.

cat ~/conc_lists/list_conf ~/conc_lists/list_d > ~/conc_lists/list__conf_d

# 16
# Создание в каталоге test скрытый каталог sub.

mkdir ~/test/.sub

# 17 
# Скопировать в него файл list_conf_d.

cp ~/conc_lists/list__conf_d ~/test/.sub

# 18
# Еще раз скопировать туда же этот же файл в режиме автоматического создания резервной копии замещаемых файлов.

cp -b ~/conc_lists/list__conf_d ~/test/.sub/

# 19
# Вывод на экран полный список файлов (включая все подкаталоги и их содержимое) каталога test.

find ~/test/

# 20
# Создание в домашнем каталоге файл man.txt, содержащий документацию на команду man.

man man > ~/conc_lists/man.txt

# 21
#Разбить файл man.txt на несколько файлов, каждый из которых будет иметь размер не более 1 килобайта.

split -b 1024 ~/conc_lists/man.txt "man.txt_copy_"

# 22
# Создать каталог man.dir.

mkdir ~/conc_lists/man.dir

# 23
# Переместить одной командой все файлы, полученные в пункте 21 в каталог man.dir.

mv ~/Projests/scripts/man.txt_copy_* ~/conc_lists/man.dir

# 24 
# Собрать файлы в каталоге man.dir обратно в файл с именем man.txt.

find ~/conc_lists/man.dir/ -name "man.txt_copy_*" | xargs cat >> ~/conc_lists/man.dir/man.txt

# 25
# Сравнить файлы man.txt в домашней каталоге и в каталоге man.dir и вывести YES, если файлы идентичны.

if diff ~/conc_lists/man.dir/man.txt ~/conc_lists/man.txt;
then
	echo "YES";
else
	echo "NO";
fi;

# 26
# Добавить в файл man.txt, находящийся в домашнем каталоге несколько строчек с произвольными символами в начало файла и несколько строчек в конце файла.

sed -i -e '1 s/^/magic\n/;' ~/conc_lists/man.txt

# 27
# Одной командой получить разницу между файлами в отдельный файл в стандартном формате для наложения патчей.

diff -u ~/conc_lists/man.txt ~/conc_lists/man.dir/man.txt > ~/man_diff.txt

# 28
# Переместить файл с разницей в каталог man.dir.

mv ~/conc_lists/man_diff.txt ~/conc_lists/man.dir/

# 29
# Наложить патч из файла с разницей на man.txt в каталоге man.dir.

patch ~/conc_lists/man.dir/man.txt ~/conc_lists/man.dir/man_diff.txt

# 30
# Сравнить файлы man.txt в домашней каталоге и в каталоге man.dir и вывести YES, если файлы идентичны.

if diff ~/man.txt ~/man.dir/man.txt;
then
	echo "YES";
else
	echo "NO";
fi;
