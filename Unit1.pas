unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.CheckLst,
  dxGDIPlusClasses, Vcl.Samples.Spin, Vcl.ComCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.Menus, Winapi.ShellAPI, ipwcore, ipwtypes, ipwhttp;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    CheckListBox1: TCheckListBox;
    OpenDialog1: TOpenDialog;
    ListBox1: TListBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image4: TImage;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Image6: TImage;
    ListView1: TListView;
    ProgressBar1: TProgressBar;
    Panel4: TPanel;
    Image5: TImage;
    PopupMenu1: TPopupMenu;
    D1: TMenuItem;
    N1: TMenuItem;
    PopupMenu2: TPopupMenu;
    J1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    ipwHTTP1: TipwHTTP;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    ListView2: TListView;
    procedure Image1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure J1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TDataLines = record
  ID: string;
  file_id: string;
  file_name: string;
  file_type: string;
  file_size: string;
  file_link: string;
end;

type
  TStats = class(TObject)
  public
    load_el, load_str: integer;
    db: integer;
    DataBase: TStringList;
    Base, Formats, Filter: TStringList;
    size_min, size_max: integer;
    size: integer;
    filter_rez, base_rez: integer;
  private
    constructor Create(CreateSuspendet: Boolean);
    destructor Destroy;
    procedure GetStatsDB;
    procedure UpdateStats;
end;

var
  Form1: TForm1;
  item: integer;
  Stats: TStats;
  ListItem: integer;
  DataLines: TDataLines;
  procedure RemoveDuplicates(const stringList : TStringList) ;


implementation

{$R *.dfm}

procedure RemoveDuplicates(const stringList : TStringList) ;
var
  buffer: TStringList;
  cnt: Integer;
begin
 stringList.Sort;
 buffer := TStringList.Create;
 try
  buffer.Sorted := True;
  buffer.Duplicates := dupIgnore;
  buffer.BeginUpdate;
  for cnt := 0 to stringList.Count - 1 do
   buffer.Add(stringList[cnt]) ;
  buffer.EndUpdate;
  stringList.Assign(buffer) ;
 finally
  FreeandNil(buffer) ;
 end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
 if Form1.ComboBox1.ItemIndex = 0 then Stats.size:=0;
 if Form1.ComboBox1.ItemIndex = 1 then Stats.size:=1;
 if Form1.ComboBox1.ItemIndex = 2 then Stats.size:=2;
 if Form1.ComboBox1.ItemIndex = 3 then Stats.size:=3;
 if Form1.ComboBox1.ItemIndex = 4 then Stats.size:=4;
end;

procedure TForm1.D1Click(Sender: TObject);
var i: integer;
begin
 for I:=0 to Form1.CheckListBox1.Items.Count-1 do
 begin
  Form1.CheckListBox1.Checked[i]:=True;
 end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 FreeAndNil(Stats);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Stats:=TStats.Create(False);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 Stats.GetStatsDB;
end;

procedure TForm1.Image1Click(Sender: TObject);
var i: integer;
begin
 OpenDialog1.Filter:='*|*.csv';
 OpenDialog1.Options:=[ofAllowMultiSelect];
 if OpenDialog1.Execute then
 begin
  for I:=0 to OpenDialog1.Files.Count-1 do
   Form1.ListBox1.Items.Add(OpenDialog1.Files.Strings[i]);
 end;

 Stats.UpdateStats;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
 Form1.ListBox1.Items.Delete(item);
 Stats.UpdateStats;
end;

procedure TForm1.Image4Click(Sender: TObject);
var LineCounts: integer;
    tmp, TS: TStringList;
    i, j: integer;
    s: string;
    Item: TListItem;
begin
 tmp:=TStringList.Create;
 Stats.Filter.Clear;
 Form1.ListView1.Clear;

 TS:=Tstringlist.create;


 case Stats.filter_rez of
  1: begin

     end;
  2: begin
      if Stats.size = -1 then
      begin
       MessageDlg('Необходимо выбрать удиницу измерения! ', mtWarning, [mbOk], 0);
       Abort;
      end;
      case Stats.size of
       0: begin // byte
           Stats.size_min:=Form1.SpinEdit1.Value;
           Stats.size_max:=Form1.SpinEdit2.Value;
          end;
       1: begin // KB
           Stats.size_min:=Form1.SpinEdit1.Value * 1024;
           Stats.size_max:=Form1.SpinEdit2.Value * 1024;
          end;
       2: begin // MB
           Stats.size_min:=Form1.SpinEdit1.Value * 1024 * 1024;
           Stats.size_max:=Form1.SpinEdit2.Value * 1024 * 1024;
          end;
       3: begin // GB
           Stats.size_min:=Form1.SpinEdit1.Value * 1024 * 1024 * 1024;
           Stats.size_max:=Form1.SpinEdit2.Value * 1024 * 1024 * 1024;
          end;
       4: begin  // TB
           Stats.size_min:=Form1.SpinEdit1.Value * 1024 * 1024 * 1024 * 1024;
           Stats.size_max:=Form1.SpinEdit2.Value * 1024 * 1024 * 1024 * 1024;
          end;
      end;
     end;
 end;

 case Stats.base_rez of
  1: begin
      tmp.Clear;
      tmp.Text:=Stats.Base.Text;
     end;
  2: begin
      tmp.Clear;
      tmp.Text:=Stats.DataBase.Text
     end;
 end;

 for I:=0 to tmp.Count-1 do
 begin
  TS.CommaText:=tmp[i];
  DataLines.ID:=TS[0];
  DataLines.file_id:=TS[1];
  DataLines.file_name:=TS[2];
  DataLines.file_type:=TS[3];
  DataLines.file_size:=TS[4];
  DataLines.file_link:=TS[5];
  TS.Clear;
  for j:=0 to Form1.CheckListBox1.Items.Count-1 do
  begin
   if Form1.CheckListBox1.Checked[j] then
   begin
    if Pos(Form1.CheckListBox1.Items[j], DataLines.file_type) <> 0 then
    begin
   //  Form1.Memo1.Lines.Add(DataLines.file_type);
   //  Form1.Memo1.Lines.Add(tmp[i]);
     Stats.Filter.Add(tmp[i]);
    end;
   end;
  end;
 end;

 tmp.Clear;
 tmp.Text:=Stats.Filter.Text;
 Stats.Filter.Clear;

 case Stats.filter_rez of
  1: begin
      Stats.Filter.Text:=tmp.Text;
     end;
  2: begin
      for I:=0 to tmp.Count-1 do
      begin
       TS.CommaText:=tmp[i];
       DataLines.ID:=TS[0];
       DataLines.file_id:=TS[1];
       DataLines.file_name:=TS[2];
       DataLines.file_type:=TS[3];
       DataLines.file_size:=TS[4];
       DataLines.file_link:=TS[5];
       TS.Clear;
       try
       if (StrToInt(DataLines.file_size) >= Stats.size_min) AND (StrToInt(DataLines.file_size) <= Stats.size_max) then
       begin
        Stats.Filter.Add(tmp[i]);
       end;
       except

       end;
      end;
     end;
 end;





 tmp.Clear;
// tmp.Text:=Stats.Filter.Text;
// Stats.Filter.Clear;

 for I:=0 to Stats.Filter.Count-1 do
 begin
  TS.CommaText:=Stats.Filter[i];
  DataLines.ID:=TS[0];
  DataLines.file_id:=TS[1];
  DataLines.file_name:=TS[2];
  DataLines.file_type:=TS[3];
  DataLines.file_size:=TS[4];
  DataLines.file_link:=TS[5];
  TS.Clear;
  Item:=Form1.ListView1.Items.Add;
  Item.Checked:=True;
  Item.SubItems.Add(DataLines.ID);
  Item.SubItems.Add(DataLines.file_id);
  Item.SubItems.Add(DataLines.file_name);
  Item.SubItems.Add(DataLines.file_type);
  Item.SubItems.Add(DataLines.file_size);
  Item.SubItems.Add(DataLines.file_link);
 end;

 FreeAndNil(tmp);
 FreeAndNil(TS);
end;

procedure TForm1.Image5Click(Sender: TObject);
var i: integer;
    f: TextFile;
    s: string;
    TS: tstringlist;
    Item: TListItem;
begin
 Form1.ListView1.Clear;
 Stats.Base.Clear;
 for I:=0 to Form1.ListBox1.Items.Count-1 do
 begin
  AssignFile(f, Form1.ListBox1.Items[i]);
  Reset(f);
  while not EOF(F) do
  begin
   ReadLn(F, s);
   Stats.Base.Add(s);
  end;
  Form1.Label2.Caption:='Загружено строк: '+Stats.Base.Count.ToString;
 end;
 Form1.Label2.Caption:='Загружено строк: '+IntToStr(Stats.Base.Count);
 RemoveDuplicates(Stats.Base);
 Form1.Label4.Caption:='Уникальных строк: '+IntToStr(Stats.Base.Count);

 RemoveDuplicates(Stats.DataBase);

 for I:=0 to Stats.Base.Count-1 do
 begin
  Stats.DataBase.Add(Stats.Base[i]);
 end;
 RemoveDuplicates(Stats.DataBase);
 Stats.DataBase.SaveToFile(ExtractFilePath(Application.ExeName)+'DB\db.csv');
 Stats.UpdateStats;
// Stats.DataBase.

 TS := Tstringlist.create;
 for I:=0 to Stats.Base.Count-1 do
 begin
  TS.CommaText:=Stats.Base[i];
  DataLines.ID:=TS[0];
  DataLines.file_id:=TS[1];
  DataLines.file_name:=TS[2];
  DataLines.file_type:=TS[3];
  DataLines.file_size:=TS[4];
  DataLines.file_link:=TS[5];
  TS.Clear;
  Item:=Form1.ListView1.Items.Add;
  Item.Checked:=True;
  Item.SubItems.Add(DataLines.ID);
  Item.SubItems.Add(DataLines.file_id);
  Item.SubItems.Add(DataLines.file_name);
  Item.SubItems.Add(DataLines.file_type);
  Item.SubItems.Add(DataLines.file_size);
  Item.SubItems.Add(DataLines.file_link);
 end;
 FreeAndNil(TS);
end;

procedure TForm1.J1Click(Sender: TObject);
var i: integer;
begin
 for I:=0 to Form1.ListView1.Items.Count-1 do
 begin
  Form1.ListView1.Items[i].Checked:=True;
 end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
 item:=Form1.ListBox1.ItemIndex;
end;

procedure TForm1.ListView1Click(Sender: TObject);
begin
 ListItem:=ListView1.ItemIndex;
end;

procedure TForm1.N1Click(Sender: TObject);
var i: integer;
begin
 for I:=0 to Form1.CheckListBox1.Items.Count-1 do
 begin
  Form1.CheckListBox1.Checked[i]:=False;
 end;
end;

procedure TForm1.N2Click(Sender: TObject);
var i: integer;
begin
 for I:=0 to Form1.ListView1.Items.Count-1 do
 begin
  Form1.ListView1.Items[i].Checked:=False;
 end;
end;

procedure TForm1.N4Click(Sender: TObject);
var link: string;
begin
 link:=Form1.ListView1.Items[ListItem].SubItems[5];
 ShellExecute(0, 'Open', PWideChar(link), nil, nil, SW_SHOW);
end;

procedure TForm1.N5Click(Sender: TObject);
var HTTP: TipwHTTP;
    link: string;
    file_name: string;
    ID: string;
    FS: TFileStream;
begin
 HTTP:=TipwHTTP.Create(nil);

 HTTP.Config('KeepAlive=True');
 HTTP.Config('UserAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36');
 HTTP.HTTPVersion:='1.1';
 link:=Form1.ListView1.Items[ListItem].SubItems[5];
 file_name:=Form1.ListView1.Items[ListItem].SubItems[2];
 ID:=Form1.ListView1.Items[ListItem].SubItems[0];

 HTTP.Timeout:=6000;
 HTTP.Referer:='https://dropmefiles.com/'+ID;
 with HTTP do
 begin
  OtherHeaders:='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'+#13#10;
  OtherHeaders:=OtherHeaders+'Accept-Encoding: gzip, deflate'+#13#10;
  OtherHeaders:=OtherHeaders+'Accept-Language: ru,en;q=0.9,it;q=0.8,fr;q=0.7'+#13#10;
  OtherHeaders:=OtherHeaders+'Upgrade-Insecure-Requests: 1';
 end;


 try
  HTTP.Get(link);
 except

 end;
 if Pos('200', HTTP.StatusLine) <> 0 then
 begin
  FS:=TFileStream.Create(ExtractFilePath(Application.ExeName)+'\download\'+ID+'_'+file_name, fmCreate);
  FS.WriteData(HTTP.TransferredDataB, Length(HTTP.TransferredDataB));
  FreeAndNil(FS);
  MessageDlg('Файл успешно был скачан.', mtInformation, [mbOk], 0);
 end else
 begin
  MessageDlg('Файла больше не существует для скачивания!', mtWarning, [mbOk], 0);
 end;

 FreeAndNil(HTTP);
end;

procedure TForm1.N7Click(Sender: TObject);
var link: string;
    i: Integer;
begin
 for I:=0 to Form1.ListView1.Items.Count-1 do
 begin
  if Form1.ListView1.Items[i].Checked then
  begin
   link:=Form1.ListView1.Items[ListItem].SubItems[5];
   ShellExecute(0, 'Open', PWideChar(link), nil, nil, SW_SHOW);
  end;
 end;
end;

procedure TForm1.N8Click(Sender: TObject);
var link: string;
    i: Integer;
begin
 for I:=0 to Form1.ListView1.Items.Count-1 do
 begin
  link:=Form1.ListView1.Items[ListItem].SubItems[5];
  ShellExecute(0, 'Open', PWideChar(link), nil, nil, SW_SHOW);
 end;
end;

procedure TForm1.N9Click(Sender: TObject);
var i: integer;
    size: integer;
    Item: TListItem;
    r, step: Real;
    HTTP: TipwHTTP;
    FS: TFileStream;
    link, file_name, ID: string;
begin
 for I:=0 to Form1.ListView1.Items.Count-1 do
 begin
  if Form1.ListView1.Items[i].Checked then
  begin
   size:=StrToInt(Form1.ListView1.Items[ListItem].SubItems[4]);
   if size <= 52428800 then  // 50Mb
   begin
    Item:=Form1.ListView2.Items.Add;
    Item.Checked:=True;
    Item.SubItems.Add(Form1.ListView1.Items[i].SubItems[0]);
    Item.SubItems.Add(Form1.ListView1.Items[i].SubItems[1]);
    Item.SubItems.Add(Form1.ListView1.Items[i].SubItems[2]);
    Item.SubItems.Add(Form1.ListView1.Items[i].SubItems[3]);
    Item.SubItems.Add(Form1.ListView1.Items[i].SubItems[4]);
    Item.SubItems.Add(Form1.ListView1.Items[i].SubItems[5]);
   end;
  end;
 end;

 Form1.ProgressBar1.Position:=0;
 Form1.ProgressBar1.Min:=0;
 Form1.ProgressBar1.Max:=Form1.ListView2.Items.Count-1;
 Form1.ProgressBar1.Step:=1;

 for I:=0 to Form1.ListView2.Items.Count-1 do
 begin
  HTTP:=TipwHTTP.Create(nil);

  HTTP.Config('KeepAlive=True');
  HTTP.Config('UserAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36');
  HTTP.HTTPVersion:='1.1';
  link:=Form1.ListView2.Items[I].SubItems[5];
  file_name:=Form1.ListView2.Items[I].SubItems[2];
  ID:=Form1.ListView2.Items[I].SubItems[0];
  HTTP.Timeout:=6000;
  HTTP.Referer:='https://dropmefiles.com/'+ID;
  with HTTP do
  begin
   OtherHeaders:='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'+#13#10;
   OtherHeaders:=OtherHeaders+'Accept-Encoding: gzip, deflate'+#13#10;
   OtherHeaders:=OtherHeaders+'Accept-Language: ru,en;q=0.9,it;q=0.8,fr;q=0.7'+#13#10;
   OtherHeaders:=OtherHeaders+'Upgrade-Insecure-Requests: 1';
  end;

  try
   HTTP.Get(link);
  except

  end;

  if Pos('200', HTTP.StatusLine) <> 0 then
  begin
   FS:=TFileStream.Create(ExtractFilePath(Application.ExeName)+'\download\'+ID+'_'+file_name, fmCreate);
   FS.WriteData(HTTP.TransferredDataB, Length(HTTP.TransferredDataB));
   FreeAndNil(FS);
   Form1.ListView2.Items[i].Checked:=False;
  end else
  begin
   Form1.ListView2.Items[i].Checked:=True;
  end;
  Form1.ProgressBar1.Position:=Form1.ProgressBar1.Position+1;
  FreeAndNil(HTTP);
 end;
 MessageDlg('Все файлы были успешно скачаны.', mtInformation, [mbOk], 0);
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
 if RadioButton1.Checked then
 begin
  Form1.ComboBox1.Enabled:=False;
  Form1.SpinEdit1.Enabled:=False;
  Form1.SpinEdit2.Enabled:=False;
  Stats.filter_rez:=1;
 end;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
 if RadioButton2.Checked then
 begin
  Form1.ComboBox1.Enabled:=True;
  Form1.SpinEdit1.Enabled:=True;
  Form1.SpinEdit2.Enabled:=True;
  Stats.filter_rez:=2;
 end;
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin
 Stats.base_rez:=1;
end;

procedure TForm1.RadioButton4Click(Sender: TObject);
begin
 Stats.base_rez:=1;
end;

{ TStats }

constructor TStats.Create(CreateSuspendet: Boolean);
begin
// inherited Create(CreateSuspendet);
 DataBase:=TStringList.Create;
 Base:=TStringList.Create;
 Formats:=TStringList.Create;
 Filter:=TStringList.Create;
 size:=-1;
 filter_rez:=1;
 base_rez:=1;
end;

destructor TStats.Destroy;
begin
 FreeAndNil(DataBase);
 FreeAndNil(base);
 FreeAndNil(Formats);
 FreeAndNil(Filter);
end;

procedure TStats.GetStatsDB;
var f: TextFile;
    i: integer;
begin
 if not DirectoryExists('DB') then CreateDir('DB');
 if not DirectoryExists('download') then CreateDir('download');
 if not FileExists(ExtractFilePath(Application.ExeName)+'DB\db.csv') then
 begin
  AssignFile(f, ExtractFilePath(Application.ExeName)+'DB\db.csv');
  Rewrite(f);
  CloseFile(f);
 end;

 if not FileExists(ExtractFilePath(Application.ExeName)+'formats.txt') then
 begin
  AssignFile(f, ExtractFilePath(Application.ExeName)+'formats.txt');
  Rewrite(f);
  CloseFile(f);
 end;

 Formats.LoadFromFile(ExtractFilePath(Application.ExeName)+'formats.txt');
 for I:=0 to Formats.Count-1 do
 begin
  Form1.CheckListBox1.Items.Add(Formats[i]);
 end;
 Form1.CheckListBox1.Columns:=3;

 DataBase.LoadFromFile(ExtractFilePath(Application.ExeName)+'DB\db.csv');

 UpdateStats;
end;

procedure TStats.UpdateStats;
begin
 db:=DataBase.Count;
 Form1.Label1.Caption:='Выбрано элентов: '+Form1.ListBox1.Items.Count.ToString;
 Form1.Label3.Caption:='В базе данных находится: '+ db.ToString;
end;

end.
