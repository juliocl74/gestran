unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls;

type
  TForm2 = class(TForm)
    QuickRep1: TQuickRep;
    QRSubDetail1: TQRSubDetail;
    procedure QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses unit1, Printers;
{$R *.dfm}

procedure TForm2.QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
begin
  if Form1.y>Form1.hpg
   then QuickRep1.NewPage;
end;

end.
