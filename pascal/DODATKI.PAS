{***************}
{ modul:dodatki }
{ Artur  Siupik }
{  (c) 1993 AS  }
{***************}


unit dodatki;

interface

const
  up     = #072;
  down   = #080;
  f1     = #059;
  f2     = #060;
  f10    = #068;
  esc    = #27;
  pgup   = #073;
  pgdown = #081;
  enter  = #13;
  left   = #075;
  right  = #077;
  fp     = #0116;
  fl     = #0115;

procedure g(x,y:byte;t:string);
procedure czysc(x1,y1,x2,y2:byte);
procedure ramka(p,q:boolean;x1,y1,x2,y2:byte);
function stringfill(c:char;l:byte):string;
function stringleft(s:string;l:byte):string;
function stringright(s:string;l:byte):string;
function stringcenter(s:string;l:byte):string;
function num2str(n:real;c,u:byte):string;
procedure linia(czypod,czypoz:boolean;x1,x2,y:byte);
procedure kill_kursor;
procedure show_kursor;
procedure show_big_kursor;
function key:char;
function czy_kolor:boolean;
procedure wwrite(text:string;czyprzen:boolean);
procedure dzwiek(czy:boolean);
procedure wczytaj(filtr:string);
function wybierz(x1:byte;dodatek,filtr:string;ap,cp,ep,sp:char):string;


implementation

uses crt,dos;

type
  str12 = string[12];



var
  a,b,c,d,e,f                 : char;
  i                           : longint;
  czy_sound                   : boolean;
  zbior                       : Array [1..102] of string;
  IloscZbiorow,IloscKatalogow : Byte;


procedure g(x,y:byte;t:string);
begin
  gotoxy(x,y);
  write(t);
end; {g}

procedure czysc(x1,y1,x2,y2:byte);
var wmin,wmax : word;
begin
  wmin:=windmin;
  wmax:=windmax;
  window(x1,y1,x2,y2);
  clrscr;
  window(Succ(Lo(Wmin)),Succ(Hi(Wmin)),Succ(Lo(Wmax)),Succ(Hi(Wmax)));
end {czysc};

procedure ramka(p,q:boolean;x1,y1,x2,y2:byte);
var ile : word;
begin
  if p=true then czysc(x1,y1,x2,y2);
  a:='É';
  b:='»';
  c:='È';
  d:='¼';
  e:='Í';
  f:='º';
  if q=false then begin
    a:='Ú';
    b:='¿';
    c:='À';
    d:='Ù';
    e:='Ä';
    f:='³';
  end;
  asm
    dec x1       { wszystkie wartosci sa zmniejszane o 1 poniewaz }
    dec y1       {   komputer numeruje wiersze i kolumny od 0 a   }
    dec x2       {                 a pascal od 1                  }
    dec y2
    mov ah,02h
    mov bh,0h
    mov dh,y1
    mov dl,x1
    int 10h     { ustaw kursor we wsp¢lrzednych x1,y1 }
    mov ah,02h
    mov dl,a
    int 21h     { wyswietl g¢rny,lewy r¢g ramki }
    mov ah,02h
    mov bh,0h
    mov dh,y1
    mov dl,x2
    int 10h     { ustaw kursor we wsp¢lrzednych x2,y1 }
    mov ah,02h
    mov dl,b
    int 21h     { wyswietl g¢rny,prawy r¢g ramki }
    mov ah,02h
    mov bh,0h
    mov dh,y2
    mov dl,x2
    int 10h     { ustaw kursor we wsp¢lrzednych x2,y2 }
    mov cx,1
    mov ah,0ah
    mov bh,0
    mov al,d
    int 10h     { wyswietl dolny,prawy r¢g ramki }
    mov ah,02h
    mov bh,0h
    mov dh,y2
    mov dl,x1
    int 10h     { ustaw kursor we wsp¢lrzednych x1,y2 }
    mov ah,02h
    mov dl,c
    int 21h     { wyswietl dolny,lewy r¢g ramki }

    mov al,x2
    cbw
    mov cx,ax
    mov al,x1
    cbw
    sub cx,ax
    dec cx
    cmp cx,0
    jbe @zero   { skocz bo bedzie blad gdy cx=0 }
    mov ah,0ah
    mov bh,0
    mov al,e
    int 10h     { wyswietl dolna poprzeczke }
    mov ah,02h
    mov bh,0h
    mov dh,y1
    mov dl,x1
    inc dl
    int 10h     { ustaw kursor we wsp¢lrzednych x1+1,y1 }
    mov al,x2
    cbw
    mov cx,ax
    mov al,x1
    cbw
    sub cx,ax
    dec cx
    cmp cx,0
    jbe @zero   { skocz bo bedzie blad gdy cx=0 }
    mov ah,0ah
    mov bh,0
    mov al,e
    int 10h     { wyswietl gorna poprzeczke }
  @zero:
    mov al,y2
    cbw
    mov cx,ax
    mov al,y1
    cbw
    inc ax          
    sub cx,ax
    cmp cx,0
    jbe @koniec
  @start:
    inc y1
    mov ah,02h
    mov bh,0h
    mov dh,y1
    mov dl,x1
    int 10h
    mov ah,02h
    mov dl,f
    int 21h     { lewy slupek }
    mov ah,02h
    mov bh,0h
    mov dh,y1
    mov dl,x2
    int 10h
    mov ah,02h
    mov dl,f
    int 21h     { prawy slupek }
    loop @start
  @koniec:
  end;
end {ramka};

function stringfill(c:char;l:byte):string;
var
 s : string;
begin
  s:='';
  for i:=1 to l do s:=s+c;
  stringfill:=s;
end; {stringfill}

function stringleft(s:string;l:byte):string;
begin
  s:=copy(s,1,l);
  stringleft:=s+stringfill(' ',l-length(s));
end; {stringleft}

function stringright(s:string;l:byte):string;
begin
  s:=copy(s,1,l);
  stringright:=stringfill(' ',l-length(s))+s;
end; {stringright}

function stringcenter(s:string;l:byte):string;
var s1 : string;
begin
  s:=copy(s,1,l);
  s1:=stringfill(' ',l-length(s));
  insert(s,s1,length(s1) div 2+1);
  stringcenter:=s1;
end; {stringcenter}

function num2str(n:real;c,u:byte):string;
var s : string;
begin
  if(U>0) then inc(c,succ(u));
  str(n:C:U,s);
  num2str:=s;
end; {num2str}

procedure linia(czypod,czypoz:boolean;x1,x2,y:byte);
begin
  case czypod of
    true:begin
           case czypoz of
             true:a:='Í';
             false:a:='º';
           end;
         end;
    false:begin
            case czypoz of
              true:a:='Ä';
              false:a:='³';
            end;
          end;
  end;
  if czypoz then for i:=x1 to x2 do g(i,y,a) else for i:=x1 to x2 do g(y,i,a);
end; {linia}

procedure kill_kursor;assembler;
asm
  mov ah,1h
  mov ch,20h
  mov cl,20h
  int 10h
end; {kill_kursor}

procedure show_kursor;assembler;
asm
  mov ah,1h
  mov ch,0bh
  mov cl,0ch
  int 10h
end; {show_cursor}

procedure show_big_kursor;assembler;
asm
  mov ah,1h
  mov ch,0h
  mov cl,10h
  int 10h
end; {show_big_cursor}

function key : char;
begin
  repeat until keypressed;
  key:=readkey;
end; {key}

function czy_kolor : boolean;
var tryb:byte;
begin
  asm
    mov ah,$0f
    int 10
    mov tryb,3
    cmp al,07
    je @mono
   @mono:
    mov tryb,7
  end;
  if tryb=3 then czy_kolor:=true else czy_kolor:=false;
end; {czy_kolor}

procedure dzwiek(czy:boolean);
begin
  if czy then czy_sound:=true else czy_sound:=false;
end;

procedure wwrite(text:string;czyprzen:boolean);
begin
  for i:=1 to length(text) do
  begin
    write(text[i]);
    if czy_sound then sound(33000);
    delay(20);
    nosound;
  end;
  if czyprzen then writeln('');
end; {wwrite}

procedure wczytaj(filtr:string);
var
  info       : SearchRec;
  pomoc,blad : Byte;

begin
  pomoc:=1;
  FindFirst('*.*',AnyFile xor VolumeId,info);
    repeat
      blad:=DosError;
      if blad=0 then
        if boolean(info.attr and directory) and (info.name<>'.') then
          begin
            zbior[pomoc]:=stringleft(info.name,12);
            inc(pomoc);
          end;
      FindNext(info);
    until ((blad<>0) or (pomoc=51));
  IloscKatalogow:=pomoc-1;

  FindFirst(filtr,AnyFile,info);
    repeat
      blad:=DosError;
      if blad=0 then
        if boolean(info.attr and directory)
          then
            dec(pomoc)
          else
            zbior[pomoc]:=stringleft(info.name,12);
      inc(pomoc);
      FindNext(info);
    until ((blad<>0) or (pomoc=102));
  dec(pomoc);
  IloscZbiorow:=pomoc-1-IloscKatalogow;
end; {wczytaj}

function wybierz(x1:byte;dodatek,filtr:string;ap,cp,ep,sp:char):string;
var
  ymax,t,oldt,ruch,y,oldy,tmax,pomoc,strona : byte;
  z     : char;
  wyjsc : boolean;

  procedure naped;
    var drive : string;
    begin
      ramka(true,true,5,5,75,7);
      g(6,6,stringcenter('Podaj liter'+ep+' okre'+sp+'laj'+ap+'c'+ap+' nap'+ep+'d',68));
      z:=key;
      if z=esc then
        begin
          wyjsc:=true;
          exit;
        end;
      drive:=z+':';
      {$I-}
      chdir(drive);
      {$I+}
      czysc(1,5,80,7);
    end;

  procedure niema;
    begin
      ramka(true,true,1,5,80,7);
      g(2,6,stringcenter('Tu nic nie ma!',78));
      z:=key;
      naped;
    end;
  procedure sprawdz;
    begin
      if t>22
        then
          begin
            pomoc:=t;
            y:=24;
          end
        else pomoc:=1;

    end;
  procedure wgore;
    begin
      dec(t);
      if t<1 then t:=1;
      dec(y);
      if y<2 then y:=2;
    end;
  procedure wdol;
    begin
      inc(t);
      if t>tmax then t:=tmax;
      inc(y);
      if y>ymax then y:=ymax;
    end;

begin
  wyjsc:=false;
  kill_kursor;
  repeat
    repeat
      wczytaj(filtr);
      if dodatek<>'' then
        begin
          pomoc:=IloscKatalogow+IloscZbiorow+1;
          zbior[pomoc]:=stringleft(dodatek,12);
        end
      else pomoc:=IloscKatalogow+IloscZbiorow;
      if pomoc=0 then niema;
    until ((pomoc<>0) or (wyjsc));
    tmax:=pomoc;
    ymax:=1+tmax;
    if ymax>24 then ymax:=24;
    ramka(true,true,x1-1,1,x1+14,ymax+1);

    if pomoc>23 then pomoc:=23;
    for i:=1 to pomoc do g(x1,i+1,' '+zbior[i]+' ');
    t:=1;
    y:=2;
    textcolor(black);textbackground(white);
    g(x1,y,' '+zbior[t]+' ');
    textcolor(white);textbackground(black);
    if wyjsc=false then
      repeat
        z:=key;
        oldt:=t;
        oldy:=y;
        case z of
          pgup,#071   : begin
                          t:=1;
                          y:=2;
                          oldy:=2;
                          oldt:=2;
                          if tmax>23 then pomoc:=23 else pomoc:=tmax;
                          for i:=1 to pomoc do g(x1,i+1,' '+zbior[i]+' ');
                        end;
          #079,pgdown : begin
                          t:=tmax;
                          y:=ymax;
                          if tmax>23
                          then
                            begin
                              oldt:=1;
                              oldy:=ymax
                            end
                        end;
          up          : wgore;
          down        : wdol;
        end;
        if oldt<>t then
        begin
          sprawdz;
          if pomoc<>1 then
            begin
              pomoc:=t-23;
              for i:=1 to 23 do g(x1,i+1,' '+zbior[i+pomoc]+' ');
            end;
          g(x1,oldy,' '+zbior[oldt]+' ');
          textcolor(black);textbackground(white);
          g(x1,y,' '+zbior[t]+' ');
          textcolor(white);textbackground(black);
        end;
      until ((z=enter) or (z=esc) or (z=' '));
    {$I-}
    if z=enter then
      if t<=IloscKatalogow
        then if zbior[t][1]='.'
          then chdir('..')
          else chdir(zbior[t]);
    {$I+}
    czysc(x1-1,1,x1+15,ymax+1);
    if z=' ' then naped;
  until ((t>IloscKatalogow) or (z=esc));
  show_kursor;
  if dodatek <> '' then zbior[tmax]:=dodatek;
  if z=esc then wybierz:='' else wybierz:=zbior[t];
end; {wybierz}

end.