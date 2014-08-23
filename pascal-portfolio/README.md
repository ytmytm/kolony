
Kolony dla Atari Portfolio
==========================

Maciej Witkowiak <ytm@elysium.pl>
15.03.2002

#LICENCJA/KOPIOWANIE
Kod zrodlowy programu oraz zalaczone kody zrodlowe dwoch modulow dla
Portfolio sa na licencji GNU GPL z dodatkowych zastrzezeniem - jesli
dokonasz zmian w ich kodzie i zaczniesz rozpowszechniac chce byc o
tym poinformowany - interesuje mnie co zostalo zmienione, na co i
dlaczego.

#KOLONY
Oto konwersja znanej z malego Atari gry ekonomicznej na Portfolio.
Nie napisalem jej od poczatku, skorzystalem z kodu zrodlowego wersji
dla PC Artura Siupika, znalezionej gdzies w Internecie. Wlozylem sporo
pracy, by Kolony dzialalo przy minimalnych wymaganiach Portfolio (wersja
A.S. po skompilowaniu zajmuje >100KB!). Nie uniknalem pewnych uproszczen.
Wyrzucilem tryb wielu graczy, a w zwiazku z tym menu wojska, zatem roboty
bojowe i X-wingi sluza teraz wylacznie do handlowania nimi. Nie ma rowniez
zapisywania i odczytywania gry, uznalem ze na Portfolio i tak nie ma to
wiekszego sensu - zawsze mozna sobie wywolac menu systemowe i aplikacje
z ROMu.

Poniewaz chcialem miec ladny, okienkowy interface skorzystalem z dostepnych
informacji na temat BIOSu Portfolio do rysowania okienek. W ten sposob
powstal modul pofcrt, ktory moze posluzyc do pisania wlasnych programow.
Mozna przy jego uzyciu latwo i szybko zrobic dosc przyjazny interface,
ktory w dodatku korzysta z charakterystycznych dla Portfolio skrotow -
ESC to zamkniecie okna, do opcji mozna szybko przejsc naciskajac pierwsza
litere jej nazwy itp.

Zalaczam rowniez kod biblioteki graficznej, ktora tez nieco pozmienialem
piszac krytyczne czesci kodu w asemblerze (procedura rysowania linii nie
doczekala tego :). Nie jest ona co prawda wykorzystywana przez Kolony, ale
gdyby ktos zechcial zrobic jakies intro, to bedzie na miejscu :)

Nie mam juz oryginalnej instrukcji do Kolony (choc mialem wersje dla C64 :)
dlatego nie czuje sie na silach opisywac dokladnie co do czego sluzy i jak
dziala. Moze w zamian kilka wyjasnien dotyczacych interface:
- do wybierania ilosci wpisujemy zawsze liczby, nie uzywamy kursorow do
  'przetaczania' materialow;
  w menu 'handluj' po wyborze typu materialu pokazuje sie requester z
  zapytaniem 'Ile z bazy na statek?' aby kupic materialy ze statku nalezy
  tu wpisac liczbe ujemna (np. jesli na statku jest 6 generatorow, to
  piszemy '-6'.
  korzystam tu z funkcji 'read' Pascala, ktora nie reaguje na puste linie -
  aby anulowac transakcje trzeba wpisac '0' i wcisnac enter nawet jezeli
  kursor 'wyjedzie' poza okno
- do zakonczenia tury sluzy 'Dalej'->'Dalej' (no coz, nie ja to wymyslilem :)
  oczywiscie po otwarciu z glownego menu 'Dalej' mozna wcisnac ESC, aby wrocic
  do glownego menu
- gra nie zawsze informuje o bledach (np. za malo gotowki, surowcow itp.),
  dlatego jezeli czegos nie mozesz zrobic, to znaczy ze nie masz do tego
  srodkow

Wszystkie te ograniczenia wynikaja z checi zachowania prostoty i jak
najmniejszego rozmiaru programu.

#KOD ZRODLOWY
Nie mam co ukrywac - jest brzydki. Oryginalny A.S. byl jeszcze brzydszy.
W dalszym ciagu straszy masa zmiennych globalnych i mnogosc zmiennych,
ktore mozna byloby polaczyc w ladne struktury (np. krz,zel,ura w tablice
surowce). Probowalem to zrobic, ale w koncu zdecydowalem na pozostawienie
tego w obecnej postaci. Taki ladny, strukturalny kod powodowal jednak
zwiekszenie objetosci programu wynikowego. Niestety.

15.03.2002 ytm
