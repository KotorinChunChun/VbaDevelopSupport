VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "kccPathEx"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem --------------------------------------------------------------------------------
Rem
Rem  @module        kccPathEx
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
Rem    kccFuncFileFolderPath
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
Public Function Init(obj, Optional is_file As Boolean = True) As kccPathEx
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

Property Get Self() As kccPathEx: Set Self = Me: End Property

Public Function Clone() As kccPathEx
    Set Clone = VBA.CVar(New kccPathEx).Init(Me.FullPath, Me.IsFile)
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
Property Get FullPath() As String: FullPath = FullPath__: End Function
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
Property Get CurrentFolder() As kccPathEx
    Set CurrentFolder = VBA.CVar(New kccPathEx).Init(Me.CurrentFolderPath, False)
End Property

Rem �e�t�H���_�I�u�W�F�N�g
Property Get ParentFolder() As kccPathEx
    Set ParentFolder = VBA.CVar(New kccPathEx).Init(Me.ParentFolderPath, False)
End Property

Rem ���݂��Ȃ��ƃG���[�ɂȂ邩��
Rem FSO�t�@�C���I�u�W�F�N�g
Public Function File() As Scripting.File: Set File = fso.GetFile(FullPath): End Function
Rem FSO�t�H���_�I�u�W�F�N�g
Public Function Folder() As Scripting.Folder: Set Folder = fso.GetFolder(Me.CurrentFolderPath): End Function

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
Public Function MoveFolder(relative_path) As kccPathEx
    Dim bas As String: bas = Me.CurrentFolderPath
    Dim ref As String: ref = relative_path
    Dim ppp As String: ppp = kccFuncString.AbsolutePathNameEx(bas, ref)
    Set MoveFolder = VBA.CVar(New kccPathEx).Init(ppp, False)
End Function

Rem ���΃p�X�ɂ��ړ������t�@�C���̃C���X�^���X��V�K����
Rem   �������t�H���_�̂Ƃ��F�u���p�X\�t�@�C�����v
Rem   �������t�@�C���̂Ƃ��F�u�J�����g�t�H���_\�t�@�C�����v
Public Function MoveFile(FileName) As kccPathEx
    Dim bas As String: bas = Me.CurrentFolderPath
    Dim ref As String: ref = IIf(FileName Like "*\*", "", ".\") & FileName
    Dim ppp As String: ppp = kccFuncString.AbsolutePathNameEx(bas, ref)
    Set MoveFile = VBA.CVar(New kccPathEx).Init(ppp, True)
End Function

Rem �t�H���_����C�ɍ쐬
Rem  ���������ꍇ
Rem  ����:���ɑ��݂����ꍇ
Rem  ���s:�t�@�C�������ɑ��݂����ꍇ
Rem  ���s:����ȊO�̗��R
Public Function CreateFolder() As kccPathEx
    Set CreateFolder = Me
    If Not kccFuncFileFolderPath.CreateDirectoryEx(Me.CurrentFolderPath) Then
        Debug.Print "CreateFolder ���s : " & Me.CurrentFolderPath
    End If
End Function

Public Function DeleteFolder()
'    On Error Resume Next
    If fso.FolderExists(Me.CurrentFolderPath) Then
        fso.DeleteFolder Me.CurrentFolderPath
    End If
End Function

Rem �t�H���_�̃t�@�C�����܂Ƃ߂ăR�s�[����
Rem ���x�͖����B
Public Function CopyFiles(dest As kccPathEx, _
        Optional withFilterString As String = "*", _
        Optional withoutFilterString As String = "")
    Dim f As File
    For Each f In Me.Folder.Files
        If f.Name Like withFilterString And _
            Not f.Name Like withoutFilterString Then
            If dest.IsFile Then
                f.Copy dest.ReplacePathAuto(FileName:=f.Name).CreateFolder.FullPath
            Else
                f.Copy dest.ReplacePathAuto(FileName:=f.Name).MoveFile(f.Name).CreateFolder.FullPath
            End If
        End If
    Next
End Function

Rem �t�H���_�����݂��邩�ۂ�
Public Function FolderExists() As Boolean
    FolderExists = fso.FolderExists(Me.FullPath)
End Function

Rem �p�X�������P���ɒu��
Public Function ReplacePath(src, dest) As kccPathEx
    Set ReplacePath = Me.Clone
    ReplacePath.FullPath = Replace(ReplacePath.FullPath, src, dest)
End Function

Rem �p�X��������}�W�b�N�i���o�[�ɂ��u��
Public Function ReplacePathAuto(Optional DateTime, Optional FileName) As kccPathEx
    Dim obj As kccPathEx: Set obj = Me.Clone
    If VBA.IsMissing(DateTime) Then
    Else
        Set obj = obj.ReplacePath("[YYYYMMDD]_[HHMMSS]", Format$(DateTime, "yyyymmdd_hhmmss"))
        Set obj = obj.ReplacePath("[YYYYMMDD]", Format$(DateTime, "yyyymmdd"))
        Set obj = obj.ReplacePath("[HHMMSS]", Format$(DateTime, "hhmmss"))
    End If
    If VBA.IsMissing(FileName) Then Else Set obj = obj.ReplacePath("[FILENAME]", FileName)
    Set ReplacePathAuto = obj
End Function
