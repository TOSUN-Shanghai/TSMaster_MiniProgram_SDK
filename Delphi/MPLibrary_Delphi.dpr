// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
library MPLibrary_Delphi;

{$IFOPT D-}{$WEAKLINKRTTI ON}{$ENDIF}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

{$WARN DUPLICATE_CTOR_DTOR OFF}

uses
  System.SysUtils,
  System.Classes,
  uMPHeader_Delphi in 'src\uMPHeader_Delphi.pas',
  uMPFunctionsImpl in 'src\uMPFunctionsImpl.pas',
  uTSMasterInternal_Delphi in 'src\uTSMasterInternal_Delphi.pas',
  uIncLibTSMaster in 'src\uIncLibTSMaster.pas',
  uMPDocuments_Delphi in 'src\uMPDocuments_Delphi.pas';

{$R *.res}

begin
end.
