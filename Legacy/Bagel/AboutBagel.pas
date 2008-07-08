unit AboutBagel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, nsXPCOM, nsXPCOMGlue,nsError, GeckoBrowser,
  ComCtrls, nsHttp, nsGeckoStrings, nsNetUtil,BagelConst,Version,
  Graphics;

type
  TAboutBagelForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    Label1: TLabel;
    Image1: TImage;
    ListView1: TListView;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
    GeckoBrowser1: TGeckoBrowser;
    BrowserCreated: Boolean;
  end;

var
  AboutBagelForm: TAboutBagelForm;

implementation

{$R *.dfm}

procedure TAboutBagelForm.FormCreate(Sender: TObject);
begin
  BrowserCreated := False;
  //ShowMessage(IntToStr(PageControl1.TabIndex));
  GeckoBrowser1 := TGeckoBrowser.Create(Self);
  GeckoBrowser1.Align := alClient;
  GeckoBrowser1.Enabled := False;
  GeckoBrowser1.Parent := TabSheet2;
  //ShowMessage(IntToStr(PageControl1.TabIndex));
  //GeckoBrowser1.Show;
end;

procedure TAboutBagelForm.FormShow(Sender: TObject);
var
item:TListItem;
list:TStringList;
i:Integer;
//ios:nsIIOService;
//p:nsIProtocolHandler;
scheme:PChar;
http:nsIHttpProtocolHandler;
productSub:nsACString;
ips:IInterfacedCString;
tmp:String;
    info: OSVERSIONINFO;
begin
ListVIew1.Clear;
tmp:='Bagel���=plus7'+#13#10;
tmp:=tmp+'TGeckoBrowser���=>>74'+#13#10;
tmp:=tmp+'Contributers=��W��'+#13#10;
tmp:=tmp+'SpecialThanks=Mozilla.org'+#13#10;
tmp:=tmp+' =Borland Software Corporation'+#13#10;
tmp:=tmp+' =OpenJane'+#13#10;
tmp:=tmp+' =�z�b�g�]�k'+#13#10;
tmp:=tmp+' =�M�R�i�r'+#13#10;
tmp:=tmp+' =Donut,DonutP,unDonut,Donut RAPT'+#13#10;
tmp:=tmp+' =����Bagel���g���Ă��邠�Ȃ�'+#13#10;

list:=TStringList.Create;
list.SetText(PChar(tmp));
for i:=0 to list.Count-1 do
begin
 item:=TListItem.Create(ListView1.Items);
 ListView1.Items.AddItem(item);
 item.Caption:=list.Names[i];
 item.SubItems.Add(Copy(list.Strings[i],1+Pos('=',list.Strings[i]),Length(list.Strings[i])-Pos('=',list.Strings[i])) );
end;

 //Label2.Caption:='Bagel '+BAGEL_STATUS+' '+IntToStr(BAGEL_NUMBER);
 Label2.Caption:='Bagel ' + version.theVersion.StringVersion;

 Memo1.Clear;

 Memo1.lines.Add('�yOS�z');


    info.dwOSVersionInfoSize := SizeOf(info);
    GetVersionEx(info);
    if info.dwPlatFormId = VER_PLATFORM_WIN32_NT then
    begin
      Memo1.lines.Add('OS �F Windows NT');
      Memo1.lines.Add('Version ' + IntToStr(info.dwMajorVersion) + '.' + IntToStr(info.dwMinorVersion) + ' ' + info.szCSDVersion);
      Memo1.lines.Add('Build ' + IntToStr(info.dwBuildNumber));
   end
   else if info.dwPlatFormId = VER_PLATFORM_WIN32_WINDOWS then
   begin
     Memo1.lines.Add('OS �F Windows (Win32)');
     Memo1.lines.Add('Version ' + IntToStr(info.dwMajorVersion) + '.' +
        IntToStr(info.dwMinorVersion));
     Memo1.lines.Add('Build ' + IntToStr($FFFF and info.dwBuildNumber));;
  end
  else
     Memo1.lines.Add('OS �F Windowns3.1 + Win32s');

 scheme:=PChar('@mozilla.org/network/protocol;1?name=http');
 NS_GetService(scheme,nsIHttpProtocolHandler,http);

 ips:=NewCString();
 productSub:=ips.ACString;

 Memo1.lines.Add('�yGecko�z');

 http.GetUserAgent(productSub);
 Memo1.Lines.Add('���[�U�[�G�[�W�F���g �F '+ips.ToString);

 http.GetMisc(productSub);
 Memo1.Lines.Add('���r�W���� �F ' +ips.ToString);

 http.GetProductSub(productSub);
 Memo1.Lines.Add('Gecko �F '+ips.ToString);

 http := nil;

 Memo1.lines.Add('�yBagel�z');
 Memo1.Lines.Add('�o�[�W���� �F '+theVersion.StringVersion);
 Memo1.Lines.Add('�X�e�[�^�X �F '+BAGEL_STATUS);
 //Memo1.Lines.Add('�ԍ� �F '+IntToStr(BAGEL_NUMBER));

 Memo1.lines.Add('�y�풓�\�t�g/�t�@�C�A�E�H�[�����z');
 Memo1.lines.Add('');

end;

procedure TAboutBagelForm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.TabIndex = 1 then
  begin
    GeckoBrowser1.Enabled := True;
    GeckoBrowser1.LoadURI('http://www.w3.org/');
    BrowserCreated := True;
  end;
end;

procedure TAboutBagelForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=CAFree;
end;

end.
