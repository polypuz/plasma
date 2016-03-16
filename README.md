# mirkots-engine
_Silnik serwera MirkOTS na bazie The Forgotten Server._

Przed instalacją prosimy o podejrzenie "licencji" (niżej).

Kontakt: #mirkots na Freenode.
# wiki, dokumentacja
The Forgotten Server ma bardzo słąbą dokumentację, więc staramy się tworzyć w miarę możliwości własną. Więcej informacji na [wiki projektu](https://github.com/Marahin/mirkots-engine/wiki)

# instalacja

## linux
obecnie wspieramy tylko i wyłącznie linuksa, najlepiej debiano-pochodnego.

*UWAGA!* Na uwadze trzeba mieć, aby kernel *nie* miał magicznych zabezpieczeń związanych z zarządzaniem pamięcią, np. _grsec_.
TFS ma wtedy tendencje do rzucania segfaultami.
### środowisko
#### ubuntu 14.04 LTS

[sugerowane pakiety **(zredaguj, zanim użyjesz)**](http://d.gimb.us/b/047b0de7df56844e9b62587240e4c52a.txt)

[**oficjalna lista pakietów**](https://github.com/otland/forgottenserver/wiki/Compiling)
### kompilowanie
 TLDR:
 - `cd mirkots-engine/build`
 - `cmake ..`
 - `make -jLICZBA_RDZENI (np. make -j8)`
 - `cd .. && cp build/tfs .`

Serwer jest gotowy do uruchomienia.

Bardziej szczególowo opisany proces (i inne systemy): https://github.com/otland/forgottenserver/wiki/Compiling

### konfiguracja

mirkots-engine/config.lua

### Maszyna wirtualna Vagranta

Możliwe jest również uruchomienie serwera na maszynie wirtualnej, zarządzanej i konfigurowanej za pomocą narzędzia [Vagrant](https://www.vagrantup.com/).  
Maszyna jest kontrolowana przez system Ubuntu Trusty Tahr (14.04 LTS).  
Skrypt konfiguracyjny wykonuje następujące czynności:
* Tworzy maszynę wirtualną
* Dokonuje wstępnej konfiguracji systemu
* Instaluje wymagane pakiety
* Konfiguruje serwer MySQL
* Kopiuje przykładową mapę HUB (data/example-world) jako domyślną mapę serwera
* Tworzy bazę danych na podstawie schematu z repo (schema.sql)
* Tworzy przykładowe konta graczy (data/example-world/test-players.sql)
* Konfiguruje serwer na podstawie przykładowego pliku konfiguracji (config-EXAMPLE.lua)
* Buduje serwer

Uruchomienie serwera przebiega następująco (na podstawie komend z systemów rodziny Linux):
```bash
me@local$ cd katalog/z/repo
me@local$ vagrant up
me@local$ vagrant ssh
```

```bash
me@vm$ cd /vagrant
me@vm$ ./tfs
```

Na serwer można zalogować się przez adres ``localhost@7171``

## gałęzie

### master
jak sama nazwa wskazuje - serwer produkcyjny, gotowe wydania nie zawierające nowych błędów, a raczej naprawiające stare, lub implementujące nowe, sprawdzone i działające ficzery

### development
gałąź w której dodajemy świeże ficzery, nowe elementy rozgrywki. Server staging.

### inne
w zależności od (pomysłu|zmian), mogą pojawić się inne gałęzie, specjalnie pod dany proces związany z rzeźbieniem mirkots-engine

## autorzy
- Jan ~marahin Matusz, www.marahin.pl
- _mirkots-engine_ *jest forkiem [_The Forgotten Server_](https://github.com/otland/forgottenserver)*, [lista autorów](https://github.com/otland/forgottenserver/graphs/contributors)

## "licencja"
Silnik serwera (_mirkots-engine_) *jest forkiem* [The Forgotten Server](https://github.com/otland/forgottenserver). [MirkOTS](www.mirkots.pl) ani twórcy mirkots-engine nie ponoszą żadnych korzyści z rozszerzania tego silnika.

Silnik nie może być udostępniany osobom trzecim, nie mającym dostępu do tego repozytorium - ze względów bezpieczeństwa. Zamiast tego, prosimy o linkowanie to The Forgotten Server.

Wykorzystywanie błędów, upublicznianie kodu bez dobrego wyjaśnienia (tj. w celu trolowania, publikowania błędu, aby mogła z niego korzystać szersza liczba osób lub po prostu - więcej osób) jest zabronione.

### Wykorzystanie jakichkolwiek części kodu we własnym projekcie
Mile widziane jest najpierw zadanie pytania, czy możesz skorzystać z autorskiego kodu z tego repozytorium.
Obowiązkowo musisz określić autora, podlinkować do stron autorów i określić z jakiego projektu brany był kod.
