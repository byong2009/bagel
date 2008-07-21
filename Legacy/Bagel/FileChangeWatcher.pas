unit FileChangeWatcher;

interface

uses Classes, ShellAPI;

type
  TFileChangeWatcher = class(TComponent)
//  private
//    FPath:String;
//    procedure SetPath(Value: String);

//  public
//    property Path: String read FPath write SetPath;
  end;

(*
#include <windows.h>

#include <stdio.h>

int main()
{
    // C:\Temp�̉����Ď�����
    HANDLE hFolder;
    int i;

    // �����t�@�C���̏������݂��������ꍇ�̊Ď����s��
    hFolder = FindFirstChangeNotification(
                    "c:\\temp" ,
                    FALSE ,
                    FILE_NOTIFY_CHANGE_LAST_WRITE);
    if( hFolder == INVALID_HANDLE_VALUE)
    {
        printf( "�G���[����`�` %ld\n",
                    (long)GetLastError());
        return -1;
    }

    // �ύX�����܂őҋ@����
    for( i = 0 ; i < 3; i++)
    {
        // �Ƃ肠���������ɑ҂��Ă݂�
        if( WaitForSingleObject( hFolder, INFINITE) 
                            == WAIT_OBJECT_0)
        { 
            printf( "�ύX���ꂽ��`�`�`\n");
        }
        else
        {
            printf( "�����G���[?\n");
            return -2;
        }

        // �ēx�A�ҋ@���邽�߂̎葱�����s��
        if( FindNextChangeNotification( hFolder)
                        == FALSE)
        {
            printf( "�Ď葱�����s...\n");
            return -3;
        }
    }

    // �n���h�����N���[�Y
    FindCloseChangeNotification( hFolder);

    return 0;
}
*)

(*
var
  hChange: THandle;
begin
  // �f�B���N�g���̊Ď����J�n
  hChange := FindFirstChangeNotification(
    'c:\windows',                 // �Ď�����f�B���N�g��
    LongBool(Integer(True)),      // �T�u�f�B���N�g�����Ď����邩
    FILE_NOTIFY_CHANGE_FILE_NAME  // �Ď�������e
  );
  // �G���[�`�F�b�N
  if hChange = INVALID_HANDLE_VALUE then begin
    ShowMessage('�Ď��ł��܂��� (' + IntToStr(GetLastError) + ')');
    exit;
  end;
  // �{�^���̖������ƃ��b�Z�[�W�\��
  Button1.Enabled := False;
  Label1.Caption := '�Ď����ł�';
  Application.ProcessMessages;
  // �ύX���Ď�
  WaitForSingleObject(hChange, INFINITE);
  // �{�^���̗L�����ƃ��b�Z�[�W�\��
  Button1.Enabled := True;
  Label1.Caption := '�ύX����܂���';
  // �n���h�������
  FindCloseChangeNotification(hChange);
end;
*)

implementation

end.
