unit BrwsFldr;

// SHBrowseForFolder �̃t�H���_�I���_�C�A���O�̃I�u�W�F�N�g

interface

uses
        Windows, ShlObj, ActiveX;

type
        TBrowseFolderBox = class
        private
                FHandle         : HWND;         //�_�C�A���O�� hwnd
                FBrowseInfo     : TBrowseInfo;  //BROWSEINFO
                FRootFolderNum  : Integer;      //CSIDL_??? ���[�g�t�H���_
                FInitFolder     : String;       //�����I���t�H���_
                FSelectFolder   : String;       //�I�����ꂽ�t�H���_�p�X
                FDisplayName    : String;       //�I�����ꂽ�t�H���_������
                FTitle          : String;       //�^�C�g��
                FStatusText     : String;       //�X�e�[�^�X������
                FFlags          : UINT;         //�_�C�A���O�̃t���O
                FPosX, FPosY    : Integer;      //�_�C�A���O�̈ʒu
                FSizeX, FSizeY  : Integer;      //�_�C�A���O�̃T�C�Y�̑���
                procedure       ResizeOwnDialog;
        public
                constructor     Create;
                function        Execute: Boolean;
        published
                property        Handle: HWND            read FHandle;
                property        SelectFolder: String    read FSelectFolder;
                property        DisplayName: String     read FDisplayName;
                property        RootFolderNum: Integer  read FRootFolderNum
                                                        write FRootFolderNum;
                property        InitFolder: String      read FInitFolder
                                                        write FInitFolder;
                property        Title: String           read FTitle
                                                        write FTitle;
                property        StatusText: String      read FStatusText;
                property        Flags: UINT             read FFlags
                                                        write FFlags;
                property        PosX: Integer           read FPosX
                                                        write FPosX;
                property        PosY: Integer           read FPosY
                                                        write FPosY;
                property        SizeX: Integer          read FSizeX
                                                        write FSizeX;
                property        SizeY: Integer          read FSizeY
                                                        write FSizeY;
        end;

const
        bifReturnOnlyFSDIRs = BIF_RETURNONLYFSDIRS;
        bifDontGoBelowDomain = BIF_DONTGOBELOWDOMAIN;
        bifStatusText = BIF_STATUSTEXT;
        bifReturnFSAncestors = BIF_RETURNFSANCESTORS;
        bifBrowseForComputer = BIF_BROWSEFORCOMPUTER;
        bifBrowseForPrinter = BIF_BROWSEFORPRINTER;
        bifBrowseIncludeFiles = BIF_BROWSEINCLUDEFILES;

implementation

function GetClientPos(hOwner, hChild: THandle): TPoint;
 (* �q�E�C���h�E�̐e�E�C���h�E�N���C�A���g���W *)
var
        rc: TRect;
begin
        GetWindowRect(hChild, rc);
        Result := rc.TopLeft;
        Windows.ScreenToClient(hOwner, Result);
end;

constructor TBrowseFolderBox.Create;
begin
        {* �v���p�e�B�����l *}
        FFlags := BIF_RETURNONLYFSDIRS;
        FRootFolderNum := CSIDL_DESKTOP;
end;

procedure TBrowseFolderBox.ResizeOwnDialog;
 (* �_�C�A���O�̃T�C�Y�A�ʒu�ύX *)
type    sResizeType = ( rtOwner, rtSize, rtAncRB );
        TResizeTable = Record
                Parent : Boolean;
                Name, Text : String;
                ReType : sResizeType;
        end;
const   ResizeTable : array [0..4] of TResizeTable = (
                ( Parent:False; Name:'SysTreeView32'; Text:''; ReType:rtSize ),
                ( Parent:False; Name:'Button'; Text:'OK'; ReType:rtAncRB ),
                ( Parent:False; Name:'Button'; Text:'��ݾ�'; ReType:rtAncRB ),
                ( Parent:True;  Name:' '; ReType:rtOwner ),
                ( Parent:False; Name:'' )
        );
var
        wnd : HWND;
        idx, OrgCX, OrgCY : Integer;
        rect : TRect; 
        Pnt : TPoint;
begin
        idx := 0;
        while ResizeTable[idx].Name<>'' do begin
                if ResizeTable[idx].Parent then
                        wnd := FHandle
                else
                        wnd := FindWindowEx( FHandle, 0,
                                        PChar( ResizeTable[idx].Name ),
                                        PChar( ResizeTable[idx].Text ) );
                if wnd<>0 then begin
                        // Pnt �����̃N���C�A���g���W
                        Pnt := GetClientPos( FHandle, wnd );
                        // OrgCX, OrgCY �����̃T�C�Y
                        GetWindowRect( wnd, rect );
                        OrgCX := rect.Right-rect.Left;
                        OrgCY := rect.Bottom-rect.Top;

                        //�ړ��A�T�C�Y�ύX
                        case ResizeTable[idx].ReType of
                                //�e�E�C���h�E
                                rtOwner : MoveWindow( wnd, FPosX, FPosY,
                                        OrgCX+FSizeX, OrgCY+FSizeY, True );
                                //�T�C�Y�ύX�i�ꏊ�͂��̂܂܁j
                                rtSize : MoveWindow( wnd, Pnt.X, Pnt.Y,
                                        OrgCX+FSizeX, OrgCY+FSizeY, False );
                                //�E�����A���J�[�ɂ��Ĉړ��i�T�C�Y�͂��̂܂܁j
                                rtAncRB : MoveWindow( wnd,
                                        Pnt.X+FSizeX, Pnt.Y+FSizeY,
                                        OrgCX, OrgCY, False );
                        end;
                end;
                inc( idx );
        end;
end;

function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam, lpData: LPARAM)
: Integer; stdcall;
 (* SHBrowseForFolder �̃R�[���o�b�N *)
var
        ppmem : IMalloc;
        Path : String;
begin
        Result:= 0;
        SetLength( Path, MAX_PATH );
        SHGetMalloc( ppmem );

        with ( TObject( lpData ) as TBrowseFolderBox ) do begin
                //�_�C�A���O�� hwnd ��ݒ�
                if FHandle=0 then FHandle := hwnd;

                if uMsg=BFFM_INITIALIZED then begin
                        //�����t�H���_�̐ݒ�
                        SendMessage( hwnd, BFFM_SETSELECTION, 1,
                        Longint( PChar( FInitFolder ) ) );
                        ResizeOwnDialog;
                end
                else if uMsg=BFFM_SELCHANGED then begin
                        SHGetPathFromIDList( PItemIDList( lParam ),
                                        PChar( Path ) );
                        FStatusText := Path;
                        //�X�e�[�^�X�ɃJ�[�\���ʒu�t�H���_�\��
                        if ( BIF_STATUSTEXT and FFlags <>0 ) then begin
                                SendMessage( hwnd, BFFM_SETSTATUSTEXT, 0,
                                        Longint( PChar( FStatusText ) ) );
                        end;
                        ppmem.Free( PItemIDList( lParam ) );
                end;
        end;
end;

function TBrowseFolderBox.Execute: Boolean;
 (* �_�C�A���O�{�b�N�X���o�� *)
var
        pidlRoot, pidlSelect : PItemIDList;
        ppmem : IMalloc;
        DisplayNameBuf, SelectFolderBuf : array [0..MAX_PATH] of Char;
begin
        Result := FALSE;
        SHGetMalloc( ppmem );

        if not SUCCEEDED( SHGetSpecialFolderLocation( 0, FRootFolderNum,
        pidlRoot ) ) then Exit;
        // BROWSEINFO ��ݒ�
        with FBrowseInfo do begin
                pidlRoot := pidlRoot;
                pszDisplayName := DisplayNameBuf;
                lpszTitle := PChar( FTitle );
                ulFlags := FFlags;
                lpfn := @BrowseCallbackProc;
                lParam := Longint( Self );
        end;

        //�_�C�A���O�{�b�N�X���o��
        pidlSelect := SHBrowseForFolder( FBrowseInfo );
        FHandle := 0;
        //�t�H���_���I�����ꂽ���H
        if Assigned( pidlSelect ) then begin
                if SHGetPathFromIDList( pidlSelect, SelectFolderBuf )
                then begin
                        Result := True;
                        FSelectFolder := String( SelectFolderBuf );
                        FDisplayName := String( DisplayNameBuf );
                end;
                ppmem.Free( pidlSelect );
        end;
        ppmem.Free( pidlRoot );
end;

end.
