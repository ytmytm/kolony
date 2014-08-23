
{ example program for portgra library }
{ Maciej Witkowiak <ytm@elysium.pl> 15.03.2002 }

uses portgra;

var x,y:integer;
    a:char;

begin
     graphmode;
     x:=0;
     while (x<240) do begin
         draw(0,0,x,63,1);
         draw(239,63,240-x,0,1);
         inc(x,8); {x:=x+5;}
     end;
{     graphclrscr;}
     y:=0;
     while (y<64) do begin
         draw(0,0,239,y,1);
         draw(239,63,0,64-y,1);
         inc(y,8); {y:=y+5;}
     end;

     read(a);
     textmode;
end.