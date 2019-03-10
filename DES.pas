unit
DES;
interface
function DES_64bit(text,key:qword;encryption:boolean):qword;
function DES(text,key:ansistring;encryption:boolean):ansistring;
function DES_hex(text,key:ansistring;encryption:boolean):ansistring;
implementation
type
_key=array[1..16]of qword;
procedure generatekeys(key:qword;var k:_key);
 const
 PC1:array[1..56]of longint=(57,49,41,33,25,17, 9,
                              1,58,50,42,34,26,18,
                             10, 2,59,51,43,35,27,
                             19,11, 3,60,52,44,36,
                             63,55,47,39,31,23,15,
                              7,62,54,46,38,30,22,
                             14, 6,61,53,45,37,29,
                             21,13, 5,28,20,12, 4);
 PC2:array[1..48]of longint=(14,17,11,24, 1, 5,
                              3,28,15, 6,21,10,
                             23,19,12, 4,26, 8,
                             16, 7,27,20,13, 2,
                             41,52,31,37,47,55,
                             30,40,51,45,33,48,
                             44,49,39,56,34,53,
                             46,42,50,36,29,32);
 shiftbits:array[1..16]of longint=(1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1);
 var
 i,j:longint;
 t,c,d:qword;
 begin
 t:=0;
 for i:=1 to 56 do
 t:=t shl 1 or key shr (64-PC1[i]) and 1;
 key:=t;
 c:=key shr 28;
 d:=c shl 28 xor key;
 for i:=1 to 16 do
 begin
 c:=c shl shiftbits[i] and 268435455 or (c shr (28-shiftbits[i]));
 d:=d shl shiftbits[i] and 268435455 or d shr (28-shiftbits[i]);
 t:=c shl 28 or d;
 k[i]:=0;
  for j:=1 to 48 do
  k[i]:=k[i] shl 1 or t shr (56-PC2[j]) and 1;
 end;
 end;
function f(R,key:qword):qword;
 const
 E:array[1..48]of longint=(32, 1, 2, 3, 4, 5,
                            4, 5, 6, 7, 8, 9,
                            8, 9,10,11,12,13,
                           12,13,14,15,16,17,
                           16,17,18,19,20,21,
                           20,21,22,23,24,25,
                           24,25,26,27,28,29,
                           28,29,30,31,32, 1);
 S_box:array[1..8,0..3,0..15]of longint=(((14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7),
                                          (0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8),
                                          (4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0),
                                          (15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13)),
                                         ((15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10),
                                          (3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5),
                                          (0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15),
                                          (13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9)),
                                         ((10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8),
                                          (13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1),
                                          (13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7),
                                          (1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12)),
                                         ((7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15),
                                          (13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9),
                                          (10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4),
                                          (3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14)),
                                         ((2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9),
                                          (14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6),
                                          (4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14),
                                          (11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3)),
                                            ((12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11),
                                          (10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8),
                                          (9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6),
                                          (4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13)),
                                         ((4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1),
                                          (13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6),
                                          (1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2),
                                          (6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12)),
                                         ((13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7),
                                          (1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2),
                                          (7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8),
                                          (2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11)));
 P:array[1..32]of longint=(16, 7,20,21,
                           29,12,28,17,
                            1,15,23,26,
                            5,18,31,10,
                            2, 8,24,14,
                           32,27, 3, 9,
                           19,13,30, 6,
                           22,11, 4,25);
 var
 i:longint;
 t:qword;
 begin
 t:=0;
 for i:=1 to 48 do
 t:=t shl 1 or R shr (32-E[i]) and 1;
 R:=t xor key;
 t:=0;
 for i:=1 to 8 do
 t:=t shl 4 or S_box[i,R shr (37-i*6) and 1 shl 1 or R shr (32-i*6) and 1,R shr (33-i*6) and 15];
 f:=0;
 for i:=1 to 32 do
 f:=f shl 1 or t shr (32-P[i]) and 1;
 end;
function DES_64bit(text,key:qword;encryption:boolean):qword;
 const
 IP:array[1..64]of longint=(58,50,42,34,26,18,10,2,
                            60,52,44,36,28,20,12,4,
                            62,54,46,38,30,22,14,6,
                            64,56,48,40,32,24,16,8,
                            57,49,41,33,25,17, 9,1,
                            59,51,43,35,27,19,11,3,
                            61,53,45,37,29,21,13,5,
                            63,55,47,39,31,23,15,7);
 IP_1:array[1..64]of longint=(40,8,48,16,56,24,64,32,
                              39,7,47,15,55,23,63,31,
                              38,6,46,14,54,22,62,30,
                              37,5,45,13,53,21,61,29,
                              36,4,44,12,52,20,60,28,
                              35,3,43,11,51,19,59,27,
                              34,2,42,10,50,18,58,26,
                              33,1,41, 9,49,17,57,25);
 var
 l,r:array[0..16]of qword;
 i,j:longint;
 t:qword;
 k:_key;
 begin
 generatekeys(key,k);
 t:=0;
 for i:=1 to 64 do
 t:=t shl 1 or text shr (64-IP[i]) and 1;
 text:=t;
 l[0]:=text shr 32;
 r[0]:=l[0] shl 32 xor text;
 for i:=1 to 16 do
 begin
 l[i]:=r[i-1];
  if encryption then
  t:=f(r[i-1],k[i])
  else
  t:=f(r[i-1],k[17-i]);
 r[i]:=l[i-1] xor t;
 end;
 t:=r[16] shl 32 or l[16];
 DES_64bit:=0;
 for i:=1 to 64 do
 DES_64bit:=DES_64bit shl 1 or t shr (64-IP_1[i]) and 1;
 end;
function DES_8byte(text,key:string;encryption:boolean):string;
 var
 _text,_key,t:qword;
 i:longint;
 begin
 _text:=0;
 for i:=1 to 8 do
 _text:=_text shl 8 or ord(text[i]);
 _key:=0;
 for i:=1 to 8 do
 _key:=_key shl 8 or ord(key[i]);
 t:=DES_64bit(_text,_key,encryption);
 DES_8byte:='';
 for i:=1 to 8 do
 begin
 DES_8byte:=chr(t and 255)+DES_8byte;
 t:=t shr 8;
 end;
 end;
function DES_textlong(text:ansistring;key:string;encryption:boolean):ansistring;
 var
 i:longint;
 begin
 if encryption then
 begin
 text:=text+#1;
  if length(text) mod 8>0 then
   for i:=1 to 8-length(text) mod 8 do
   text:=text+#0;
 end;
 DES_textlong:='';
 for i:=1 to length(text) div 8 do
 DES_textlong:=DES_textlong+DES_8byte(copy(text,(i-1)*8+1,8),key,encryption);
 if not encryption then
 begin
  while DES_textlong[length(DES_textlong)]=#0 do
  delete(DES_textlong,length(DES_textlong),1);
 delete(DES_textlong,length(DES_textlong),1);
 end;
 end;
function DES(text,key:ansistring;encryption:boolean):ansistring;
 var
 i:longint;
 begin
 key:=key+#1;
 if length(key) mod 8>0 then
  for i:=1 to 8-length(key) mod 8 do
  key:=key+#0;
 DES:=text;
 if encryption then
  for i:=1 to length(key) div 8 do
  DES:=DES_textlong(DES,copy(key,(i-1)*8+1,8),encryption)
 else
  for i:=length(key) div 8 downto 1 do
  DES:=DES_textlong(DES,copy(key,(i-1)*8+1,8),encryption);
 end;
function DES_hex(text,key:ansistring;encryption:boolean):ansistring;
 var
 s:ansistring;
 i:longint;
 function n_c(n:byte):char;
 begin
 if n<10 then
 n_c:=chr(n+48)
 else
 n_c:=chr(n+55);
 end;
 function c_n(c:char):byte;
 begin
 if c<'A' then
 c_n:=ord(c)-48
 else
 c_n:=ord(c)-55;
 end;
 begin
 if encryption then
 begin
 s:=DES(text,key,encryption);
 DES_hex:='';
  for i:=1 to length(s) do
  DES_hex:=DES_hex+n_c(ord(s[i]) div 16)+n_c(ord(s[i]) mod 16);
 end
 else
 begin
 s:='';
  for i:=1 to length(text) div 2 do
  s:=s+chr(c_n(text[i*2-1])*16+c_n(text[i*2]));
 DES_hex:=DES(s,key,encryption);
 end;
 end;
end.
