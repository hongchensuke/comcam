unit alamsg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, MPlayer, ExtCtrls, jpeg;

type
  TalamsgForm = class(TForm)
    MediaPlayer1: TMediaPlayer;
    musicnameLbl: TLabel;
    msgMemo: TMemo;
    Timer1: TTimer;
    okImg: TImage;
    okSBt: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure okSBtClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  alamsgForm: TalamsgForm;
  endposition:integer;
implementation
  uses tdrmcammain;
{$R *.dfm}

procedure TalamsgForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tdrmcammain.alamsgshowyn:=false;
  Timer1.Enabled:=false;
  MediaPlayer1.Close;
  endposition:=0;
  msgMemo.Lines.Clear;
end;

procedure TalamsgForm.FormCreate(Sender: TObject);
begin
  endposition:=0;
  tdrmcammain.alamsgshowyn:=false; 
end;

procedure TalamsgForm.Timer1Timer(Sender: TObject);
begin
  If Mediaplayer1.Position=EndPosition then
  begin
    Mediaplayer1.ReWind;
    Mediaplayer1.Play;
  end;
end;

procedure TalamsgForm.okSBtClick(Sender: TObject);
begin
  Self.Close;
end;

end.
