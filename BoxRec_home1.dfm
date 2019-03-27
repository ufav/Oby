object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 623
  ClientWidth = 1076
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    1076
    623)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 35
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 25
    Height = 13
    Caption = 'Login'
  end
  object Label3: TLabel
    Left = 360
    Top = 13
    Width = 31
    Height = 13
    Caption = 'Label3'
  end
  object cnnct: TButton
    Left = 192
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 0
    OnClick = cnnctClick
  end
  object lgn: TEdit
    Left = 65
    Top = 10
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'khvostatyy'
  end
  object psswrd: TEdit
    Left = 65
    Top = 32
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    Text = 'Ghbrjk123'
  end
  object gtdt: TButton
    Left = 273
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Get Data'
    TabOrder = 3
    OnClick = gtdtClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 59
    Width = 505
    Height = 158
    TabOrder = 4
  end
  object data_list: TStringGrid
    Left = 8
    Top = 223
    Width = 1060
    Height = 392
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 1000
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 5
    ExplicitWidth = 765
    ExplicitHeight = 281
  end
  object Button1: TButton
    Left = 496
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Memo2: TMemo
    Left = 519
    Top = 59
    Width = 549
    Height = 158
    TabOrder = 7
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 648
    Top = 16
  end
end
