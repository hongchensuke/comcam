unit Cammain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, AviWriter_2, Spin, Buttons, vfw,
  Videocap, ColorGrd,registry, Mask,math,jpeg, VCLUnZip, VCLZip,
  ToolWin, RzTabs, IdMessage, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase,
  IdNNTP, IdSMTP, inifiles,IdAttachmentFile,
  DateUtils, IdPOP3,ShlObj,FileCtrl,URLMon,WinInet,
  DSPack, Tlhelp32, RzPanel;

type
  TmainForm = class(TForm)
    capfontFod: TFontDialog;
    timefontFod: TFontDialog;
    mainboardRPCtr: TRzPageControl;
    videoshowTS: TRzTabSheet;
    settingTS: TRzTabSheet;
    whImg: TImage;
    viewImg: TImage;
    savejpgSDg: TSaveDialog;
    musicpathODg: TOpenDialog;
    camaddrfontFod: TFontDialog;
    softsetRPCtr: TRzPageControl;
    basset: TRzTabSheet;
    frawidLbl: TLabel;
    fraheiLbl: TLabel;
    commacLbl: TLabel;
    comquaLbl: TLabel;
    savepathLbl: TLabel;
    capfontLbl: TLabel;
    cappoLbl: TLabel;
    capxLbl: TLabel;
    capyLbl: TLabel;
    captextLbl: TLabel;
    timefontLbl: TLabel;
    timepoLbl: TLabel;
    timexLbl: TLabel;
    timeyLbl: TLabel;
    smtpLbl: TLabel;
    mailuserLbl: TLabel;
    mailpasswordLbl: TLabel;
    smtpporttxtLbl: TLabel;
    recuserLbl: TLabel;
    pop3Lbl: TLabel;
    pop3porttxtLbl: TLabel;
    softskinLbl: TLabel;
    savedaysbLbl: TLabel;
    savedayseLbl: TLabel;
    camnameLbl: TLabel;
    alapiclastbLbl: TLabel;
    alapiclasteLbl: TLabel;
    filepasswordLbl: TLabel;
    musicpathLbl: TLabel;
    camaddrLbl: TLabel;
    camaddrfontLbl: TLabel;
    camaddrfontpoLbl: TLabel;
    camaddrxLbl: TLabel;
    camaddryLbl: TLabel;
    frawidSdt: TSpinEdit;
    fraheiSdt: TSpinEdit;
    commacCob: TComboBox;
    camproynCkb: TCheckBox;
    comquaCob: TComboBox;
    flycomynCkb: TCheckBox;
    savepathEdt: TEdit;
    savepathBtn: TBitBtn;
    timeynCkb: TCheckBox;
    capynCkb: TCheckBox;
    capxSdt: TSpinEdit;
    capySdt: TSpinEdit;
    captextEdt: TEdit;
    timexSdt: TSpinEdit;
    timeySdt: TSpinEdit;
    capfontBtn: TBitBtn;
    timefontBtn: TBitBtn;
    videosaveynCkb: TCheckBox;
    softstartynCkb: TCheckBox;
    mostartynCkb: TCheckBox;
    campdproynCkb: TCheckBox;
    fresoftBtn: TBitBtn;
    mailuserEdt: TEdit;
    mailpasswordMdt: TMaskEdit;
    smtpporttxtEdt: TEdit;
    recuserEdt: TEdit;
    pop3porttxtEdt: TEdit;
    smtptxtEdt: TComboBox;
    pop3txtEdt: TComboBox;
    softskinCob: TComboBox;
    savedaysCob: TComboBox;
    camnameCoB: TComboBox;
    sendalapicynCkb: TCheckBox;
    alapiclastEdt: TEdit;
    alaynCkb: TCheckBox;
    filepasswordMdt: TMaskEdit;
    musicpathEdt: TEdit;
    musicpathBtn: TBitBtn;
    alamusicynCkb: TCheckBox;
    alamsgynCkb: TCheckBox;
    camaddrEdt: TEdit;
    camaddrynCkB: TCheckBox;
    camaddrxSdt: TSpinEdit;
    camaddrySdt: TSpinEdit;
    camaddrfontBtn: TBitBtn;
    alaset: TRzTabSheet;
    poselImg: TImage;
    poselLbl: TLabel;
    poselxLbl: TLabel;
    poselyLbl: TLabel;
    poheiLbl: TLabel;
    powidLbl: TLabel;
    alasetLbl: TLabel;
    turnquaLbl: TLabel;
    turnquavLbl: TLabel;
    Label1: TLabel;
    tempImg: TImage;
    Label3: TLabel;
    Label5: TLabel;
    poselBtn: TBitBtn;
    poselxSdt: TSpinEdit;
    poselySdt: TSpinEdit;
    poheiEdt: TEdit;
    powidEdt: TEdit;
    turnquaTcb: TTrackBar;
    alamodelCoB: TComboBox;
    setMemo: TMemo;
    RzPanel1: TRzPanel;
    monitorstaImg: TImage;
    monitorstaSBt: TSpeedButton;
    savebmpImg: TImage;
    savebmpSBt: TSpeedButton;
    monitorstopImg: TImage;
    monitorstopSBt: TSpeedButton;
    spgetbmpstopImg: TImage;
    spgetbmpstaImg: TImage;
    spgetbmpSBt: TSpeedButton;
    RzPanel2: TRzPanel;
    resetImg: TImage;
    resetSBt: TSpeedButton;
    settingsaveImg: TImage;
    settingsaveSBt: TSpeedButton;
    alamode: TRzPageControl;
    simmode: TRzTabSheet;
    higmode: TRzTabSheet;
    blueturnLbl: TLabel;
    blueturnvLbl: TLabel;
    greenturnLbl: TLabel;
    greenturnvLbl: TLabel;
    redturnLbl: TLabel;
    redturnvLbl: TLabel;
    blueturnTcb: TTrackBar;
    greenturnTcb: TTrackBar;
    redturnTcb: TTrackBar;
    pointturnLbl: TLabel;
    pointturnvLbl: TLabel;
    pointturnTcb: TTrackBar;
    copysetBtn: TSpeedButton;
    Image1: TImage;
    vioceynCkb: TCheckBox;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label4: TLabel;
    DateTimePicker2: TDateTimePicker;
    alastrlistLB: TListBox;
    alastrlistaddBtn: TBitBtn;
    alastrlistsaveBtn: TBitBtn;
    alastrlistdeleteBtn: TBitBtn;
    camorderynCkb: TCheckBox;
    scrtimebLbl: TLabel;
    scrtimeCob: TComboBox;
    scrtimeeLbl: TLabel;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);  //获取摄像头图片
    procedure capfontBtnClick(Sender: TObject);
    procedure timefontBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure poselBtnClick(Sender: TObject);
    procedure blueturnTcbChange(Sender: TObject);
    procedure greenturnTcbChange(Sender: TObject);
    procedure redturnTcbChange(Sender: TObject);
    procedure turnquaTcbChange(Sender: TObject);
    procedure Label1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure savebmpSBtClick(Sender: TObject);
    procedure monitorstopSBtClick(Sender: TObject);
    procedure settingsaveSBtClick(Sender: TObject);
    procedure backgroundImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure resetSBtClick(Sender: TObject);
    procedure savepathBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fresoftBtnClick(Sender: TObject);
    procedure smtptxtEdtChange(Sender: TObject);
    procedure pop3txtEdtChange(Sender: TObject);
    procedure powidEdtKeyPress(Sender: TObject; var Key: Char);
    procedure poheiEdtKeyPress(Sender: TObject; var Key: Char);
    procedure poselxSdtChange(Sender: TObject);
    procedure poselySdtChange(Sender: TObject);
    procedure musicpathBtnClick(Sender: TObject);
    procedure alamusicynCkbClick(Sender: TObject);
    procedure spgetbmpSBtClick(Sender: TObject);
    procedure softskinCobChange(Sender: TObject);
    procedure savedaysCobKeyPress(Sender: TObject; var Key: Char);
    procedure mainboardRPCtrClose(Sender: TObject;
      var AllowClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure monitorstaSBtClick(Sender: TObject);
    procedure camaddrfontBtnClick(Sender: TObject);
    procedure copysetBtnClick(Sender: TObject);
    procedure alamodelCoBChange(Sender: TObject);
    procedure pointturnTcbChange(Sender: TObject);
    procedure softsetRPCtrChange(Sender: TObject);
    procedure mainboardRPCtrChange(Sender: TObject);
    procedure alasetEnter(Sender: TObject);
    procedure alastrlistaddBtnClick(Sender: TObject);
    procedure alastrlistsaveBtnClick(Sender: TObject);
    procedure alastrlistLBClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;
  tempbitmap:Tbitmap;             //选择区域时的暂存图片
  ptOld:TPoint;                   //选择区域时的旧点
//  rOld:TRect;                     //选择区域时的旧画布
  getpoyn:boolean;                //是否已经开始选择图片区域
  camproi:integer;
  showyn:boolean;                //是否已经显示
implementation

uses controlpas,md5,EnDestr,tdrmcammain, PBar, alamsg, reg;

{$R *.dfm}

procedure TmainForm.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
if not(key in['0'..'9'])then
   key:=#0;
end;

procedure TmainForm.capfontBtnClick(Sender: TObject);
begin
capfontFod.Execute;
end;

procedure TmainForm.timefontBtnClick(Sender: TObject);
begin
timefontFod.Execute;
end;


procedure TmainForm.FormCreate(Sender: TObject);
begin
  getpoyn:=false;
  tempbitmap:=tbitmap.Create;
  viewImg.Parent.DoubleBuffered:=true;
end;

procedure TmainForm.poselBtnClick(Sender: TObject);
begin
   if campro[camproi].isload  then
   begin
      if poselBtn.Caption='开始选择' then
      with campro[camproi] do
      begin
         if frawid>=frahei then
         begin
            if frawid<poselImg.Width then
            begin
            Label1.Width:=frawid;
            poselImg.Width:=frawid;
            end;
            Label1.Height:=floor(frahei*poselImg.Width/frawid);
            poselImg.Height:=floor(frahei*poselImg.Width/frawid);
         end
         else
         begin
            if frahei<poselImg.Height then
            begin
            Label1.Height:=frahei;
            poselImg.Height:=frahei;
            end;
            Label1.Width:=floor(frawid*poselImg.Height/frahei);
            poselImg.Width:=floor(frawid*poselImg.Height/frahei);
         end;
         Label1.Left:=floor((336-Label1.Width)/2);
         poselImg.Left:=floor((336-Label1.Width)/2);
         Label1.Top:=floor((249-Label1.Height)/2);
         poselImg.Top:=floor((249-Label1.Height)/2);
         tempbitmap.Assign(bitmap);
         poselImg.Picture.Bitmap.Assign(tempbitmap);
         poselBtn.Caption:='停止选择';
      end
      else
      begin
         poselBtn.Caption:='开始选择';
      end;
   end
   else
   begin
      showmessage('要先打开录像才能获取图片用于定位！');
   end;
end;

procedure TmainForm.blueturnTcbChange(Sender: TObject);
begin
   blueturnvLbl.Caption:=inttostr(blueturnTcb.Position);
end;

procedure TmainForm.greenturnTcbChange(Sender: TObject);
begin
   greenturnvLbl.Caption:=inttostr(greenturnTcb.Position);
end;

procedure TmainForm.redturnTcbChange(Sender: TObject);
begin
   redturnvLbl.Caption:=inttostr(redturnTcb.Position);
end;

procedure TmainForm.turnquaTcbChange(Sender: TObject);
begin
   turnquavLbl.Caption:=inttostr(turnquaTcb.Position)+'%';
end;

procedure TmainForm.Label1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if (poselImg.Picture.Graphic <> nil) and (poselBtn.Caption='停止选择') then
   with campro[camproi] do
   begin
      poselImg.Picture.Bitmap.Assign(tempbitmap);
      Label1.Canvas.Brush.Style:=bsClear;
      Label1.Canvas.Pen.Style:=psDot;
      Label1.Canvas.Pen.Mode:=(pmXor);
      Label1.Canvas.Pen.Color:=clred; //花红色矩形，空心
      poselxSdt.Value:=trunc(X*frawid/poselImg.Width);
      poselySdt.Value:=trunc(Y*frahei/poselImg.Height);
      powidEdt.Text:='0';
      poheiEdt.Text:='0';
      ptOld.X:=X;
      ptOld.Y:=Y;
      getpoyn:=true;
   end;
end;

procedure TmainForm.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
xt,yt:integer;
begin
   if getpoyn and (ssLeft in Shift)then
   with campro[camproi] do
   begin
      if X>Label1.Width then
         xt:=Label1.Width
      else
         xt:=X;
      if Y>Label1.Height then
         yt:=Label1.Height
      else
         yt:=Y;
      if xt>ptOld.X then
         powidEdt.Text:=inttostr(trunc((xt-ptOld.X)*frawid/poselImg.Width)-1)
      else
         xt:=ptOld.X;
      if yt>ptOld.Y then
         poheiEdt.Text:=inttostr(trunc((yt-ptOld.Y)*frahei/poselImg.Height)-1)
      else
         yt:=ptOld.Y;
      Label1.Canvas.Rectangle(rOld);
      Label1.Canvas.Rectangle(ptOld.X,ptOld.Y,xt,yt);
      rOld:=Rect(ptOld.X,ptOld.Y,xt,yt);
   end;
end;

procedure TmainForm.Label1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//   Label1.Canvas.Rectangle(rOld);
   Label1.Canvas.Brush.Style:=bsClear;
   Label1.Canvas.Pen.Style:=psSolid; //当鼠标抬起时把那个矩形画入paintbox
   Label1.Canvas.Pen.Mode:=pmCopy;
   Label1.Canvas.Rectangle(rOld);
   if getpoyn then
      getpoyn:=false;
end;
procedure TmainForm.Timer2Timer(Sender: TObject);
begin

end;

//最小化代码：SendMessage(handle,wm_SysCommand,sc_Minimize,0);
//关闭代码：
   {controlpwdForm.actypeLbl.Caption:='wcloSBt';
   if campdproyn then
      controlpwdForm.ShowModal
   else
      controlpwdForm.controlpwdySBt.Click; }
procedure TmainForm.savebmpSBtClick(Sender: TObject);
var
tempjpg:TJpegImage;
begin
   if not campro[camproi].isload then
   begin
     showmessage('请先启动摄像！');
     Exit;
   end;
   campro[camproi].isload:=false;
   tempjpg:=tjpegimage.Create;
   tempjpg.Assign(viewImg.Picture.Bitmap);
   tempjpg.CompressionQuality:=60;
   tempjpg.Compress;
   campro[camproi].isload:=true;
   if savejpgSDg.Execute then
   begin
   tempjpg.SaveToFile(savejpgSDg.FileName+'.jpg');
   showmessage('截图成功！已经保存到：'+savejpgSDg.FileName+'.jpg。');
   end;
   tempjpg.Free;
end;

procedure TmainForm.monitorstopSBtClick(Sender: TObject);
begin
  try
    tdrmcammainForm.Stopcam(camproi);
  except
  end;
end;

procedure TmainForm.settingsaveSBtClick(Sender: TObject);
begin
   controlpwdForm.actypeLbl.Caption:='settingsaveSBt';
   if campdproyn then
   begin
     if not passhowingyn then
       controlpwdForm.ShowModal;
   end
   else
      controlpwdForm.controlpwdySBt.Click;
end;

procedure TmainForm.backgroundImgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if (ssLeft in Shift) then
   begin
     ReleaseCapture;
     SendMessage(Handle,WM_SYSCOMMAND,SC_MOVE+1,0);
   end;
end;

procedure TmainForm.resetSBtClick(Sender: TObject);
begin
   tdrmcammainForm.PutParatoshow(Timage(tdrmcammainForm.FindComponent('camimage'+inttostr(camproi))));
end;

procedure TmainForm.savepathBtnClick(Sender: TObject);
var
sPath:string;
begin
   if SelectDirectory('选择存放目录：','',sPath) then
   begin
     savepathEdt.Text:=sPath;
     if sPath[length(sPath)]<>'\' then
       savepathEdt.Text:=sPath+'\';
   end;
end;

procedure TmainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   //CanClose := Application.MessageBox('关闭系统将关闭监控！是否要关闭系统？', '关闭系统',MB_OKCANCEL + MB_ICONQUESTION) = IDOK
   //CanClose := controlpwdForm.cloynlbl.Caption='yes';

end;

procedure TmainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  campro[camproi].setshowyn:=false;
  showyn:=false;
end;

procedure TmainForm.fresoftBtnClick(Sender: TObject);
var
sPath,wrongmsg:string;
resfile:TResourceStream;
setstrlist:Tstringlist;
overlyn:boolean;
SMTP: TIdSMTP;
POP3: TIdPOP3;
msgsend: TIdMessage;
smtpconyn,pop3conyn:boolean;
begin
   if not (camproyn or camorderyn) then
   begin
     showmessage('请先开启远程保护或远程指令再释放！');
     Exit;
   end;
   with campro[camproi] do
   begin
     if not (Application.MessageBox('您选择的是远程保护类型！需要邮箱的支持，我们将向您的邮箱和收件人各发送一封确认邮件（该邮件不用回复），是否继续？','是否继续',MB_OKCANCEL + MB_ICONQUESTION) = IDOK) then
       Exit;
     try
       smtpconyn:=false;
       smtp := TIdSMTP.Create(nil);
       smtp.ConnectTimeout:=3000;
       smtp.ReadTimeout:=20000;
       smtp.Host := smtptxt;
       smtp.AuthType :=satdefault;
       smtp.Username := mailuser;
       smtp.Password := mailpassword;
       smtp.Port:=strtoint(smtpporttxt);
       msgsend := TIdMessage.Create(nil);
       if smtptxtEdt.Text='smtp.qq.com' then
       begin
         msgsend.Recipients.EMailAddresses :=recuser+';'+mailuser+'@qq.com';
         msgsend.From.Address := mailuser+'@qq.com';
       end;
       msgsend.Subject := '邮箱验证邮件'; //邮件标题
       msgsend.Body.Text := '此为摄像头软件验证邮件，对应操作是释放单摄像头监控软件保护软件，此邮件不必回复，日期：'+datetimetostr(now); //邮件内容
       smtp.Authenticate;
       smtp.Connect();
       smtp.Send(msgsend);
       smtpconyn:=true;
       smtp.Disconnect;
     except
       smtpconyn:=false;
       smtp.Disconnect;
     end;

     try
       pop3conyn:=false;
       POP3 := TIdPOP3.Create(nil);
       POP3.ConnectTimeout:=3000;
       POP3.ReadTimeout:=20000;
       POP3.Host := pop3txt;       //pop.qq.com
       POP3.Username := mailuser; //用户名
       POP3.Password := mailpassword; //密码
       POP3.Port:=strtoint(pop3porttxt);  //110
       POP3.Connect;//POP3.Login;
       POP3.CheckMessages;
       pop3conyn:=true;
       POP3.Disconnect;
     except
       pop3conyn:=false;
       pop3.Disconnect;
     end;
     POP3.Free;
     smtp.Free;
     msgsend.Free;
     if not smtpconyn then
       wrongmsg:=wrongmsg+'邮箱设置错误，无法连接到SMTP服务器';
     if not pop3conyn then
       wrongmsg:=wrongmsg+'，邮箱设置错误，无法连接到POP3服务器';
     if(length(wrongmsg)>0)then
     begin
       showmessage(wrongmsg+'，请修改好设置重新打开本软件后再进行此操作！');
       Exit;
     end;
   end;
   if smtpconyn and pop3conyn then
   with campro[camproi] do
   begin
     overlyn:=false;
     if SelectDirectory('选择路径：','D:\Root',sPath) then
     begin
        if sPath[length(sPath)]<>'\' then
           sPath:=sPath+'\';
        if fileexists(sPath+'searclo.exe') then
        begin
           overlyn:=true;
           if Deletefile(sPath+'searclo.exe')then
              overlyn:=false;
        end;
        resfile:=TResourceStream.Create(HInstance,'searclo','exefile');
        if not fileexists(sPath+'searclo.exe') then
           resfile.SaveToFile(sPath+'searclo.exe');
        resfile.Free;
        if fileexists(sPath+'camprosoft.dat') then
        begin
           overlyn:=true;
           if Deletefile(sPath+'camprosoft.dat')then
              overlyn:=false;
        end;
        setstrlist:=Tstringlist.Create;
        setstrlist.Add(Enstr1(pop3txt));
        setstrlist.Add(Enstr1(pop3porttxt));
        setstrlist.Add(Enstr1(smtptxt));
        setstrlist.Add(Enstr1(smtpporttxt));
        setstrlist.Add(Enstr1(mailuser));
        setstrlist.Add(Enstr1(mailpassword));
        setstrlist.SaveToFile(sPath+'camprosoft.dat');
        setstrlist.Free;
     end;
     if overlyn then
     begin
        showmessage('覆盖失败！请检查该目录下searclo.exe和camprosoft.dat是否被占用！');
        Exit;
     end;
     if fileexists(sPath+'searclo.exe')and fileexists(sPath+'camprosoft.dat') then
        showmessage('释放成功！')
     else
        showmessage('释放失败！');
   end;
end;

procedure TmainForm.smtptxtEdtChange(Sender: TObject);
begin
  if smtptxtEdt.Text='smtp.qq.com' then
    smtpporttxtEdt.Text:='25';
end;

procedure TmainForm.pop3txtEdtChange(Sender: TObject);
begin
  if pop3txtEdt.Text='pop.qq.com' then
    pop3porttxtEdt.Text:='110';
end;

procedure TmainForm.powidEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if  not (key in['0'..'9']) then
    key:=#0;
end;

procedure TmainForm.poheiEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in['0'..'9']) then
    key:=#0;
end;

procedure TmainForm.poselxSdtChange(Sender: TObject);
begin
   if poselxSdt.Value<0 then
     poselxSdt.Value:=0;
end;

procedure TmainForm.poselySdtChange(Sender: TObject);
begin
  if poselySdt.Value<0 then
     poselySdt.Value:=0;
end;

procedure TmainForm.musicpathBtnClick(Sender: TObject);
begin
  musicpathODg.filter:='MP3文件(*.mp3)|*.mp3';//selpicOpg.filter:='Windows位图(*.bmp)|*.bmp|JPG图片(*.jpg)|*.jpg';
  musicpathODg.FileName:=campro[camproi].musicpath;
  if musicpathODg.Execute then
    musicpathEdt.Text:=musicpathODg.FileName;
end;

procedure TmainForm.alamusicynCkbClick(Sender: TObject);
begin
  if alamusicynCkb.Checked then
     alamsgynCkb.Checked:=true;
end;

procedure TmainForm.spgetbmpSBtClick(Sender: TObject);
begin
  if not campro[camproi].isload then
  begin
    showmessage('请先启动摄像！');
    Exit;
  end;
  spgetbmp:=not spgetbmp;
  if spgetbmp then
  with campro[camproi] do
  begin
  spgetbmppath:=todaypath+formatdatetime('yyyymmddhhnnss',now)+'\';
  if not DirectoryExists(spgetbmppath) then
    ForceDirectories(spgetbmppath);
  end;
  if spgetbmp then
  begin
    spgetbmpstopImg.Visible:=true;
    spgetbmpstaImg.Visible:=false;
  end
  else
  begin
    spgetbmpstopImg.Visible:=false;
    spgetbmpstaImg.Visible:=true;
  end;
end;

procedure TmainForm.softskinCobChange(Sender: TObject);
var
titletype:string;
resfile:TResourceStream;
jpgfile:TJpegImage;
colortype:Tcolor;
begin
  {if softskinCob.ItemIndex=0 then
  begin
    titletype:='green';
    colortype:=RGB(197,238,196);
  end
  else if softskinCob.ItemIndex=1 then
  begin
    titletype:='blue';
    colortype:=RGB(211,239,249);
  end
  else if softskinCob.ItemIndex=2 then
  begin
    titletype:='red';
    colortype:=RGB(236,234,211);
  end
  else if softskinCob.ItemIndex=3 then
  begin
    titletype:='gray';
    colortype:=RGB(219,219,219);
  end
  else
  begin
    titletype:='blue';
    colortype:=RGB(211,239,249);
  end;
  mainboardRPCtr.Color:=colortype;
  videoshowTS.Color:=colortype;
  settingTS.Color:=colortype;
  alasettingTS.Color:=colortype;
  controlpwdForm.Color:=colortype;
  alamsgForm.Color:=colortype;
  PBarForm.Color:=colortype;
  regForm.Color:=colortype;
  alamsgForm.msgMemo.Color:=colortype;
  regForm.msgMemo.Color:=colortype;
  resfile:=TResourceStream.Create(HInstance,titletype+'allin','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
//  backgroundImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'reset','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  resetImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'save','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  settingsaveImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'savebmp','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  savebmpImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'start','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  monitorstaImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'stop','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  monitorstopImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'ok','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  alamsgForm.okImg.Picture.Bitmap.Assign(jpgfile);
  regForm.okImg.Picture.Bitmap.Assign(jpgfile);
  controlpwdForm.controlpwdyImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'cancel','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  controlpwdForm.controlpwdnImg.Picture.Bitmap.Assign(jpgfile);
  regForm.cancelImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'spgetbmpsta','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  spgetbmpstaImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'spgetbmpstop','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  spgetbmpstopImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;
  resfile:=TResourceStream.Create(HInstance,titletype+'getreg','jpgfile');
  jpgfile:=TJpegImage.Create;
  jpgfile.LoadFromStream(resfile);
  regForm.getregImg.Picture.Bitmap.Assign(jpgfile);
  jpgfile.Free;
  resfile.Free;}
end;

procedure TmainForm.savedaysCobKeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9']) then
    key:=#0;
end;

procedure TmainForm.mainboardRPCtrClose(Sender: TObject;
  var AllowClose: Boolean);
begin
  {controlpwdForm.actypeLbl.Caption:='wcloSBt';
  if campdproyn then
    controlpwdForm.ShowModal
  else
    controlpwdForm.controlpwdySBt.Click;}
  campro[camproi].setshowyn:=false;
  Self.Close;
end;

procedure TmainForm.FormShow(Sender: TObject);
begin
  showyn:=true;
  alamode.Pages[0].TabVisible:=false;
  alamode.Pages[1].TabVisible:=false;
  if camproi<>0 then
  begin
    campdproynCkb.Enabled:=false;
    vioceynCkb.Enabled:=false;
    softstartynCkb.Enabled:=false;
    softskinCob.Enabled:=false;
    softskinLbl.Enabled:=false;
    scrtimeCob.Enabled:=false;
    scrtimebLbl.Enabled:=false;
    scrtimeeLbl.Enabled:=false;
    camproynCkb.Enabled:=false;
    camorderynCkb.Enabled:=false;
    fresoftBtn.Enabled:=false;
    savepathLbl.Enabled:=false;
    savepathEdt.Enabled:=false;
    savepathBtn.Enabled:=false;
    camnameCoB.Enabled:=true;
    camnameLbl.Enabled:=true;
    copysetBtn.Visible:=true;
    viewImg.Picture.Bitmap.Assign(tdrmcammainForm.nowkImg.Picture.Bitmap);
    mainboardRPCtr.Pages[0].TabVisible:=true;
    mainboardRPCtr.Pages[1].TabVisible:=true;
    videoshowTS.Show;
  end
  else
  begin
    campdproynCkb.Enabled:=true;
    vioceynCkb.Enabled:=true;
    softstartynCkb.Enabled:=true;
    softskinCob.Enabled:=true;
    softskinLbl.Enabled:=true;
    scrtimeCob.Enabled:=true;
    scrtimebLbl.Enabled:=true;
    scrtimeeLbl.Enabled:=true;
    camproynCkb.Enabled:=true;
    camorderynCkb.Enabled:=true;
    fresoftBtn.Enabled:=true;
    savepathLbl.Enabled:=true;
    savepathEdt.Enabled:=true;
    savepathBtn.Enabled:=true;
    camnameCoB.Enabled:=false;
    camnameLbl.Enabled:=false;
    copysetBtn.Visible:=false;
    mainboardRPCtr.Pages[0].TabVisible:=false;
    mainboardRPCtr.Pages[1].TabVisible:=false;
    settingTS.Show;
  end;
end;

procedure TmainForm.monitorstaSBtClick(Sender: TObject);
var
campwdindex,campwdindexleft:integer;
begin
  tdrmcammainForm.Startcam(camproi);
end;

procedure TmainForm.camaddrfontBtnClick(Sender: TObject);
begin
  camaddrfontFod.Execute;
end;

procedure TmainForm.copysetBtnClick(Sender: TObject);
begin
  if campro[camproi].isload then
  begin
    showmessage('停止摄像后才能复制！');
    Exit;
  end;
  campro[37]:=campro[camproi];
  campro[camproi]:=campro[0];
  tdrmcammainForm.PutParatoshow(Timage(tdrmcammainForm.FindComponent('camimage'+inttostr(camproi))));
  campro[camproi]:=campro[37];
end;

procedure TmainForm.alamodelCoBChange(Sender: TObject);
begin
  if alamodelCoB.ItemIndex=0 then
    simmode.Show
  else
    higmode.Show;
end;

procedure TmainForm.pointturnTcbChange(Sender: TObject);
begin
  pointturnvLbl.Caption:=inttostr(pointturnTcb.Position)+'%';
end;

procedure TmainForm.softsetRPCtrChange(Sender: TObject);
begin
  if softsetRPCtr.TabIndex=1 then
  begin
    alamodelCoBChange(nil);
    alastrlistLBClick(nil);
  end;
end;

procedure TmainForm.mainboardRPCtrChange(Sender: TObject);
begin
  if mainboardRPCtr.TabIndex=1 then
    basset.Show;
end;

procedure TmainForm.alasetEnter(Sender: TObject);
begin
  if campro[camproi].isload then
  begin
    poselImg.Picture.Bitmap.Assign(tempbitmap);
    //Label1.Canvas.Brush.Style:=bsClear;
    //Label1.Canvas.FillRect(ClientRect);
    with campro[camproi] do
      Label1.Canvas.Rectangle(trunc(poselx*poselImg.Width/frawid)-1,trunc(posely*poselImg.Height/frahei)-1,trunc(powid*poselImg.Width/frawid)-1,trunc(pohei*poselImg.Height/frahei)-1);
  end;
end;

procedure TmainForm.alastrlistaddBtnClick(Sender: TObject);
begin
  alastrlistaddBtn.Hint:='增加';
end;

function getthree(str:string):string;
begin
  if length(str)=1 then
    Result:='00'+str
  else if length(str)=2 then
    Result:='0'+str
  else
    Result:=str;
end;

procedure TmainForm.alastrlistsaveBtnClick(Sender: TObject);
var
i,lsint1,lsint2,ylint1,ylint2:integer;
isin:boolean;
begin
  lsint1:=strtoint(formatdatetime('hhnnss',DateTimePicker1.DateTime));
  lsint2:=strtoint(formatdatetime('hhnnss',DateTimePicker2.DateTime));
  if (lsint1>=lsint2)then
  begin
    showmessage('时间段设置出错，前时间点不能大于等于后时间点！');
    Exit;
  end;
  isin:=false;
  for i:=0 to alastrlistLB.Items.Count-1 do
  begin
    if alastrlistaddBtn.Hint='增加' then
    begin
      ylint1:=strtoint(copy(alastrlistLB.Items.Strings[i],1,6));
      ylint2:=strtoint(copy(alastrlistLB.Items.Strings[i],7,6));
      if ((ylint1<=lsint2)and(ylint2>=lsint2))or((ylint1<=lsint1)and(ylint2>=lsint2))then
      begin
        showmessage('新增区间跟已设置的区间有重叠，请重新调整！');
        Exit;
      end;
    end
    else
    begin
      if i<>alastrlistLB.ItemIndex then
      begin
        ylint1:=strtoint(copy(alastrlistLB.Items.Strings[i],1,6));
        ylint2:=strtoint(copy(alastrlistLB.Items.Strings[i],7,6));
        if ((ylint1<=lsint2)and(ylint2>=lsint2))or((ylint1<=lsint1)and(ylint2>=lsint2))then
        begin
          showmessage('新增区间跟已设置的区间有重叠，请重新调整！');
          Exit;
        end;
      end;
    end
  end;
  if alastrlistaddBtn.Hint='增加' then
  begin
    alastrlistLB.Items.Add(formatdatetime('hhnnss',DateTimePicker1.DateTime)+formatdatetime('hhnnss',DateTimePicker2.DateTime)+inttostr(alamodelCoB.ItemIndex)+getthree(inttostr(turnquaTcb.Position))+getthree(inttostr(pointturnTcb.Position))+getthree(inttostr(redturnTcb.Position))+getthree(inttostr(greenturnTcb.Position))+getthree(inttostr(blueturnTcb.Position)));
    alastrlistaddBtn.Hint:='';
  end
  else
  begin
    //showmessage('修改');
    alastrlistLB.Items.Strings[alastrlistLB.ItemIndex]:=formatdatetime('hhnnss',DateTimePicker1.DateTime)+formatdatetime('hhnnss',DateTimePicker2.DateTime)+inttostr(alamodelCoB.ItemIndex)+getthree(inttostr(turnquaTcb.Position))+getthree(inttostr(pointturnTcb.Position))+getthree(inttostr(redturnTcb.Position))+getthree(inttostr(greenturnTcb.Position))+getthree(inttostr(blueturnTcb.Position));
  end;
end;

procedure TmainForm.alastrlistLBClick(Sender: TObject);
var
lsstr:string;
begin
  lsstr:=alastrlistLB.Items[alastrlistLB.ItemIndex];
  DateTimePicker1.Time:=EncodeTime(strtoint(copy(lsstr,1,2)),strtoint(copy(lsstr,3,2)),strtoint(copy(lsstr,5,2)),0);
  DateTimePicker2.Time:=EncodeTime(strtoint(copy(lsstr,7,2)),strtoint(copy(lsstr,9,2)),strtoint(copy(lsstr,11,2)),0);
  alamodelCoB.ItemIndex:=strtoint(copy(lsstr,13,1));
  alamodelCoBChange(nil);
  turnquaTcb.Position:=strtoint(copy(lsstr,14,3));
  pointturnTcb.Position:=strtoint(copy(lsstr,17,3));
  redturnTcb.Position:=strtoint(copy(lsstr,20,3));
  greenturnTcb.Position:=strtoint(copy(lsstr,23,3));
  blueturnTcb.Position:=strtoint(copy(lsstr,26,3));
end;

initialization
    RegisterClass(TFontDialog);//装入TFontDialog类
end.


