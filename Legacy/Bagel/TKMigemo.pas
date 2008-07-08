unit TKMigemo;

interface

uses
  Windows;

//migemo���ĂԐ錾
const
  CMP_MIGEMO_DICTID_MIGEMO = 1;
  CMP_MIGEMO_DICTID_ROMA2HIRA = 2;
  CMP_MIGEMO_DICTID_HIRA2KATA = 3;
  CMP_MIGEMO_DICTID_HAN2ZEN = 4;

const
  CMP_MIGEMO_OPINDEX_OR = 0;
  CMP_MIGEMO_OPINDEX_NEST_IN = 1;
  CMP_MIGEMO_OPINDEX_NEST_OUT = 2;
  CMP_MIGEMO_OPINDEX_SELECT_IN = 3;
  CMP_MIGEMO_OPINDEX_SELECT_OUT = 4;
  CMP_MIGEMO_OPINDEX_NEWLINE = 5;

const
  ROMANODE_VALUE_MAXLEN = 7;
  RXGEN_OP_MAXLEN = 8;
  MTREE_MNODE_N = 1024;

type
  PWordList = ^TWordList;
  TWordList = record
    ptr: PChar;
    next: PWordList;
  end;

type
  PMNode = ^TMNode;
  TMNode = record
    attr: Cardinal;
    next: PMNode;
    child: PMNode;
    list: PWordList;
  end;

type
  PMTree = ^TMTree;
  TMTree = record
    active: PMTree;
    used: integer;
    nodes: array [0..MTREE_MNODE_N] of TMNode;
    next: PMTree;
  end;

type
  PRomaNode = ^TRomaNode;
  TRomanode = record
    key: Byte;
    value: array [0..ROMANODE_VALUE_MAXLEN] of Byte;
    next: PRomaNode;
    child: PRomaNode;
  end;

type
  PRomaji = ^TRomaji;
  TRomaji = record
    node: PRomaNode;
    fixvalue_xn: array [0..ROMANODE_VALUE_MAXLEN] of Byte;
    fixvalue_xtu: array [0..ROMANODE_VALUE_MAXLEN] of Byte;
  end;

type
  PRNode = ^TRNode;
  TRNode = record
    code: Cardinal;
    child: PRNode;
    next: PRNode;
  end;

type
  TRXGEN_PROC_CHAR2INT = function(vals: PChar; var vali: Cardinal): integer; cdecl;
  TRXGEN_PROC_INT2CHAR = function(vali: Cardinal; vals: PChar): integer; cdecl;
  PRxgen = ^TRxgen;
  TRxgen = record
    node: PRNode;
    char2int: TRXGEN_PROC_CHAR2INT;
    int2char: TRXGEN_PROC_INT2CHAR;
    op_or: array [0..RXGEN_OP_MAXLEN] of Byte;
    op_nest_in: array [0..RXGEN_OP_MAXLEN] of Byte;
    op_nest_out: array [0..RXGEN_OP_MAXLEN] of Byte;
    op_select_in: array [0..RXGEN_OP_MAXLEN] of Byte;
    op_select_out: array [0..RXGEN_OP_MAXLEN] of Byte;
    op_newline: array [0..RXGEN_OP_MAXLEN] of Byte;
  end;

type
  PMIGEMO_PROC_ADDWORD = ^TMIGEMO_PROC_ADDWORD;
  TMIGEMO_PROC_ADDWORD = function(date: Pointer; word: PChar): integer; cdecl;
  PMigemo = ^TMigemo;
  TMigemo = record
    enable: Integer;
    mtree: PMTree;
    roma2hira: PRomaji;
    hira2kata: PRomaji;
    han2zen: PRomaji;
    rx: PRxgen;
    addword: PMIGEMO_PROC_ADDWORD;
  end;

type
  TMigemo_open = function(dict: Pchar): PMigemo; cdecl;
  TMigemo_close = procedure(migemo: PMigemo); cdecl;
  TMigemo_query = function(migemo: PMigemo; query: PChar): PChar; cdecl;
  TMigemo_release = procedure(migemo: PMigemo; query: PChar); cdecl;
  TMigemo_load = function(migemo: PMigemo; DicID: Integer;
    dic: Pchar): integer; cdecl;
  TMigemo_is_enable = function(migemo: PMigemo): Integer; cdecl;
  TMigemo_set_operator = function(migemo: PMigemo; Index: Integer;
    Operator: PChar): Integer; cdecl;
  TMigemo_get_operator = function(migemo: PMigemo; Index: Integer): PChar; cdecl;
  TMigemo_setproc_char2int = procedure(migemo: PMigemo;
    proc: TRXGEN_PROC_CHAR2INT); cdecl;
  TMigemo_setproc_int2char = procedure(migemo: PMigemo;
    proc: TRXGEN_PROC_INT2CHAR); cdecl;

//�錾�I��

type
  TKMCDicType = (MIGEMO_DICTID_MIGEMO = 1,
    MIGEMO_DICTID_ROMA2HIRA = 2,
    MIGEMO_DICTID_HIRA2KATA = 3,
    MIGEMO_DICTID_HAN2ZEN = 4);

  TKMCOPIndex = (MIGEMO_OPINDEX_OR = 0,
    MIGEMO_OPINDEX_NEST_IN = 1,
    MIGEMO_OPINDEX_NEST_OUT = 2,
    MIGEMO_OPINDEX_SELECT_IN = 3,
    MIGEMO_OPINDEX_SELECT_OUT = 4,
    MIGEMO_OPINDEX_NEWLINE = 5);

  TTKCMigemo = class
  private
    FMigemo: PMigemo;
    FDllHandle: THandle;
  public
    constructor Create(const MigemoDll: String);
    destructor Destroy; override;

    function CheckMigemoDll: Boolean; //false���A���Ă�����Dll�̃��[�h���ł��ĂȂ�
    function CheckMigemo: Boolean; //false���A���Ă�����I�u�W�F�N�g���o���ĂȂ�

    function LoadFromDicFile(dictype: TKMCDicType;
      const FileName: String): Boolean; //�����̃��[�h
    function Isenable: Boolean; //������Migemo�Ɏ������ǂ܂�Ďg���邩�ǂ�����Ԃ�
    function Query(const Str: String): String; //���ۂɃ��[�}������Migemo�Ȑ��K�\���𓾂�
    function SetOperator(Opindex: TKMCOPIndex;
      const NewOperator: String): Boolean; //�I�y���[�^�[�̏㏑��
    function GetOperator(Opindex: TKMCOPIndex): String;

    procedure SetProcChar2int(proc: TRXGEN_PROC_CHAR2INT);
    procedure SetProcInt2char(proc: TRXGEN_PROC_INT2CHAR);
  end;

implementation

  procedure TTKCMigemo.SetProcInt2char(proc: TRXGEN_PROC_INT2CHAR);
  var
    Migemo_set_int2char: TMigemo_setproc_int2char;
  begin
    //����
      if CheckMigemo = False then
        Exit;
      @Migemo_set_int2char := GetProcAddress(FDllHandle, 'migemo_setproc_int2char');
      if @Migemo_set_int2char = nil then
        Exit;

    //���s
      Migemo_set_int2char(FMigemo,proc);
  end;

  procedure TTKCMigemo.SetProcChar2int(proc: TRXGEN_PROC_CHAR2INT);
  var
    Migemo_set_char2int: TMigemo_setproc_char2int;
  begin
    //����
      if CheckMigemo = False then
        Exit;
      @Migemo_set_char2int := GetProcAddress(FDllHandle, 'migemo_setproc_char2int');
      if @Migemo_set_char2int = nil then
        Exit;

    //���s
      Migemo_set_char2int(FMigemo,proc);
  end;

  function TTKCMigemo.GetOperator(Opindex: TKMCOPIndex): String;
  var
    Migemo_get_operator: TMigemo_get_operator;
    opt: PChar;
    op: String;
  begin
    //����
      Result := '';
      if CheckMigemo = False then
        Exit;
      @Migemo_get_operator := GetProcAddress(FDllHandle, 'migemo_get_operator');
      if @Migemo_get_operator = nil then
        Exit;

    //���s
      opt := Migemo_get_operator(FMigemo,ord(Opindex));
      if opt <> nil then
      begin
        op := String(opt);
        Result := op;
      end;
  end;

  function TTKCMigemo.SetOperator(Opindex: TKMCOPIndex;
    const NewOperator: String): Boolean;
  var
    Migemo_set_operator: TMigemo_set_operator;
  begin
    //����
      Result := False;
      if CheckMigemo = False then
        Exit;
      @Migemo_set_operator := GetProcAddress(FDllHandle, 'migemo_set_operator');
      if @Migemo_set_operator = nil then
        Exit;

    //���s
      if Migemo_set_operator(FMigemo,ord(Opindex),PChar(NewOperator)) <> 0 then
        Result := True;
  end;

  function TTKCMigemo.Query(const Str: String): String;
  var
    Migemo_query: TMigemo_query;
    Migemo_release: TMigemo_release;
    RegEx: PChar;
    RegExp: String;
  begin
    //����
      Result := '';
      if CheckMigemo = False then
        Exit;
      @Migemo_query := GetProcAddress(FDllHandle, 'migemo_query');
      if @Migemo_query = nil then
        Exit;
      @Migemo_release := GetProcAddress(FDllHandle, 'migemo_release');
      if @Migemo_release = nil then
        Exit;

    //�N�G���[���Ă݂�
      RegEx := Migemo_query(FMigemo,PChar(Str));
      try
        if RegEx <> nil then
        begin
          RegExp := String(RegEx);
          Result := RegExp;
        end;
      finally
        migemo_release(FMigemo,RegEx); //�p��
      end;
  end;

  function TTKCMigemo.Isenable: Boolean;
  var
    Migemo_is_enable: TMigemo_is_enable;
  begin
    //����
      Result := False;
      if CheckMigemo = False then
        Exit;
      @Migemo_is_enable := GetProcAddress(FDllHandle, 'migemo_is_enable');
      if @Migemo_is_enable = nil then
        Exit;

    //���s
    if Migemo_is_enable(FMigemo) <> 0 then
      Result := True;
  end;

  function TTKCMigemo.LoadFromDicFile(dictype: TKMCDicType;
    const FileName: String): Boolean;
  var
    Migemo_load: TMigemo_load;
  begin
    Result := False;
    if CheckMigemo = False then
      Exit;

    //�A�h���X�̎擾
      @Migemo_load := GetProcAddress(FDllHandle, 'migemo_load');
      if @Migemo_load = nil then
        Exit;

    //�����̃��[�h
      if Migemo_load(FMigemo,Ord(dictype),PChar(FileName)) <> 0 then
        Result := True;
  end;

  function TTKCMigemo.CheckMigemoDll: Boolean;
  begin
    Result := (FDllHandle <> 0);
  end;

  function TTKCMigemo.CheckMigemo: Boolean;
  begin
    Result := (FMigemo <> nil);
  end;

  constructor TTKCMigemo.Create(const MigemoDll: String);
  var
    Migemo_open: TMigemo_open;
  begin
    FDllHandle := 0;
    FMigemo := nil;

    //Dll�̃��[�h
      FDllHandle := LoadLibrary(PChar(MigemoDll));
      if FDllHandle = 0 then
        Exit;
        
    //�֐��̃A�h���X�𓾂�
      @Migemo_open := GetProcAddress(FDllHandle, 'migemo_open');
      if @Migemo_open = nil then
        Exit;
      FMigemo := Migemo_open(nil);
      if FMigemo = nil then
        Exit;
  end;

  destructor TTKCMigemo.Destroy;
  var
    Migemo_close: TMigemo_close;
  begin
    //Migemo�I�u�W�F�N�g������ΊJ��
      if CheckMigemo then
      begin
        @Migemo_close := GetProcAddress(FDllHandle, 'migemo_close');
        if @Migemo_close <> nil then
          Migemo_close(FMigemo);
      end;

    //DLL�����[�h���Ă���J��
      if CheckMigemoDll then
        FreeLibrary(FDllHandle);
      
    inherited;
  end;

end.
