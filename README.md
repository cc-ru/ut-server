# ut-server
Компонент софтверной части ивента «Unreal Tounament: Resurrection», проводимого на [computercraft.ru](http://computercraft.ru).

Сервер управляет игрой и хранит информацию о турнире. Предоставляет интерфейс для очков OpenPeripheral.

### Установка сервера
* Установить в компьютер T3 интернет-карту, беспроводной модем и дебаг-карту.
* Подключить мост для очков через адаптер.
* Кликнуть очками по мосту и надеть очечи на себя.
* Перезагрузить компьютер.
* Прописать следующие команды:

```
$ pastebin run vf6upeAN
$ wget https://raw.githubusercontent.com/ChenThread/oczip/master/unzip.lua /usr/bin/unzip.lua
$ cd /home
$ wget https://github.com/cc-ru/ut-server/archive/master.zip
$ unzip master.zip
$ hpm install -ly ./results/ut-server-master
$ cp ./results/ut-server-master/ut-serv.conf /etc
$ edit /etc/ut-serv.conf
```

* Найти в самом конце строку game.admins. Вместо стандартных значений вписать свой ник, чтобы можно было начать игру потом.
* Сохранить.

Команда для запуска:


```
$ ut-serv
```
