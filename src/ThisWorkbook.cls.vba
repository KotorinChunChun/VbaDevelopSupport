VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub Workbook_AfterSave(ByVal Success As Boolean)
'    Call UserNameStackPush
'    Debug.Print "Workbook_AfterSave", "Success:="; Success
End Sub

Private Sub Workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)
'xlam�ł�������s����ƕۑ����s���Ȃ��B
'�X��AfterSave�C�x���g�ɂ����ǂ蒅���Ȃ�
'    Call UserNameStackPush(" ")
'    Debug.Print "Workbook_BeforeSave", "SaveAsUI:="; SaveAsUI, "Cancel:="; Cancel
End Sub

Private Sub Workbook_Open()
    Call VbeMenuItemAdd
End Sub

Private Sub Workbook_BeforeClose(Cancel As Boolean)
    Call VbeMenuItemDel
End Sub
