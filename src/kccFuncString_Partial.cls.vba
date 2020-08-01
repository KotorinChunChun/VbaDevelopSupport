VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "kccFuncString_Partial"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem --------------------------------------------------------------------------------
Rem
Rem  @module        kccFuncString_Partial
Rem
Rem  @description   ������ϊ��֐�
Rem
Rem  @update        2020/08/01
Rem
Rem  @author        @KotorinChunChun (GitHub / Twitter)
Rem
Rem  @license       MIT (http://www.opensource.org/licenses/mit-license.php)
Rem
Rem --------------------------------------------------------------------------------

Rem Right�֐��g��  �Ō�ɏo�������؂蕶�����؂�ڂƂ��ĉE���̕�����Ԃ�
Rem
Rem  @param base_str      ���o����������
Rem  @param cut_str       �ؒf������i�������猟�����ĊY�����镶����̎�O�܂ł����o���j
Rem  @param cut_inc       �ؒf��������܂߂ĕԂ����ǂ����i�ʏ�͏��O����j
Rem  @param shift_len     ���o���������]���Ɏ��o���������i�v���X�j�A��藎�Ƃ��������i�}�C�i�X�j
Rem  @param should_fill   ���݂��Ȃ��ꍇ�͓��͕�����Ŗ��߂邩�i����True�j
Rem
Rem  @return As String
Rem
Rem  @example
Rem
Public Function RightStrRev(base_str, cut_str, _
                                Optional cut_inc As Boolean = False, _
                                Optional shift_len As Long = 0, _
                                Optional should_fill = True) As String
    If InStrRev(base_str, cut_str, -1) > 0 And cut_str <> "" Then
        If cut_inc Then
            RightStrRev = Right(base_str, Len(base_str) - InStrRev(base_str, cut_str, -1) + shift_len + 1)
        Else
            RightStrRev = Right(base_str, Len(base_str) - InStrRev(base_str, cut_str, -1) + shift_len + 1 - Len(cut_str))
        End If
    ElseIf should_fill Then
        RightStrRev = base_str
    Else
        RightStrRev = ""
    End If
End Function

Rem �ʏ�g�����ɉ����āA�����񒆂̘A���X�y�[�X���V���O���X�y�[�X�ɕϊ�����B
Rem Excel�֐���TRIM�݊�
Rem
Rem  @param base_str       ���͕�����
Rem
Rem  @return As String
Rem
Rem  @example
Rem
Public Function Trim2to1(ByVal base_str) As String
    Do
        Trim2to1 = Replace(Trim(base_str), "  ", " ")
        If Trim2to1 = base_str Then Exit Do
        base_str = Trim2to1
    Loop
End Function

Rem  @description �����鏉�ߊ��ʂ�������ʂ�Ԃ��֐�
Rem
Rem  @param open_brackets       ���ߊ��ʁi�@��ˑ������Ή��j
Rem
Rem  @return As String          ������
Rem
Function OpenBracketsToClose(open_brackets) As String
    Dim stb As String: stb = open_brackets
    Dim etb As String: etb = ""
    Select Case stb
        Case "[", "{", "<", "�m", "�o", "��"
            etb = ChrW(AscW(stb) + 2)
        Case ChrW(171)
            etb = ChrW(AscW(stb) + 16)
        Case Else
            etb = ChrW(AscW(stb) + 1)
    End Select
    OpenBracketsToClose = etb
End Function

Rem ������Ɋ܂܂�銇�ʂ��l�X�g�ɉ����ĕω�������֐�
Rem
Rem  @param base_str            ���͕�����
Rem  @param open_Bracket        �u���Ώۂ̏��ߊ��� (����l:�ۊ���)
Rem  @param replaced_brackets   �u����̏��ߊ��ʂ̔z�� (����l:[{(<��4�i�K)
Rem
Rem  @return As String          ���ʂ�u���ς݂̕�����
Rem
Rem  @note
Rem      ���ʂ̃l�X�g�͕�����̐擪���珇���ϊ����郍�W�b�N
Rem      ���߁`�����s���S�ł���؊֒m���Ȃ��̂Œ��ӂ��邱��
Rem
Rem  @example
Rem       IN : "Array(aaa, Array( hoge, fuga, piyo, Array(xxx), chun), bbb)"
Rem      OUT : "Array[aaa, Array{ hoge, fuga, piyo, Array(xxx), chun}, bbb]"
Rem
Function ReplaceBracketsNest( _
                ByVal base_str As String, _
                Optional open_bracket = "", _
                Optional replaced_brackets) As String
    If open_bracket = "" Then open_bracket = "("
    If IsMissing(replaced_brackets) Then replaced_brackets = VBA.Array("[", "{", "(", "<")
    Dim close_bracket
    close_bracket = OpenBracketsToClose(open_bracket)
    
    Dim nest As Long
    Dim i As Long
    nest = 0
    For i = 1 To Len(base_str)
        Select Case Mid(base_str, i, 1)
            Case open_bracket
                Mid(base_str, i, 1) = replaced_brackets(nest)
                nest = nest + 1
            Case close_bracket
                nest = nest - 1
                Mid(base_str, i, 1) = OpenBracketsToClose(replaced_brackets(nest))
        End Select
    Next
    ReplaceBracketsNest = base_str
End Function

Rem ��؂蕶����̂����������Ɉ͂�ꂽ�͈͂����̕������ʂ�Ԃ�
Rem
Rem  @param base_str        ���͕�����
Rem  @param start_brackets  �J�n�������̎�ށi�I���J�b�R�͎������f�j
Rem  @param remove_brackets �J�b�R��...True:�폜����(����) False:�c��
Rem
Rem  @return As Variant/Variant(0 To #)
Rem
Rem  @example
Rem          remove_brackets = False
Rem          Missing                              >> Variant(0 to -1) {}
Rem          String ""                            >> Variant(0 to -1) {}
Rem          String "abc,def,[ghi,jkl,mno],pqr"   >> String(0 to 2) {"ghi","jkl","mno"}
Rem          String "[abc,def],ghi[,jkl,mno],pqr" >> String(0 to 4) {"abc","def","","jkl","mno"}
Rem          String "abc,def,ghi,jkl,mno[,pqr]"   >> String(0 to 1) {"","pqr"}
Rem
Rem          remove_brackets = True
Rem          Missing                              >> Variant(0 to -1) {}
Rem          String ""                            >> Variant(0 to -1) {}
Rem          String "abc,def,[ghi,jkl,mno],pqr"   >> String(0 to 2) {"ghi","jkl","mno"}
Rem          String "[abc,def],ghi[,jkl,mno],pqr" >> String(0 to 4) {"abc","def","","jkl","mno"}
Rem          String "abc,def,ghi,jkl,mno[,pqr]"   >> String(0 to 1) {"","pqr"}
Rem
Rem  @note
Rem     ����q�ɂ͔�Ή�
Rem
Public Function SplitWithInBrackets(ByVal base_str, _
                                        start_brackets, _
                                        Optional remove_brackets As Boolean = True _
                                        ) As Variant
    SplitWithInBrackets = VBA.Array()
    If IsMissing(base_str) Then Exit Function
    If base_str = "" Then Exit Function

    Dim reg     As Object: Set reg = CreateObject("VBScript.RegExp")
    Dim retVal     As String
    
    Const CashDelimiter = vbVerticalTab
    Dim openDelim As String, closeDelim As String
    Select Case start_brackets
        Case "(", "["
            openDelim = "\" & start_brackets
            closeDelim = "\" & OpenBracketsToClose(start_brackets)
        Case Else
            openDelim = start_brackets
            closeDelim = OpenBracketsToClose(start_brackets)
    End Select

    SplitWithInBrackets = Split(vbNullString)
    base_str = Replace(base_str, vbLf, "")

    ' �������������ʓ��ȊO�𒊏o
    'reg.Pattern = "^(.*?)\(|\)(.*?)\(|\)(.*?).*$"
    reg.Pattern = "^(.*?)" & openDelim & "|" & closeDelim & "(.*?)" & openDelim & "|" & closeDelim & "(.*?).*$"
    'reg.Pattern = "\[[^\[\]]*(?=\])"
    ' ������̍Ō�܂Ō�������
    reg.Global = True

    ' ������v�������J���}�ɒu��������
    retVal = reg.Replace(base_str, CashDelimiter)

    If IsEmpty(retVal) Or retVal = "" Then Exit Function
    If reg.Execute(base_str).Count = 0 Then Exit Function

    ' �擪�ƍŌ�̃J���}��������������
    retVal = Mid(retVal, 2, Len(retVal) - 2)

    ' ���ʓ��̕���������ʂ̐������z��Ƃ��Ď擾
    SplitWithInBrackets = Split(retVal, CashDelimiter)

End Function

Rem �t�@�C���p�X��W�J���āA�f�B���N�g���A�t�@�C�����A�g���q�@���Ƃ肾��
Rem
Rem  @param FullPath        �t���p�X�f�[�^
Rem  @param AddPath         �߂�l�Ƀt�H���_�p�X���܂߂�
Rem  @param AddName         �߂�l�Ƀx�[�X�t�@�C�������܂߂�
Rem  @param AddExtension    �߂�l�Ɋg���q���܂߂�
Rem  @param outPath         �������Ƀt�H���_�p�X��Ԃ�(C:\hoge\)
Rem  @param outName         �������Ƀt�@�C�����܂��̓t�H���_����Ԃ�("fuga")
Rem  @param outExtension    �������Ɋg���q��Ԃ�(".ext")
Rem  @param outIsFolder     ��������outName���t�H���_�̎�True��Ԃ�
Rem
Rem  @return    As String   ���������p�X�f�[�^
Rem
Rem  @note
Rem     �߂�l��outName�ɂ�\�������̂Œ��ӂ��邱��
Rem
Rem  @example
Rem    | param FullPath       | AddX3 | return               | outPath       | outName | outExt | IsFolder |
Rem    | -------------------- | ----- | -------------------- | ------------- | ------- | ------ | -------- |
Rem    | C:\hoge\fuga         | TTT   | C:\hoge\fuga         | C:\hoge\      | fuga    |        | TRUE     |
Rem    | C:\hoge\fuga\        | TTT   | C:\hoge\fuga         | C:\hoge\      | fuga    |        | TRUE     |
Rem    | C:\hoge\fuga\a.txt   | TTT   | C:\hoge\fuga\a.txt   | C:\hoge\fuga\ | a.      | txt    | FALSE    |
Rem    | C:\hoge\fuga\a.b.txt | TTT   | C:\hoge\fuga\a.b.txt | C:\hoge\fuga\ | a.b.    | txt    | FALSE    |
Rem    | C:\hoge\fuga\c.c     | TTT   | C:\hoge\fuga\c.c     | C:\hoge\fuga\ | c.c     |        | TRUE     |
Rem    | C:\hoge\fuga\c.c\    | TTT   | C:\hoge\fuga\c.c     | C:\hoge\fuga\ | c.c     |        | TRUE     |
Rem
Public Function GetPath( _
        ByVal FullPath, _
        ByVal AddPath As Boolean, _
        ByVal AddName As Boolean, _
        ByVal AddExtension As Boolean, _
        Optional ByRef outPath, _
        Optional ByRef outName, _
        Optional ByRef outExtension, _
        Optional ByRef outIsFolder) As String
'    outPath = "": outName = "": outExtension = "": outIsFolder = False
    outPath = "XXXX": outName = "XXXX": outExtension = "XXXX": outIsFolder = False
    
    If IsEmpty(FullPath) Then Exit Function
    If TypeName(FullPath) <> "String" Then Exit Function
    If Len(FullPath) = 0 Then Exit Function
    
    FullPath = RenewalPath(FullPath)
    If FullPath = "" Then Exit Function
    
    '�Ōオ\�Ȃ�t�H���_�����B
    '����Ă�fso�Ŏ������画�肷��B
    '���݂��Ȃ��t�H���_�̏ꍇ�A�g���q�̗L���Ŕ��������B
    'FullPath�̖����ɂ�\��t���Ȃ���ԂŌ�̏����Ɉ����p��
    outIsFolder = (FullPath Like "*\")
    If outIsFolder Then
        FullPath = Left$(FullPath, Len(FullPath) - 1)
    Else
        outIsFolder = CreateObject("Scripting.FileSystemObject").FolderExists(FullPath)
    End If
    
    '�p�X���ƃt�@�C�����̒��o
    Dim NameAndExt As String
    outPath = Strings.Left(FullPath, Strings.InStrRev(FullPath, "\"))
    NameAndExt = Strings.Right(FullPath, Strings.Len(FullPath) - Strings.InStrRev(FullPath, "\"))
    If outIsFolder Then outName = NameAndExt: GoTo ExitProc
    
    '�t�@�C�����Ɗg���q�̒��o
    outName = Strings.Left(NameAndExt, Strings.InStrRev(NameAndExt, ".") - 1)
    outExtension = Strings.Right(NameAndExt, Strings.Len(NameAndExt) - Strings.InStrRev(NameAndExt, ".") + 1)
    
ExitProc:
    GetPath = ""
    If AddPath Then GetPath = GetPath & outPath
    If AddName Then GetPath = GetPath & outName
    If AddExtension Then GetPath = GetPath & outExtension
End Function

Rem �p�X���K��̏����ɏ���������B�i�l�b�g���[�N�h���C�u�Ή��j
Public Function RenewalPath(ByVal Path As String, Optional AddYen As Boolean = False) As String
    If Strings.InStr(Path, ".") = 0 Then Path = Path & IIf(AddYen, "\", "")
    RenewalPath = Strings.Left(Path, 2) & Strings.Replace(Strings.Replace(Path, "/", "\"), "\\", "\", 3)
End Function

Rem �e�f�B���N�g����Ԃ��B
Rem \�}�[�N�͕t�^���Ȃ�
Public Function ToPathParentFolder(ByVal Path As String, Optional AddYen As Boolean = False) As String
    ToPathParentFolder = ToPathLastYen(GetPath(RenewalPath(Path), True, False, False), AddYen)
End Function

Rem �p�X�̍Ō��\��t����^����
Private Function ToPathLastYen(Path, AddYen As Boolean) As String
    If AddYen Then
        If Right(Path, 1) <> "\" Then
            ToPathLastYen = Path & "\"
        End If
    Else
        If Right(Path, 1) = "\" Then
            ToPathLastYen = Left(Path, Len(Path) - 1)
        End If
    End If
End Function
