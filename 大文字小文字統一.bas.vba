
'���̃\�[�X�R�[�h�S����K���ȃ��W���[���ɃR�s�y������ACtrl+Z�Ŗ߂����Ƃő啶��������������ł���B
Option Explicit


'WinAPI��DLL������
'�擪�啶���A".dll"�����œ���
Public Declare PtrSafe Function GdipCreateSolidFill Lib "GDIPlus" ()
Public Declare PtrSafe Sub CopyMemory Lib "Kernel32" ()
Public Declare PtrSafe Function GetAsyncKeyState% Lib "User32" ()
Public Declare PtrSafe Function SHCreateDirectoryEx Lib "Shell32" ()


'VBA�W���֐�
Type VBAKeywordUpperLowerCaseUnification
        
    '���w�֐� VBA.Math�����o
    Abs As Long
    Atn As Long
    Cos As Long
    Exp As Long
    Log As Long
    Rnd As Long
    Sgn As Long
    Sin As Long
    Sqr As Long
    Tan As Long
    Round As Long '���̑�����ړ�
    
    '�f�[�^�^�ϊ��֐��@VBA.Conversion
    CBool As Long
    CByte As Long
    CCur As Long
    CDate As Long
    CDbl As Long
    CDec As Long
    CInt As Long
    CLng As Long
    CLngPtr As Long   '�ǉ�
    CSng As Long
    CStr As Long
    CVar As Long
    CVDate As Long
    CVErr As Long     '�ϊ��֐�����ړ�
    Error As Long     '�ϊ��֐�����ړ�
    Fix As Long       '���w�֐�����ړ�
    Hex As Long       '�ϊ��֐�����ړ�
    Int As Long       '���w�֐�����ړ�
    MacID As Long     '���̑�����ړ�
    Oct As Long       '�ϊ��֐�����ړ�
    Str As Long       '�ϊ��֐�����ړ�
    Val As Long       '�ϊ��֐�����ړ�
    
    '������֐� VBA.Strings
    Asc As Long       '�ϊ��֐�����ړ�
    AscB As Long      '�ϊ��֐�����ړ�
    AscW As Long      '�ϊ��֐�����ړ�
    Chr As Long       '�ϊ��֐�����ړ�
    ChrB As Long      '�ϊ��֐�����ړ�
    ChrW As Long      '�ϊ��֐�����ړ�
    Filter As Long    '���̑�����ړ�
    Format As Long    '�ϊ��֐�����ړ�
    FormatCurrency As Long    '���̑�����ړ�
    FormatDateTime As Long    '���̑�����ړ�
    FormatNumber As Long      '���̑�����ړ�
    FormatPercent As Long     '���̑�����ړ�
    InStr As Long
    InStrB As Long
    InStrRev As Long
    Join As Long
    LCase As Long
    Left As Long
    LeftB As Long
    Len As Long
    LenB As Long
    Ltrim As Long
    Mid As Long
    MidB As Long
    MonthName As Long
    Replace As Long
    Right As Long
    RightB As Long
    Rtrim As Long
    Space As Long
    Split As Long
    StrComp As Long
    StrConv As Long
    String As Long
    StrReverse As Long
    Trim As Long
    UCase As Long
    WeekdayName As Long
    
    'VBA.[_HiddenModule]
    Array As Long
    Input As Long
    InputB As Long
    ObjPtr As Long    '�ǉ�
    StrPtr As Long    '�ǉ�
    VarPtr As Long    '�ǉ�
    Width As Long     '�ǉ�
    
    'VBA.Information
    Erl As Long       '�ǉ�
    Err As Long       '�ǉ�
    IMEStatus As Long
    IsArray As Long
    IsDate As Long
    IsEmpty As Long
    IsError As Long
    IsMissing As Long
    IsNull As Long
    IsNumeric As Long
    IsObject As Long
    QBColor As Long
    Rgb As Long
    TypeName As Long
    VarType As Long
    
    'VBA.Interaction
    AppActivate As Long     '�ǉ�
    Beep As Long     '�ǉ�
    CallByName As Long
    Choose As Long
    Command As Long
    CreateObject As Long
    DeleteSetting As Long     '�ǉ�
    DoEvents As Long
    Environ As Long
    GetAllSettings As Long
    GetObject As Long
    GetSetting As Long
    IIf As Long
    InputBox As Long
    MacScript As Long
    MsgBox As Long
    Partition As Long
    SaveSetting As Long   '�ǉ�
    SendKeys As Long      '�ǉ�
    Shell As Long
    Switch As Long
    
    'VBA.FileSystem
    ChDir As Long      '�ǉ�
    ChDrive As Long      '�ǉ�
    CurDir As Long
    Dir As Long
    EOF As Long
    FileAttr As Long
    FileCopy As Long      '�ǉ�
    FileDateTime As Long
    FileLen As Long
    FreeFile As Long
    GetAttr As Long
    Kill As Long      '�ǉ�
    Loc As Long
    LOF As Long
    MkDir As Long      '�ǉ�
    Reset As Long      '�ǉ�
    RmDir As Long      '�ǉ�
    Seek As Long
    SetAttr As Long      '�ǉ�
    
    'VBA.DateTime
    Calendar As Long      '�ǉ�
    Date As Long
    DateAdd As Long
    DateDiff As Long
    DatePart As Long
    DateSerial As Long
    DateValue As Long
    Day As Long
    Hour As Long
    Minute As Long
    Month As Long
    Now As Long
    Second As Long
    Time As Long
    Timer As Long
    TimeSerial As Long
    TimeValue As Long
    Weekday As Long
    Year As Long
    
    'VBA.Financial
    DDB As Long
    FV As Long
    IPmt As Long
    IRR As Long
    MIRR As Long
    NPer As Long
    NPV As Long
    Pmt As Long
    PPmt As Long
    PV As Long
    Rate As Long
    SLN As Long
    SYD As Long
    
    '�Y�����C�u��������
    LoadPicture As Long
    Spc As Long
    Tab As Long
    LBound As Long
    UBound As Long

End Type


'VBA��`�ς�1
Dim Size
Dim Color
Dim Destination
Dim FileFilter
Dim Image
Dim Appearance
Dim Key
Dim Keys
Dim Items
Dim Add
Dim Control
Dim Controls
Dim ListIndex
Dim Scroll
Dim Pages
Dim Number
Dim Version
Dim Str
Dim Val


'VBA��`�ς�2
Type KeywordUpperLowerCaseUnification
    Goto As Long
    Get As Long
    Set As Long
    Let As Long
    Select As Long
    End As Long
    Next As Long
End Type
'Application.Goto
'GoTo Label


'Excel�L�[���[�h
Dim Activate
Dim AddComment
Dim AddCommentThreaded
Dim AdvancedFilter
Dim AllocateChanges
Dim ApplyNames
Dim ApplyOutlineStyles
Dim AutoComplete
Dim AutoFill
Dim AutoFilter
Dim AutoFit
Dim AutoOutline
Dim BorderAround
Dim Calculate
Dim CalculateRowMajorOrder
Dim CheckSpelling
Dim Clear
Dim ClearComments
Dim ClearContents
Dim ClearFormats
Dim ClearHyperlinks
Dim ClearNotes
Dim ClearOutline
Dim ColumnDifferences
Dim Consolidate
Dim ConvertToLinkedDataType
Dim Copy
Dim CopyFromRecordset
Dim CopyPicture
Dim CreateNames
Dim Cut
Dim DataTypeToText
Dim DataSeries
Dim Delete
Dim DialogBox
Dim Dirty
Dim DiscardChanges
Dim EditionOptions
Dim ExportAsFixedFormat
Dim FillDown
Dim FillLeft
Dim FillRight
Dim FillUp
Dim Find
Dim FindNext
Dim FindPrevious
Dim FlashFill
Dim FunctionWizard
Dim Group
Dim Insert
Dim InsertIndent
Dim Justify
Dim ListNames
Dim Merge
Dim NavigateArrow
Dim NoteText
Dim Parse
Dim PasteSpecial
Dim PrintOut
Dim PrintPreview
Dim RemoveDuplicates
Dim RemoveSubtotal
Dim Replace
Dim RowDifferences
Dim Run
Dim SetCellDataTypeFromCell
Dim SetPhonetic
Dim Show
Dim ShowCard
Dim ShowDependents
Dim ShowErrors
Dim ShowPrecedents
Dim Sort
Dim SortSpecial
Dim Speak
Dim SpecialCells
Dim SubscribeTo
Dim Subtotal
Dim Table
Dim TextToColumns
Dim Ungroup
Dim UnMerge
Dim Properties
Dim AddIndent
Dim Address
Dim AddressLocal
Dim AllowEdit
Dim Application
Dim Areas
Dim Borders
Dim Cells
Dim Characters
Dim Column
Dim Columns
Dim ColumnWidth
Dim Comment
Dim CommentThreaded
Dim Count
Dim CountLarge
Dim Creator
Dim CurrentArray
Dim CurrentRegion
Dim Dependents
Dim DirectDependents
Dim DirectPrecedents
Dim DisplayFormat
Dim EntireColumn
Dim EntireRow
Dim Errors
Dim Font
Dim FormatConditions
Dim Formula
Dim FormulaArray
Dim FormulaHidden
Dim FormulaLocal
Dim FormulaR1C1
Dim FormulaR1C1Local
Dim HasArray
Dim HasFormula
Dim HasRichDataType
Dim Height
Dim Hidden
Dim HorizontalAlignment
Dim Hyperlinks
Dim ID
Dim IndentLevel
Dim Interior
Dim Item
Dim Left
Dim LinkedDataTypeState
Dim ListHeaderRows
Dim ListObject
Dim LocationInTable
Dim Locked
Dim MDX
Dim MergeArea
Dim MergeCells
Dim Name
Dim NumberFormat
Dim NumberFormatLocal
Dim Offset
Dim Orientation
Dim OutlineLevel
Dim PageBreak
Dim Parent
Dim Phonetic
Dim Phonetics
Dim PivotCell
Dim PivotField
Dim PivotItem
Dim PivotTable
Dim Precedents
Dim PrefixCharacter
Dim Previous
Dim QueryTable
Dim Range
Dim ReadingOrder
Dim Resize
Dim Row
Dim RowHeight
Dim Rows
Dim ServerActions
Dim ShowDetail
Dim ShrinkToFit
Dim SoundNote
Dim SparklineGroups
Dim Style
Dim Summary
Dim Text
Dim Top
Dim UseStandardHeight
Dim UseStandardWidth
Dim Validation
Dim Value
Dim Value2
Dim VerticalAlignment
Dim Width
Dim Worksheet
Dim WrapText
Dim XPath
Dim Selection
Dim Test
Dim Caption


'�I���W�i���ꕶ���ϐ��擾
'������\�[�X�R�[�h�ɓ\��Ɨ~������Ԃɕω�����̂�
'���ʂ�Excel�ɓ\���āA�t���b�V���t�B���ŉp�����������o���ē���Dim ��t�����OK�B
'A=1
'B=1
'C=1
'D=1
'E=1
'F=1
'G=1
'H=1
'I=1
'J=1
'K=1
'L=1
'M=1
'N=1
'O=1
'P=1
'Q=1
'R=1
'S=1
'T=1
'U=1
'V=1
'W=1
'X=1
'Y=1
'Z=1

'�I���W�i���ꕶ���ϐ�
Dim a
Dim b
Dim C
Dim d
Dim E
Dim f
Dim g
Dim H
Dim i
Dim j
Dim k
Dim l
Dim M
Dim n
Dim o
Dim p
Dim Q
Dim r
Dim s
Dim t
Dim u
Dim v
Dim W
Dim x
Dim y
Dim Z


'�I���W�i�������o
Dim st
Dim data
Dim data1
Dim data2
Dim data3
Dim data4
Dim handle
Dim N2
Dim hWnd
Dim hDc
Dim BaseRow
Dim BaseCol
Dim LastRow
Dim LastCol
Dim ColDic
Dim TableName
Dim URL
dim OutCol
Dim dItem
dim dKey


'�ύX�ۗ������o�i�R�[�h�ύX�Ƒ啶���������ύX�̃R�~�b�g�𕪗����邽�߂Ɏg�p����
