unit view;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, MPlayer, StdCtrls, ExtCtrls,math, DSPack,Jpeg,
  OleCtrls, WMPLib_TLB;

type
  TviewForm = class(TForm)
    Panel9: TPanel;
    Panel3: TPanel;
    ScrollBar1: TScrollBar;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    StopSBt: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    Panel6: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Panel4: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    DateTimePicker1: TDateTimePicker;
    MediaPlayer1: TMediaPlayer;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    SpeedButton6: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Label4: TLabel;
    SpeedButton10: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton11: TSpeedButton;
    SaveDialog1: TSaveDialog;
    SpeedButton12: TSpeedButton;
    Panel8: TPanel;
    Image1: TImage;
    Panel10: TPanel;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Edit3: TEdit;
    Edit4: TEdit;
    Timer2: TTimer;
    Image2: TImage;
    Label8: TLabel;
    Label9: TLabel;
    WindowsMediaPlayer1: TWindowsMediaPlayer;
    procedure SpeedButton1Click(Sender: TObject);
    procedure StopSBtClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton10Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure SpeedButton9Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    function getvideolist:boolean;
    procedure Panel7DblClick(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  viewForm: TviewForm;
  playstate:string;     //ini:初始  fas:快进  fab:快退  pla:播放  pau:暂停
  witchpanel:integer;
  ismove,fullscr,oldbitmapyn:boolean;
  oldbitmap:Tbitmap;
  nowbitmap:Tbitmap;
  Bitmap,whtempbitmap:TBitmap;
  tol,sin:integer;

implementation

uses controlpas,md5,EnDestr,tdrmcammain, PBar, alamsg, reg;

{$R *.dfm}

procedure TviewForm.SpeedButton1Click(Sender: TObject);
begin
  if MediaPlayer1.DeviceID<>0 then
  begin
    showmessage('请先停止后再打开');
    Exit;
  end;
  opendialog1.filter:='录像文件(*.avi)|*.avi';
  //opendialog1.filter:='文本文件(*.txt)|*.txt|FLASH文件(*.swf)|*.swf';
  if OpenDialog1.Execute then
  begin
    try
      Panel5.Visible:=true;
      Panel6.Visible:=false;
      MediaPlayer1.Display:=Panel6;
      MediaPlayer1.Close;
      MediaPlayer1.filename := OpenDialog1.filename;
      MediaPlayer1.open;
      MediaPlayer1.Play;
      playstate:='pla';
      oldbitmapyn:=false;
      ScrollBar1.Enabled:=true;
      MediaPlayer1.DisplayRect:=Panel6.ClientRect;
      ScrollBar1.Max:=MediaPlayer1.Length;
      witchpanel:=6;
      SpeedButton8Click(nil);
    except
      showmessage('无法播放！');
    end;
  end;
end;

procedure TviewForm.StopSBtClick(Sender: TObject);
begin
  if MediaPlayer1.DeviceID=0 then
    Exit;
  MediaPlayer1.Stop;
  MediaPlayer1.Close;
  playstate:='ini';
  Panel5.Visible:=false;
  Panel6.Visible:=false;
  Panel7.Visible:=false;
  ScrollBar1.Enabled:=false;
  ScrollBar1.Position:=0;
end;

procedure TviewForm.SpeedButton3Click(Sender: TObject);
begin
  MediaPlayer1.Frames:=25;
  MediaPlayer1.Step;
end;

function SnapScreenbmp(LeftPos,TopPos,RightPos,BottomPos:integer;var Bitmap:TBitmap):boolean;
var
  RectWidth,RectHeight:integer;
  SourceDC,DestDC,Bhandle:integer;
  Stream:TMemoryStream;
begin
  try
    try
      result:=false;
      RectWidth:=RightPos-LeftPos;
      RectHeight:=BottomPos-TopPos;
      SourceDC:=CreateDC('DISPLAY','','',nil);
      DestDC:=CreateCompatibleDC(SourceDC);
      Bhandle:=CreateCompatibleBitmap(SourceDC,
      RectWidth,RectHeight);
      SelectObject(DestDC,Bhandle);
      BitBlt(DestDC,0,0,RectWidth,RectHeight,SourceDC,
      LeftPos,TopPos,SRCCOPY);
      Bitmap.Handle:=BHandle;
      Stream := TMemoryStream.Create;
      Bitmap.SaveToStream(Stream);
      Stream.Free;
      result:=true;
      //result:=MyJpeg;
      //result.Assign(MyJpeg);
      //MyJpeg.SaveToFile(Apath);
    finally
      DeleteDC(DestDC);
      ReleaseDC(Bhandle,SourceDC);
    end;
  except
    result:=false;
  end;
end;

procedure TviewForm.Timer1Timer(Sender: TObject);
begin
  if (playstate='pla') or (playstate='fab') or (playstate='fas')then
  begin
    ScrollBar1.Position:=MediaPlayer1.Position;
    if 21<>TrackBar1.Position then
    begin
      MediaPlayer1.Frames:=abs(21-TrackBar1.Position);
      if 21>TrackBar1.Position then
      begin
        MediaPlayer1.Back;
        playstate:='fab';
      end
      else
      begin
        MediaPlayer1.Step;
        playstate:='fas';
      end;
    end;
  end
  else if ((playstate='fab') or (playstate='fas'))and(21=TrackBar1.Position) then
  begin
    MediaPlayer1.Play;
    playstate:='pla';
  end;
  if (playstate='pla') or (playstate='fab') or (playstate='fas')then
  begin
    if MediaPlayer1.Position=MediaPlayer1.Length then
    begin
      if MediaPlayer1.DeviceID=0 then
        Exit;
      MediaPlayer1.Stop;
      MediaPlayer1.Close;
      Panel5.Visible:=false;
      Panel6.Visible:=false;
      Panel7.Visible:=false;
      playstate:='ini';
      ScrollBar1.Position:=0;
      ScrollBar1.Enabled:=false;
      if ListBox1.ItemIndex<ListBox1.Items.Count-1 then
      begin
        ListBox1.ItemIndex:=ListBox1.ItemIndex+1;
        ListBox1DblClick(nil);
      end;
    end;
  end;
end;

procedure TviewForm.SpeedButton4Click(Sender: TObject);
begin
  if playstate='ini' then
  begin
    if length(MediaPlayer1.filename)=0 then
      Exit;
    if MediaPlayer1.DeviceID<>0 then
    begin
      showmessage('请先停止后再打开');
      Exit;
    end;
    MediaPlayer1.open;
  end;
  MediaPlayer1.Play;
  playstate:='pla';
  if witchpanel=5 then
  begin
    MediaPlayer1.Display:=Panel5;
    MediaPlayer1.DisplayRect:=Panel5.ClientRect;
  end
  else if witchpanel=6 then
  begin
    MediaPlayer1.Display:=Panel6;
    MediaPlayer1.DisplayRect:=Panel6.ClientRect;
  end
  else if witchpanel=7 then
  begin
    MediaPlayer1.Display:=Panel7;
    MediaPlayer1.DisplayRect:=Panel7.ClientRect;
  end;
  ScrollBar1.Enabled:=true;
  ScrollBar1.Max:=MediaPlayer1.Length;
  //witchpanel:=6;
end;

procedure TviewForm.TrackBar1Change(Sender: TObject);
begin
  if 21>TrackBar1.Position then
  begin
    Label2.Caption:=inttostr(abs(21-TrackBar1.Position));
    Label3.Caption:='0';
  end
  else if 21<TrackBar1.Position then
  begin
    Label3.Caption:=inttostr(abs(21-TrackBar1.Position));
    Label2.Caption:='0';
  end
  else if 21=TrackBar1.Position then
  begin
    Label3.Caption:='0';
    Label2.Caption:='0';
  end;
end;

procedure TviewForm.SpeedButton5Click(Sender: TObject);
begin
  MediaPlayer1.Pause;
  playstate:='pau';
end;

procedure TviewForm.SpeedButton2Click(Sender: TObject);
begin
  MediaPlayer1.Frames:=25;
  MediaPlayer1.Back;
end;

procedure TviewForm.SpeedButton6Click(Sender: TObject);
begin
  Edit1.Text:=inttostr(floor(Panel4.Width/2));
  Edit2.Text:=inttostr(floor((Panel4.Height-Panel1.Height)/2));
  SpeedButton10Click(nil);
end;

procedure TviewForm.SpeedButton8Click(Sender: TObject);
begin
  Edit1.Text:=inttostr(Panel4.Width);
  Edit2.Text:=inttostr(Panel4.Height-Panel1.Height);
  SpeedButton10Click(nil);
end;

procedure TviewForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9'])then
    key:=#0;
end;

procedure TviewForm.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9'])then
    key:=#0;
end;

procedure TviewForm.SpeedButton10Click(Sender: TObject);
begin
  if (length(Edit1.Text)>0) and (length(Edit2.Text)>0) then
  begin
    if strtoint(Edit1.Text)>Panel4.Width then
    begin
      showmessage('宽度不能大于可用宽度（'+inttostr(Panel4.Width)+'）');
      Exit;
    end;
    if strtoint(Edit2.Text)>(Panel4.Height-Panel1.Height) then
    begin
      showmessage('高度不能大于可用高度（'+inttostr(Panel4.Height-Panel1.Height)+'）');
      Exit;
    end;
    if witchpanel=6 then
    begin
      Panel5.Width:=strtoint(Edit1.Text);
      Panel5.Height:=strtoint(Edit2.Text);
      Panel5.Left:=floor((Panel4.Width-Panel5.Width)/2);
      Panel5.Top:=floor((Panel4.Height-Panel5.Height-Panel1.Height)/2)+Panel1.Height;
      Panel5.Visible:=true;
      Panel6.Visible:=false;
      Panel7.Visible:=false;
      MediaPlayer1.Display:=Panel5;
      MediaPlayer1.DisplayRect:=Panel5.ClientRect;
      witchpanel:=5;
    end
    else
    begin
      Panel6.Width:=strtoint(Edit1.Text);
      Panel6.Height:=strtoint(Edit2.Text);
      Panel6.Left:=floor((Panel4.Width-Panel6.Width)/2);
      Panel6.Top:=floor((Panel4.Height-Panel6.Height-Panel1.Height)/2)+Panel1.Height;
      Panel6.Visible:=true;
      Panel5.Visible:=false;
      Panel7.Visible:=false;
      MediaPlayer1.Display:=Panel6;
      MediaPlayer1.DisplayRect:=Panel6.ClientRect;
      witchpanel:=6;
    end;
 end;
end;

procedure TviewForm.ScrollBar1Change(Sender: TObject);
begin
  if ismove then
  begin
    MediaPlayer1.Position:=ScrollBar1.Position;
    MediaPlayer1.Play;
    playstate:='pla';
  end;
  ismove:=false;
end;

procedure TviewForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  ismove:=true;
end;

procedure TviewForm.SpeedButton9Click(Sender: TObject);
begin
  if not fullscr then
  begin
    fullscr:=true;
    {Panel1.Visible:=false;
    Panel2.Visible:=false;}
    viewForm.Top:=0;
    viewForm.Left:=0;
    viewForm.BorderStyle:=bsNone;
    viewForm.Width:=screen.Width;
    viewForm.Height:=screen.Height;
    Panel7.Align:=alclient;
    Panel7.Visible:=true;
    Panel6.Visible:=false;
    Panel5.Visible:=false;
    MediaPlayer1.Display:=Panel7;
    MediaPlayer1.DisplayRect:=Panel7.ClientRect;
    witchpanel:=7;
  end
  else
  begin
    fullscr:=false;
    {Panel1.Visible:=true;
    Panel2.Visible:=true;}
    viewForm.BorderStyle:=bsSingle;
    viewForm.Width:=964;
    viewForm.Height:=683;
    viewForm.Left:=floor((screen.Width-viewForm.Width)/2);
    viewForm.Top:=floor((screen.Height-viewForm.Height)/2);
    SpeedButton8Click(nil);
  end;
end;

procedure TviewForm.FormShow(Sender: TObject);
var
pathlist:Tstringlist;
begin
  ListBox1.Items.Clear;
  ListBox2.Items.Clear;
  ScrollBar1.Enabled:=false;
  Panel4.Color:=clblack;
  pathlist:=Tstringlist.Create;
  pathlist:=tdrmcammainForm.MakePathList(savepath);
  ComboBox1.Items.Clear;
  ComboBox1.Items:=pathlist;
  pathlist.Free;
  ComboBox1.ItemIndex:=0;
  DateTimePicker1.DateTime:=now;
  DateTimePicker1Change(nil);
  CheckBox1.Checked:=false;
end;

function TviewForm.getvideolist:boolean;
var
sr:TSearchRec;
filename:string;
begin
  try
    result:=false;
    if length(ComboBox1.Text)=0 then
      Exit;
    ListBox1.Items.Clear;
    ListBox2.Items.Clear;
  //  showmessage(savepath+ComboBox1.Text+'\'+formatdatetime('yyyymmdd',DateTimePicker1.DateTime)+'\录像\');
    if(FindFirst(savepath+ComboBox1.Text+'\'+formatdatetime('yyyymmdd',DateTimePicker1.DateTime)+'\录像\'+'*.avi',faAnyFile,sr)=0)then
    begin
      repeat
      filename:=sr.Name;
      if (length(filename)=39) then
      if (uppercase(copy(filename,36,4))='.AVI')and (filename[18]='-') then
      begin
        ListBox1.Items.Add(copy(filename,9,2)+':'+copy(filename,11,2)+':'+copy(filename,13,2)+'-'+copy(filename,27,2)+':'+copy(filename,29,2)+':'+copy(filename,31,2));
        ListBox2.Items.Add(sr.Name);
      end;
      until(FindNext(sr)<>0);
      FindClose(sr);
      result:=true;
    end;
  except
    result:=false;
  end;
end;
procedure TviewForm.ComboBox1Change(Sender: TObject);
begin
  getvideolist;
end;

procedure TviewForm.ListBox1DblClick(Sender: TObject);
begin
    try
      if MediaPlayer1.DeviceID<>0 then
      begin
        showmessage('请先停止后再打开');
        Exit;
      end;
      Panel5.Visible:=true;
      Panel6.Visible:=false;
      MediaPlayer1.Display:=Panel6;
      MediaPlayer1.Close;
      MediaPlayer1.filename := savepath+ComboBox1.Text+'\'+formatdatetime('yyyymmdd',DateTimePicker1.DateTime)+'\录像\'+ListBox2.Items.Strings[ListBox1.ItemIndex];
      MediaPlayer1.open;
      MediaPlayer1.Play;
      playstate:='pla';
      oldbitmapyn:=false;
      ScrollBar1.Enabled:=true;
      MediaPlayer1.DisplayRect:=Panel6.ClientRect;
      ScrollBar1.Max:=MediaPlayer1.Length;
      witchpanel:=6;
      SpeedButton8Click(nil);
    except
    end;
end;

procedure TviewForm.DateTimePicker1Change(Sender: TObject);
begin
  getvideolist;
end;

procedure TviewForm.Panel7DblClick(Sender: TObject);
begin
  fullscr:=false;
  {Panel1.Visible:=true;
  Panel2.Visible:=true;}
  viewForm.BorderStyle:=bsSingle;
  viewForm.Width:=938;
  viewForm.Height:=683;
  viewForm.Left:=floor((screen.Width-viewForm.Width)/2);
  viewForm.Top:=floor((screen.Height-viewForm.Height)/2);
  SpeedButton8Click(nil);
end;

function SnapScreenjpg(LeftPos,TopPos,RightPos,BottomPos:integer;var MyJpeg: TJpegImage):boolean;
var
  RectWidth,RectHeight:integer;
  SourceDC,DestDC,Bhandle:integer;
  Bitmap:TBitmap;
  Stream:TMemoryStream;
begin
  try
    try
      result:=false;
      RectWidth:=RightPos-LeftPos;
      RectHeight:=BottomPos-TopPos;
      SourceDC:=CreateDC('DISPLAY','','',nil);
      DestDC:=CreateCompatibleDC(SourceDC);
      Bhandle:=CreateCompatibleBitmap(SourceDC,
      RectWidth,RectHeight);
      SelectObject(DestDC,Bhandle);
      BitBlt(DestDC,0,0,RectWidth,RectHeight,SourceDC,
      LeftPos,TopPos,SRCCOPY);
      Bitmap:=TBitmap.Create;
      Bitmap.Handle:=BHandle;
      Stream := TMemoryStream.Create;
      Bitmap.SaveToStream(Stream);
      Stream.Free;
      MyJpeg.Assign(Bitmap);
      MyJpeg.CompressionQuality:=100;
      MyJpeg.Compress;
      result:=true;
      //result:=MyJpeg;
      //result.Assign(MyJpeg);
      //MyJpeg.SaveToFile(Apath);
    finally
      Bitmap.Free;
      DeleteDC(DestDC);
      ReleaseDC(Bhandle,SourceDC);
    end;
  except
    result:=false;
  end;
end;

procedure TviewForm.SpeedButton11Click(Sender: TObject);
var
MyJpeg: TJpegImage;
scpanel:Tpanel;
bmp:Tbitmap;
ImageRect : TRect;
begin
  MediaPlayer1.Pause;
  playstate:='pau';
  MyJpeg:= TJpegImage.Create;
  if witchpanel=5 then
  scpanel:=Panel5
  else if witchpanel=6 then
  scpanel:=Panel6
  else if witchpanel=7 then
  scpanel:=Panel7;
  if witchpanel=7 then
  SnapScreenjpg(Self.Left+scpanel.Left+Panel2.Width+3,Self.Top+scpanel.Top+Panel1.Height-28,Self.Left+scpanel.Left+Panel2.Width+scpanel.Width+3,Self.Top+scpanel.Top+Panel1.Height+scpanel.Height-28,MyJpeg)
  else
  SnapScreenjpg(Self.Left+scpanel.Left+Panel2.Width+3,Self.Top+scpanel.Top+Panel1.Height+1,Self.Left+scpanel.Left+Panel2.Width+scpanel.Width+3,Self.Top+scpanel.Top+Panel1.Height+scpanel.Height+1,MyJpeg);
  Image1.Picture.Assign(MyJpeg);
//  Image1.Picture.SaveToFile(scpanel.name+'.jpg');
  MyJpeg.Free;
  Panel8.Visible:=true;
end;

procedure TviewForm.SpeedButton12Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TviewForm.SpeedButton14Click(Sender: TObject);
begin
  Panel8.Visible:=false;
  MediaPlayer1.Play;
  playstate:='pla';
end;

procedure TviewForm.SpeedButton13Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if uppercase(copy(SaveDialog1.FileName,length(SaveDialog1.FileName)-3,4))<>'.JPG' then
      SaveDialog1.FileName:=SaveDialog1.FileName+'.JPG';
    Image1.Picture.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TviewForm.Button1Click(Sender: TObject);
begin
  showmessage(playstate);
end;

procedure TviewForm.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  CheckBox1.Checked:=false;
  if not(key in ['0'..'9'])then
    key:=#0;
end;

procedure TviewForm.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  CheckBox1.Checked:=false;
  if not(key in ['0'..'9'])then
    key:=#0;
end;

procedure TviewForm.CheckBox1Click(Sender: TObject);
var
tes1,tes2:integer;
begin
  if CheckBox1.Checked then
  begin
    try
      tes1:=strtoint(Edit3.Text);
      tes2:=strtoint(Edit4.Text);
      if (tes1>100)or (tes1>100) then
      begin
        showmessage('总体变化率和单点变化率都不能大于100！');
        CheckBox1.Checked:=false;
        Exit;
      end;
      tol:=strtoint(Edit3.Text);
      sin:=strtoint(Edit4.Text);
    except
      showmessage('总体变化率或单点变化率输入有误！');
      CheckBox1.Checked:=false;
    end;
  end;
end;

procedure TviewForm.Timer2Timer(Sender: TObject);
type
    PRGBTripleArray=^TRGBTripleArray;
    TRGBTripleArray=array[0..32767] of TRGBTriple;
var
chi,x,y,truni:integer;
scpanel:Tpanel;
p0,p1:PRGBTripleArray;
begin
  if (playstate='pla') or (playstate='fab') or (playstate='fas')then
  begin
    if CheckBox1.Checked then
    begin
      if witchpanel=5 then
      scpanel:=Panel5
      else if witchpanel=6 then
      scpanel:=Panel6
      else if witchpanel=7 then
      scpanel:=Panel7;
      if witchpanel=7 then
      SnapScreenbmp(Self.Left+scpanel.Left+Panel2.Width+3,Self.Top+scpanel.Top+Panel1.Height-28,Self.Left+scpanel.Left+Panel2.Width+scpanel.Width+3,Self.Top+scpanel.Top+Panel1.Height+scpanel.Height-28,Bitmap)
      else
      SnapScreenbmp(Self.Left+scpanel.Left+Panel2.Width+3,Self.Top+scpanel.Top+Panel1.Height+1,Self.Left+scpanel.Left+Panel2.Width+scpanel.Width+3,Self.Top+scpanel.Top+Panel1.Height+scpanel.Height+1,Bitmap);
      Image2.Picture.Bitmap.Assign(Bitmap);
      whtempbitmap.Width:=400;
      whtempbitmap.Height:=300;
      whtempbitmap.Canvas.Lock;
      whtempbitmap.Canvas.FillRect(Canvas.ClipRect);
      whtempbitmap.Canvas.StretchDraw(rect(0,0,whtempbitmap.Width,whtempbitmap.Height),Image2.Picture.Graphic);
      whtempbitmap.Canvas.Unlock;
      nowbitmap.Assign(whtempbitmap);
      if not oldbitmapyn then
      begin
        oldbitmapyn:=true;
        oldbitmap.Assign(whtempbitmap);
      end;
      chi:=0;
      for y:=0 to 299 do
      begin
        p0:=nowbitmap.ScanLine[y];
        p1:=oldbitmap.ScanLine[y];
        for x:=0 to 399 do
        begin
          truni:=floor((abs(p0[x].rgbtBlue-p1[x].rgbtBlue)+abs(p0[x].rgbtGreen-p1[x].rgbtGreen)+abs(p0[x].rgbtRed-p1[x].rgbtRed))*100/(255*3));
          if (truni>=sin) then
          begin
             Label9.Caption:=inttostr(truni);
            //showmessage(inttostr(floor((abs(p0[x].rgbtBlue-p1[x].rgbtBlue)+abs(p0[x].rgbtGreen-p1[x].rgbtGreen)+abs(p0[x].rgbtRed-p1[x].rgbtRed))*100/(255*3))))
             chi:=chi+1;
          end;
        end;    
      end;
      oldbitmap.Assign(whtempbitmap);
      Label8.Caption:=inttostr(floor(chi/1200));
      //Image3.Picture.Bitmap.Assign(whtempbitmap);
      if (chi/1200>=tol) then
      begin
        Label8.Caption:=inttostr(floor(chi/1200));
        MediaPlayer1.Pause;
        playstate:='pau';
        //showmessage(inttostr(floor(chi/1200))+';'+inttostr(tol));
      end;
    end;
  end;
end;

procedure TviewForm.FormCreate(Sender: TObject);
begin
  Bitmap:=TBitmap.Create;
  whtempbitmap:=TBitmap.Create;
  oldbitmap:=Tbitmap.Create;
  nowbitmap:=Tbitmap.Create;
  Bitmap.PixelFormat:=pf24bit;
  whtempbitmap.PixelFormat:=pf24bit;
  oldbitmap.PixelFormat:=pf24bit;
  nowbitmap.PixelFormat:=pf24bit;
end;

procedure TviewForm.FormDestroy(Sender: TObject);
begin
  Bitmap.Free;
  whtempbitmap.Free;
  oldbitmap.Free;
  nowbitmap.Free;
end;

procedure TviewForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MediaPlayer1.DeviceID=0 then
    Exit;
  MediaPlayer1.Stop;
  MediaPlayer1.Close;
  playstate:='ini';
end;

end.
