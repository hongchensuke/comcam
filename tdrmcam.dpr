program tdrmcam;

{$R 'res\camres.res' 'res\camres.rc'}

uses
  Windows,
  Messages,
  SysUtils,
  Forms,
  tdrmcammain in 'tdrmcammain.pas' {tdrmcammainForm},
  Cammain in 'Cammain.pas' {mainForm},
  EnDestr in 'EnDestr.pas',
  Md5 in 'md5.pas',
  alamsg in 'alamsg.pas' {alamsgForm},
  controlpas in 'controlpas.pas' {controlpwdForm},
  PBar in 'PBar.pas' {PBarForm},
  reg in 'reg.pas' {regForm},
  view in 'view.pas' {viewForm};

{$R *.res}
var
HWndCalculator : HWnd;
hAppMutex: THandle;
begin
  Application.Initialize;
  if(pos('stup.exe',Application.Exename)>0)then
   begin
      HWndCalculator := FindWindow(nil, '关闭摄像头监控软件');
      if HWndCalculator <> 0 then
         SendMessage(HWndCalculator, WM_CLOSE, 0, 0);
      while fileexists(apppath+'Cam.exe')do
         deletefile(apppath+'Cam.exe');
      while not fileexists(apppath+'Cam.exe') do
      begin
        renamefile(apppath+'stup.exe',apppath+'Cam.exe');
      end;
   end;
   hAppMutex := CreateMutex(nil, False, 'tdrcamone');
    try
      if ((hAppMutex <> 0) and (GetLastError() = ERROR_ALREADY_EXISTS)) then //查看是否是第一次运行程序
      begin
          MessageBox(0, PChar('泰德瑞摄像头监控软件已经运行！!' + #13#10 + '请关闭软件后再尝试'),
            PChar('重复运行'), MB_OK + MB_ICONWARNING);
        CloseHandle(hAppMutex); //关闭互斥对象，退出程序
        Exit;
      end;
    except
    end;
  SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);      //在任务栏隐藏本软件窗体   需uses windows
//  SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);  //在任务管理器应用程序里隐藏
  Application.Title := '';
  Application.CreateForm(TtdrmcammainForm, tdrmcammainForm);
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TalamsgForm, alamsgForm);
  Application.CreateForm(TcontrolpwdForm, controlpwdForm);
  Application.CreateForm(TPBarForm, PBarForm);
  Application.CreateForm(TregForm, regForm);
  Application.CreateForm(TviewForm, viewForm);
  Application.Run;
end.
