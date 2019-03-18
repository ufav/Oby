object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 512
  ClientWidth = 781
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    781
    512)
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
    Width = 765
    Height = 158
    TabOrder = 4
  end
  object data_list: TStringGrid
    Left = 8
    Top = 223
    Width = 765
    Height = 281
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 1000
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 5
  end
end
