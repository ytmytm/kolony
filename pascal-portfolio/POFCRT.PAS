
{ read README.TXT for licensing information    }
{ Maciej Witkowiak <ytm@elysium.pl> 15.03.2002 }

unit pofcrt;

interface

procedure ClrScr;
procedure GotoXY(x,y:byte);
function WhereX:byte;
function WhereY:byte;
function KeyPressed:boolean;
function ReadKey:char;

{ slow screen refresh }
procedure Refresh;
{ cursor mode: 0 - off, 1 - underline, 2 - block }
procedure CursorMode(typ:byte);
{ turn off computer }
procedure Off;
{ dial a number }
procedure Dial(number:string);
{ save/restore screen area, action: 0/2 - save/restore only chars, 1/3 - w/ attributes }
procedure ScreenSave(x1,y1,x2,y2,action:byte; buffer:array of byte);
{ draw a box, typ: 0 - single, 1 - double line }
procedure DrawBox(x1,y1,x2,y2,typ:byte);
{ show message box - double line frame with title }
procedure MessageBox(x,y:byte; message:string);
{ show error box - double line frame with beep and no title }
procedure ErrorBox(x,y:byte; message:string);
{ Draw menubox, returns menuitem (0-..) or -1 for ESC, doesn't clear screen }
function MenuBox(x,y,typ,depth,top,item:byte; menu,defaults:string):integer;

implementation

var tempstring:string[200];

procedure ClrScr; assembler;
asm
   mov ax, $0600
   mov bh, 7
   xor cx, cx
   mov dh, 24
   mov dl, 79
   int $10              { clrscr }
   mov ah, 2
   xor bh, bh
   xor dx, dx
   int $10              { gotoxy(1,1) }
end;

procedure GotoXY(x,y:byte); assembler;
asm
   mov ah, 2
   xor bh, bh
   mov dh, y
   mov dl, x
   dec dh
   dec dl
   int $10
end;

function WhereX:byte; assembler;
asm
   mov ah, 3
   xor bh, bh
   int $10
   mov al, dl
   inc al
end;

function WhereY:byte; assembler;
asm
   mov ah, 3
   xor bh, bh
   int $10
   mov al, dh
   inc al
end;

function KeyPressed:boolean; assembler;
asm
   mov ah, $0b
   int $21
   cmp al, 0
   je  @end
   mov al, 1
@end:
end;

function ReadKey:char; assembler;
asm
   mov ah, 7
   int $21
end;

procedure Refresh; assembler;
asm
   mov ah, $12
   int $61
end;

procedure CursorMode(typ:byte); assembler;
asm
   mov ah, $0f
   xor al, al
   inc al
   mov bl, typ
   int $61
end;

procedure Off; assembler;
asm
   mov ah, $2d
   int $61
end;

procedure Dial(number:string);
begin
     tempstring:=number;
     asm
     push ds
     mov ax, seg tempstring;
     mov ds, ax
     mov si, offset tempstring;
     mov cl, ds:[si]
     inc si
     xor ch, ch
     mov ah, $17
     int $61
     pop ds
     end;
end;

procedure ScreenSave(x1,y1,x2,y2,action:byte; buffer:array of byte); assembler;
asm
   xor bh, bh
   mov dl, x1
   mov dh, y1
   mov cl, x2
   mov ch, y2
   mov ah, 8
   mov al, action
   push ds
   lds si, buffer
   int $60
   pop ds
end;

procedure DrawBox(x1,y1,x2,y2,typ:byte); assembler;
asm
   mov al, typ
   mov ah, 9
   xor bh, bh
   mov dl, x1
   mov dh, y1
   mov cl, x2
   mov ch, y2
   int $60
end;

procedure MessageBox(x,y:byte; message:string);
var  p_str:^string;
begin
     p_str:=@message;
    asm
     mov dl, x
     mov dh, y
     xor bh, bh
     push ds
     lds si, p_str;
     inc si
     mov ah, $12
     int $60
     pop ds
    end;
end;

procedure ErrorBox(x,y:byte; message:string);
var  p_str:^string;
begin
     p_str:=@message;
    asm
     mov dl, x
     mov dh, y
     xor bh, bh
     push ds
     lds si, p_str;
     inc si
     xor cx, cx
     inc cx
     mov ah, $14
     int $60
     pop ds
     end;
end;

function MenuBox(x,y,typ,depth,top,item:byte; menu,defaults:string):integer;
var p_menu,p_defaults:^string;
    retval:integer;
begin
     p_menu:=@menu;
     p_defaults:=@defaults;
     asm
        mov ah, typ
        mov al, depth
        mov cl, 3
        shl al, cl
        or  al, ah
        mov ah, $0f
        xor bh, bh
        mov ch, top
        mov cl, item
        mov dl, x
        mov dh, y
        push es
        push ds
        lds si, p_menu
        les di, p_defaults
        inc si
        inc di
        int $60
        mov retval, ax
        pop ds
        pop es
     end;
     MenuBox:=retval;
end;


end.
