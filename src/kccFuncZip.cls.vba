VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "kccFuncZip"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare PtrSafe Sub Sleep Lib "Kernel32" (ByVal dwMilliseconds As Long)

Rem ZIP�t�@�C�����𓀂���
Rem
Rem  @param inFilePath      �𓀂������t�@�C���̃t���p�X
Rem  @param outParentPath   �𓀐�e�t�H���_
Rem                           �ȗ���         : �ꎞ�t�H���_
Rem                           ���[�g�J�n�p�X : �w��p�X
Rem                           ���΃p�X       : ���t�@�C����̑��΃p�X
Rem                         ���w��p�X�Ɍ��t�@�C���̊g���q�����������O�̃t�H���_�𐶐����܂��B
Rem
Rem  @return As String      �𓀂��ꂽ�p�X�̐�΃p�X�`��
Rem
Rem  @note
Rem    ���������̗���
Rem    1. %temp%\VbaUnZip\FILENAME.zip �֌��̃t�@�C�����R�s�[
Rem    2. %temp%\VbaUnZip\FILENAME\ �։�
Rem    3. 1�̃t�@�C�����폜
Rem    4. outFolderPath�ֈړ� (��ȗ���)
Rem       ���h���C�u���Ⴄ��Move�o���Ȃ�����Copy�����Delete�ƂȂ�
Rem
Rem   ���Ƀt�H���_�����݂���ꍇ�A�t�H���_���ƍ폜���Ēu�������܂��B
Rem
Rem   �w��t�H���_�֒��ډ𓀂��邱�Ƃ͏o���܂���B
Rem   �����I�ɃI�v�V������ǉ�����\���͂���܂��B
Rem   ������������ƂȂ�Ɖ𓀂������t�@�C�����ʂɍ폜���ړ����郍�W�b�N�ɕς���K�v������܂��B
Rem
Rem   �p�X���[�h�t��ZIP�t�@�C���̉𓀂͒f�O�����B
Rem
Function DecompZip(ByVal inFilePath, Optional outParentPath) As String
    Const PROC_NAME = "DecompZip"
    If Not fso.FileExists(inFilePath) Then
        Err.Raise 9999, PROC_NAME, "�W�J������ZIP�t�@�C��������܂���F" & inFilePath
        Exit Function
    End If
    
    '�ꎞ�t�H���_�̏���
    Dim tempFolderPath As String
    tempFolderPath = GetTempFolder("VbaUnZip") & fso.GetBaseName(inFilePath)
    If fso.FolderExists(tempFolderPath) Then
        If Not DeleteFolder(tempFolderPath) Then
            Err.Raise 9999, PROC_NAME, "�𓀈ꎞ�t�H���_�̏������Ɏ��s�F" & tempFolderPath
        End If
    End If
    fso.CreateFolder tempFolderPath
    
    '�o�̓t�H���_�̏���
    If VBA.IsMissing(outParentPath) Then outParentPath = ""
    Dim outFolderPath As String
    '�ȗ���   : �ꎞ�t�H���_
    If outParentPath = "" Then
        outFolderPath = ""
    Else
        '���[�g�J�n�p�X : �w��p�X
        If kccFuncString.IsRootStart(outParentPath) Then
            outFolderPath = outParentPath & fso.GetBaseName(inFilePath)
        '���΃p�X : ���t�@�C����̑��΃p�X
        Else
            Dim curFolderPath As String
            curFolderPath = fso.GetParentFolderName(inFilePath) & "\"
            outFolderPath = kccFuncString.AbsolutePathNameEx(curFolderPath, outParentPath) & fso.GetBaseName(inFilePath)
        End If
        If fso.FolderExists(outFolderPath) Then
            If Not DeleteFolder(outFolderPath) Then
                Err.Raise 9999, PROC_NAME, "�o�͐�t�H���_�̏������Ɏ��s�F" & outFolderPath
            End If
        End If
    End If
    
    '�g���q�̃`�F�b�N��ZIP����(Namespace�W�J�Ɋg���q���d�v)
    Dim zip_file_path As String
    Dim IsZip As Boolean: IsZip = inFilePath Like "*.zip"
    If IsZip Then
        zip_file_path = inFilePath
    Else
        zip_file_path = tempFolderPath & ".zip"
        fso.CopyFile inFilePath, zip_file_path
    End If
    
    'Namespace�ɂ͈Öق̌^�ϊ����K�v�Ȃ̂ŁA�ϐ��ł͂Ȃ������K�v
    Dim objZip
    Set objZip = CreateObject("Shell.Application").Namespace("" & zip_file_path).Items
    
    '���ꂾ�ƈ��萫�Ɍ����邽�߁A�p�X���[�hZIP�Ή��͒f�O
'    Application.SendKeys zipPw & "{Enter}"
    
'    DecompZip = CreateObject("Shell.Application").Namespace("" & tempFolderPath).CopyHere(objZip, &H4 Or &H10)
    DecompZip = CopyHere(tempFolderPath, objZip)
'    sha.Namespace(unzipfld_).CopyHere( sha.Namespace(zippth_).Items, &H4 Or &H10)
    
    '�L���b�V����ZIP�t�@�C���폜
    fso.DeleteFile zip_file_path
    
    If outFolderPath = "" Then
        DecompZip = tempFolderPath
    Else
        If fso.GetDriveName(tempFolderPath) <> fso.GetDriveName(outFolderPath) Then
            'MoveFolder�̓h���C�u�Ԃ̈ړ����ł��Ȃ�����CopyFolder
            '�R�s�[���\��t����ƃt�H���_�����B\�������ƒ��g�����ɂȂ�炵���B
            fso.CreateFolder outFolderPath
            fso.CopyFolder tempFolderPath, outFolderPath
            fso.DeleteFolder tempFolderPath
        Else
            fso.MoveFolder tempFolderPath, outFolderPath
        End If
        DecompZip = outFolderPath
    End If
End Function

Sub Test_DecompZip()
    Dim inFile: inFile = "D:\vba\zip\test.xlsm"
    Dim outFolder: outFolder = "D:\vba\zip\temp"
'    Debug.Print DecompZip(inFile)
    Debug.Print DecompZip(inFile, outFolder)
'    Debug.Print DecompZip(inFile, outFolder, "a")
End Sub
 
Sub Test_CompZip()
    Dim inFolder: inFolder = "D:\vba\zip\temp"
'    Dim outFile: outFile = "D:\vba\zip\hoge.xlsm"
    Debug.Print CompZip(inFolder)
End Sub

Rem �t�@�C���E�t�H���_��ZIP�`���ň��k����
Rem
Rem  @param target_paths     ���k���̃t�@�C���E�t�H���_�̐�΃p�X�B���͂��̔z��
Rem  @param zip_file_path    ���k��̃t�@�C���̃p�X
Rem                           �ȗ���         : ���t�@�C���Ɠ����t�H���_�Ő擪��BaseName
Rem                           ���[�g�J�n�p�X : �w��t�H���_
Rem                           ���΃p�X       : ���t�@�C����̑��΃p�X
Rem                           ���w��p�X�Ɍ��t�@�C���̊g���q�����������O�̃t�H���_�𐶐����܂��B
Rem
Rem  @return As String      ���k���ꂽ�t�@�C���̐�΃p�X
Rem
Rem  @note
Rem
Rem
Function CompZip(target_paths, Optional zip_file_path) As String
    Const PROC_NAME = "CompZip"
    
    Dim targetPaths As Collection
    Set targetPaths = ToCollection(target_paths)
    Dim i As Long
    For i = 1 To targetPaths.Count
        Dim s As String: s = targetPaths.Item(i)
        If s Like "*\" Then targetPaths(i) = Left(s, Len(s) - 1)
    Next
    Dim firstTargetPath As String: firstTargetPath = targetPaths.Item(1)
    
    '�ȗ���   : ���t�@�C���Ɠ����t�H���_�Ő擪��BaseName
    If VBA.IsMissing(zip_file_path) Then zip_file_path = ""
    If zip_file_path = "" Then
        zip_file_path = firstTargetPath & ".zip"
    '���΃p�X or ��΃p�X
    Else
        Dim ParentFolderPath As String
        ParentFolderPath = fso.GetParentFolderName(firstTargetPath)
        zip_file_path = kccFuncString.AbsolutePathNameEx(ParentFolderPath, zip_file_path)
    End If
    If fso.FileExists(zip_file_path) Then fso.DeleteFile zip_file_path
    If fso.FileExists(zip_file_path) Then
        Err.Raise 9999, PROC_NAME, "�o��ZIP���������ł��܂���F" & zip_file_path
        Exit Function
    End If
    
    Dim tempZipName As String
    If zip_file_path Like "*.zip" Then
        tempZipName = zip_file_path
    Else
        tempZipName = zip_file_path & ".zip"
    End If
    
    'ZIP�t�@�C���̐V�K�쐬
    With fso.CreateTextFile(tempZipName, True)
        .Write Chr(80) & Chr(75) & Chr(5) & Chr(6) & String(18, 0)
        .Close
    End With
    
    '���̏��������ƃt�H���_�����[�g�ɍ쐬����Ă��܂��B
'    CompZip = zipFolder.CopyHere("" & targetPaths & "\")
    
    Dim tgt As Variant
    Dim f As Object
    Dim Result As Boolean
    For Each tgt In targetPaths
        If fso.FileExists(tgt) Then
            Result = CopyHere(tempZipName, tgt)
        ElseIf fso.FolderExists(tgt) Then
            For Each f In fso.GetFolder(tgt).Files
                Result = CopyHere(tempZipName, f.Path)
            Next
            For Each f In fso.GetFolder(tgt).SubFolders
                Result = CopyHere(tempZipName, f.Path)
            Next
        Else
            Dim msg As String
            msg = PROC_NAME & " �\�[�X������܂���F" & tgt
            'Err.Raise 9999,msg
            Debug.Print msg
        End If
    Next
    
    If tempZipName <> zip_file_path Then
        fso.MoveFile tempZipName, zip_file_path
    End If
    
End Function

'�񓯊��������ς݂�CopyHere���\�b�h
'��Object��String���� sha�ɂ�Variant�œn������
Function CopyHere(ToObjectOrPath As Variant, FromObjectOrPath As Variant) As Boolean
    Dim toObj
    If IsObject(ToObjectOrPath) Then
        Set toObj = ToObjectOrPath
    Else
        Set toObj = CreateObject("Shell.Application").Namespace("" & ToObjectOrPath)
    End If
    
    '   : �ȗ���
    '4  : �w�肵���ꍇ�͓W�J���ɂ�����_�C�A���O���\������Ȃ��Ȃ�܂��B
    '16 : ????
    CopyHere = toObj.CopyHere(FromObjectOrPath, &H4 Or &H10)
    
    If IsObject(ToObjectOrPath) Then Exit Function
    If Not ToObjectOrPath Like "*.zip" Then Exit Function
    If TypeName(ToObjectOrPath) <> "String" Then Stop: Exit Function
    
    'CopyHere���񓯊��Ȃ̂ŁA������TextOpen���ē������Ƃ�
    Call WaitFileClosed("" & ToObjectOrPath)
    
End Function

Rem �w��t�@�C�����������݉\�ƂȂ�܂őҋ@����
Function WaitFileClosed(fn As String, Optional max_wait_second)
    Do
        '�R�R�ɒx�����K�{�B�������Ȃ���CopyHere���n�܂�O�Ɍ��ؗp��Open�������Ă��܂�
        Application.Wait [Now() + "00:00:00.2"]
        
        '�����ɑ}��Open���ă��b�N����Ă���CopyHere���I����Ă��Ȃ��̂ŏ����҂��p��
        On Error Resume Next
            Call fso.OpenTextFile(fn, ForAppending, False).Close
            If Err.Number = 0 Then Exit Do
'            Debug.Print ToPath, FromObjectOrPath
        On Error GoTo 0
        
        DoEvents
    Loop
    Application.Wait [Now() + "00:00:00.2"]
End Function

Public Function ToCollection(var) As Collection
    Dim Item
    If TypeName(var) = "Collection" Then
        Set ToCollection = var
    ElseIf IsArray(var) Then
        Set ToCollection = New Collection
        For Each Item In var: ToCollection.Add Item: Next
    ElseIf IsObject(var) Then
        Set ToCollection = New Collection
        On Error Resume Next
        For Each Item In var
            If Err Then Debug.Print TypeName(var), Err.Number: Stop '�I�u�W�F�N�g����̕ϊ�������
            ToCollection.Add Item
        Next
        On Error GoTo 0
    Else
        Set ToCollection = New Collection
        ToCollection.Add var
    End If
End Function

'------------------------------------------------------------------------------------------

'IShellDispatch Folder3��ParentFolder��k���ăt���p�X���擾����
'���̈Ă̓_���������B�����I�ɂ��肦�Ȃ��p�X�������Ă��܂����B
'����
' �f�X�N�g�b�v\USERNAME\AppData\Roaming\VbaUnZip\BOX_sample(group_mng1)_v1.0
'����
'    C:\Users\USERNAME\AppData\Roaming\VbaUnZip
Function GetFullPathByFolder3(obj) As String
    Dim ret As String
    ret = ""
    Dim nextObj
    Set nextObj = obj
    Do
        ret = nextObj & IIf(ret = "", "", "\") & ret
        Debug.Print ret
'        Stop
        Set nextObj = nextObj.ParentFolder
        If nextObj Is Nothing Then Exit Do
    Loop
    GetFullPathByFolder3 = ret
End Function

Function GetTempFolder(subFolder)
    GetTempFolder = VBA.CreateObject("Wscript.Shell").SpecialFolders("AppData") & "\"
    GetTempFolder = GetTempFolder & IIf(subFolder = "", "", subFolder & "\")
    On Error Resume Next
    fso.CreateFolder GetTempFolder
End Function
 
'http://excelfactory.net/excelboard/excelvba/excel.cgi?mode=all&namber=188859&rev=0
Sub ���k(ByVal OldFld As String, ByVal Str As String)
    
    Dim Result As Variant
    Result = Split(Str, "\") 'str��\�ŕ�������
    Result = Result(UBound(Result)) '�t�H���_�������o��
    
    '���ZIP�t�@�C���쐬
    Dim ts As TextStream
    Set ts = fso.CreateTextFile(Str & "\" & Result & ".zip")
    
    Dim msg As String
    msg = "PK" & Chr(5) & Chr(6) & String(18, 0)
    ts.Write (msg)
    ts.Close
    
    '�t�H���_�I�u�W�F�N�g�擾
    Dim sh As Object, fol As Object
    Set sh = CreateObject("Shell.Application")
    Set fol = sh.Namespace(Str & "\" & Result & ".zip")
    
    '�T���v���F�t�H���_����XLS�t�@�C�������k
    Dim FName As String
    FName = Dir(OldFld & "*")
    Do While (FName <> "")
        fol.MoveHere OldFld & FName 'ZIP�փt�@�C���ǉ�
        FName = Dir()
    Loop

End Sub

'�p�X���[�h�t��ZIP���k�@Lhaplus�g�p��
'�e�X�g�f�[�^��0�o�C�g�̏ꍇ�p�X�͂��Ȃ��B
Sub CompPasswordZipForLhaplus()
    Dim WSH As Object
    Dim wExec As Object
    Dim comStr As String
    Set WSH = CreateObject("WScript.Shell")
    comStr = "C:\Program Files\Lhaplus\Lhaplus.exe /c:zip /p:123 /n:C:\Users\���[�U�[��\Desktop\���k.zip C:\Users\���[�U�[��\Desktop\���k"
    Set wExec = WSH.Exec(comStr)
    Set WSH = Nothing
    Set wExec = Nothing
End Sub
 

'7-ZIP�Ȃ�΁A-p�Ńp�X���[�h�w��ł���悤�ł��B���������������B

'PDF
'xpdf���ǂ��炵��
'http://pdf-file.nnn2.com/?p=858


'https://qiita.com/RelaxTools/items/375492175ef902e59ca5

Sub Main()

    Dim Col As Collection

    Set Col = New Collection

    Col.Add "e:\README.md"

    CompressArchive Col, "E:\aaa.zip"


End Sub

'--------------------------------------------------------------
' Zip ���k����
'--------------------------------------------------------------
Private Sub CompressArchive(Col As Collection, strDest As String)

    Dim strCommand As String
    Dim strPath  As String
    Dim v As Variant
    Dim First As Boolean

    '�R�}���h
    strCommand = "Compress-Archive"

    strCommand = strCommand & " -Path"

    First = True
    For Each v In Col

        If First Then
            strPath = """" & v & """"
            First = False
        Else
            strPath = strPath & ",""" & v & """"
        End If
    Next

    strCommand = strCommand & " " & strPath

    strCommand = strCommand & " -DestinationPath"
    strCommand = strCommand & " """ & strDest & """"

    strCommand = strCommand & " -Force"


    'PowerShell �����s����
    ExecPowerShell strCommand

End Sub

'--------------------------------------------------------------
' PowerShell ���s
'--------------------------------------------------------------
Private Sub ExecPowerShell(strCommand As String)

    Dim strTemp As String
    Dim strFile As String
    Dim strBuf As String

    With CreateObject("Scripting.FileSystemObject")

        strTemp = .GetSpecialFolder(2).Path
        strFile = .BuildPath(strTemp, .GetTempName & ".ps1")

        '�e�L�X�g�o��
        With .CreateTextFile(strFile, True)
            .Write strCommand
            .Close
        End With

        strBuf = "powershell"
        strBuf = strBuf & " -ExecutionPolicy"
        strBuf = strBuf & " RemoteSigned"
        strBuf = strBuf & " -File"
        strBuf = strBuf & " """ & strFile & """"

        With CreateObject("WScript.Shell")
            Call .Run(strBuf, 0, True)
        End With

        .DeleteFile strFile

    End With

End Sub


'Scripting.FileSystemObject�AShell.Application���g�p�B
'https://qiita.com/kou_tana77/items/06f7dc897ef1a69d2ea8
Public Function zip(ArrPath() As String, zippth As String) As Boolean
    zip = False
    On Error GoTo Err
    Dim fso As Object, sha As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set sha = CreateObject("Shell.Application")
    If fso.FileExists(zippth) = True Then
        fso.DeleteFile zippth
    End If
    With fso.CreateTextFile(zippth, True)
        .Write "PK" & Chr(5) & Chr(6) & String(18, 0)
        .Close
    End With
    Dim zipfld As Object
    Set zipfld = sha.Namespace(fso.GetAbsolutePathName(zippth))
    Dim idx As Long, maxidx As Long: maxidx = UBound(ArrPath, 1)
    Dim n As Long: n = 0
    Dim f As Variant
    Dim start_tim As Date, cpyflg As Boolean
    For idx = 0 To maxidx
        cpyflg = False
        f = fso.GetAbsolutePathName(ArrPath(idx))
        If fso.FolderExists(ArrPath(idx)) = True Then
            If sha.Namespace(f).Items().Count > 0 Then  '��t�H���_�łȂ��H
                                                        '�ˋ�t�H���_�͈��k�ł��Ȃ�
                cpyflg = True
            End If
        ElseIf Dir(ArrPath(idx)) <> "" Then
            cpyflg = True
        End If
        If cpyflg = True Then
            zipfld.CopyHere f, &H4 Or &H10
            n = n + 1
            '�R�s�[���I���̂�҂�
            start_tim = Now
            Do Until zipfld.Items().Count = n
                If DateDiff("s", start_tim, Now) > 5 Then    '�^�C���I�[�o�[
                    Exit Function
                End If
                Debug.Print CStr(n) & "/" & CStr(zipfld.Items().Count)
                Sleep 10
            Loop
        End If
    Next
    zip = True
Err:
    If Err.Number <> 0 Then
        Debug.Print "zip(): " & Err.Description
    End If
    Set fso = Nothing
    Set sha = Nothing
End Function

Property Get fso() As FileSystemObject: Set fso = CreateObject("Scripting.FileSystemObject"): End Property
Property Get sha() As Object: Set sha = CreateObject("Shell.Application"): End Property

'Sub Test_UnZip()
'    Dim arr: arr = VBA.Array("D:\vba\zip\test.zip")
'    Debug.Print UnZip(arr, "D:\vba\zip\test.zip", "D:\vba\zip\temp")
'End Sub
'
'Public Function UnZip(ArrPath, zippth As String, unzipfld As String) As Boolean
'    UnZip = False
'    On Error GoTo Err
'
'    If fso.FolderExists(unzipfld) Then
'        If DeleteFolder(unzipfld) Then Else Exit Function
'    ElseIf Dir(unzipfld, vbNormal) <> "" Then
'        Debug.Print "unzip(): �t�H���_�ȊO�̃t�@�C��(" & unzipfld & ")������"
'        Exit Function
'    End If
'
'    MkDir unzipfld
'    Dim unzipfld_ As Variant, zippth_ As Variant
'    unzipfld_ = fso.GetAbsolutePathName(unzipfld)
'    zippth_ = fso.GetAbsolutePathName(zippth)
'
'    '�W�J = ���ʂ̃t�H���_�փR�s�[
'    sha.Namespace(unzipfld_).CopyHere sha.Namespace(zippth_).Items, &H4 Or &H10
'
'    '�T�u�t�H���_����
'    UnZip = move_pth4unzip(unzipfld_, ArrPath)
'
'    Exit Function
'
'Err:
'    If Err.Number <> 0 Then
'        Debug.Print "unzip(): " & Err.Description
'    End If
'End Function
'
'Private Function move_pth4unzip(unzipfld As Variant, ArrPath) As Boolean
'    move_pth4unzip = False
''    On Error GoTo Err
'    Dim idx As Long, maxidx As Long
'    maxidx = UBound(ArrPath, 1)
'    Dim f As Variant
'    For Each f In sha.Namespace(unzipfld).Items
'        Debug.Print f.Name
'        For idx = 0 To maxidx
'            If BaseName("" & ArrPath(idx)) = f.Name Then
'                Exit For
'            End If
'        Next
'        If idx <= maxidx Then
'            If move_pth4unzip1(CStr(unzipfld), f.Name, "" & ArrPath(idx)) = False Then
'                Exit Function
'            End If
'        Else
'            Debug.Print "move_pth4unzip(): " & _
'                    "zip�t�@�C���ɓW�J�ΏۊO�t�@�C��(=""" & f.Name & """)���܂܂�Ă���:=>�𖳎�"
'        End If
'    Next
'    move_pth4unzip = True
'    Exit Function
'
'Err:
'    If Err.Number <> 0 Then
'        Debug.Print "move_pth4unzip(): " & Err.Description
'    End If
'End Function
'
'Private Function move_pth4unzip1(fr_fld As String, fr_fn As String, to_Path As String) As Boolean
'    move_pth4unzip1 = False
'    On Error GoTo Err
'    If Dir(to_Path) <> "" Or fso.FolderExists(to_Path) = True Then
'        If DeleteFolder(to_Path) Then Else Exit Function
'    End If
'
'    Dim fr_Path As String: fr_Path = fr_fld & "\" & fr_fn
'    If fso.FolderExists(fr_Path) = True Then
'        fso.MoveFolder fr_Path, to_Path
'    Else
'        fso.MoveFile fr_Path, to_Path
'    End If
'    move_pth4unzip1 = True
'    Exit Function
'
'Err:
'    If Err.Number <> 0 Then
'        Debug.Print "move_pth4unzip1(): " & Err.Description
'    End If
'End Function
'
''�u�t�@�C��/�t�H���_��zip�t�@�C���Ɉ��k�v�̋L���ɂ������֐��Ɠ����֐�
''�˃R�����g�A�E�g���Ă���
''Public Function fso.FolderExists(Path As String) As Boolean
''    fso.FolderExists = CreateObject("Scripting.FileSystemObject").FolderExists(Path)
''End Function
'
'Public Function BaseName(Path As String) As String
'    Dim Path_ As String: Path_ = Trim(Path)
'    If Right(Path_, Len("\")) = "\" Then
'        Path_ = Left(Path_, Len(Path_) - Len("\"))
'    End If
'    Dim pos As Long
'    pos = InStrRev(Path_, "\")
'    If pos <> 0 Then
'        BaseName = Right(Path_, Len(Path_) - pos)
'    Else
'        BaseName = Path_
'    End If
'End Function

Rem �폜���������Ă��OK
Public Function DeleteFolder(Path) As Boolean
    DeleteFolder = False
    
    If Not fso.FolderExists(Path) Then
        Debug.Print "DeleteFolder(): �Ώۃp�X(" & Path & ")�����݂��Ȃ�"
        Exit Function
    End If
    
    On Error Resume Next
    fso.DeleteFolder Path
    If Err.Number <> 0 Then Debug.Print "DeleteFolder(): " & Err.Description, Path
    On Error GoTo 0
    
    DeleteFolder = Not fso.FolderExists(Path)
End Function
