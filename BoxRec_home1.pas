unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdHTTP, RegExpr, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  Vcl.StdCtrls, Vcl.Grids, IdBaseComponent, IdAntiFreezeBase, Vcl.IdAntiFreeze;

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
    IdAntiFreeze1: TIdAntiFreeze;
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
  function CountPos(const subtext: string; Text: string): Integer;

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
      Cells[15, 0] := 'Contest';
      Cells[16, 0] := 'Rounds';
      Cells[17, 0] := 'WLD';
      Cells[18, 0] := 'Text won';
      Cells[19, 0] := 'Round won';
      Cells[20, 0] := '1st ranking';
      Cells[21, 0] := '1st pts before';
      Cells[22, 0] := '1st pts after';
      Cells[23, 0] := '2nd ranking';
      Cells[24, 0] := '2nd pts before';
      Cells[25, 0] := '2nd pts after';
      Cells[26, 0] := '1st age';
      Cells[27, 0] := '2nd age';
      Cells[28, 0] := '1st stance';
      Cells[29, 0] := '2nd stance';
      Cells[30, 0] := '1st height';
      Cells[31, 0] := '2nd height';
      Cells[32, 0] := '1st reach';
      Cells[33, 0] := '2nd reach';
      Cells[34, 0] := '1st won';
      Cells[35, 0] := '2nd won';
      Cells[36, 0] := '1st lost';
      Cells[37, 0] := '2nd lost';
      Cells[38, 0] := '1st drawn';
      Cells[39, 0] := '2nd drawn';
      Cells[40, 0] := '1st KOs';
      Cells[41, 0] := '2nd KOs';
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

  for i := 1 to Memo1.Lines.Count do
    begin
      IdHTTP := TIdHTTP.Create;
      IdHTTP.HandleRedirects := True;
      IdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';

      re1 := TRegExpr.Create;
      lst1 := TStringList.Create;
      lst2 := TStringList.Create;

      //783549/2327203
      s := IdHTTP.Get('http://boxrec.com/en/event/744074/' + Memo1.Lines[i - 1]); //fighters block
      t := Copy(s, Pos('pageHeading', s), Pos('starBase', s) - Pos('pageHeading', s));

      if Pos('TBA', t) > 0 then Continue;

      re1.Expression := 'Link">(.*?)</a>';  //fighters
      if re1.Exec(t) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
      data_list.Cells[0, i] := lst1.Strings[0];
      data_list.Cells[1, i] := lst1.Strings[1];
      lst1.Clear;

      re1.Expression := '\d{4}-\d{2}-\d{2}';  //event's date
      re1.Exec(s);
      data_list.Cells[2, i] := re1.Match[0];

      if Pos('/referee/', s) > 0 then //referee*
        begin
          t := Copy(s, Pos('/referee/', s), 200);
          re1.Expression := 'Link">(.*?)</a>';
          re1.Exec(t);
          data_list.Cells[3, i] := re1.Match[1];
          t := Copy(s, Pos('/referee/', s) - 150, 300);
          re1.Expression := 'right;font-size:0.8em;" width="40%">(.*?)</td>';
          re1.Exec(t);
          data_list.Cells[4, i] := re1.Match[1];
          re1.Expression := 'left;font-size:0.8em;"  width="40%">(.*?)</td>';
          re1.Exec(t);
          data_list.Cells[5, i] := re1.Match[1];

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
          data_list.Cells[6, i] := lst2.strings[0];
          data_list.Cells[7, i] := lst2.Strings[1];
          if CountPos('/judge/', s) > 2 then
            data_list.Cells[8, i] := lst2.Strings[2];
          lst1.Clear;
          lst2.Clear;

          t := Copy(s, Pos('<b>judges</b>', s), 1500);  //judge's scorecards
          re1.Expression := '8em;" width="40\%">(.*?)</td>';
          if re1.Exec(t) then
            repeat
              lst1.Add(re1.Match[1]);
            until not re1.ExecNext;
          data_list.Cells[9, i] := lst1.strings[0];
          data_list.Cells[10, i] := lst1.Strings[1];
          data_list.Cells[11, i] := lst1.Strings[2];
          data_list.Cells[12, i] := lst1.Strings[3];
          if CountPos('/judge/', s) > 2 then
            begin
              data_list.Cells[13, i] := lst1.Strings[4];
              data_list.Cells[14, i] := lst1.Strings[5];
            end;
          lst1.Clear;
        end;

      t := Copy(s, Pos('primaryIcon', s), Pos('responseLessDataTable', s) - Pos('primaryIcon', s));  //Contest, Rounds
      re1.Expression := '<h2>(.*?)</h2>';
      re1.Exec(t);
      data_list.Cells[15, i] := Trim(StringReplace(Copy(re1.Match[1], 1, Pos(',', re1.Match[1]) - 1), 'Contest', '', [rfReplaceAll, rfIgnoreCase]));
      data_list.Cells[16, i] := Trim(StringReplace(copy(re1.Match[1], Pos(',', re1.Match[1]) + 1, Length(re1.Match[1]) - Pos(',', re1.Match[1]) + 1), 'Rounds', '', [rfReplaceAll, rfIgnoreCase]));

      t := Copy(s, Pos('starBase', s), Pos('<b>ranking</b>', s) - Pos('starBase', s));  //WLD
      t := Copy(t, Pos(data_list.Cells[0, i], t), Pos(data_list.Cells[1, i], t) - Pos(data_list.Cells[0, i], t));
      if Pos('textWon', t) > 0 then
        data_list.Cells[17, i] := '1'
      else
        data_list.Cells[17, i] := '2';

      if Pos('<br><span class="textDrawn">', s) > 0 then  //text drawn
        begin
          data_list.Cells[17, i] := '0';
          re1.Expression := 'textDrawn">(.*?)</span>';
          re1.Exec(s);
          data_list.Cells[18, i] := re1.Match[1];
        end
      else
        begin
          t := Copy(s, Pos('<br><span class="textWon">', s), 200);  //text won
          re1.Expression := 'Won">(.*?)</span>';
          re1.Exec(t);
          data_list.Cells[18, i] := Trim(StringReplace(re1.Match[1], 'won', '', [rfReplaceAll, rfIgnoreCase]));

          re1.Expression := '\s<br>(.*?)\n';  //round won
          re1.Exec(t);
          data_list.Cells[19, i] := Trim(StringReplace(re1.Match[1], 'round', '', [rfReplaceAll, rfIgnoreCase]));
        end;

      t := Copy(s, Pos('ranking', s), Pos('details', s) - Pos('ranking', s)); //ranking
      t := StringReplace(t, 'points', '', [rfReplaceAll, rfIgnoreCase]);
      re1.Expression := 'right;">(.*?)</td>'; //1st fighter
      if re1.Exec(t) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
      data_list.Cells[20, i] := lst1.strings[0];  //ranking
      data_list.Cells[21, i] := lst1.Strings[1];  //points before fight
      data_list.Cells[22, i] := lst1.Strings[2];  //points after fight
      lst1.Clear;

      re1.Expression := 'left;">(.*?)</td>';  //2nd fighter
      if re1.Exec(t) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
      data_list.Cells[23, i] := lst1.strings[0];  //ranking
      data_list.Cells[24, i] := lst1.Strings[1];  //points before fight
      data_list.Cells[25, i] := lst1.Strings[2];  //points after fight
      lst1.Clear;

      if Pos('<b>age</b>', s) > 0 then  //age
        begin
          t := Copy(s, Pos('<b>age</b>', s) - 75, 150);
          re1.Expression := 'right;">(.*?)</td>';  //age 1st fighter
          re1.Exec(t);
          data_list.Cells[26, i] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //age 2nd fighter
          re1.Exec(t);
          data_list.Cells[27, i] := re1.Match[1];
        end;

      if Pos('<b>stance</b>', s) > 0 then  //stance
        begin
          j := 200;
          repeat
            begin
              t := Copy(s, Pos('stance', s) - j, j * 2);
              j := j - 5;
            end;
          until (CountPos('right;">', t) = 1) and (CountPos('left;">', t) = 1);
          re1.Expression := 'right;">(.*?)</td>';  //stance 1st fighter
          re1.Exec(t);
          data_list.Cells[28, i] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //stance 2nd fighter
          re1.Exec(t);
          data_list.Cells[29, i] := re1.Match[1];
        end;

      if Pos('<b>height</b>', s) > 0 then  //height
        begin
          t := Copy(s, Pos('<b>height</b>', s) - 103, 206);
          re1.Expression := 'right;">(.*?)</td>';  //height 1st fighter
          re1.Exec(t);
          data_list.Cells[30, i] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //height 2nd fighter
          re1.Exec(t);
          data_list.Cells[31, i] := re1.Match[1];
        end;

      if Pos('<b>reach</b>', s) > 0 then  //reach
        begin
          t := Copy(s, Pos('<b>reach</b>', s) - 120, 240);
          re1.Expression := 'right;">(.*?)</td>';  //reach 1st fighter
          re1.Exec(t);
          data_list.Cells[32, i] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //reach 2nd fighter
          re1.Exec(t);
          data_list.Cells[33, i] := re1.Match[1];
        end;

      if Pos('<b>won</b>', s) > 0 then  //won
        begin
          t := Copy(s, Pos('<b>won</b>', s) - 100, 200);
          re1.Expression := 'right;" class="textWon">(.*?)</td>';  //won 1st fighter
          re1.Exec(t);
          data_list.Cells[34, i] := re1.Match[1];
          re1.Expression := 'left;" class="textWon">(.*?)</td>';  //won 2nd fighter
          re1.Exec(t);
          data_list.Cells[35, i] := re1.Match[1];
        end;

      if Pos('<b>lost</b>', s) > 0 then //lost
        begin
          t := Copy(s, Pos('<b>lost</b>', s) - 100, 200);
          re1.Expression := 'right;" class="textLost">(.*?)</td>';  //lost 1st fighter
          re1.Exec(t);
          data_list.Cells[36, i] := re1.Match[1];
          re1.Expression := 'left;" class="textLost">(.*?)</td>';  //lost 2nd fighter
          re1.Exec(t);
          data_list.Cells[37, i] := re1.Match[1];
        end;

      if Pos('<b>drawn</b>', s) > 0 then  //drawn
        begin
          t := Copy(s, Pos('<b>drawn</b>', s) - 100, 200);
          re1.Expression := 'right;" class="textDraw">(.*?)</td>';  //drawn 1st fighter
          re1.Exec(t);
          data_list.Cells[38, i] := re1.Match[1];
          re1.Expression := 'left;" class="textDraw">(.*?)</td>';  //drawn 2nd fighter
          re1.Exec(t);
          data_list.Cells[39, i] := re1.Match[1];
        end;

      if Pos('<b>KOs</b>', s) > 0 then  //KOs
        begin
          t := Copy(s, Pos('<b>KOs</b>', s) - 80, 160);
          re1.Expression := 'right;">(.*?)</td>';  //KOs 1st fighter
          re1.Exec(t);
          data_list.Cells[40, i] := re1.Match[1];
          re1.Expression := 'left;">(.*?)</td>';  //KOs 2nd fighter
          re1.Exec(t);
          data_list.Cells[41, i] := re1.Match[1];
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
  s := IdHTTP.Get('http://boxrec.com/en/event/744074');
  re1.Expression := 'id="ma(.*?)"';
  if re1.Exec(s) then
    repeat
      lst1.Add(re1.Match[1]);
    until not re1.ExecNext;
  Memo1.Text := lst1.Text;
  lst1.Clear;
end;

function CountPos(const subtext: string; Text: string): Integer;
  begin
    if (Length(subtext) = 0) or (Length(Text) = 0) or (Pos(subtext, Text) = 0) then
      Result := 0
    else
      Result := (Length(Text) - Length(StringReplace(Text, subtext, '', [rfReplaceAll]))) div Length(subtext);
  end;

end.
