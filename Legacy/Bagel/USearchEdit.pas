unit USearchEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Menus;

type
  TfrmSearchEdit = class(TForm)
    PageControl1: TPageControl;
    EngineSheet: TTabSheet;
    GroupSheet: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    Label77: TLabel;
    edtCaptionE: TEdit;
    edtPrefixE: TEdit;
    Label78: TLabel;
    Label79: TLabel;
    edtSuffixE: TEdit;
    Label80: TLabel;
    cboEncodeE: TComboBox;
    Label81: TLabel;
    edtShortcutE: TEdit;
    edtCaptionG: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtShortcutG: TEdit;
    EnginePopup: TPopupMenu;
    GroupBox1: TGroupBox;
    btnAddG: TButton;
    btnDelG: TButton;
    lstEngine: TListBox;
    procedure btnDelGClick(Sender: TObject);
    procedure EnginePopupPopup(Sender: TObject);
    procedure btnAddGClick(Sender: TObject);
    procedure lstEngineStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure lstEngineDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstEngineDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    { Private �錾 }
  public
    { Public �錾 }
    Mode:Integer;//0-Modify�@1-New
    procedure AddEngineMenu(EngineName:String);
    procedure AddEngine(Sender:TObject);
  end;

var
  frmSearchEdit: TfrmSearchEdit;

implementation

{$R *.dfm}

var
  PrevItemIndex: Integer;

// �ړ���������r����`�悷��葱��
procedure DrawMoveLine(ListBox: TListBox; const Index: Integer);
var
  r: TRect;
  y: Integer;
begin
  ListBox.Canvas.Pen.Mode := pmXor;
  ListBox.Canvas.Pen.Color := $00FFFFFF;
  ListBox.Canvas.Pen.Width := 3;
  if Index <> -1 then
  begin
    r := ListBox.ItemRect(Index);
    if ListBox.ItemIndex < Index then y := r.Bottom else y := r.Top;
    ListBox.Canvas.MoveTo(0, y);
    ListBox.Canvas.LineTo(ListBox.Width, y);
  end;
end;

procedure TfrmSearchEdit.btnDelGClick(Sender: TObject);
begin
  if lstEngine.ItemIndex>-1 then
  lstEngine.DeleteSelected;
end;

procedure TfrmSearchEdit.AddEngineMenu(EngineName:String);
var
mi:TMenuItem;
begin
  mi:=TMenuItem.Create(Self);
  mi.OnClick:=AddEngine;
  mi.Caption:=EngineName;
  EnginePopup.Items.Add(mi);
end;

procedure TfrmSearchEdit.AddEngine(Sender:TObject);
begin
  if lstEngine.Items.IndexOf(TMenuItem(Sender).Caption)<0 then
    lstEngine.Items.Add(TMenuItem(Sender).Caption);
end;

procedure TfrmSearchEdit.EnginePopupPopup(Sender: TObject);
var
i:Integer;
begin
  for i:=0 to EnginePopup.Items.Count-1 do begin
    if lstEngine.Items.IndexOf(EnginePopup.Items.Items[i].Caption) < 0 then
      EnginePopup.Items.Items[i].Enabled:=true
    else
      EnginePopup.Items.Items[i].Enabled:=false;
  end;
end;

procedure TfrmSearchEdit.btnAddGClick(Sender: TObject);
var
 pt:Tpoint;
begin
  pt:=btnAddG.ClientToScreen(Point(0,btnAddG.Height));
  EnginePopup.Popup(pt.X,pt.Y);
end;

procedure TfrmSearchEdit.lstEngineStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  PrevItemIndex := -1;
end;

procedure TfrmSearchEdit.lstEngineDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  idx:integer;
begin
  // �������g����̃h���b�O�̂݋�����B
  // �܂��A�I������Ă��鍀�ځi�ړ�����A�C�e���j���Ȃ��ƃ_���B
  // ��L�ɂ��Ă͂܂�Ȃ��ꍇ�A�����ɏ����𔲂���B
  Accept := (Source = Sender) and (TListBox(Source).ItemIndex <> -1);
  if not Accept then Exit;

  // �J�[�\���̂���ʒu�̃A�C�e���C���f�b�N�X���擾�B
  idx := TListBox(Source).ItemAtPos(Point(X, Y), True);

  // ���O�̃h���b�v��\���p�r��������
  DrawMoveLine(TListBox(Sender), PrevItemIndex);

  // �V�����h���b�v��\���p�r����`�悷��
  DrawMoveLine(TListBox(Sender), idx);

  PrevItemIndex := idx;
end;

procedure TfrmSearchEdit.lstEngineDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  idx: Integer;
begin
  // �J�[�\���̂���ʒu�̃A�C�e���C���f�b�N�X���擾�B
  idx := TListBox(Source).ItemAtPos(Point(X, Y), True);

  // ���O�̃h���b�v��\���p�r��������
  DrawMoveLine(TListBox(Sender), PrevItemIndex);

  // ���בւ���
  if idx <> -1 then
    TListBox(Sender).Items.Move(TListBox(Sender).ItemIndex, idx);
end;

end.
