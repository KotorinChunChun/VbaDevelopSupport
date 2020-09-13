VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "kccBinaryFileIO"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem --------------------------------------------------------------------------------
Rem
Rem  @module        kccBinaryFileIO
Rem
Rem  @description   �o�C�i���t�@�C���ǂݏ������b�p�[�N���X
Rem
Rem  @update        2020/09/09
Rem
Rem  @author        @KotorinChunChun (GitHub / Twitter)
Rem
Rem  @license       MIT (http://www.opensource.org/licenses/mit-license.php)
Rem
Rem --------------------------------------------------------------------------------
Rem  @references
Rem    �s�v
Rem
Rem --------------------------------------------------------------------------------
Rem  @refModules
Rem    �s�v
Rem
Rem --------------------------------------------------------------------------------
Rem  @functions
Rem
Rem --------------------------------------------------------------------------------
Rem  @note
Rem    VBA�̃t�@�C������X�e�[�g�����g�ꗗ
Rem
Rem    ��{
Rem      Seek [#]#FileNumber, position
Rem      Close #FileNumber
Rem      Reset
Rem      Lock #FileNumber, position
Rem      UnLock #FileNumber, position
Rem      Open pathname For mode [Access access] [Lock] As [#]#FileNumber [Len=recLength]
Rem        Mode
Rem          Open fn For Input As #1
Rem          Open fn For Output As #1
Rem          Open fn For Random As #1
Rem          Open fn For Append As #1
Rem          Open fn For Binary As #1
Rem        [Access access]
Rem          Open fn For Binary Access Read As #1
Rem          Open fn For Binary Access Write As #1
Rem          Open fn For Binary Access Read Write As #1
Rem        [Lock]
Rem          Open fn For Binary Shared As #1
Rem          Open fn For Binary Lock Read As #1
Rem          Open fn For Binary Lock Write As #1
Rem          Open fn For Binary Lock Read Write As #1
Rem        [Len]
Rem          Open fn For Random Shared As #1 Len = 6
Rem
Rem    �ǂ�
Rem      Get [#]FileNumber, [recnumber], varname
Rem      Line Input #FileNumber, varname
Rem      Input #FileNumber, varlist
Rem
Rem    ����
Rem      Put [#]FileNumber,[recnumber],varname
Rem      Write #FileNumber, [outputlist]
Rem      Print #FileNumber, [outputlist]
Rem      Width #FileNumber, Width
Rem
Rem    �֐�
Rem      FreeFile()
Rem      EOF( #FileNumber )
Rem      LOC( #FileNumber )
Rem      FileLen( FileName)
Rem      Seek( #FileNumber )
Rem      Input( size, #FileNumber )
Rem      InputB( size, #FileNumber )
Rem
Rem    �֘A������֐�
Rem      TAB(n)
Rem      SPC(n)
Rem
Rem --------------------------------------------------------------------------------

Option Explicit

Private fp_ As Integer
Private fn_ As String
Private om_ As Long

Private Const ERROR_MSG_NOT_READABLE = "�ǂݎ��\�ŊJ����Ă��܂���"
Private Const ERROR_MSG_NOT_WRITABLE = "�������݉\�ŊJ����Ă��܂���"
Private Const ERROR_MSG_OUT_OF_INDEX = "�ǂݏ�������C���f�b�N�X���͈͊O�ł�"
Private Const ERROR_MSG_OUT_OF_SIZE = "�ǂݏ�������T�C�Y���͈͊O�ł�"
Private Const ERROR_MSG_NOT_OPEND = "�t�@�C�����J����Ă��܂���"

Private fso As New FileSystemObject

Private Sub Class_Initialize()
    '���ɉ����s��Ȃ�
    '�����ȏ������� OpenFile �ōs��
End Sub

Private Sub Init()
    'CallByName�΍�
    '���ɉ����s��Ȃ�
    '�����ȏ������� OpenFile �ōs��
End Sub

Private Sub Class_Terminate()
    Call CloseFile
End Sub

Rem �t�@�C�����J��
Rem
Rem @param mFileName        �t�@�C�����t���p�X
Rem @param R1W2RW3          1:�Ǎ���p 2:������p 3:�ǂݏ����\
Rem
Rem @return As kccBinaryFileIO �I�u�W�F�N�g�𐶐�
Rem
Function OpenFile(mFileName As String, R1W2RW3 As Long) As kccBinaryFileIO
    If Me Is kccBinaryFileIO Then
        With New kccBinaryFileIO
            Set OpenFile = .OpenFile(mFileName, R1W2RW3)
        End With
        Exit Function
    End If
    Set OpenFile = Me
    
    fn_ = mFileName
    fp_ = FreeFile()
    om_ = R1W2RW3
    
    If R1W2RW3 = 1 Then
        Open mFileName For Binary Access Read As fp_
    ElseIf R1W2RW3 = 2 Then
        If fso.FileExists(mFileName) Then
            fso.DeleteFile mFileName
        End If
        Open mFileName For Binary Access Write As fp_
    Else
        Open mFileName For Binary As fp_
    End If
End Function

Rem �t�@�C�������
Sub CloseFile()
    If fp_ <> 0 Then Close fp_
    fp_ = 0
    om_ = 0
    fn_ = ""
End Sub

Rem �ǂݍ��݉\�ł��邩
Property Get IsReadable() As Boolean
    IsReadable = (om_ And 1)
End Property

Rem �������݉\�ł��邩
Property Get IsWritable() As Boolean
    IsWritable = (om_ And 2)
End Property

Rem VBA�̊Ǘ�����t�@�C���|�C���^
Property Get FileNumber() As Long
    If fp_ = 0 Then Err.Raise 9999, "", ERROR_MSG_NOT_OPEND
    FileNumber = fp_
End Property

Rem �J���Ă���t�@�C���̃t���p�X
Property Get FileName() As String
    FileName = fn_
End Property

Rem �S�f�[�^���o�C�i���z��ňꊇ�ǂݍ���
Function ReadAllToBytes() As Byte()
    If IsReadable Then Else Err.Raise 9999, "", ERROR_MSG_NOT_READABLE
    Dim iSize: iSize = Me.FileSize()
    If iSize = 0 Then Exit Function
    
'    ReDim ReadAllToBytes(iSize)
    Seek #Me.FileNumber, 1
'    ReadAllToBytes = InputB(iSize, Me.FileNumber)
    ReDim ReadAllToBytes(0 To FileLen(Me.FileName) - 1)
    Get #Me.FileNumber, , ReadAllToBytes
    Seek #Me.FileNumber, 1
End Function

Rem �S�f�[�^���o�C�i���z��ňꊇ�ǂݍ���
Function ReadAllToString() As String
    If IsReadable Then Else Err.Raise 9999, "", ERROR_MSG_NOT_READABLE
    
    Dim iSize: iSize = Me.FileSize()
    If iSize = 0 Then Exit Function
    
    Seek #Me.FileNumber, 1
    ReadAllToString = Space(iSize)
    Get #Me.FileNumber, , ReadAllToString
    Seek #Me.FileNumber, 1
End Function

Rem 1�o�C�g�Ǎ�
Rem
Rem @param SeekIndex        �Ǎ��ʒu1~n �ȗ���:���݈ʒu
Rem
Rem @return As Byte         �ǂݍ��񂾃f�[�^
Rem
Function ReadByte(Optional SeekIndex) As Byte
    If IsReadable Then Else Err.Raise 9999, "", ERROR_MSG_NOT_READABLE
    
    If VBA.IsMissing(SeekIndex) Then
        Get #Me.FileNumber, , ReadByte
    Else
        Get #Me.FileNumber, SeekIndex, ReadByte
    End If
End Function

Rem �w��T�C�Y���o�C�g�z��ɓǍ�
Rem
Rem @param SeekIndex        �Ǎ��ʒu1~ �ȗ���:���݈ʒu
Rem @param ReadSize         �Ǎ��f�[�^�T�C�Y�������o�C�g��1~
Rem
Rem @return As Byte()       �ǂݍ��񂾃f�[�^
Rem
Function ReadBytes(Optional SeekIndex, Optional ReadSize = 1) As Byte()
    If IsReadable Then Else Err.Raise 9999, "", ERROR_MSG_NOT_READABLE
    If ReadSize < 1 Then Err.Raise 9999, "", ERROR_MSG_OUT_OF_SIZE
    
    ReDim ReadBytes(0 To ReadSize - 1)
    If VBA.IsMissing(SeekIndex) Then
        Get #Me.FileNumber, , ReadBytes
    Else
        Get #Me.FileNumber, SeekIndex, ReadBytes
    End If
End Function

Rem �w��T�C�Y�𕶎���ɓǍ��i������Byte�z��ɓ��ꂽ���Ȃ��ꍇ�Ɏg�p�j
Rem
Rem @param SeekIndex        �Ǎ��ʒu1~n �ȗ���:���݈ʒu
Rem @param ReadSize         �Ǎ��f�[�^�T�C�Y�������o�C�g��1~
Rem
Rem @return As String       �ǂݍ��񂾃f�[�^
Rem
Function ReadString(Optional SeekIndex, Optional ReadSize = 1) As String
    If IsReadable Then Else Err.Raise 9999, "", ERROR_MSG_NOT_READABLE
    If ReadSize < 1 Then Err.Raise 9999, "", ERROR_MSG_OUT_OF_SIZE
    
    ReadString = Space(ReadSize)
    If VBA.IsMissing(SeekIndex) Then
        Get #Me.FileNumber, , ReadString
    Else
        Get #Me.FileNumber, SeekIndex, ReadString
'        ReadString = InputB(ReadSize, #Me.FileNumber)
    End If
End Function

Rem �f�[�^�������o��
Rem
Rem @param sameData         �����o�������C�ӂ̃f�[�^
Rem @param SeekIndex        �Ǎ��ʒu1~n �ȗ���:���݈ʒu
Rem
Rem @note
Rem   http://www016.upp.so-net.ne.jp/garger-studio/gameprog/vb0124.html
Rem   Variant�^�̕ϐ��̂܂܏������ނƁA�f�[�^�̑O�Ɍ^����v�f��񂪓����Ă��܂��B
Rem   Byte() �^���?4byte�v�f��4byte  00��4byte
Rem          11 20 01 00 0A 00 00 00 00 00 00 00
Rem   String �^���?4byte
Rem          08 00 0A 00
Rem   ���[�U�[��`�^��Variant�ɒ��ۉ��o���Ȃ��̂Œf�O�����B
Rem
Sub WriteByte(sameData, Optional SeekIndex)
    If Not VBA.IsMissing(SeekIndex) Then
        If SeekIndex > 0 Then
            Me.FileSeek SeekIndex
        End If
    End If
    
    Dim bData() As Byte
    Select Case TypeName(sameData)
        Case "Byte"
            ReDim bData(0 To 0)
            bData(0) = sameData
            Put #Me.FileNumber, , bData
        Case "Byte()"
            bData = sameData
            Put #Me.FileNumber, , bData
        Case "String"
            Dim sData As String
            sData = sameData
            Put #Me.FileNumber, , sData
        Case Else
            MsgBox "����`�̃f�[�^�`���̂��߈Ӑ}���Ȃ��f�[�^�ŏ����o����鋰�ꂪ����܂�"
            Put #Me.FileNumber, , sameData
    End Select
End Sub

Rem �t�@�C���̑S���܂��͈ꕔ�����b�N
Rem
Rem @param SeekIndex        �Ǎ��ʒu1~n �ȗ���:���݈ʒu
Rem
Rem @note
Rem   �����̃v���Z�X�������t�@�C���ɃA�N�Z�X�ł���ꍇ�Ɏg�p
Rem   Open "C:\Test.dat" For Random Shared As #1 Len = 6
Rem
Sub FileLock(Optional SeekIndex As Long)
    If VBA.IsMissing(SeekIndex) Then
        Lock #Me.FileNumber
    Else
        Lock #Me.FileNumber, SeekIndex
    End If
End Sub

Rem �t�@�C���̑S���܂��͈ꕔ�����b�N����
Rem
Rem @param SeekIndex        �Ǎ��ʒu1~n �ȗ���:���݈ʒu
Rem
Sub FileUnLock(Optional SeekIndex As Long)
    If VBA.IsMissing(SeekIndex) Then
        Unlock #Me.FileNumber
    Else
        Unlock #Me.FileNumber, SeekIndex
    End If
End Sub

Rem ���݂̓ǂݏ����ʒu�������J�[�\��
Function Cursol() As LongPtr
    Cursol = VBA.Loc(Me.FileNumber)
'    Cursol = Seek(Me.FileNumber) '���`
End Function

Rem �t�@�C���̃o�C�g�����擾(FileLen�Ƃ͈ႢOpen�����ǂ߂�j
Function FileSize()
    FileSize = VBA.LOF(Me.FileNumber)
End Function

Rem �ǂݍ��݈ʒu���V�t�g
Function FileSeek(Optional SeekIndex = 1)
    If SeekIndex < 1 Then Err.Raise 9999, "", ERROR_MSG_OUT_OF_INDEX
    Seek #Me.FileNumber, SeekIndex
End Function

Rem �t�@�C�������[�ɓ��B�ς݂�
Function IsEndOfFile() As Boolean
    IsEndOfFile = VBA.EOF(Me.FileNumber)
End Function
