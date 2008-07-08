unit SearchListItem;

interface

uses
  Windows, Messages, SysUtils, Classes, ComCtrls;

type
  TSearchListItem = class(TListItem)
  private
    { Private �錾 }
    FGroups:TStringList;
    FItemType:Integer;
    FEncode:String;
  protected
    { Protected �錾 }
  public
    constructor Create(AOwner: TListItems);
    destructor Destroy; override;
    { Public �錾 }
  published
    { Published �錾 }
    property Groups:TStringList read FGroups;
    property ItemType:Integer read FitemType write FItemType;
    property Encode:String read FEncode write FEncode;
  end;

//procedure Register;

implementation

constructor TSearchListItem.Create(AOwner: TListItems);
begin
  inherited Create(AOwner);
  FGroups:=TStringList.Create;
end;

destructor TSearchListItem.Destroy;
begin
  FGroups.Free;
  inherited Destroy;
end;

end.
