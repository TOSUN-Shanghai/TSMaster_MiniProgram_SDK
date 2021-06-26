unit uMPDocuments;

interface

uses
  windows,
  sysutils,
  classes,
  uinclibtsmaster;

procedure write_api_document(const AObj: Pointer; const AWriteDoc: TLIBWriteAPIDocumentFunc; const AWritePara: TLIBWriteAPIParaFunc); stdcall;

implementation

procedure write_api_document(const AObj: Pointer; const AWriteDoc: TLIBWriteAPIDocumentFunc; const AWritePara: TLIBWriteAPIParaFunc); stdcall;
const
  GROUP_NAME = 'MPLibrary_Delphi';
begin
  // API - perform_add
  AWriteDoc(AObj, 'perform_add', GROUP_NAME, 'Simple add function API exported by Delphi', 's32 i = MPLibrary_Delphi.perform_add(1, 2);', 2);
  AWritePara(AObj, 0, 'perform_add', 'A1', true, 's32', 'Parameter 1');
  AWritePara(AObj, 1, 'perform_add', 'A2', true, 's32', 'Parameter 2');
  // API - perform_dec
  AWriteDoc(AObj, 'perform_dec', GROUP_NAME, 'Simple dec function API exported by Delphi', 's32 i = MPLibrary_Delphi.perform_dec(1);', 1);
  AWritePara(AObj, 0, 'perform_dec', 'A1', true, 's32', 'Parameter 1');

end;

end.
