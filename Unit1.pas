unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ADODB, DB, Grids, Buttons, Mask, CheckLst, ExtCtrls, QRCtrls;

type
  TForm1 = class(TForm)
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    BitBtn1: TBitBtn;
    StringGrid1: TStringGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    MaskEdit1: TMaskEdit;
    Label2: TLabel;
    MaskEdit2: TMaskEdit;
    CheckListBox1: TCheckListBox;
    Label3: TLabel;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
   y, hpg:integer;
   b:boolean;
  end;

var
  Form1: TForm1;
implementation

uses StrUtils, DateUtils, Unit2, Printers;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var s,q:Tstringlist;
    i,j,k,l:integer;
    a,b:string;
begin
 try
 s:=TStringList.create;

 //configure sua conexão ao SQL Server
 s.Add('Provider=SQLOLEDB.1;');
 s.Add('Integrated Security=SSPI;');
 s.Add('Persist Security Info=False;');
 s.Add('Initial Catalog=master;');
 s.Add('Data Source=Hellcat\SQLEXPRESS;');
 s.Add('Use Procedure for Prepare=1;');
 s.Add('Auto Translate=True;');
 s.Add('Packet Size=4096;');
 s.Add('Workstation ID=HELLCAT;');
 s.Add('Use Encryption for Data=False;');
 s.Add('Tag with column collation when possible=False;');

 ADOConnection1.ConnectionString:=s.Text;
 ADOConnection1.Connected:=True;
 ADOQuery1.SQL.Text:=('IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '#39'vendas'#39')'+
  'BEGIN '+
    'CREATE TABLE vendas ( '+
        'Id_da_Venda INT PRIMARY KEY, '+
        'Data DATE, '+
        'Vendedor VARCHAR(100), '+
        'Valor_da_Venda DECIMAL(18, 2), '+
        'Valor_do_Desconto DECIMAL(18, 2), '+
        'Valor_Total DECIMAL(18, 2) ); END;');
 ADOQuery1.ExecSQL;

 q:=TStringList.create;
 s.LoadFromFile('vendas.csv');
 StringReplace(s.Text,' ','',[rfReplaceAll]);

 //decode csv
 for i:=1 to s.Count-1
  do begin
      a:=s[i];
      j:=pos(',',a);
      b:=Copy(a,1,j)+' CONVERT(DATE,'+#39;
      k:=PosEx(',',a,j+1);
      b:=b+Copy(a,j+1,k-j-1)+#39',105),'#39;
      Delete(a,1,k);
      j:=pos(',',a);
      b:=b+Copy(a,1,j-1)+#39',';
      Delete(a,1,j);
      b:=b+a;
      q.Add('('+b+')'+IfThen(i<>s.Count-1,','))
     end;
 if q.Count>0
  then begin
         q.Text:='INSERT INTO'+
                 ' vendas (Id_da_Venda, Data, Vendedor,'+
                         ' Valor_da_Venda, Valor_do_Desconto, Valor_Total)'+
                 'SELECT new_data.Id_da_Venda, new_data.Data,'+
                 ' new_data.Vendedor, new_data.Valor_da_Venda,'+
                 ' new_data.Valor_do_Desconto, new_data.Valor_Total'+
                 ' FROM'+
                 ' (VALUES'+
                  q.Text+
           //      q[0]+
                 ') AS new_data(Id_da_Venda, Data, Vendedor, Valor_da_Venda,'+
                              ' Valor_do_Desconto, Valor_Total)'+
                ' WHERE NOT EXISTS ('+
                  ' SELECT 1 FROM vendas'+
                  ' WHERE vendas.Id_da_Venda = new_data.Id_da_Venda)';
         ADOQuery1.SQL:=q;
         ADOQuery1.ExecSQL
       end;
 With ADOQuery1 do begin
  SQL.Text:='SELECT distinct Vendedor'+
    ' from Vendas';
  open;
  while not eof do
  begin
   CheckListBox1.AddItem(FieldByName('Vendedor').AsString,nil);
   Next;
  end;
  Close;
 end
 finally
   FreeAndNil(s);
   FreeAndNil(q);
 end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var a,b:TDateTime;
i,j:integer;
s,v,u:string;
begin
 for i:=1 to StringGrid1.RowCount-1
  do StringGrid1.Rows[i].Clear;
 if not TryStrToDate(MaskEdit1.Text,a)
  or not TryStrToDate(MaskEdit2.Text,b)
  then begin
        ShowMessage('Datas inválidas');
        exit;
       end;
 j:=0;
 for i:=0 to CheckListBox1.Items.Count-1
  do if CheckListBox1.Checked[i]
      then Inc(j);
 if (j=0) or (j=CheckListBox1.Items.Count)
  then v:=''
  else for i:=0 to CheckListBox1.Items.Count-1
        do if CheckListBox1.Checked[i]
            then v:=v+','+#39+CheckListBox1.Items.Strings[i]+#39;
 Delete(v,1,1);

 With ADOQuery1 do begin
  SQL.Text:='with S as'+
' (SELECT Vendedor,'+
    ' SUM(Valor_da_Venda) AS Total_Vendas,'+
    ' SUM(Valor_do_Desconto) AS Total_Descontos'+
 ' FROM vendas'+
 ' where Data between '#39+FormatDateTime('YYYY-MM-DD',a)+#39+
   ' and '#39+FormatDateTime('YYYY-MM-DD',b)+#39+
   ifthen(v<>'','and Vendedor in ('+v+')')+
 ' GROUP BY Vendedor)'+
' SELECT * FROM s'+
' inner join vendas v on v.vendedor=s.Vendedor'+
' where v.Data between '#39+FormatDateTime('YYYY-MM-DD',a)+#39+
  ' and '#39+FormatDateTime('YYYY-MM-DD',b)+#39+
   ifthen(v<>'','and v.Vendedor in ('+v+')')+
 'order by v.Vendedor, v.Data';
  Open;
  i:=0;
  s:='';
  u:='';
  StringGrid1.Cells[0,0]:='Vendedor';
  StringGrid1.Cells[1,0]:='Data';
  StringGrid1.Cells[2,0]:='Venda';
  StringGrid1.Cells[3,0]:='Desconto';
  StringGrid1.Cells[4,0]:='Comissão';
  while not eof do
  begin
   inc(i);
   if (u='') or (u<>s)
    then StringGrid1.Cells[0,i]:=FieldByName('Vendedor').AsString;
   StringGrid1.Cells[1,i]:=FieldByName('Data').AsString;
   StringGrid1.Cells[2,i]:=FieldByName('Valor_da_Venda').AsString;
   StringGrid1.Cells[3,i]:=FieldByName('Valor_do_Desconto').AsString;
   u:=FieldByName('Vendedor').AsString;
   if s='' then s:=u;
   Next;
   if not Eof and (u<>FieldByName('Vendedor').AsString)
    then s:=FieldByName('Vendedor').AsString;
   if eof or (s<>u)
    then begin
          inc(i);
          StringGrid1.Cells[0,i]:='TOTAL '+u;
          StringGrid1.Cells[2,i]:=FieldByName('Total_Vendas').AsString;
          StringGrid1.Cells[3,i]:=FieldByName('Total_Descontos').AsString;
         end;
  end;
  Close;
  StringGrid1.RowCount:=i+1;
  SQL.Text:='with S as'+
    ' (SELECT Vendedor,'+
    ' SUM(Valor_Total) AS Total_Liquido'+
     ' FROM vendas'+
     ' where Data between '#39+FormatDateTime('YYYY-MM-DD',a)+#39+
       ' and '#39+FormatDateTime('YYYY-MM-DD',b)+#39+
     ' GROUP BY Vendedor)'+
     ' select * from s order by Total_Liquido desc';
  Open;
  i:=0;
  While not EOF do begin
   j:=StringGrid1.Cols[0].IndexOf('TOTAL '+FieldByName('Vendedor').AsString);
   if j>1
    then case i of
          0:StringGrid1.Cells[4,j]:='Rank 1 > '+FormatFloat('#0.00',FieldByName('Total_Liquido').AsFloat*0.1+
                                               FieldByName('Total_Liquido').AsFloat*0.1*0.2);
          1:StringGrid1.Cells[4,j]:='Rank 2 > '+FormatFloat('#0.00',FieldByName('Total_Liquido').AsFloat*0.1)
       else StringGrid1.Cells[4,j]:=FormatFloat('#0.00',FieldByName('Total_Liquido').AsFloat*0.05)
         end;
   Inc(i);
   Next;
  end;
  Close;
 end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  i, j: Integer;
begin
 Form2:= TForm2.Create(Nil);
  y:= 20;
  hpg:= Trunc((Printer.PageHeight - 20) / 10);
  for i:=0 to Form1.StringGrid1.RowCount-1 do
  begin
    if y > hpg
     then y:=20;
    for j:=0 to Form1.StringGrid1.ColCount-1 do
     begin
      with TQRLabel.Create(Self) do
      begin
        Parent:= Form2.QuickRep1;
        Caption:= Form1.StringGrid1.Cells[j, i];
        Left:= 10 + j * 80;
        Top:= y;
        AutoSize:= True;
      end;
    end;
    y := y + 10;
   end;

 Form2.QuickRep1.PreviewModal;
 FreeAndNil(Form2);
end;

end.
