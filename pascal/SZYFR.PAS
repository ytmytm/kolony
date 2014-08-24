uses dodatki;

var
  sz,dos : String;
  z      : Char;


function szyfr(t:string):string;
var
  i,l : byte;
  q   : string;
begin
  q:='';
  l:=length(t);
  for i:=1 to l do
    begin
      z:=chr(ord(t[i])+80+i);
      q:=concat(q,z);
    end;

  szyfr:=q;
end;

function deszyfr(t:string):string;
var
  i,l : byte;
  q   : string;
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
begin
  Write('Podaj text do zaszyfrowania : ');
  readln(dos);
  writeln;
  sz:=szyfr(dos);
  writeln(dos,' = ',sz);
  writeln;
  writeln('Odszyfrowany text - ',sz,' = ',deszyfr(sz));
  writeln('Press any key...');
  close(f);
  z:=key;
end.
