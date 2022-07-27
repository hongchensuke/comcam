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
       showmessage('�����������');
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
           wrongmsg:=wrongmsg+'ÿ֡��Ȳ���С�ڻ����0';
        end;
        if(fraheiSdt.Value<=0)then
        begin
           wrongmsg:=wrongmsg+'��ÿ֡�߶Ȳ���С�ڻ����0';
        end;
        if flycomynCkb.Checked=true then
        begin
           if(length(commacCob.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'������������Ϊ��';
           end;
           if(length(comquaCob.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'��ѹ����������Ϊ��';
           end;
        end;
        if videosaveynCkb.Checked=true then
        begin
          if(length(savepathEdt.Text)=0)then
          begin
             wrongmsg:=wrongmsg+'�����Ŀ¼����Ϊ��';
          end;
        end;
        if capynCkb.Checked=true then
        begin
          if(capxSdt.Value<0)or(capxSdt.Value>frawidSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'����Ļλ��X����С��0��Ҳ���ܴ���ÿ֡���';
          end;
          if(capySdt.Value<0)or(capySdt.Value>fraheiSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'����Ļλ��Y����С��0��Ҳ���ܴ���ÿ֡�߶�';
          end;
        end;
        if(strtoint(savedaysCob.Text)<0)then
        begin
          wrongmsg:=wrongmsg+'���������޲���С��0';
        end;
        if timeynCkb.Checked=true then
        begin
          if(timexSdt.Value<0)or(timexSdt.Value>frawidSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'��ʱ��λ��X����С��0��Ҳ���ܴ���ÿ֡���';
          end;
          if(timeySdt.Value<0)or(timeySdt.Value>fraheiSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'��ʱ��λ��Y����С��0��Ҳ���ܴ���ÿ֡�߶�';
          end;
        end;
        if camaddrynCkb.Checked=true then
        begin
          if(camaddrxSdt.Value<0)or(camaddrxSdt.Value>frawidSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'������ͷ�ص�λ��X����С��0��Ҳ���ܴ���ÿ֡���';
          end;
          if(camaddrySdt.Value<0)or(camaddrySdt.Value>fraheiSdt.Value)then
          begin
             wrongmsg:=wrongmsg+'������ͷ�ص�λ��Y����С��0��Ҳ���ܴ���ÿ֡�߶�';
          end;
        end;

        if(poselxSdt.Value<0)then
        begin
           wrongmsg:=wrongmsg+'����X����С��0';
        end;
        if(poselySdt.Value<0)then
        begin
           wrongmsg:=wrongmsg+'������Y����С��0';
        end;
        if(length(powidEdt.Text)=0)or(strtoint(powidEdt.Text)<=0)then
        begin
           wrongmsg:=wrongmsg+'����Ȳ���Ϊ���Ҳ���С�ڻ����0';
        end;
        if(length(poheiEdt.Text)=0)or(strtoint(poheiEdt.Text)<=0)then
        begin
           wrongmsg:=wrongmsg+'���߶Ȳ���Ϊ���Ҳ���С�ڻ����0';
        end;
        if((poselxSdt.Value+strtoint(powidEdt.Text))>frawidSdt.Value)then
        begin
           wrongmsg:=wrongmsg+'������X����֮�Ͳ��ܴ���ÿ֡���';
        end;
        if((poselySdt.Value+strtoint(poheiEdt.Text))>fraheiSdt.Value)then
        begin
           wrongmsg:=wrongmsg+'������Y��߶�֮�Ͳ��ܴ���ÿ֡�߶�';
        end;
        if(length(filepasswordMdt.Text)=0)then
        begin
           wrongmsg:=wrongmsg+'������ѹ���ļ����벻��Ϊ��';
        end;
        if(sendalapicynCkb.Checked=true)then
        begin
           if(length(smtptxtEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'��SMTP����������Ϊ��';
           end;
{           if(length(pop3txtEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'��POP3����Ϊ��';
           end;}
           if(pos('.',smtptxtEdt.Text)=0)then
           wrongmsg:=wrongmsg+'��SMTP�������������';
           if(pos('.',pop3txtEdt.Text)=0)and(length(pop3txtEdt.Text)>0)and(pop3txtEdt.Text<>'�˴���дPOP3������')then
           wrongmsg:=wrongmsg+'��POP3�������������';
           if(length(smtpporttxtEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'��SMTP�˿ڲ���Ϊ��';
           end;
{           if(length(pop3porttxtEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'��POP3�˿ڲ���Ϊ��';
           end;}
           if(length(mailuserEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'���û�������Ϊ��';
           end;
           if(length(mailpasswordMdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'�����벻��Ϊ��';
           end;
           if(pos('@',recuserEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'���ռ����������';
           end;
        end;

        if(alamusicynCkb.Checked=true)then
          if(length(musicpathEdt.Text)=0)then
           begin
              wrongmsg:=wrongmsg+'���������˲��ž������֣���������·������Ϊ��';
           end;

        if(length(wrongmsg)=0)and((smtptxtEdt.Text<>smtptxt)or(mailuserEdt.Text<>mailuser)or(mailpasswordMdt.Text<>mailpassword)or(smtpporttxtEdt.Text<>smtpporttxt)or(recuserEdt.Text<>recuser))then
        begin
           try
             //showmessage(smtptxtEdt.Text+':'+smtptxt+'��'+mailuserEdt.Text+':'+mailuser+'��'+mailpasswordMdt.Text+':'+mailpassword+'��'+smtpporttxtEdt.Text+':'+smtpporttxt+'��'+recuserEdt.Text+':'+recuser);
             if not (Application.MessageBox('���������Ѿ����ģ����ǽ�������������ռ��˸�����һ��ȷ���ʼ������ʼ����ûظ������Ƿ������','�Ƿ����',MB_OKCANCEL + MB_ICONQUESTION) = IDOK) then
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
             msgsend.Subject := '������֤�ʼ�'; //�ʼ�����
             msgsend.Body.Text := '��Ϊ����ͷ�����֤�ʼ�����Ӧ�������޸�������ã����ʼ����ػظ����Ժ����ǻ����ռ��˷��͡����ϵͳԶ��ָ����÷����������ڣ�'+datetimetostr(now); //�ʼ�����
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
             wrongmsg:=wrongmsg+'���������ô�����������⣬�޷�ͨ��SMTP��������֤';
           end;
        end;
        if(length(wrongmsg)=0)then
        begin
         reg:=tregistry.create;
         with reg do //����д��ע�������
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
                    WriteString('captext'+inttostr(camproi),Enstr1('��������Ļ'));
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
                    WriteString('camaddr'+inttostr(camproi),Enstr1('ͨ��'+formatdatetime('yyyymmddhhnnsszzz',now)));
                 if length(camnameCob.Text)>0 then
                    WriteString('camname'+inttostr(camproi),Enstr1(camnameCob.Text))
                 else
                    WriteString('camname'+inttostr(camproi),Enstr1('û��'));
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
           showmessage('����ɹ�����������ͷ�������޸�������Ч��������������ͷ�����Ժ�');
           lscamproi:=camproi;
           tdrmcammainForm.Stopcam(lscamproi);
           tdrmcammainForm.Startcam(lscamproi);
         end
         else
         begin
           tdrmcammainForm.Getparafromreg(camproi);
           showmessage('����ɹ��������޸�������Ч��');
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
           showmessage(wrongmsg+'��');
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
         showmessage('�����������ȷ�������붼����Ϊ�գ�');
         Exit;
      end;
      if (controlpwdMdt.Text)<>(ccontrolpwdMdt.Text) then
      begin
         showmessage('�����������벻һ�£���ȷ�ϣ�');
         Exit;
      end;
      reg:=tregistry.create;
         with reg do //����д��ע�������
          begin
             RootKey:=HKEY_CURRENT_USER;
             if OpenKey('SOFTWARE\TDR\tdrcamsoft',True) then
             begin
                 WriteString('campda',Enstr1(controlpwdMdt.Text));
                 WriteString('cdqrc',Enstr1(controlpwdMdt.Text));
             end;
          end;
         reg.Free;
         showmessage('�����޸ĳɹ���');
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
      controlpwdForm.Caption:='�޸�����';
      ncontrolpwdLbl.Caption:='����������룺';
      controlpwdLbl.Caption:='�����¿������룺';
      ccontrolpwdLbl.Caption:='ȷ���¿������룺';
      ncontrolpwdLbl.Visible:=true;
      ccontrolpwdLbl.Visible:=true;
      ncontrolpwdMdt.Visible:=true;
      ccontrolpwdMdt.Visible:=true;
   end
   else
   begin
      controlpwdForm.Caption:='��������';
      controlpwdLbl.Caption:='����������룺';
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
   with reg do //����д��ע�������
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
