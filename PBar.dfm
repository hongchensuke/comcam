object PBarForm: TPBarForm
  Left = 495
  Top = 446
  Width = 426
  Height = 99
  Caption = #36827#24230
  Color = 15985881
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 161
    Height = 13
    AutoSize = False
    Caption = #27491#22312#26356#26032#20013#65292#35831#31245#21518#12290#12290#12290
    Transparent = True
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 32
    Width = 401
    Height = 17
    Max = 10
    TabOrder = 0
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 248
    Top = 8
  end
end
