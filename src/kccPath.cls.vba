VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "kccPath"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem --------------------------------------------------------------------------------
Rem
Rem  @module        kccPath
Rem
Rem  @description   �p�X���Ǘ��N���X
Rem
Rem  @update        2020/08/06
Rem
Rem  @author        @KotorinChunChun (GitHub / Twitter)
Rem
Rem  @license       MIT (http://www.opensource.org/licenses/mit-license.php)
Rem
Rem --------------------------------------------------------------------------------
Rem  @references
Rem    Microsoft Scripting Runtime
Rem
Rem --------------------------------------------------------------------------------
Rem  @refModules
Rem    kccFuncString
Rem    kccFuncPath
Rem
Rem --------------------------------------------------------------------------------
Rem  @history
Rem
Rem --------------------------------------------------------------------------------
Rem  @functions
Rem
Rem --------------------------------------------------------------------------------
Rem  @note
Rem
Rem --------------------------------------------------------------------------------
Option Explicit

Public FullPath__ As String
Public IsFile     As Boolean

Public Property Get fso() As FileSystemObject
    Static xxFso As Object  'FileSystemObject
    If xxFso Is Nothing Then Set xxFso = CreateObject("Scripting.FileSystemObject")
    Set fso = xxFso
End Property

Rem �I�u�W�F�N�g�̍쐬
Public Function Init(obj, Optional is_file As Boolean = True) As kccPath
    If Me Is kccPath Then
        With New kccPath
            Set Init = .Init(obj, is_file)
        End With
        Exit Function
    End If
    Set Init = Me
    
    Select Case TypeName(obj)
        Case "String":    IsFile = is_file: FullPath = obj
        Case "File":      IsFile = True:    FullPath = ToFile(obj).Path
        Case "Folder":    IsFile = False:   FullPath = ToFolder(obj).Path
        Case "Range":     IsFile = True:    FullPath = ToRange(obj).Worksheet.Parent.FullName
        Case "Worksheet": IsFile = True:    FullPath = ToWorksheet(obj).Parent.FullName
        Case "Workbook":  IsFile = True:    FullPath = ToWorkbook(obj).FullName
        Case "Window":    IsFile = True:    FullPath = ToWindow(obj).Parent.FullName
        Case "VBProject": IsFile = True:    FullPath = VBEProjectFileName(ToVBProject(obj))
        Case Else
            On Error Resume Next
            FullPath = obj.CreateClass.FullPath: If FullPath <> "" Then IsFile = True: Exit Function
            FullPath = obj.Path: If FullPath <> "" Then IsFile = False: Exit Function
            On Error GoTo 0
            Debug.Print TypeName(obj)
            Stop
    End Select
End Function

Property Get Self() As kccPath: Set Self = Me: End Property

Public Function Clone() As kccPath
    Set Clone = kccPath.Init(Me.FullPath, Me.IsFile)
End Function

Rem VBProject���疼�O���擾����֐�
Rem
Rem  ���ۑ��̃u�b�N�ł�VBProject.FileName���G���[�ɂȂ�B
Rem  VBProject���璼�ږ��O���擾�����i�͑��ɑ��݂��Ȃ��B
Rem  ���ۑ��̃u�b�N��Workbook.FullPath�Ȃǂ�[Book1]�ƌ������P���Ȗ��O�����Ԃ��Ȃ��B
Rem
Private Property Get VBEProjectFileName(prj As VBProject) As String
On Error Resume Next
    VBEProjectFileName = prj.FileName
On Error GoTo 0
    If VBEProjectFileName <> "" Then Exit Property
    
    Dim wb As Excel.Workbook
    For Each wb In Workbooks
        If prj Is wb.VBProject Then
            VBEProjectFileName = wb.FullName
            Exit For
        End If
    Next
End Property

Rem �u�b�N������Workbook��Ԃ��B
Rem
Rem  �����������炱�̕��@�ł͎擾�ł��Ȃ����Ⴊ���邩������Ȃ��B
Rem
Public Function GetWorkbook(book_str_name) As Excel.Workbook
    Set GetWorkbook = Workbooks(book_str_name)
'    Dim wb As Workbook
'    For Each wb In Workbooks
'        If wb.Name = book_str_name Then
'            Set GetWorkbook = wb
'            Exit Function
'        End If
'    Next
End Function

Rem �t���p�X��
Property Get FullPath() As String: FullPath = Me.FullPath__ & IIf(Me.IsFile, "", "\"): End Function
Property Let FullPath(Path As String)
    If Path Like "*\" Then Me.IsFile = False
    '�t���p�X�AUNC�A���΁A�J�����g�������F�����ăt���p�X��
    FullPath__ = kccFuncString.ToPathLastYen(Path, False)
End Property

Rem �t�@�C���܂��̓t�H���_��
Property Get Name() As String
    Name = kccFuncString.GetPath(FullPath, False, True, True)
End Property

Rem �t�@�C����
Rem  �t�H���_�̂Ƃ���
Property Get FileName() As String
    Dim IsFolder As Boolean
    FileName = kccFuncString.GetPath(FullPath, False, True, True, outIsFolder:=IsFolder)
    If IsFolder Then FileName = ""
End Property

Rem �g���q���������O
Property Get BaseName() As String
    BaseName = kccFuncString.GetPath(FullPath, False, True, False)
End Property

Rem �g���q�̖��O�i.ext�j
Property Get Extension() As String
    Extension = kccFuncString.GetPath(FullPath, False, False, True)
End Property

Rem �t�H���_��
Rem  �t�@�C���̂Ƃ���
Property Get FolderName() As String
    Dim IsFolder As Boolean
    FolderName = kccFuncString.GetPath(FullPath, False, True, True, outIsFolder:=IsFolder)
    If IsFolder Then Else FolderName = ""
End Property

Rem ���t�H���_�t���p�X
Property Get CurrentFolderPath(Optional AddYen As Boolean = False) As String
    If Me.IsFile Then
        CurrentFolderPath = kccFuncString.GetPath(Me.FullPath, True, False, False)
    Else
        CurrentFolderPath = Me.FullPath
    End If
    CurrentFolderPath = kccFuncString.ToPathLastYen(CurrentFolderPath, AddYen)
End Property

Rem ���݂̃t�H���_���̕ύX
Property Let CurrentFolderName(FolderName As String)
    Dim cur As Scripting.Folder
    Set cur = Me.CurrentFolder.Folder
    cur.Name = FolderName
End Property

Rem �e�t�H���_��
Property Get ParentFolderPath(Optional AddYen As Boolean = False) As String
    If Me.IsFile Then
        ParentFolderPath = kccFuncString.GetPath(Me.CurrentFolderPath(AddYen:=False), True, False, False)
    Else
        ParentFolderPath = kccFuncString.GetPath(Me.FullPath, True, False, False)
    End If
    ParentFolderPath = kccFuncString.ToPathLastYen(ParentFolderPath, AddYen)
End Property

Rem �e�t�H���_�I�u�W�F�N�g
Property Get CurrentFolder() As kccPath
    Set CurrentFolder = kccPath.Init(Me.CurrentFolderPath, False)
End Property

Rem �e�t�H���_�I�u�W�F�N�g
Property Get ParentFolder() As kccPath
    Set ParentFolder = kccPath.Init(Me.ParentFolderPath, False)
End Property

Rem FSO�t�@�C���I�u�W�F�N�g
Public Function File() As Scripting.File
    On Error Resume Next
    Set File = fso.GetFile(FullPath)
End Function

Rem FSO�t�H���_�I�u�W�F�N�g
Public Function Folder() As Scripting.Folder
    On Error Resume Next
    Set Folder = fso.GetFolder(Me.CurrentFolderPath)
End Function

Rem VB�v���W�F�N�g
Public Function VBProject() As VBIDE.VBProject
On Error Resume Next
'    Dim VBP As VBProject
'    For Each VBP In Application.VBE.VBProjects
'        Dim prjName As String
'        prjName = VBP.FileName
'        If Err.Number = 0 Then
'            If prjName = Me.FullPath Then
'                Set VBProject = VBP
'            End If
'        End If
'    Next
    Dim wb As Workbook
    Set wb = Me.Workbook
    If wb Is Nothing Then Stop
    Set VBProject = wb.VBProject
End Function

Rem Excel���[�N�u�b�N
Public Function Workbook() As Excel.Workbook
    '[Workbooks("Book1.xlsx")]
    '[Workbooks("Book1")]
    Set Workbook = GetWorkbook(Me.FileName)
End Function

Rem ���΃p�X�ɂ��ړ������t�H���_�̃p�X
Public Function MoveFolderPath(relative_path) As String
    MoveFolderPath = kccFuncString.AbsolutePathNameEx(Me.FullPath, relative_path)
End Function

Rem ���΃p�X�ɂ��ړ������t�H���_�̃C���X�^���X��V�K����
Public Function MovePathByFolder(relative_path, Optional KeepFileName As Boolean = False) As kccPath
    Dim bas As String: bas = Me.CurrentFolderPath
    Dim ref As String: ref = relative_path
    Dim ppp As String: ppp = kccFuncString.AbsolutePathNameEx(bas, ref)
    Set MovePathByFolder = kccPath.Init(ppp, False)
End Function

Rem ���΃p�X�ɂ��ړ������t�@�C���̃C���X�^���X��V�K����
Rem   �������t�H���_�̂Ƃ��F�u���p�X\�t�@�C�����v
Rem   �������t�@�C���̂Ƃ��F�u�J�����g�t�H���_\�t�@�C�����v
Public Function MovePathByFile(relative_path) As kccPath
    Dim bas As String: bas = Me.CurrentFolderPath
    Dim ref As String: ref = IIf(relative_path Like "*\*", "", ".\") & relative_path
    Dim ppp As String: ppp = kccFuncString.AbsolutePathNameEx(bas, ref)
    Set MovePathByFile = kccPath.Init(ppp, True)
End Function

Rem �t�H���_����C�ɍ쐬
Rem  ���������ꍇ
Rem  ����:���ɑ��݂����ꍇ
Rem  ���s:�t�@�C�������ɑ��݂����ꍇ
Rem  ���s:����ȊO�̗��R
Public Function CreateFolder() As kccPath
    Set CreateFolder = Me
    If Not kccFuncPath.CreateDirectoryEx(Me.CurrentFolderPath) Then
        Debug.Print "CreateFolder ���s : " & Me.CurrentFolderPath
    End If
End Function

Rem �t�H���_���폜
Rem
Rem  @return As Boolean �폜����
Rem                         True  : ����(�폜�ɐ��� or ���X�t�H���_������)
Rem                         False : ���s(�t�H���_���c���Ă���)
Rem
Public Function DeleteFolder() As Boolean
    Dim cPath As String: cPath = Me.CurrentFolderPath
    If fso.FolderExists(cPath) Then
        '1�b�󂯂�3�񃊃g���C
        Dim n As Long: n = 3
        Do
            On Error Resume Next
            fso.DeleteFolder cPath
            If Err.Number = 0 Then Exit Do
            On Error GoTo 0
            Application.Wait [Now() + "00:00:01"]
            n = n - 1
            If n = 0 Then Exit Do 'Err.Raise 9999, "DeleteFolder", "�폜�ł��܂���"
        Loop
        DoEvents
    End If
    DeleteFolder = Not fso.FolderExists(cPath)
End Function

Rem �t�@�C���E�t�H���_�����݂��邩
Public Function Exists() As Boolean
    If Me.IsFile Then
        Exists = Not (Me.File Is Nothing)
    Else
        Exists = Not (Me.Folder Is Nothing)
    End If
End Function

Rem �t�@�C�����R�s�[����
Rem
Rem  @param dest            �R�s�[��t�@�C�����܂��̓t�H���_
Rem  @param OverWriteFiles  �R�s�[��t�@�C�������݂��鎞�㏑�����邩(����:True)
Rem
Rem  @note
Rem    dest:=�t�@�C���w��E�E�E�Ώۃt�@�C�����ŏ�������
Rem    dest:=�t�H���_�w��E�E�E�Ώۃt�H���_�Ɍ��Ɠ����t�@�C�����ŏ�������
Rem
Public Function CopyFile(dest As kccPath, _
                         Optional OverWriteFiles As Boolean = True) As kccResult
    Const PROC_NAME = "CopyFile"
    
    '�R�s�[���t�@�C���s�݁F�������ďI��
    If Not Me.Exists Then
        Set CopyFile = kccResult.Init(False, "�R�s�[���t�@�C��������܂���")
        Exit Function
    End If
    
    '�t�H���_�̏ꍇ�A�t�H���_���̂��̂��R�s�[����H������
    If Me.IsFile Then Else Stop
    
    Dim fl As File:   Set fl = Me.File
    Dim destFile As kccPath: Set destFile = dest
    If dest.IsFile Then Else Set destFile = destFile.MovePathByFile(".\" & Me.File.Name)
    
    Set CopyFile = kccResult.Init(True)
    
    If dest.Exists Then
        If OverWriteFiles Then
            CopyFile.Add True, dest.FullPath & " �㏑�����܂�"
        Else
            Set CopyFile = kccResult.Init(False, dest.FullPath & " ���ɑ��݂��邽�ߎ��s���܂���")
            Exit Function
        End If
    End If
    
    On Error GoTo CopyFileError
    fl.Copy dest.FullPath, OverWriteFiles:=OverWriteFiles
    On Error GoTo 0
    
    CopyFile.Add True, PROC_NAME & " �������܂����B"
    
CopyFileEnd:
    Exit Function
    
CopyFileError:
    CopyFile.IsSuccess = False
    Select Case MsgBox( _
            "[" & dest.FullPath & "]" & "�փt�@�C�����R�s�[�ł��܂���B" & vbLf & _
            "�t�@�C���܂������b�N����Ă��Ȃ����m�F���Ă��������B", _
            vbAbortRetryIgnore, PROC_NAME)
        Case VbMsgBoxResult.vbAbort: CopyFile.Add False, dest.FullPath & " ���s�����~����܂���", True: Resume CopyFileEnd
        Case VbMsgBoxResult.vbRetry: CopyFile.Add False, dest.FullPath & " ���s���Ď��s���܂���": Resume
        Case VbMsgBoxResult.vbIgnore: CopyFile.Add False, dest.FullPath & " ���s���ȗ�����܂���": Resume Next
    End Select
End Function

Rem �t�H���_���̃t�@�C���E�t�H���_���܂Ƃ߂ăR�s�[����
Rem
Rem  @param dest                �R�s�[��t�@�C�����܂��̓t�H���_
Rem  @param withFilterString    �܂߂�t�@�C����\��Like��r�p������(����:�S��)
Rem  @param withoutFilterString ���O����t�@�C����\��Like��r�p������(����:����)
Rem  @param OverWriteFiles      �R�s�[��t�@�C�������݂��鎞�㏑�����邩(����:True)
Rem
Rem  @note
Rem    dest:=�t�@�C���w��E�E�E�Ώۃt�@�C�����̃t�H���_���쐬
Rem    dest:=�t�H���_�w��E�E�E�Ώۃt�H���_���̃t�H���_���쐬
Rem    ���x�͒ቺ���邪�������Ă���
Rem
Public Function CopyFiles(dest As kccPath, _
                          Optional withFilterString As String = "*", _
                          Optional withoutFilterString As String = "", _
                          Optional OverWriteFiles = True) As kccResult
    Const PROC_NAME = "CopyFiles"
    
    If Me.IsFile Then: Set CopyFiles = Me.CopyFile(dest): Exit Function
    
    Set CopyFiles = kccResult.Init(True)
    
    If Me.CurrentFolderPath = "" Then Stop
    Dim fl As File
    Dim fd As String
    For Each fl In Me.Folder.Files
        If fl.Name Like withFilterString And _
            Not fl.Name Like withoutFilterString Then
            '����Copy�ł͎��s���Ă��G���[���N����Ȃ��炵���H
            '���b�N����Ă�ƃG���[���o��B
            If dest.IsFile Then
                fd = dest.ReplacePathAuto(FileName:=fl.Name).CreateFolder.FullPath
            Else
                fd = dest.ReplacePathAuto(FileName:=fl.Name).MovePathByFile(fl.Name).CreateFolder.FullPath
            End If
            On Error GoTo CopyFilesError
                fl.Copy fd, True
            On Error GoTo 0
        End If
    Next
    
    CopyFiles.Add True, PROC_NAME & " �������܂����B"
    
CopyFilesEnd:
    Exit Function
    
CopyFilesError:
    Dim res As VbMsgBoxResult
    Select Case MsgBox( _
            "[" & fd & "]" & "�փt�@�C�����R�s�[�ł��܂���B" & vbLf & _
            "�t�@�C���܂��͏�ʂ̃t�H���_�����b�N����Ă��Ȃ����m�F���Ă��������B", _
            vbAbortRetryIgnore, PROC_NAME)
        Case VbMsgBoxResult.vbAbort: CopyFiles.Add False, dest.FullPath & " ���s�����~����܂���", True: Resume CopyFilesEnd
        Case VbMsgBoxResult.vbRetry: CopyFiles.Add False, dest.FullPath & " ���s���Ď��s���܂���": Resume
        Case VbMsgBoxResult.vbIgnore: CopyFiles.Add False, dest.FullPath & " ���s���ȗ�����܂���": Resume Next
    End Select
End Function

Rem �t�H���_�����݂��邩�ۂ�
Public Function FolderExists() As Boolean
    FolderExists = fso.FolderExists(Me.FullPath)
End Function

Rem �p�X�������P���ɒu��
Public Function ReplacePath(src, dest) As kccPath
    Set ReplacePath = Me.Clone
    ReplacePath.FullPath = Replace(ReplacePath.FullPath, src, dest)
End Function

Rem �p�X��������}�W�b�N�i���o�[�ɂ��u��
Public Function ReplacePathAuto(Optional DateTime, Optional FileName) As kccPath
    Dim obj As kccPath: Set obj = Me.Clone
    If VBA.IsMissing(DateTime) Then
    Else
        Set obj = obj.ReplacePath("[YYYYMMDD]_[HHMMSS]", Format$(DateTime, "yyyymmdd_hhmmss"))
        Set obj = obj.ReplacePath("[YYYYMMDD]", Format$(DateTime, "yyyymmdd"))
        Set obj = obj.ReplacePath("[HHMMSS]", Format$(DateTime, "hhmmss"))
    End If
    If VBA.IsMissing(FileName) Then Else Set obj = obj.ReplacePath("[FILENAME]", FileName)
    Set ReplacePathAuto = obj
End Function

' �t�@�C���̕����R�[�h��SJIS����UTF8(BOM����)�ɕϊ�����
Public Sub ConvertCharCode_SJIS_to_utf8()
    If Me.IsFile Then Else Exit Sub
    If fso.FileExists(Me.FullPath) Then Else Exit Sub
    
    Dim fn As String: fn = Me.FullPath
    Dim destWithBOM As Object: Set destWithBOM = CreateObject("ADODB.Stream")
    With destWithBOM
        .Type = 2
        .Charset = "utf-8"
        .Open
        
        ' �t�@�C����SJIS �ŊJ���āAdest �� �o��
        With CreateObject("ADODB.Stream")
            .Type = 2
            .Charset = "shift-jis"
            .Open
            .LoadFromFile fn
            .Position = 0
            .copyTo destWithBOM
            .Close
        End With
        
        ' BOM����
        ' 3�o�C�g�������Ă���o�C�i���Ƃ��ďo��
        .Position = 0
        .Type = 1 ' adTypeBinary
        .Position = 3
        
        Dim dest: Set dest = CreateObject("ADODB.Stream")
        With dest
            .Type = 1 ' adTypeBinary
            .Open
            destWithBOM.copyTo dest
            .SaveToFile fn, 2
            .Close
        End With
        
        .Close
    End With
End Sub
