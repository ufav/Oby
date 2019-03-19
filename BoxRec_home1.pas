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
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cnnctClick(Sender: TObject);
    procedure gtdtClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  with data_list do
    begin
      Cells[0, 0] := '1st fighter';
      Cells[1, 0] := '2nd fighter';
      Cells[2, 0] := 'Event''s Date';
      Cells[3, 0] := 'Referee';
      Cells[4, 0] := 'Ref. sc 1st';
      Cells[5, 0] := 'Ref. sc 2nd';
      Cells[6, 0] := '1st judge';
      Cells[7, 0] := '2nd judge';
      Cells[8, 0] := '3rd judge';
      Cells[9, 0] := '1j sc 1st';
      Cells[10, 0] := '1j sc 2nd';
      Cells[11, 0] := '2j sc 1st';
      Cells[12, 0] := '2j sc 2nd';
      Cells[13, 0] := '3j sc 1st';
      Cells[14, 0] := '3j sc 2nd';
      Cells[15, 0] := 'Text won';
      Cells[16, 0] := 'Round won';
      Cells[17, 0] := '1st ranking';
      Cells[18, 0] := '1st pts before';
      Cells[19, 0] := '1st pts after';
      Cells[20, 0] := '2nd ranking';
      Cells[21, 0] := '2nd pts before';
      Cells[22, 0] := '2nd pts after';
      Cells[23, 0] := '1st age';
      Cells[24, 0] := '2nd age';
      Cells[25, 0] := '1st stance';
      Cells[26, 0] := '2nd stance';
      Cells[27, 0] := '1st height';
      Cells[28, 0] := '2nd height';
      Cells[29, 0] := '1st reach';
      Cells[30, 0] := '2nd reach';
      Cells[31, 0] := '1st won';
      Cells[32, 0] := '2nd won';
      Cells[33, 0] := '1st lost';
      Cells[34, 0] := '2nd lost';
      Cells[35, 0] := '1st drawn';
      Cells[36, 0] := '2nd drawn';
      Cells[37, 0] := '1st KOs';
      Cells[38, 0] := '2nd KOs';
    end;
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

  for k := Memo1.Lines.Count - 1 downto 0 do
    begin
      IdHTTP := TIdHTTP.Create;
      IdHTTP.HandleRedirects := True;
      IdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';

      re1 := TRegExpr.Create;
      lst1 := TStringList.Create;
      lst2 := TStringList.Create;

      s := IdHTTP.Get('http://boxrec.com/en/event/783549/' + Memo1.Lines[k]); //fighters block
      t := Copy(s, Pos('pageHeading', s), Pos('starBase', s) - Pos('pageHeading', s));

      re1.Expression := 'Link">(.*?)</a>';  //fighters
      if re1.Exec(t) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
      data_list.Cells[0, k + 1] := lst1.Strings[0];
      data_list.Cells[1, k + 1] := lst1.Strings[1];
      lst1.Clear;

      re1.Expression := '\d{4}-\d{2}-\d{2}';  //event's date
      re1.Exec(s);
      data_list.Cells[2, k + 1] := re1.Match[0];

      if Pos('/referee/', s) > 0 then //referee*
        begin
          t := Copy(s, Pos('/referee/', s), 200);
          re1.Expression := 'Link">(.*?)</a>';
          re1.Exec(t);
          data_list.Cells[3, k + 1] := re1.Match[1];
          t := Copy(s, Pos('/referee/', s) - 150, 300);
          re1.Expression := 'right;font-size:0.8em;" width="40%">(.*?)</td>';
          re1.Exec(t);
          data_list.Cells[4, k + 1] := re1.Match[1];
          re1.Expression := 'left;font-size:0.8em;"  width="40%">(.*?)</td>';
          re1.Exec(t);
          data_list.Cells[5, k + 1] := re1.Match[1];

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
          data_list.Cells[6, k + 1] := lst2.strings[0];
          data_list.Cells[7, k + 1] := lst2.Strings[1];
          data_list.Cells[8, k + 1] := lst2.Strings[2];
          lst1.Clear;
          lst2.Clear;

          t := Copy(s, Pos('<b>judges</b>', s), 1500);  //judge's scorecards
          re1.Expression := '8em;" width="40\%">(.*?)</td>';
          if re1.Exec(t) then
            repeat
              lst1.Add(re1.Match[1]);
            until not re1.ExecNext;
          data_list.Cells[9, k + 1] := lst1.strings[0];
          data_list.Cells[10, k + 1] := lst1.Strings[1];
          data_list.Cells[11, k + 1] := lst1.Strings[2];
          data_list.Cells[12, k + 1] := lst1.Strings[3];
          data_list.Cells[13, k + 1] := lst1.Strings[4];
          data_list.Cells[14, k + 1] := lst1.Strings[5];
          lst1.Clear;
        end;

      t := Copy(s, Pos('<br><span class="textWon">', s), 200);  //text won
      re1.Expression := 'Won">(.*?)</span>';
      re1.Exec(t);
      data_list.Cells[15, k + 1] := re1.Match[1];

      re1.Expression := '\s<br>(.*?)\n';  //round won
      re1.Exec(t);
      data_list.Cells[16, k + 1] := re1.Match[1];

      t := Copy(s, Pos('ranking', s), Pos('details', s) - Pos('ranking', s)); //ranking
      t := StringReplace(t, 'points', '', [rfReplaceAll, rfIgnoreCase]);
      re1.Expression := 'right;">(.*?)</td>'; //1st fighter
      if re1.Exec(t) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
      data_list.Cells[17, k + 1] := lst1.strings[0];  //ranking
      data_list.Cells[18, k + 1] := lst1.Strings[1];  //points before fight
      data_list.Cells[19, k + 1] := lst1.Strings[2];  //points after fight
      lst1.Clear;

      re1.Expression := 'left;">(.*?)</td>';  //2nd fighter
      if re1.Exec(t) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
      data_list.Cells[20, k + 1] := lst1.strings[0];  //ranking
      data_list.Cells[21, k + 1] := lst1.Strings[1];  //points before fight
      data_list.Cells[22, k + 1] := lst1.Strings[2];  //points after fight
      lst1.Clear;

      if Pos('<b>age</b>', s) > 0 then  //age
        begin
          t := Copy(s, Pos('<b>age</b>', s) - 75, 150);
          re1.Expression := 'right;">(.*?)</td>';  //age 1st fighter
          re1.Exec(t);
          data_list.Cells[23, k + 1] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //age 2nd fighter
          re1.Exec(t);
          data_list.Cells[24, k + 1] := re1.Match[1];
        end;

      if Pos('<b>stance</b>', s) > 0 then  //stance
        begin
          t := Copy(s, Pos('stance', s) - 100, 200);
          re1.Expression := 'right;">(.*?)</td>';  //stance 1st fighter
          re1.Exec(t);
          data_list.Cells[25, k + 1] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //stance 2nd fighter
          re1.Exec(t);
          data_list.Cells[26, k + 1] := re1.Match[1];
        end;

      if Pos('<b>height</b>', s) > 0 then  //height
        begin
          t := Copy(s, Pos('<b>height</b>', s) - 103, 206);
          re1.Expression := 'right;">(.*?)</td>';  //height 1st fighter
          re1.Exec(t);
          data_list.Cells[27, k + 1] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //height 2nd fighter
          re1.Exec(t);
          data_list.Cells[28, k + 1] := re1.Match[1];
        end;

      if Pos('<b>reach</b>', s) > 0 then  //reach
        begin
          t := Copy(s, Pos('<b>reach</b>', s) - 120, 240);
          re1.Expression := 'right;">(.*?)</td>';  //reach 1st fighter
          re1.Exec(t);
          data_list.Cells[29, k + 1] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //reach 2nd fighter
          re1.Exec(t);
          data_list.Cells[30, k + 1] := re1.Match[1];
        end;

      if Pos('<b>won</b>', s) > 0 then  //won
        begin
          t := Copy(s, Pos('<b>won</b>', s) - 100, 200);
          re1.Expression := 'right;" class="textWon">(.*?)</td>';  //won 1st fighter
          re1.Exec(t);
          data_list.Cells[31, k + 1] := re1.Match[1];
          re1.Expression := 'left;" class="textWon">(.*?)</td>';  //won 2nd fighter
          re1.Exec(t);
          data_list.Cells[32, k + 1] := re1.Match[1];
        end;

      if Pos('<b>lost</b>', s) > 0 then //lost
        begin
          t := Copy(s, Pos('<b>lost</b>', s) - 100, 200);
          re1.Expression := 'right;" class="textLost">(.*?)</td>';  //lost 1st fighter
          re1.Exec(t);
          data_list.Cells[33, k + 1] := re1.Match[1];
          re1.Expression := 'left;" class="textLost">(.*?)</td>';  //lost 2nd fighter
          re1.Exec(t);
          data_list.Cells[34, k + 1] := re1.Match[1];
        end;

      if Pos('<b>drawn</b>', s) > 0 then  //drawn
        begin
          t := Copy(s, Pos('<b>drawn</b>', s) - 100, 200);
          re1.Expression := 'right;" class="textDraw">(.*?)</td>';  //drawn 1st fighter
          re1.Exec(t);
          data_list.Cells[35, k + 1] := re1.Match[1];
          re1.Expression := 'left;" class="textDraw">(.*?)</td>';  //drawn 2nd fighter
          re1.Exec(t);
          data_list.Cells[36, k + 1] := re1.Match[1];
        end;

      if Pos('<b>KOs</b>', s) > 0 then  //KOs
        begin
          t := Copy(s, Pos('<b>KOs</b>', s) - 80, 160);
          re1.Expression := 'right;">(.*?)</td>';  //KOs 1st fighter
          re1.Exec(t);
          data_list.Cells[37, k + 1] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //KOs 2nd fighter
          re1.Exec(t);
          data_list.Cells[38, k + 1] := re1.Match[1];
        end;

      FreeAndNil(IdHTTP); //убиваем всё созданное
      FreeAndNil(lst1);
      FreeAndNil(lst2);
      FreeAndNil(re1);
    end;

end;


procedure TForm1.Button1Click(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  s, t, u: string;
  i, j, k: Integer;
  lst1, lst2, lst3: TStringList;
  re1, re2, re3: TRegExpr;
  flag: Boolean;
begin
  IdHTTP := TIdHTTP.Create;
  re1 := TRegExpr.Create;
  lst1 := TStringList.Create;
  s := IdHTTP.Get('http://boxrec.com/en/event/783549');
  re1.Expression := 'id="ma(.*?)"';
  if re1.Exec(s) then
    repeat
      lst1.Add(re1.Match[1]);
    until not re1.ExecNext;
  Memo1.Text := lst1.Text;
  lst1.Clear;
end;


end.
