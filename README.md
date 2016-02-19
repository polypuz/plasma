# mirkots-engine
Silnik serwera MirkOTS na bazie The Forgotten Server
Przed instalacją prosimy o podejrzenie "licencji" (niżej).

# instalacja

## linux
obecnie wspieramy tylko i wyłącznie linuksa, najlepiej debiano-pochodnego.
*UWAGA!* Na uwadze trzeba mieć, aby kernel *nie* miał magicznych zabezpieczeń związanych z zarządzaniem pamięcią, np. grsec.
TFS ma wtedy tendencje do rzucania segfaultami.
### środowisko
#### ubuntu 14.04 LTS
*lista pakietów jest sugerowana, prosimy o ZREDAGOWANIE PRZED KORZYSTANIEM*
vim, python, perl, *kernel 3.13-generic*, nginx, php5-fpm, pma, wszystko wymagane do skompilowania mirkots-engine
sugerowane pakiety: http://d.gimb.us/b/047b0de7df56844e9b62587240e4c52a.txt
### kompilowanie
 
 >cd mirkots-engine/build
 >cmake ..
 >make -jLICZBA_RDZENI (np. make -j8)
 >cd .. && cp build/tfs .

Serwer jest gotowy do uruchomienia.

### konfiguracja

mirkots-engine/config.lua

## gałęzie

### master
ta gałąź należy do serwera produkcyjnego, z niej pobiera gotowy serwer do skompilowania i uruchomienia. Nie powinny znaleźć tu się żadne bugi.

### development
gałąź w której dodajemy świeże ficzery, nowe elementy rozgrywki. Server staging.

### inne
w zależności od (pomysłu|zmian), mogą pojawić się inne gałęzie, specjalnie pod dany proces związany z rzeźbieniem mirkots-engine

## autorzy
Jan ~marahin Matusz, www.marahin.pl
mirkots-engine jest forkiem The Forgotten Server, którego listę autorów można podejrzeć tutaj:
https://github.com/otland/forgottenserver/graphs/contributors

## "licencja"
Silnik serwera jest forkiem The Forgotten Server (). MirkOTS.pl ani twórcy mirkots-engine nie ponoszą żadnych korzyści z rozszerzania tego silnika.
Silnik nie może być udostępniany osobom trzecim, nie mającym dostępu do tego repozytorium - ze względów bezpieczeństwa. Zamiast tego, prosimy o linkowanie to The Forgotten Server.

### Wykorzystanie jakichkolwiek części kodu we własnym projekcie
Mile widziane jest najpierw zadanie pytania, czy możesz skorzystać z autorskiego kodu z tego repozytorium.
Obowiązkowo musisz określić autora, podlinkować do stron autorów i określić z jakiego projektu brany był kod.
