{********************************************}
{*                                          *}
{* Modul z plansza poczatkowa do " KOLONY " *}
{*                                          *}
{********************************************}


{$X+}

unit kol_pocz;

interface

const
  maxlen = 1000;
  kom1   = '’ÄÇÉ¨vÇÊÓ¿¿ÏÑ¿ÖÉÂ‚ÊÖÊ†×Ü£Š·¼º¾¾Ê”“¢';


type
 lentype = 0..maxlen;
 textpoint = ^texttype;
 texttype = record
  max : lentype;
  len : lentype;
  buf : array[1..maxlen] of char;
 end;
var joy,joy2:boolean;

function DeSzyfr(t:string):string;
function stringfill(c:char;l:byte) : string;
procedure kbdclear;
function textmake(l:lentype):textpoint;
procedure textadd(var t : texttype;s:string);
procedure textkill(t:textpoint);
procedure textscroll(t:textpoint;x,y,l,g:byte;d:word;b:boolean;s:byte);
procedure fillscreen;
procedure scrolltest;
procedure superscroll;


implementation

uses crt;


function deszyfr(t:string):string;
var
  i,l : byte;
  q   : string;
  z   : char;
begin
  q:='';
  l:=length(t);
  for i:=1 to l do
    begin
      z:=chr(ord(t[i])-80-i);
      q:=concat(q,z);
    end;

  deszyfr:=q;
end;

function stringfill(c:char;l:byte) : string;
var s:string;
begin
 fillchar(s[1],l,c);
 s[0]:=chr(l);
 stringfill:=s;
end;

procedure kbdclear;
var z:char;
begin
 while keypressed do z:=readkey;
end;

function textmake(l:lentype):textpoint;
var t:textpoint;
begin
 if (maxavail < 2 * sizeof(lentype) + l) then t:=nil else begin
  getmem(t,2 * sizeof(lentype) + l);
  t^.max:=l;
  t^.len:=0;
  end;
 textmake:=t;
end;

procedure textadd(var t : texttype;s:string);
var l:lentype;
begin
 l:=length(s);
 if (t.len + l > t.max) then l:=t.max - t.len;
 move(s[1],t.buf[succ(t.len)],l);
 inc(t.len,l);
end;

procedure textkill(t:textpoint);
begin
 if (t <> nil) then freemem(t,2 * sizeof(lentype) + t^.max);
end;

procedure textscroll(t:textpoint;x,y,l,g:byte;d:word;b:boolean;s:byte);
var text:string;
 i:lentype;
 j:byte;
begin
 text:=stringfill(' ',l);
 i:=1;
 j:=0;
 repeat
  gotoxy(x,y);
  write(text);
  text:=copy(text,2,pred(l));
  if (t^.buf[i] <> #13) and (j=0) then begin
    text:=text+t^.buf[i];
    inc(i);
  end else begin
    if (j=0) then begin
      inc(i);
      j:=g;
    end else dec(j);
    text:=text + ' ';
  end;
  if b and ((i + j) mod s=0) then textcolor((textattr and$0f) xor $08);
  if (i > t^.len) then i:=1;
  delay(d);
 until keypressed;
 kbdclear;
end;

procedure fillscreen;
var i:byte;
t:string;
begin
 t:=stringfill(#177,80);
 textcolor(green);
 textbackground(black);
 clrscr;
 for i:=1 to 24 do write(t);
end;

function deszyfr2(t:string):string;
var
  i,l : byte;
  q   : string;
  z   : char;
begin
  q:='';
  l:=length(t);
  for i:=1 to l do
    begin
      z:=chr((ord(t[i])-i+80) div 2);
      q:=concat(q,z);
    end;
  deszyfr2:=q;
end;

procedure scrolltest;
var
  t:textpoint;
  kom2 : string;
  kom3 : string;
  i    : byte;
begin
 kom2:=concat(#13,deszyfr('›·ÆÈuÊÆxÀÌ¼|Ë¿ÏÉÔÃÑÅ…ÖÙâÎä‹­ßâäâÒ’ÆİêæàãÚšéİîîäôöä'));
 t:=textmake(1000);
 if (t <> nil) then
 begin
   kom3:=deszyfr2('3–›™x÷^‹¤›“€');
   kom3[7]:=' ';
   for i:=1 to 14 do
     kom2[i+28]:=kom3[i];
   gotoxy(9,4);
   writeln('                                                               ');gotoxy(9,5);
   writeln('  ##   ##    #####    ##        #####    ##    ##  ##      ##  ');gotoxy(9,6);
   writeln('  ##  ##    ##   ##   ##       ##   ##   ###   ##   ##    ##   ');gotoxy(9,7);
   writeln('  ## ##    ##     ##  ##      ##     ##  ####  ##    ##  ##    ');gotoxy(9,8);
   writeln('  ####     ##     ##  ##      ##     ##  ## ## ##     ####     ');gotoxy(9,9);
   writeln('  ## ##    ##     ##  ##      ##     ##  ##  ####      ##      ');gotoxy(9,10);
   writeln('  ##  ##    ##   ##   ##       ##   ##   ##   ###      ##      ');gotoxy(9,11);
   writeln('  ##   ##    #####    #######   #####    ##    ##      ##      ');gotoxy(9,12);
   writeln('                                                               ');gotoxy(19,14);
   gotoxy(73,12);
   write(' v 0.98 ');
   textadd(t^,deszyfr(kom1));
   textadd(t^,kom2);
   textadd(t^,deszyfr('È»¸tÈ¹¼ÆºÌÄÑĞØÀ€Û‚…¯ÔÒÖÖâŒ‹ÚÎ‘İÒŞØ–•·ëÙëã›ª'));
   textadd(t^,#13+#13+deszyfr('¡ÄÍÍ¿»ÄÆ¾Ä{Ö¾ÀÀ×Ú‚„…†')+#13+#13);
   textadd(t^,deszyfr('¨r¶Î¶ÉÀ½yÁÍÕ}ÎÎÄÍÏÅÜÏÚâÎ×‹²äÛãëçí•àÜëíšÄÂÊÏ¢¡°')+#13#13);
   textadd(t^,deszyfr('›·Í¹Á¿wÒºÇÄ½ĞÒĞĞÎÖÏÎÉÏˆÕÓßÑßâÑ‘”Şæï×Úòäã¨òî ø¢æşæùğí©ñı­üğóúıÿ¶İÊÇ')+#13#13);
   textadd(t^,deszyfr('Ÿ³¶½ÈÄÀÂyÄ¼ÇÆÉÎÌØËÈÏ…ÑÓÉàÓŞæÏÑé‘ìÔ×ï×Ú˜àìàª')+#13#13#13#13);
   textcolor(yellow);
   textbackground(blue);
   textscroll(t,9,20,63,10,100,false,2);
   textkill(t)
 end else
 begin
   writeln('Brak pamieci na dane!');
   readln;
 end;
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

end.
