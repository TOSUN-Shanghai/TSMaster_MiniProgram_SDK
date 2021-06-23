unit uTSMasterInternal_Delphi;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  uIncLibTSMaster,
  uMPHeader_Delphi,
  System.Generics.Collections;

type
  TMPCallback = procedure;
  Tretrieve_mp_abilities_custom_functions = function(const AObj: pointer; const AReg: TRegTSMasterFunction): s32;

function initialize_miniprogram(const AConf: PTSMasterConfiguration): s32; stdcall;
function finalize_miniprogram: s32; stdcall;
function retrieve_mp_abilities(const AObj: pointer; const AReg: TRegTSMasterFunction): s32; stdcall;

var
  // System Variables definition
  app: TTSApp;
  com: TTSCOM;
  test: TTSTest;
  // MP callbacks, NOTE: user must implement the following three functions
  vCallbackInitialization: TMPCallback;
  vCallbackFinalization: TMPCallback;
  vCallbackStep: TMPCallback;
  vCallbackRetrieveAbilities: Tretrieve_mp_abilities_custom_functions;

implementation

uses
  uMPFunctionsImpl;

var
  vIsMiniProgramInitialized: boolean;

procedure internal_step(); cdecl;
begin
  if Assigned(vCallbackStep) then begin
    vCallbackStep();
  end;

end;

function initialize_miniprogram(const AConf: PTSMasterConfiguration): s32; stdcall;
begin
  Result := 0;
  app := AConf.FTSApp;
  com := AConf.FTSCOM;
  test := AConf.FTSTest;
  if Assigned(vCallbackInitialization) then begin
    try
      vCallbackInitialization();
      vIsMiniProgramInitialized := true;
    except
      on e: Exception do begin
        Result := 1;
        OutputDebugString(PChar('Error in mp initialization: ' + e.classname + ': ' + e.Message));
      end;
    end;
  end;

end;

function finalize_miniprogram: s32; stdcall;
begin
  Result := 0;
  if not vIsMiniProgramInitialized then exit;
  if Assigned(vCallbackFinalization) then begin
    try
      vIsMiniProgramInitialized := False;
      vCallbackFinalization();
    except
      on e: Exception do begin
        Result := 1;
        OutputDebugString(PChar('Error in mp finalization: ' + e.classname + ': ' + e.Message));
      end;
    end;
  end;

end;

function retrieve_mp_abilities(const AObj: pointer; const AReg: TRegTSMasterFunction): s32; stdcall;
begin
  // version
  if not AReg(AObj, 'check_mp_internal', 'version'   , '2020.10.7.272', nil, '') then Exit(-1);
  // struct size
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_app', pointer(sizeof(TTSMasterConfiguration)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_tcan', pointer(sizeof(TlibCAN)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_tcanfd', pointer(sizeof(TlibCANFD)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_tlin', pointer(sizeof(TlibLIN)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_TMPVarInt', pointer(sizeof(TMPVarInt)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_TMPVarDouble', pointer(sizeof(TMPVarDouble)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_TMPVarString', pointer(sizeof(TMPVarString)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_TMPVarCAN', pointer(sizeof(TMPVarCAN)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_TMPVarCANFD', pointer(sizeof(TMPVarCANFD)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_TMPVarLIN', pointer(sizeof(TMPVarLIN)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_TLIBTSMapping', pointer(sizeof(TLIBTSMapping)), '') then Exit(-1);
  if not AReg(AObj, 'check_mp_internal', 'struct_size', 'struct_size_TLIBSystemVarDef', pointer(sizeof(TLIBSystemVarDef)), '') then Exit(-1);
  // register functions
  if not AReg(AObj, 'step_function', 'step', '5', @internal_step, '') then Exit(-1);
  // register mini program functions
  if Assigned(vCallbackRetrieveAbilities) then begin
    try
      Result := vCallbackRetrieveAbilities(aobj, AReg);
    except
      on e: exception do begin
        Result := -1;
        OutputDebugString(PChar('Error in mp abilities retrieve: ' + e.classname + ': ' + e.Message));
      end;
    end;
  end else begin
    Result := 0;
  end;

end;

end.
