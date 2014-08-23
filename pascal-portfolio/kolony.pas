{$A+,B-,D-,E-,F-,G-,I+,L-,N-,O-,R-,S-,V-,X-}
{$M 16384,0,0}

{****************************************************}
{ KOLONY - na podstawie wersji Artura Siupika        }
{ Maciej 'YTM/Elysium' Witkowiak <ytm@friko.onet.pl> }
{                                <ytn@elysium.pl>    }
{ wersja dla Atari Portfolio                         }
{****************************************************}
{ ten program jest na licencji GNU GPL z dodatkowym  }
{ zastrzezeniem - jesli dokonasz w nim zmian chce    }
{ zostac o nich poinformowany                        }
{****************************************************}

{ brak: wojsko, load+save }

{ 24-25,27-28,30.01.2002 }
{ 15.03.2002 }

uses pofcrt;

const  mainmenu:string = 'Kolony'#0'Budowa'#0'Status'#0'Zasoby'#0'Handel'#0'Dalej'#0#0;
       bud_menu:string = 'Budowa'#0'Inwestycje'#0'Produkcja'#0'Wyprawy'#0#0;
       statmenu:string = 'Status'#0'Magazyny'#0'Zaloga'#0'Wojsko'#0'Budynki'#0#0;
       enermenu:string = 'Zasoby'#0'Uprawy'#0'Generator'#0'Wydobycie'#0#0;
       exitmenu:string =  'Dalej'#0'Dalej'#0'DOS'#0#0;

       bud2menu:string = 'BUDOWA'#0'Mieszkania'#0'Magazyny'#0'Fabryki'#0'Ladowiska'#0#0;
       prodmenu:string = 'PRODUKCJA'#0'roboty bx-1'#0'roboty bx-2'#0'generatory'#0'roboty bb-1'#0'X-wingi'#0#0;
       han1menu:string = 'HANDEL'#0'Surowce'#0'Maszyny'#0'Ludzie'#0#0;
       hansmenu:string = 'SUROWCE'#0'Krzem'#0'Zelazo'#0'Uran'#0'Zywnosc'#0#0;
       hanmmenu:string = 'MASZYNY'#0'roboty bx-1'#0'roboty bx-2'#0'generatory'#0'roboty bb-1'#0'X-wingi'#0#0;
       hanlmenu:string = 'LUDZIE'#0'Kolonisci'#0'Naukowcy'#0'Zolnierze'#0#0;

       koszty_inw :array[1..4] of array[1..4] of integer = ( (50,25,0,20), (150,100,0,20), (100,200,50,25), (300,80,5,30) );
       nazwa_pro  :array[1..5] of string = ( 'robot bx-1', 'robot bx-2', 'generator', 'robot bb-1', 'X-wing' );
       nazwa_pro_d:array[1..5] of string = ('robotow bx-1','robotow bx-2','generatorow','robotow bb-1','X-wingow');
       cecha_pro  :array[1..5] of string = ( 'sila rob. 2', 'sila rob. 5', 'moc - 30KW', 'boj. 5', 'boj. 5' );
       seria_pro  :array[1..5] of integer = ( 10, 5, 1, 5, 5 );
       cena_pro   :array[1..5] of integer = (1000, 1550, 5000, 1800, 1800 );
       koszty_pro :array[1..5] of array[1..3] of integer = ( (10,4,1), (15,10,2), (50,40,10), (12,10,3), (10,30,6) );
       czas_bud   :array[1..4] of integer = ( 30, 60, 100, 200 );
       pobmoc_inw :array[1..4] of integer = ( 20, 20, 25, 30 );

var  got:longint;
     imie_gracza:string;
     rok,mies,kredyt:integer;
     kongr,koniec_gry,restart:boolean;
     czyinw, czypro, czywyp, czy_st:boolean;
     mie,mag,fab,lad:integer;
     krz,zel,ura,zyw,bx1,bx2,gen,bb1,xwi:integer;
     krzinw,zelinw,urainw:integer;
     krzpro,zelpro,urapro:integer;
     krzkop,krzwyd,zelkop,zelwyd,urakop,urawyd:integer;
     krzst,zelst,urast,zywst:integer;
     cenakrz,cenazel,cenaura,cenazyw:integer;
     bx1st,bx2st,genst,bb1st,xwist:integer;
     cenabx1,cenabx2,cenagen,cenabb1,cenaxwi:integer;
     kolst,naust,zolst:integer;
     kol,nau,zol:integer;
     kolupr,kolwyp,nauwyp:integer;
     mocpro,mocfab,mocinw,pobmoc,moc,zuzura:integer;
     czastrwyp,czaswyp,proczbad:integer;
     czaspro,czasbud,pro,inw,ilinw,ilpro:integer;

var  buff:array[0..320] of byte;
     i:integer;

procedure waitkey;
var a:char;
begin
  CursorMode(0);
  repeat until keypressed;
  a:=readkey;
  CursorMode(2);
end;

procedure MyDrawBox(x1,y1,x2,y2:byte);
begin
  DrawBox(x1,y1,x2,y2,1);
  ScreenSave(x1+1,y1+1,x2-1,y2-1,2,buff);
end;

procedure czekaj;
begin
  write('---'); waitkey; writeln;
end;

procedure data;
begin
  inc(mies); if mies=13 then begin inc(rok); mies:=1; end;
end;

procedure writexy(x,y:byte;message:string);
begin
  gotoxy(x,y); write(message);
end;

function silboj:longint;
begin
  silboj:=zol+bb1*5+xwi*10;
end;

function silrob:longint;
begin
  silrob:=kol+bx1*2+bx2*5;
end;

function ilosc_wydobycia:longint;
begin
  ilosc_wydobycia:=krzwyd+zelwyd+urawyd;
end;

function zajete_magazyny:longint;
begin
  zajete_magazyny:=krz+zel+zyw+ura;
end;

function pojemnosc_mag:longint;
begin
  pojemnosc_mag:=mag*500;
end;

function moc_generatorow:integer;
begin
  moc_generatorow:=gen*30;
end;

function ilu_ludzi:integer;
begin
  ilu_ludzi:=kol+nau+zol;
end;

procedure mocfabryk;
begin
  if czypro then mocfab:=fab*20 else mocfab:=0;
end;

procedure mocinwestycji;
begin
  if czyinw then mocinw:=ilinw*pobmoc_inw[inw]
  else mocinw:=0;
end;

function ppczasbud(x:byte):longint;
begin
  if silrob=0 then ppczasbud:=ilinw*1000
  else ppczasbud:=ilinw*czas_bud[x] div silrob;
end;

function ppczaspro(x:byte):longint;
begin
  case x of
    1 : ppczaspro:=ilpro div fab;
    2 : if fab>1 then ppczaspro:=ilpro div (fab-1) else ppczaspro:=ilpro+1;
    3 : if fab>1 then ppczaspro:=(ilpro div (fab div 2)) else ppczaspro:=ilpro*2;
    4 : if fab>1 then ppczaspro:=ilpro div (fab-1) else ppczaspro:=ilpro+1;
    5 : if fab>1 then ppczaspro:=(ilpro div (fab div 2)) else ppczaspro:=ilpro*2;
  end;
end;

procedure odpoczatku;
begin
  write('Podaj swoje imie:');
  read(imie_gracza);
  if imie_gracza='' then imie_gracza:='Gracz';
  czyinw:=false; czypro:=false; czywyp:=false;
  got:=50000;
  krz:=20; zel:=20; ura:=20; zyw:=25;
  bx1:=0; bx2:=0; gen:=1; bb1:=0; xwi:=0;
  kol:=20; nau:=2; zol:=0;
  mie:=1; mag:=1; fab:=0; lad:=0;
  urakop:=0; urawyd:=0;
  krzkop:=0; krzwyd:=0;
  zelkop:=0; zelwyd:=0;
  kolupr:=0; kolwyp:=0; nauwyp:=0; proczbad:=0;
  rok:=2090; mies:=0;
end;

procedure plansza_koncowa;
begin
  ClrScr;
  writeln('Wyladowal krazownik typu "ATORA". Kazdy'#13#10'z gubernatorow musi wplacic 100.000.000');
  writeln('aby wykupic swoja kolonie.');
  waitkey;
  writeln('Brak okreslonej sumy jest jednoznaczny'#13#10'z usunieciem z zajmowanego stanowiska i');
  writeln('konfiskata mienia.');
  czekaj;
  if got>=100000000 then begin
     writeln('Gubernator ',imie_gracza,#13#10'zostal wyznaczony przez pelnomocnika');
     writeln('Imperatora na namiestnika na planecie'#13#10'Vvp-12a.');
  end else begin
      writeln('Gubernator ',imie_gracza,#13#10'nie zebral wymaganej sumy, wobec czego');
      writeln('namiestnikiem planety Vvp-12a zostal'#13#10'Komandor Floty Kosmicznej M. Puchatek.');
  end;
  czekaj;
end;

procedure tabela;
begin
  writexy(1,8,imie_gracza); gotoxy(10,8); write(rok,'.',mies,'.1');
  writexy(20,8,'$: '); write(got);
end;

procedure brak(mesg:string);
begin
  MyDrawBox(3,3,17,5);
  writexy(5,5,mesg);
  waitkey;
  DrawBox(3,3,17,5,0);
end;

procedure brak_surowcow;
begin
  brak('BRAK SUROWCOW');
end;

procedure brak_mocy;
begin
  brak('  BRAK MOCY  ');
end;

procedure brak_ludzi;
begin
  brak(' BRAK LUDZI ');
end;

procedure brak_fabryk;
begin
  brak(' BRAK FABRYK ');
end;

procedure brak_statku;
begin
  brak('NIE MA STATKU');
end;

procedure czyinwestycja;
begin
  czyinw:=false;
  if ((krzinw>krz) or (zelinw>zel) or (urainw>ura)) then brak_surowcow
  else begin
    czyinw:=true;
    pobmoc:=0;
    if czypro then pobmoc:=fab*20;
    inc(pobmoc,(ilosc_wydobycia div 10));
    moc:=moc_generatorow-pobmoc;
    if mocinw>moc then begin czyinw:=false; brak_mocy; end;
  end;
end;

procedure czyprodukcja;
begin
  czypro:=false;
  if ((krzpro>krz) or (zelpro>zel) or (urapro>ura)) then brak_surowcow
  else begin
    mocinwestycji;
    pobmoc:=mocinw;
    czypro:=true;
    inc(pobmoc,(ilosc_wydobycia div 10));
    moc:=moc_generatorow-pobmoc;
    if mocpro>moc then begin czypro:=false; brak_mocy; end;
  end;
end;


procedure inwestycje;
var tempstr:string;
    item,pczasbud:integer;
    odp:char;
begin
  if kol<1 then begin
     brak_ludzi;
     exit;
  end;
  if czyinw then begin
     tempstr:='Trwa budowa ';
     case inw of
       1: tempstr:=tempstr+'mieszkan.'#0#0;
       2: tempstr:=tempstr+'magazynow.'#0#0;
       3: tempstr:=tempstr+'fabryk.'#0#0;
       4: tempstr:=tempstr+'ladowisk.'#0#0;
     end;
     MyDrawBox(3,3,38,5);
     writexy(5,5,tempstr);
     waitkey;
     DrawBox(3,3,38,5,0);
  end else begin
      item:=MenuBox(2,2,1,0,0,0,bud2menu,#0#0);
      if item=-1 then exit;
      inw:=item+1;
      MyDrawBox(20,3,35,5);
      writexy(22,5,'Ile sztuk:'); read(ilinw);
      krzinw:=ilinw*koszty_inw[inw,1];
      zelinw:=ilinw*koszty_inw[inw,2];
      urainw:=ilinw*koszty_inw[inw,3];
      mocinw:=ilinw*koszty_inw[inw,4];
      pczasbud:=ppczasbud(inw);
      DrawBox(20,3,35,5,0);
      MyDrawBox(15,0,38,7);
      writexy(17,1,' SUROWCE ');
      writexy(17,2,'Krzem :'); write(krzinw,'t');
      writexy(17,3,'Zelazo:'); write(zelinw,'t');
      writexy(17,4,'Uran  :'); write(urainw,'t');
      writexy(17,5,'Pobor mocy :'); write(mocinw,'Kw');
      writexy(17,6,'Czas budowy:'); write(pczasbud,'ms.');
      writexy(17,7,'Rozpoczac? (T/N)');
      repeat odp:=readkey; until ((odp='t') or (odp='n'));
      DrawBox(15,0,38,7,0);
      if odp='t' then begin
        CzyInwestycja;
        if czyinw then begin
           MyDrawBox(15,4,33,6);
           writexy(17,6,'Budowa rozpoczeta');
           dec(krz,krzinw);
           dec(zel,zelinw);
           dec(ura,urainw);
           pobmoc:=mocinw;
           czasbud:=0;
           waitkey;
           DrawBox(15,4,33,6,0);
        end;
      end;
  end;
end;

procedure produkcja;
var item, kolfab, naufab, pczaspro:integer;
    odp:char;
begin
  if fab<1 then begin
     brak_fabryk;
     czypro:=false;
  end else begin
      if czypro then begin
         MyDrawBox(3,3,38,5);
         writexy(5,5,'Trwa produkcja '); write(nazwa_pro_d[pro]);
         waitkey;
         DrawBox(3,3,38,5,0);
      end else begin
         kolfab:=fab*20;
         naufab:=fab*3;
         if (kolfab>kol) or (naufab>nau) then begin
           czypro:=false;
           MyDrawBox(3,3,30,7);
           writexy(5,5,'Brak ludzi, potrzeba:');
           writexy(5,6,'kolonistow:'); write(kolfab);
           writexy(5,7,'naukowcow :'); write(naufab);
           waitkey;
           DrawBox(3,3,30,7,0);
           exit;
         end;
         item:=MenuBox(1,1,1,0,0,0,prodmenu,#0#0);
         if item=-1 then exit else pro:=item+1;
         MyDrawBox(0,0,30,4);
         writexy(2,2,'Dane:'); write(nazwa_pro[pro],'  ',cecha_pro[pro]);
         writexy(2,3,'seria - '); write(seria_pro[pro],'  cena sr.-',cena_pro[pro]);
         writexy(2,4,'Ile serii:'); read(ilpro);
         mocpro:=fab*20;
         krzpro:=ilpro*koszty_pro[pro,1];
         zelpro:=ilpro*koszty_pro[pro,2];
         urapro:=ilpro*koszty_pro[pro,3];
         pczaspro:=ppczaspro(pro);
         DrawBox(0,0,30,4,0);
         MyDrawBox(25,1,39,7);
         writexy(27,3,'Krzem: '); write(krzpro,' t');
         writexy(27,4,'Zelazo:'); write(zelpro,' t');
         writexy(27,5,'Uran:  '); write(urapro,' t');
         writexy(27,6,'Moc:   '); write(mocpro,' KW');
         writexy(27,7,'Czas:  '); write(pczaspro,' ms.');
         DrawBox(25,1,39,7,0);
         item:=MenuBox(1,1,1,0,0,0,#0'Start'#0'Powrot'#0'Wyjscie'#0#0,#0#0);
         if item=0 then begin
            czyprodukcja;
            if czypro then begin
               czaspro:=1;
               dec(krz,krzpro);
               dec(zel,zelpro);
               dec(ura,urapro);
               MyDrawBox(3,3,25,5);
               writexy(5,5,'Produkcja rozpoczeta.');
               waitkey;
               DrawBox(3,3,25,5,0);
            end;
         end;
         if item=1 then begin czypro:=false; produkcja; end;
         if item=2 then czypro:=false;
      end;
  end;
end;

procedure wyprawy;
var ilu_kol, ilu_nau, ile_mies:integer;
begin
  if czywyp then begin
     MyDrawBox(2,2,30,4);
     gotoxy(4,4); write('Wyprawa wroci za ',czastrwyp,' ms.');
     waitkey;
     DrawBox(2,2,30,4,0);
     end
  else begin
     if proczbad>=100 then begin
        MyDrawBox(2,2,20,4);
        writexy(3,3,'Cala wyspa zbadana');
        waitkey;
        DrawBox(2,2,20,4,0);
        end
     else begin
     repeat
       MyDrawBox(0,0,30,6);
       writexy(2,1,' WYPRAWY ');
       writexy(2,2,'Wyspa zbadana w '); write(proczbad,'%');
       writexy(2,3,'Ilu wyslac: '); write(kol,'/',nau);
       writexy(2,4,'Kolonistow: '); read (ilu_kol);
       writexy(2,5,'Naukowcow:  '); read (ilu_nau);
       writexy(2,6,'Na miesiecy:'); read (ile_mies);
       DrawBox(0,0,30,6,0);
     until ((ilu_kol<=kol) and (ilu_kol>=0) and (ilu_nau>=0) and (ilu_nau<=nau));
     if (ilu_kol+ilu_nau>0) then begin
        czywyp:=true;
        nauwyp:=ilu_nau;
        kolwyp:=ilu_kol;
        czastrwyp:=ile_mies;
        czaswyp:=ile_mies;
        dec(kol,kolwyp);
        dec(nau,nauwyp);
     end;
     end;
  end;
end;

procedure magazyny;
var poj,proc:longint;
begin
  poj:=mag*5;
  proc:=zajete_magazyny div poj;
  MyDrawBox(0,0,20,7);
  gotoxy(2,1); writexy(2,1,' MAGAZYNY ');
  writexy(2,2,'pojemnosc: '); write(pojemnosc_mag:6);
  writexy(2,3,'krzem:  '); write(krz:9);
  writexy(2,4,'zelazo: '); write(zel:9);
  writexy(2,5,'uran:   '); write(ura:9);
  writexy(2,6,'zywnosc:'); write(zyw:9);
  writexy(2,7,'uzywane:'); write(proc,'%');
  waitkey;
  DrawBox(0,0,20,7,0);
end;

procedure zaloga;
begin
  MyDrawBox(0,0,39,6);
  writexy(2,1,' ZALOGA ');
  writexy(2,2,'roboty bx1: '); write(bx1:4);
  writexy(2,3,'roboty bx2: '); write(bx2:4);
  writexy(2,4,'kolonisci:  '); write(kol+kolupr+kolwyp:4);
  writexy(2,5,'naukowcy:   '); write(nau+nauwyp:4);
  writexy(2,6,'zolnierze:  '); write(zol:4);
  writexy(21,2,'mieszkan:  '); write(mie*50:4);
  writexy(21,3,'zajete:    '); write(ilu_ludzi:4);
  writexy(21,4,'W bazie');
  writexy(21,5,'kolonisci: '); write(kol:4);
  writexy(21,6,'naukowcy:  '); write(nau:4);
  waitkey;
  DrawBox(0,0,39,6,0);
end;

procedure budynki;
begin
  MyDrawBox(0,0,20,5);
  writexy(2,1,' BUDYNKI ');
  writexy(2,2,'mieszkania: '); write(mie*50:6);
  writexy(2,3,'magazyny:   '); write(mag*500:6);
  writexy(2,4,'fabryki:    '); write(fab:6);
  writexy(2,5,'ladowiska:  '); write(lad:6);
  waitkey;
  DrawBox(0,0,20,5,0);
end;

procedure zbiory;
var ilunowych:integer;
begin
  if ((kol<1) and (kolupr<1)) then begin
     brak_ludzi;
     exit;
  end;
  MyDrawBox(0,0,28,7);
  writexy(2,1,' UPRAWY ');
  writexy(2,2,'Pora zasiewow');
  writexy(2,3,'Baza:  '); write(kol);
  writexy(2,4,'Pola:  '); write(kolupr);
  writexy(2,5,'Uprawy:'); write(kolupr*5);
  writexy(2,6,'Koszt: '); write(kolupr*50);
  repeat
    writexy(2,7,'Ilu ludzi na pole:'); read(ilunowych);
  until ((ilunowych>=0) and (ilunowych<=kol+kolupr));
  inc(kol,kolupr-ilunowych);
  kolupr:=ilunowych;
  dec(got,kolupr*50);
  tabela;
  DrawBox(0,0,28,7,0);
end;

procedure uprawy;
var ilejeszcze:integer;
begin
  if (mies=1) or (mies=7) then zbiory else
    begin
      case mies of
        2..6:  ilejeszcze:=7-mies;
        8..12: ilejeszcze:=13-mies;
      end;
      MyDrawBox(10,1,30,3);
      writexy(12,3,'Zbiory za '); write(ilejeszcze,' mies.');
      waitkey;
      DrawBox(10,1,30,3,0);
    end;
end;

procedure stan_generatorow;
begin
  mocfabryk;
  mocinwestycji;
  pobmoc:=(mocfab+mocinw+(ilosc_wydobycia div 10));
  moc:=moc_generatorow;
  zuzura:=pobmoc div 5;
end;

procedure generator;
begin
  stan_generatorow;
  MyDrawBox(0,0,20,5);
  writexy(2,1,' GENERATOR ');
  writexy(2,2,'moc  :'); write(moc);
  writexy(2,3,'pobor:'); write(pobmoc);
  writexy(2,4,'zuzycie uranu:');
  writexy(2,5,'  '); write(zuzura,' t/ms');
  waitkey;
  DrawBox(0,0,20,5,0);
end;

function wyd_kop(item:byte):integer;
begin
  case item of
    0: wyd_kop:=krzkop;
    1: wyd_kop:=zelkop;
    2: wyd_kop:=urakop;
  end;
end;

function wyd_wyd(item:byte):integer;
begin
  case item of
    0: wyd_wyd:=krzwyd;
    1: wyd_wyd:=zelwyd;
    2: wyd_wyd:=urawyd;
  end;
end;

procedure wydobycie;
var item,mmag,new_wyd:integer;
    wydmenu,wyddef,tmp:string;
begin
  mmag:=mag*500-zajete_magazyny;
  repeat
    wydmenu:='WYDOBYCIE'#0'Krzem'#0'Zelazo'#0'Uran'#0'Wolne w mag.'#0#0;
    str(krzwyd,wyddef); wyddef:=wyddef+#0;
    str(zelwyd,tmp); wyddef:=wyddef+tmp+#0;
    str(urawyd,tmp); wyddef:=wyddef+tmp+#0;
    str(mmag,tmp); wyddef:=wyddef+tmp+#0#0;
    item:=MenuBox(0,1,1,0,0,0,wydmenu,wyddef);
    if ((item<>-1) and (item<>3)) then begin
     repeat
       MyDrawBox(20,1,39,5);
       writexy(22,2,'Zmiana');
       writexy(22,3,'Kopalnie: '); write(wyd_kop(item));
       writexy(22,4,'Wydobycie:'); write(wyd_wyd(item));
       writexy(22,5,'Nowe wyd.:'); read(new_wyd);
     until ((new_wyd>=0) and (new_wyd<=wyd_kop(item)));
     DrawBox(20,1,39,5,0);
     case item of
       0: krzwyd:=new_wyd;
       1: zelwyd:=new_wyd;
       2: urawyd:=new_wyd;
     end;
  end;
  until ((item=-1) or (item=3));
end;

procedure handluj(max,cena:integer; nazwa:string; var baza,statek:integer);
var odp:integer;
    can_exit:boolean;
begin
  repeat
    MyDrawBox(0,0,30,5);
    gotoxy(3,1); write(nazwa);
    writexy(2,2,'Baza:     Statek:   Cena:');
    gotoxy(2,3); write(baza:9,statek:9,cena:9);
    if max<0 then max:=32700
    else begin
       gotoxy(2,4); write('miejsca: ',max);
    end;
    writexy(2,5,'Ile z bazy na statek?'); read(odp);
    DrawBox(0,0,30,5,0);
    if odp=0 then exit;
    if odp>0 then can_exit:=(((statek+odp)<=0) and ((baza-odp)>=0));
    if odp<0 then can_exit:=(((statek+odp)>=0) and (odp<=max));
  until can_exit;
  if odp<>0 then begin
     inc(got,cena*odp);
     dec(baza,odp);
     inc(statek,odp);
  end;
end;

procedure handel_surowce;
var ilosc,item:integer;
begin
  repeat
    item:=MenuBox(2,2,1,0,0,0,hansmenu,#0#0);
    if item=-1 then exit;
    ilosc:=mag*500-krz-zel-ura-zyw;
    case item of
      0: handluj(ilosc, cenakrz, 'Krzem', krz, krzst);
      1: handluj(ilosc, cenazel, 'Zelazo', zel, zelst);
      2: handluj(ilosc, cenaura, 'Uran', ura, urast);
      3: handluj(ilosc, cenazyw, 'Zywnosc',zyw,zywst);
    end;
  until item=-1;
end;

procedure handel_maszyny;
var item:integer;
begin
  repeat
    item:=MenuBox(3,1,1,0,0,0,hanmmenu,#0#0);
    if item=-1 then exit;
    case item of
      0: handluj(-1, cenabx1, nazwa_pro[1], bx1, bx1st);
      1: handluj(-1, cenabx2, nazwa_pro[2], bx2, bx2st);
      2: handluj(-1, cenagen, nazwa_pro[3], gen, genst);
      3: handluj(-1, cenabb1, nazwa_pro[4], bb1, bb1st);
      4: handluj(-1, cenaxwi, nazwa_pro[5], xwi, xwist);
    end;
  until item=-1;
end;

procedure handel_ludzie;
var ilosc,item:integer;
begin
  repeat
    item:=MenuBox(2,2,1,0,0,0,hanlmenu,#0#0);
    if item=-1 then exit;
    ilosc:=mie*50-ilu_ludzi;
    case item of
      0: handluj(ilosc, 25, 'kolonisci', kol, kolst);
      1: handluj(ilosc, 25, 'naukowcy', nau, naust);
      2: handluj(ilosc, 25, 'zolnierze', zol, zolst);
    end;
  until item=-1;
end;

procedure handel;
var item:integer;
begin
  if czy_st then begin
    repeat
     item:=MenuBox(1,1,1,0,0,0,han1menu,#0#0);
     case item of
       0: handel_surowce;
       1: handel_maszyny;
       2: handel_ludzie;
     end;
    until item=-1;
  end else brak_statku;
end;

procedure opuszczenie;
begin
  writeln(#13#10'--- GLOD W BAZIE ---');
  writeln('Glodziles swoich ludzi, az ich'#13#10'zaglodziles! Czesc kopnela w kalendarz,');
  writeln('czesc uciekla, a reszta powiesila Cie'#13#10'na najblizszym drzewie!'#13#10'To juz koniec Twojej gry!');
  czekaj;
  koniec_gry:=true;
end;

procedure komornik;
begin
  writeln('--- ZBANKRUTOWALES ---'#13#10'Twoj dlug przekroczyl dopuszczalne normy i nie'#13#10'zdazyles go splacic!');
  writeln('Komornik zarekwirowal Twoja planete jako zastaw'#13#10'na splate dlugow!. To juz koniec Twoich rzadow');
  writeln('na tej planecie!');
  czekaj;
  koniec_gry:=true;
end;

procedure losowanie_statku;
var magraz,pomoc,pomoc2,nr_st:integer;

procedure losowanie_surowcow(cenamin,cenamax,cenarand:integer; var statek,cena:integer);
var pomoc,pomoc2:integer;
begin
  pomoc:=random(21)+1;
  pomoc2:=random(nr_st*magraz)+nr_st*magraz;
  if pomoc=21 then statek:=0
  else if pomoc<=10 then statek:=-pomoc2 else statek:=pomoc2;
  cena:=random(cenarand);
  if statek<0 then inc(cena,cenamin) else inc(cena,cenamax);
end;

procedure losowanie_maszyn(cenamin,cenamax,cenarand,magg:integer; var statek,cena:integer);
var pomoc,pomoc2:integer;
begin
  pomoc:=random(21)+1;
  pomoc2:=random(nr_st*magraz*magg);
  if pomoc=21 then statek:=0
  else if pomoc<=10 then statek:=-pomoc2 else statek:=pomoc2;
  cena:=random(cenarand);
  if statek<0 then inc(cena,cenamin) else inc(cena,cenamax);
end;

begin
  czy_st:=true;
  pomoc:=random(30)+1;
  case lad of
    0:     if pomoc>10 then czy_st:=false;
    1..5:  if pomoc>18 then czy_st:=false;
    5..10: if pomoc>25 then czy_st:=false;
  end;
  if ((rok=2090) and (mies=1)) then czy_st:=true;
  if czy_st then begin
  nr_st:=random(20)+(lad div 2)+random(lad*5)+((lad div 2)+(lad*5));
  if nr_st<lad div 2 then nr_st:=lad div 2;
  magraz:=15;
  case nr_st of
        0..20     : magraz:=3;
        21..100   : magraz:=5;
        101..1000 : magraz:=10
  end;
  losowanie_surowcow(14,10,7,krzst,cenakrz);
  losowanie_surowcow(29,20,12,zelst,cenazel);
  losowanie_surowcow(90,70,41,urast,cenaura);
  losowanie_surowcow(19,15,7,zywst,cenazyw);

  if lad<100 then magraz:=1 else magraz:=10;
  losowanie_maszyn(950,700,350,3,bx1st,cenabx1);
  losowanie_maszyn(1500,1100,500,2,bx2st,cenabx2);
  losowanie_maszyn(5000,3500,1502,1,genst,cenagen);
  losowanie_maszyn(1750,1300,550,2,bb1st,cenabb1);
  losowanie_maszyn(2500,1850,750,2,xwist,cenaxwi);

  pomoc:=random(11)+1;
  pomoc2:=(random(nr_st)+(nr_st div 10))*2;
  if pomoc=11 then kolst:=0 else kolst:=pomoc2;

  pomoc:=random(11)+1;
  pomoc2:=(random(nr_st)+(nr_st div 10)) div 2;
  if pomoc=11 then naust:=0 else naust:=pomoc2;

  pomoc:=random(11)+1;
  pomoc2:=random(nr_st)+(nr_st div 10) div 2;
  if pomoc=11 then zolst:=0 else zolst:=pomoc2;

  writeln('Wyladowal statek typu VARG-',nr_st);
  end;
end;

procedure trzesienie_ziemi;
begin
  writeln('Trzesienie ziemi zniszczylo 10% twoich'#13#10'kopalni!');
  dec(krzkop,krzkop div 10);
  dec(zelkop,zelkop div 10);
  dec(urakop,urakop div 10);
  czekaj;
end;

procedure bestie;
var ile:integer;
begin
  ile:=random(3)*10;
  writeln('Bestie zniszczyly ',ile,'% upraw!');
  dec(kolupr,(kolupr*ile) div 100);
  czekaj;
end;

procedure imperator;
begin
  inc(got,100000000);
  writeln('Za namowa glownego ksiegowego'#13#10'WIELKI IMPERATOR przysyla Ci'#13#10'100.000.000!');
  czekaj;
end;

procedure gremliny;
begin
  gen:=gen div 2;
  writeln('Zaatakowaly Cie Gremliny!!!'#13#10'Zjadly polowe generatorow.');
  czekaj;
end;

procedure wydarzenie(nr:longint);
begin
  if ((nr<49999) and (nr>=49990)) then trzesienie_ziemi;
  if ((nr<49990) and (nr>=44999)) then bestie;
  if ((nr=39898) or (nr=1)) then imperator;
{  if ((nr<=39898) and (nr>=39699)) then napad;}
  if ((nr<39399) and (nr>=39359)) then gremliny;
end;

procedure plansza;
var glod,wstrzgen,pomoc_b:boolean;
    pomoc,pomoc2,nailzyw,zuzzyw,procuzyw:integer;
    zajete_mag,poj_mag,pensja:integer;
begin
  ClrScr;
  writeln('Gubernator ',imie_gracza,', ',rok,'.',mies,'.1');
  wstrzgen:=false;
  stan_generatorow;
  zajete_mag:=zajete_magazyny;
  poj_mag:=pojemnosc_mag;
  if moc<pobmoc then begin
     writeln('Generator przeciazony!');
     zuzura:=0;
     wstrzgen:=true;
  end;
  if ura<zuzura then begin
     writeln('Brak paliwa do generatora!');
     zuzura:=0;
     wstrzgen:=true;
  end;
  dec(ura,zuzura);
  writeln('Zuzycie uranu ',zuzura,' t.');
  if (ilosc_wydobycia>0) and (not wstrzgen)
      and ((ilosc_wydobycia+zajete_mag)>poj_mag) then begin
         writeln('Wydobycie wstrzymane !'#13#10'Brak magazynow !');
      end else begin
         inc(krz,krzwyd);
         inc(zel,zelwyd);
         inc(ura,urawyd);
         writeln('Wydobycie zrealizowane.');
      end;
  if (czyinw and (not wstrzgen)) then begin
     inc(czasbud);
     if czasbud>=ppczasbud(inw) then begin
     write('Ukonczono budowe ');
     case inw of
          1: begin writeln('mieszkan.');  inc(mie,ilinw); end;
          2: begin writeln('magazynow.'); inc(mag,ilinw); end;
          3: begin writeln('fabryk.');    inc(fab,ilinw); end;
          4: begin writeln('ladowisk.');  inc(lad,ilinw); end;
     end;
     czyinw:=false;
     end;
  end;

  if (czypro and (not wstrzgen)) then begin
    inc(czaspro);
    if czaspro>=ppczaspro(pro) then begin
       write('Ukonczono produkcje ',ilpro*seria_pro[pro],' szt. ',nazwa_pro_d[pro]);
       czypro:=false;
       case pro of
         1: inc(bx1,ilpro*seria_pro[pro]);
         2: inc(bx2,ilpro*seria_pro[pro]);
         3: inc(gen,ilpro*seria_pro[pro]);
         4: inc(bb1,ilpro*seria_pro[pro]);
         5: inc(xwi,ilpro*seria_pro[pro]);
       end;
    end;
  end;
  czekaj;
  if czywyp then begin
     dec(czastrwyp);
     if czastrwyp<1 then begin
        writeln('Wrocila wyprawa.');
        czywyp:=false;
        pomoc:=((kolwyp+(nauwyp div 3)) div 3)+czaswyp;
        if proczbad+pomoc>100 then pomoc:=100-proczbad;
        inc(proczbad,pomoc);
        writeln('Zbadano ',pomoc,'% wyspy.');
        pomoc2:=random(6);
        pomoc_b:=false;
        case pomoc of
          1..4:    pomoc_b:=(pomoc2<pomoc);
          5..100:  pomoc_b:=true;
        end;
        if pomoc_b then begin
          procuzyw:=nauwyp*100;
          if procuzyw>1500 then procuzyw:=1500;
          inc(procuzyw,random(1500));
          pomoc2:=random(3);
          if proczbad>25 then begin
             if krzkop=0 then pomoc2:=0;
             if zelkop=0 then pomoc2:=1;
             if urakop=0 then pomoc2:=2;
          end;
          write('Znaleziono zloza ');
          case pomoc2 of
            0: begin write('krzemu '); inc(krzkop,procuzyw); end;
            1: begin write('zelaza '); inc(zelkop,procuzyw); end;
            2: begin write('uranu ');  inc(urakop,procuzyw); end;
          end;
          writeln(#13#10'o wydajnosci ',procuzyw,'t.');
          end;
          pomoc:=random(3);
          if pomoc=0 then begin
             pomoc2:=(random(71)*kolwyp) div 100;
             procuzyw:=(random(61)*nauwyp) div 100;
             if pomoc2>0 then begin
                writeln('Zginelo ',pomoc2,' kolonistow.');
                kolwyp:=kolwyp-pomoc2;
             end;
             if procuzyw>0 then begin
                writeln('Zginelo ',procuzyw,' naukowcow.');
                nauwyp:=nauwyp-procuzyw;
             end;
          end;
          if (ilu_ludzi+kolwyp)>mie*50 then kolwyp:=(mie*50)-ilu_ludzi;
          inc(kol,kolwyp);
          if (ilu_ludzi+nauwyp)>mie*50 then nauwyp:=(mie*50)-ilu_ludzi;
          inc(nau,nauwyp);
        end;
     end;
  pensja:=kol*10+nau*15;
  dec(got,pensja);
  writeln('Pensja dla zalogi: ',pensja,'.');
  czekaj;
  if (((mies=1) and (rok<>2090)) or (mies=7)) then begin
     pomoc:=kolupr*10;
     pomoc2:=zajete_magazyny;
     if pomoc2>poj_mag then pomoc:=0 else if (pomoc2+pomoc)>=poj_mag then pomoc:=poj_mag-pomoc2;
     writeln('Z pol zebrano ',pomoc,'t zywnosci.');
     inc(zyw,pomoc);
  end;
  zuzzyw:=(kol+nau) div 5;
  if zuzzyw<1 then zuzzyw:=1;
  glod:=(zyw=0);
  dec(zyw,zuzzyw);
  if zyw<0 then zyw:=0;
  writeln('Zuzycie zywnosci: ',zuzzyw,'t.');
  nailzyw:=(zyw div zuzzyw);
  if nailzyw<0 then nailzyw:=0;
  writeln('Zywnosci na ',nailzyw,' miesiecy.');
  if nailzyw<=0 then writeln(' GLOD W BAZIE!');
  if glod then begin
      opuszczenie;
      exit;
  end;
  if nailzyw<=2 then writeln(' MINIMUM ZYWNOSCI !!!');

  czekaj;

  if got<0 then dec(kredyt) else kredyt:=13;
  if got<0 then writeln('Kredyt na ',kredyt,' miesiecy.');
  if kredyt<1 then begin
     komornik;
     exit;
  end;
  wydarzenie(random(50000));
  losowanie_statku;
  czekaj;
end;

function wezopcje:integer;
var item:integer;
begin
     item:=MenuBox(0,0,1,0,0,0,mainmenu,#0#0);
     case item of
          0: item:=10+MenuBox(2,2,1,0,0,0,bud_menu,#0#0);
          1: item:=20+MenuBox(2,2,1,0,0,0,statmenu,#0#0);
          2: item:=30+MenuBox(2,2,1,0,0,0,enermenu,#0#0);
          4: item:=50+MenuBox(2,2,1,0,0,0,exitmenu,#0#0);
     end;
     wezopcje:=item;
end;

procedure cozrobic;
begin
   case wezopcje of
      3: handel;
     10: inwestycje;
     11: produkcja;
     12: wyprawy;
     20: magazyny;
     21: zaloga;
     23: budynki;
     30: uprawy;
     31: generator;
     32: wydobycie;
     50: kongr:=true;
     51: koniec_gry:=true;
   end;
end;

procedure gracz;
begin
  data;
  if (koniec_gry or restart or ((rok=2100) and (mies=1))) then exit;
  kongr:=false;
  plansza;
  repeat
    tabela;
    cozrobic;
  until (kongr or koniec_gry or restart);
end;

begin
  randomize;
  koniec_gry:=false;
  restart:=false;
  for i:=1 to 320 do buff[i]:=32;
  CursorMode(2);
  repeat
    { zapytaj czy od poczatku, czy odczytac z pliku }
    ClrScr;
    odpoczatku;
    repeat
      gracz;
    until ((koniec_gry) or restart or (rok>2099));
    if rok>2099 then plansza_koncowa;
  until koniec_gry;
  ClrScr;
  CursorMode(2);
end.
