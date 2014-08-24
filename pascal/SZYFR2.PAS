uses dodatki;

var
  sz,dos : String;
  z      : Char;
  f      : Text;

function szyfr(t:string):string;
var
  i,l : byte;
  q   : string;
begin
  q:='';
  l:=length(t);
  for i:=1 to l do
    begin
      z:=chr(ord(t[i])*2+i-80);
      q:=concat(q,z);
    end;

  szyfr:=q;
end;

begin
  assign(f,'zaszyfr.pas');
  reset(f);
  readln(f,dos);
  sz:=szyfr(dos);
  assign(f,'zaszyfr.pas');
  rewrite(f);
  write(f,sz);
  close(f);
end.
