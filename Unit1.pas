unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdHTTP, RegExpr, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  Vcl.StdCtrls, Vcl.Grids;

type
  TForm1 = class(TForm)
    cnnct: TButton;
    lgn: TEdit;
    psswrd: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    gtdt: TButton;
    Label3: TLabel;
    Memo1: TMemo;
    data_list: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure cnnctClick(Sender: TObject);
    procedure gtdtClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.cnnctClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  lp: TStringList;
  s: string;

begin
  IdHTTP := TIdHTTP.Create;
  IdHTTP.HandleRedirects := True;
  IdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';
  lp := TStringList.Create;
  lp.Add('_username=' + lgn.Text);
  lp.Add('_password=' + psswrd.Text);
  try
    begin
      IdHTTP.Post('http://boxrec.com/en/login', lp);
      s := IdHTTP.Get('http://boxrec.com/en/results');
      if Pos(lgn.Text, s) > 0 then
        begin
          label3.Caption := 'Successful';
          gtdt.Enabled := True;
          lgn.Enabled := False;
          psswrd.Enabled := False;
        end
      else
        Label3.Caption := 'Connection error';
    end;
  except
    Label3.Caption := 'Connection error';
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.WindowState := wsMaximized;
  gtdt.Enabled := False;
  Label3.Caption := '';
end;

procedure TForm1.gtdtClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  s, t, u: string;
  i, j, k: Integer;
  lst1, lst2, lst3: TStringList;
  re1, re2, re3: TRegExpr;
  flag: Boolean;
begin
  IdHTTP := TIdHTTP.Create;
  IdHTTP.HandleRedirects := True;
  IdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';

  re1 := TRegExpr.Create;
  lst1 := TStringList.Create;
  lst2 := TStringList.Create;

  s := IdHTTP.Get('http://boxrec.com/en/event/772920/2296464'); //fighters block
  t := Copy(s, Pos('pageHeading', s), Pos('starBase', s) - Pos('pageHeading', s));

  re1.Expression := 'Link">(.*?)</a>';  //fighters
  if re1.Exec(t) then
    repeat
      lst1.Add(re1.Match[1]);
    until not re1.ExecNext;
  data_list.Cells[0, 1] := lst1.Strings[0];
  data_list.Cells[1, 1] := lst1.Strings[1];
  lst1.Clear;

  re1.Expression := '\d{4}-\d{2}-\d{2}';  //event's date
  re1.Exec(s);
  data_list.Cells[2, 1] := re1.Match[0];

  if Pos('/referee/', s) > 0 then //referee*
    begin
      t := Copy(s, Pos('/referee/', s), 200);
      re1.Expression := 'Link">(.*?)</a>';
      re1.Exec(t);
      data_list.Cells[3, 1] := re1.Match[1];
    end;

  if Pos('/judge/', s) > 0 then //judges*
    begin
      re1.Expression := '/judge/(.*?)</td>';
      if re1.Exec(s) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
      re1.Expression := 'Link">(.*?)</a>';
      if re1.Exec(lst1.Text) then
        repeat
          lst2.Add(re1.Match[1]);
        until not re1.ExecNext;
      data_list.Cells[4, 1] := lst2.strings[0];
      data_list.Cells[5, 1] := lst2.Strings[1];
      data_list.Cells[6, 1] := lst2.Strings[2];
      lst1.Clear;
      lst2.Clear;

      t := Copy(s, Pos('<b>judges</b>', s), 1500);  //judge's scorecards
      re1.Expression := '8em;" width="40\%">(.*?)</td>';
      if re1.Exec(t) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
      data_list.Cells[7, 1] := lst1.strings[0];
      data_list.Cells[8, 1] := lst1.Strings[1];
      data_list.Cells[9, 1] := lst1.Strings[2];
      data_list.Cells[10, 1] := lst1.Strings[3];
      data_list.Cells[11, 1] := lst1.Strings[4];
      data_list.Cells[12, 1] := lst1.Strings[5];
      lst1.Clear;
    end;

  t := Copy(s, Pos('<br><span class="textWon">', s), 200);  //text won
  re1.Expression := 'Won">(.*?)</span>';
  re1.Exec(t);
  data_list.Cells[13, 1] := re1.Match[1];

  re1.Expression := '\s<br>(.*?)\n';  //round won
  re1.Exec(t);
  data_list.Cells[14, 1] := re1.Match[1];

  Memo1.Text := t;

  t := Copy(s, Pos('ranking', s), Pos('details', s) - Pos('ranking', s)); //ranking
  t := StringReplace(t, 'points', '', [rfReplaceAll, rfIgnoreCase]);
  re1.Expression := 'right;">(.*?)</td>'; //1st fighter
  if re1.Exec(t) then
    repeat
      lst1.Add(re1.Match[1]);
    until not re1.ExecNext;
  data_list.Cells[15, 1] := lst1.strings[0];  //ranking
  data_list.Cells[16, 1] := lst1.Strings[1];  //points before fight
  data_list.Cells[17, 1] := lst1.Strings[2];  //points after fight
  lst1.Clear;

  re1.Expression := 'left;">(.*?)</td>';  //2nd fighter
  if re1.Exec(t) then
    repeat
      lst1.Add(re1.Match[1]);
    until not re1.ExecNext;
  data_list.Cells[18, 1] := lst1.strings[0];  //ranking
  data_list.Cells[19, 1] := lst1.Strings[1];  //points before fight
  data_list.Cells[20, 1] := lst1.Strings[2];  //points after fight
  lst1.Clear;

end;

end.
