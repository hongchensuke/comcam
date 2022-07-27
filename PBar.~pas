unit PBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TPBarForm = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PBarForm: TPBarForm;

implementation

{$R *.dfm}

procedure TPBarForm.Timer1Timer(Sender: TObject);
begin
if ProgressBar1.Position<10 then
   ProgressBar1.Position:=ProgressBar1.Position+1
else
   ProgressBar1.Position:=0;
end;

end.
