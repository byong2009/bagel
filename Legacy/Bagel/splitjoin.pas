unit splitjoin;

interface

uses
  Classes, StrUtils;
  
const
  // �A�v���P�[�V�������ʂŎg��
  btCrLf = #13#10;
  btTab  = #09;

  // Split�֐�
  function btSplitToStringList(const AString: string;
    const Delimiter : string = btCrLf): TStringList;
  type TStrArray = array of string;
  function btSplitToArray(const AString: string;
    const Delimiter : string = btCrLf): TStrArray;

  // Join�֐�
  function btJoin(const AStringList: TStringList;
    const Delimiter : string = ''): string; Overload;
  function btJoin(const AStringArray: TStrArray;
    const Delimiter : string = ''): string; Overload;
  function btJoin(const AStringArray: array of string;
    const Delimiter : string = ''): string; Overload;

implementation

{
**************************************************************
    Split�֐��i�ȗ��^�A��������j

������
�@AString��Delimiter�ŕ������ATStringList�`���Ŗ߂�

������
�@������r���ɉ��s������ƁA�����ł����������

���g����
var SplittedStringList: TStringList;
SplittedStringList := btSplitToStringList(AString, Delimiter);
SplittedStringList.Free     <== �����Y��Ȃ����ƁI
**************************************************************
}
function btSplitToStringList(const AString: string;
  const Delimiter : string = btCrLf): TStringList;
begin
  Result := TStringList.Create;
  Result.Text := AnsiReplaceStr(AString, Delimiter, btCrLf);
end;


{
**************************************************************
    Split�֐��i�ȗ��^�A��������j

������
�@AString��Delimiter�ŕ������ATStrArray�`���i������̓��I�z��j�Ŗ߂�

������
�@������r���ɉ��s������ƁA�����ł����������

���g����
var   SplittedStr: TStrArray;
SplittedStr := btSplitToArray(AString, Delimiter);
**************************************************************
}
function btSplitToArray(const AString: string;
  const Delimiter : string = btCrLf): TStrArray;
var
  SplittedStrs : TStringList;
  i: integer;
begin
  SplittedStrs := btSplitToStringList(AString, Delimiter);
  SetLength(Result, SplittedStrs.Count);
  try
    for i := 0 to SplittedStrs.Count - 1 do begin
      Result[i] := SplittedStrs.Strings[i];
    end;
  finally
    SplittedStrs.Free;
  end;
end;

{
**************************************************************
    Join�֐��i�ȗ��^�A��������j

������
�@AStringList��Delimiter�ŘA�����AString�Ŗ߂�

������
�@�n���ꂽ���X�g�ɋ󔒍��ڂ������Delimiter������

���g����
JoinedStr := btJoin(AStringList, Delimiter);
AStringList�́ATStringLise, TStrArray, string�z����Ƃ��
**************************************************************
}
function btJoin(const AStringList: TStringList;
    const Delimiter : string = ''): string;
var
  i: integer;
begin
  if AStringList.Count = 0 then begin
    Result := '';
  end else begin
    Result := AStringList[0];
  end;
  for i:= 1 to AStringList.Count - 1 do begin
    Result := Result + Delimiter + AStringList[i];
  end;
end;
{---------------------------------------------------------------}
function btJoin(const AStringArray: TStrArray;
    const Delimiter : string = ''): string;
var
  i: integer;
begin
  if High(AStringArray) < 0 then begin
    Result := '';
  end else begin
    Result := AStringArray[Low(AStringArray)];
  end;
  for i:= Low(AStringArray) + 1 to High(AStringArray) do begin
    Result := Result + Delimiter + AStringArray[i];
  end;
end;
{---------------------------------------------------------------}
function btJoin(const AStringArray: array of string;
    const Delimiter : string = ''): string;
var
  i: integer;
begin
  if High(AStringArray) < 0 then begin
    Result := '';
  end else begin
    Result := AStringArray[Low(AStringArray)];
  end;
  for i:= Low(AStringArray) + 1 to High(AStringArray) do begin
    Result := Result + Delimiter + AStringArray[i];
  end;
end;

end.
