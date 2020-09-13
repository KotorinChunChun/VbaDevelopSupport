VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "kccFuncZip"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Attribute VB_Name = "ModuleZipPdf"
Option Explicit

Private Declare PtrSafe Sub Sleep Lib "Kernel32" (ByVal dwMilliseconds As Long)



Rem outFolderPath   �ȗ���:���Ɠ����t�H���_
Rem zipPw           ZIP�t�@�C���p�X���[�h������
Function DecompZip(ByVal inFilePath, Optional outFolderPath, Optional zipPw) As String
    Const proc_name = "DecompZip"
    If Not fso.FileExists(inFilePath) Then
        Err.Raise 9999, proc_name, "�W�J������ZIP�t�@�C��������܂���F" & inFilePath
        Exit Function
    End If
    
    If VBA.IsMissing(outFolderPath) Then outFolderPath = ""
    If outFolderPath = "" Then
        outFolderPath = fso.GetParentFolderName(inFilePath) & "\" & fso.GetBaseName(inFilePath)
    End If
    If fso.FolderExists(outFolderPath) Then
        If Not DeleteFolder(outFolderPath) Then
            Err.Raise 9999, proc_name, "�o�͐�t�H���_�̏������Ɏ��s�F" & outFolderPath
        End If
    End If
    
    '�ꎞ�t�H���_�̏���
    Dim TempBaseName As String
    TempBaseName = GetTempFolder("VbaUnZip") & fso.GetBaseName(inFilePath)
    If fso.FolderExists(TempBaseName) Then
        If Not DeleteFolder(TempBaseName) Then
            Err.Raise 9999, proc_name, "�ꎞ�t�H���_�̏������Ɏ��s�F" & TempBaseName
        End If
    End If
    fso.CreateFolder TempBaseName
    
    '�g���q�̃`�F�b�N��ZIP����(Namespace�W�J�Ɋg���q���d�v)
    Dim zipFilePath As String
    Dim IsZip As Boolean: IsZip = inFilePath Like "*.zip"
    If IsZip Then
        zipFilePath = inFilePath
    Else
        zipFilePath = TempBaseName & ".zip"
        fso.CopyFile inFilePath, zipFilePath
    End If
    
    'Namespace�ɂ͈Öق̌^�ϊ����K�v�Ȃ̂ŁA�ϐ��ł͂Ȃ������K�v
    Dim objZip
    Set objZip = CreateObject("Shell.Application").Namespace("" & zipFilePath).Items
    
    '���ꂾ�ƈ��萫�Ɍ�����
'    Application.SendKeys zipPw & "{Enter}"
    
'    DecompZip = CreateObject("Shell.Application").Namespace("" & TempBaseName).CopyHere(objZip, &H4 Or &H10)
    DecompZip = CopyHere(TempBaseName, objZip)
'    sha.Namespace(unzipfld_).CopyHere( sha.Namespace(zippth_).Items, &H4 Or &H10)
    
    If fso.GetDriveName(TempBaseName) <> fso.GetDriveName(outFolderPath) Then
        'MoveFolder�̓h���C�u�Ԃ̈ړ����ł��Ȃ�����CopyFolder
        '�R�s�[���\��t����ƃt�H���_�����B\�������ƒ��g�����ɂȂ�B
        fso.CreateFolder outFolderPath
        fso.CopyFolder TempBaseName, outFolderPath
    Else
        fso.MoveFolder TempBaseName, outFolderPath
    End If
    
    DecompZip = outFolderPath
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

Function CompZip(sourceFolder, Optional zipFileName) As Boolean
    Const proc_name = "CompZip"
    
    If sourceFolder Like "*\" Then sourceFolder = Left(sourceFolder, Len(sourceFolder) - 1)
    If Not fso.FolderExists(sourceFolder) Then
        Err.Raise 9999, proc_name, "�\�[�X�t�H���_������܂���F" & sourceFolder
        Exit Function
    End If
    
    If VBA.IsMissing(zipFileName) Then zipFileName = ""
    If zipFileName = "" Then
        zipFileName = sourceFolder & ".zip"
    End If
    If fso.FileExists(zipFileName) Then fso.DeleteFile zipFileName
    If fso.FileExists(zipFileName) Then
        Err.Raise 9999, proc_name, "�o��ZIP���������ł��܂���F" & zipFileName
        Exit Function
    End If
    
    Dim tempZipName As String
    If zipFileName Like "*.zip" Then
        tempZipName = zipFileName
    Else
        tempZipName = zipFileName & ".zip"
    End If
    
    'ZIP�t�@�C���̐V�K�쐬
    With fso.CreateTextFile(tempZipName, True)
        .Write Chr(80) & Chr(75) & Chr(5) & Chr(6) & String(18, 0)
        .Close
    End With
    
    '���̏��������ƃt�H���_�����[�g�ɍ쐬����Ă��܂��B
'    CompZip = zipFolder.CopyHere("" & sourceFolder & "\")
    
    Dim f As Object
    For Each f In fso.GetFolder(sourceFolder).Files
        CompZip = CopyHere(tempZipName, f.Path)
    Next
    
    For Each f In fso.GetFolder(sourceFolder).SubFolders
        CompZip = CopyHere(tempZipName, f.Path)
    Next
    
    If tempZipName <> zipFileName Then
        fso.MoveFile tempZipName, zipFileName
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
    
    Dim result As Variant
    result = Split(Str, "\") 'str��\�ŕ�������
    result = result(UBound(result)) '�t�H���_�������o��
    
    '���ZIP�t�@�C���쐬
    Dim ts As TextStream
    Set ts = fso.CreateTextFile(Str & "\" & result & ".zip")
    
    Dim msg As String
    msg = "PK" & Chr(5) & Chr(6) & String(18, 0)
    ts.Write (msg)
    ts.Close
    
    '�t�H���_�I�u�W�F�N�g�擾
    Dim sh As Object, fol As Object
    Set sh = CreateObject("Shell.Application")
    Set fol = sh.Namespace(Str & "\" & result & ".zip")
    
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

    Dim col As Collection

    Set col = New Collection

    col.Add "e:\README.md"

    CompressArchive col, "E:\aaa.zip"


End Sub

'--------------------------------------------------------------
' Zip ���k����
'--------------------------------------------------------------
Private Sub CompressArchive(col As Collection, strDest As String)

    Dim strCommand As String
    Dim strPath  As String
    Dim v As Variant
    Dim First As Boolean

    '�R�}���h
    strCommand = "Compress-Archive"

    strCommand = strCommand & " -Path"

    First = True
    For Each v In col

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
