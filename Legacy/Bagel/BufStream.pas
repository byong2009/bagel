unit BufStream;

interface

uses
  Classes, SysUtils;

type
  TBufFileStream = class(TFileStream)
  private
    FBuf: PChar;          //�o�b�t�@
    FBufSize: Longint;    //�o�b�t�@�T�C�Y
    FBufPos: Longint;     //�o�b�t�@���̈ʒu
    FBufEnd: Longint;     //�o�b�t�@�̏I���
    FFilePos: Longint;    //�t�@�C���̈ʒu(Seek�ŕK�v)
  public
    constructor Create(const FileName: string; Mode: Word; BufSize: Byte = 16);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override; //���邾��
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;

implementation

{ TBufFileStream }

constructor TBufFileStream.Create(const FileName: string; Mode: Word;
  BufSize: Byte = 16);
begin
  inherited Create(FileName, Mode);
  FBufSize := BufSize * 1024;
  GetMem(FBuf, FBufSize);
end;

destructor TBufFileStream.Destroy;
begin
  FreeMem(FBuf);
  inherited Destroy;
end;

function TBufFileStream.Read(var Buffer; Count: Integer): Longint;
var
  Rest, Len, ForwardSize: Longint;
begin
  if Count > FBufSize then
    raise Exception.Create('�o�b�t�@�̑傫�����z���Ă��܂��B');

  ForwardSize := Count;
  if FBufEnd = 0 then //�o�b�t�@�������ꍇ
  begin
    FBufEnd := inherited Read(FBuf[0], FBufSize);
    if FBufEnd = 0 then
    begin
      Result := 0;
      Exit;
    end;
    if FBufEnd < Count then ForwardSize := FBufEnd; //��������
  end
  else
  begin
    Rest := FBufEnd - FBufPos; //�o�b�t�@�̎c��
    if Count > Rest then      //�o�b�t�@���ɂȂ��ꍇ
    begin
      Move(FBuf[FBufSize - Rest], FBuf[0], Rest);          //�c���擪�ɂ��炷
      Len := inherited Read(FBuf[Rest], FBufSize - Rest); //�ǉ��ǂݍ���
      FBufEnd := Rest + Len;
      if Len = 0 then
      begin
        if FBufEnd = 0 then
        begin
          Result := 0;
          Exit;
        end;
        if FBufEnd < Count then ForwardSize := FBufEnd; //��������
      end
      else
        FBufPos := 0; //�o�b�t�@���ʒu������
    end;
  end;
  Move(FBuf[FBufPos], Buffer, ForwardSize); //�o�b�t�@����]��
  Result := ForwardSize;
  Inc(FBufPos, ForwardSize);
  Inc(FFilePos, ForwardSize);
end;

function TBufFileStream.Write(const Buffer; Count: Integer): Longint;
begin
  Result := inherited Write(Buffer, Count);
end;

function TBufFileStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromCurrent:
      Result := inherited Seek(FFilePos + Offset, soFromBeginning);
    else
      Result := inherited Seek(Offset, Origin);
  end;
  FBufPos := 0;
  FBufEnd := 0;
  FFilePos := Result;
end;

end.

