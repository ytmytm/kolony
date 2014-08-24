{************************}
{*    Gra pt.KOLONY     *}
{*    Artur  Siupik     *}
{*  (c) 1993-1994, AS   *}
{************************}



program KOLONY;
uses crt,dos,dodatki,clock,kol_pocz,kol_1;
type attt = record
              kto : byte;
              czy : boolean
            end;
     lon5 = array[1..5] of longint;
     int5 = array[1..5] of integer;
     byt5 = array[1..5] of byte;
var
iden1,i,moc,mocpro,tow,pobmoc,krzinw,zelinw,urainw,mocinw,pomoc  : longint;
pomoc2,kolfab,naufab,zuzura,pensja,zuzzyw,nailzyw,magraz,mocfab  : longint;
krzkopp,urakopp,zelkopp,krzwydd,urawydd,zelwydd,v,woldysk,nrwyd  : longint;
krzpro,zelpro,urapro,zoll,bb11,xwii,krzz,uraa,zell,zyww,genn     : longint;
magg,miee,ladd,koll,nauu,bx11,bx22,krzst,urast,zelst,zywst,ile   : longint;
bx1st,bx2st,genst,xwist,bb1st,kolst,naust,zolst,licznik,cenakrz  : longint;
cenazel,cenaura,cenazyw,cenabx1,cenabx2,cenagen,cenabb1,cenaxwi  : longint;
nr_st,rodzajst,fabb                                              : longint;
jx,jy,procuzyw,proc,rodzst,pczaspro,rok,pczasbud,st_jx           : integer;
st_jy,koluprr,kolwypp,nauwypp,ilproo                             : integer;
czaswypp,czastrwwypp,iden5,mies,aktpoz,proo,ilgr,gdziey,poczgr   : byte;
proczbadd,inww,ilinww,ruchy,kredytt,ii,nr                        : byte;
pomoc_b,joy2,joy,iden3,czyod,czyproo,kongr,czyinww,lg,czy_sound  : boolean;
czy_st,koniec_gry,restart,czywypp,czym,glod,wszyscy,zamykanie    : boolean;
dap,dep,dsp,dlp,dop,z,ap,cp,ep,lp,sp,zp,xp,dzp                   : char;
gott                                                             : real;
regs                                                             : registers;
f                                                                : file;
ftext                                                            : text;
a                                                                : string;
naj,img                                                          : string[17];
iden4,nazwa                                                      : string[8];
nazwa1                                                           : string[12];
t                               : array[1..50] of string;
imgr                            : array[1..5] of string[17];
czyatak                         : array[1..5] of attt;
got                             : array[1..5] of real;
czyinw,czywyp,czypro,czygr      : array[1..5] of boolean;
zol,bb1,xwi,krz,ura,zel,zyw,gen,fab,mag,mie,lad,kol,nau,bx1,bx2     : lon5;
krzkop,krzwyd,urakop,urawyd,zelkop,zelwyd                           : lon5;
kolupr,kolwyp,nauwyp,ilpro                                          : int5;
czasbud,czaspro,pro,proczbad,inw,ilinw,czaswyp,czastrwwyp,kredyt,dl : byt5;

procedure zamykanie_okien;
begin
  write(' Zamyka',cp,' okna po wyj',sp,'ciu z opcji ? : ');
  z:=key;
  z:=upcase(z);
  if z<>'N' then z:='T';
  writeln(z);
  if z='T' then zamykanie:=true else zamykanie:=false;
end; {zamykanie}

procedure obsluga;
begin
  writeln(' Obs',lp,'uga przez :');
  writeln(' 1 : Klawiatur',ep);
  writeln(' 2 : Joystick');
  gotoxy(18,3);
  z:=key;
  if z<>'2' then czym:=false else czym:=true;
  if czym then writeln('2') else writeln('1');
  gotoxy(1,8);
  z:='/';
  if czym then
  begin
    writeln(' Wycentruj joystick i naci',sp,'nij "fire"');
    repeat
      joy2:=false;
      regs.AH:=$84;
      regs.DX:=0;
      intr($15,regs);
      if ((regs.AL and 16) / 16 )=0 then joy2:=true;
      if ((regs.AL and 32) / 32 )=0 then joy2:=true;
      regs.AH:=$84;
      regs.DX:=1;
      intr($15,regs);
      st_jy:=regs.BX div 40;
      st_jx:=regs.AX div 40;
      if keypressed then z:=readkey;
      if z=#27 then
        begin
          gotoxy(19,14);
          writeln(' Obs'+lp+'uga przez klawiatur'+ep+'! ');
          czym:=false;
        end;
    until ((joy2) or (z=#27));
  end;
end {obsluga};

procedure litery(czy:boolean);
begin
  znaki(czy);
  if czy then
  begin
    ap:=#134;
    cp:=#141;
    ep:=#145;
    lp:=#146;
    sp:=#158;
    zp:=#167;
    xp:=#166;
    dap:=#143;
    dzp:=#161;
    dsp:=#152;
    dlp:=#156;
    dop:=#163;
    dep:=#144;
  end else
  begin
    ap:='a';
    cp:='c';
    ep:='e';
    lp:='l';
    sp:='s';
    zp:='z';
    xp:='z';
    dap:='A';
    dzp:='Z';
    dlp:='L';
    dsp:='S';
    dop:='O';
    dep:='E';
  end;
end; {litery}

procedure ustaw_cfg;
var pel : boolean;
begin
  pel:=true;
  if diskfree(0)<100 then
    begin
      blad(200);
      pel:=false;
    end;
  assign(ftext,'kolony.cfg');
  {$I-}
  rewrite(ftext);
  {$I+}
  nr:=ioresult;
  if nr<>0 then
    begin
      blad(nr);
      pel:=false;
    end;
  show_kursor;
  pomoc_b:=mazovia;
  litery(pomoc_b);
  {$I-}
  if pel then writeln(ftext,'Czy u'+zp+'ywasz polskich liter w standardzie Mazovia ?');
  if pel then if pomoc_b then writeln(ftext,'TAK') else writeln(ftext,'NIE');
  if pel then writeln(ftext,'Czy u'+zp+'ywasz joysticka ?');
  obsluga;
  if pel then if czym=false then writeln(ftext,'NIE') else writeln(ftext,'TAK');
  zamykanie_okien;
  if pel then writeln(ftext,'Zamykanie okien');
  if pel then if zamykanie then writeln(ftext,'TAK') else writeln(ftext,'NIE');
  {$I+}
  nr:=ioresult;
  if nr<>0 then blad(nr);
  {$I-}
  close(ftext);
  {$I+}
  kill_kursor;
end; {ustaw_cfg}


procedure ttt;
begin
  t[1]:= '  Inwestycje   ';
  t[2]:= '  Produkcja    ';
  t[3]:= '  Wyprawy      ';
  t[4]:= '  Uprawy       ';
  t[5]:= '  Magazyny     ';
  t[6]:= '  Za'+lp+'oga       ';
  t[7]:= '  Wojsko       ';
  t[8]:= '  Budynki      ';
  t[9]:= '  Generator    ';
  t[10]:='  Wydobycie    ';
  t[11]:='  Handel       ';
  t[12]:='  Dalej        ';
  t[13]:='  Mieszkania  ';
  t[14]:='  Magazyny    ';
  t[15]:='  Fabryki     ';
  t[16]:='  L'+ap+'dowiska   ';
  t[17]:='  Start    ';
  t[18]:='  Powr¢t   ';
  t[19]:='  Wyj'+sp+'cie  ';
  t[20]:='  roboty bx-1  ';
  t[21]:='  roboty bx-2  ';
  t[22]:='  generatory   ';
  t[23]:='  roboty bb-1  ';
  t[24]:='  X-wingi      ';
  t[25]:='  Dalej    ';
  t[26]:='  Wyj'+sp+'cie  ';
  t[27]:='  Zapis    ';
  t[28]:='  Restart  ';
  t[29]:='  DOS      ';
  t[30]:=' TAK ';
  t[31]:=' NIE ';
  t[37]:='  Surowce   ';
  t[38]:='  Maszyny   ';
  t[39]:='  Ludzie    ';
  t[40]:='  Wyj'+sp+'cie   ';
  for i:=1 to 5 do t[31+i]:=stringcenter(imgr[i],19);
end; {ttt}

procedure konfiguracja;
begin
  ramka(true,true,5,3,75,18);
  window(6,4,74,17);
  ustaw_cfg;
  window(1,1,80,25);
  gdziey:=2;
  ttt;
end; {konfiguracja}

procedure wczytaj_config;
var info : searchrec;
begin
  kill_kursor;
  clrscr;
  findfirst('kolony.cfg',Anyfile,info);
  if DosError=18 then
    begin
      ramka(true,false,1,12,80,14);
      g(2,13,stringcenter('Brak pliku KOLONY.CFG !',78));
      z:=key;
      ustaw_cfg;
    end
  else
    begin
      {$I-}
      assign(ftext,'kolony.cfg');
      reset(ftext);
      readln(ftext,pomoc_s);
      readln(ftext,pomoc_s);
      if pomoc_s='TAK' then litery(true) else litery(false);
      readln(ftext,pomoc_s);
      readln(ftext,pomoc_s);
      if pomoc_s='TAK' then czym:=true else czym:=false;
      readln(ftext,pomoc_s);
      readln(ftext,pomoc_s);
      if pomoc_s='NIE' then zamykanie:=false else zamykanie:=true;
      close(ftext);
      {$I+}
      nr:=ioresult;
      if nr<>0 then
        begin
          ramka(true,false,1,12,80,14);
          g(2,13,stringcenter('Blad '+stt(nr)+' podczas czytania pliku KOLONY.CFG !!!',78));
          halt(nr);
        end;
    end;
end; {wczytaj_config}

function ruch_j:char;
var
  z          : char;
begin
  case czym of
    false : z:=key;
    true  : repeat
              joy:=false;
              joy2:=joy;
              z:='/';
              regs.AH:=$84;
              regs.DX:=0;
              intr($15,regs);
              if ((regs.AL and 16) / 16 )=0 then begin z:=#13;joy2:=true;end;
              if ((regs.AL and 32) / 32 )=0 then begin z:=#13;joy2:=true;end;
              regs.AH:=$84;
              regs.DX:=1;
              los;
              intr($15,regs);
              jx:=regs.AX div 40;
              if jx>st_jx then begin z:=right;joy:=true;end;
              if jx<st_jx then begin z:=left;joy:=true;end;
              if (joy and joy2) then
              begin
                if jx>st_jx then z:=fp;
                if jx<st_jx then z:=fl;
              end;
              jy:=regs.BX div 40;
              if jy>st_jy then begin z:=down;joy:=true;end;
              if jy<st_jy then begin z:=up;joy:=true;end;
              if (joy and joy2) then
              begin
                if jy>st_jy then z:=pgdown;
                if jy<st_jy then z:=pgup;
              end;
              if keypressed then z:=key;
            until z<>'/';
  end;
  ruch_j:=z;
end; {ruch_j}

function ruch_j_x:char;
var z:char;
begin
  repeat
    z:=ruch_j;
  until ((z=left) or (z=fl) or (z=right) or (z=fp) or (z=enter));
  ruch_j_x:=z;
end; {ruch_j_x}

function ruch_j_y:char;
var z:char;
begin
  repeat
    z:=ruch_j;
  until ((z=down) or (z=pgdown) or (z=up) or (z=pgup) or (z=enter) or (z=#19) or (z=f1) or (z=f2) or (z=',') or (z='.'));
  ruch_j_y:=z;
end; {ruch_j_y}

procedure czekaj;
var z : char;
begin
  z:=ruch_j;
  los;
  if czym then if joy2 then delay(200);
end; {czekaj}


procedure gr(x:byte);
begin
  zyw[x]:=zyww;
  got[x]:=gott;
  krz[x]:=krzz;
  ura[x]:=uraa;
  zel[x]:=zell;
  mie[x]:=miee;
  mag[x]:=magg;
  fab[x]:=fabb;
  lad[x]:=ladd;
  kol[x]:=koll;
  nau[x]:=nauu;
  bx1[x]:=bx11;
  bx2[x]:=bx22;
  gen[x]:=genn;
  bb1[x]:=bb11;
  xwi[x]:=xwii;
  zol[x]:=zoll;
  urakop[x]:=urakopp;
  urawyd[x]:=urawydd;
  krzwyd[x]:=krzwydd;
  krzkop[x]:=krzkopp;
  zelwyd[x]:=zelwydd;
  zelkop[x]:=zelkopp;
  kolupr[x]:=koluprr;
  proczbad[x]:=proczbadd;
  kolwyp[x]:=kolwypp;
  nauwyp[x]:=nauwypp;
  czastrwwyp[x]:=czastrwwypp;
  czaswyp[x]:=czaswypp;
  ilinw[x]:=ilinww;
  inw[x]:=inww;
  czyinw[x]:=czyinww;
  pro[x]:=proo;
  ilpro[x]:=ilproo;
  czypro[x]:=czyproo;
  czywyp[x]:=czywypp;
  kredyt[x]:=kredytt;
end;

function silboj:longint;
begin
  silboj:=zoll+bb11*5+xwii*10;
end;

function silrob:longint;
begin
  silrob:=koll+bx11*2+bx22*5;
end;

procedure zapis;
begin
  gr(v);
  clrscr;
  ramka(true,true,4,4,38,6);
  g(5,5,stringcenter('Wybierz nazw'+ep+' pliku.',33));
  nazwa1:=wybierz(40,'Nowy','*.kol',ap,cp,ep,sp);
  kill_kursor;
  if nazwa1='' then exit;
  if nazwa1='Nowy' then
    begin
      ramka(true,true,20,11,70,13);
      gotoxy(22,12);
      write('Podaj nazw',ep,' pliku  (max. 8 znak¢w) : ');
      show_kursor;
      nazwa1:=wprowadz_t(59,12,8);
      kill_kursor;
      if nazwa1='' then exit;
      nazwa1:=nazwa1+'.kol';
    end;
  woldysk:=diskfree(0);
  if ioresult=0 then if woldysk<6656 then blad(202) else
  begin
    poczgr:=v+1;
    if poczgr>ilgr then poczgr:=1;
    iden1:=56841;
    iden3:=true;
    iden4:='Ûáe ðøde';
    assign(f,nazwa1);
    {$I-}
    rewrite(f);
    {$I+}
    nr:=ioresult;
    if nr<>0 then
      begin
        blad(nr);
        exit;
      end;
      {$I-}
      blockwrite(f,iden4,1);
      blockwrite(f,iden1,1);
      blockwrite(f,czyatak,1);
      blockwrite(f,rok,1);
      blockwrite(f,iden5,1);
      blockwrite(f,mies,1);
      blockwrite(f,ilgr,1);
      blockwrite(f,poczgr,1);
      blockwrite(f,czy_sound,1);
      blockwrite(f,iden3,1);
      blockwrite(f,got,1);
      blockwrite(f,zol,1);
      blockwrite(f,kol,1);
      blockwrite(f,nau,1);
      blockwrite(f,bb1,1);
      blockwrite(f,xwi,1);
      blockwrite(f,czyinw,1);
      blockwrite(f,czywyp,1);
      blockwrite(f,czypro,1);
      blockwrite(f,krz,1);
      blockwrite(f,ura,1);
      blockwrite(f,zel,1);
      blockwrite(f,zyw,1);
      blockwrite(f,mag,1);
      blockwrite(f,mie,1);
      blockwrite(f,lad,1);
      blockwrite(f,fab,1);
      blockwrite(f,gen,1);
      blockwrite(f,bx1,1);
      blockwrite(f,bx2,1);
      blockwrite(f,krzkop,1);
      blockwrite(f,krzwyd,1);
      blockwrite(f,urakop,1);
      blockwrite(f,urawyd,1);
      blockwrite(f,zelkop,1);
      blockwrite(f,zelwyd,1);
      blockwrite(f,kolupr,1);
      blockwrite(f,kolwyp,1);
      blockwrite(f,nauwyp,1);
      blockwrite(f,ilpro,1);
      blockwrite(f,czasbud,1);
      blockwrite(f,czaspro,1);
      blockwrite(f,pro,1);
      blockwrite(f,proczbad,1);
      blockwrite(f,inw,1);
      blockwrite(f,ilinw,1);
      blockwrite(f,czaswyp,1);
      blockwrite(f,czastrwwyp,1);
      blockwrite(f,kredyt,1);
      blockwrite(f,czygr,1);
      for ii:=1 to 5 do dl[ii]:=length(imgr[ii]);
      blockwrite(f,dl,1);
      for ii:=1 to 5 do imgr[ii]:=stringleft(imgr[ii],17);
      blockwrite(f,imgr,1);
      {$I+}
      for ii:=1 to 5 do
        begin
          pomoc_s:='';
          pomoc_s:=copy(imgr[ii],1,dl[ii]);
          imgr[ii]:=pomoc_s;
        end;
      nr:=ioresult;
      if nr<>0 then
        begin
          blad(nr);
          exit;
        end;
    {$I-}
    close(f);
    {$I+}
    clrscr;
    ramka(true,true,20,11,70,13);
    g(41,12,'Zapisano');
    czekaj;
  end;
  aktpoz:=14;
  gdziey:=2;
end;

procedure odczyt;
var wynik : integer;
    czymm : boolean;
begin
  czymm:=czym;
  czyod:=true;
  clrscr;
  g(1,3,' Wybierz plik z zapisan'+ap+' gr'+ap+'.');
  nazwa1:=wybierz(40,'','*.kol',ap,cp,ep,sp);
  kill_kursor;
  if nazwa1='' then
  begin
    czyod:=false;
    exit;
  end else
  begin
    assign(f,nazwa1);
    {$I-}
    reset(f);
    {$I+}
    nr:=ioresult;
    if nr<>0 then
      begin
        blad(nr);
        czyod:=false;
        exit;
      end;
      {$I-}
      blockread(f,iden4,1);
      blockread(f,iden1,1);
      blockread(f,czyatak,1);
      blockread(f,rok,1);
      blockread(f,iden5,1);
      blockread(f,mies,1);
      blockread(f,ilgr,1);
      blockread(f,poczgr,1);
      blockread(f,czy_sound,1);
      blockread(f,iden3,1);
      blockread(f,got,1);
      blockread(f,zol,1);
      blockread(f,kol,1);
      blockread(f,nau,1);
      blockread(f,bb1,1);
      blockread(f,xwi,1);
      blockread(f,czyinw,1);
      blockread(f,czywyp,1);
      blockread(f,czypro,1);
      blockread(f,krz,1);
      blockread(f,ura,1);
      blockread(f,zel,1);
      blockread(f,zyw,1);
      blockread(f,mag,1);
      blockread(f,mie,1);
      blockread(f,lad,1);
      blockread(f,fab,1);
      blockread(f,gen,1);
      blockread(f,bx1,1);
      blockread(f,bx2,1);
      blockread(f,krzkop,1);
      blockread(f,krzwyd,1);
      blockread(f,urakop,1);
      blockread(f,urawyd,1);
      blockread(f,zelkop,1);
      blockread(f,zelwyd,1);
      blockread(f,kolupr,1);
      blockread(f,kolwyp,1);
      blockread(f,nauwyp,1);
      blockread(f,ilpro,1);
      blockread(f,czasbud,1);
      blockread(f,czaspro,1);
      blockread(f,pro,1);
      blockread(f,proczbad,1);
      blockread(f,inw,1);
      blockread(f,ilinw,1);
      blockread(f,czaswyp,1);
      blockread(f,czastrwwyp,1);
      blockread(f,kredyt,1);
      blockread(f,czygr,1);
      blockread(f,dl,1);
      blockread(f,imgr,1);
      for ii:=1 to 5 do
        begin
          pomoc_s:='';
          pomoc_s:=copy(imgr[ii],1,dl[ii]);
          imgr[ii]:=pomoc_s;
        end;
      for ii:=1 to 5 do t[31+ii]:=stringcenter(imgr[ii],19);
      {$I+}
      if czy_sound then dzwiek(true) else dzwiek(false);
      nr:=ioresult;
      if nr<>0 then
        begin
          wczytaj_config;
          blad(nr);
          czyod:=false;
          exit;
        end;
      {$I-}
      close(f);
      {$I+}
    czyod:=true;
    if iden1<>56841 then
      begin
        blad(201);
        czyod:=false;
        exit;
      end;
    if iden3<>true then
      begin
        blad(201);
        czyod:=false;
        exit;
      end;
    if iden4<>'Ûáe ðøde' then
      begin
        blad(201);
        czyod:=false;
        exit;
      end;
  end;
  czym:=czymm;
end {odczyt};


procedure pocz;
var cc : byte;
begin
for cc:=1 to 5 do begin
  czygr[cc]:=true;
  czyatak[cc].czy:=false;
  czyinw[cc]:=false;
  czypro[cc]:=false;
  czywyp[cc]:=false;
  zyw[cc]:=25;
  got[cc]:=50000;
  krz[cc]:=20;
  zel[cc]:=20;
  ura[cc]:=20;
  bx1[cc]:=0;
  bx2[cc]:=0;
  gen[cc]:=1;
  bb1[cc]:=0;
  xwi[cc]:=0;
  kol[cc]:=20;
  nau[cc]:=2;
  mie[cc]:=1;
  mag[cc]:=1;
  fab[cc]:=0;
  lad[cc]:=0;
  zol[cc]:=0;
  urakop[cc]:=0;
  urawyd[cc]:=0;
  krzwyd[cc]:=0;
  krzkop[cc]:=0;
  zelwyd[cc]:=0;
  zelkop[cc]:=0;
  kolupr[cc]:=0;
  kolwyp[cc]:=0;
  nauwyp[cc]:=0;
  proczbad[cc]:=0;
  end;
  rok:=2090;
  mies:=0;
  clrscr;
  for i:=ilgr+1 to 5 do czygr[i]:=false;
  poczgr:=1;
  wszyscy:=false;
  koniec_gry:=false;
  restart:=false;
end {pocz};

procedure odczytt;
begin
  show_kursor;
  if wszyscy then
    begin
      kolor1;
      clrscr;
    end;
  restart:=false;
  clrscr;
  if czym then
    begin
      writeln('Wycentruj joystick i naci',sp,'nij "fire".');
      repeat
        joy2:=false;
        regs.AH:=$84;
        regs.DX:=0;
        intr($15,regs);
        if ((regs.AL and 16) / 16 )=0 then joy2:=true;
        if ((regs.AL and 32) / 32 )=0 then joy2:=true;
        regs.AH:=$84;
        regs.DX:=1;
        intr($15,regs);
        st_jy:=regs.BX div 40;
        st_jx:=regs.AX div 40;
        if keypressed then
          begin
            writeln(' Obs'+lp+'uga przez klawiatur'+ep+'! ');
            czym:=false;
            z:=readkey;
          end;
      until ((czym=false) or (joy2));
    end;
  write(#13#10'Wczyta',cp,' zapisan',ap,' gr',ep,' ? : ');
  z:=key;
  z:=upcase(z);
  if z<>'T' then z:='N';
  writeln(z);
  if z='T' then czyod:=true else czyod:=false;
end; {odczytt}


procedure odpoczatku;
var kod : integer;
begin
  show_kursor;
  repeat
    clrscr;
    write('Podaj liczb',ep,' graczy : ');
    z:=key;
    writeln(z);
    ilgr:=9;
    case z of
      '1'..'5' : val(z,ilgr,kod)
    end;
  until ((ilgr>0)and(ilgr<6));
  writeln('');
  imgr[1]:='Gracz 1';
  imgr[2]:='Anonimus B';
  imgr[3]:='Kaczuszek III';
  imgr[4]:='Mafiu $4$';
  imgr[5]:='Muminkus V Wielki';
  for i:=1 to ilgr do
  begin
    gotoxy(1,i+1);
    write('Podaj imi'+ep+' ',i,' gracza : ');
    pomoc_s:=wprowadz_t(23,i+1,17);
    if pomoc_s<>'' then imgr[i]:=pomoc_s;
    g(23,i+1,imgr[i]);
  end;
  if imgr[1]='' then imgr[1]:='Gracz 1';
  if imgr[2]='' then imgr[2]:='Anonimus B';
  if imgr[3]='' then imgr[3]:='Kaczuszek III';
  if imgr[4]='' then imgr[4]:='Mafiu $4$';
  if imgr[5]='' then imgr[5]:='Muminkus V Wielki';
  pocz;
end {odpoczatku};

procedure wybor(x1,ymin,ymax,aktpoz,aktt,tmin,tmax:byte);
var
tt,ttold,ruchyold:byte;
zz:char;

  procedure wgore;
    begin
      dec(tt);
      if tt<tmin then tt:=tmax;
      dec(ruchy);
      if ruchy<ymin then ruchy:=ymax;
    end;
  procedure wdol;
    begin
      inc(tt);
      if tt>tmax then tt:=tmin;
      inc(ruchy);
      if ruchy>ymax then ruchy:=ymin;
    end;

begin
  tt:=aktt;
  kolor2;
  g(x1,aktpoz,t[aktt]);
  kolor1;
  ruchy:=aktpoz;
  repeat
    los;
    zz:=ruch_j_y;
    ttold:=tt;
    ruchyold:=ruchy;
    case zz of
      pgup,#071   : begin
                      tt:=tmin;
                      ruchy:=ymin
                    end;
      #079,pgdown : begin
                      tt:=tmax;
                      ruchy:=ymax
                    end;
      up          : wgore;
      down        : wdol;
      #19         : begin
                      if czy_sound then czy_sound:=false else czy_sound:=true;
                      gotoxy(50,22);
                      if czy_sound then
                        begin
                          write('Sound ON ');
                          dzwiek(true)
                        end
                      else
                        begin
                          write('Sound OFF');
                          dzwiek(false)
                        end;
                    end;
    end;
    if ttold<>tt then
    begin
      g(x1,ruchyold,t[ttold]);
      kolor2;
      g(x1,ruchy,t[tt]);
      kolor1;
    end;
    if czym then if joy then delay(80);
    if czym then if joy2 then delay(200);
  until ((zz=enter) or (zz=f1) or (zz=f2));
  gdziey:=wherey;
  z:=zz;
end; {wybor}


procedure czyscimie;
begin
  g(25,23,'                   ');
end; {czyscimie}

procedure tabela;
begin
  kolor1;
  gotoxy(1,2);
  ramka(false,true,2,2,18,15);
  for i:=1 to 12 do g(3,2+i,t[i]);
  linia(true,true,1,80,21);
  gotoxy(4,23);write(rok,'.',mies,'.1');
  czyscimie;
  gotoxy(25,23);write(img);
  gotoxy(50,23);write('Konto : ',gott:20:0);   {gott od x:=58}
  g(2,25,'F1-Help    F2-Konfiguracja');
  wybor(3,3,14,aktpoz,aktpoz-2,1,12);
end; {tabela}

procedure ruch2(x,y:byte;min,max:integer;czys,maxl:byte);
begin
  ile:=min;
  repeat;
    for i:=x to (x+czys) do
      begin
        g(i,y,' ');
      end;
    gotoxy(x,y);write(ile);
    z:=ruch_j_y;
    licznik:=1;
    if ile>30 then licznik:=10;
    if ile>300 then licznik:=100;
    if ile>3000 then licznik:=1000;
    if ile>30000 then licznik:=10000;
    if ile>maxl*3 then licznik:=maxl;
    if z=pgup then ile:=ile+licznik;
    if z=up then inc(ile);
    if ile>max then ile:=max;
    if z=pgdown then ile:=ile-licznik;
    if z=down then dec(ile);
    if ile<min then ile:=min;
    if z='.' then ile:=max;
    if z=',' then ile:=min;
    if (joy and joy2) then delay(80) else if czym then if joy then delay(80) else if czym then if joy2 then delay(200);
  until z=enter;
end; {ruch2}

procedure ruch3(l1,dl1,x1,l2,dl2,x2,y,rodzaj,cena:longint;czypod:boolean);
var ll1 : longint;
begin     { rodzaj : 0-nic, 1-do magazynu, 2-do mieszka¤ }
  ll1:=l1;
  repeat
    gotoxy(x1,y);
    write(stringright(stt(l1),dl1));
    gotoxy(x2,y);
    write(stringright(stt(l2),dl2));
    kolor1;
    gotoxy(58,23);
    write(gott:20:0);
    los;
    case rodzaj of
      1 : begin
            magraz:=magg*500;
            tow:=(krzz+zell+uraa+zyww+l1-ll1);
            proc:=magraz div 100;
            procuzyw:=(tow div proc);
            gotoxy(66,11);write(magraz:7);
            gotoxy(66,10) ;write(procuzyw:6,'%');
          end;
      2 : begin
            magraz:=miee*50;
            tow:=(koll+nauu+zoll+l1-ll1);
            gotoxy(63,16);write(magraz:9);
            gotoxy(63,15);write(tow:9);
          end;
    end;
    if czypod then kolor2;
    z:=ruch_j;
    licznik:=1;
    case z of
      fl:begin
             if l2>30 then licznik:=10;
             if l2>300 then licznik:=100;
             if l2>3000 then licznik:=1000;
             if l2>30000 then licznik:=10000;
             if l2>300000 then licznik:=100000;
             z:=left;
           end;
      fp:begin
             if l1>30 then licznik:=10;
             if l1>300 then licznik:=100;
             if l1>3000 then licznik:=1000;
             if l1>30000 then licznik:=10000;
             if l1>300000 then licznik:=100000;
             z:=right;
           end;
      ',':begin
            licznik:=l2;
            z:=left;
          end;
      '.':begin
            licznik:=l1;
            z:=right;
          end;
    end;
    if z=right then
      if ((l2<0) and (l1>0)) then
        begin
          if l2+licznik>0 then licznik:=0-l2;
          l1:=l1-licznik;
          l2:=l2+licznik;
          gott:=gott+(licznik*cena);
        end;
    if z=left then
      if l2>0 then
        begin
          if l2-licznik<0 then licznik:=l2;
          case rodzaj of
            1:if (licznik+l1-ll1+krzz+uraa+zell+zyww)>(magg*500) then licznik:=(magg*500)-krzz-zell-zyww-uraa-(l1-ll1);
            2:if (licznik+l1-ll1+koll+nauu+zoll)>(miee*50) then licznik:=(miee*50)-koll-nauu-zoll-(l1-ll1);
          end;
          l1:=l1+licznik;
          l2:=l2-licznik;
          gott:=gott-(licznik*cena);
        end;
    if ((czym) and (joy)) then delay(100);
until ((z=enter) or (z=up) or (z=down) or (z=pgup) or (z=pgdown));
if ((czym) and (joy2)) then delay(200);
pomoc:=l1;
pomoc2:=l2;
end; {ruch3}

procedure ruch4(l1,dl1,x1,l2,dl2,x2,y,max:longint;czypod:boolean);
var ll1 : longint;
begin
  ll1:=l1;
  repeat
    gotoxy(x1,y);
    write(sttr(l1,dl1));
    gotoxy(x2,y);
    write(sttr(l2,dl2));
    kolor1;
    los;
    if czypod then kolor2;
    z:=ruch_j;
    licznik:=1;
    case z of
      fl:begin
             if l2>30 then licznik:=10;
             if l2>300 then licznik:=100;
             if l2>3000 then licznik:=1000;
             if l2>30000 then licznik:=10000;
             if l2>300000 then licznik:=100000;
             z:=left;
           end;
      fp:begin
             if l1>30 then licznik:=10;
             if l1>300 then licznik:=100;
             if l1>3000 then licznik:=1000;
             if l1>30000 then licznik:=10000;
             if l1>300000 then licznik:=100000;
             z:=right;
           end;
      ',':begin
            licznik:=l2;
            z:=left;
          end;
      '.':begin
            licznik:=l1;
            z:=right;
          end;
    end;
    if z=right then
      if l1>0 then
        begin
          if max<>0 then if l2+licznik>max then licznik:=max-l2;
          l1:=l1-licznik;
          l2:=l2+licznik;
        end;
    if z=left then
      if l2>0 then
        begin
          l1:=l1+licznik;
          l2:=l2-licznik;
        end;
    if ((czym)and (joy)) then delay(100);
  until ((z=enter) or (z=up) or (z=down) or (z=pgup) or (z=pgdown));
  if ((czym) and (joy2)) then delay(200);
  pomoc:=l1;
  pomoc2:=l2;
end; {ruch4}

procedure brsur(co:string);
begin
  ramka(true,false,31,4,47,6);
  g(33,5,'BRAK SUROWC'+dop+'W');
  if co='i' then czyinww:=false;
  if co='p' then czyproo:=false;
  gdziey:=2;
  aktpoz:=3;
  czekaj;
end;

procedure brmoc(co:string);
begin
  ramka(true,false,30,5,46,7);
  g(34,6,'BRAK MOCY');
  if co='i' then czyinww:=false;
  if co='p' then czyproo:=false;
  aktpoz:=3;
  gdziey:=2;
  czekaj;
end;

procedure MocInwestycji;
begin
  if czyinww then
    case inww of
      1 : mocinw:=ilinww*20;
      2 : mocinw:=ilinww*20;
      3 : mocinw:=ilinww*25;
      4 : mocinw:=ilinww*30;
    end
  else mocinw:=0;
end;

procedure czyinwestycja;
begin
  czyinww:=true;
  if krzinw>krzz then brsur('i');
  if czyinww=true then
    begin
      if zelinw>zell then brsur('i');
    end;
  pobmoc:=0;
  if czyproo then pobmoc:=fabb*20;
  inc(pobmoc,((krzwydd+zelwydd+urawydd) div 10));
  moc:=genn*30-pobmoc;
  if czyinww=true then begin if urainw>uraa then brsur('i');end;
  if czyinww=true then begin if mocinw>moc then brmoc('i');end;
end {czyinwestycja};

procedure czyprodukcja;
begin
  czyproo:=true;
    if krzpro>krzz then brsur('p');
    if czyproo=true then
      begin
        if zelpro>zell then brsur('p');
      end;
    MocInwestycji;
    pobmoc:=mocinw;
    inc(pobmoc,((krzwydd+zelwydd+urawydd) div 10));
    moc:=genn*30-pobmoc;
    if czyproo=true then begin if urapro>uraa then brsur('p');end;
    if czyproo=true then begin if mocpro>moc then brmoc('p');end;
end {czyprodukcja};

function ppczasbud(x:byte):longint;
var sill : longint;
begin
  sill:=silrob;
  if silrob=0
    then ppczasbud:=ilinww*1000
    else
      case x of
        1:ppczasbud:=(ilinww*30) div sill;
        2:ppczasbud:=(ilinww*60) div sill;
        3:ppczasbud:=(ilinww*100) div sill;
        4:ppczasbud:=(ilinww*200) div sill;
      end;
end;

function ppczaspro(x:byte):longint;
begin
  case x of
    1 : ppczaspro:=ilproo div fabb;
    2 : if fabb>1 then ppczaspro:=ilproo div (fabb-1) else ppczaspro:=ilproo+1;
    3 : if fabb>1 then ppczaspro:=(ilproo div (fabb div 2)) else ppczaspro:=ilproo*2;
    4 : if fabb>1 then ppczaspro:=ilproo div (fabb-1) else ppczaspro:=ilproo+1;
    5 : if fabb>1 then ppczaspro:=(ilproo div (fabb div 2)) else ppczaspro:=ilproo*2;
  end;
end;

procedure inwestycje;
var sill : longint;
begin
  if koll<1 then
  begin
    brludz;
    czekaj;
    aktpoz:=3;
    exit;
  end;
  if czyinww=false then
    begin
      sill:=silrob;
      gotoxy(25,5);write('ÉÍÍÍ');kolor2;write(' BUDOWA ');kolor1;write('ÍÍÍ»');
      gotoxy(25,6);write('º  Mieszkania  º');
      gotoxy(25,7);write('º  Magazyny    º');
      gotoxy(25,8);write('º  Fabryki     º');
      gotoxy(25,9);write('º  L',ap,'dowiska   º');
      gotoxy(25,10);write('È',q5,q5,'ÍÍÍÍ¼');
      wybor(26,6,9,6,13,13,16);
      inww:=gdziey-5;
      gotoxy(39,5);write('ÉÍ',q5,q5,q5,'Í»');
      gotoxy(39,6);write('º Ile sztuk :     º');
      gotoxy(39,7);write('º                 º');
      gotoxy(39,8);write('º    SUROWCE :    º');
      gotoxy(39,9);write('º                 º');
      gotoxy(39,10);write('º Krzem  :        º');
      gotoxy(39,11);write('º ',dzp,'elazo :        º');
      gotoxy(39,12);write('º Uran   :        º');
      gotoxy(39,13);write('º Pob¢r mocy :    º');
      gotoxy(39,14);write('º                 º');
      gotoxy(39,15);write('º Czas budowy :   º');
      gotoxy(39,16);write('º                 º');
      gotoxy(39,17);write('ÈÍÍ',q5,q5,q5,'¼');
      ruch2(53,6,1,99,2,10);
      ilinww:=ile;
      if inww=1 then
        begin
          krzinw:=ilinww*50;
          zelinw:=ilinww*25;
          urainw:=0;
          mocinw:=ilinww*20;
          pczasbud:=ppczasbud(1);
        end;
      if inww=2 then
        begin
          krzinw:=ilinww*150;
          zelinw:=ilinww*100;
          urainw:=0;
          mocinw:=ilinww*20;
          pczasbud:=ppczasbud(2);
        end;
      if inww=3 then
        begin
          krzinw:=ilinww*100;
          zelinw:=ilinww*200;
          urainw:=ilinww*50;
          mocinw:=ilinww*25;
          pczasbud:=ppczasbud(3);
        end;
      if inww=4 then
        begin
          krzinw:=ilinww*300;
          zelinw:=ilinww*80;
          urainw:=ilinww*5;
          mocinw:=ilinww*30;
          pczasbud:=ppczasbud(4);
        end;
      gotoxy(50,10);write(krzinw:5,'t');
      gotoxy(50,11);write(zelinw:5,'t');
      gotoxy(50,12);write(urainw:5,'t');
      gotoxy(43,14);write(mocinw:4,'Kw');
      gotoxy(45,16);write(pczasbud,'ms.');
      ramka(true,true,56,10,68,14);
      for i:=12 to 13 do g(57,i,t[i+6]);
      wybor(57,11,13,11,17,17,19);
      gdziey:=wherey;
      if gdziey=11 then
        begin
          czyinwestycja;
          if czyinww then
            begin
              gotoxy(30,1);write('É',q5,q5,q5,'ÍÍÍÍ»');
              gotoxy(30,2);write('º Budowa rozpocz',ep,'ta º');
              gotoxy(30,3);write('È',q5,q5,q5,'ÍÍÍÍ¼');
              krzz:=krzz-krzinw;
              zell:=zell-zelinw;
              uraa:=uraa-urainw;
              pobmoc:=mocinw;
              ilinww:=ilinww;
              czyinww:=true;
              czasbud[v]:=0;
              czekaj;
            end;
        end;
      if gdziey=12 then inwestycje;
      if gdziey=13 then czyinww:=false;
      aktpoz:=3;
      gdziey:=2;
    end
    else
      begin
        ramka(true,true,36,10,60,12);
        g(38,11,'Trwa budowa ');
        case inww of
          1:write('mieszka¤');
          2:write('magazyn¢w');
          3:write('fabryk');
          4:write('l',ap,'dowisk');
        end;
        aktpoz:=3;
        czekaj;
      end;
end {iwestycje};

procedure brfab;
begin
  ramka(true,false,30,3,44,5);
  g(32,4,'BRAK FABRYK');
  czyproo:=false;
  czekaj;
end;

procedure brludz2;
begin
  ramka(true,true,30,2,55,6);
  g(32,3,'Brak ludzi, potrzeba :');
  g(34,4,stringleft(stt(kolfab),8)+'kolonist¢w');
  g(34,5,stringleft(stt(naufab),8)+'naukowc¢w');
  aktpoz:=4;
  gdziey:=2;
  czekaj;
end;

procedure produkcja;
begin
  if fabb<1 then brfab else
  begin
    if czyproo=false then
      begin
        kolfab:=(fabb * 20);
        naufab:=(fabb * 3);
        if kolfab>koll then
          begin
            brludz2;
            czyproo:=false;
            exit;
          end;
        if naufab>nauu then
          begin
            brludz2;
            czyproo:=false;
            exit;
          end;
        gotoxy(25,4);write('ÉÍÍ');
        kolor2;
        write(' PRODUKCJA ');
        kolor1;
        write('ÍÍ»');
        gotoxy(25,5);write('º  roboty bx-1  º');
        gotoxy(25,6);write('º  roboty bx-2  º');
        gotoxy(25,7);write('º  generatory   º');
        gotoxy(25,8);write('º  roboty bb-1  º');
        gotoxy(25,9);write('º  X-wingi      º');
        gotoxy(25,10);write('È',q5,q5,'ÍÍÍÍÍ¼');
        wybor(26,5,9,5,20,20,24);
        if gdziey=5 then proo:=1;
        if gdziey=6 then proo:=2;
        if gdziey=7 then proo:=3;
        if gdziey=8 then proo:=4;
        if gdziey=9 then proo:=5;
        gotoxy(40,5);write('ÉÍ',q5,q5,q5,'Í»');
        gotoxy(40,6);write('º Dane :          º');
        gotoxy(40,7);write('º robot bx-1      º');
        gotoxy(40,8);write('º si',lp,'a rob. 2     º');
        gotoxy(40,9);write('º seria - 10 szt. º');
        gotoxy(40,10);write('º cena sr.-1000   º');
        gotoxy(40,11);write('º Ile serii:      º');
        gotoxy(40,12);write('º    SUROWCE      º');
        gotoxy(40,13);write('º Krzem  :        º');
        gotoxy(40,14);write('º ',dzp,'elazo :        º');
        gotoxy(40,15);write('º Uran   :        º');
        gotoxy(40,16);write('º   Pob¢r mocy    º');
        gotoxy(40,17);write('º                 º');
        gotoxy(40,18);write('º Czas produkcji  º');
        gotoxy(40,19);write('º                 º');
        gotoxy(40,20);write('ÈÍÍ',q5,q5,q5,'¼');
        if proo=3 then
        begin
          gotoxy(42,7);write('generator   ');
          gotoxy(42,8);write('moc - 30 Kw   ');
          gotoxy(50,9);write('1 szt. ');
          gotoxy(51,10);write('5000');
        end;
        if proo=2 then
        begin
          gotoxy(48,7);write('bx-2');
          gotoxy(51,8);write(' 5');
          gotoxy(50,9);write('5 szt. ');
          gotoxy(51,10);write('1550');
        end;
        if proo=4 then
        begin
          gotoxy(48,7);write('bb-1');
          gotoxy(46,8);write(' boj. 5');
          gotoxy(50,9);write('5 szt. ');
          gotoxy(51,10);write('1800');
        end;
        if proo=5 then begin
          gotoxy(48,7);write('X-wing');
          gotoxy(46,8);write(' boj. 5');
          gotoxy(50,9);write('5 szt. ');
          gotoxy(51,10);write('1800');
        end;
        ruch2(53,11,1,999,3,100);
        ilproo:=ile;
        mocpro:=fabb*20;
        if proo=1 then
          begin
            krzpro:=ilproo*10;
            zelpro:=ilproo*4;
            urapro:=ilproo;
            pczaspro:=ppczaspro(1);
          end;
        if proo=2 then
          begin
            krzpro:=ilproo*15;
            zelpro:=ilproo*10;
            urapro:=ilproo*2;
            pczaspro:=ppczaspro(2);
          end;
        if proo=3 then
          begin
            krzpro:=ilproo*50;
            zelpro:=ilproo*40;
            urapro:=ilproo*10;
            pczaspro:=ppczaspro(3);
          end;
        if proo=4 then
          begin
            krzpro:=ilproo*12;
            zelpro:=ilproo*10;
            urapro:=ilproo*3;
            pczaspro:=ppczaspro(4);
          end;
        if proo=5 then
          begin
            krzpro:=ilproo*10;
            zelpro:=ilproo*30;
            urapro:=ilproo*6;
            pczaspro:=ppczaspro(5);
          end;
        gotoxy(51,13);write(krzpro:5,'t');
        gotoxy(51,14);write(zelpro:5,'t');
        gotoxy(51,15);write(urapro:5,'t');
        g(41,17,stringcenter(stt(mocpro)+' Kw',16));
        g(41,19,stringcenter(stt(pczaspro)+' ms.',16));
        ramka(true,true,60,10,72,14);
        gotoxy(63,11);write('Start');
        gotoxy(63,12);write('Powr¢t');
        gotoxy(63,13);write('Wyj'+sp+'cie');
        wybor(61,11,13,11,17,17,19);
        gdziey:=wherey;
        if gdziey=11 then
          begin
            czyprodukcja;
            if czyproo=true then
              begin
                czaspro[v]:=1;
                gotoxy(30,1);write('É',q5,q5,q5,'ÍÍÍÍÍÍÍ»');
                gotoxy(30,2);write('º Produkcja rozpocz',ep,'ta º');
                gotoxy(30,3);write('È',q5,q5,q5,'ÍÍÍÍÍÍÍ¼');
                krzz:=krzz-krzpro;
                zell:=zell-zelpro;
                uraa:=uraa-urapro;
                czekaj;
              end;
          end;
        if gdziey=12 then
          begin
            czyproo:=false;
            produkcja;
          end;
        if gdziey=13 then czyproo:=false;
      end
    else
      begin
        gotoxy(41,10);write('É',q5,q5,q5,q5,q5,'ÍÍÍ»');
        gotoxy(41,11);write('º Trwa produkcja             º');
        gotoxy(41,12);write('È',q5,q5,q5,q5,q5,'ÍÍÍ¼');
        gotoxy(58,11);
        case proo of
          1 : write('Bx-1');
          2 : write('Bx-2');
          3 : write('generator¢w');
          4 : write('Bb-1');
          5 : write('X-wing¢w')
        end;
        czekaj;
      end;
  end;
  aktpoz:=4;
  gdziey:=2;
end {produkcja};

procedure wyswyp;
begin
  if ((koll<1)or(nauu<1)) then
   begin
     brludz;
     czekaj;
     exit;
   end;
  czywypp:=true;
  ramka(true,true,45,10,66,17);
  g(48,11,'Ilu kolonist¢w :');
  ile:=500;pomoc:=100;
  if koll<100 then pomoc:=10;
  if koll<10 then pomoc:=1;
  if koll<500 then ile:=koll;
  ruch2(55,12,1,ile,3,pomoc);
  kolwypp:=ile;
  gotoxy(55,12);
  write(ile,'  ');
  ile:=500;pomoc:=100;
  if nauu<100 then pomoc:=10;
  if nauu<10 then pomoc:=1;
  if nauu<500 then ile:=nauu;
  g(48,13,'Ilu naukowc¢w :');
  ruch2(55,14,1,ile,3,pomoc);
  nauwypp:=ile;
  gotoxy(55,14);
  write(ile,'  ');
  g(48,15,'Czas wyprawy :');
  ruch2(55,16,1,24,2,10);
  czastrwwypp:=ile;
  czaswypp:=ile;
  write(' ms');
  ramka(true,true,33,12,51,14);
  g(35,13,'Wyprawa wys'+lp+'ana');
  koll:=koll-kolwypp;
  nauu:=nauu-nauwypp;
  czekaj;
end {wyswyp};

procedure wyprawy;
begin
  if czywypp=true then
    begin
      ramka(true,true,28,10,53,12);
      g(30,11,'Wyprawa wr¢ci za ');write(czastrwwypp,' ms');
      aktpoz:=5;
      czekaj;
      exit;
    end
  else
    begin
      ramka(true,true,31,5,54,11);
      gotoxy(38,5);
      kolor2;
      write(' WYPRAWY ');
      kolor1;
      g(33,6,'Wyspa zbadana w ');write(proczbadd,'%');
      g(35,8,'Wys');write(lp,'a',cp,' wypraw',ep,' ?');
      g(41,10,'NIE');
            if proczbadd>=100 then
        begin
          ramka(false,true,32,8,53,10);
          czywypp:=false;
          g(33,9,' Ca'+lp+'a wyspa zbadana ');
          gdziey:=2;
        end
      else wybor(40,9,10,9,30,30,31);
      if gdziey=9 then wyswyp else czywypp:=false;
    end;
    gdziey:=20;
    aktpoz:=5;
    czekaj;
end {wyprawy};

procedure zbiory;
begin
  if ((koll<1) and (koluprr<1)) then
  begin
    brludz;
    czekaj;
    aktpoz:=6;
    exit;
  end;
  ramka(true,true,40,7,60,14);
  kolor2;
  g(46,7,' UPRAWY ');
  kolor1;
  g(44,8,'Pora zasiew¢w');
  g(46,9,'Ilu ludzi');
  g(45,10,'Baza    Pola');
  g(42,12,'Uprawy :');
  g(42,13,'Koszt  :');
  ruch4(koll,7,43,koluprr,3,53,11,500,false);
  koll:=pomoc;
  koluprr:=pomoc2;
  aktpoz:=6;
  gotoxy(51,12);
  write(koluprr*5);
  gotoxy(51,13);
  write(koluprr*50);
  gott:=gott-(koluprr*50);
  if ((czym)and(joy2)) then delay(150);
  czekaj;
end; {zbiory}

procedure uprawy;
begin
  if (mies=1)or(mies=7) then zbiory else
    begin
      if ((mies=6)or(mies=12)) then ramka(true,true,34,7,58,9) else ramka(true,true,34,7,59,9);
      g(37,8,'Zbiory za ');
      case mies of
        2..6:pomoc:=7-mies;
        8..12:pomoc:=13-mies;
      end;
      case pomoc of
        1:pomoc_s:=' miesi'+ap+'c';
        2..4:pomoc_s:=' miesi'+ap+'ce';
        5,6:pomoc_s:=' miesi'+ep+'cy';
      end;
      write(pomoc,pomoc_s);
    end;
  aktpoz:=6;
  czekaj;
end; {uprawy}

procedure magazyny;
begin
  gotoxy(19,13); write('É',q5);kolor2;write(' MAGAZYNY ');kolor1;write(q5,'»');
  gotoxy(19,14);write('º pojemno',sp,cp,':       t º');
  gotoxy(19,15);write('º Krzem  :         t º');
  gotoxy(19,16);write('º ',dzp,'elazo :         t º');
  gotoxy(19,17);write('º Uran   :         t º');
  gotoxy(19,18);write('º ',dzp,'ywno',sp,cp,':         t º');
  gotoxy(19,19);write('º     u',zp,'ywane     %  º');
  gotoxy(19,20);write('È',q5,q5,q5,q5,'¼');
  magraz:=magg*500;
  tow:=(krzz+zell+uraa+zyww);
  proc:=magraz div 100;
  procuzyw:=(tow div proc);
  gotoxy(31,14);write(magraz:7);
  gotoxy(33,19);write(procuzyw:3);
  gotoxy(29,15);write(krzz:9);
  gotoxy(29,16);write(zell:9);
  gotoxy(29,17);write(uraa:9);
  gotoxy(29,18);write(zyww:9);
  aktpoz:=7;
  czekaj;
end; {Magazyny}

procedure zaloga;
begin
  ramka(true,true,30,9,54,18);
  kolor2;
  g(38,9,' ZA'+dlp+'OGA ');
  kolor1;
  g(32,10,'roboty bx-1 : ');write(bx11:6);
  g(32,11,'roboty bx-2 : ');write(bx22:6);
  g(32,12,'koloni'+sp+'ci   : ');write(koll+koluprr+kolwypp:6);
  g(32,13,'naukowcy    : ');write(nauu+nauwypp:6);
  g(32,14,zp+'o'+lp+'nierze   : ');write(zoll:6);
  g(32,16,'mieszka¤ : ');write(miee*50:6);
  g(32,17,'zaj'+ep+'te   : ');write(koll+nauu+zoll:6);
  ramka(true,true,50,15,70,19);
  g(57,16,'W bazie');
  g(52,17,'koloni'+sp+'ci : ');write(koll:5);
  g(52,18,'naukowcy  : ');write(nauu:5);
  g(50,18,'¹');
  g(54,15,'Ê');
  aktpoz:=8;
  gdziey:=222;
  czekaj;
end; {zaloga}

procedure nakogo;

  procedure atakn;
  begin
    ramka(true,false,45,13,63,15);
    g(47,14,'ATAK NIEMO'+dzp+'LIWY');
  end;
  procedure atakt(im:string);
  var tekst:string;
  begin
    ramka(true,true,28,13,75,15);
    g(30,14,stringcenter('Gracz '+im+' zostanie zaatakowany',44));
  end;

begin
  ramka(true,true,52,12,72,14+ilgr);
  g(58,13,'Na kogo ?');
  for i:=2 to ilgr do g(53,13+i,t[31+i]);
  wybor(53,14,13+ilgr,14,32,32,31+ilgr);
  if gdziey=13+v then
  begin
    atakn;
    exit
  end;
  if silboj=0 then
  begin
    atakn;
    exit
  end;
  dec(gdziey,13);
  if czyatak[gdziey].czy=true then
    begin
      atakn;
      exit
    end
  else
    begin
      czyatak[gdziey].czy:=true;
      czyatak[gdziey].kto:=v;
      atakt(imgr[gdziey])
    end;
end; {nakogo}

procedure wojsko;
begin
  ramka(true,true,27,10,50,15);
  kolor2;
  g(35,10,' WOJSKO ');
  kolor1;
  g(29,11,dzp+'o'+lp+'nierze   : ');write(zoll:6);
  g(29,12,'roboty bb-1 : ');write(bb11:6);
  g(29,13,'X-wingi     : ');write(xwii:6);
  g(29,14,'Si'+lp+'a bojowa : ');write(silboj:6);
  if ilgr>1 then if ((mies<>1) or (rok<>2090)) then
  begin
    ramka(true,true,49,14,59,18);
    g(52,15,'Atak?');
    g(53,17,'NIE');
    wybor(52,16,17,16,30,30,31);
    if gdziey=16 then nakogo;
  end;
  aktpoz:=9;
  gdziey:=1;
  czekaj;
end; {wojsko}

procedure budynki;
begin
  ramka(true,true,49,5,71,10);
  kolor2;
  g(56,5,' BUDYNKI ');
  kolor1;
  g(51,6,'mieszkania : ');write(miee*50:6);
  g(51,7,'magazyny   : ');write(magg*500:6);
  g(51,8,'fabryki    : ');write(fabb:6);
  g(51,9,'l'+ap+'dowiska  : ');write(ladd:6);
  gotoxy(17,10);
  aktpoz:=10;
  gdziey:=2;
  czekaj;
end;

procedure generator;
begin
  if czyproo then mocfab:=fabb*20 else mocfab:=0;
  MocInwestycji;
  pobmoc:=(mocfab+mocinw+((krzwydd+zelwydd+urawydd) div 10));
  moc:=genn*30;
  zuzura:=pobmoc div 5;
  gotoxy(40,14);write('É',q5);kolor2;write(' GENERATOR ');kolor1;write(q5,'»');
  gotoxy(40,15);write('º moc   :             º');
  gotoxy(40,16);write('º pob¢r :             º');
  gotoxy(40,17);write('º   zu'+zp+'ycie uranu     º');
  gotoxy(40,18);write('º                     º');
  gotoxy(40,19);write('È',q5,q5,q5,q5,'Í¼');
  gotoxy(50,15);write(moc);
  gotoxy(50,16);write(pobmoc);
  gotoxy(46,18);write(zuzura,' t/ms');
  aktpoz:=11;
  gdziey:=2;
  czekaj;
end {generator};

procedure zmienw_p_p(x:byte);
begin
  case x of
    1 : pomoc_s:='  Krzem    '+sttr(krzkopp,8)+sttr(krzwydd,9)+'   ';
    2 : pomoc_s:='  '+dZp+'elazo   '+sttr(zelkopp,8)+sttr(zelwydd,9)+'   ';
    3 : pomoc_s:='  Uran     '+sttr(urakopp,8)+sttr(urawydd,9)+'   ';
  end;
end;

procedure zmienw_p(x,xx:byte);
begin
  kolor1;
  pomoc_s:='';
  zmienw_p_p(xx);
  g(41,7+xx,pomoc_s);
  zmienw_p_p(x);
  kolor2;
  g(41,7+x,pomoc_s);
end;


procedure wydobycie;
var
  koniec           : boolean;
  rodzaj,oldrodzaj : byte;
  l1,l2            : longint;
begin
  ramka(true,true,40,6,72,12);
  kolor2;
  g(50,6,' WYDOBYCIE ');
  kolor1;
  g(55,7,'Z'+lp+'o'+zp+'a    Pob¢r');
  g(42,11,'Wolna pow. magazynowa:');
  write((magg*500)-krzz-zell-uraa-zyww:7);
  zmienw_p_p(2);
  g(41,9,pomoc_s);
  zmienw_p_p(3);
  g(41,10,pomoc_s);
  rodzaj:=1;
  oldrodzaj:=0;
  koniec:=false;
  repeat
    zmienw_p(rodzaj,oldrodzaj);
    case rodzaj of
      1 : begin
            l1:=krzkopp;
            l2:=krzwydd;
            gdziey:=8;
          end;
      2 : begin
            l1:=zelkopp;
            l2:=zelwydd;
            gdziey:=9;
          end;
      3 : begin
            l1:=urakopp;
            l2:=urawydd;
            gdziey:=10;
          end;
    end;
    ruch4(l1,9,51,l2,9,60,gdziey,0,true);
    case rodzaj of
      1 : begin
            krzkopp:=pomoc;
            krzwydd:=pomoc2;
          end;
      2 : begin
            zelkopp:=pomoc;
            zelwydd:=pomoc2;
          end;
      3 : begin
            urakopp:=pomoc;
            urawydd:=pomoc2;
          end;
    end;
    oldrodzaj:=rodzaj;
    case z of
      up     : dec(rodzaj);
      down   : inc(rodzaj);
      enter  : koniec:=true;
      pgup   : rodzaj:=1;
      pgdown : rodzaj:=3;
    end;
    if rodzaj<1 then rodzaj:=3;
    if rodzaj>3 then rodzaj:=1;
  until koniec;
  kolor1;
  aktpoz:=12;
  gdziey:=2;
end;


procedure handel_of;
begin
  ramka(true,true,17,3,56,5);
  g(18,4,stringcenter('Wyl'+ap+'dowa'+lp+' statek typu VARG-'+stt(nr_st),38));
  ramka(true,true,30,6,43,11);
  kolor2;
  g(33,6,' OFERTA ');
  kolor1;
  for i:=1 to 4 do g(31,6+i,t[36+i]);
end; {handel_of}

procedure zmien_p(x:byte);
begin
  case x of
    1 : pomoc_s:='  Krzem    '+sttr(krzz,10)+sttr(krzst,10)+'   '+sttr(cenakrz,3)+' ';
    2 : pomoc_s:='  '+dZp+'elazo   '+sttr(zell,10)+sttr(zelst,10)+'   '+sttr(cenazel,3)+' ';
    3 : pomoc_s:='  Uran     '+sttr(uraa,10)+sttr(urast,10)+'   '+sttr(cenaura,3)+' ';
    4 : pomoc_s:='  '+dZp+'ywno'+sp+cp+'  '+sttr(zyww,10)+sttr(zywst,10)+'   '+sttr(cenazyw,3)+' ';
  end;
end;

procedure zmien(x,xx:byte);
begin
  kolor1;
  pomoc_s:='';
  zmien_p(xx);
  g(39,5+xx,pomoc_s);
  zmien_p(x);
  kolor2;
  g(39,5+x,pomoc_s);
end; {zmien}

procedure handel_sur;
var
  koniec           : boolean;
  l1,l2,cena       : longint;
  rodzaj,oldrodzaj : byte;
begin
  ramka(true,true,38,4,77,12);
  kolor2;
  g(52,4,' SUROWCE ');
  kolor1;
  g(54,5,'Baza     Statek   Cena');
  g(40,10,'Magazyny -');
  g(51,10,'wykorzystanie :');
  g(55,11,'pojemno'+sp+cp+' :');
  for i:=2 to 4 do
    begin
      zmien_p(i);
      g(39,5+i,pomoc_s);
    end;
  koniec:=false;
  rodzaj:=1;
  oldrodzaj:=0;
  repeat
    zmien(rodzaj,oldrodzaj);
    case rodzaj of
      1 : begin
            l1:=krzz;
            l2:=krzst;
            gdziey:=6;
            cena:=cenakrz;
          end;
      2 : begin
            l1:=zell;
            l2:=zelst;
            gdziey:=7;
            cena:=cenazel;
          end;
      3 : begin
            l1:=uraa;
            l2:=urast;
            gdziey:=8;
            cena:=cenaura;
          end;
      4 : begin
            l1:=zyww;
            l2:=zywst;
            gdziey:=9;
            cena:=cenazyw;
          end;
    end;
    ruch3(l1,10,50,l2,10,60,gdziey,1,cena,true);
    case rodzaj of
      1 : begin
            krzz:=pomoc;
            krzst:=pomoc2;
          end;
      2 : begin
            zell:=pomoc;
            zelst:=pomoc2;
          end;
      3 : begin
            uraa:=pomoc;
            urast:=pomoc2;
          end;
      4 : begin
            zyww:=pomoc;
            zywst:=pomoc2;
          end;
    end;
    oldrodzaj:=rodzaj;
    case z of
      up     : dec(rodzaj);
      down   : inc(rodzaj);
      enter  : koniec:=true;
      pgup   : rodzaj:=1;
      pgdown : rodzaj:=4;
    end;
    if rodzaj<1 then rodzaj:=4;
    if rodzaj>4 then rodzaj:=1;
  until koniec;
  kolor1;
  aktpoz:=7;
  gdziey:=2;
end; {handel_sur}

procedure zmien_m_p(x:byte);
begin
  case x of
    1 : pomoc_s:='  roboty Bx-1'+sttr(bx11,10)+sttr(bx1st,10)+sttr(cenabx1,5)+' ';
    2 : pomoc_s:='  roboty Bx-2'+sttr(bx22,10)+sttr(bx2st,10)+sttr(cenabx2,5)+' ';
    3 : pomoc_s:='  generatory '+sttr(genn,10)+sttr(genst,10)+sttr(cenagen,5)+' ';
    4 : pomoc_s:='  roboty Bb-1'+sttr(bb11,10)+sttr(bb1st,10)+sttr(cenabb1,5)+' ';
    5 : pomoc_s:='  X-wingi    '+sttr(xwii,10)+sttr(xwist,10)+sttr(cenaxwi,5)+' ';
  end;
end;

procedure zmien_m(x,xx:byte);
begin
  kolor1;
  pomoc_s:='';
  zmien_m_p(xx);
  g(37,7+xx,pomoc_s);
  zmien_m_p(x);
  kolor2;
  g(37,7+x,pomoc_s);
end; {zmien}

procedure handel_masz;
var
  koniec           : boolean;
  l1,l2,cena       : longint;
  rodzaj,oldrodzaj : byte;
begin
  ramka(true,true,36,6,76,13);
  kolor2;
  g(52,6,' MASZYNY ');
  kolor1;
  g(53,7,'Baza     Statek   Cena');
  for i:=2 to 5 do
    begin
      zmien_m_p(i);
      g(37,7+i,pomoc_s);
    end;
  koniec:=false;
  rodzaj:=1;
  oldrodzaj:=0;
  repeat
    zmien_m(rodzaj,oldrodzaj);
    case rodzaj of
      1 : begin
            l1:=bx11;
            l2:=bx1st;
            gdziey:=8;
            cena:=cenabx1;
          end;
      2 : begin
            l1:=bx22;
            l2:=bx2st;
            gdziey:=9;
            cena:=cenabx2;
          end;
      3 : begin
            l1:=genn;
            l2:=genst;
            gdziey:=10;
            cena:=cenagen;
          end;
      4 : begin
            l1:=bb11;
            l2:=bb1st;
            gdziey:=11;
            cena:=cenabb1;
          end;
      5 : begin
            l1:=xwii;
            l2:=xwist;
            gdziey:=12;
            cena:=cenaxwi;
          end;
    end;
    ruch3(l1,10,50,l2,10,60,gdziey,0,cena,true);
    case rodzaj of
      1 : begin
            bx11:=pomoc;
            bx1st:=pomoc2;
          end;
      2 : begin
            bx22:=pomoc;
            bx2st:=pomoc2;
          end;
      3 : begin
            genn:=pomoc;
            genst:=pomoc2;
          end;
      4 : begin
            bb11:=pomoc;
            bb1st:=pomoc2;
          end;
      5 : begin
            xwii:=pomoc;
            xwist:=pomoc2;
          end;
    end;
    oldrodzaj:=rodzaj;
    case z of
      up     : dec(rodzaj);
      down   : inc(rodzaj);
      enter  : koniec:=true;
      pgup   : rodzaj:=1;
      pgdown : rodzaj:=5;
    end;
    if rodzaj<1 then rodzaj:=5;
    if rodzaj>5 then rodzaj:=1;
  until koniec;
  kolor1;
  aktpoz:=8;
  gdziey:=2;
end; {handel_masz}

procedure zmien_l_p(x:byte);
begin
  case x of
    1 : pomoc_s:='  Koloni'+sp+'ci '+sttr(koll,8)+sttr(kolst,9)+'  ';
    2 : pomoc_s:='  Naukowcy  '+sttr(nauu,8)+sttr(naust,9)+'  ';
    3 : pomoc_s:='  '+dZp+'o'+lp+'nierze '+sttr(zoll,8)+sttr(zolst,9)+'  ';
  end;
end;

procedure zmien_l(x,xx:byte);
begin
  kolor1;
  pomoc_s:='';
  zmien_l_p(xx);
  g(43,11+xx,pomoc_s);
  pomoc_s:='';
  zmien_l_p(x);
  kolor2;
  g(43,11+x,pomoc_s);
end; {zmien_l}

procedure handel_lud;
var
  koniec           : boolean;
  l1,l2,ilosc      : longint;
  rodzaj,oldrodzaj : byte;
begin
  ilosc:=koll+nauu+zoll;
  ramka(true,true,42,10,74,18);
  kolor2;
  g(55,10,' LUDZIE ');
  kolor1;
  g(58,11,'Baza   Statek');
  g(53,15,'Razem :');
  g(44,16,'Ilo'+sp+cp+' mieszka¤ :');
  g(47,17,'Koszt jednego biletu 25!');
  zmien_l_p(2);
  g(43,13,pomoc_s);
  zmien_l_p(3);
  g(43,14,pomoc_s);
  koniec:=false;
  rodzaj:=1;
  oldrodzaj:=0;
  repeat
    zmien_l(rodzaj,oldrodzaj);
    case rodzaj of
      1 : begin
            l1:=koll;
            l2:=kolst;
            gdziey:=12;
          end;
      2 : begin
            l1:=nauu;
            l2:=naust;
            gdziey:=13;
          end;
      3 : begin
            l1:=zoll;
            l2:=zolst;
            gdziey:=14;
          end;
    end;
    ruch3(l1,9,54,l2,9,63,gdziey,2,0,true);
    case rodzaj of
      1 : begin
            koll:=pomoc;
            kolst:=pomoc2;
          end;
      2 : begin
            nauu:=pomoc;
            naust:=pomoc2;
          end;
      3 : begin
            zoll:=pomoc;
            zolst:=pomoc2;
          end;
    end;
    oldrodzaj:=rodzaj;
    case z of
      up     : dec(rodzaj);
      down   : inc(rodzaj);
      enter  : koniec:=true;
      pgup   : rodzaj:=1;
      pgdown : rodzaj:=3;
    end;
    if rodzaj<1 then rodzaj:=3;
    if rodzaj>3 then rodzaj:=1;
  until koniec;
  kolor1;
  gott:=gott-(((koll+nauu+zoll)-ilosc)*25);
  gotoxy(58,23);
  write(gott:20:0);
  ramka(true,true,40,7,79,9);
  g(41,8,Stringcenter('Za bilety zap'+lp+'aci'+lp+'e'+sp+' '+stt(((koll+nauu+zoll)-ilosc)*25),38));
  czekaj;
  aktpoz:=9;
  gdziey:=2;
end; {handel_sur}

procedure handel;
begin
  if czy_st then
  begin
    aktpoz:=7;
    pomoc_b:=false;
    repeat
      handel_of;
      wybor(31,7,10,aktpoz,30+aktpoz,37,40);
      case gdziey of
        7  : handel_sur;
        8  : handel_masz;
        9  : handel_lud;
        10 : begin
               aktpoz:=13;
               gdziey:=2;
               pomoc_b:=true;
             end;
      end;
    until pomoc_b;
  end else
  begin
    ramka(true,true,30,10,46,12);
    g(32,11,'NIE MA STATKU');
    czekaj;
  end;
  aktpoz:=13;
  gdziey:=2;
end;

procedure cozrobic;
begin
  if z=f1 then
    begin
      help;
      gdziey:=2
    end;
  if z=f2 then konfiguracja;
  if ((z=f1) or (z=f2)) then exit;
  case gdziey of
    3  : inwestycje;
    4  : produkcja;
    5  : wyprawy;
    6  : uprawy;
    7  : magazyny;
    8  : zaloga;
    9  : wojsko;
    10 : budynki;
    11 : generator;
    12 : wydobycie;
    13 : handel;
    14 : begin
           ramka(true,true,30,10,42,16);
           for i:=11 to 15 do g(31,i,t[i+14]);
           wybor(31,11,15,11,25,25,29);
           if gdziey=11 then kongr:=true;
           if gdziey=12 then aktpoz:=14;
           if gdziey=12 then exit;
           if gdziey=13 then zapis;
           if gdziey=14 then if Na_Pewno(1) then restart:=true;
           if gdziey=15 then if Na_Pewno(2) then koniec_gry:=true;
         end;
  end;
  if zamykanie then clrscr;
end {cozrobic};

procedure kkoniec;
begin
end;

procedure trzziemi;
begin
  wwrite(' Trz'+ep+'sienie ziemi zniszczy'+lp+'o 10% twoich kopalni !',true);
  krzkopp:=(krzkopp-(krzkopp div 10));
  urakopp:=(urakopp-(urakopp div 10));
  zelkopp:=(zelkopp-(zelkopp div 10));
  czekaj;
end;

procedure best;
var il : byte;
begin
  il:=((random(3))*10);
  wwrite(' Bestie zniszczy'+lp+'y '+stt(il)+'% upraw !',true);
  koluprr:=koluprr-((koluprr*il) div 100);
  czekaj;
end;

procedure imper;
begin
  gott:=gott+100000000;
  wwrite(' Za namow'+ap+' g'+lp+'¢wnego ksi'+ep+'gowego WIELKI IMPERATOR przysy'+lp+'a Ci 100.000.000 !',true);
  czekaj;
end;

procedure napad;
var strat : array[1..6] of longint;
var dalej : boolean;
str17     : string[17];
begin
  wwrite('         Napad obcych X-wing¢w',true);
  wwrite('',true);
  i:=1000;
  dalej:=true;
  if silboj>i then
    begin
      wwrite('     ATAK ODPARTY',true);
      strat[1]:=random(zoll div 20);
      strat[2]:=random(bb11 div 20);
      strat[3]:=random(xwii div 20);
      strat[4]:=0;
      strat[5]:=0;
      strat[6]:=0;
      dalej:=false;
    end;
  if dalej then if silboj+100>i then
    begin
      wwrite('     MAGAZYNY NIETKNI'+dep+'TE',true);
      strat[1]:=random(zoll div 10);
      strat[2]:=random(bb11 div 10);
      strat[3]:=random(xwii div 10);
      strat[4]:=0;
      strat[5]:=0;
      strat[6]:=0;
      dalej:=false;
    end;
  if dalej then
    begin
      wwrite('     Zrabowano z magazyn¢w :',true);
      strat[1]:=random(zoll div 5);
      strat[2]:=random(bb11 div 5);
      strat[3]:=random(xwii div 5);
      strat[4]:=random(krzz div 10);
      strat[5]:=random(zell div 10);
      strat[6]:=random(uraa div 10);
    end;
  zoll:=zoll-strat[1];
  bb11:=bb11-strat[2];
  xwii:=xwii-strat[3];
  krzz:=krzz-strat[4];
  uraa:=uraa-strat[5];
  zell:=zell-strat[6];
  if dalej then
    begin
      wwrite('     Krzem  :'+sttr(strat[4],6)+'t',true);
      wwrite('     Uran   :'+sttr(strat[5],6)+'t',true);
      wwrite('     '+dzp+'elazo :'+sttr(strat[6],6)+'t',true);
    end;
  wwrite('   Straty :',true);
  wwrite('                    '+t[31+v],true);
  str(strat[1],str17);
  wwrite('     '+dzp+'o'+lp+'nierze           '+stringcenter(str17,17),true);
  str(strat[2],str17);
  wwrite('     Bb-1                '+stringcenter(str17,17),true);
  str(strat[3],str17);
  wwrite('     X-wingi             '+stringcenter(str17,17),true);
end; {napad}

procedure grem;
begin
  genn:=genn div 2;
  wwrite(' UWAGA !!! Zaatakowa'+lp+'y Ci'+ep+' Gremliny !!!',true);
  wwrite(' Zjad'+lp+'y po'+lp+'ow'+ep+' Twoich generator¢w',true);
  czekaj;
end;

procedure wyd(nr:longint);
begin
kbdclear;
wwrite('',true);
if nr<49999 then if nr>=49990 then trzziemi;
if nr<49990 then if nr>=44999 then best;
if nr=39898 then imper;
if nr<39898 then if nr>=39699 then napad;
if nr<39399 then if nr>=39359 then grem;
if nr=1 then imper;
end;

procedure losowanie_statku;
begin
  czy_st:=true;
  pomoc:=random(30)+1;
  case ladd of
    0         : if pomoc>10 then czy_st:=false;
    1..5      : if pomoc>18 then czy_st:=false;
    5..10     : if pomoc>25 then czy_st:=false;
  end;
  if ((rok=2090) and (mies=1)) then czy_st:=true;
  if czy_st then
    begin
      nr_st:=random(20)+(ladd div 2)+random(ladd*5)+((ladd div 2)+(ladd*5));
      if nr_st<ladd div 2 then nr_st:=ladd div 2;
      magraz:=15;
      case nr_st of
        0..20     : magraz:=3;
        21..100   : magraz:=5;
        101..1000 : magraz:=10
      end;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz)+nr_st*magraz;
      if pomoc=21 then krzst:=0
        else if pomoc<=10 then krzst:=-pomoc2
          else krzst:=pomoc2;
      cenakrz:=random(7);
      if krzst<0 then cenakrz:=cenakrz+14 else cenakrz:=cenakrz+10;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz)+nr_st*magraz;
      if pomoc=21 then zelst:=0
        else if pomoc<=10 then zelst:=-pomoc2
          else zelst:=pomoc2;
      cenazel:=random(12);
      if krzst<0 then cenazel:=cenazel+29 else cenazel:=cenazel+20;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz)+nr_st*magraz;
      if pomoc=21 then urast:=0
        else if pomoc<=10 then urast:=-pomoc2
          else urast:=pomoc2;
      cenaura:=random(41);
      if urast<0 then cenaura:=cenaura+90 else cenaura:=cenaura+70;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz)+nr_st*magraz;
      if pomoc=21 then zywst:=0
        else if pomoc<=10 then zywst:=-pomoc2
          else zywst:=pomoc2;
      cenazyw:=random(7);
      if zywst<0 then cenazyw:=cenazyw+19 else cenazyw:=cenazyw+15;

      if ladd<100 then magraz:=1 else magraz:=10;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz*3);
      if pomoc=21 then bx1st:=0
        else if pomoc<=10 then bx1st:=-pomoc2
          else bx1st:=pomoc2;
      cenabx1:=random(350);
      if bx1st<0 then cenabx1:=cenabx1+950 else cenabx1:=cenabx1+700;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz*2);
      if pomoc=21 then bx2st:=0
       else if pomoc<=10 then bx2st:=-pomoc2
         else bx2st:=pomoc2;
      cenabx2:=random(500);
      if bx2st<0 then cenabx2:=cenabx2+1500 else cenabx2:=cenabx2+1100;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz);
      if pomoc=21 then genst:=0
        else if pomoc<=10 then genst:=-pomoc2
          else genst:=pomoc2;
      cenagen:=random(1502);
      if genst<0 then cenagen:=cenagen+5000 else cenagen:=cenagen+3500;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz*2);
      if pomoc=21 then bb1st:=0
        else if pomoc<=10 then bb1st:=-pomoc2
          else bb1st:=pomoc2;
      cenabb1:=random(550);
      if bb1st<0 then cenabb1:=cenabb1+1750 else cenabb1:=cenabb1+1300;

      pomoc:=random(21)+1;
      pomoc2:=random(nr_st*magraz*2);
      if pomoc=21 then xwist:=0
        else if pomoc<=10 then xwist:=-pomoc2
          else xwist:=pomoc2;
      cenaxwi:=random(750);
      if xwist<0 then cenaxwi:=cenaxwi+2500 else cenaxwi:=cenaxwi+1850;

      pomoc:=random(11)+1;
      pomoc2:=(random(nr_st)+(nr_st div 10))*2;
      if pomoc=11 then kolst:=0
        else kolst:=pomoc2;

      pomoc:=random(11)+1;
      pomoc2:=(random(nr_st)+(nr_st div 10)) div 2;
      if pomoc=11 then naust:=0
        else naust:=pomoc2;

      pomoc:=random(11)+1;
      pomoc2:=random(nr_st)+(nr_st div 10) div 2;
      if pomoc=11 then zolst:=0
        else zolst:=pomoc2;

      wwrite(' Wyl'+ap+'dowa'+lp+' statek typu VARG-'+stt(nr_st),true);
      kbdclear;
      czekaj;
    end;
end; {losowanie_statku}

procedure opuszczenie;
begin
  czygr[v]:=false;
  wwrite('',true);
  wwrite('',true);
  wwrite(stringcenter('---  G'+dlp+dop+'D W BAZIE  ---',80),true);
  wwrite('',true);
  wwrite('  G'+lp+'odzi'+lp+'e'+sp+' swoich ludzi, a'+zp+' ich zag'+lp+'odzi'+lp+'e'+sp+' na '+sp+'mier'+cp+' !',true);
  wwrite('  Cz'+ep+sp+cp+' kopn'+ep+lp+'a w kalendarz, cz'+ep+sp+cp+' uciek'+lp+'a, a reszta powiesi'+lp+'a Ci'+ep,true);
  wwrite('  na najbli'+zp+'szym drzewie !',true);
  wwrite('  To ju'+zp+' koniec Twojej gry !',true);
  wwrite('',true);
  wwrite('    Naci'+sp+'nij co'+sp,false);
  kbdclear;
  czekaj;
end; {opuszczenie}

procedure komornik;
begin
  czygr[v]:=false;
  wwrite('',true);
  wwrite('',true);
  wwrite(stringcenter('---  ZBANKRUTOWA'+dlp+'E'+dsp+'  ---',80),true);
  wwrite('',true);
  wwrite('  Tw¢j d'+lp+'ug przekroczy'+lp+' dopuszczalne normy i nie zd'+ap+zp+'y'+lp+'e'+sp+' go sp'+lp+'aci'+cp+' !',true);
  wwrite('  Komornik zarekwirowa'+lp+' Twoj'+ap+' planet'+ep+' jako zastaw na sp'+lp+'at'+ep+' d'+lp+'ug¢w !',true);
  wwrite('  To ju'+zp+' koniec Twoich rz'+ap+'d¢w na tej planecie !',true);
  wwrite('',true);
  wwrite('    Naci'+sp+'nij co'+sp,false);
  kbdclear;
  czekaj;
end; {komornik}

procedure plansza_koncowa;
var max : byte;
begin
  max:=1;
  for i:=2 to ilgr do
    if got[i]>got[max] then max:=i;
  if got[max]<100000000 then max:=0;
  show_big_kursor;
  kolor2;
  clrscr;
  wwrite(stringcenter('Wyl'+ap+'dowa'+lp+' kr'+ap+zp+'ownik typu "ATORA"',76),TRUE);
  wwrite('  Ka'+zp+'dy z gubernator¢w musi wp'+lp+'aci'+cp+' 100.000.000 aby wykupi'+cp+' sw'+ap+' koloni'+ep+'.',true);
  writeln;
  wwrite('  Brak okre'+sp+'lonej sumy jest jednoznaczny z usuni'+ep+'ciem z zajmowanego',true);
  wwrite('  dotychczas stanowiska i konfiskat'+ap+' mienia.',true);
  writeln;
  if max<>0 then
    begin
      wwrite(stringcenter('Gubernator '+imgr[max],76),true);
      writeln;
      wwrite('  zosta'+lp+' wyznaczony przez pe'+lp+'nomocnika Imperatora na namiestnika',true);
      wwrite(stringcenter('na planecie  Vvp-12a.',70),true);
      for i:=1 to 12 do writeln;
    end
  else
    begin
      wwrite('  '+dzp+'aden z gubernator¢w nie zebra'+lp+' 100.000.000 wobec czego',true);
      wwrite('  namiestnikiem planety Vvp-12a zosta'+lp+' Komandor Floty Kosmicznej  M. Puchatek.',true);
      for i:=1 to 13 do writeln;
    end;
  wwrite('     Naci'+sp+'nij jakikolwiek klawisz aby rozpocz'+ap+cp+' gr'+ep+'.',true);
  kbdclear;
  czekaj;
  kill_kursor;
  kolor1;
end; {plansza_koncowa}


procedure plansza;
var
  strat          : array[1..9] of longint;
  wstrzgen,dalej : boolean;
  str15,str152   : string;
  j              : longint;
  kto            : byte;
begin
  kolor2;
  clrscr;
  show_big_kursor;
  wwrite('                      Gubernator '+img,true);
  wwrite('                          '+stt(rok)+'.'+stt(mies)+'.1'+#10,true);
  wstrzgen:=false;
  if czyproo then mocfab:=fabb*20 else mocfab:=0;
  if czyinww then
    case inww of
      1 : mocinw:=ilinww*20;
      2 : mocinw:=ilinww*20;
      3 : mocinw:=ilinww*25;
      4 : mocinw:=ilinww*30;
    end
  else mocinw:=0;
  pobmoc:=(mocfab+mocinw+((krzwydd+zelwydd+urawydd) div 10));
  moc:=genn*30;
  zuzura:=pobmoc div 5;
  if moc<pobmoc then
    begin
      kolor1;
      wwrite(' Generator przeci'+ap+zp+'ony !',true);
      kolor2;
      wstrzgen:=true;
      zuzura:=0;
    end;
  if uraa<zuzura then
    begin
      kolor1;
      wwrite(' Brak paliwa do generatora !',true);
      kolor2;
      wstrzgen:=true;
      zuzura:=0;
    end;
  uraa:=uraa-zuzura;
  wwrite(' Zu'+zp+'ycie uranu '+stt(zuzura)+'t.',true);
  if (krzwydd+zelwydd+urawydd)>0 then if wstrzgen=false then
    begin
      if ((krzwydd+zelwydd+urawydd)+krzz+zell+uraa+zyww)>(magg*500)
        then
          begin
            kolor1;
            wwrite(' Wydobycie wstrzymane ! ',true);
            wwrite(' Brak magazyn¢w !       ',true);
            kolor2;
          end
        else
          begin
            krzz:=krzz+krzwydd;
            zell:=zell+zelwydd;
            uraa:=uraa+urawydd;
            wwrite(' Wydobycie zrealizowane.',true);
          end;
    end;
  if czyinww=true then if wstrzgen=false then
    begin
      inc(czasbud[v]);
      pczasbud:=ppczasbud(inww);
      if czasbud[v]>=pczasbud then
        begin
          wwrite(' Uko¤czono budow'+ep+' ',false);
          case inww of
            1 : begin
                  wwrite('mieszka¤.',true);
                  miee:=miee+ilinww;
                end;
            2 : begin
                  wwrite('magazyn¢w.',true);
                  magg:=magg+ilinww;
                end;
            3 : begin
                  wwrite('fabryk.',true);
                  fabb:=fabb+ilinww;
                end;
            4 : begin
                  wwrite('l'+ap+'dowisk.',true);
                  ladd:=ladd+ilinww;
                end;
          end;
          czyinww:=false;
        end;
    end;
  if czyproo=true then if wstrzgen=false then
    begin
      inc(czaspro[v]);
      pczaspro:=ppczaspro(proo);
      if czaspro[v]>=pczaspro then
        begin
          wwrite(' Uko¤czono produkcj'+ep+' ',false);
          case proo of
            1 : begin
                  ilproo:=ilproo*10;
                  wwrite(stt(ilproo)+' szt. robot¢w Bx-1.',true);
                  bx11:=bx11+ilproo;
                end;
            2 : begin
                  ilproo:=ilproo*5;
                  wwrite(stt(ilproo)+' szt. robot¢w Bx-2.',true);
                  bx22:=bx22+ilproo;
                end;
            3 : begin
                  wwrite(stt(ilproo)+' szt. generator¢w.',true);
                  genn:=genn+ilproo;
                end;
            4 : begin
                  ilproo:=ilproo*5;
                  wwrite(stt(ilproo)+' szt. robot¢w Bb-1.',true);
                  bb11:=bb11+ilproo;
                end;
            5 : begin
                  ilproo:=ilproo*5;
                  wwrite(stt(ilproo)+' szt. X-wing¢w.',true);
                  xwii:=xwii+ilproo;
                end;
          end;
          czyproo:=false;
        end;
    end;
  if czywypp then
    begin
      dec(czastrwwypp);
      if czastrwwypp<1 then
        begin
          wwrite(' Wr¢ci'+lp+'a wyprawa.',true);
          czywypp:=false;
          pomoc:=((kolwypp+(nauwypp div 3)) div 3)+czaswypp;
          if proczbadd+pomoc>100 then pomoc:=100-proczbadd;
          proczbadd:=proczbadd+pomoc;
          wwrite('    Zbadano '+stt(pomoc)+'% wyspy.',true);
          pomoc2:=random(6);
          pomoc_b:=false;
          case pomoc of
            1      : if pomoc2<1 then pomoc_b:=true;
            2      : if pomoc2<2 then pomoc_b:=true;
            3      : if pomoc2<3 then pomoc_b:=true;
            4      : if pomoc2<4 then pomoc_b:=true;
            5..100 : pomoc_b:=true;
          end;
          if pomoc_b then
            begin
              magraz:=random(3);
              procuzyw:=(nauwypp*100);
              if procuzyw>1500 then procuzyw:=1500;
              procuzyw:=procuzyw+random(1500);
              pomoc2:=random(3);
              if proczbadd>25 then
                begin
                  if krzkopp=0 then pomoc2:=0;
                  if zelkopp=0 then pomoc2:=1;
                  if urakopp=0 then pomoc2:=2;
                end;
              wwrite('    Znaleziono z'+lp+'o'+zp+'a ',false);
              case pomoc2 of
                0 : begin
                      wwrite('krzemu ',false);
                      krzkopp:=krzkopp+procuzyw;
                    end;
                1 : begin
                      wwrite(zp+'elaza ',false);
                      zelkopp:=zelkopp+procuzyw;
                    end;
                2 : begin
                      wwrite('uranu ',false);
                      urakopp:=urakopp+procuzyw;
                    end;
              end;
              wwrite('o wydajno'+sp+'ci '+stt(procuzyw)+'t.',true)
            end;
            pomoc:=random(3);
            if pomoc=0 then
              begin
                pomoc2:=(random(71)*kolwypp) div 100;
                procuzyw:=(random(61)*nauwypp) div 100;
                if pomoc2>0 then
                  begin
                    if pomoc2>1 then wwrite('    Zgin'+ep+lp+'o '+stt(pomoc2)+' kolonist¢w.',true)
                    else wwrite('    Zgin'+ap+lp+' 1 kolonista.',true);
                    kolwypp:=kolwypp-pomoc2;
                  end;
                if procuzyw>0 then
                  begin
                    if procuzyw>1 then wwrite('    Zgin'+ep+lp+'o '+stt(procuzyw)+' naukowc¢w.',true)
                    else wwrite('    Zgin'+ap+lp+' 1 naukowiec.',true);
                    nauwypp:=nauwypp-procuzyw;
                  end;
              end;
            if (koll+nauu+zoll+kolwypp)>miee*50 then kolwypp:=((miee*50)-koll-nauu-zoll);
            koll:=koll+kolwypp;
            if (koll+nauu+zoll+nauwypp)>miee*50 then nauwypp:=((miee*50)-koll-nauu-zoll);
            nauu:=nauu+nauwypp;
        end;
    end;
  wwrite(' Pensja dla za'+lp+'ogi : '+stt(pensja)+'.',true);
  if (((mies=1) and (rok<>2090)) or (mies=7)) then
  begin
    pomoc:=koluprr*10;
    pomoc2:=zell+zyww+uraa+krzz;
    if pomoc2>=magg*500 then pomoc:=0 else if (pomoc2+pomoc)>=(magg*500) then pomoc:=((magg*500)-pomoc2);
    wwrite(#13#10' Z p¢l zebrano '+stt(pomoc)+'t '+zp+'ywno'+sp+'ci.'#13#10,true);
    zyww:=zyww+pomoc;
  end;
  zuzzyw:=((koll+nauu) div 5);
  if zuzzyw<1 then zuzzyw:=1;
  if zyww=0 then glod:=true else glod:=false;
  los;
  zyww:=zyww-zuzzyw;
  if zyww<0 then zyww:=0;
  wwrite(' Zu'+zp+'ycie '+zp+'ywno'+sp+'ci : '+stt(zuzzyw)+'t.',true);
  nailzyw:=(zyww div zuzzyw);
  if nailzyw<0 then nailzyw:=0;
  wwrite(' '+dzp+'ywno'+sp+'ci na '+stt(nailzyw)+' miesi',false);
  case nailzyw of
    1     : wwrite(ap+'c.',true);
    2..4  : wwrite(ap+'ce.',true);
    5..19 : wwrite(ep+'cy.',true)
    else
      case (nailzyw mod 10) of
        0,1  : wwrite(ep+'cy.',true);
        2..4 : wwrite(ap+'ce.',true);
        5..9 : wwrite(ep+'cy.',true)
      end
  end;
  if nailzyw<=0 then
    begin
      kolor1;
      wwrite(' G'+dlp+dop+'D W BAZIE ! ',true);
      kolor2;
    end;
  if glod then
    begin
      opuszczenie;
      exit;
    end;
  if nailzyw<=2 then
  begin
    kolor1;
    wwrite(' MINIMUM '+dzp+'YWNO'+dsp+'CI !!! ',true);
    kolor2;
  end;
  if gott<0 then dec(kredytt) else kredytt:=13;
  if gott<0 then
    begin
      if kredytt<5 then kolor1;
      wwrite(' Kredyt na '+stt(kredytt)+' miesi',false);
      case kredytt of
        0       : wwrite(ep+'cy !!!!',true);
        1       : wwrite(ap+'c !!!',true);
        2..4    : wwrite(ap+'ce !!',true);
        5..13   : wwrite(ep+'cy !',true)
      end;
      kolor2;
    end;
  if kredytt<1 then
    begin
      komornik;
      exit;
    end;
  wwrite('    Naci'+sp+'nij co'+sp,false);
  kbdclear;
  czekaj;
  los;
  nrwyd:=random(50000);
  wyd(nrwyd);
  if czyatak[v].czy then
  begin
    wwrite('',true);
    wwrite('            ATAKUJE GUBERNATOR '+imgr[czyatak[v].kto],true);
    wwrite('',true);
    kto:=czyatak[v].kto;
    i:=(zol[kto]+(bb1[kto]*5)+(xwi[kto]*10));
    dalej:=true;
    if silboj>i then
      begin
        if i<>0
          then pomoc:=(silboj div i)
          else pomoc:=0;
        if pomoc<>0 then
          begin
            wwrite('     ATAK ODPARTY',true);
            strat[4]:=(((random(51)+30)*zol[kto]) div 100);
            strat[5]:=(((random(51)+30)*bb1[kto]) div 100);
            strat[6]:=(((random(51)+30)*xwi[kto]) div 100);
            pomoc2:=strat[4]+(strat[5]*5)+(strat[6]*10);
            strat[1]:=((random(31)*(pomoc2 div 2)) div 100);
            strat[2]:=((random(31)*(pomoc2 div 5)) div 100);
            strat[3]:=((random(31)*(pomoc2 div 9)) div 100);
            strat[7]:=0;
            strat[8]:=0;
            strat[9]:=0;
            dalej:=false;
          end
        else
          begin
            wwrite('     ATAK ODPARTY',true);
            for i:=1 to 9 do strat[i]:=0;
            dalej:=false;
          end;
      end;
    if dalej then if silboj+random(100)>i then
      begin
        wwrite('     MAGAZYNY NIETKNI'+dep+'TE',true);
        strat[1]:=((random(36)*zoll) div 100);
        strat[2]:=((random(36)*bb11) div 100);
        strat[3]:=((random(36)*xwii) div 100);
        strat[4]:=((random(36)*zol[kto]) div 100);
        strat[5]:=((random(36)*bb1[kto]) div 100);
        strat[6]:=((random(36)*xwi[kto]) div 100);
        strat[7]:=0;
        strat[8]:=0;
        strat[9]:=0;
        dalej:=false;
      end;
    if dalej then
      begin
        wwrite('     Zrabowano z magazyn¢w :',true);
        if silboj<>0
          then pomoc:=(i div silboj)
          else pomoc:=0;
        if pomoc<>0 then
          begin
            strat[1]:=(((random(61)+20)*zoll) div 100);
            strat[2]:=(((random(61)+20)*bb11) div 100);
            strat[3]:=(((random(61)+20)*xwii) div 100);
            pomoc2:=strat[1]+(strat[2]*5)+(strat[3]*10);
            strat[4]:=((random(41)*(pomoc2 div 3)) div 100);
            strat[5]:=((random(41)*(pomoc2 div 5)) div 100);
            strat[6]:=((random(41)*(pomoc2 div 9)) div 100);
            strat[7]:=((random(51)*krzz) div 100);
            strat[8]:=((random(51)*zell) div 100);
            strat[9]:=((random(51)*uraa) div 100);
          end else
          begin
            for i:=1 to 6 do strat[i]:=0;
            strat[7]:=((random(81)*krzz) div 100);
            strat[8]:=((random(81)*zell) div 100);
            strat[9]:=((random(81)*uraa) div 100);
          end;
      end;
    if strat[1]>zoll then strat[1]:=zoll;
    if strat[2]>bb11 then strat[2]:=bb11;
    if strat[3]>xwii then strat[3]:=xwii;
    if strat[4]>zol[kto] then strat[4]:=zol[kto];
    if strat[5]>bb1[kto] then strat[5]:=bb1[kto];
    if strat[6]>xwi[kto] then strat[6]:=xwi[kto];
    j:=((mag[kto]*500)-zel[kto]-ura[kto]-krz[kto])-zyw[kto];
    if strat[7]>j then
      begin
        strat[7]:=j;
        j:=0;
      end;
    if strat[8]>j then
      begin
        strat[8]:=j;
        j:=0;
      end;
    if strat[9]>j then strat[9]:=j;
    zoll:=zoll-strat[1];
    zol[kto]:=zol[kto]-strat[4];
    bb11:=bb11-strat[2];
    bb1[kto]:=bb1[kto]-strat[5];
    xwii:=xwii-strat[3];
    xwi[kto]:=xwi[kto]-strat[6];
    krzz:=krzz-strat[7];
    krz[kto]:=krz[kto]+strat[7];
    uraa:=uraa-strat[9];
    ura[kto]:=ura[kto]+strat[9];
    zell:=zell-strat[8];
    zel[kto]:=zel[kto]+strat[8];
    if dalej then
      begin
        wwrite('     Krzem  : '+sttr(strat[7],6)+'t',true);
        wwrite('     '+dzp+'elazo : '+sttr(strat[8],6)+'t',true);
        wwrite('     Uran   : '+sttr(strat[9],6)+'t',true);
      end;
    wwrite('   Straty :',true);
    wwrite('                         '+t[31+v]+'          '+t[31+czyatak[v].kto],true);
    str(strat[1],str15);str(strat[4],str152);
    wwrite('     '+dzp+'o'+lp+'nierze           '+stringcenter(str15,17)+'             '+stringcenter(str152,17),true);
    str(strat[2],str15);str(strat[5],str152);
    wwrite('     Bb-1                '+stringcenter(str15,17)+'             '+stringcenter(str152,17),true);
    str(strat[3],str15);str(strat[6],str152);
    wwrite('     X-wingi             '+stringcenter(str15,17)+'             '+stringcenter(str152,17),true);
    czyatak[v].czy:=false;
    kbdclear;
    czekaj;
  end;
  losowanie_statku;
  kill_kursor;
  kolor1;
  clrscr;
end {plansza};

procedure data;
begin
  inc(mies);
  if mies=13 then
    begin
      inc(rok);
      mies:=1;
    end;
end; {data}

procedure gracz(y:byte);
begin
  if koniec_gry then exit;
  if restart then exit;
  if y=1 then data;
  if rok=2100 then if mies=1 then if y=1 then exit;
  kongr:=false;
  koluprr:=kolupr[y];
  zyww:=zyw[y];
  gott:=got[y];
  krzz:=krz[y];
  uraa:=ura[y];
  zell:=zel[y];
  miee:=mie[y];
  magg:=mag[y];
  fabb:=fab[y];
  ladd:=lad[y];
  koll:=kol[y];
  nauu:=nau[y];
  bx11:=bx1[y];
  img:=imgr[y];
  bx22:=bx2[y];
  genn:=gen[y];
  bb11:=bb1[y];
  xwii:=xwi[y];
  inww:=inw[y];
  zoll:=zol[y];
  urakopp:=urakop[y];
  urawydd:=urawyd[y];
  krzwydd:=krzwyd[y];
  krzkopp:=krzkop[y];
  zelwydd:=zelwyd[y];
  zelkopp:=zelkop[y];
  proczbadd:=proczbad[y];
  kolwypp:=kolwyp[y];
  nauwypp:=nauwyp[y];
  czastrwwypp:=czastrwwyp[y];
  czaswypp:=czaswyp[y];
  czyinww:=czyinw[y];
  czyproo:=czypro[y];
  proo:=pro[y];
  ilproo:=ilpro[y];
  czywypp:=czywyp[y];
  ilinww:=ilinw[y];
  czyinww:=czyinw[y];
  kredytt:=kredyt[y];
  pensja:=((koll*10)+(nauu*15));
  gott:=gott-pensja;
  plansza;
  if czygr[y]=false then exit;
  aktpoz:=14;
  repeat;
    tabela;
    cozrobic;
  until ((kongr) or (koniec_gry) or (restart));
  gr(y);
end;


procedure superscroll;
BEGIN
  fillscreen;
  textcolor(lightred);
  scrolltest;
  textbackground(black);
  textcolor(lightgray);
  clrscr;
end {superscroll};

procedure ust_pocz;
var x1,x2,x3,x4:word;
begin
  wszyscy:=false;
  koniec_gry:=false;
  restart:=false;
  czy_sound:=true;
  dzwiek(false);
  licznik:=1;
  poczgr:=1;
  superscroll;
  kolor1;
  gdziey:=14;
  gettime(x1,x2,x3,x4);
  randseed:=2*(x4*x3)-(x2*(x1-x2))-x1+x2+x3+x4;
end;






begin
  wczytaj_config;
  ust_pocz;
  repeat
    kbdclear;
    odczytt;
    if czyod=true then odczyt;
    if czyod=false then odpoczatku;
    ttt;
    kill_kursor;
    repeat;
      if rok<2100 then for v:=poczgr to ilgr do if czygr[v] then gracz(v);
      poczgr:=1;
      i:=0;
      repeat
        inc(i);
        if czygr[i]=false then wszyscy:=true else wszyscy:=false;
      until ((wszyscy=false) or (i=5));
    until ((koniec_gry) or (restart) or (rok>2099) or (wszyscy));
    if rok>2099 then plansza_koncowa;
  until koniec_gry;
  clrscr;
  show_kursor;
end.
