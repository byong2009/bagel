unit ScriptAction;

interface

uses
  Windows, Messages, SysUtils, Classes, ActnList;

type
  TScriptAction = class(TAction)
  private
    { Private �錾 }
    FScriptPath:String;
    FParameters:String;
  protected
    { Protected �錾 }
  public
    { Public �錾 }
  published
    { Published �錾 }
     property ScriptPath: String read FScriptPath write FScriptPath;
     property Parameters: String read FParameters write FParameters;
     function a:String;
  end;

implementation

function TScriptAction.a:String;
begin
//  MessageBox();
MessageBox(0, PChar(String(TObject(Self.FClients.Items[0]).ClassName)) ,'a' ,0);
end;


end.
