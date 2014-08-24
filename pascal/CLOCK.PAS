{$F+}

Unit Clock;

Interface

Function clockactive:boolean;
procedure clocktoggle(s:boolean);
procedure clockposition(x,y:byte);
procedure clockcolor(a:byte);
procedure clockbackground(a:byte);


Implementation


uses dos;
const
 cpos:word=$92;
 cattr:byte=$2f;
 cflag:boolean=false;
var
  oexit:pointer;
  oint8:pointer;

procedure cint8;interrupt;assembler;
asm
  pushf
  call oint8
  mov al,cflag
  mov al,false
  je @noclock
  MOV AH,$0F
  int $10
  cmp al,$07
  je @mono
  mov ax,$b800
  jmp @do
 @mono:
  mov ax,$b000
 @do:
  mov es,ax
  mov di,cpos
  mov ah,$02
  int $1a
  mov ah,cattr
  mov bx,cx
  mov cl,4
  mov al,' '
  stosw
  mov al,bh
  shr al,cl
  add al,48
  stosw
  mov al,bh
  and al,$f
  add al,48
  stosw
  mov al,' '
  test dh,$01
  jz @skip
  mov al,':'
 @skip:
  stosw
  mov al,bl
  shr al,cl
  add al,48
  stosw
  mov al,bl
  and al,$f
  add al,48
  stosw
  mov al,' '
  stosw
 @noclock:
end;

procedure clockexit;
begin
  setintvec($08,oint8);
  exitproc:=oexit
end;

function  clockactive:boolean;
begin
  clockactive:=cflag;
end;

procedure clocktoggle(s:boolean);
begin
  cflag:=s;
end;

procedure clockposition(x,y:byte);
begin
  cpos:=(pred(y)*80+pred(x)) shl 1;
end;

procedure clockcolor(a:byte);
begin
  cattr:=(cattr and $f0) or (a and $0f);
end;

procedure clockbackground(a:byte);
begin
  cattr:=(cattr and $0f) or (a shl 4);
end;

begin
  oexit:=exitproc;
  exitproc:=@clockexit;
  getintvec($08,oint8);
  setintvec($08,@cint8);
end.
