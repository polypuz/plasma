# mirkots-engine
_Silnik serwera MirkOTS na bazie The Forgotten Server._

Kontakt: [#mirkots @ Freenode](https://webchat.freenode.net/?channels=#mirkots)

  
# Wiki, dokumentacja
The Forgotten Server ma bardzo słabą dokumentację.  
Część danych musi zostać przeniesiona z poprzedniego repozytorium (patrz issue #1)

# Instalacja

## linux
Obecnie wspieramy tylko i wyłącznie linuksa, najlepiej debiano-pochodnego.
Jednakże sam TFS ma [wsparcie dla różnej gamy systemów](https://github.com/otland/forgottenserver/wiki/Compiling).

*UWAGA!* W przypadku Linuksa na uwadze trzeba mieć, aby kernel *nie* miał magicznych zabezpieczeń związanych z zarządzaniem pamięcią, np. _grsec_.
TFS ma wtedy tendencje do rzucania segfaultami.

### Środowisko domyślne (produkcyjne)
#### ubuntu 14.04 LTS

[sugerowane pakiety **(zredaguj, zanim użyjesz)**](http://d.gimb.us/b/047b0de7df56844e9b62587240e4c52a.txt)

[**oficjalna lista pakietów**](https://github.com/otland/forgottenserver/wiki/Compiling)
### kompilowanie
 TLDR:
 - `cd mirkots-engine/build`
 - `cmake ..`
 - `make -jLICZBA_RDZENI`, np. `make -j8`
 - `cd .. && cp build/tfs .`

Serwer jest gotowy do uruchomienia.

Bardziej szczególowo opisany proces (i inne systemy): https://github.com/otland/forgottenserver/wiki/Compiling

### Konfiguracja

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
me@local$ vagrant plugin install vagrant-hostmanager
me@local$ vagrant up
me@local$ vagrant ssh
```

```bash
me@vm$ cd /vagrant
me@vm$ ./tfs
```

Na serwer można zalogować się przez adres ``localhost@7171``

## Współpraca, dodawanie nowych rzeczy / poprawki
## Gałęzie (branch)

### master
jak sama nazwa wskazuje - serwer produkcyjny, gotowe wydania, które zostały przetestowane (a przynajmniej w domyśle nie wprowadzają żadnych nowych błedów)

### development
gałąź w której dodajemy świeże ficzery, nowe elementy rozgrywki. Stage, w którym testujemy nowe zmiany, w którym możemy zobaczyć jak sprawdzą się z istniejącymi elementami rozgrywki.

### inne
każdy feature / bugfix okraszony musi być odpowiednim issue. W momencie, gdy issue zostaje naprawiony - ta zmiana powinna być utworzona w odpowiedniej gałęzi repozytorium, np. `issue-5` dla issue #5. Jeśli zmiana działa, serwer się kompiluje, można utworzyć pull request do `development`, i jeśli tam działa w porządku - można merge'ować do `master`.

## autorzy
- Jan ~marahin Matusz, www.marahin.pl
- _mirkots-engine_ **jest** (niebezpośrednim) **forkiem [_The Forgotten Server_](https://github.com/otland/forgottenserver)**, [lista autorów](https://github.com/otland/forgottenserver/graphs/contributors)

## "licencja"
Silnik serwera (_mirkots-engine_) **jest** (niebezpośrednim) **forkiem [The Forgotten Server](https://github.com/otland/forgottenserver)**. [MirkOTS](www.mirkots.pl) ani twórcy mirkots-engine nie ponoszą żadnych korzyści z rozszerzania tego silnika.

Licencja dziedziczona jest z projektu-matki, GNU GPL dostępna [tutaj](https://github.com/otland/forgottenserver/blob/master/LICENSE)

### Wykorzystanie jakichkolwiek części kodu we własnym projekcie
**Mile widziane** jest najpierw zadanie pytania, czy możesz skorzystać z autorskiego kodu z tego repozytorium w swoim projekcie (nadmieniając czym ten projekt jest i jakie ma założenia).  
Obowiązkowo musisz określić autora, podlinkować do stron autorów i określić z jakiego projektu brany był kod.
