unit controlpas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,registry, Mask, jpeg, ExtCtrls, IdSMTPBase,
  IdNNTP, IdSMTP,IdPOP3, IdMessage;

type
  TcontrolpwdForm = class(TForm)
    controlpwdLbl: TLabel;
    controlpwdySBt: TSpeedButton;
    actypeLbl: TLabel;
    controlpwdMdt: TMaskEdit;
    controlpwdyImg: TImage;
    controlpwdnImg: TImage;
    controlpwdnSBt: TSpeedButton;
    cloynlbl: TLabel;
    ncontrolpwdLbl: TLabel;
    ncontrolpwdMdt: TMaskEdit;
    ccontrolpwdLbl: TLabel;
    ccontrolpwdMdt: TMaskEdit;
    procedure controlpwdySBtClick(Sender: TObject);
    procedure controlpwdnSBtClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ncontrolpwdMdtKeyPress(Sender: TObject; var Key: Char);
    procedure controlpwdMdtKeyPress(Sender: TObject; var Key: Char);
    procedure ccontrolpwdMdtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  controlpwdForm: TcontrolpwdForm;
  cpdstr:string;
  passhowingyn:boolean;
  
//  camproi:integer;

implementation

uses EnDestr, tdrmcammain, Cammain;

{$R *.dfm}

procedure TcontrolpwdForm.controlpwdySBtClick(Sender: TObject);
var
wrongmsg,controlpwd:string;
reg:Tregistry;
SMTP: TIdSMTP;
POP3: TIdPOP3;
msgsend: TIdMessage;
smtpconyn,pop3conyn:boolean;
lscamproi:integer;
sendhelpyn:boolean;
begin
   if(actypeLbl.Caption='Modifypwd')then
      controlpwd:=ncontrolpwdMdt.Text
   else
      controlpwd:=controlpwdMdt.Text;
   if campdproyn or (actypeLbl.Caption='Modifypwd')then
   begin
     if(controlpwd<>cpdstr)then
     begin
       showmessage('控制密码错误！');
       Exit;
     end;
   end;
   if(actypeLbl.Caption='settingsaveSBt')then
   begin
     with mainForm,campro[camproi] do
     begin
        smtpconyn:=false;
        pop3conyn:=false;
        wrongmsg:='';
        if(frawidSdt.Value<=0)then
        begin
           wrongmsg:=wrongmsg+'每帧宽度不能小于或等于0';
        end;
        if(fraheiSdt.Value<=0)then
        begin
           wrongmsg:=wrongmsg+'，每帧高度不能小于或等于0';
        end;
        if flycomynCkb.Checked=true then
        begin
           if(length(commacCob.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，解码器不能为空';
           end;
           if(length(comquaCob.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，压缩质量不能为空';
           end;
        end;
        if videosaveynCkb.Checked=true then
        begin
          if(length(savepathEdt.Text)=0)then
          begin
             wrongmsg:=wrongmsg+'，存放目录不能为空';
          end;
        end;
        if capynCkb.Checked=true then
        begin
          if(capxSdt.Value<0)or(capxSdt.Value>frawidSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'，字幕位置X不能小于0，也不能大于每帧宽度';
          end;
          if(capySdt.Value<0)or(capySdt.Value>fraheiSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'，字幕位置Y不能小于0，也不能大于每帧高度';
          end;
        end;
        if(strtoint(savedaysCob.Text)<0)then
        begin
          wrongmsg:=wrongmsg+'，保存期限不能小于0';
        end;
        if timeynCkb.Checked=true then
        begin
          if(timexSdt.Value<0)or(timexSdt.Value>frawidSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'，时间位置X不能小于0，也不能大于每帧宽度';
          end;
          if(timeySdt.Value<0)or(timeySdt.Value>fraheiSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'，时间位置Y不能小于0，也不能大于每帧高度';
          end;
        end;
        if camaddrynCkb.Checked=true then
        begin
          if(camaddrxSdt.Value<0)or(camaddrxSdt.Value>frawidSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'，摄像头地点位置X不能小于0，也不能大于每帧宽度';
          end;
          if(camaddrySdt.Value<0)or(camaddrySdt.Value>fraheiSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'，摄像头地点位置Y不能小于0，也不能大于每帧高度';
          end;
        end;

        if(poselxSdt.Value<0)then
        begin
           wrongmsg:=wrongmsg+'坐标X不能小于0';
        end;
        if(poselySdt.Value<0)then
        begin
           wrongmsg:=wrongmsg+'，坐标Y不能小于0';
        end;
        if(length(powidEdt.Text)=0)or(strtoint(powidEdt.Text)<=0)then
        begin
           wrongmsg:=wrongmsg+'，宽度不能为空且不能小于或等于0';
        end;
        if(length(poheiEdt.Text)=0)or(strtoint(poheiEdt.Text)<=0)then
        begin
           wrongmsg:=wrongmsg+'，高度不能为空且不能小于或等于0';
        end;
        if((poselxSdt.Value+strtoint(powidEdt.Text))>frawidSdt.Value)then
        begin
           wrongmsg:=wrongmsg+'，坐标X与宽度之和不能大于每帧宽度';
        end;
        if((poselySdt.Value+strtoint(poheiEdt.Text))>fraheiSdt.Value)then
        begin
           wrongmsg:=wrongmsg+'，坐标Y与高度之和不能大于每帧高度';
        end;
        if(length(filepasswordMdt.Text)=0)then
        begin
           wrongmsg:=wrongmsg+'，警报压缩文件密码不能为空';
        end;
        if(sendalapicynCkb.Checked=true)then
        begin
           if(length(smtptxtEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，SMTP服务器不能为空';
           end;
{           if(length(pop3txtEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，POP3不能为空';
           end;}
           if(pos('.',smtptxtEdt.Text)=0)then
           wrongmsg:=wrongmsg+'，SMTP服务器输入错误';
           if(pos('.',pop3txtEdt.Text)=0)and(length(pop3txtEdt.Text)>0)and(pop3txtEdt.Text<>'此处填写POP3服务器')then
           wrongmsg:=wrongmsg+'，POP3服务器输入错误';
           if(length(smtpporttxtEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，SMTP端口不能为空';
           end;
{           if(length(pop3porttxtEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，POP3端口不能为空';
           end;}
           if(length(mailuserEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，用户名不能为空';
           end;
           if(length(mailpasswordMdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，密码不能为空';
           end;
           if(pos('@',recuserEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，收件人输入错误';
           end;
        end;

        if(alamusicynCkb.Checked=true)then
          if(length(musicpathEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'，您开启了播放警报音乐，所以音乐路径不能为空';
           end;

        if(length(wrongmsg)=0)and((smtptxtEdt.Text<>smtptxt)or(mailuserEdt.Text<>mailuser)or(mailpasswordMdt.Text<>mailpassword)or(smtpporttxtEdt.Text<>smtpporttxt)or(recuserEdt.Text<>recuser))then
        begin
           try
             //showmessage(smtptxtEdt.Text+':'+smtptxt+'；'+mailuserEdt.Text+':'+mailuser+'；'+mailpasswordMdt.Text+':'+mailpassword+'；'+smtpporttxtEdt.Text+':'+smtpporttxt+'；'+recuserEdt.Text+':'+recuser);
             if not (Application.MessageBox('邮箱设置已经更改，我们将向您的邮箱和收件人各发送一封确认邮件（该邮件不用回复），是否继续？','是否继续',MB_OKCANCEL + MB_ICONQUESTION) = IDOK) then
               Exit;
             smtpconyn:=false;
             smtp := TIdSMTP.Create(nil);
             smtp.ConnectTimeout:=3000;
             smtp.ReadTimeout:=20000;
             smtp.Host := smtptxtEdt.Text;
             smtp.AuthType :=satdefault;
             smtp.Username := mailuserEdt.Text;
             smtp.Password := mailpasswordMdt.Text;
             smtp.Port:=strtoint(smtpporttxtEdt.Text);
             msgsend := TIdMessage.Create(nil);
             if smtptxtEdt.Text='smtp.qq.com' then
             begin
               msgsend.Recipients.EMailAddresses :=recuserEdt.Text+';'+mailuserEdt.Text+'@qq.com';
               msgsend.From.Address := mailuserEdt.Text+'@qq.com';
             end;
             msgsend.Subject := '邮箱验证邮件'; //邮件标题
             msgsend.Body.Text := '此为摄像头软件验证邮件，对应操作是修改软件设置，此邮件不必回复，稍后我们会向收件人发送《监控系统远程指令调用方法》，日期：'+datetimetostr(now); //邮件内容
             smtp.Authenticate;
             smtp.Connect();
             smtp.Send(msgsend);
             smtpconyn:=true;
             smtp.Disconnect;
           except
             smtpconyn:=false;
             smtp.Disconnect;
           end;
           smtp.Free;
           msgsend.Free;
           sendhelpyn:=true;
           if not smtpconyn then
           begin
             sendhelpyn:=false;
             wrongmsg:=wrongmsg+'，邮箱设置错误或网络问题，无法通过SMTP服务器验证';
           end;
        end;
        if(length(wrongmsg)=0)then
        begin
         reg:=tregistry.create;
         with reg do //设置写入注册表并读出
          begin
             RootKey:=HKEY_CURRENT_USER;
             if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
             begin
                 WriteString('frawid'+inttostr(camproi),Enstr1(inttostr(frawidSdt.Value)));
                 WriteString('frahei'+inttostr(camproi),Enstr1(inttostr(fraheiSdt.Value)));
                 if flycomynCkb.Checked=true then
                    WriteString('flycomyn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('flycomyn'+inttostr(camproi),Enstr1('0'));
                 WriteString('commac'+inttostr(camproi),Enstr1(commacCob.Text));
                 WriteString('commaci'+inttostr(camproi),Enstr1(inttostr(commacCob.ItemIndex)));
                 WriteString('comqua'+inttostr(camproi),Enstr1(inttostr(comquaCob.ItemIndex)));
                 if videosaveynCkb.Checked=true then
                    WriteString('videosaveyn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('videosaveyn'+inttostr(camproi),Enstr1('0'));
                 WriteString('savepath',Enstr1(savepathEdt.Text));
                 if camorderynCkb.Checked=true then
                    WriteString('camorderyn',Enstr1('1'))
                 else
                    WriteString('camorderyn',Enstr1('0'));

                 if camproynCkb.Checked=true then
                    WriteString('camproyn',Enstr1('1'))
                 else
                    WriteString('camproyn',Enstr1('0'));
                 if softstartynCkb.Checked=true then
                    WriteString('softstartyn',Enstr1('1'))
                 else
                    WriteString('softstartyn',Enstr1('0'));
                 if mostartynCkb.Checked=true then
                    WriteString('mostartyn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('mostartyn'+inttostr(camproi),Enstr1('0'));
                 if campdproynCkb.Checked=true then
                    WriteString('campdproyn',Enstr1('1'))
                 else
                    WriteString('campdproyn',Enstr1('0'));
                 if vioceynCkb.Checked=true then
                    WriteString('vioceyn',Enstr1('1'))
                 else
                    WriteString('vioceyn',Enstr1('0'));
                 if capynCkb.Checked=true then
                    WriteString('capyn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('capyn'+inttostr(camproi),Enstr1('0'));
                 WriteString('capfont'+inttostr(camproi),Enstr1(tdrmcammainForm.fontTostr(capfontFod.Font)));
                 WriteString('capx'+inttostr(camproi),Enstr1(inttostr(capxSdt.Value)));
                 WriteString('capy'+inttostr(camproi),Enstr1(inttostr(capySdt.Value)));
                 if length(captextEdt.Text)>0 then
                    WriteString('captext'+inttostr(camproi),Enstr1(captextEdt.Text))
                 else
                    WriteString('captext'+inttostr(camproi),Enstr1('请填入字幕'));
                 WriteString('savedays'+inttostr(camproi),Enstr1(savedaysCob.Text));
                 if camaddrynCkb.Checked=true then
                    WriteString('camaddryn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('camaddryn'+inttostr(camproi),Enstr1('0'));
                 WriteString('camaddrfont'+inttostr(camproi),Enstr1(tdrmcammainForm.fontTostr(camaddrfontFod.Font)));
                 WriteString('camaddrx'+inttostr(camproi),Enstr1(inttostr(camaddrxSdt.Value)));
                 WriteString('camaddry'+inttostr(camproi),Enstr1(inttostr(camaddrySdt.Value)));
                 if length(camaddrEdt.Text)>0 then
                    WriteString('camaddr'+inttostr(camproi),Enstr1(camaddrEdt.Text))
                 else
                    WriteString('camaddr'+inttostr(camproi),Enstr1('通道'+formatdatetime('yyyymmddhhnnsszzz',now)));
                 if length(camnameCob.Text)>0 then
                    WriteString('camname'+inttostr(camproi),Enstr1(camnameCob.Text))
                 else
                    WriteString('camname'+inttostr(camproi),Enstr1('没有'));
                 if timeynCkb.Checked=true then
                    WriteString('timeyn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('timeyn'+inttostr(camproi),Enstr1('0'));
                 WriteString('timefont'+inttostr(camproi),Enstr1(tdrmcammainForm.fontTostr(timefontFod.Font)));
                 WriteString('timex'+inttostr(camproi),Enstr1(inttostr(timexSdt.Value)));
                 WriteString('timey'+inttostr(camproi),Enstr1(inttostr(timeySdt.Value)));
                 WriteString('softskin',Enstr1(inttostr(softskinCob.ItemIndex)));
                 WriteString('scrtime',Enstr1(scrtimeCob.Text));

                 if alaynCkb.Checked=true then
                    WriteString('alayn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('alayn'+inttostr(camproi),Enstr1('0'));
                 WriteString('poselx'+inttostr(camproi),Enstr1(inttostr(poselxSdt.Value)));
                 WriteString('posely'+inttostr(camproi),Enstr1(inttostr(poselySdt.Value)));
                 WriteString('powid'+inttostr(camproi),Enstr1(powidEdt.Text));
                 WriteString('pohei'+inttostr(camproi),Enstr1(poheiEdt.Text));
                 WriteString('blueturn'+inttostr(camproi),Enstr1(inttostr(blueturnTcb.Position)));
                 WriteString('greenturn'+inttostr(camproi),Enstr1(inttostr(greenturnTcb.Position)));
                 WriteString('redturn'+inttostr(camproi),Enstr1(inttostr(redturnTcb.Position)));
                 WriteString('pointturn'+inttostr(camproi),Enstr1(inttostr(pointturnTcb.Position)));
                 WriteString('turnqua'+inttostr(camproi),Enstr1(inttostr(turnquaTcb.Position)));
                 WriteString('alastrlist'+inttostr(camproi),Enstr1(alastrlistLB.Items.Text));
                 WriteString('alamodel'+inttostr(camproi),Enstr1(inttostr(alamodelCob.ItemIndex)));
                 WriteString('alapiclast'+inttostr(camproi),Enstr1(alapiclastEdt.Text));
                 WriteString('filepassword'+inttostr(camproi),Enstr1(filepasswordMdt.Text));
                 if sendalapicynCkb.Checked=true then
                    WriteString('sendalapicyn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('sendalapicyn'+inttostr(camproi),Enstr1('0'));
                 if alamsgynCkb.Checked=true then
                    WriteString('alamsgyn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('alamsgyn'+inttostr(camproi),Enstr1('0'));
                 if alamusicynCkb.Checked=true then
                    WriteString('alamusicyn'+inttostr(camproi),Enstr1('1'))
                 else
                    WriteString('alamusicyn'+inttostr(camproi),Enstr1('0'));
                 WriteString('smtptxt'+inttostr(camproi),Enstr1(smtptxtEdt.Text));
                 WriteString('pop3txt'+inttostr(camproi),Enstr1(pop3txtEdt.Text));
                 WriteString('smtpporttxt'+inttostr(camproi),Enstr1(smtpporttxtEdt.Text));
                 WriteString('pop3porttxt'+inttostr(camproi),Enstr1(pop3porttxtEdt.Text));
                 WriteString('mailuser'+inttostr(camproi),Enstr1(mailuserEdt.Text));
                 WriteString('mailpassword'+inttostr(camproi),Enstr1(mailpasswordMdt.Text));
                 WriteString('recuser'+inttostr(camproi),Enstr1(recuserEdt.Text));
                 WriteString('musicpath'+inttostr(camproi),Enstr1(musicpathEdt.Text));
             end;
          end;
         reg.Free;
         if softstartynCkb.Checked=true then
         begin
           reg:=tregistry.create;
           with reg do
           begin
             rootkey:=HKEY_LOCAL_MACHINE;
             openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',true);
             if not ValueExists(extractfilename(application.ExeName))then
               writeString(extractfilename(application.ExeName),application.ExeName);
             closekey;
             free;
           end;
         end;
         if softstartynCkb.Checked=false then
         begin
           reg:=tregistry.create;
           with reg do
           begin
             rootkey:=HKEY_LOCAL_MACHINE;
             openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',false);
             if ValueExists(extractfilename(application.ExeName))then
               DeleteValue(extractfilename(application.ExeName));
             closekey;
             free;
           end;
         end;
         if campro[camproi].isload then
         begin
           showmessage('保存成功，重启摄像头后所作修改立即生效！现在重启摄像头，请稍后！');
           lscamproi:=camproi;
           tdrmcammainForm.Stopcam(lscamproi);
           tdrmcammainForm.Startcam(lscamproi);
         end
         else
         begin
           tdrmcammainForm.Getparafromreg(camproi);
           showmessage('保存成功，所作修改立即生效！');
         end;
         if sendhelpyn then
         begin
           sendhelpyn:=false;
           sendhelp:=true;
         end;
         self.Close;
        end
        else
        begin
           showmessage(wrongmsg+'！');
           Exit;
        end;
     end;
   end
   else if(actypeLbl.Caption='wcloSBt')then
   begin
      cloynlbl.Caption:='yes';
      tdrmcammainForm.Close;
   end
   else if(actypeLbl.Caption='Modifypwd')then
   begin
      if (length(controlpwdMdt.Text)=0)or(length(ccontrolpwdMdt.Text)=0) then
      begin
         showmessage('输入新密码和确认新密码都不能为空！');
         Exit;
      end;
      if (controlpwdMdt.Text)<>(ccontrolpwdMdt.Text) then
      begin
         showmessage('两次输入密码不一致，请确认！');
         Exit;
      end;
      reg:=tregistry.create;
         with reg do //设置写入注册表并读出
          begin
             RootKey:=HKEY_CURRENT_USER;
             if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
             begin
                 WriteString('campda',Enstr1(controlpwdMdt.Text));
                 WriteString('cdqrc',Enstr1(controlpwdMdt.Text));
             end;
          end;
         reg.Free;
         showmessage('密码修改成功！');
         self.Close;
   end;
   cpdstr:=controlpwdMdt.Text;
   controlpwdMdt.Text:='';
   ncontrolpwdMdt.Text:='';
   ccontrolpwdMdt.Text:='';
end;

procedure TcontrolpwdForm.controlpwdnSBtClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TcontrolpwdForm.FormShow(Sender: TObject);
begin
   ncontrolpwdMdt.Text:='';
   controlpwdMdt.Text:='';
   ccontrolpwdMdt.Text:='';
   if(actypeLbl.Caption='Modifypwd')then
   begin
      controlpwdForm.Caption:='修改密码';
      ncontrolpwdLbl.Caption:='输入控制密码：';
      controlpwdLbl.Caption:='输入新控制密码：';
      ccontrolpwdLbl.Caption:='确认新控制密码：';
      ncontrolpwdLbl.Visible:=true;
      ccontrolpwdLbl.Visible:=true;
      ncontrolpwdMdt.Visible:=true;
      ccontrolpwdMdt.Visible:=true;
   end
   else
   begin
      controlpwdForm.Caption:='输入密码';
      controlpwdLbl.Caption:='输入控制密码：';
      ncontrolpwdLbl.Visible:=false;
      ccontrolpwdLbl.Visible:=false;
      ncontrolpwdMdt.Visible:=false;
      ccontrolpwdMdt.Visible:=false;
   end;
   passhowingyn:=true;
   controlpwdForm.BringToFront;
end;

procedure TcontrolpwdForm.FormCreate(Sender: TObject);
var
reg:Tregistry;
begin
   reg:=tregistry.create;
   with reg do //设置写入注册表并读出
    begin
       RootKey:=HKEY_CURRENT_USER;
       if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
       begin
          if (not ValueExists('campda'))and(not ValueExists('cdqrc'))then
          begin
             WriteString('campda',Enstr1('12345'));
             WriteString('cdqrc',Enstr1('12345'));
          end;
          if length(Destr1(ReadString('campda')))>0 then
             cpdstr:=Destr1(ReadString('campda'))
          else
             cpdstr:=Destr1(ReadString('cdqrc'));
       end;
    end;
    reg.Free;
end;

procedure TcontrolpwdForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  passhowingyn:=false;
end;

procedure TcontrolpwdForm.ncontrolpwdMdtKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#13 then
    controlpwdySBt.Click;
end;

procedure TcontrolpwdForm.controlpwdMdtKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#13 then
    controlpwdySBt.Click;
end;

procedure TcontrolpwdForm.ccontrolpwdMdtKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#13 then
    controlpwdySBt.Click;
end;

end.
