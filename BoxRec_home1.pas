unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdHTTP, RegExpr, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  Vcl.StdCtrls, Vcl.Grids, IdBaseComponent, IdAntiFreezeBase,
  IdAntiFreeze;

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
    Memo2: TMemo;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cnnctClick(Sender: TObject);
    procedure gtdtClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  function CountPos(const subtext: string; Text: string): Integer;
  function StripTag(S: string): string;

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
      Cells[4, 0] := 'Promoters';
      Cells[5, 0] := 'Matchmakers';
      Cells[6, 0] := '1st judge';
      Cells[7, 0] := '2nd judge';
      Cells[8, 0] := '3rd judge';
      Cells[9, 0] := 'Location';
      Cells[10, 0] := '1st last 6';
      Cells[11, 0] := '2nd last 6';
      Cells[12, 0] := 'Contest';
      Cells[13, 0] := 'Rounds';
      Cells[14, 0] := 'WLD';
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
      Cells[39, 0] := '1st birthdate';
      Cells[40, 0] := '2nd birthdate';
      Cells[41, 0] := '1st residence';
      Cells[42, 0] := '2nd residence';
      Cells[43, 0] := '1st birthplace';
      Cells[44, 0] := '2nd birthplace';
    end;
end;

procedure TForm1.gtdtClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  s, t, u: string;
  i, j, k: Integer;
  lst1, lst2, lst3, lst4: TStringList;
  re1, re2, re3: TRegExpr;
  flag: Boolean;
  frst, scnd, edate, refr, prom, mm, fj, sj, tj, loc, fl6, sl6, cntst, rnds, wld, twon, rwon, fr, sr, fage, sage, fstnc, sstnc, fhgth, shgth, frch, srch, fwon, swon, flost, slost, fdrwn, sdrwn, fko, sko, fbd, sbd, fres, sres, fbp, sbp: string;
begin

  lst3 := TStringList.Create;
  lst4 := TStringList.Create;

  for i := 1 to Memo1.Lines.Count do
    begin
      IdHTTP := TIdHTTP.Create;
      IdHTTP.HandleRedirects := True;
      IdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';
      re1 := TRegExpr.Create;




      s := IdHTTP.Get('http://boxrec.com/en/date?Pnr[date][year]=' +
      Copy(Memo1.Lines.Strings[i - 1], 7, 4) + '&Pnr[date][month]=' +
      Copy(Memo1.Lines.Strings[i - 1], 4, 2) + '&Pnr[date][day]=' +
      Copy(Memo1.Lines.Strings[i - 1], 1, 2) + '&d_go=');
      {s := IdHTTP.Get('http://boxrec.com/en/date?lrc[date]' +
        '[year]=' + Copy(Memo1.Lines.Strings[i - 1], 7, 4) +
        '&lrc[date][month]=' + Copy(Memo1.Lines.Strings[i - 1], 4, 2) +
        '&lrc[date][day]=' + Copy(Memo1.Lines.Strings[i - 1], 1, 2) + '&d_go=');}
      re1.Expression := ';">    <a href="/en/event/(.*?)"><div';
      if re1.Exec(s) then
        repeat
          lst3.Add(re1.Match[1]);
        until not re1.ExecNext;
      FreeAndNil(IdHTTP); //убиваем всё созданное
      FreeAndNil(re1);
    end;

  Memo2.Text := lst3.Text;

  for i := 1 to lst3.Count do
    try
      begin
        IdHTTP := TIdHTTP.Create;
        IdHTTP.HandleRedirects := True;
        IdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';

        re1 := TRegExpr.Create;
        lst1 := TStringList.Create;
        lst2 := TStringList.Create;

        s := IdHTTP.Get('http://boxrec.com/en/event/' + lst3.Strings[i - 1]); //fighters block
        t := Copy(s, Pos('pageHeading', s), Pos('starBase', s) - Pos('pageHeading', s));
        //.Text := s;

        if Pos('TBA', t) > 0 then Continue;

        re1.Expression := 'Link">(.*?)</a>';  //fighters
        if re1.Exec(t) then
          repeat
            lst1.Add(re1.Match[1]);
          until not re1.ExecNext;
        frst := lst1.Strings[0];
        scnd := lst1.Strings[1];
        data_list.Cells[0, i] := lst1.Strings[0];
        data_list.Cells[1, i] := lst1.Strings[1];
        lst1.Clear;

        re1.Expression := '\d{4}-\d{2}-\d{2}';  //event's date
        re1.Exec(s);
        edate := re1.Match[0];
        data_list.Cells[2, i] := re1.Match[0];

        if Pos('/referee/', s) > 0 then //referee*
          begin
            t := Copy(s, Pos('/referee/', s), 200);
            re1.Expression := 'Link">(.*?)</a>';
            re1.Exec(t);
            refr := re1.Match[1];
            data_list.Cells[3, i] := re1.Match[1];
          end;

        if Pos('<b>promoter</b>', s) > 0 then //promoters*
          begin
            t := Copy(s, Pos('<b>promoter</b>', s), Pos('footerAd', s) - Pos('<b>promoter</b>', s));
            re1.Expression := 'ter</b>(.*?)</tr>';
            re1.Exec(t);
            prom := StripTag(re1.Match[1]);
            data_list.Cells[4, i] := StripTag(re1.Match[1]);
          end;

        if Pos('<b>matchmaker</b>', s) > 0 then //matchmakers*
          begin
            t := Copy(s, Pos('<b>matchmaker</b>', s), Pos('footerAd', s) - Pos('<b>matchmaker</b>', s));
            re1.Expression := 'ker</b>(.*?)</tr>';
            re1.Exec(t);
            mm := StripTag(re1.Match[1]);
            data_list.Cells[5, i] := StripTag(re1.Match[1]);
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
            fj := lst2.strings[0];
            data_list.Cells[6, i] := lst2.strings[0];
            if CountPos('/judge/', s) > 1 then
              begin
                sj := lst2.strings[1];
                data_list.Cells[7, i] := lst2.Strings[1];
              end;
            if CountPos('/judge/', s) > 2 then
              begin
                tj := lst2.strings[2];
                data_list.Cells[8, i] := lst2.Strings[2];
              end;
            lst1.Clear;
            lst2.Clear;
          end;

        if Pos('/venue/', s) > 0 then //location*
          begin
            t := Copy(s, Pos('/venue/', s), Pos('responseLessDataTable', s) - Pos('/venue/', s));
            re1.Expression := '\d{2}">(.*?)<br>';
            re1.Exec(t);
            loc := Trim(StripTag(re1.Match[1]));
            data_list.Cells[9, i] := Trim(StripTag(re1.Match[1]));
          end;

        if Pos('<b>last 6</b>', s) > 0 then //1st last 6*
          begin
            t := Copy(s, Pos('<b>last 6</b>', s), Pos('footerAd', s) - Pos('<b>last 6</b>', s));
            re1.Expression := '20%" style="text-align:right;">(.*?)">';
            if re1.Exec(t) then
              repeat
                begin
                  if Pos(widestring('span class'), re1.Match[1]) = 0 then
                    lst1.Add('0')
                  else
                    lst1.Add(Trim(Copy(re1.Match[1], Pos('"', re1.Match[1]) + 1, Length(re1.Match[1]) - Pos('"', re1.Match[1]))));
                end;
              until not re1.ExecNext;
            lst1.Text := StringReplace(lst1.Text, 'textWon', '1', [rfReplaceAll, rfIgnoreCase]);
            lst1.Text := StringReplace(lst1.Text, 'textLost', '2', [rfReplaceAll, rfIgnoreCase]);
            lst1.Text := StringReplace(lst1.Text, 'textDrawn', '3', [rfReplaceAll, rfIgnoreCase]);
            lst1.Delimiter := ';';
            data_list.Cells[10, i] := lst1.DelimitedText;
            data_list.Cells[10, i] := StringReplace(data_list.Cells[10, i] , ';', '', [rfReplaceAll, rfIgnoreCase]);
            fl6 := data_list.Cells[10, i];
            lst1.Clear;
            re1.Expression := 'left;">(.*?)">';
            if re1.Exec(t) then
              repeat
                begin
                  if Pos(widestring('span class'), re1.Match[1]) = 0 then
                    lst1.Add('0')
                  else
                    lst1.Add(Trim(Copy(re1.Match[1], Pos('"', re1.Match[1]) + 1, Length(re1.Match[1]) - Pos('"', re1.Match[1]))));
                end;
              until not re1.ExecNext;
            lst1.Text := StringReplace(lst1.Text, 'textWon', '1', [rfReplaceAll, rfIgnoreCase]);
            lst1.Text := StringReplace(lst1.Text, 'textLost', '2', [rfReplaceAll, rfIgnoreCase]);
            lst1.Text := StringReplace(lst1.Text, 'textDrawn', '3', [rfReplaceAll, rfIgnoreCase]);
            lst1.Delimiter := ';';
            data_list.Cells[11, i] := lst1.DelimitedText;
            data_list.Cells[11, i] := StringReplace(data_list.Cells[11, i] , ';', '', [rfReplaceAll, rfIgnoreCase]);
            sl6 := data_list.Cells[11, i];
            lst1.Clear;
          end;

            {t := Copy(s, Pos('<b>judges</b>', s), 1500);  //judge's scorecards
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
            lst1.Clear;}

        t := Copy(s, Pos('primaryIcon', s), Pos('responseLessDataTable', s) - Pos('primaryIcon', s));  //Contest, Rounds
        re1.Expression := '<h2>(.*?)</h2>';
        re1.Exec(t);
        data_list.Cells[12, i] := Trim(StringReplace(Copy(re1.Match[1], 1, Pos(',', re1.Match[1]) - 1), 'Contest', '', [rfReplaceAll, rfIgnoreCase]));
        data_list.Cells[13, i] := Trim(StringReplace(copy(re1.Match[1], Pos(',', re1.Match[1]) + 1, Length(re1.Match[1]) - Pos(',', re1.Match[1]) + 1), 'Rounds', '', [rfReplaceAll, rfIgnoreCase]));
        cntst := data_list.Cells[12, i];
        rnds := data_list.Cells[13, i];

        t := Copy(s, Pos('starBase', s), Pos('<b>ranking</b>', s) - Pos('starBase', s));  //WLD
        t := Copy(t, Pos(data_list.Cells[0, i], t), Pos(data_list.Cells[1, i], t) - Pos(data_list.Cells[0, i], t));
        if Pos('textWon', t) > 0 then
          data_list.Cells[14, i] := '1'
        else
          data_list.Cells[14, i] := '2';

        if Pos('<br><span class="textDrawn">', s) > 0 then  //text drawn
          begin
            data_list.Cells[14, i] := '0';
            re1.Expression := 'textDrawn">(.*?)</span>';
            re1.Exec(s);
            data_list.Cells[15, i] := re1.Match[1];
          end
        else
          begin
            t := Copy(s, Pos('<br><span class="textWon">', s), 200);  //text won
            re1.Expression := 'Won">(.*?)</span>';
            re1.Exec(t);
            data_list.Cells[15, i] := Trim(StringReplace(re1.Match[1], 'won', '', [rfReplaceAll, rfIgnoreCase]));

            re1.Expression := '\s<br>(.*?)\n';  //round won
            re1.Exec(t);
            data_list.Cells[16, i] := Trim(StringReplace(re1.Match[1], 'round', '', [rfReplaceAll, rfIgnoreCase]));
          end;

        t := Copy(s, Pos('ranking', s), Pos('details', s) - Pos('ranking', s)); //ranking
        t := StringReplace(t, 'points', '', [rfReplaceAll, rfIgnoreCase]);
        re1.Expression := 'right;">(.*?)</td>'; //1st fighter
        if re1.Exec(t) then
          repeat
            lst1.Add(re1.Match[1]);
          until not re1.ExecNext;
        data_list.Cells[17, i] := lst1.strings[0];  //ranking
        data_list.Cells[18, i] := lst1.Strings[1];  //points before fight
        data_list.Cells[19, i] := lst1.Strings[2];  //points after fight
        lst1.Clear;

        re1.Expression := 'left;">(.*?)</td>';  //2nd fighter
        if re1.Exec(t) then
          repeat
            lst1.Add(re1.Match[1]);
          until not re1.ExecNext;
        data_list.Cells[20, i] := lst1.strings[0];  //ranking
        data_list.Cells[21, i] := lst1.Strings[1];  //points before fight
        data_list.Cells[22, i] := lst1.Strings[2];  //points after fight
        lst1.Clear;

        if Pos('<b>age</b>', s) > 0 then  //age
          begin
            j := 100;
            repeat
              begin
                t := Copy(s, Pos('<b>age</b>', s) - j, j * 2);
                j := j - 5;
              end;
            until (CountPos('right;">', t) = 1) and (CountPos('left;">', t) = 1);
            re1.Expression := 'right;">(.*?)</td>';  //age 1st fighter
            re1.Exec(t);
            data_list.Cells[23, i] := re1.Match[1];
            re1.Expression := 'left;">(.*?)</td>';  //age 2nd fighter
            re1.Exec(t);
            data_list.Cells[24, i] := re1.Match[1];
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
            data_list.Cells[25, i] := re1.Match[1];
            re1.Expression := 'left;">(.*?)</td>';  //stance 2nd fighter
            re1.Exec(t);
            data_list.Cells[26, i] := re1.Match[1];
          end;

        if Pos('<b>height</b>', s) > 0 then  //height
          begin
            j := 150;
            repeat
              begin
                t := Copy(s, Pos('<b>height</b>', s) - j, j * 2);
                j := j - 5;
              end;
            until (CountPos('right;">', t) = 1) and (CountPos('left;">', t) = 1);
            re1.Expression := 'right;">(.*?)</td>';  //height 1st fighter
            re1.Exec(t);
            data_list.Cells[27, i] := re1.Match[1];
            re1.Expression := 'left;">(.*?)</td>';  //height 2nd fighter
            re1.Exec(t);
            data_list.Cells[28, i] := re1.Match[1];
          end;

        if Pos('<b>reach</b>', s) > 0 then  //reach
          begin
            j := 150;
            repeat
              begin
                t := Copy(s, Pos('<b>reach</b>', s) - j, j * 2);
                j := j - 5;
              end;
            until (CountPos('right;">', t) = 1) and (CountPos('left;">', t) = 1);
            re1.Expression := 'right;">(.*?)</td>';  //reach 1st fighter
            re1.Exec(t);
            data_list.Cells[29, i] := re1.Match[1];
            re1.Expression := 'left;">(.*?)</td>';  //reach 2nd fighter
            re1.Exec(t);
            data_list.Cells[30, i] := re1.Match[1];
          end;

        if Pos('<b>won</b>', s) > 0 then  //won
          begin
            j := 150;
            repeat
              begin
                t := Copy(s, Pos('<b>won</b>', s) - j, j * 2);
                j := j - 5;
              end;
            until (CountPos('right;" class="textWon">', t) = 1) and (CountPos('left;" class="textWon">', t) = 1);
            re1.Expression := 'right;" class="textWon">(.*?)</td>';  //won 1st fighter
            re1.Exec(t);
            data_list.Cells[31, i] := re1.Match[1];
            re1.Expression := 'left;" class="textWon">(.*?)</td>';  //won 2nd fighter
            re1.Exec(t);
            data_list.Cells[32, i] := re1.Match[1];
          end;

        if Pos('<b>lost</b>', s) > 0 then //lost
          begin
            t := Copy(s, Pos('<b>lost</b>', s) - 100, 200);
            re1.Expression := 'right;" class="textLost">(.*?)</td>';  //lost 1st fighter
            re1.Exec(t);
            data_list.Cells[33, i] := re1.Match[1];
            re1.Expression := 'left;" class="textLost">(.*?)</td>';  //lost 2nd fighter
            re1.Exec(t);
            data_list.Cells[34, i] := re1.Match[1];
          end;

        if Pos('<b>drawn</b>', s) > 0 then  //drawn
          begin
            t := Copy(s, Pos('<b>drawn</b>', s) - 100, 200);
            re1.Expression := 'right;" class="textDraw">(.*?)</td>';  //drawn 1st fighter
            re1.Exec(t);
            data_list.Cells[35, i] := re1.Match[1];
            re1.Expression := 'left;" class="textDraw">(.*?)</td>';  //drawn 2nd fighter
            re1.Exec(t);
            data_list.Cells[36, i] := re1.Match[1];
          end;

        if Pos('<b>KOs</b>', s) > 0 then  //KOs
          begin
            j := 100;
            repeat
              begin
                t := Copy(s, Pos('<b>KOs</b>', s) - j, j * 2);
                j := j - 5;
              end;
            until (CountPos('right;">', t) = 1) and (CountPos('left;">', t) = 1);
            re1.Expression := 'right;">(.*?)</td>';  //KOs 1st fighter
            re1.Exec(t);
            data_list.Cells[37, i] := re1.Match[1];
            re1.Expression := 'left;">(.*?)</td>';  //KOs 2nd fighter
            re1.Exec(t);
            data_list.Cells[38, i] := re1.Match[1];
          end;

        try

          t := Copy(s, Pos('singleColumn', s), Pos('starBase', s) - Pos('singleColumn', s));
          re1.Expression := '<a href="(.*?)" cla';
          if re1.Exec(t) then
            repeat
              lst1.Add(re1.Match[1]);
            until not re1.ExecNext;

          t := IdHTTP.Get('http://boxrec.com' + lst1.Strings[0]);

          re1.Expression := '"birthDate">(.*?)</span>'; //1st birthdate
          re1.Exec(t);
          data_list.Cells[39, i] := re1.Match[1];

          if Pos('<b>residence</b>', t) > 0 then //1st residence
            begin
              u := Copy(t, Pos('<b>residence</b>', t), Pos('clickableIcon add', t) - Pos('<b>residence</b>', t));
              re1.Expression := '">(.*?)</tr>';
              re1.Exec(u);
              data_list.Cells[41, i] := Trim(StripTag(re1.Match[1]));
            end;

          if Pos('<b>birth place</b>', t) > 0 then //1st birthplace
            begin
              u := Copy(t, Pos('<b>birth place</b>', t), Pos('clickableIcon add', t) - Pos('<b>birth place</b>', t));
              re1.Expression := '">(.*?)</tr>';
              re1.Exec(u);
              data_list.Cells[43, i] := Trim(StripTag(re1.Match[1]));
            end;

          t := IdHTTP.Get('http://boxrec.com' + lst1.Strings[1]);

          re1.Expression := '"birthDate">(.*?)</span>'; //2nd birthdate
          re1.Exec(t);
          data_list.Cells[40, i] := re1.Match[1];

          if Pos('<b>residence</b>', t) > 0 then //2nd residence
            begin
              u := Copy(t, Pos('<b>residence</b>', t), Pos('clickableIcon add', t) - Pos('<b>residence</b>', t));
              re1.Expression := '">(.*?)</tr>';
              re1.Exec(u);
              data_list.Cells[42, i] := Trim(StripTag(re1.Match[1]));
            end;

          if Pos('<b>birth place</b>', t) > 0 then //2nd birthplace
            begin
              u := Copy(t, Pos('<b>birth place</b>', t), Pos('clickableIcon add', t) - Pos('<b>birth place</b>', t));
              re1.Expression := '">(.*?)</tr>';
              re1.Exec(u);
              data_list.Cells[44, i] := Trim(StripTag(re1.Match[1]));
            end;

        except
          Continue;
        end;

        lst1.Clear;

        FreeAndNil(IdHTTP); //убиваем всё созданное
        FreeAndNil(lst1);
        FreeAndNil(lst2);
        FreeAndNil(re1);
      end;
    except
      Continue;
    end;

  lst3.Clear;
  FreeAndNil(lst3);

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
  s := IdHTTP.Get('http://boxrec.com/en/event/771321');
  re1.Expression := 'id="ma(.*?)"';
  if re1.Exec(s) then
    repeat
      lst1.Add(re1.Match[1]);
    until not re1.ExecNext;
  Memo1.Text := lst1.Text;
  lst1.Clear;
end;

procedure TForm1.Button2Click(Sender: TObject);
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

  for i := 1 to Memo1.Lines.Count do
    begin
      s := IdHTTP.Get('http://boxrec.com/en/date?lrc[date]' +
        '[year]=' + Copy(Memo1.Lines.Strings[i - 1], 7, 4) +
        '&lrc[date][month]=' + Copy(Memo1.Lines.Strings[i - 1], 4, 2) +
        '&lrc[date][day]=' + Copy(Memo1.Lines.Strings[i - 1], 1, 2) + '&d_go=');
      re1.Expression := 'id="ma(.*?)"';
      if re1.Exec(s) then
        repeat
          lst1.Add(re1.Match[1]);
        until not re1.ExecNext;
    end;
    Memo2.Text := lst1.Text;
    lst1.Clear;
end;

function CountPos(const subtext: string; Text: string): Integer;
  begin
    if (Length(subtext) = 0) or (Length(Text) = 0) or (Pos(subtext, Text) = 0) then
      Result := 0
    else
      Result := (Length(Text) - Length(StringReplace(Text, subtext, '', [rfReplaceAll]))) div Length(subtext);
  end;

function StripTag(S: string): string;
var TagBegin, TagEnd, TagLength: integer;

begin
  TagBegin := Pos('<', S);
  while (TagBegin > 0) do
    begin
      TagEnd := Pos('>', S);
      TagLength := TagEnd - TagBegin + 1;
      Delete(S, TagBegin, TagLength);
      TagBegin := Pos('<', S);
    end;
  Result := S;
end;

end.

