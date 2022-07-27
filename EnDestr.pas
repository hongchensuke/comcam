//     加解密单元   版本：2012091101
//     使用方法：1、uses EnDestr；2、调用相关函数。


unit EnDestr;

interface

uses Windows,SysUtils,dialogs;
//Procedure Enstr1(str:string):string;
Function Enstr1(str:string):string;
Function Destr1(str:string):string;
Function fillstr(str:string;len:integer):string;

implementation

Function fillstr(str:string;len:integer):string;
var
i:integer;
begin
   if length(str)>=len then
   begin
      Result:=str;
      Exit;
   end;
   Result:=str;
   for i:=1 to len-length(str) do
      Result:='0'+Result;
end;
Function Enstr1(str:string):string;
var
i,ri,a,b,c:integer;
str1,str2:string;
begin
   str1:='';
   str2:='';
   if length(str)=0 then
   begin
      Result:='';
      Exit;
   end;
   for i:=1 to length(str) do
   begin
      if ord(str[i])+100<1000 then
      begin
         randomize;
         ri:=random(100);
      end
      else
         ri:=0;
      str1:=str1+fillstr(inttostr(ord(str[i])+ri),3)+fillstr(inttostr(ri),3);
   end;
   for i:=1 to length(str1) do
   begin
      if str1[i]='0' then
         str2:=str2+'S'
      else if str1[i]='1' then
         str2:=str2+'W'
      else if str1[i]='2' then
         str2:=str2+'T'
      else if str1[i]='3' then
         str2:=str2+'U'
      else if str1[i]='4' then
         str2:=str2+'J'
      else if str1[i]='5' then
         str2:=str2+'M'
      else if str1[i]='6' then
         str2:=str2+'C'
      else if str1[i]='7' then
         str2:=str2+'A'
      else if str1[i]='8' then
         str2:=str2+'E'
      else if str1[i]='9' then
         str2:=str2+'O'
   end;
   randomize;
   a:=65+random(25);
   randomize;
   b:=65+random(25);
   randomize;
   c:=65+random(25);
   Result:=chr(c)+str2+chr(a)+chr(b);
end;

Function Destr1(str:string):string;
var
i,ri,j,k:integer;
str1,str2:string;
begin
   if length(str)=0 then
   begin
      Result:='';
      Exit;
   end;
   str1:=copy(str,2,length(str)-3);
   //showmessage(str1);
   for i:=1 to length(str1) do
   begin
      if str1[i]='S' then
         str2:=str2+'0'
      else if str1[i]='W' then
         str2:=str2+'1'
      else if str1[i]='T' then
         str2:=str2+'2'
      else if str1[i]='U' then
         str2:=str2+'3'
      else if str1[i]='J' then
         str2:=str2+'4'
      else if str1[i]='M' then
         str2:=str2+'5'
      else if str1[i]='C' then
         str2:=str2+'6'
      else if str1[i]='A' then
         str2:=str2+'7'
      else if str1[i]='E' then
         str2:=str2+'8'
      else if str1[i]='O' then
         str2:=str2+'9'
   end;
   //showmessage(str2);
   str1:='';
   k:=1;
   for i:=1 to length(str2) do
   begin
      if (i mod 6 =0) then
      begin
         str1:=str1+chr(strtoint(copy(str2,k,3))-strtoint(copy(str2,k+3,3)));
         //showmessage(copy(str1,k,3)+';'+copy(str1,k+3,3));
         k:=i+1;
      end;
   end;
   Result:=str1;
end;

end.
