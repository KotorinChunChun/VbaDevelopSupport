Attribute VB_Name = "AppMain"
Rem --------------------------------------------------------------------------------
Rem
Rem  @module        AppMain
Rem
Rem  @description   VBA�J�����x������VBE�g���A�h�C��
Rem
Rem  @update        0.1.x
Rem
Rem  @author        @KotorinChunChun (GitHub / Twitter)
Rem
Rem  @license       MIT (http://www.opensource.org/licenses/mit-license.php)
Rem
Rem --------------------------------------------------------------------------------
Rem  @references
Rem    Microsoft Visual Basic for Applications Extensibility 5.3
Rem    Microsoft Scripting Runtime
Rem    Microsoft Excel 16.0 Object Library
Rem
Rem --------------------------------------------------------------------------------
Rem  @refModules
Rem    VbProcInfo
Rem    VbeMenuItemCreator
Rem    kccFuncString
Rem    kccFuncPath
Rem    kccPath
Rem
Rem --------------------------------------------------------------------------------
Rem  @history
Rem    2020/08/01 �Đ���
Rem
Rem --------------------------------------------------------------------------------
Rem  @note
Rem Public Function ParamsToString(Optional Delimiter = " ,") As String �̃R���}�K�؂Ƀp�[�X�ł��Ȃ��s�������
Rem �Ȃ��������͂��̃u�b�N���]���r������
Rem
Rem
Rem --------------------------------------------------------------------------------
Option Explicit
Option Private Module

Public Const APP_NAME = "VBA�J���x���A�h�C��"
Public Const APP_CREATER = "@KotorinChunChun"
Public Const APP_VERSION = "0.1.x"
Public Const APP_SETTINGFILE = APP_NAME & ".xml"
Public Const APP_MENU_MODULE_NAME = "AppMain"

Rem �{�A�h�C���Łu��~�v�����炱������s���čċN��������
Public Sub Reset_Addin(): Call VbeMenuItemDel: Call VbeMenuItemAdd: End Sub
Public Sub Close_Addin(): Call ThisWorkbook.Close(False): End Sub

'Public Sub Auto_Open(): Call Auto_Sub("Open"): End Sub
'Public Sub Auto_Close(): Call Auto_Sub("Close"): End Sub

Rem ���j���[�ɒǉ�����v���V�[�W��
Public Sub �\�[�X���o�b�N�A�b�v�ƃG�N�X�|�[�g����():    Call VBComponents_BackupAndExport: End Sub
Public Sub �\�[�X��SRC�ɃG�N�X�|�[�g����():            Call VBComponents_Export_SRC: End Sub
Public Sub �\�[�X��YYYYMMD�ɃG�N�X�|�[�g����():        Call VBComponents_Export_YYYYMMDD: End Sub
Public Sub �\�[�X�R�[�h�̃v���V�[�W���ꗗ���o�͂���():  Call VbeProcInfo_Output: End Sub

Public Sub �v���W�F�N�g�̃t�H���_���J��():             Call OpenProjectFolder: End Sub
Public Sub �v���W�F�N�g�����():                    Call CloseProject: End Sub

Public Sub �S�ẴR�[�h�E�C���h�E�����():           Call CloseCodePanes: End Sub
Public Sub �C�~�f�B�G�C�g�E�B���h�E����ɂ���():       Call ImdClearGAX: End Sub
Public Sub VBA�J���x���A�h�C�����I������():            Call Close_Addin: End Sub

'Public Sub �e�X�g�֐������s����():          Call TestExecute: End Sub
'Public Sub �e�X�g�֐��̏ꏊ�փW�����v����(): Call TestJump: End Sub

'Public Sub �v���V�[�W���ꗗ�𕪉�����(): Call �v���V�[�W���ꗗ��������𕪉�����: End Sub

