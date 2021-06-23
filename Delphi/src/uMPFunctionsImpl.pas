unit uMPFunctionsImpl;

{
  IMPORTANT: implement each function as cdecl!!!

function excel_dynamic_invoke(const AFuncName: PAnsiChar; const AInParameters: PAnsiChar; const AOutParameters: PPAnsiChar): s32; cdecl;
var
  funcName, s: string;
  ss: TStringDynArray;
  i, j: Integer;
  p: PAnsiChar;
begin
  Result := IDX_ERR_FUNC_IN_PARAMETER_NOT_VALID;
  funcname := GetStringFromC(AFuncName);
  s := GetStringFromC(AInParameters);
  ss := SplitString(s, ',');
  app.log(GetCStringFromString_OnlyOneParameter('Invoking ' + QuotedStr(funcName) + ' with parameter = ' + s), LVL_INFO);
  if funcname.Equals('load') then begin
    if Length(ss) <> 1 then begin
      LogError(app, 'Error: load parameter count invalid');
      exit;
    end;
    // para is file name
    Result := excel_load(GetCStringFromString_OnlyOneParameter(ss[0]));
    AOutParameters^ := nil;
  end else begin
    Result := IDX_ERR_FUNC_NAME_NOT_FOUND;
    LogError(app, 'Error: function name not found: ' + funcname);
  end;

end;

}

interface

uses
  Winapi.Windows,
  System.SysUtils,
  uMPHeader_Delphi;

function perform_add(const A1: s32; const A2: s32): s32; cdecl;
function perform_dec(const A1: s32): s32; cdecl;

implementation

uses
  uTSMasterInternal_Delphi;

function perform_add(const A1: s32; const A2: s32): s32; cdecl;
var
  s: ansistring;
begin
  Result := A1 + A2;
  s := AnsiString('this is add from delphi: ' + result.tostring);
  app.log(pansichar(s), lvl_ok);

end;

function perform_dec(const A1: s32): s32; cdecl;
var
  s: ansistring;
begin
  Result := A1 - 1;
  s := AnsiString('this is dec from delphi: ' + result.tostring);
  app.log(pansichar(s), lvl_ok);

end;

procedure OnMPInitialization;
begin

end;

procedure OnMPFinalization;
begin

end;

procedure OnMPStepFunction;
begin

end;

function OnMPRetrieveAbilities(const AObj: pointer; const AReg: TRegTSMasterFunction): s32;
begin
  if not AReg(AObj, 'on_custom_callback', 'perform_add', 'const A1: s32; const A2: s32', @perform_add, 'add function example') then Exit(-1);
  if not AReg(AObj, 'on_custom_callback', 'perform_dec', 'const A1: s32', @perform_dec, 'dec function example') then Exit(-1);
  Result := 2;

end;

initialization
  vCallbackInitialization := OnMPInitialization;
  vCallbackFinalization := OnMPFinalization;
  vCallbackStep := OnMPStepFunction;
  vCallbackRetrieveAbilities := OnMPRetrieveAbilities;

end.
