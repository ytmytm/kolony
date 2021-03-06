{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,R-,S+,V+,X-}
{$M 16384,0,655360}
{***************************}
{*** Modul z procedurami ***}
{***  i funkcjami do gry ***}
{***      " KOLONY "     ***}
{***************************}

unit kol_1;

interface

uses crt,dodatki,kol_pocz;

var
  pomoc_s                 : string;
  z,dlp,ap,cp,ep,lp,sp,zp : char;

const
  q5     = '�����';
  maxlen = 3000;

procedure los;
function stt(liczba:longint):string;
function sttr(liczba:longint;dl:byte):string;
function wprowadz_t(x,y,dl:byte):string;
procedure brludz;
procedure help;
function Na_Pewno(x:byte):boolean;
procedure znaki(q:boolean);
procedure blad(x:byte);
function mazovia:boolean;
procedure kolor1;
procedure kolor2;



implementation

procedure kolor1;
begin
  textcolor(white);
  textbackground(black);
end {kolor1};

procedure kolor2;
begin
  textcolor(black);
  textbackground(white);
end {kolor2};

procedure los;
var nic : integer;
begin
  nic:=random(random(10000));
end;

function stt(liczba:longint):string;
begin
  str(liczba,pomoc_s);
  stt:=pomoc_s;
end; {stt}

function sttr(liczba:longint;dl:byte):string;
begin
  pomoc_s:=stringright(stt(liczba),dl);
  sttr:=pomoc_s;
end;

function wprowadz_t(x,y,dl:byte):string;
var
  tekst,tekst2:string;
  dl_t,poz,i:byte;
  znak:char;
  wyjscie:boolean;

begin
  tekst:='';
  dl_t:=0;
  poz:=1;
  wyjscie:=false;
  repeat
    g(x,y,tekst);
    for i:=1 to dl-dl_t do write(#250);
    gotoxy(x-1+poz,y);
    znak:=key;
    case znak of
      #13  : wyjscie:=true;
      #0   : begin
               znak:=readkey;
               case znak of
                 #71 : poz:=1;
                 #79 : poz:=dl_t+1;
                 #75 : poz:=poz-1;
                 #77 : poz:=poz+1;
                 #83 : if poz<=dl_t then
                       begin
                         dec(dl_t);
                         for i:=poz to dl_t do tekst[i]:=tekst[i+1];
                         tekst:=copy(tekst,1,dl_t);
                       end;
               end;
             end;
      #8   : begin
               if poz>1 then
                 begin
                   dec(dl_t);
                   dec(poz);
                   for i:=poz to dl_t do tekst[i]:=tekst[i+1];
                   tekst:=copy(tekst,1,dl_t);
                 end;
             end;

      #1..#31:
      else   begin
               if dl_t<dl then
                 begin
                   tekst2:=copy(tekst,poz,dl_t-poz+1);
                   tekst:=copy(tekst,1,poz-1);
                   inc(dl_t);
                   tekst:=tekst+znak;
                   tekst:=concat(tekst,tekst2);
                   inc(poz);
                 end;
             end;
    end;
    if dl_t<0 then dl_t:=0;
    if dl_t>dl then dl_t:=dl;
    if poz<1 then poz:=1;
    if poz>dl_t+1 then poz:=dl_t+1;
  until wyjscie;
  wprowadz_t:=tekst;
  gotoxy(x+dl_t,y);
  for i:=1 to dl-dl_t do write(' ');
  gotoxy(x+poz-1,y);
end; {wprowadz_t}

procedure brludz;
begin
  ramka(true,false,18,9,31,11);
  gotoxy(20,10);writeln('BRAK LUDZI');
end;

procedure help;
var z:char;
begin
  clrscr;
  ramka(true,true,2,2,79,24);
  linia(false,true,3,78,4);
  gotoxy(36,3);
  write('HELP');
  window(3,5,78,23);
  writeln('            �����  K O L O N Y  v 1.0');
  writeln('  �����������������    for IBM PC');
  writeln('  ���������autor wersji na PC - Artur Siupik');
  writeln('  ���scenariusz na podstawie gry "Kolony" na Atari');
  writeln;
  writeln('   ������Rok 2090 ...');
  writeln;
  writeln('  Ogromne ��zdobycze ��nauki �i �techniki �pozwoli',lp,'y �na');
  writeln('  pokonywanie ���niezmierzonych ��przestrzeni ��kosmosu.');
  writeln('  Wzrastaj',ap,'cy ���przyrost ���naturalny ���i ��wyd',lp,'u',zp,'enie');
  writeln('  przeci',ep,'tnego �okresu ',zp,'ycia na Ziemi spowodowa',lp,'y, ',zp,'e na');
  writeln('  planecie �zacz',ep,lp,'o �brakowa',cp,' �miejsca �. Rozpocz',ep,lp,'o si',ep);
  writeln('  poszukiwanie �nowych �teren�w, �planet, �gdzie mogliby');
  writeln('  zamieszka',cp,' �ludzie. Podczas poszukiwa� w przestworzach');
  writeln('  natrafiono �na �szczeg�lnie nadaj',ap,'c',ap,' si',ep,' do osiedlenia');
  writeln('  grup',ep,' �planet, z uwagi na znakomite po',lp,'o',zp,'enie, ',sp,'wietne');
  writeln('  warunki �atmosferyczne, terenowe i du',zp,'e ilo',cp,'ci bogactw');
  writeln('  naturalnych postanowiono okre',sp,'li',cp,' j',ap,' jako priorytetow',ap);
  write('  w �programie �bada� �kolonizacyjnych i nazwa',cp,' systemem');
  kbdclear;
  z:=key;
  writeln;
  writeln('  KOLONY.  Poniewa',zp,'  zawsze  by',lp,'e',sp,'  znakomitym  zarz',ap,'d -');
  writeln('  c',ap,'   IMPERATOR   tego  systemu  mianowa',lp,'  Ci',ep,'  guber -');
  writeln('  natorem jednej z najwa',zp,'niejszych planet,kt�re znalaz',lp,'y');
  writeln('  si',ep,' �pod  jego  rz',ap,'dami,  planety  Vvp-12a.  W',lp,'a',sp,'nie');
  writeln('  rozpocz',ap,lp,'e',sp,' ��urz',ep,'dowanie, �obejmuj',ap,'c �kluczow',ap,' �wysp',ep);
  writeln('  planety, �przed �tob',ap,' �trudne �zadanie �musisz wyt',ep,zp,'y',cp);
  writeln('  swoje �szare �kom�rki, b',lp,'ysn',ap,cp,' intelektem, wykaza',cp,' si',ep);
  writeln('  zdolno',sp,'ciami �przyw�dczymi �i �ekonomicznymi, a przede');
  writeln('  wszystkim cierpliwo',sp,'ci',ap,' i umiej',ep,'tno',sp,'ci',ap,' przewidywania.');
  writeln('  Twoja �wyspa �nie �jest �du',zp,'a, ale stanowi wa',zp,'ny punkt');
  writeln('  programu  bada�.  Otrzyma',lp,'e',sp,' 50.000 w got�wce i 10�lat');
  writeln(' �czasu �aby �zgromadzi',cp,' �kwot',ep,'�co najmniej 100.000.000.');
  writeln(' �Je',zp,'eli  tego  nie zdob',ep,'dziesz, tw�j zwierzchnik odwo',lp,'a');
  writeln(' �Ci',ep,'  ze  stanowiska  gubernatora (tak',zp,'e w sytuacji gdy');
  writeln('  twoje  zad',lp,'u',zp,'enie b',ep,'dzie utrzymywa',lp,'o si',ep,' d',lp,'u',zp,'ej ni',zp,' 12');
  writeln('  miesi',ep,'cy). �Przysz',lp,'o',sp,cp,' najwa',zp,'niejszej z planet systemu');
  writeln('  KOLONY zale',zp,'y tylko od ciebie.');
  writeln;
  kbdclear;
  z:=key;
  writeln;
  writeln;
  writeln('  ������Rozpocz',ep,'cie gry');
  writeln;
  writeln('  Przed �przyst',ap,'pieniem �do �gry �mo',zp,'emy �zapozna',cp,' si',ep,' z');
  writeln('  kr�tk',ap,' �instrukcj',ap,' �( To  co  teraz czytasz wywolywane');
  writeln('  klawiszem F1)  i  skonfigurowac  gre (  klawisz F2  ),');
  writeln(' �nast',ep,'pnie  program zapyta czy chcemy wczyta',cp,' wcze',sp,'niej');
  writeln('  zapisan',ap,' �gr',ep,',  czy  rozpocz',ap,cp,'  now',ap,'.  Kolejne pytania');
  writeln('  dotycz',ap,' liczby graczy ( od 1 do 5 ) i ich imion, teraz');
  writeln('  mo',zp,'na ju',zp,' rozpocz',ap,cp,' zabaw',ep,'.Najpierw pojawi',ap,' si',ep,' og�lne');
  writeln(' �informacje dotycz',ap,'ce aktualnej sytuacji na planecie, a');
  writeln('  nast',ep,'pnie okno wyboru opcji :');
  writeln('    INWESTYCJE - kierowanie budowami');
  writeln('    PRODUKCJA - sterowanie produkcj',ap);
  writeln('    WYPRAWY - kierowanie ekspedycjami');
  writeln('    UPRAWY - decyduj',ap,' o zapasach ',zp,'ywno',sp,'ci');
  writeln('    MAGAZYNY - opcja informacyjna');
  writeln('    ZA',dlp,'OGA - opcja informacyjna');
  write('    WOJSKO - opcja informacyjna');
  kbdclear;
  z:=key;
  writeln;
  writeln('    BUDYNKI - opcja informacyjna');
  writeln('    GENERATOR - steruje prac',ap,' generatora');
  writeln('    WYDOBYCIE - ilo',sp,'ci wydobywanych surowc�w');
  writeln('    HANDEL - mo',zp,'na sprzedawa',cp,' lub kupowa',cp);
  writeln('    DALEJ - zapis stanu gry, ... min',ap,lp,' miesi',ap,'c');
  writeln;
  writeln;
  writeln;
  writeln('  ��������Jak gra',cp,' ?');
  writeln('  Wyboru ��opcji ��dokonuje �si',ep,' �u',zp,'ywaj',ap,'c �klawiszy. �W');
  writeln('  przypadku gdy mamy zadecydowa',cp,' o liczbie ludzi, ilo',sp,'ci');
  writeln('  surowc�w, �obiekt�w lub przedmiot�w naciskamy klawisze');
  writeln('  "lewo" i "prawo" (tzn. "lewo" - strza',lp,'ka w lewo, itd.)');
  writeln('  potwierdzaj',ap,'c ustawione warto',sp,'ci ENTER''em.');
  writeln('  U',zp,'ywaj',ap,'c �opcji �INWESTYCJE �mo',zp,'emy budowa',cp,' mieszkania');
  writeln('  dla za',lp,'ogi, magazyny potrzebne do sk',lp,'adowania surowc�w');
  writeln('  fabryki �konieczne do podj',ep,'cia produkcji lub l',ap,'dowiska');
  writeln('  pozwalaj',ap,'ce �na �przyjmowanie �wi',ep,'kszych �statk�w. �Do');
  write('  budowy �potrzebna �jest �odpowiednia �liczba surowc�w,');
  kbdclear;
  z:=key;
  writeln;
  writeln('  natomiast �czas trwania zale',zp,'ny jest od ilo',sp,'ci ludzi i');
  writeln('  robot�w ��znajduj',ap,'cych �si',ep,' �w �bazie. �Nale',zp,'y �jednak');
  writeln('  pami',ep,'ta',cp,', �',zp,'e �za',lp,'oga �mo',zp,'e �pracowa',cp,' tylko nad jednym');
  writeln('  rodzajem �budowli, �i �',zp,'e �jednocze',sp,'nie mo',zp,'na uprawia',cp);
  writeln('  pola �(a �nawet �trzeba, gdy',zp,' jest to jedyny skuteczny');
  writeln('  spos�b �zaopatrzenia �kolonii �w ',zp,'ywno',sp,cp,'). W przypadku');
  writeln('  wyczerpania ��si',ep,' �zapas�w �',zp,'ywno',sp,'ci �ludzie �opuszcz',ap);
  writeln('  koloni',ep,', �co �jest �jednoznaczne z zako�czenie kariery');
  writeln('  gubernatora.');
  writeln;
  writeln('  Opcj',ep,' �PRODUKCJA �uruchomi',cp,' �mo',zp,'na �tylko �wtedy, �gdy');
  writeln('  wcze',sp,'niej �zosta',lp,'y �wybudowane fabryki (pami',ep,'taj',ap,'c, ',zp,'e');
  writeln('  im �wi',ep,'cej fabryk, tym wi',ep,'cej potrzeba ludzi, ',zp,'ywno',sp,'ci');
  writeln('  i mieszka�).');
  writeln('  U',zp,'ywaj',ap,'c opcji WYPRAWY mo',zp,'emy wysy',lp,'a',cp,' ekspedycje wg',lp,ap,'b');
  writeln('  wyspy, ���aby ��wyprawa ��wyruszy',lp,'a ��potrzebny ��jest');
  writeln('  przynajmniej �jeden kolonista i jeden naukowiec, sk',lp,'ad');
  writeln('  grupy �ustalamy �wciskaj',ap,'c �klawisze "g�ra" lub "d�',lp,'".');
  write('  Opcja WYDOBYCIE pokazuje ilo',sp,cp,' surowc�w uzyskiwanych z');
  kbdclear;
  z:=key;
  writeln;
  writeln('  kopalni. �Je',zp,'eli �og�lny �poziom �wydobycia przekracza');
  writeln('  woln',ap,' ��powierzchni',ep,' ��magazynow',ap,' ��to ��zostaje ��ono');
  writeln('  wstrzymane. �Pierwsza �z �liczb �znajduj',ap,'cych �si',ep,' �po');
  writeln('  nazwie surowca okre',sp,'la wielko',sp,cp,' zbadanego z',lp,'o',zp,'a, druga');
  writeln('  (ustawiana �klawiszami) �aktualne, za',lp,'o',zp,'one wydobycie.');
  writeln('  Nale',zp,'y �jednak �pami',ep,'ta',cp,', �',zp,'e mo',zp,'e by',cp,' ono wstrzymane,');
  writeln('  gdy ��generator �kolonii �zostanie �przeci',ap,zp,'ony, �b',ap,'d�');
  writeln('  zabraknie do niego paliwa. O ile to drugie nie powinno');
  writeln('  si',ep,' �zda',zp,'y',cp,' �przy rozs',ap,'dnej gospodarce uranem (jest to');
  writeln('  generator atomowy), o tyle przeci',ap,zp,'enie zda',zp,'a si',ep,' do',sp,cp);
  writeln('  cz',ep,'sto.Nie ��poci',ap,'ga ��to ��jednak ��za �sob',ap,' �',zp,'adnych');
  writeln('  tragicznych ��nast',ep,'pstw, �zostaj',ap,' �jedynie �wstrzymane');
  writeln('  wszystkie inwestycje, produkcja i wydobycie.');
  writeln('  Opcja �GENERATOR pozwala na sprawdzenie czy pob�r mocy');
  writeln('  jest dopuszczalny oraz pokazuje aktualne zu',zp,'ycie uranu');
  writeln('  przez reaktor. Modu',lp,' generatora mo',zp,'na wyprodukowa',cp,' lub');
  writeln('  kupi',cp,', ��produkcja ��modu',lp,'u �poci',ap,'ga �jednak �za �sob',ap);
  writeln('  zmniejszenie mocy.');
  write('  Opcja �UPRAWY �ma �decyduj',ap,'cy �wp',lp,'yw na ilo',sp,cp,' ',zp,'ywno',sp,'ci');
  kbdclear;
  z:=key;
  writeln;
  writeln('  (niezb',ep,'dna do egzystowania kolonii), u',zp,'ywaj',ap,'c klawiszy');
  writeln('  wybieramy ��liczb',ep,' ��kolonist�w �kierowanych �do �prac');
  writeln('  rolniczych ��(w �ten �spos�b �zwi',ep,'kszamy �powierzchni',ep);
  writeln('  upraw, ale tak',zp,'e koszty z nimi zwi',ap,'zane).');
  writeln('  Kolejna ��wa',zp,'na ��opcja ��to ��PRODUKCJA �(mo',zp,'liwa �do');
  writeln('  uruchomienia dopiero po wybudowaniu co najmniej jednej');
  writeln('  fabryki), ��po �jej �wybraniu �zostanie �przedstawiona');
  writeln('  informacja �o tym co mo',zp,'na produkowa',cp,'. Je',zp,'eli dokonasz');
  writeln('  wyboru, �program �wy',sp,'wietli podstawowe dane techniczne');
  writeln('  produktu, �jego �cen',ep,', �moc �i �surowce �potrzebne �do');
  writeln('  wytworzenia �oraz �czas trwania produkcji. Je',zp,'eli masz');
  writeln('  do �dyspozycji du',zp,'o fabryk praz odpowiedni zapas mocy,');
  writeln('  mo',zp,'esz �wyprodukowa',cp,' w tym samym czasie kilka, a nawet');
  writeln('  kilkadziesi',ap,'t produkt�w. Zwi',ep,'kszasz w ten spos�b zysk,');
  writeln('  gdy',zp,' mo',zp,'esz prowadzi',cp,' handel na wi',ep,'ksz',ap,' skal',ep,'.');
  writeln('  HANDEL ��jest ��ostatnia ��z �opcji �decyzyjnych, �ale');
  writeln('  jednocze',sp,'nie �jedn',ap,' z najwa',zp,'niejszych. Do handlu mo',zp,'na');
  writeln('  przyst',ap,'pi',cp,' �natychmiast �po �ukazaniu si',ep,' komunikatu o');
  write('  wyl',ap,'dowaniu �statku. Do wyboru s',ap,' surowce, maszyny lub');
  kbdclear;
  z:=key;
  writeln;
  writeln('  ludzie (nie chodzi oczywi',sp,'cie o "handel ',zp,'ywym towarem"');
  writeln('  lecz �o �najem �kolonist�w, �naukowc�w lub ',zp,'o',lp,'nierzy).');
  writeln('  Liczby i ilo',sp,'ci ustalamy wciskaj',ap,'c klawisze "lewo" lub');
  writeln('  "prawo".');
  writeln('  Opr�cz �opcji �decyzyjnych �jest �tak',zp,'e �kilka �czysto');
  writeln('  informacyjnych �: �MAGAZYNY, �ZA�OGA, WOJSKO, BUDYNKI,');
  writeln('  bez kt�rych kontrola og�lnej sytuacji w kolonii by',lp,'aby');
  writeln('  niemo',zp,'liwa. �Je',zp,'eli w grze uczestniczy kilku graczy to');
  writeln('  w ��opcji �WOJSKO �zawarta �jest �mo',zp,'liwo',sp,cp,' �ataku �na');
  writeln('  konkurencj',ep,', �taki �atak mo',zp,'e oczywi',sp,'cie zako�czy',cp,' si',ep);
  writeln('  zar�wno osi',ap,'gni',ep,'ciem korzy',sp,'ci jak i stratami.');
  writeln('  Ostatni',ap,' opcj',ap,' nie maj',ap,'c',ap,' wp',lp,'ywu na sytuacj',ep,' w kolonii');
  writeln('  jest �DALEJ, �zawarta �jest �tu mo',zp,'liwo',sp,cp,' zapisu stanu');
  writeln('  gry, rozpocz',ep,'cia od nowa lub zako�czenia pewnego etapu');
  writeln('  gry ("przesuni',ep,'cie czasu" o jeden miesi',ap,'c), pojawi si',ep);
  writeln('  raport o aktualnej sytuacji.');
  writeln;
  writeln;
  kbdclear;
  z:=key;
  writeln;
  writeln('  �������Uwagi ko�cowe');
  writeln;
  writeln('  W �dolnej �cz',ep,sp,'ci �ekranu podane s',ap,': data, imi',ep,' i stan');
  writeln('  konta aktualnie zarz',ap,'dzaj',ap,'cego koloni',ap,' gracza.');
  writeln('  Wi',ep,'ksza �ilo',sp,cp,' l',ap,'dowisk pozwala na l',ap,'dowanie wi',ep,'kszych');
  writeln('  statk�w.');
  writeln('  Podczas ��gry ��mog',ap,' ��wydarzy',cp,' �si',ep,' �r�',zp,'nego �rodzaju');
  writeln('  nieszcz',ep,sp,'cia, ���trz',ep,'sienia ���powierzchni ��niszcz',ap,'ce');
  writeln('  kopalnie, �a �tak',zp,'e �dzikie bestie pustosz',ap,' twoje pola');
  writeln('  uprawne, ��a ��kosmiczni ��piraci ��co ��pewien ��czas');
  writeln('  przypominaj',ap,' o sobie pl',ap,'druj',ap,'c twoje magazyny.');
  writeln('  Graj',ap,'c nale',zp,'y pami',ep,'ta',cp,', ',zp,'e nie mo',zp,'na si',ep,' skupia',cp,' tylko');
  writeln('  na �jednym �rodzaju dzia',lp,'alno',sp,'ci zapominaj',ap,'c o innych,');
  writeln('  gdy',zp,' �takie �post',ep,'powanie �mo',zp,'e �doprowadzi',cp,' �tylko do');
  writeln('  zag',lp,'ady.');
  writeln('  Zadanie �postawione przed graczem jest trudne i trzeba');
  writeln('  umiej',ep,'tnie ��gospodarowa',cp,' ��czasem �i �pieni',ep,'dzmi �aby');
  writeln('  zgromadzi',cp,' �potrzebn',ap,' �sum',ep,'.');
  kbdclear;
  z:=key;
  writeln;
  writeln;
  writeln('  Przy  prze',lp,'adowywaniu  du',zp,'ych  ilo',sp,'ci towar�w, m',ep,'cz',ap,'ce');
  writeln('  jest  ich  przerzucanie  po  jednej jednostce, dlatego');
  writeln('  zdefiniowa',lp,'em dodatkowe klawisze :');
  writeln('    ["Ctrl"+"" i "Ctrl"+"',chr(26),'"] - szybsze prze',lp,'adowywanie');
  writeln('    ["PgUp" i "PgDown"] - to co wy',zp,'ej ale w pionie');
  writeln('    ["<" i ">"] - tyle, ile sie zmie',sp,'ci');
  writeln;
  writeln('  W  joysticku  "Ctrl"+""  uzyskujemy trzymaj',ap,'c dr',ap,zp,'ek');
  writeln('  w lewo i naciskaj',ap,'c "fire".');
  writeln;
  writeln('  Podczas wybierania pliku mo',zp,'emy zmieni',cp,' nap',ep,'d naciska-');
  writeln('  j',ap,'c spacj',ep,' i liter',ep,' oznaczaj',ap,'c',ap,' dany nap',ep,'d.');
  writeln;
  writeln;
  writeln('     Przyjemnej zabawy !!!');
  writeln;
  writeln;
  kbdclear;
  z:=key;
  window(1,1,80,25);
  clrscr;
end;

function Na_Pewno(x:byte):boolean;  { x :  1 - Restart }
var                                 {      2 - DOS     }
  tekst  : string;
  z,oldz : char;
  wynik  : boolean;
begin
  case x of
    1 : tekst:='zrestartowa'+cp+' gr'+ep+' ?';
    2 : tekst:='wyj'+sp+cp+' do DOS''u ?';
  end;
  ramka(true,true,15,7,65,10);
  g(16,8,stringcenter('Na pewno chcesz '+tekst,48));
  g(30,9,' TAK ');
  kolor2;
  g(45,9,' NIE ');
  z:=right;
  x:=2;
  repeat
    oldz:=z;
    z:=key;
    case z of
      esc   : begin
                z:=enter;
                x:=2;
              end;
      left  : x:=1;
      right : x:=2
    end;
    if x=1 then kolor2 else kolor1;
    g(30,9,' TAK ');
    if x=1 then kolor1 else kolor2;
    g(45,9,' NIE ');
  until z=enter;
  if x=1 then wynik:=true else wynik:=false;
  kolor1;
  Na_Pewno:=wynik;
end;

procedure blad(x:byte);
var
  tekst : string;
begin
  tekst:='B'+lp+ap+'d !';
  case x of
    1 :   tekst:='Wywo'+lp+'anie nie istniej'+ap+'cej funkcji DOS !';
    2 :   tekst:='Nie odnaleziono zbioru !';
    3 :   tekst:='Nie odnaleziono '+sp+'cie'+zp+'ki !';
    4 :   tekst:='Zbyt wiele otwartych zbior�w !';
    5 :   tekst:='Dost'+ep+'p do zbioru nie jest dozwolony !';
    6 :   tekst:='B'+lp+ep+'dna operacja na zbiorze !';
    12 :  tekst:='B'+lp+ep+'dny kod dost'+ep+'pu do zbioru !';
    15 :  tekst:='B'+lp+ep+'dne oznaczenie nap'+ep+'du !';
    16 :  tekst:='Usuni'+ep+'cie bie'+zp+ap+'cego katalogu nie jest mo'+zp+'liwe !';
    18 :  tekst:='Nie odnaleziono zbioru !';
    100 : tekst:='B'+lp+ap+'d w odczycie dysku !';
    101 : tekst:='B'+lp+ap+'d podczas zapisywania na dysku !';
    150 : tekst:='Dysk jest zabezpieczony przed zapisem !';
    151 : tekst:='Nieznane urz'+ap+'dzenie !';
    152 : tekst:='Nap'+ep+'d nie jest gotowy !';
    154 : tekst:='B'+lp+ap+'d w danych !';
    155 : tekst:='B'+lp+ep+'dne okre'+sp+'lenie nap'+ep+'du !';
    156 : tekst:='B'+lp+ap+'d podczas przeszukiwania dysku !';
    158 : tekst:='Nie odnaleziono sektora !';
    160 : tekst:='B'+lp+ap+'d urz'+ap+'dzenia podczas zapisu !';
    161 : tekst:='B'+lp+ap+'d urz'+ap+'dzenia podczas odczytu !';
    162 : tekst:='Awaria sprz'+ep+'tu !';
    201 : tekst:='Kt�ry'+sp+' z plik�w jest uszkodzony, lub nie jest to plik z zapisan'+ap+' gr'+ap+' !';
    202 : tekst:='Brak miejsca na dysku aby zapisa'+cp+' plik lub katalog !';
    203 : tekst:='Nie znalaz'+lp+'em pliku z zapisan'+ap+' gr'+ap+' !';
    204 : tekst:='B'+lp+ap+'d podczas kasowania katalogu !';
    205 : tekst:='B'+lp+ap+'d podczas zmiany katalogu !';
    206 : tekst:='B'+lp+ap+'d podczas tworzenia katalogu !';
  end;
  ramka(true,false,1,11,80,13);
  g(2,12,stringcenter(tekst,78));
  writeln;
  z:=key;
end;

procedure znaki(q:boolean);
begin
  if q then
  begin
    ap:=#134;
    cp:=#141;
    ep:=#145;
    lp:=#146;
    sp:=#158;
    zp:=#167;
    dlp:=#156;
  end else
  begin
    ap:='a';
    cp:='c';
    ep:='e';
    lp:='l';
    sp:='s';
    zp:='z';
    dlp:='L';
  end;
end; {znaki}

function mazovia:boolean;
begin
  clrscr;
  Write(' Czy monitor ma zainstalowane polskie znaki w Mazovii ? (T/N)  : ');;
  z:=key;
  z:=upcase(z);
  if z<>'T' then z:='N';
  writeln(z);
  if z='T' then mazovia:=true else mazovia:=false;
  writeln;
end; {mazovia}

end.

