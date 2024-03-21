object Form1: TForm1
  Left = 192
  Top = 125
  Width = 544
  Height = 441
  Caption = 'VENDAS'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 235
    Top = 19
    Width = 126
    Height = 25
    Caption = 'Gerar pr'#233'via'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object StringGrid1: TStringGrid
    Left = 24
    Top = 144
    Width = 457
    Height = 241
    DefaultRowHeight = 16
    FixedCols = 0
    TabOrder = 1
    ColWidths = (
      103
      64
      64
      64
      121)
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 8
    Width = 205
    Height = 129
    Caption = 'Filtro'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 65
      Height = 13
      Caption = 'Data inicial'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 9
      Top = 49
      Width = 56
      Height = 13
      Caption = 'Data final'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 10
      Top = 72
      Width = 55
      Height = 13
      Caption = 'Vendedor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object MaskEdit1: TMaskEdit
      Left = 82
      Top = 21
      Width = 77
      Height = 21
      EditMask = '!99/99/9999;1;_'
      MaxLength = 10
      TabOrder = 0
      Text = '01/01/2023'
    end
    object MaskEdit2: TMaskEdit
      Left = 83
      Top = 46
      Width = 78
      Height = 21
      EditMask = '!99/99/9999;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '31/12/2023'
    end
    object CheckListBox1: TCheckListBox
      Left = 83
      Top = 72
      Width = 109
      Height = 48
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object BitBtn2: TBitBtn
    Left = 256
    Top = 96
    Width = 105
    Height = 25
    Caption = 'Gerar Relat'#243'rio'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 352
    Top = 72
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 344
    Top = 144
  end
end
