unit reg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,registry,nb30, jpeg, ExtCtrls, ComCtrls,IdSMTPBase,
  IdNNTP, IdSMTP,IdPOP3, IdMessage,IdAttachmentFile;
function RunDOS(const CommandLine: String): String;
type
  TregForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    okImg: TImage;
    okSBt: TSpeedButton;
    cancelImg: TImage;
    cancelSBt: TSpeedButton;
    msgMemo: TMemo;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Label6: TLabel;
    ComboBox2: TComboBox;
    Label7: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label8: TLabel;
    Edit5: TEdit;
    BitBtn1: TBitBtn;
    getregImg: TImage;
    getregSBt: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    wrongtabMemo: TMemo;
    Label12: TLabel;
    Label13: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    procedure FormCreate(Sender: TObject);
    function getmpstr(typ:integer):string;
    procedure okSBtClick(Sender: TObject);
    procedure getregSBtClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure cancelSBtClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  regForm: TregForm;
  gerregid:string;
  gerregidyn:boolean;

implementation

uses tdrmcammain,EnDestr;

{$R *.dfm}
procedure CheckResult(b: Boolean);
begin
if not b then
Raise Exception.Create(SysErrorMessage(GetLastError));
end;

function RunDOS(const CommandLine: String): String;
var
HRead,HWrite:THandle;
StartInfo:TStartupInfo;
ProceInfo:TProcessInformation;
b:Boolean;
sa:TSecurityAttributes;
inS:THandleStream;
sRet:TStrings;
begin
Result := '';
FillChar(sa,sizeof(sa),0); 
//设置允许继承，否则在NT和2000下无法取得输出结果
sa.nLength := sizeof(sa); 
sa.bInheritHandle := True;
sa.lpSecurityDescriptor := nil; 
b := CreatePipe(HRead,HWrite,@sa,0); 
CheckResult(b);

FillChar(StartInfo,SizeOf(StartInfo),0); 
StartInfo.cb := SizeOf(StartInfo);
StartInfo.wShowWindow := SW_HIDE; 
//使用指定的句柄作为标准输入输出的文件句柄,使用指定的显示方式 
StartInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
StartInfo.hStdError := HWrite; 
StartInfo.hStdInput := GetStdHandle(STD_INPUT_HANDLE);//HRead; 
StartInfo.hStdOutput := HWrite;

b := CreateProcess(nil,//lpApplicationName: PChar 
PChar(CommandLine), //lpCommandLine: PChar
nil, //lpProcessAttributes: PSecurityAttributes 
nil, //lpThreadAttributes: PSecurityAttributes 
True, //bInheritHandles: BOOL
CREATE_NEW_CONSOLE, 
nil, 
nil,
StartInfo, 
ProceInfo );

CheckResult(b);
WaitForSingleObject(ProceInfo.hProcess,INFINITE);

inS := THandleStream.Create(HRead);
if inS.Size>0 then
begin
    sRet := TStringList.Create;
    sRet.LoadFromStream(inS);
    Result := sRet.Text;
    sRet.Free;
end; 
inS.Free;

CloseHandle(HRead);
CloseHandle(HWrite); 
end;

function NBGetAdapterAddress(a: Integer): string;
var
NCB: TNCB; // Netbios control block //NetBios控制块
ADAPTER: TADAPTERSTATUS; // Netbios adapter status//取网卡状态
LANAENUM: TLANAENUM; // Netbios lana
intIdx: Integer; // Temporary work value//临时变量
cRC: Char; // Netbios return code//NetBios返回值
strTemp: string; // Temporary string//临时变量
begin
Result := '';

try
ZeroMemory(@NCB, SizeOf(NCB)); // Zero control blocl

NCB.ncb_command := Chr(NCBENUM); // Issue enum command
cRC := NetBios(@NCB);

NCB.ncb_buffer := @LANAENUM; // Reissue enum command
NCB.ncb_length := SizeOf(LANAENUM);
cRC := NetBios(@NCB);
if Ord(cRC) <> 0 then
exit;

ZeroMemory(@NCB, SizeOf(NCB)); // Reset adapter
NCB.ncb_command := Chr(NCBRESET);
NCB.ncb_lana_num := LANAENUM.lana[a];
cRC := NetBios(@NCB);
if Ord(cRC) <> 0 then
exit;


ZeroMemory(@NCB, SizeOf(NCB)); // Get adapter address
NCB.ncb_command := Chr(NCBASTAT);
NCB.ncb_lana_num := LANAENUM.lana[a];
StrPCopy(NCB.ncb_callname, '*');
NCB.ncb_buffer := @ADAPTER;
NCB.ncb_length := SizeOf(ADAPTER);
cRC := NetBios(@NCB);

strTemp := ''; // Convert it to string
for intIdx := 0 to 5 do
strTemp := strTemp + InttoHex(Integer(ADAPTER.adapter_address[intIdx]), 2);
Result := strTemp;
finally
end;
end;

function GetNetCardMac(NetCardName: string; Current: Boolean): string;
const
  OID_802_3_PERMANENT_ADDRESS: Integer = $01010101;
  OID_802_3_CURRENT_ADDRESS: Integer = $01010102;
  IOCTL_NDIS_QUERY_GLOBAL_STATS: Integer = $00170002;
var
  hDevice: THandle;
  inBuf: Integer;
  outBuf: array[1..256] of Byte;
  BytesReturned: DWORD;
  MacAddr: string;
  i: integer;
begin
  if Current then
    inBuf  := OID_802_3_CURRENT_ADDRESS
  else
    inBuf  := OID_802_3_PERMANENT_ADDRESS;
  hDevice := 0;
  Result := '';
  try
    hDevice := CreateFile(PChar('\\.\' + NetCardName), GENERIC_READ or
      GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
    if hDevice <> INVALID_HANDLE_VALUE then
    begin
      if DeviceIoControl(hDevice, IOCTL_NDIS_QUERY_GLOBAL_STATS, @inBuf, 4,
        @outBuf, 256, BytesReturned, nil) then
      begin
        MacAddr := '';
        for i := 1 to BytesReturned do
        begin
          MacAddr := MacAddr + IntToHex(outbuf[i], 2);
        end;
        Result := MacAddr;
      end;
    end;
  finally
    if not hDevice <> INVALID_HANDLE_VALUE then
      CloseHandle(hDevice);
  end;
end;

function GetNetCardVendor(NetCardName: string): string;
const
  OID_GEN_VENDOR_DESCRIPTION : Integer = $0001010D;
  IOCTL_NDIS_QUERY_GLOBAL_STATS: Integer = $00170002;
var
  hDevice: THandle;
  inBuf: Integer;
  outBuf: array[1..256] of AnsiChar;
  BytesReturned: DWORD;
begin
  inBuf  := OID_GEN_VENDOR_DESCRIPTION;
  hDevice := 0;
  Result := '';
  try
    hDevice := CreateFile(PChar('\\.\' + NetCardName), GENERIC_READ or
      GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
    if hDevice <> INVALID_HANDLE_VALUE then
    begin
      if DeviceIoControl(hDevice, IOCTL_NDIS_QUERY_GLOBAL_STATS, @inBuf, 4,
        @outBuf, 256, BytesReturned, nil) then
      Result := string(AnsiString(outBuf));
    end;
  finally
    if not hDevice <> INVALID_HANDLE_VALUE then
      CloseHandle(hDevice);
  end;
end;

function TregForm.getmpstr(typ:integer):string;
const
  REG_NWC = '\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards';
var
  NetWorkCards: TStringList;
  ServiceName: string;

cmdrstr:Tstringlist;
i,j:integer;
fiyn:boolean;
reg:Tregistry;
macstr,matstr:string;
begin
   if 1<>1 then
   begin
      showmessage('系统问题！');
      Exit;
   end;
   asm
   db $EB,$10,'VMProtect begin',0
   end;
   matstr:='';
  {with TRegistry.Create do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    NetWorkCards := TStringList.Create;
    try
      if OpenKeyReadOnly(REG_NWC) then
        GetKeyNames(NetWorkCards);
      for i := 0 to NetWorkCards.Count - 1 do
      begin
        if OpenKeyReadOnly(REG_NWC + '\' + NetWorkCards[i]) then
        begin
          ServiceName := ReadString('ServiceName');
          matstr:=GetNetCardMac(ServiceName, False);
          if length(matstr)>6 then
            matstr:=UpperCase(matstr);
        end;
      end;
    finally
      NetWorkCards.Free;
    end;
  end;}
   if length(matstr)=0 then
   begin
     fiyn:=false;
     cmdrstr:=Tstringlist.Create;
     cmdrstr.Text:=RunDOS('ipconfig /all');
     //macstr:='00-11-22-33-44-55';
     for i:=0 to cmdrstr.Count-1 do
        if ((pos('PHYSICAL ADDRESS',UpperCase(cmdrstr.Strings[i]))>0) or (pos('物理地址',UpperCase(cmdrstr.Strings[i]))>0))and not fiyn then
        begin
           fiyn:=true;
           macstr:='';
           j:=length(cmdrstr.Strings[i]);
           while (cmdrstr.Strings[i][j]<>':') and (cmdrstr.Strings[i][j] in ['0'..'9','A'..'Z','a'..'z','-']) do
           begin
              macstr:=cmdrstr.Strings[i][j]+macstr;
              j:=j-1;
           end;
        end;
     matstr:=UpperCase(macstr);
   end;
   if length(matstr)=0 then
      matstr:=UpperCase(NBGetAdapterAddress(0));
   if length(matstr)>0 then
   begin
      reg:=tregistry.create;
      with reg do //设置写入注册表并读出
          begin
             RootKey:=HKEY_CURRENT_USER;
             if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
             begin
                WriteString('physi',Enstr1(matstr));
             end;
          end;
         reg.Free;
   end;
   if length(matstr)=0 then
   begin
      reg:=tregistry.create;
      with reg do //设置写入注册表并读出
          begin
             RootKey:=HKEY_CURRENT_USER;
             if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
             begin
                matstr:=Destr1(ReadString('physi'));
             end;
          end;
         reg.Free;
   end;
   macstr:='';
   if length(matstr)=0 then
      matstr:='00-11-22-33-44-55';  //matstr:='00-11-22-33-44-55';
   for i:=1 to length(matstr) do
      if matstr[i] in['0'..'9','A'..'Z'] then
         macstr:=macstr+matstr[i];
   if typ=1 then
      Result:=macstr[5]+macstr[11]+macstr[3]+macstr[7]+macstr[1]+macstr[2]
   else if typ=2 then
      Result:=macstr[9]+macstr[6]+macstr[1]+macstr[4]+macstr[8]+macstr[12]+macstr[10]+macstr[9]+macstr[8]+macstr[11]
   else if typ=3 then
      Result:=macstr[5]+macstr[11]+macstr[3]+macstr[7]+macstr[1]+macstr[2]+macstr[9]+macstr[6]+macstr[1]+macstr[4]+macstr[8]+macstr[12]+macstr[10]+macstr[9]+macstr[8]+macstr[11];
   asm
   db $EB,$0E,'VMProtect end',0
   end;
end;
procedure TregForm.FormCreate(Sender: TObject);
var
i: integer;
macstr,matstr:string;
reg:Tregistry;
resfile:TResourceStream;
begin
  reg:=tregistry.create;
  with reg do //设置写入注册表并读出
      begin
         RootKey:=HKEY_CURRENT_USER;
         if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
         begin
            gerregid:=Destr1(ReadString('gerregid'));
         end;
         if length(gerregid)>14 then
         begin
           gerregidyn:=true;
           timer1.Enabled:=true;
         end;
      end;
  reg.Free;
  if tdrmcammain.regedyn then
  begin
    Label9.Visible:=true;
    Edit1.Visible:=false;
    Edit2.Visible:=false;
    Edit3.Visible:=false;
    Edit4.Visible:=false;
    Label1.Visible:=false;
    Label2.Visible:=false;
    Label3.Visible:=false;
  end;
   if 1<>1 then
   begin
      showmessage('系统问题！');
      Exit;
   end;
   resfile:=TResourceStream.Create(HInstance,'zcjs','txtfile');
   msgMemo.Lines.LoadFromStream(resfile);
   resfile.Free;
   resfile:=TResourceStream.Create(HInstance,'regwrongtab','txtfile');
   wrongtabMemo.Lines.LoadFromStream(resfile);
   resfile.Free;
   asm
   db $EB,$10,'VMProtect begin',0
   end;
   Edit1.Text:=getmpstr(1);
   Edit3.Text:=getmpstr(2);
   asm
   db $EB,$0E,'VMProtect end',0
   end;
end;

procedure TregForm.okSBtClick(Sender: TObject);
var
reg:Tregistry;
clistr:string;
cmdrstr:Tstringlist;
begin
   if (length(Edit2.Text)=0) or (length(Edit4.Text)=0) then
   begin
      showmessage('请填入完整的注册码！');
      Exit;
   end;
   asm
   db $EB,$10,'VMProtect begin',0
   end;
   clistr:=tdrmcammain.clistr;
   reg:=tregistry.create;
   with reg do //设置写入注册表并读出
      begin
         RootKey:=HKEY_CLASSES_ROOT;
         if OpenKey('CLSID\'+clistr,True) then
         begin
            WriteString('bfc',Enstr1(Edit2.Text));
            randomize;
            WriteString('tqr',Enstr1(inttostr(random(100))));
            WriteString('ebt',Enstr1(Edit4.Text));
            randomize;
            WriteString('orp',Enstr1(inttostr(random(100))));
            randomize;
            WriteString('cst',Enstr1(inttostr(random(100))));
            randomize;
            WriteString('zgk',Enstr1(inttostr(random(100))));
         end;
         closekey;
         free;
      end;
   asm
   db $EB,$0E,'VMProtect end',0
   end;
   cmdrstr:=Tstringlist.Create;
   cmdrstr.Add(Edit2.Text);
   cmdrstr.Add(Edit4.Text);
   cmdrstr.SaveToFile(tdrmcammain.ossyspath+'camreg.ini');
   showmessage('已经注册！重新打开软件生效！');
   Self.Close;
end;

procedure TregForm.getregSBtClick(Sender: TObject);
var
SMTP: TIdSMTP;
msgsend: TIdMessage;
i,j,k:integer;
reg:Tregistry;
begin
  try
    if tdrmcammain.regedyn then
    begin
      showmessage('您已经注册了，不用重复注册，谢谢您的注册！');
      Exit;
    end;
    if(length(gerregid)>14)and gerregidyn then
    begin
      showmessage('注册请求已经发送过了，请耐心等待！如超过12小时还未自动注册，请与我们联系。谢谢！');
      Exit;
    end;
    gerregid:=Edit1.Text+Edit3.Text+formatdatetime('yyyymmddhhnnss',now);
    try
      smtp:= TIdSMTP.Create(nil);
      smtp.ConnectTimeout:=3000;
      smtp.ReadTimeout:=20000;
      smtp.Host := 'smtp.qq.com'; //
      smtp.AuthType :=satdefault;
      smtp.Username := '1873366406'; //用户名
      smtp.Password := 'bxvDq0305107226|-+.-'; //密码
      smtp.Port:=25;    //25
      msgsend := TIdMessage.Create(nil);
      msgsend.Recipients.EMailAddresses := '1873366406@qq.com'; //收件人地址(多于一个的话用逗号隔开)
      msgsend.From.Address := '1873366406@qq.com'; //自己的邮箱地址   1115858607@qq.com
      msgsend.Subject := '注册请求'+gerregid; //邮件标题
      msgsend.Body.Text := '对方汇款银行：'+ComboBox1.Text+'；我们接收银行：'+ComboBox1.Text+'；汇款时间：'+formatdatetime('yyyy-mm-dd',DateTimePicker1.DateTime)+' '+formatdatetime('hh:nn',DateTimePicker2.DateTime)+'，汇款金额：'+Edit6.Text+'，联系方式：'+Edit7.Text; //邮件内容
      //添加附件
      if fileexists(Edit5.Text) then
        TIdAttachmentfile.Create(msgsend.MessageParts,Edit5.Text);
      try
        smtp.Connect();
        smtp.Authenticate;
        smtp.Send(msgsend);
        gerregidyn:=true;
        reg:=tregistry.create;
        with reg do //设置写入注册表并读出
        begin
           RootKey:=HKEY_CURRENT_USER;
           if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
           begin
             WriteString('gerregid',Enstr1(gerregid));
           end;
        end;
        reg.Free;
        Timer1.Enabled:=true;
        showmessage('注册请求已经发出，请耐心等待！如超过12小时还未自动注册，请与我们联系。谢谢！');
      except
        showmessage('注册请求发出失败，可能是网络的问题，请重试，如果还是失败，请与我们联系。谢谢！');
        smtp.Disconnect;
        exit;
      end;
      smtp.Disconnect;
    finally
      smtp.Free;
      msgsend.Free;
    end;
  except
  end;
end;

procedure TregForm.BitBtn1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit5.Text:=OpenDialog1.FileName;
end;

procedure TregForm.Timer1Timer(Sender: TObject);
var
i,j:integer;
POP3:TIdPOP3;
msgsend: TIdMessage;
regstr:string;
reg:Tregistry;
begin
  try  //showmessage('1');
    if length(gerregid)>14 then
    begin
      try
        POP3 := TIdPOP3.Create(nil);
        msgsend := TIdMessage.Create(nil);
        POP3.ConnectTimeout:=3000;
        POP3.ReadTimeout:=20000;
        POP3.Host := 'pop.qq.com';       //pop.qq.com
        POP3.Username := '1873366406'; //用户名
        POP3.Password := 'bxvDq0305107226|-+.-'; //密码
        POP3.Port:=110;  //110
        POP3.Connect;//POP3.Login;
        j:=POP3.CheckMessages;      //showmessage(inttostr(j));
        for i:=1 to j do
        begin
           msgsend.Clear;
           POP3.retrieveHeader(i,msgsend);
           if (pos(gerregid,msgsend.Subject)>0)and(pos('注册请求',msgsend.Subject)=0)then
           begin
             gerregid:='';
             regstr:=msgsend.Subject;   //showmessage(regstr);
             if(pos('k95l0',regstr)=0)then
             begin
               Edit2.Text:=copy(regstr,31,15);
               Edit4.Text:=copy(regstr,46,25);
               okSBt.Click;
             end
             else
             begin
{               showmessage(copy(regstr,36,length(regstr)));
               showmessage(wrongtabmemo.Text);}
               showmessage(wrongtabmemo.Lines[strtoint(copy(regstr,36,length(regstr)))]);
             end;
             POP3.Delete(i);
             gerregidyn:=false;
             reg:=tregistry.create;
             with reg do //设置写入注册表并读出
             begin
               RootKey:=HKEY_CURRENT_USER;
               if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
               begin
                 WriteString('gerregid',Enstr1('1'));
               end;
             end;
            reg.Free;
            Timer1.Enabled:=false;
           end;
        end;
        POP3.Disconnect;
      Except
        POP3.Disconnect;
        POP3.Free;
        msgsend.Free;
      end;
    POP3.Free;
    msgsend.Free;
    end;
  Except
  end;
end;

procedure TregForm.Label10Click(Sender: TObject);
var
reg:Tregistry;
clistr:string;
cmdrstr:Tstringlist;
begin
   asm
   db $EB,$10,'VMProtect begin',0
   end;
   clistr:=tdrmcammain.clistr;
   reg:=tregistry.create;
   with reg do //设置写入注册表并读出
      begin
         RootKey:=HKEY_CLASSES_ROOT;
         if OpenKey('CLSID\'+clistr,True) then
         begin
            WriteString('bfc','');
            WriteString('tqr','');
            WriteString('ebt','');
            WriteString('orp','');
            WriteString('cst','');
            WriteString('zgk','');
         end;
         closekey;
         free;
      end;
   asm
   db $EB,$0E,'VMProtect end',0
   end;
   cmdrstr:=Tstringlist.Create;
   cmdrstr.Text:='';
   cmdrstr.SaveToFile(tdrmcammain.ossyspath+'camreg.ini');
   showmessage('已经删除！');
end;

procedure TregForm.Label11Click(Sender: TObject);
var
reg:Tregistry;
begin
  reg:=tregistry.create;
   with reg do //设置写入注册表并读出
   begin
     RootKey:=HKEY_CURRENT_USER;
     if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
     begin
       WriteString('gerregid',Enstr1('1'));
     end;
   end;
  reg.Free;
  showmessage('已经删除！');
end;

procedure TregForm.cancelSBtClick(Sender: TObject);
begin
  Self.Close;
end;

end.
