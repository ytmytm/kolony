
{ plot should be faster than plota, line should be rewritten in asm }
{ Maciej Witkowiak <ytm@elysium.pl>, 15.03.2002 }

unit portgra;

interface

{uses portfolio;}

procedure putlcd(command,option : byte);

procedure graphmode;

procedure textmode;

procedure graphclrscr;

procedure plota(x,y,color : integer);
procedure plot(x,y,color:integer);

procedure circle(cx,cy,radius,color : integer);

procedure draw(x1,y1,x2,y2,color : integer);

procedure line(x1,y1,x2,y2,color : integer);

procedure box(topx,topy,botx,boty,color : integer);

procedure angle(degree : real; cx,cy,radius,color : integer);

procedure savepgc(f2 : string);

procedure loadpgc(filename : string; keyed : integer);

implementation

procedure putlcd(command,option : byte);
begin
     inline($FA);
     port[$8011] := command;
     port[$8010] := option;
     inline($FB);
end;

procedure graphmode; assembler;
asm
     mov ax,4
     int $10
end;

procedure graphclrscr; assembler;
asm
     xor di, di
     mov cx, 1919
     mov ax, $b000
     mov es, ax
     mov ds, ax
     rep stosb
 xor  si,si
 mov  di,64         {DI = number of lines on the screen}
 mov  dx,8010h
@refresh_2:
 mov  cx,30         {CX = number of bytes on one line}
 mov  bx,si
 mov  al,0ah
 inc  dx
 cli
 out  dx,al
 mov  al,bl
 dec  dx
 out  dx,al
 mov  al,0bh
 inc  dx
 out  dx,al
 dec  dx
 mov  al,bh
 and  al,7
 out  dx,al
 sti
@refresh_1:
 lodsb

 ror  al,1
 mov  ah,al
 and  ah,136
 ror  al,1
 ror  al,1
 mov  bl,al
 and  bl,68
 or   ah,bl
 ror  al,1
 ror  al,1
 mov  bl,al
 and  bl,34
 or   ah,bl
 ror  al,1
 ror  al,1
 and  al,17
 or   al,ah

 mov  ah,al
 inc  dx
 mov  al,0ch
 cli
 out  dx,al
 mov  al,ah
 dec  dx
 out  dx,al
 sti
 loop @refresh_1
 dec  di
 jnz  @refresh_2
end;


procedure textmode; assembler;
asm
     mov ax,$3
     int $10
end;

procedure plota(x,y,color : integer);

var
   memloc: word; loword,hiword : byte;
   store : byte;
{   power : array[0..7] of byte;
   yy,xx : byte;
 }
begin
{     if (x < 240) and (x > -1) and (y < 64) and (y > -1) then} begin
{     power[0] := 1;
     power[1] := 2;
     power[2] := 4;
     power[3] := 8;
     power[4] := 16;
     power[5] := 32;
     power[6] := 64;
     power[7] := 128;}
{     memloc := (y*30) + (x div 8); }
             asm
        mov dx, x
        mov ax, y
        mov bx, ax
        mov cl, 5
        shl ax, cl
        mov cl, 1
        shl bx, cl
        sub ax, bx { ax:=30*y }
        mov bl, dl
        mov cl, 3
        shr bl, cl
        xor bh, bh
        add ax, bx
        mov memloc, ax
        mov loword, al
        mov hiword, ah
             end;
     store := mem[$b800:memloc];
{     loword := memloc mod 256;
     hiword := memloc div 256;}
     putlcd($0a,loword);
     putlcd($0b,hiword);
{     x := x mod 8;
     if color <> 1 then begin
          x := not(power[x]);
          store := store and x;
        end else store := store or power[x];}
     asm
        mov dl, store
        mov cx, x
        and cl, 0111b
        mov al, 1
        shl al, cl
        mov bx, color
        cmp bl, 1
        je  @rysuj
@wymaz:
        xor al, 0ffh
        and dl, al
        jp  @koncz
@rysuj:
        or  dl, al
@koncz:
        mov store, dl
     end;
     putlcd($0c,store);
     mem[$b800:memloc] := store;
     end;
end;

procedure plot(x,y,color:integer); assembler;
asm
   mov ax, $b800
   mov es, ax
   mov ax, y     { y->ax }
   shl al, 1     { ax:=ax*2 }
   mov bl, al
   xor bh, bh    { bx:=y*2  }
   clc
   mov cl, 4
   shl ax, cl    { ax:=y*2*2^4=y*2^5 }
   sub ax, bx    { ax:=32y-2y=30y  }
   mov bx, x
   dec cl        { cl:=3 }
   shr bl, cl    { x:=x/8 }
{   xor bh, bh  }
   add bx, ax    { bx:=30y+x/8 }
   mov di, bx
   mov dx, $8011
   mov al, $0a
   cli
   out dx, al
   mov al, bl
   dec dx
   out dx, al
   inc dx
   mov al, $0b
   out dx, al
   dec dx
   mov al, bh
   out dx, al
   sti
   mov dl, es:[di]
   mov cx, x
   and cl, 0111b
   mov al, 1
   shl al, cl
   mov bx, color
   cmp bl, 1
   je  @rysuj
@wymaz:
   xor al, 0ffh
   and dl, al
   jp  @koncz
@rysuj:
   or  dl, al
@koncz:
   mov es:[di], dl
   mov bl, dl
   mov dx, $8011
   mov al, $0c
   cli
   out dx, al
   dec dx
   mov al, bl
   out dx, al
   sti
end;

procedure circle(cx,cy,radius,color : integer);

var x,y : integer;
    r2,x2,y2 : integer;
    yp,xp : real;
    ty,tx : integer;

begin
     r2 := sqr(radius);
     for x := cx - radius to cx + radius do begin
         x2 := sqr(x-cx);
         yp := sqrt(r2-x2) + cy;
         ty := round(yp);
         plot(x,ty,color);
         yp := (-sqrt(r2-x2)) + cy;
         ty := round(yp);
         plot(x,ty,color);
     end;
     for y := cy - radius to cy + radius do begin
         y2 := sqr(y-cy);
         xp := sqrt(r2-y2) + cx;
         tx := round(xp);
         plot(tx,y,color);
         xp := (-sqrt(r2-y2)) + cx;
         tx := round(xp);
         plot(tx,y,color);
     end;
end;

procedure draw(x1,y1,x2,y2,color : integer);

var slope,b : real;
    rise,run,testslope : integer;
    x,y,xstart,xfinish,ystart,yfinish : integer;

begin
     if y1 < y2 then begin
        ystart := y1;
        yfinish := y2;
     end;
     if y1 > y2 then begin
        ystart := y2;
        yfinish := y1;
     end;
     if x1 < x2 then begin
        xstart := x1;
        xfinish := x2;
     end;
     if x1 > x2 then begin
        xstart := x2;
        xfinish := x1;
     end;
     rise := y2 - y1;
     run := x2 - x1;
     if run <> 0 then slope := rise/run else slope := 1;
     b := y2 - (slope*x2);
     testslope := trunc(slope);
     if testslope < 0 then testslope := -testslope;
     if run = 0 then testslope := -1;
     if (testslope > -1) and (testslope < 1) then begin
        for x := xstart to xfinish do begin
            y := round(slope*x)+round(b);
            plot(x,y,color);
        end;
     end;
     if (testslope >= 1) then begin
        for y := ystart to yfinish do begin
            x := round((y-b)/slope);
            plot(x,y,color);
        end;
     end;
     if testslope = -1 then begin
        for y := ystart to yfinish do begin
            plot(x1,y,color);
        end;
     end;
end;

procedure line(x1,y1,x2,y2,color : integer);

begin
     draw(x1,y1,x2,y2,color);
end;

procedure box(topx,topy,botx,boty,color : integer);

begin
     draw(topx,topy,botx,topy,color);
     draw(botx,topy,botx,boty,color);
     draw(botx,boty,topx,boty,color);
     draw(topx,boty,topx,topy,color);
end;

procedure angle(degree : real; cx,cy,radius,color : integer);

const degtorad = 0.017453;

var radians : real;
    x,y : integer;

begin
     radians := degree * degtorad;
     x := round(cx+(sin(radians)*(radius)));
     y := round(cy-(cos(radians)*(radius)));
     draw(cx,cy,x,y,color);
end;

procedure savepgc(f2 : string);

var
   fileout : file;
   bufin,bufout : array[0..2000] of byte;
   nosame,nodiff : integer;
   current,last,pos,a : integer;
   result : word;
   b : integer;
   power : array[0..7] of byte;
   store : byte;

begin
     power[0] := 1;
     power[1] := 2;
     power[2] := 4;
     power[3] := 8;
     power[4] := 16;
     power[5] := 32;
     power[6] := 64;
     power[7] := 128;
     for a := 0 to 1919 do begin
         store := mem[$b800:a];
         bufin[a] := 0;
         for b := 0 to 7 do begin
             if store and power[b] = power[b] then bufin[a] := bufin[a] or power[7-b];
         end;
     end;
     nosame := 0;
     nodiff := 0;
     current := 0;
     bufout[0] := ord('P');
     bufout[1] := ord('G');
     bufout[2] := 1;
     pos := 3;
     last := 1;
     while last < 1920 do begin
           if bufin[current] <> bufin[last] then begin
              inc(nodiff);
              if nosame > 0 then begin
                 bufout[pos] := (nosame+1) or 128;
                 inc(pos);
                 bufout[pos] := bufin[current];
                 inc(pos);
                 nosame := 0;
                 dec(nodiff);
              end;
                  if nodiff > 126 then begin
                     bufout[pos] := nodiff;
                     inc(pos);
                     for a := current-(nodiff-1) to current do begin
                         bufout[pos] := bufin[a];
                         inc(pos);
                     end;
                     nodiff := 0;
                  end;
              inc(current);
              inc(last);
              end else begin
                  inc(nosame);
                  if nodiff > 0 then begin
                     bufout[pos] := nodiff;
                     inc(pos);
                     for a := current-nodiff to current-1 do begin
                         bufout[pos] := bufin[a];
                         inc(pos);
                     end;
                     nodiff := 0;
                  end;
              if nosame+1 > 126 then begin
                 bufout[pos] := 127 or 128;
                 inc(pos);
                 bufout[pos] := bufin[current];
                 inc(pos);
                 nosame := 0;
                 inc(current);
                 inc(last);
              end;
                  inc(current);
                  inc(last);
              end;
           end;
           if bufin[1918] = bufin[1919] then inc(nosame) else inc(nodiff);
              if nosame > 0 then begin
                 bufout[pos] := nosame or 128;
                 inc(pos);
                 bufout[pos] := bufin[1919];
                 inc(pos);
              end;
                  if nodiff > 0 then begin
                     bufout[pos] := nodiff;
                     inc(pos);
                     for a := 1919-nodiff to 1919 do begin
                         bufout[pos] := bufin[a];
                         inc(pos);
                     end;
                  end;
     assign(fileout,f2);
     rewrite(fileout,1);
     blockwrite(fileout,bufout[0],pos);
     close(fileout);
end;

procedure loadpgc(filename : string; keyed : integer);

var
    filein : file;
    position,a,b,c,index,fsize : integer;
    ch : char;
    abyte : byte;
    result : integer;
    graphic : array[-3..1919] of byte;
    f : array[0..255] of byte;
    memofs : word;

begin
     f[0] := 0;
     f[1] := 128;
     f[2] := 64;
     f[3] := 192;
     f[4] := 32;
     f[5] := 160;
     f[6] := 96;
     f[7] := 224;
     f[8] := 16;
     f[9] := 144;
     f[10] := 80;
     f[11] := 208;
     f[12] := 48;
     f[13] := 176;
     f[14] := 112;
     f[15] := 240;
     f[16] := 8;
     f[17] := 136;
     f[18] := 72;
     f[19] := 200;
     f[20] := 40;
     f[21] := 168;
     f[22] := 104;
     f[23] := 232;
     f[24] := 24;
     f[25] := 152;
     f[26] := 88;
     f[27] := 216;
     f[28] := 56;
     f[29] := 184;
     f[30] := 120;
     f[31] := 248;
     f[32] := 4;
     f[33] := 132;
     f[34] := 68;
     f[35] := 196;
     f[36] := 36;
     f[37] := 164;
     f[38] := 100;
     f[39] := 228;
     f[40] := 20;
     f[41] := 148;
     f[42] := 84;
     f[43] := 212;
     f[44] := 52;
     f[45] := 180;
     f[46] := 116;
     f[47] := 244;
     f[48] := 12;
     f[49] := 140;
     f[50] := 76;
     f[51] := 204;
     f[52] := 44;
     f[53] := 172;
     f[54] := 108;
     f[55] := 236;
     f[56] := 28;
     f[57] := 156;
     f[58] := 92;
     f[59] := 220;
     f[60] := 60;
     f[61] := 188;
     f[62] := 124;
     f[63] := 252;
     f[64] := 2;
     f[65] := 130;
     f[66] := 66;
     f[67] := 194;
     f[68] := 34;
     f[69] := 162;
     f[70] := 98;
     f[71] := 226;
     f[72] := 18;
     f[73] := 146;
     f[74] := 82;
     f[75] := 210;
     f[76] := 50;
     f[77] := 178;
     f[78] := 114;
     f[79] := 242;
     f[80] := 10;
     f[81] := 138;
     f[82] := 74;
     f[83] := 202;
     f[84] := 42;
     f[85] := 170;
     f[86] := 106;
     f[87] := 234;
     f[88] := 26;
     f[89] := 154;
     f[90] := 90;
     f[91] := 218;
     f[92] := 58;
     f[93] := 186;
     f[94] := 122;
     f[95] := 250;
     f[96] := 6;
     f[97] := 134;
     f[98] := 70;
     f[99] := 198;
     f[100] := 38;
     f[101] := 166;
     f[102] := 102;
     f[103] := 230;
     f[104] := 22;
     f[105] := 150;
     f[106] := 86;
     f[107] := 214;
     f[108] := 54;
     f[109] := 182;
     f[110] := 118;
     f[111] := 246;
     f[112] := 14;
     f[113] := 142;
     f[114] := 78;
     f[115] := 206;
     f[116] := 46;
     f[117] := 174;
     f[118] := 110;
     f[119] := 238;
     f[120] := 30;
     f[121] := 158;
     f[122] := 94;
     f[123] := 222;
     f[124] := 62;
     f[125] := 190;
     f[126] := 126;
     f[127] := 254;
     f[128] := 1;
     f[129] := 129;
     f[130] := 65;
     f[131] := 193;
     f[132] := 33;
     f[133] := 161;
     f[134] := 97;
     f[135] := 225;
     f[136] := 17;
     f[137] := 145;
     f[138] := 81;
     f[139] := 209;
     f[140] := 49;
     f[141] := 177;
     f[142] := 113;
     f[143] := 241;
     f[144] := 9;
     f[145] := 137;
     f[146] := 73;
     f[147] := 201;
     f[148] := 41;
     f[149] := 169;
     f[150] := 105;
     f[151] := 233;
     f[152] := 25;
     f[153] := 153;
     f[154] := 89;
     f[155] := 217;
     f[156] := 57;
     f[157] := 185;
     f[158] := 121;
     f[159] := 249;
     f[160] := 5;
     f[161] := 133;
     f[162] := 69;
     f[163] := 197;
     f[164] := 37;
     f[165] := 165;
     f[166] := 101;
     f[167] := 229;
     f[168] := 21;
     f[169] := 149;
     f[170] := 85;
     f[171] := 213;
     f[172] := 53;
     f[173] := 181;
     f[174] := 117;
     f[175] := 245;
     f[176] := 13;
     f[177] := 141;
     f[178] := 77;
     f[179] := 205;
     f[180] := 45;
     f[181] := 173;
     f[182] := 109;
     f[183] := 237;
     f[184] := 29;
     f[185] := 157;
     f[186] := 93;
     f[187] := 221;
     f[188] := 61;
     f[189] := 189;
     f[190] := 125;
     f[191] := 253;
     f[192] := 3;
     f[193] := 131;
     f[194] := 67;
     f[195] := 195;
     f[196] := 35;
     f[197] := 163;
     f[198] := 99;
     f[199] := 227;
     f[200] := 19;
     f[201] := 147;
     f[202] := 83;
     f[203] := 211;
     f[204] := 51;
     f[205] := 179;
     f[206] := 115;
     f[207] := 243;
     f[208] := 11;
     f[209] := 139;
     f[210] := 75;
     f[211] := 203;
     f[212] := 43;
     f[213] := 171;
     f[214] := 107;
     f[215] := 235;
     f[216] := 27;
     f[217] := 155;
     f[218] := 91;
     f[219] := 219;
     f[220] := 59;
     f[221] := 187;
     f[222] := 123;
     f[223] := 251;
     f[224] := 7;
     f[225] := 135;
     f[226] := 71;
     f[227] := 199;
     f[228] := 39;
     f[229] := 167;
     f[230] := 103;
     f[231] := 231;
     f[232] := 23;
     f[233] := 151;
     f[234] := 87;
     f[235] := 215;
     f[236] := 55;
     f[237] := 183;
     f[238] := 119;
     f[239] := 247;
     f[240] := 15;
     f[241] := 143;
     f[242] := 79;
     f[243] := 207;
     f[244] := 47;
     f[245] := 175;
     f[246] := 111;
     f[247] := 239;
     f[248] := 31;
     f[249] := 159;
     f[250] := 95;
     f[251] := 223;
     f[252] := 63;
     f[253] := 191;
     f[254] := 127;
     f[255] := 255;
     if pos('.',filename) = 0 then filename := filename + '.pgc';
     assign(filein,filename);
     {$I-}
     reset(filein,1);
     {$I+}
     if ioresult = 0 then begin
     fsize := filesize(filein);
     blockread(filein,graphic[-3],fsize,result);
     close(filein);
     graphmode;
     c := 0;
     index := 0;
     a := -1;
     putlcd($0a,00);
     putlcd($0b,00);
     memofs := 0;
     repeat inc(a);
           abyte := graphic[a];
           if (abyte and 128) = 128 then begin
                    index := abyte - 128;
                    a := a + 1;
                    for b := 0 to index-1 do begin
                        putlcd($0c,f[ord(graphic[a])]);
                        mem[$b800:memofs] := f[ord(graphic[a])];
                        inc(memofs);
                    end;
                    c := c + index;
                    end
                else begin
                index := abyte;
                a := a + 1;
                for b := a to index+a-1 do begin
                    putlcd($0c,f[ord(graphic[b])]);
                    mem[$b800:memofs] := f[ord(graphic[b])];
                    inc(memofs);
                end;
                c := c + index;
                a := a + index - 1;
                end;
           until a >= result;
           if keyed > 0 then begin
{           while not keypressed do;
           ch := readkey;}
           textmode;
           end;
     end else ; {porterrorwindow(10,3,'File not found');}
end;

end.
