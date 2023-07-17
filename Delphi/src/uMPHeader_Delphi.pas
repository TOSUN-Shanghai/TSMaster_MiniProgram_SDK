unit uMPHeader_Delphi;

{
  F3 for fast location
  TS_APP_PROTO_END  TS_COM_PROTO_END  TS_TEST_PROTO_END

  Note: dynamic address cannot be used in mp library !!!
        because multiple script may also use the same library function, but global object cannot be used more than one!!!
}

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  uIncLibTSMaster,
  System.Generics.Collections;

const
  // log
  LVL_COUNT            = 7; // all count
  LVL_NO_OUTPUT        = 0; // disable output
  LVL_ERROR            = 1; // critical error, NOK, red
  LVL_WARNING          = 2; // warning, COK, blue
  LVL_OK               = 3; // success, OK, green
  LVL_HINT             = 4; // hint message, yellow
  LVL_INFO             = 5; // text message, window text
  LVL_VERBOSE          = 6; // debug message, gray
  LVL_COLORS: array [0..LVL_COUNT - 1] of Integer = (
    integer($FF000008), //$FF000000 or 8,
    $0000FF, // clred
    $FF0000, // clblue
    $008000, // clgreen
    $008080, // clOlive
    integer($FF000000 or 8), // clWindowText = TColor(clSystemColor or COLOR_WINDOWTEXT)
    $808080  // clGray
  );
  LVL_IMAGE_INDEXES: array [0..LVL_COUNT - 1] of Integer = (
    227, //$FF000000 or 8,
    226, // clred
    229, // clblue
    228, // clgreen
    227, // clOlive
    227, // info
    169  // clGray
  );
  MP_DATABASE_STR_LEN = 512;

type
  u8 = UInt8;
  s8 = Int8;
  u16 = UInt16;
  s16 = Int16;
  u32 = UInt32;
  s32 = Int32;
  u64 = Int64;
  s64 = Int64;
  pu8 = ^u8;
  ps8 = ^s8;
  pu16 = ^u16;
  ps16 = ^s16;
  pu32 = ^u32;
  ps32 = ^s32;
  pu64 = ^u64;
  ps64 = ^s64;
  u8x8 = array [0..7] of u8;
  u8x64 = array [0..63] of u8;
  u16x8 = array [0..7] of u16;
  u8array = array of u8;
  f8array = array [0..7] of single;
  array_of_Integer = array of integer;
  array_of_u32 = array of u32;
  array_of_string = array of string;
  array_of_byte = array of Byte;

  TSimVarType = (
    svtInteger = 0,
    svtDouble = 1,
    svtString = 2,
    svtCANMsg = 3,
    svtCANFDMsg = 4,
    svtLINMsg = 5
  );
  TSimFunctionAPIType = (
    fatFunctionGroup = 0, fatFunction, fatDatabaseGroup, fatDatabaseSymbol
  );
  // sync. with vSimFunctionParameterTypeNames
  TSimFunctionParameterType = (
    fptS8 = 0, fptU8, fptS16, fptU16, fptS32, fptU32, fptSingle, fptDouble,
    fptpS8, fptpU8, fptpS16, fptpU16, fptpS32, fptpU32, fptpSingle, fptpDouble,
    fptBoolean, fptString, fptpBoolean, fptpString, fptppDouble,
    fptPCAN, fptPCANFD, fptPLIN, fptMapping, fptCANFDControllerType, fptCANFDControllerMode,
    fptS64, fptU64, fptpS64, fptpU64, fptpLIBSystemVarDef, fptpVoid, fptppVoid,
    fptOnIoIPData, fptpDouble1, fptpSingle1, fptpS321, fptpS322, fptpU321, fptpU322,
    fptRealtimeComment, fptLogLevel, fptCheckResult, fptDoublexx, fptPChar,
    fptPCANSignal, fptSystemVar, fptPPSingle, fptPPS32, fptpBool, fptpAutomationModuleRunningState,
    fptTSTIMSignalStatus, fptpSTIMSignalStatus, fptSignalType, fptSignalCheckKind,
    fptSignalStatisticsKind, fptReplayPhase, fptSymbolMappingDirection, fptPFlexRaySignal,
    fptPFlexRay, fptPLINSignal, fptPDBProperties, fptPDBECUProperties, fptPDBFrameProperties,
    fptPDBSignalProperties, fptTReadProgressCallback
  );
  TMPCANSignal = packed record
    FCANSgnType: u8; // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
	  FIsIntel: Boolean;
	  FStartBit: s32;
	  FLength: s32;
	  FFactor: Double;
	  FOffset: Double;
  end;
  PMPCANSignal = ^TMPCANSignal;
  // mp lin signal
  TMPLINSignal = packed record
    FLINSgnType: u8; // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
	  FIsIntel: Boolean;
	  FStartBit: s32;
	  FLength: s32;
	  FFactor: Double;
	  FOffset: Double;
  end;
  PMPLINSignal = ^TMPLINSignal;
  TMPFlexRaySignal = packed record
    FFRSgnType: u8;    // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
    FCompuMethod: u8;  // 0 - Identical, 1 - Linear, 2 - Scale Linear, 3 - TextTable, 4 - TABNoIntp, 5 - Formula
    FReserved: u8;
	  FIsIntel: Boolean;
	  FStartBit: s32;
    FUpdateBit: s32;
	  FLength: s32;
	  FFactor: Double;
	  FOffset: Double;
  end;
  PMPFlexRaySignal = ^TMPFlexRaySignal;

  // TMPDBProperties for database properties, size = 1048
  TMPDBProperties = packed record
    FDBIndex: s32;
    FSignalCount: s32;
    FFrameCount: s32;
    FECUCount: s32;
    FSupportedChannelMask: u64;
    FName: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FComment: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
  end;
  PMPDBProperties = ^TMPDBProperties;
  // TMPDBECUProperties for database ECU properties, size = 1040
  TMPDBECUProperties = packed record
    FDBIndex: s32;
    FECUIndex: s32;
    FTxFrameCount: s32;
    FRxFrameCount: s32;
    FName: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FComment: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
  end;
  PMPDBECUProperties = ^TMPDBECUProperties;
  // TMPDBFrameProperties for database Frame properties, size = 1088
  TMPDBFrameProperties = packed record
    FDBIndex: s32;
    FECUIndex: s32;
    FFrameIndex: s32;
    FIsTx: u8;
    FReserved1: u8;
    FReserved2: u8;
    FReserved3: u8;
    FFrameType: TSignalType;
    // CAN
    FCANIsDataFrame: u8;
    FCANIsStdFrame: u8;
    FCANIsEdl: u8;
    FCANIsBrs: u8;
    FCANIdentifier: s32;
    FCANDLC: s32;
    FCANDataBytes: s32;
    // LIN
    FLINIdentifier: s32;
    FLINDLC: s32;
    // FlexRay
    FFRChannelMask: u8;
    FFRBaseCycle: u8;
    FFRCycleRepetition: u8;
    FFRIsStartupFrame: u8;
    FFRSlotId: u16;
    FFRReserved: u16;
    FFRCycleMask: u64;
    FSignalCount: s32;
    FName: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FComment: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
  end;
  PMPDBFrameProperties = ^TMPDBFrameProperties;
  // TMPDBSignalProperties for database signal properties, size = 1140
  TMPDBSignalProperties = packed record
    FDBIndex: s32;
    FECUIndex: s32;
    FFrameIndex: s32;
    FSignalIndex: s32;
    FIsTx: u8;
    FReserved1: u8;
    FReserved2: u8;
    FReserved3: u8;
    FSignalType: TSignalType;
    FCANSignal: TMPCANSignal;
    FLINSignal: TMPLINSignal;
    FFlexRaySignal: TMPFlexRaySignal;
    FInitValue: double;
    FName: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FComment: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
  end;
  PMPDBSignalProperties = ^TMPDBSignalProperties;

// TSMiniProgram C type definition =======================================================
  // generic defintions in header
  TMPProcedure = procedure (const AObj: Pointer); stdcall;
  TMPProcedureSetInt = procedure (const AObj: Pointer; const AValue: s32); stdcall;
  TMPIntFunction = function(const AObj: Pointer): s32; stdcall;
  TMPProcedureSetDouble = procedure (const AObj: Pointer; const AValue: Double); stdcall;
  TMPDoubleFunction = function(const AObj: Pointer): Double; stdcall;
  TMPProcedureSetString = procedure(const AObj: Pointer; const AValue: PAnsiChar); stdcall;
  TMPStringFunction = function(const AObj: Pointer): PAnsiChar; stdcall;
  TMPProcedureSetCAN = procedure(const AObj: Pointer; const AValue: plibcan); stdcall;
  TMPCANFunction = function(const AObj: Pointer): tlibcan; stdcall;
  TMPProcedureSetCANFD = procedure (const AObj: Pointer; const AValue: plibcanfd); stdcall;
  TMPCANFDFunction = function(const AObj: Pointer): tlibcanfd; stdcall;
  TMPProcedureSetLIN = procedure (const AObj: Pointer; const AValue: pliblin); stdcall;
  TMPLINFunction = function(const AObj: Pointer): tliblin; stdcall;
  // application management
  TTSAppSetCurrentApplication = function (const AAppName: PAnsiChar): integer; stdcall;
  TTSAppGetCurrentApplication = function (const AAppName: pPAnsiChar): integer; stdcall;
  TTSAppDelApplication = function (const AAppName: PAnsiChar): integer; stdcall;
  TTSAppAddApplication = function (const AAppName: PAnsiChar): integer; stdcall;
  TTSAppGetApplicationList = function (const AAppNameList: PPAnsiChar): integer; stdcall;
  TTSAppSetCANChannelCount = function (const ACount: Integer): integer; stdcall;
  TTSAppSetLINChannelCount = function (const ACount: Integer): integer; stdcall;
  TTSAppGetCANChannelCount = function (out ACount: Integer): integer; stdcall;
  TTSAppGetLINChannelCount = function (out ACount: Integer): integer; stdcall;
  TTSAppSetMapping = function (const AMapping: PLIBTSMapping): integer; stdcall;
  TTSAppGetMapping = function (const AMapping: PLIBTSMapping): integer; stdcall;
  TTSAppDeleteMapping = function (const AMapping: PLIBTSMapping): integer; stdcall;
  TTSAppConnectApplication = function: integer; stdcall;
  TTSAppDisconnectApplication = function: integer; stdcall;
  TTSAppLogger = function(const AStr: pansichar; const ALevel: Integer): integer; stdcall;
  TTSSetTurboMode = function (const AEnable: Boolean): integer; stdcall;
  TTSGetTurboMode = function (out AEnable: Boolean): integer; stdcall;
  TTSGetErrorDescription = function (const ACode: Integer; ADesc: PPAnsiChar): Integer; stdcall;
  TTSTerminate = function (const AObj: Pointer): integer; stdcall;
  TTSWait = function(const AObj: Pointer; const ATimeMs: s32; const AMsg: PAnsiChar): s32; stdcall;
  TTSCheckError = function(const AObj: Pointer; const AErrorCode: s32): s32; stdcall;
  TTSStartLog = function(const AObj: Pointer): s32; stdcall;
  TTSEndLog = function(const AObj: Pointer): s32; stdcall;
  TTSCheckTerminate = function(const AObj: Pointer): s32; stdcall;
  TTSGetTimestampUs = function(ATimeUs: ps64): s32; stdcall;
  TTSShowConfirmDialog = function(const ATitle: PAnsiChar; const APrompt: pansichar; const AImage: PAnsiChar; const ATimeoutMs: s32; const ADefaultOK: Boolean): s32; stdcall;
  TTSPause = function: s32; stdcall;
  TTSSetCheckFailedTerminate = function(const AObj: Pointer; const AToTerminate: Boolean): s32; stdcall;
  TTSAppSplitString = function(const ASplitter: pansichar; const AStr: pansichar; const AArray: ppansichar; const ASingleStrSize: s32; const AArraySize: s32; out AActualCount: s32): s32; stdcall;
  TTSAppGetSystemVarCount = function(AInternalCount: ps32; AUserCount: ps32): s32; stdcall;
  TTSAppGetSystemVarDefByIndex = function(const AIsUser: boolean; const AIndex: s32; const AVarDef: PLIBSystemVarDef): s32; stdcall;
  TTSAppFindSystemVarDefByName = function(const AIsUser: boolean; const ACompleteName: PAnsiChar; const AVarDef: PLIBSystemVarDef): s32; stdcall;
  TTSAppGetSystemVarDouble = function(const ACompleteName: PAnsiChar; AValue: PDouble): s32; stdcall;
  TTSAppGetSystemVarInt32 = function(const ACompleteName: PAnsiChar; AValue: ps32): s32; stdcall;
  TTSAppGetSystemVarUInt32 = function(const ACompleteName: PAnsiChar; AValue: pu32): s32; stdcall;
  TTSAppGetSystemVarInt64 = function(const ACompleteName: PAnsiChar; AValue: ps64): s32; stdcall;
  TTSAppGetSystemVarUInt64 = function(const ACompleteName: PAnsiChar; AValue: pu64): s32; stdcall;
  TTSAppGetSystemVarUInt8Array = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AVarCount: ps32; AValue: pu8): s32; stdcall;
  TTSAppGetSystemVarInt32Array = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AVarCount: ps32; AValue: ps32): s32; stdcall;
  TTSAppGetSystemVarInt64Array = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AVarCount: ps32; AValue: ps64): s32; stdcall;
  TTSAppGetSystemVarDoubleArray = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AVarCount: ps32; AValue: PDouble): s32; stdcall;
  TTSAppGetSystemVarString = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: PAnsiChar): s32; stdcall;
  TTSAppWaitSystemVar = function(const ACompleteName: PAnsiChar; const AValue: PAnsiChar; const ATimeoutMs: s32): s32; stdcall;
  TTSAppSetSystemVarDouble = function(const ACompleteName: PAnsiChar; const AValue: Double): s32; stdcall;
  TTSAppSetSystemVarInt32 = function(const ACompleteName: PAnsiChar; const AValue: s32): s32; stdcall;
  TTSAppSetSystemVarUInt32 = function(const ACompleteName: PAnsiChar; const AValue: u32): s32; stdcall;
  TTSAppSetSystemVarInt64 = function(const ACompleteName: PAnsiChar; const AValue: s64): s32; stdcall;
  TTSAppSetSystemVarUInt64 = function(const ACompleteName: PAnsiChar; const AValue: u64): s32; stdcall;
  TTSAppSetSystemVarUInt8Array = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: pu8): s32; stdcall;
  TTSAppSetSystemVarInt32Array = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: ps32): s32; stdcall;
  TTSAppSetSystemVarInt64Array = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: ps64): s32; stdcall;
  TTSAppSetSystemVarDoubleArray = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: PDouble): s32; stdcall;
  TTSAppSetSystemVarString = function(const ACompleteName: PAnsiChar; AValue: PAnsiChar): s32; stdcall;
  TTSAppWaitSystemVarExistance = function(const ACompleteName: pansichar; const ATimeoutMs: s32): s32; stdcall;
  TTSAppWaitSystemVarDisappear = function(const ACompleteName: pansichar; const ATimeoutMs: s32): s32; stdcall;
  TTSAppMakeToast = function(const AString: PAnsiChar; const ALevel: Integer): s32; stdcall;
  TTSAppExecutePythonString = function(const AString: PAnsiChar; const AArguments: pansichar;const ASync: boolean; const AIsX64: Boolean; AResultLog: PPAnsiChar): s32; stdcall;
  TTSAppExecutePythonScript = function(const AFilePath: PAnsiChar; const AArguments: pansichar;const ASync: boolean; const AIsX64: Boolean; AResultLog: PPAnsiChar): s32; stdcall;
  TTSAppExecuteApp = function(const AAppPath: pansichar; const AWorkingDir: pansichar; const AParameter: pansichar; const AWaitTimeMS: s32): s32; stdcall;
  TTSAppTerminateAppByName = function(const AImageName: pansichar): s32; stdcall;
  TTSAppLogSystemVar = function(const ACompleteName: PAnsiChar): s32; stdcall;
  TTSAppCallMPAPI = function(const ALibName: PAnsiChar; const AFuncName: PAnsiChar; const AInParameters: PAnsiChar; const AOutParameters: PPAnsiChar): s32; stdcall;
  TTSAppSetAnalysisTimeRange = function(const ATimeStartUs: s64; const ATimeEndUs: s64): s32; stdcall;
  TTSAppGetConfigurationFileName = function(AFileName: PPAnsiChar): s32; stdcall;
  TTSAppGetConfigurationFilePath = function(AFilePath: PPAnsiChar): s32; stdcall;
  TTSAppSetDefaultOutputDir = function(const APath: PAnsiChar): s32; stdcall;
  TTSAppSaveScreenshot = function(const AFormCaption, AFilePath: PAnsiChar): s32; stdcall;
  TTSAppEnableGraphics = function(const AEnableAll: boolean; const AExceptCaption: PAnsiChar): s32; stdcall;
  TTSAppGetTSMasterVersion = function(const AYear: ps32; const AMonth: ps32; const ADay: ps32; const ABuildNumber: ps32): s32; stdcall;
  TUIShowPageByIndex = function(const AIndex: s32): s32; stdcall;
  TUIShowPageByName = function(const AName: PAnsiChar): s32; stdcall;
  TWriteRealtimeComment = function(const AStr: PAnsiChar): s32; stdcall;
  TTSAppSetThreadPriority = function(const AObj: Pointer; const AIndex: s32): s32; stdcall;
  TTSAppGetSystemVarGeneric = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: PAnsiChar): s32; stdcall;
  TTSAppSetSystemVarGeneric = function(const ACompleteName: PAnsiChar; const AValue: PAnsiChar): s32; stdcall;
  TTSAppForceDirectory = function(const ADir: PAnsiChar): s32; stdcall;
  TTSAppDirectoryExists = function(const ADir: PAnsiChar): s32; stdcall;
  TTSAppOpenDirectoryAndSelectFile = function(const AFileName: PAnsiChar): s32; stdcall;
  TTSAppMiniDelayCPU = function(): s32; stdcall;
  TPromptUserInputValue = function(const APrompt: PAnsiChar; AValue: PDouble): s32; stdcall;
  TPromptUserInputString = function(const APrompt: PAnsiChar; AValue: PAnsiChar; const ACapacity: s32): s32; stdcall;
  TTSAppCreateSystemVar = function(const ACompleteName: PAnsiChar; const AType: TLIBSystemVarType; const ADefaultValue: PAnsiChar; const AComment: PAnsiChar): s32; stdcall;
  TTSAppDeleteSystemVar = function(const ACompleteName: PAnsiChar): s32; stdcall;
  TTSAppRunForm = function(const AFormCaption: PAnsiChar): s32; stdcall;
  TTSAppStopForm = function(const AFormCaption: PAnsiChar): s32; stdcall;
  TTSAppClearMeasurementForm = function(const AFormCaption: PAnsiChar): s32; stdcall;
  // text file
  TWriteTextFileStart = function(const AFileName: PAnsiChar; AHandle: ps32): s32; stdcall;
  TWriteTextFileLine = function(const AHandle: s32; const ALine: PAnsiChar): s32; stdcall;
  TWriteTextFileLineWithDoubleArray = function(const AHandle: s32; const AArray: PDouble; const ACount: s32): s32; stdcall;
  TWriteTextFileLineWithStringArray = function(const AHandle: s32; const AArray: PPAnsiChar; const ACount: s32): s32; stdcall;
  TWriteTextFileEnd = function(const AHandle: s32): s32; stdcall;
  TReadTextFileStart = function(const AFileName: pansichar; AHandle: ps32): s32; stdcall;
  TReadTextFileLine = function(const AHandle: s32; const ACapacity: s32; AReadCharCount: ps32; ALine: pansichar): s32; stdcall;
  TReadTextFileEnd = function(const AHandle: s32): s32; stdcall;
  // excel functions
  Texcel_load = function(const AFileName: PAnsiChar; const AObj: PPointer): s32; stdcall;
  Texcel_get_sheet_count = function(const AObj: Pointer; out ACount: s32): s32; stdcall;
  Texcel_set_sheet_count = function(const AObj: Pointer; const ACount: s32): s32; stdcall;
  Texcel_get_sheet_name = function(const AObj: Pointer; const AIdxSheet: Integer; const AName: PPAnsiChar): s32; stdcall;
  Texcel_set_sheet_name = function(const AObj: Pointer; const AIdxSheet: Integer; const AName: PAnsiChar): s32; stdcall;
  Texcel_get_cell_count = function(const AObj: Pointer; const AIdxSheet: Integer; out ARowCount: integer; out AColCount: Integer): s32; stdcall;
  Texcel_get_cell_value = function(const AObj: Pointer; const AIdxSheet: Integer; const AIdxRow: integer; const AIdxCol: Integer; const AValue: PPAnsiChar): s32; stdcall;
  Texcel_set_cell_count = function(const AObj: Pointer; const AIdxSheet: integer; const ARowCount: integer; const AColCount: integer): s32; stdcall;
  Texcel_set_cell_value = function(const AObj: Pointer; const AIdxSheet: Integer; const AIdxRow: integer; const AIdxCol: Integer; const AValue: PAnsiChar): s32; stdcall;
  Texcel_unload = function(const AObj: Pointer): s32; stdcall;
  Texcel_unload_all = function(): s32; stdcall;
  // mat file
  TWriteMatFileStart = function(const AFileName: PAnsiChar; AHandle: ps32): s32; stdcall;
  TWriteMatFileVariableDouble = function(const AHandle: s32; const AVarName: PAnsiChar; const AValue: Double): s32; stdcall;
  TWriteMatFileVariableString = function(const AHandle: s32; const AVarName: PAnsiChar; const AValue: PAnsiChar): s32; stdcall;
  TWriteMatFileVariableDoubleArray = function(const AHandle: s32; const AVarName: PAnsiChar; const AArray: PDouble; const ACount: s32): s32; stdcall;
  TWriteMatFileEnd = function(const AHandle: s32): s32; stdcall;
  TReadMatFileStart = function(const AFileName: PAnsiChar; AHandle: ps32): s32; stdcall;
  TReadMatFileVariableCount = function(const AHandle: s32; const AVarName: PAnsiChar; ACount: ps32): s32; stdcall;
  TReadMatFileVariableString = function(const AHandle: s32; const AVarName: PAnsiChar; AValue: PPAnsiChar; const ACapacity: s32): s32; stdcall;
  TReadMatFileVariableDouble = function(const AHandle: s32; const AVarName: PAnsiChar; const AValue: PDouble; const AStartIdx: s32; const ACount: s32): s32; stdcall;
  TReadMatFileEnd = function(const AHandle: s32): s32; stdcall;
  // ini file
  TIniCreate = function(const AFileName: PAnsiChar; AHandle: ps32): s32; stdcall;
  TIniWriteInt32 = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: s32): s32; stdcall;
  TIniWriteInt64 = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: s64): s32; stdcall;
  TIniWriteBool = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: Boolean): s32; stdcall;
  TIniWriteFloat = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: Double): s32; stdcall;
  TIniWriteString = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: PAnsiChar): s32; stdcall;
  TIniReadInt32 = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: ps32; const ADefault: s32): s32; stdcall;
  TIniReadInt64 = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: ps64; const ADefault: s64): s32; stdcall;
  TIniReadBool = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: PBoolean; const ADefault: boolean): s32; stdcall;
  TIniReadFloat = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: PDouble; const ADefault: double): s32; stdcall;
  TIniReadString = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: PAnsiChar; ACapacity: ps32; const ADefault: pansichar): s32; stdcall;
  TIniSectionExists = function(const AHandle: s32; const ASection: PAnsiChar): s32; stdcall;
  TIniKeyExists = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar): s32; stdcall;
  TIniDeleteKey = function(const AHandle: s32; const ASection: PAnsiChar; const AKey: PAnsiChar): s32; stdcall;
  TIniDeleteSection = function(const AHandle: s32; const ASection: PAnsiChar): s32; stdcall;
  TIniClose = function(const AHandle: s32): s32; stdcall;
  TMakeToastUntil = function(const AString: PAnsiChar; const ALevel: Integer; const ACloseCriteria: pboolean; const AUserCanBreak: boolean): s32; stdcall;
  TMakeToastWithCallback = function(const AString: PAnsiChar; const ALevel: Integer; const ACallback: TLIBCheckResult; const AUserCanBreak: boolean): s32; stdcall;
  TTSAppGetDocPath = function(AFilePath: PPAnsiChar): s32; stdcall;
  TTSAppGetHWIDString = function(AString: PPAnsiChar): s32; stdcall;
  TTSAppGetHWIDArray = function(AArray8B: pu8): s32; stdcall;
  TPlaySound = function(const AIsSync: boolean; const AWaveFileName: pansichar): s32; stdcall;
  TTSAppSetSystemVarUnit = function(const ACompleteName: pansichar; const AUnit: pansichar): s32; stdcall;
  TTSAppSetSystemVarValueTable = function(const ACompleteName: pansichar; const ATable: pansichar): s32; stdcall;
  TTSAppLoadPlugin = function(const APluginName: PAnsiChar): s32; stdcall;
  TTSAppUnloadPlugin = function(const APluginName: PAnsiChar): s32; stdcall;
  TTSAppSetSystemVarDoubleAsync = function(const ACompleteName: PAnsiChar; const AValue: Double): s32; stdcall;
  TTSAppSetSystemVarInt32Async = function(const ACompleteName: PAnsiChar; const AValue: s32): s32; stdcall;
  TTSAppSetSystemVarUInt32Async = function(const ACompleteName: PAnsiChar; const AValue: u32): s32; stdcall;
  TTSAppSetSystemVarInt64Async = function(const ACompleteName: PAnsiChar; const AValue: s64): s32; stdcall;
  TTSAppSetSystemVarUInt64Async = function(const ACompleteName: PAnsiChar; const AValue: u64): s32; stdcall;
  TTSAppSetSystemVarUInt8ArrayAsync = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: pu8): s32; stdcall;
  TTSAppSetSystemVarInt32ArrayAsync = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: ps32): s32; stdcall;
  TTSAppSetSystemVarInt64ArrayAsync = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: ps64): s32; stdcall;
  TTSAppSetSystemVarDoubleArrayAsync = function(const ACompleteName: PAnsiChar; const ACapacity: s32; AValue: PDouble): s32; stdcall;
  TTSAppSetSystemVarStringAsync = function(const ACompleteName: PAnsiChar; AValue: PAnsiChar): s32; stdcall;
  TTSAppSetSystemVarGenericAsync = function(const ACompleteName: PAnsiChar; const AValue: PAnsiChar): s32; stdcall;
  // Graphic Program apis
  TAMGetRunningState = function(const AModuleName: pansichar; AState: PLIBAutomationModuleRunningState; ASubModuleName: ppansichar; ACurrentParameterGroupName: ppansichar): s32; stdcall;
  TAMRun = function(const AModuleName: pansichar; const ASubModuleName: pansichar; const AParameterGroupName: pansichar; const AIsSync: boolean): s32; stdcall;
  TAMStop = function(const AModuleName: pansichar; const AIsSync: boolean): s32; stdcall;
  TAMSelectSubModule = function(const AIsSelect: boolean; const AModuleName: pansichar; const ASubModuleName: pansichar; const AParameterGroupName: pansichar): s32; stdcall;
  // panel set apis
  TPanelSetEnable = function(const APanelName: pansichar; const AControlName: pansichar; const AEnable: boolean): s32; stdcall;
  TPanelSetPositionX = function(const APanelName: pansichar; const AControlName: pansichar; const AX: single): s32; stdcall;
  TPanelSetPositionY = function(const APanelName: pansichar; const AControlName: pansichar; const AY: single): s32; stdcall;
  TPanelSetPositionXY = function(const APanelName: pansichar; const AControlName: pansichar; const AX: single; const AY: single): s32; stdcall;
  TPanelSetOpacity = function(const APanelName: pansichar; const AControlName: pansichar; const AOpacity: single): s32; stdcall;
  TPanelSetWidth = function(const APanelName: pansichar; const AControlName: pansichar; const AWidth: single): s32; stdcall;
  TPanelSetHeight = function(const APanelName: pansichar; const AControlName: pansichar; const AHeight: single): s32; stdcall;
  TPanelSetWidthHeight = function(const APanelName: pansichar; const AControlName: pansichar; const AWidth: single; const AHeight: single): s32; stdcall;
  TPanelSetRotationAngle = function(const APanelName: pansichar; const AControlName: pansichar; const AAngleDegree: single): s32; stdcall;
  TPanelSetRotationCenter = function(const APanelName: pansichar; const AControlName: pansichar; const ARatioX: single; const ARatioY: single): s32; stdcall;
  TPanelSetScaleX = function(const APanelName: pansichar; const AControlName: pansichar; const AScaleX: single): s32; stdcall;
  TPanelSetScaleY = function(const APanelName: pansichar; const AControlName: pansichar; const AScaleY: single): s32; stdcall;
  TPanelSetBkgdColor = function(const APanelName: pansichar; const AControlName: pansichar; const AAlphaColor: u32): s32; stdcall;
  TPanelSetSelectorItems = function(const APanelName: pansichar; const AControlName: pansichar; const AItems: pansichar): s32; stdcall;
  TPanelGetSelectorItems = function(const APanelName: pansichar; const AControlName: pansichar; AItems: pPansichar): s32; stdcall;
  // panel get apis
  TPanelGetEnable = function(const APanelName: pansichar; const AControlName: pansichar; var AEnable: boolean): s32; stdcall;
  TPanelGetPositionXY = function(const APanelName: pansichar; const AControlName: pansichar; var Ax: single; var Ay: single): s32; stdcall;
  TPanelGetOpacity = function(const APanelName: pansichar; const AControlName: pansichar; var AOpacity: single): s32; stdcall;
  TPanelGetWidthHeight = function(const APanelName: pansichar; const AControlName: pansichar; var AWidth: single; var AHeight: single): s32; stdcall;
  TPanelGetRotationAngle = function(const APanelName: pansichar; const AControlName: pansichar; var AAngleDegree: single): s32; stdcall;
  TPanelGetRotationCenter = function(const APanelName: pansichar; const AControlName: pansichar; var ARatioX: single; var ARatioY: single): s32; stdcall;
  TPanelGetScaleXY = function(const APanelName: pansichar; const AControlName: pansichar; var AScaleX: single; var AScaleY: single): s32; stdcall;
  TPanelGetBkgdColor = function(const APanelName: pansichar; const AControlName: pansichar; var AAlphaColor: u32): s32; stdcall;
  // stim
  TSTIMSetSignalStatus = function(const ASTIMName: pansichar; const ASignalLabel: pansichar; const AStatus: TSTIMSignalStatus): s32; stdcall;
  TSTIMGetSignalStatus = function(const ASTIMName: pansichar; const ASignalLabel: pansichar; const AStatus: PSTIMSignalStatus): s32; stdcall;
  // 2022-09-02
  TTSAppGetSystemVarAddress = function(const ACompleteName: pansichar; AAddress: ps32): s32; stdcall;
  TTSAppSetSystemVarLogging = function(const ACompleteName: pansichar; const AIsLogging: boolean): s32; stdcall;
  TTSAppGetSystemVarLogging = function(const ACompleteName: pansichar; AIsLogging: pbool): s32; stdcall;
  TTSAppLogSystemVarValue = function(const AObj: pointer; const ACompleteName: pansichar): s32; stdcall;
  TUIGetMainWindowHandle = function(AHandle: ps32): s32; stdcall;
  TPrintDeltaTime = function(const AInfo: pansichar): s32; stdcall;
  TAtomicIncrement32 = function(const AAddr: ps32; const AValue: s32; const AResult: ps32): s32; stdcall;
  TAtomicIncrement64 = function(const AAddr: ps64; const AValue: s64; const AResult: ps64): s32; stdcall;
  TAtomicSet32 = function(const AAddr: ps32; const AValue: s32): s32; stdcall;
  TAtomicSet64 = function(const AAddr: ps64; const AValue: s64): s32; stdcall;
  // 2022-09-09
  TGetConstantDouble = function(const AName: pansichar; var AValue: double): s32; stdcall;
  // 2022-09-16
  TAddDirectMappingCAN = function(const ADestinationVarName: pansichar; const ASignalAddress: pansichar; const ADirection: TSymbolMappingDirection): s32; stdcall;
  TAddExpressionMapping = function(const ADestinationVarName: pansichar; const AExpression: pansichar; const AArguments: pansichar): s32; stdcall;
  TDeleteSymbolMappingItem = function(const ADestinationVarName: pansichar): s32; stdcall;
  TEnableSymbolMappingItem = function(const ADestinationVarName: pansichar; const AEnable: boolean): s32; stdcall;
  TEnableSymbolMappingEngine = function(const AEnable: boolean): s32; stdcall;
  // 2022-09-17
  TDeleteSymbolMappingItems = function(): s32; stdcall;
  TSaveSymbolMappingSettings = function(const AFileName: pansichar): s32; stdcall;
  TLoadSymbolMappingSettings = function(const AFileName: pansichar): s32; stdcall;
  // 2022-09-18
  TAddDirectMappingWithFactorOffsetCAN = function(const ADestinationVarName: pansichar; const ASignalAddress: pansichar; const ADirection: TSymbolMappingDirection; const AFactor: double; const AOffset: double): s32; stdcall;
  // 2022-09-29
  TTSAppDebugLog = function(const AObj: Pointer; const AFile: pansichar; const AFunc: pansichar; const ALine: s32; const AStr: pansichar; const ALevel: Integer): integer; stdcall;
  // 2022-10-26
  TTSWaitWithDialog = function(const AObj: Pointer; const ATitle: pansichar; const AMessage: pansichar; const ApResult: pboolean; const ApProgress100: psingle): s32; stdcall;
  // 2022-11-16
  TTSAppIsConnected = function: s32; stdcall;
  // 2022-11-17
  TTSAppGetFlexRayChannelCount = function(out ACount: Integer): s32; stdcall;
  TTSAppSetFlexRayChannelCount = function(const ACount: Integer): s32; stdcall;
  // 2022-12-03 database apis
  TDBGetCANDBCount = function(out ACount: s32): s32; stdcall;
  TDBGetLINDBCount = function(out ACount: s32): s32; stdcall;
  TDBGetFlexRayDBCount = function(out ACount: s32): s32; stdcall;
  TDBGetCANDBPropertiesByIndex = function(const AValue: PMPDBProperties): s32; stdcall;
  TDBGetLINDBPropertiesByIndex = function(const AValue: PMPDBProperties): s32; stdcall;
  TDBGetFlexRayDBPropertiesByIndex = function(const AValue: PMPDBProperties): s32; stdcall;
  TDBGetCANDBECUPropertiesByIndex = function(const AValue: PMPDBECUProperties): s32; stdcall;
  TDBGetLINDBECUPropertiesByIndex = function(const AValue: PMPDBECUProperties): s32; stdcall;
  TDBGetFlexRayDBECUPropertiesByIndex = function(const AValue: PMPDBECUProperties): s32; stdcall;
  TDBGetCANDBFramePropertiesByIndex = function(const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetLINDBFramePropertiesByIndex = function(const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetFlexRayDBFramePropertiesByIndex = function(const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetCANDBSignalPropertiesByIndex = function(const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetLINDBSignalPropertiesByIndex = function(const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetFlexRayDBSignalPropertiesByIndex = function(const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetCANDBPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBProperties): s32; stdcall;
  TDBGetLINDBPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBProperties): s32; stdcall;
  TDBGetFlexRayDBPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBProperties): s32; stdcall;
  TDBGetCANDBECUPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBECUProperties): s32; stdcall;
  TDBGetLINDBECUPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBECUProperties): s32; stdcall;
  TDBGetFlexRayDBECUPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBECUProperties): s32; stdcall;
  TDBGetCANDBFramePropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetLINDBFramePropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetFlexRayDBFramePropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetCANDBSignalPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetLINDBSignalPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetFlexRayDBSignalPropertiesByAddress = function(const AAddr: pansichar; const AValue: PMPDBSignalProperties): s32; stdcall;
  TRunPythonFunction = function(const AObj: Pointer; const AModuleName: pansichar; const AFunctionName: pansichar; const AArgFormat: pansichar{...}): s32; cdecl;
  TRunPythonFunctionInDelphi = function(const AObj: Pointer; const AModuleName: pansichar; const AFunctionName: pansichar; const AArgFormat: pansichar; const AArgAddr: pinteger): s32; stdcall;
  TGetCurrentMpName = function(const AObj: Pointer): pansichar; stdcall;
  TGetSystemConstantCount = function(const AIdxType: s32; ACount: ps32): s32; stdcall;
  TGetSystemConstantValueByIndex = function(const AIdxType: s32; const AIdxValue: s32; AName: ppansichar; AValue: pdouble; ADesc: ppansichar): s32; stdcall;
  // 2023-03-28 database apis for direct signal and frame access in db
  TDBGetCANDBFramePropertiesByDBIndex = function(const AIdxDB: s32; const AIndex: s32; const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetLINDBFramePropertiesByDBIndex = function(const AIdxDB: s32; const AIndex: s32; const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetFlexRayDBFramePropertiesByDBIndex = function(const AIdxDB: s32; const AIndex: s32; const AValue: PMPDBFrameProperties): s32; stdcall;
  TDBGetCANDBSignalPropertiesByDBIndex = function(const AIdxDB: s32; const AIndex: s32; const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetLINDBSignalPropertiesByDBIndex = function(const AIdxDB: s32; const AIndex: s32; const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetFlexRayDBSignalPropertiesByDBIndex = function(const AIdxDB: s32; const AIndex: s32; const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetCANDBSignalPropertiesByFrameIndex = function(const AIdxDB: s32; const AIdxFrame: s32; const ASgnIndexInFrame: s32; const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetLINDBSignalPropertiesByFrameIndex = function(const AIdxDB: s32; const AIdxFrame: s32; const ASgnIndexInFrame: s32; const AValue: PMPDBSignalProperties): s32; stdcall;
  TDBGetFlexRayDBSignalPropertiesByFrameIndex = function(const AIdxDB: s32; const AIdxFrame: s32; const ASgnIndexInFrame: s32; const AValue: PMPDBSignalProperties): s32; stdcall;
  TAddSystemConstant = function(const AName: PAnsiChar; const AValue: double; const ADesc: pansichar): s32; stdcall;
  TDeleteSystemConstant = function(const AName: PAnsiChar): s32; stdcall;
  TDBGetFlexRayClusterParameters = function(const AIdxChn: integer; const AClusterName: PAnsiChar; AValue: PLibFlexRayClusterParameters): s32; stdcall;
  TDBGetFlexRayControllerParameters = function(const AIdxChn: integer; const AClusterName: PAnsiChar; const AECUName: PAnsiChar; AValue: PLibFlexRayControllerParameters): s32; stdcall;
  TSetSystemVarEventSupport = function(const ACompleteName: PAnsiChar; const ASupport: boolean): s32; stdcall;
  TGetSystemVarEventSupport = function(const ACompleteName: PAnsiChar; ASupport: PBoolean): s32; stdcall;
  TGetDateTime = function(AYear: pInt32; AMonth: pInt32; ADay: pInt32; AHour: pInt32; AMinute: pInt32; ASecond: pInt32; AMilliseconds: pInt32): s32; stdcall;
  TGPGDeleteAllModules = function: int32; stdcall;
  TGPGCreateModule = function(const AProgramName: PAnsichar; const ADisplayName: PAnsichar; AModuleId: pint64; AEntryPointId: pint64): s32; stdcall;
  TGPGDeleteModule = function(const AModuleId: int64): s32; stdcall;
  TGPGDeployModule = function(const AModuleId: int64; const AGraphicProgramWindowTitle: PAnsichar): s32; stdcall;
  TGPGAddActionDown = function(const AModuleId: int64; const AUpperActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; AActionId: pint64): s32; stdcall;
  TGPGAddActionRight = function(const AModuleId: int64; const ALeftActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; AActionId: pint64): s32; stdcall;
  TGPGAddGoToDown = function(const AModuleId: int64; const AUpperActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar; AActionId: pint64): s32; stdcall;
  TGPGAddGoToRight = function(const AModuleId: int64; const ALeftActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar; AActionId: pint64): s32; stdcall;
  TGPGAddFromDown = function(const AModuleId: int64; const AUpperActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar; AActionId: pint64): s32; stdcall;
  TGPGAddGroupDown = function(const AModuleId: int64; const AUpperActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; AGroupId: pint64; AEntryPointId: pint64): s32; stdcall;
  TGPGAddGroupRight = function(const AModuleId: int64; const ALeftActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; AGroupId: pint64; AEntryPointId: pint64): s32; stdcall;
  TGPGDeleteAction = function(const AModuleId: int64; const AActionId: int64): s32; stdcall;
  TGPGSetActionNOP = function(const AModuleId: int64; const AActionId: int64): s32; stdcall;
  TGPGSetActionSignalReadWrite = function(const AModuleId: int64; const AActionId: int64): s32; stdcall;
  TGPGSetActionAPICall = function(const AModuleId: int64; const AActionId: int64): s32; stdcall;
  TGPGSetActionExpression = function(const AModuleId: int64; const AActionId: int64): s32; stdcall;
  TGPGConfigureActionBasic = function(const AModuleId: int64; const AActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const ATimeoutMs: int32): s32; stdcall;
  TGPGConfigureGoTo = function(const AModuleId: int64; const AActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar): s32; stdcall;
  TGPGConfigureFrom = function(const AModuleId: int64; const AActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar): s32; stdcall;
  TGPGConfigureNOP = function(const AModuleId: int64; const AActionId: int64; const ANextDirectionIsDown: boolean; const AResultOK: boolean; const AJumpBackIfEnded: boolean): s32; stdcall;
  TGPGConfigureGroup = function(const AModuleId: int64; const AActionId: int64; const ARepeatCountType: TLIBAutomationSignalType; const ARepeatCountRepr: PAnsichar): s32; stdcall;
  TGPGConfigureSignalReadWriteListClear = function(const AModuleId: int64; const AActionId: int64): s32; stdcall;
  TGPGConfigureSignalWriteListAppend = function(const AModuleId: int64; const AActionId: int64; const ADestSignalType: TLIBAutomationSignalType; const ASrcSignalType: TLIBAutomationSignalType; const ADestSignalExpr: PAnsichar; const ASrcSignalExpr: PAnsichar; AItemIndex: pInt32): s32; stdcall;
  TGPGConfigureSignalReadListAppend = function(const AModuleId: int64; const AActionId: int64; const AIsConditionAND: boolean; const ADestSignalType: TLIBAutomationSignalType; const AMinSignalType: TLIBAutomationSignalType; const AMaxSignalType: TLIBAutomationSignalType; const ADestSignalExpr: PAnsichar; const AMinSignalExpr: PAnsichar; const AMaxSignalExpr: PAnsichar; AItemIndex: pInt32): s32; stdcall;
  TGPGConfigureAPICallArguments = function(const AModuleId: int64; const AActionId: int64; const AAPIType: TLIBMPFuncSource; const AAPIName: PAnsichar; const AAPIArgTypes: PLIBAutomationSignalType; const AAPIArgNames: PPAnsiChar; const AAPIArgExprs: PPAnsiChar; const AArraySize: int32): s32; stdcall;
  TGPGConfigureAPICallResult = function(const AModuleId: int64; const AActionId: int64; const ASignalType: TLIBAutomationSignalType; const ASignalExpr: PAnsichar): s32; stdcall;
  TGPGConfigureExpression = function(const AModuleId: int64; const AActionId: int64; const AxCount: int32; const AExpression: PAnsichar; const AArgumentTypes: PLIBAutomationSignalType; const AArgumentExprs: PPAnsiChar; const AResultType: TLIBAutomationSignalType; const AResultExpr: PAnsichar): s32; stdcall;
  TGPGAddLocalVar = function(const AModuleId: int64; const AType: TLIBSimVarType; const AName: PAnsichar; const AInitValue: PAnsichar; const AComment: PAnsichar; AItemIndex: pInt32): s32; stdcall;
  TGPGDeleteLocalVar = function(const AModuleId: int64; const AItemIndex: int32): s32; stdcall;
  TGPGDeleteAllLoalVars = function(const AModuleId: int64): s32; stdcall;
  TGPGDeleteGroupItems = function(const AModuleId: int64; const AGroupId: int64): s32; stdcall;
  TGPGConfigureSignalReadWriteListDelete = function(const AModuleId: int64; const AActionId: int64; const AItemIndex: int32): s32; stdcall;
  TGPGConfigureModule = function(const AModuleId: int64; const AProgramName: PAnsichar; const ADisplayName: PAnsichar; const ARepeatCount: int32; const ASelected: boolean): s32; stdcall;
  TUIShowWindow = function(const AWindowTitle: PAnsichar; const AIsShow: boolean): s32; stdcall;
  TUIGraphicsLoadConfiguration = function(const AWindowTitle: PAnsichar; const AConfigurationName: PAnsichar): s32; stdcall;
  TUIWatchdogEnable = function(const AEnable: boolean): s32; stdcall;
  TUIWatchdogFeed = function(): s32; stdcall;
  TAddPathToEnvironment = function(const APath: pansichar): s32; stdcall;
  TDeletePathFromEnvironment = function(const APath: pansichar): s32; stdcall;
  TTSAppSetSystemVarDoubleWTime = function(const ACompleteName: pansichar; const AValue: double; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarInt32WTime = function(const ACompleteName: pansichar; const AValue: int32; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarUInt32WTime = function(const ACompleteName: pansichar; const AValue: uint32; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarInt64WTime = function(const ACompleteName: pansichar; const AValue: int64; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarUInt64WTime = function(const ACompleteName: pansichar; const AValue: uint64; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarUInt8ArrayWTime = function(const ACompleteName: pansichar; const ACount: int32; const AValue: pbyte; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarInt32ArrayWTime = function(const ACompleteName: pansichar; const ACount: int32; const AValue: pInt32; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarDoubleArrayWTime = function(const ACompleteName: pansichar; const ACount: int32; const AValue: pdouble; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarStringWTime = function(const ACompleteName: pansichar; const AValue: pansichar; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarGenericWTime = function(const ACompleteName: pansichar; const AValue: pansichar; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarDoubleAsyncWTime = function(const ACompleteName: pansichar; const AValue: double; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarInt32AsyncWTime = function(const ACompleteName: pansichar; const AValue: int32; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarUInt32AsyncWTime = function(const ACompleteName: pansichar; const AValue: uint32; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarInt64AsyncWTime = function(const ACompleteName: pansichar; const AValue: int64; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarUInt64AsyncWTime = function(const ACompleteName: pansichar; const AValue: uint64; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarUInt8ArrayAsyncWTime = function(const ACompleteName: pansichar; const ACount: int32; const AValue: pbyte; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarInt32ArrayAsyncWTime = function(const ACompleteName: pansichar; const ACount: int32; const AValue: pInt32; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarInt64ArrayAsyncWTime = function(const ACompleteName: pansichar; const ACount: int32; const AValue: pint64; ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarDoubleArrayAsyncWTime = function(const ACompleteName: pansichar; const ACount: int32; const AValue: pdouble; const ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarStringAsyncWTime = function(const ACompleteName: pansichar; const AValue: pansichar; const ATimeUs: int64): s32; stdcall;
  TTSAppSetSystemVarGenericAsyncWTime = function(const ACompleteName: pansichar; const AValue: pansichar; const ATimeUs: int64): s32; stdcall;
  TDBGetSignalStartBitByPDUOffset = function(const ASignalStartBitInPDU: int32; const ASignalBitLength: int32; const AIsSignalIntel: boolean; const AIsPDUIntel: boolean; const APDUStartBit: int32; const APDUBitLength: int32; AActualStartBit: pInt32): s32; stdcall;
  TUIShowSaveFileDialog = function(const ATitle: pansichar; const AFileTypeDesc: pansichar; const AFilter: pansichar; const ASuggestFileName: pansichar; ADestinationFileName: PPAnsiChar): s32; stdcall;
  TUIShowOpenFileDialog = function(const ATitle: pansichar; const AFileTypeDesc: pansichar; const AFilter: pansichar; const ASuggestFileName: pansichar; ADestinationFileName: PPAnsiChar): s32; stdcall;
  TUIShowSelectDirectoryDialog = function(ADestinationDirectory: PPAnsiChar): s32; stdcall;
  TSetEthernetChannelCount = function(const ACount: int32): s32; stdcall;
  TGetEthernetChannelCount = function(ACount: pInt32): s32; stdcall;
  TDBGetCANDBIndexById = function(const AId: int32; AIndex: pInt32): s32; stdcall;
  TDBGetLINDBIndexById = function(const AId: int32; AIndex: pInt32): s32; stdcall;
  TDBGetFlexRayDBIndexById = function(const AId: int32; AIndex: pInt32): s32; stdcall;
  // TS_APP_PROTO_END (do not modify this line) ================================
  // hardware settings
  TTSConfigureBaudrateCAN = function(const AIdxChn: integer; const ABaudrateKbps: Single; const AListenOnly: boolean; const AInstallTermResistor120Ohm: Boolean): integer; stdcall;
  TTSConfigureBaudrateCANFD = function(const AIdxChn: integer; const ABaudrateKbpsArb, ABaudrateKbpsData: Single; const AControllerType: TLIBCANFDControllerType; const AControllerMode: TLIBCANFDControllerMode; const AInstallTermResistor120Ohm: Boolean): integer; stdcall;
  // communication async functions
  TTransmitCANAsync = function (const ACAN: PLIBCAN): integer; stdcall;
  TTransmitCANFDAsync = function (const ACANFD: PLIBCANFD): integer; stdcall;
  TTransmitLINAsync = function (const ALIN: PLIBLIN): integer; stdcall;
  TTransmitFastLINAsync = function (const ALIN: PLIBLIN): integer; stdcall;
  TInjectCANMessage = function (const ACANFD: PLIBCANFD): integer; stdcall;
  TInjectLINMessage = function (const ALIN: PLIBLIN): integer; stdcall;
  // database functions
  TMPGetCANSignalValue = function(const ASignal: PMPCANSignal; const AData: pu8): double; stdcall;
  TMPSetCANSignalValue = procedure(const ASignal: PMPCANSignal; const AData: pu8; const AValue: Double); stdcall;
  TMPGetLINSignalValue = function(const ASignal: PMPLINSignal; const AData: pu8): double; stdcall;
  TMPSetLINSignalValue = procedure(const ASignal: PMPLINSignal; const AData: pu8; const AValue: Double); stdcall;
  TGetCANSignalDefinitionVerbose = function(const AIdxChn: integer; const ANetworkName: pansichar; const AMsgName: pansichar; const ASignalName: pansichar; AMsgIdentifier: pinteger; ASignalDef: PMPCANSignal): integer; stdcall;
  TGetCANSignalDefinition = function(const ASignalAddress: pansichar; AMsgIdentifier: pinteger; ASignalDef: PMPCANSignal): integer; stdcall;
  // communication sync functions
  TTransmitCANSync = function (const ACAN: PLIBCAN; const ATimeoutMS: Integer): integer; stdcall;
  TTransmitCANFDSync = function (const ACANFD: PLIBCANFD; const ATimeoutMS: Integer): integer; stdcall;
  TTransmitLINSync = function (const ALIN: PLIBLIN; const ATimeoutMS: Integer): integer; stdcall;
  // bus functions
  TWaitCANMessage = function (const AObj: Pointer; const ATxCAN: PLIBCAN; const ARxCAN: PLIBCAN; const ATimeoutMS: s32): integer; stdcall;
  TWaitCANFDMessage = function (const AObj: Pointer; const ATxCANFD: PLIBCANFD; const ARxCANFD: PLIBCANFD; const ATimeoutMS: s32): integer; stdcall;
  // periodic
  TAddCyclicMsgCAN = function (const ACAN: PLIBCAN; const APeriodMS: Single): integer; stdcall;
  TAddCyclicMsgCANFD = function (const ACANFD: PLIBCANFD; const APeriodMS: Single): integer; stdcall;
  TDeleteCyclicMsgCAN = function (const ACAN: PLIBCAN): integer; stdcall;
  TDeleteCyclicMsgCANFD = function (const ACANFD: PLIBCANfd): integer; stdcall;
  TDeleteCyclicMsgs = function : Integer; stdcall;
  Tadd_precise_cyclic_message = function (const AIdentifier:integer; const AChn:byte; const AIsExt:byte; const APeriodMS: Single; const ATimeoutMS:Integer): Integer; stdcall;
  Tdelete_precise_cyclic_message = function (const AIdentifier:integer; const AChn:byte; const AIsExt:byte; const ATimeoutMS:Integer): Integer; stdcall;
  // bus statistics
  TEnableBusStatistics = function (const AEnable: Boolean): Integer; stdcall;
  TClearBusStatistics = function: Integer; stdcall;
  TGetBusStatistics = function (const ABusType: TLIBApplicationChannelType; const AIdxChn: Integer; const AIdxStat: TLIBCANBusStatistics; out AStat: double): Integer; stdcall;
  TGetFPSCAN = function (const AIdxChn: Integer; const AIdentifier: Integer; out AFPS: Integer): Integer; stdcall;
  TGetFPSCANFD = function (const AIdxChn: Integer; const AIdentifier: Integer; out AFPS: Integer): Integer; stdcall;
  TGetFPSLIN = function (const AIdxChn: Integer; const AIdentifier: Integer; out AFPS: Integer): Integer; stdcall;
  // bus callback handler
  TRegisterCANEvent = function (const AObj: pointer; const AEvent: TCANQueueEvent_Win32): integer; stdcall;
  TUnregisterCANEvent = function (const AObj: pointer; const AEvent: TCANQueueEvent_Win32): integer; stdcall;
  TRegisterCANFDEvent = function (const AObj: pointer; const AEvent: TCANfdQueueEvent_Win32): integer; stdcall;
  TUnregisterCANFDEvent = function (const AObj: pointer; const AEvent: TCANfdQueueEvent_Win32): integer; stdcall;
  TRegisterLINEvent = function (const AObj: pointer; const AEvent: TliNQueueEvent_Win32): integer; stdcall;
  TUnregisterLINEvent = function (const AObj: pointer; const AEvent: TliNQueueEvent_Win32): integer; stdcall;
  TUnregisterCANEvents = function (const AObj: pointer): integer; stdcall;
  TUnregisterLINEvents = function (const AObj: pointer): integer; stdcall;
  TUnregisterCANFDEvents = function (const AObj: pointer): integer; stdcall;
  TUnregisterALLEvents = function (const AObj: pointer): integer; stdcall;
  // bus pre-tx callback handler
  TRegisterPreTxCANEvent = function (const AObj: pointer; const AEvent: TCANQueueEvent_Win32): integer; stdcall;
  TUnregisterPreTxCANEvent = function (const AObj: pointer; const AEvent: TCANQueueEvent_Win32): integer; stdcall;
  TRegisterPreTxCANFDEvent = function (const AObj: pointer; const AEvent: TCANfdQueueEvent_Win32): integer; stdcall;
  TUnregisterPreTxCANFDEvent = function (const AObj: pointer; const AEvent: TCANfdQueueEvent_Win32): integer; stdcall;
  TRegisterPreTxLINEvent = function (const AObj: pointer; const AEvent: TliNQueueEvent_Win32): integer; stdcall;
  TUnregisterPreTxLINEvent = function (const AObj: pointer; const AEvent: TliNQueueEvent_Win32): integer; stdcall;
  TUnregisterPreTxCANEvents = function (const AObj: pointer): integer; stdcall;
  TUnregisterPreTxLINEvents = function (const AObj: pointer): integer; stdcall;
  TUnregisterPreTxCANFDEvents = function (const AObj: pointer): integer; stdcall;
  TUnregisterPreTxALLEvents = function (const AObj: pointer): integer; stdcall;
  // online replay
  Ttslog_add_online_replay_config = function (const AFileName: PAnsiChar; out AIndex: s32): integer; stdcall;
  Ttslog_set_online_replay_config = function (const AIndex: s32; const AName: PAnsiChar; const AFileName: PAnsiChar; const AAutoStart: Boolean; const AIsRepetitiveMode: boolean; const AStartTimingMode: TLIBOnlineReplayTimingMode; const AStartDelayTimeMs: s32; const ASendTx: boolean; const ASendRx: Boolean; const AMappings: PAnsiChar): integer; stdcall;
  Ttslog_get_online_replay_count = function (out ACount: s32): integer; stdcall;
  Ttslog_get_online_replay_config = function (const AIndex: s32; AName: PPAnsiChar; AFileName: PPAnsiChar; out AAutoStart: Boolean; out AIsRepetitiveMode: boolean; out AStartTimingMode: TLIBOnlineReplayTimingMode; out AStartDelayTimeMs: s32; out ASendTx: boolean; out ASendRx: Boolean; AMappings: PPAnsiChar): integer; stdcall;
  Ttslog_del_online_replay_config = function (const AIndex: s32): integer; stdcall;
  Ttslog_del_online_replay_configs = function (): integer; stdcall;
  Ttslog_start_online_replay = function (const AIndex: s32): integer; stdcall;
  Ttslog_start_online_replays = function (): integer; stdcall;
  Ttslog_pause_online_replay = function (const AIndex: s32): integer; stdcall;
  Ttslog_pause_online_replays = function (): integer; stdcall;
  Ttslog_stop_online_replay = function (const AIndex: s32): integer; stdcall;
  Ttslog_stop_online_replays = function (): integer; stdcall;
  Ttslog_get_online_replay_status = function (const AIndex: s32; out AStatus: TLIBOnlineReplayStatus; out AProgressPercent100: Single): integer; stdcall;
  // can rbs
  TCANRBSStart = function (): integer; stdcall;
  TCANRBSStop = function (): integer; stdcall;
  TCANRBSIsRunning = function (out AIsRunning: Boolean): integer; stdcall;
  TCANRBSConfigure = function (const AAutoStart: boolean; const AAutoSendOnModification: boolean; const AActivateNodeSimulation: boolean; const AInitValueOptions: TLIBRBSInitValueOptions): integer; stdcall;
  TCANRBSActivateAllNetworks = function (const AEnable: boolean; const AIncludingChildren: Boolean): integer; stdcall;
  TCANRBSActivateNetworkByName = function (const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const AIncludingChildren: Boolean): integer; stdcall;
  TCANRBSActivateNodeByName = function (const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AIncludingChildren: Boolean): integer; stdcall;
  TCANRBSActivateMessageByName = function (const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall;
  TCANRBSSetMessageCycleByName = function (const AIdxChn: integer; const AIntervalMs: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall;
  TCANRBSGetSignalValueByElement = function (const AIdxChn: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; out AValue: Double): integer; stdcall;
  TCANRBSGetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; out AValue: Double): integer; stdcall;
  TCANRBSSetSignalValueByElement = function (const AIdxChn: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; const AValue: Double): integer; stdcall;
  TCANRBSSetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; const AValue: Double): integer; stdcall;
  TCANRBSEnable = function(const AEnable: boolean): s32; stdcall;
  TCANRBSBatchSetStart = function: s32; stdcall;
  TCANRBSBatchSetEnd = function: s32; stdcall;
  TCANRBSBatchSetSignal = function(const AAddr: pansichar; const AValue: double): s32; stdcall;
  TCANRBSSetMessageDirection = function (const AIdxChn: integer; const AIsTx: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall;
  TCANRBSFaultInjectionClear = function: s32; stdcall;
  TCANRBSFaultInjectionMessageLost = function(const AEnable: boolean; const AIdxChn: s32; const AIdentifier: s32): s32; stdcall;
  TCANRBSFaultInjectionSignalAlter = function(const AEnable: boolean; const ASymbolAddress: pansichar; const AAlterValue: double): s32; stdcall;
  TCANRBSSetNormalSignal = function(const ASymbolAddress: pansichar): s32; stdcall;
  TCANRBSSetRCSignal = function(const ASymbolAddress: pansichar): s32; stdcall;
  TCANRBSSetRCSignalWithLimit = function(const ASymbolAddress: pansichar; const ALowerLimit: s32; const AUpperLimit: s32): s32; stdcall;
  TCANRBSSetCRCSignal = function(const ASymbolAddress: pansichar; const AAlgorithmName: pansichar; const AIdxByteStart: s32; const AByteCount: s32): s32; stdcall;
  // blf functions
  TTSLog_blf_write_start = function (const AFileName: PAnsiChar; AHandle: ps32): s32; stdcall;
  TTSLog_blf_write_start_w_timestamp = function (const AFileName: PAnsiChar; AHandle: ps32; AYear: ps32; AMonth: ps32; ADay: ps32; AHour: ps32; AMinue: ps32; ASecond: ps32; AMilliSeconds: ps32): s32; stdcall;
  TTSLog_blf_write_set_max_count = function (const AHandle: s32; const ACount: u32): s32; stdcall;
  TTSLog_blf_write_can = function (const AHandle: s32; const ACAN: PlibCAN): s32; stdcall;
  TTSLog_blf_write_can_fd = function (const AHandle: s32; const ACANFD: PLIBCANFD): s32; stdcall;
  TTSLog_blf_write_lin = function (const AHandle: s32; const ALIN: PLIBLIN): s32; stdcall;
  TTSLog_blf_write_realtime_comment = function (const AHandle: s32; const ATimeUs: s64; const AComment: PAnsiChar): s32; stdcall;
  TTSLog_blf_write_end = function (const AHandle: s32): s32; stdcall;
  TTSLog_blf_read_start = function (const AFileName: PAnsiChar; AHandle: ps32; AObjCount: ps32): s32; stdcall;
  TTSLog_blf_read_status = function (const AHandle: s32; AObjReadCount: ps32): s32; stdcall;
  TTSLog_blf_read_object = function (const AHandle: s32; AProgressedCnt: ps32; AType: PSupportedObjType; ACAN: PlibCAN; ALIN: PLIBLIN; ACANFD: PLIBCANFD): s32; stdcall;
  TTSLog_blf_read_object_w_comment = function (const AHandle: s32; AProgressedCnt: ps32; AType: PSupportedObjType; ACAN: PlibCAN; ALIN: PlibLIN; ACANFD: PlibCANFD; AComment: Prealtime_comment_t): s32; stdcall;
  TTSLog_blf_read_end = function (const AHandle: s32): s32; stdcall;
  TTSLog_blf_seek_object_time = function (const AHandle: s32; const AProg100: Double; var ATime: s64; var AProgressedCnt: s32): s32; stdcall;
  TTSLog_blf_to_asc = function (const AObj: pointer; const ABLFFileName: PAnsiChar; const AASCFileName: pansichar; const AProgressCallback: TReadProgressCallback): s32; stdcall;
  TTSLog_asc_to_blf = function (const AObj: pointer; const AASCFileName: PAnsiChar; const ABLFFileName: pansichar; const AProgressCallback: TReadProgressCallback): s32; stdcall;
  // IP functions
  TIoIPCreate = function(const AObj: Pointer; const APortTCP, APortUDP: u16; const AOnTCPDataEvent, AOnUDPDataEvent: TOnIoIPData; AHandle: ps32): s32; stdcall;
  TIoIPDelete = function(const AObj: Pointer; const AHandle: s32): s32; stdcall;
  TIoIPEnableTCPServer = function(const AObj: Pointer; const AHandle: s32; const AEnable: Boolean): s32; stdcall;
  TIoIPEnableUDPServer = function(const AObj: Pointer; const AHandle: s32; const AEnable: Boolean): s32; stdcall;
  TIoIPConnectTCPServer = function(const AObj: Pointer; const AHandle: s32; const AIpAddress: PAnsiChar; const APort: u16): s32; stdcall;
  TIoIPConnectUDPServer = function(const AObj: Pointer; const AHandle: s32; const AIpAddress: PAnsiChar; const APort: u16): s32; stdcall;
  TIoIPDisconnectTCPServer = function(const AObj: Pointer; const AHandle: s32): s32; stdcall;
  TIoIPSendBufferTCP = function(const AObj: Pointer; const AHandle: s32; const APointer: Pointer; const ASize: s32): s32; stdcall;
  TIoIPSendBufferUDP = function(const AObj: Pointer; const AHandle: s32; const APointer: Pointer; const ASize: s32): s32; stdcall;
  TIoIPRecvTCPClientResponse = function(const AObj: Pointer; const AHandle: s32; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32): s32; stdcall;
  TIoIPSendTCPServerResponse = function(const AObj: Pointer; const AHandle: s32; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; stdcall;
  TIoIPSendUDPBroadcast = function(const AObj: Pointer; const AHandle: s32; const APort: Word; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; stdcall;
  TIoIPSetUDPServerBufferSize = function(const AObj: Pointer; const AHandle: s32; const ASize: s32): s32; stdcall;
  TIoIPRecvUDPClientResponse = function(const AObj: Pointer; const AHandle: s32; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32): s32; stdcall;
  TIoIPSendUDPServerResponse = function(const AObj: Pointer; const AHandle: s32; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; stdcall;
  // signal server functions
  TSgnSrvRegisterCANSignalByMsgId = function(const AIdxChn: integer; const AMsgId: integer; const ASgnName: pansichar; AClientId: pinteger): s32; stdcall;
  TSgnSrvRegisterLINSignalByMsgId = function(const AIdxChn: integer; const AMsgId: integer; const ASgnName: pansichar; AClientId: pinteger): s32; stdcall;
  TSgnSrvRegisterCANSignalByMsgName = function(const AIdxChn: integer; const ANetworkName: pansichar; const AMsgName: pansichar; const ASgnName: pansichar; AClientId: pinteger): s32; stdcall;
  TSgnSrvRegisterLINSignalByMsgName = function(const AIdxChn: integer; const ANetworkName: pansichar; const AMsgName: pansichar; const ASgnName: pansichar; AClientId: pinteger): s32; stdcall;
  TSgnSrvGetCANSignalPhyValueLatest = function(const AIdxChn: integer; const AClientId: integer; AValue: pdouble; ATimeUs: pint64): s32; stdcall;
  TSgnSrvGetLINSignalPhyValueLatest = function(const AIdxChn: integer; const AClientId: integer; AValue: pdouble; ATimeUs: pint64): s32; stdcall;
  TSgnSrvGetCANSignalPhyValueInMsg = function(const AIdxChn: integer; const AClientId: integer; const AMsg: plibcanfd; AValue: pdouble; ATimeUs: pint64): s32; stdcall;
  TSgnSrvGetLINSignalPhyValueInMsg = function(const AIdxChn: integer; const AClientId: integer; const AMsg: PlibLIN; AValue: pdouble; ATimeUs: pint64): s32; stdcall;
  // pdu container
  TPDUContainerSetCycleCount = function(const AIdxChn: integer; const AMsgId: integer; const ACount: integer): integer; stdcall;
  TPDUContainerSetCycleByIndex = function(const AIdxChn: integer; const AMsgId: integer; const AIdxCycle: integer; const ASignalGroupIdList: pansichar): integer; stdcall;
  TPDUContainerGetCycleCount = function(const AIdxChn: integer; const AMsgId: integer; out ACount: integer): integer; stdcall;
  TPDUContainerGetCycleByIndex = function(const AIdxChn: integer; const AMsgId: integer; const AIdxCycle: integer; ASignalGroupIdList: ppansichar): integer; stdcall;
  TPDUContainerRefresh = function(const AIdxChn: integer; const AMsgId: integer): integer; stdcall;
  // j1939
  TJ1939MakeId = function(const APGN: integer; const ASource: byte; const ADestination: byte; const APriority: byte; var AIdentifier: integer): integer; stdcall;
  TJ1939ExtractId = function(const AIdentifier: integer; var APGN: integer; var ASource: byte; var ADestination: byte; var APriority: byte): integer; stdcall;
  TJ1939GetPGN = function(const AIdentifier: integer; var APGN: integer): integer; stdcall;
  TJ1939GetSource = function(const AIdentifier: integer; var ASource: byte): integer; stdcall;
  TJ1939GetDestination = function(const AIdentifier: integer; var ADestination: byte): integer; stdcall;
  TJ1939GetPriority = function(const AIdentifier: integer; var APriority: byte): integer; stdcall;
  TJ1939GetR = function(const AIdentifier: integer; var AR: byte): integer; stdcall;
  TJ1939GetDP = function(const AIdentifier: integer; var ADP: byte): integer; stdcall;
  TJ1939GetEDP = function(const AIdentifier: integer; var AEDP: byte): integer; stdcall;
  TJ1939SetPGN = function(var AIdentifier: integer; const APGN: integer): integer; stdcall;
  TJ1939SetSource = function(var AIdentifier: integer; const ASource: u8): integer; stdcall;
  TJ1939SetDestination = function(var AIdentifier: integer; const ADestination: u8): integer; stdcall;
  TJ1939SetPriority = function(var AIdentifier: integer; const APriority: u8): integer; stdcall;
  TJ1939SetR = function(var AIdentifier: integer; const AR: u8): integer; stdcall;
  TJ1939SetDP = function(var AIdentifier: integer; const ADP: u8): integer; stdcall;
  TJ1939SetEDP = function(var AIdentifier: integer; const AEDP: u8): integer; stdcall;
  TJ1939GetLastPDU = function(const AIdxChn: byte; const AIdentifier: integer; const AIsTx: boolean; const APDUBufferSize: integer; APDUBuffer: pbyte; var APDUActualSize: integer; var ATimeUs: int64): integer; stdcall;
  TJ1939GetLastPDUAsString = function(const AIdxChn: byte; const AIdentifier: integer; const AIsTx: boolean; APDUData: ppansichar; var APDUActualSize: integer; var ATimeUs: int64): integer; stdcall;
  TJ1939TransmitPDUAsync = function(const AIdxChn: byte; const APGN: integer; const APriority: byte; const ASource: byte; const ADestination: byte; const APDUData: pbyte; const APDUSize: integer): integer; stdcall;
  TJ1939TransmitPDUSync = function(const AIdxChn: byte; const APGN: integer; const APriority: byte; const ASource: byte; const ADestination: byte; const APDUData: pbyte; const APDUSize: integer; const ATimeoutMs: integer): integer; stdcall;
  TJ1939TransmitPDUAsStringAsync = function(const AIdxChn: byte; const APGN: integer; const APriority: byte; const ASource: byte; const ADestination: byte; const APDUData: pansichar): integer; stdcall;
  TJ1939TransmitPDUAsStringSync = function(const AIdxChn: byte; const APGN: integer; const APriority: byte; const ASource: byte; const ADestination: byte; const APDUData: pansichar; const ATimeoutMs: integer): integer; stdcall;
  // 2022-11-18
  TTransmitFlexRayASync = function(const AFlexRay: plibflexray): integer; stdcall;
  TTransmitFlexRaySync = function(const AFlexRay: plibflexray; const ATimeoutMs: integer): integer; stdcall;
  TGetFlexRaySignalValue = function(const AFlexRaySignal: pmpflexraysignal; const AData: pu8): double; stdcall;
  TSetFlexRaySignalValue = function(const AFlexRaySignal: pmpflexraysignal; const AData: pu8; const AValue: double): integer; stdcall;
  TRegisterFlexRayEvent = function(const AObj: pointer; const AEvent: TFlexRayQueueEvent_Win32): integer; stdcall;
  TUnregisterFlexRayEvent = function(const AObj: pointer; const AEvent: TFlexRayQueueEvent_Win32): integer; stdcall;
  TInjectFlexRayFrame = function(const AFlexRay: plibflexray): integer; stdcall;
  TGetFlexRaySignalDefinition = function(const ASignalAddress: pansichar; ASignalDef: PmpFlexRaySignal): integer; stdcall;
  Ttslog_blf_write_flexray = function(const AHandle: integer; const AFlexRay: plibflexray): integer; stdcall;
  TSgnSrvRegisterFlexRaySignalByFrame = function(const AIdxChn: integer; const AShnMask: byte; const ACycleNumber: byte; const ASlotId: integer; const ASgnName: pansichar; AClientId: pinteger): integer; stdcall;
  TSgnSrvRegisterFlexRaySignalByFrameName = function(const AIdxChn: integer; const ANetworkName: pansichar; const AFrameName: pansichar; const ASgnName: pansichar; out AClientId: integer): integer; stdcall;
  TSgnSrvGetFlexRaySignalPhyValueLatest = function(const AIdxChn: integer; const AClientId: integer; out AValue: double; out ATimeUs: int64): integer; stdcall;
  TSgnSrvGetFlexRaySignalPhyValueInFrame = function(const AIdxChn: integer; const AClientId: integer; const AFrame: plibflexray; AValue: pdouble; ATimeUs: pint64): integer; stdcall;
  // 2022-11-19
  TUnregisterFlexRayEvents = function(const AObj: pointer): integer; stdcall;
  TRegisterPreTxFlexRayEvent = function(const AObj: Pointer; const AEvent: TFlexRayQueueEvent_Win32): integer; stdcall;
  TUnregisterPreTxFlexRayEvent = function(const AObj: pointer; const AEvent: TFlexRayQueueEvent_Win32): integer; stdcall;
  TUnregisterPreTxFlexRayEvents = function(const AObj: pointer): integer; stdcall;
  // 2022-11-29 flexray rbs
  TFlexRayRBSStart = function (): integer; stdcall;
  TFlexRayRBSStop = function (): integer; stdcall;
  TFlexRayRBSIsRunning = function (out AIsRunning: Boolean): integer; stdcall;
  TFlexRayRBSConfigure = function (const AAutoStart: boolean; const AAutoSendOnModification: boolean; const AActivateECUSimulation: boolean; const AInitValueOptions: TLIBRBSInitValueOptions): integer; stdcall;
  TFlexRayRBSActivateAllClusters = function (const AEnable: boolean; const AIncludingChildren: Boolean): integer; stdcall;
  TFlexRayRBSActivateClusterByName = function (const AIdxChn: integer; const AEnable: boolean; const AClusterName: PAnsiChar; const AIncludingChildren: Boolean): integer; stdcall;
  TFlexRayRBSActivateECUByName = function (const AIdxChn: integer; const AEnable: boolean; const AClusterName: PAnsiChar; const AECUName: pansichar; const AIncludingChildren: Boolean): integer; stdcall;
  TFlexRayRBSActivateFrameByName = function (const AIdxChn: integer; const AEnable: boolean; const AClusterName: PAnsiChar; const AECUName: pansichar; const AFrameName: PAnsiChar): integer; stdcall;
  TFlexRayRBSGetSignalValueByElement = function (const AIdxChn: s32; const AClusterName: PAnsiChar; const AECUName: pansichar; const AFrameName: PAnsiChar; const ASignalName: PAnsiChar; out AValue: Double): integer; stdcall;
  TFlexRayRBSGetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; out AValue: Double): integer; stdcall;
  TFlexRayRBSSetSignalValueByElement = function (const AIdxChn: s32; const AClusterName: PAnsiChar; const AECUName: pansichar; const AFrameName: PAnsiChar; const ASignalName: PAnsiChar; const AValue: Double): integer; stdcall;
  TFlexRayRBSSetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; const AValue: Double): integer; stdcall;
  TFlexRayRBSEnable = function(const AEnable: boolean): s32; stdcall;
  TFlexRayRBSBatchSetStart = function: s32; stdcall;
  TFlexRayRBSBatchSetEnd = function: s32; stdcall;
  TFlexRayRBSBatchSetSignal = function(const AAddr: pansichar; const AValue: double): s32; stdcall;
  TFlexRayRBSSetFrameDirection = function (const AIdxChn: integer; const AIsTx: boolean; const AClusterName: PAnsiChar; const AECUName: pansichar; const AFrameName: PAnsiChar): integer; stdcall;
  TFlexRayRBSSetNormalSignal = function(const ASymbolAddress: pansichar): s32; stdcall;
  TFlexRayRBSSetRCSignal = function(const ASymbolAddress: pansichar): s32; stdcall;
  TFlexRayRBSSetRCSignalWithLimit = function(const ASymbolAddress: pansichar; const ALowerLimit: s32; const AUpperLimit: s32): s32; stdcall;
  TFlexRayRBSSetCRCSignal = function(const ASymbolAddress: pansichar; const AAlgorithmName: pansichar; const AIdxByteStart: s32; const AByteCount: s32): s32; stdcall;
  TDisableOnlineReplayFilter = function(const AIndex: int32): s32; stdcall;
  TSetOnlineReplayFilter = function(const AIndex: Int32; const AIsPassFilter: Boolean; const ACount: Int32; const AIdxChannels: pInt32; const AIdentifiers: pInt32): s32; stdcall;
  TSetCANSignalRawValue = function(const ACANSignal: PMPCANSignal; const AData: pbyte; const AValue: UInt64): s32; stdcall;
  TGetCANSignalRawValue = function(const ACANSignal: PMPCANSignal; const AData: pbyte): u64; stdcall;
  TSetLINSignalRawValue = function(const ALINSignal: PMPLINSignal; const AData: pbyte; const AValue: UInt64): s32; stdcall;
  TGetLINSignalRawValue = function(const ALINSignal: PMPLINSignal; const AData: pbyte): u64; stdcall;
  TSetFlexRaySignalRawValue = function(const AFlexRaySignal: PMPFlexRaySignal; const AData: pbyte; const AValue: UInt64): s32; stdcall;
  TGetFlexRaySignalRawValue = function(const AFlexRaySignal: PMPFlexRaySignal; const AData: pbyte): u64; stdcall;
  TFlexRayRBSUpdateFrameByHeader = function(const AFlexRay: PLIBFlexRay): s32; stdcall;
  TLINRBSStart = function: integer; stdcall;
  TLINRBSStop = function: integer; stdcall;
  TLINRBSIsRunning = function (out AIsRunning: Boolean): integer; stdcall;
  TLINRBSConfigure = function (const AAutoStart: boolean; const AAutoSendOnModification: boolean; const AActivateNodeSimulation: boolean; const AInitValueOptions: TLIBRBSInitValueOptions): integer; stdcall;
  TLINRBSActivateAllNetworks = function (const AEnable: boolean; const AIncludingChildren: Boolean): integer; stdcall;
  TLINRBSActivateNetworkByName = function (const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const AIncludingChildren: Boolean): integer; stdcall;
  TLINRBSActivateNodeByName = function (const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AIncludingChildren: Boolean): integer; stdcall;
  TLINRBSActivateMessageByName = function (const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall;
  TLINBSSetMessageDelayTimeByName = function (const AIdxChn: integer; const AIntervalMs: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall;
  TLINRBSGetSignalValueByElement = function (const AIdxChn: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; out AValue: Double): integer; stdcall;
  TLINRBSGetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; out AValue: Double): integer; stdcall;
  TLINRBSSetSignalValueByElement = function (const AIdxChn: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; const AValue: Double): integer; stdcall;
  TLINRBSSetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; const AValue: Double): integer; stdcall;
  TLINRBSEnable = function(const AEnable: boolean): s32; stdcall;
  TLINRBSBatchSetStart = function: s32; stdcall;
  TLINRBSBatchSetEnd = function: s32; stdcall;
  TLINRBSBatchSetSignal = function(const AAddr: pansichar; const AValue: double): s32; stdcall;
  TTransmitEthernetASync = function(const AEthernetHeader: PLIBEthernetHeader): s32; stdcall;
  TTransmitEthernetSync = function(const AEthernetHeader: PLIBEthernetHeader; const ATimeoutMs: int32): s32; stdcall;
  TInjectEthernetFrame = function(const AEthernetHeader: PLIBEthernetHeader): s32; stdcall;
  TTSLogBlfWriteEthernet = function(const AHandle: int32; const AEthernetHeader: PLIBEthernetHeader): s32; stdcall;
  TTransmitEthernetAsyncWoPretx = function(const AEthernetHeader: PLIBEthernetHeader): s32; stdcall;
  TIoIpSetOnConnectionCallback = function(const AHandle: int32; const AConnectedCallback: TOnIoIPConnection; const ADisconnectedCallback: TOnIoIPConnection): s32; stdcall;
  TEthBuildIPv4UDPPacket = function(const AHeader: PLIBEthernetHeader; const ASrcIp: pbyte; const ADstIp: pbyte; const ASrcPort: word; const ADstPort: word; const APayload: pbyte; const APayloadLength: word; AIdentification: pInt32; AFragmentIndex: pInt32): s32; stdcall;
  // TS_COM_PROTO_END (do not modify this line) ================================

  // Test features
  TTestSetVerdictOK = function(const AObj: Pointer; const AStr: pansichar): integer; stdcall;
  TTestSetVerdictNOK = function(const AObj: Pointer; const AStr: pansichar): integer; stdcall;
  TTestSetVerdictCOK = function(const AObj: Pointer; const AStr: pansichar): integer; stdcall;
  TTestCheckVerdict = function(const AObj: Pointer; const AName: pansichar; const AValue: double; const AMin: double; const AMax: double): s32; stdcall;
  TTestLogger = function(const AObj: Pointer; const AStr: pansichar; const ALevel: Integer): integer; stdcall;
  TTestDebugLog = function(const AObj: Pointer; const AFile: pansichar; const AFunc: pansichar; const ALine: s32; const AStr: pansichar; const ALevel: Integer): s32; stdcall;
  TTestWriteResultString = function(const AObj: Pointer; const AName: pansichar; const AValue: PAnsiChar; const ALevel: Integer): integer; stdcall;
  TTestWriteResultValue = function(const AObj: Pointer; const AName: pansichar; const AValue: Double; const ALevel: Integer): integer; stdcall;
  TTestCheckErrorBegin = function: integer; stdcall;
  TTestCheckErrorEnd = function(const ACount: PInteger): integer; stdcall;
  TTestWriteResultImage = function(const AObj: Pointer; const AName: pansichar; const AImageFilePath: PAnsiChar): Integer; stdcall;
  TTestRetrieveCurrentResultFolder = function(const AObj: Pointer; AFolder: PPAnsiChar): Integer; stdcall;
  TTestCheckTerminate = function: integer; stdcall;
  TTestSignalCheckerClear = function: integer; stdcall;
  TTestSignalCheckerAddCheckWithTime = function(const ASignalType: TSignalType; const ACheckKind: TSignalCheckKind; const ASgnName: pansichar; const ASgnMin: double; const ASgnMax: double; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddCheckWithTrigger = function(const ASignalType: TSignalType; const ACheckKind: TSignalCheckKind; const ASgnName: pansichar; const ASgnMin: double; const ASgnMax: double; const ATriggerType: TSignalType; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddStatisticsWithTime = function(const ASignalType: TSignalType; const AStatisticsKind: TSignalStatisticsKind; const ASgnName: pansichar; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddStatisticsWithTrigger = function(const ASignalType: TSignalType; const AStatisticsKind: TSignalStatisticsKind; const ASgnName: pansichar; const ATriggerType: tsignaltype; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerGetResult = function(const AObj: Pointer; const ACheckId: integer; var APass: boolean; var AResult: double; AResultRepr: ppansichar): integer; stdcall;
  TTestSignalCheckerEnable = function(const ACheckId: integer; const AEnable: boolean): integer; stdcall;
  // 2022-11-29 signal checker apis
  TTestSignalCheckerAddRisingEdgeWithTime = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddRisingEdgeWithTrigger = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ATriggerType: tsignaltype; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddFallingEdgeWithTime = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddFallingEdgeWithTrigger = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ATriggerType: tsignaltype; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddMonotonyRisingWithTime = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ASampleIntervalMs: integer; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddMonotonyRisingWithTrigger = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ASampleIntervalMs: integer; const ATriggerType: tsignaltype; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddMonotonyFallingWithTime = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ASampleIntervalMs: integer; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddMonotonyFallingWithTrigger = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ASampleIntervalMs: integer; const ATriggerType: tsignaltype; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddFollowWithTime = function (const ASignalType, AFollowSignalType: TSignalType; const ASgnName, AFollowSgnName: pansichar; const AErrorRange: double; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddFollowWithTrigger = function (const ASignalType, AFollowSignalType: TSignalType; const ASgnName, AFollowSgnName: pansichar; const AErrorRange: double; const ATriggerType: tsignaltype; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddJumpWithTime = function (const ASignalType: TSignalType; const ASgnName: pansichar; const AIgnoreFrom: boolean; const AFrom: double; const ATo: double; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddJumpWithTrigger = function (const ASignalType: TSignalType; const ASgnName: pansichar; const AIgnoreFrom: boolean; const AFrom: double; const ATo: double; const ATriggerType: tsignaltype; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddUnChangeWithTime = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ATimeStartS: double; const ATimeEndS: double; var ACheckId: integer): integer; stdcall;
  TTestSignalCheckerAddUnchangeWithTrigger = function (const ASignalType: TSignalType; const ASgnName: pansichar; const ATriggerType: tsignaltype; const ATriggerName: pansichar; const ATriggerMin: double; const ATriggerMax: double; var ACheckId: integer): integer; stdcall;
  // 2023-02-08 signal checker check statistics
  TTestSignalCheckerCheckStatistics = function(const AObj: Pointer; const ACheckId: integer; const AMin: double; const AMax: double; var APass: boolean; var AResult: double; AResultRepr: ppansichar): integer; stdcall;
  // 2023-02-28 log name=value in test system
  TTestLogValue = function(const AObj: Pointer; const AStr: pansichar; const AValue: double; const ALevel: Integer): s32; stdcall;
  TTestLogString = function(const AObj: Pointer; const AStr: pansichar; const AValue: pansichar; const ALevel: Integer): s32; stdcall;
  // TS_TEST_PROTO_END (do not modify this line) ===============================

  // TSMaster variables ========================================================
  TEventInC = procedure; cdecl;
  // integer
  TMPVarInt = packed record // C type
    FObj: Pointer;
    FGet: TMPIntFunction;
    FSet: TMPProcedureSetInt;
    function GetValue: s32; cdecl;
    procedure SetValue(const AValue: s32); cdecl;
  end;
  PMPVarInt = ^TMPVarInt;
  // double
  TMPVarDouble = packed record // C type
    FObj: Pointer;
    FGet: TMPDoubleFunction;
    FSet: TMPProcedureSetDouble;
    function GetValue: Double; cdecl;
    procedure SetValue(const AValue: Double); cdecl;
  end;
  PMPVarDouble = ^TMPVarDouble;
  // string
  TMPStringType = array [0..1023] of AnsiChar;
  TMPVarString = packed record // C type
    FObj: Pointer;
    FGet: TMPStringFunction;
    FSet: TMPProcedureSetString;
    function GetValue: PAnsiChar; cdecl;
    procedure SetValue(const AValue: PAnsiChar); cdecl;
  end;
  PMPVarString = ^TMPVarString;
  // tcan
  TMPVarCAN = packed record // C type
    FObj: Pointer;
    FGet: TMPCANFunction;
    FSet: TMPProcedureSetCAN;
    function GetValue: TLIBCAN; cdecl;
    procedure SetValue(const AValue: TLIBCAN); cdecl;
  end;
  PMPVarCAN = ^TMPVarCAN;
  // tcanfd
  TMPVarCANFD = packed record // C type
    FObj: Pointer;
    FGet: TMPCANFDFunction;
    FSet: TMPProcedureSetCANFD;
    function GetValue: TLIBCANfd; cdecl;
    procedure SetValue(const AValue: TLIBCANfd); cdecl;
  end;
  PMPVarCANFD = ^TMPVarCANFD;
  // tlin
  TMPVarLIN = packed record // C type
    FObj: Pointer;
    FGet: TMPLINFunction;
    FSet: TMPProcedureSetLIN;
    function GetValue: TLIBLIN; cdecl;
    procedure SetValue(const AValue: TLIBLIN); cdecl;
  end;
  PMPVarLIN = ^TMPVarLIN;

  // TSMaster timer
  TMPTimerMS = packed record // C type
    FObj: Pointer;
    FStart: TMPProcedure;
    FStop: TMPProcedure;
    FSetInterval: TMPProcedureSetInt;
    FGetInterval: TMPIntFunction;
    procedure Start; cdecl;
    procedure Stop; cdecl;
    procedure SetInterval(const AInterval: s32); cdecl;
    function GetInterval: s32; cdecl;
  end;
  PMPTimerMS = ^TMPTimerMS;

  // TSMaster application record in C script
  TTSApp = packed record // C type
    FObj                                : Pointer                          ;
    set_current_application             : TTSAppSetCurrentApplication      ;
    get_current_application             : TTSAppGetCurrentApplication      ;
    del_application                     : TTSAppDelApplication             ;
    add_application                     : TTSAppAddApplication             ;
    get_application_list                : TTSAppGetApplicationList         ;
    set_can_channel_count               : TTSAppSetCANChannelCount         ;
    set_lin_channel_count               : TTSAppSetLINChannelCount         ;
    get_can_channel_count               : TTSAppGetCANChannelCount         ;
    get_lin_channel_count               : TTSAppGetLINChannelCount         ;
    set_mapping                         : TTSAppSetMapping                 ;
    get_mapping                         : TTSAppGetMapping                 ;
    del_mapping                         : TTSAppDeleteMapping              ;
    connect                             : TTSAppConnectApplication         ;
    disconnect                          : TTSAppDisconnectApplication      ;
    Log_text                            : TTSAppLogger                     ;
    configure_baudrate_can              : TTSConfigureBaudrateCAN          ;
    configure_baudrate_canfd            : TTSConfigureBaudrateCANFD        ;
    set_turbo_mode                      : TTSSetTurboMode                  ;
    get_turbo_mode                      : TTSGetTurboMode                  ;
    get_error_description               : TTSGetErrorDescription           ;
    internal_terminate_application      : TTSTerminate                     ;
    internal_wait                       : TTSWait                          ;
    internal_check                      : TTSCheckError                    ;
    internal_start_log                  : TTSStartLog                      ;
    internal_end_log                    : TTSEndLog                        ;
    internal_check_terminate            : TTSCheckTerminate                ;
    get_timestamp                       : TTSGetTimestampUs                ;
    show_confirm_dialog                 : TTSShowConfirmDialog             ;
    pause                               : TTSPause                         ;
    internal_set_check_failed_terminate : TTSSetCheckFailedTerminate       ;
    get_system_var_count                : TTSAppGetSystemVarCount          ;
    get_system_var_def_by_index         : TTSAppGetSystemVarDefByIndex     ;
    get_system_var_def_by_name          : TTSAppFindSystemVarDefByName     ;
    get_system_var_double               : TTSAppGetSystemVarDouble         ;
    get_system_var_int32                : TTSAppGetSystemVarInt32          ;
    get_system_var_uint32               : TTSAppGetSystemVarUInt32         ;
    get_system_var_int64                : TTSAppGetSystemVarInt64          ;
    get_system_var_uint64               : TTSAppGetSystemVarUInt64         ;
    get_system_var_uint8_array          : TTSAppGetSystemVarUInt8Array     ;
    get_system_var_int32_array          : TTSAppGetSystemVarInt32Array     ;
    get_system_var_int64_array          : TTSAppGetSystemVarInt64Array     ;
    get_system_var_double_array         : TTSAppGetSystemVarDoubleArray    ;
    get_system_var_string               : TTSAppGetSystemVarString         ;
    set_system_var_double               : TTSAppSetSystemVarDouble         ;
    set_system_var_int32                : TTSAppSetSystemVarInt32          ;
    set_system_var_uint32               : TTSAppSetSystemVarUInt32         ;
    set_system_var_int64                : TTSAppSetSystemVarInt64          ;
    set_system_var_uint64               : TTSAppSetSystemVarUInt64         ;
    set_system_var_uint8_array          : TTSAppSetSystemVarUInt8Array     ;
    set_system_var_int32_array          : TTSAppSetSystemVarInt32Array     ;
    set_system_var_int64_array          : TTSAppSetSystemVarInt64Array     ;
    set_system_var_double_array         : TTSAppSetSystemVarDoubleArray    ;
    set_system_var_string               : TTSAppSetSystemVarString         ;
    make_toast                          : TTSAppMakeToast                  ;
    execute_python_string               : TTSAppExecutePythonString        ;
    execute_python_script               : TTSAppExecutePythonScript        ;
    execute_app                         : TTSAppExecuteApp                 ;
    terminate_app_by_name               : TTSAppTerminateAppByName         ;
    excel_load                          : Texcel_load                      ;
    excel_get_sheet_count               : Texcel_get_sheet_count           ;
    excel_set_sheet_count               : Texcel_set_sheet_count           ;
    excel_get_sheet_name                : Texcel_get_sheet_name            ;
    excel_get_cell_count                : Texcel_get_cell_count            ;
    excel_get_cell_value                : Texcel_get_cell_value            ;
    excel_set_cell_count                : Texcel_set_cell_count            ;
    excel_set_cell_value                : Texcel_set_cell_value            ;
    excel_unload                        : Texcel_unload                    ;
    excel_unload_all                    : Texcel_unload_all                ;
    log_system_var                      : TTSAppLogSystemVar               ;
    excel_set_sheet_name                : Texcel_set_sheet_name            ;
    call_mini_program_api               : TTSAppCallMPAPI                  ;
    split_string                        : TTSAppSplitString                ;
    wait_system_var_existance           : TTSAppWaitSystemVarExistance     ;
    wait_system_var_disappear           : TTSAppWaitSystemVarDisappear     ;
    set_analysis_time_range             : TTSAppSetAnalysisTimeRange       ;
    get_configuration_file_name         : TTSAppGetConfigurationFileName   ;
    get_configuration_file_path         : TTSAppGetConfigurationFilePath   ;
    set_default_output_dir              : TTSAppSetDefaultOutputDir        ;
    save_screenshot                     : TTSAppSaveScreenshot             ;
    enable_all_graphics                 : TTSAppEnableGraphics             ;
    get_tsmaster_version                : TTSAppGetTSMasterVersion         ;
    ui_show_page_by_index               : TUIShowPageByIndex               ;
    ui_show_page_by_name                : TUIShowPageByName                ;
    write_realtime_comment              : TWriteRealtimeComment            ;
    internal_set_thread_priority        : TTSAppSetThreadPriority          ;
    get_system_var_generic              : TTSAppGetSystemVarGeneric        ;
    set_system_var_generic              : TTSAppSetSystemVarGeneric        ;
    write_text_file_start               : TWriteTextFileStart              ;
    write_text_file_line                : TWriteTextFileLine               ;
    write_text_file_line_double_array   : TWriteTextFileLineWithDoubleArray;
    write_text_file_line_string_array   : TWriteTextFileLineWithStringArray;
    write_text_file_end                 : TWriteTextFileEnd                ;
    force_directory                     : TTSAppForceDirectory             ;
    directory_exists                    : TTSAppDirectoryExists            ;
    open_directory_and_select_file      : TTSAppOpenDirectoryAndSelectFile ;
    mini_delay_cpu                      : TTSAppMiniDelayCPU               ;
    wait_system_var                     : TTSAppWaitSystemVar              ;
    write_mat_file_start                : TWriteMatFileStart               ;
    write_mat_file_variable_double      : TWriteMatFileVariableDouble      ;
    write_mat_file_variable_string      : TWriteMatFileVariableString      ;
    write_mat_file_variable_double_array: TWriteMatFileVariableDoubleArray ;
    write_mat_file_end                  : TWriteMatFileEnd                 ;
    read_mat_file_start                 : TReadMatFileStart                ;
    read_mat_file_variable_count        : TReadMatFileVariableCount        ;
    read_mat_file_variable_string       : TReadMatFileVariableString       ;
    read_mat_file_variable_double       : TReadMatFileVariableDouble       ;
    read_mat_file_end                   : TReadMatFileEnd                  ;
    prmopt_user_input_value             : TPromptUserInputValue           ;
    prmopt_user_input_string            : TPromptUserInputString          ;
    ini_create                          : TIniCreate                      ;
    ini_write_int32   :  TIniWriteInt32     ;
    ini_write_int64   :  TIniWriteInt64     ;
    ini_write_bool    :  TIniWriteBool      ;
    ini_write_float   :  TIniWriteFloat     ;
    ini_write_string  :  TIniWriteString    ;
    ini_read_int32    :  TIniReadInt32      ;
    ini_read_int64    :  TIniReadInt64      ;
    ini_read_bool     :  TIniReadBool       ;
    ini_read_float    :  TIniReadFloat      ;
    ini_read_string   :  TIniReadString     ;
    ini_section_exists:  TIniSectionExists  ;
    ini_key_exists    :  TIniKeyExists      ;
    ini_delete_key    :  TIniDeleteKey      ;
    ini_delete_section:  TIniDeleteSection  ;
    ini_close         :  TIniClose          ;
    make_toast_until  :  TMakeToastUntil    ;
    make_toast_with_callback            : TMakeToastWithCallback          ;
    get_doc_path                        : TTSAppGetDocPath                ;
    get_hardware_id_string              : TTSAppGetHWIDString             ;
    get_hardware_id_array               : TTSAppGetHWIDArray              ;
    create_system_var                   : TTSAppCreateSystemVar           ;
    delete_system_var                   : TTSAppDeleteSystemVar           ;
    run_form                            : TTSAppRunForm                   ;
    stop_form                           : TTSAppstopform                  ;
    read_text_file_start                : TReadTextFileStart              ;
    read_text_file_line                 : TReadTextFileLine               ;
    read_text_file_end                  : TReadTextFileEnd                ;
    play_sound                          : TPlaySound                      ;
    set_system_var_unit                 : TTSAppSetSystemVarUnit          ;
    set_system_var_value_table          : TTSAppSetSystemVarValueTable    ;
    load_plugin                         : TTSAppLoadPlugin                ;
    unload_plugin                       : TTSAppUnloadPlugin              ;
    set_system_var_double_async      :   TTSAppSetSystemVarDoubleAsync     ;
    set_system_var_int32_async       :   TTSAppSetSystemVarInt32Async      ;
    set_system_var_uint32_async      :   TTSAppSetSystemVarUInt32Async     ;
    set_system_var_int64_async       :   TTSAppSetSystemVarInt64Async      ;
    set_system_var_uint64_async      :   TTSAppSetSystemVarUInt64Async     ;
    set_system_var_uint8_array_async :   TTSAppSetSystemVarUInt8ArrayAsync ;
    set_system_var_int32_array_async :   TTSAppSetSystemVarInt32ArrayAsync ;
    set_system_var_int64_array_async :   TTSAppSetSystemVarInt64ArrayAsync ;
    set_system_var_double_array_async:   TTSAppSetSystemVarDoubleArrayAsync;
    set_system_var_string_async      :   TTSAppSetSystemVarStringAsync     ;
    set_system_var_generic_async     :   TTSAppSetSystemVarGenericAsync    ;
    am_get_running_state             :   TAMGetRunningState                ;
    am_run                           :   TAMRun                            ;
    am_stop                          :   TAMStop                           ;
    am_select_sub_module             :   TAMSelectSubModule                ;
    panel_set_enable                 :   TPanelSetEnable                   ;
    panel_set_position_x             :   TPanelSetPositionX                ;
    panel_set_position_y             :   TPanelSetPositionY                ;
    panel_set_position_xy            :   TPanelSetPositionXY               ;
    panel_set_opacity                :   TPanelSetOpacity                  ;
    panel_set_width                  :   TPanelSetWidth                    ;
    panel_set_height                 :   TPanelSetHeight                   ;
    panel_set_width_height           :   TPanelSetWidthHeight              ;
    panel_set_rotation_angle         :   TPanelSetRotationAngle            ;
    panel_set_rotation_center        :   TPanelSetRotationCenter           ;
    panel_set_scale_x                :   TPanelSetScaleX                   ;
    panel_set_scale_y                :   TPanelSetScaleY                   ;
    panel_get_enable                 :   TPanelGetEnable                   ;
    panel_get_position_xy            :   TPanelGetPositionXY               ;
    panel_get_opacity                :   TPanelGetOpacity                  ;
    panel_get_width_height           :   TPanelGetWidthHeight              ;
    panel_get_rotation_angle         :   TPanelGetRotationAngle            ;
    panel_get_rotation_center        :   TPanelGetRotationCenter           ;
    panel_get_scale_xy               :   TPanelGetScaleXY                  ;
    stim_set_signal_status           :   TSTIMSetSignalStatus              ;
    stim_get_signal_status           :   TSTIMGetSignalStatus              ;
    panel_set_bkgd_color             :   TPanelSetBkgdColor                ;
    panel_get_bkgd_color             :   TPanelGetBkgdColor                ;
    clear_measurement_form           :   TTSAppClearMeasurementForm        ;
    get_system_var_address           :   TTSAppGetSystemVarAddress         ;
    set_system_var_logging           :   TTSAppSetSystemVarLogging         ;
    get_system_var_logging           :   TTSAppGetSystemVarLogging         ;
    log_system_var_value             :   TTSAppLogSystemVarValue           ;
    get_main_window_handle           :   TUIGetMainWindowHandle            ;
    print_delta_time                 :   TPrintDeltaTime                   ;
    atomic_increment_32              :   TAtomicIncrement32                ;
    atomic_increment_64              :   TAtomicIncrement64                ;
    atmoic_set_32                    :   TAtomicSet32                      ;
    atomic_set_64                    :   TAtomicSet64                      ;
    get_consant_double               :   TGetConstantDouble                ;
    add_direct_mapping_can           :   TAddDirectMappingCAN              ;
    add_expression_mapping           :   TAddExpressionMapping             ;
    delete_symbol_mapping_item       :   TDeleteSymbolMappingItem          ;
    enable_symbol_mapping_item       :   TEnableSymbolMappingItem          ;
    enable_symbol_mapping_engine     :   TEnableSymbolMappingEngine        ;
    delete_symbol_mapping_items      :   TDeleteSymbolMappingItems         ;
    save_symbol_mapping_settings     :   TSaveSymbolMappingSettings        ;
    load_symbol_mapping_settings     :   TLoadSymbolMappingSettings        ;
    add_direct_mapping_with_factor_offset_can:   TAddDirectMappingWithFactorOffsetCAN;
    internal_debug_log               :   TTSAppDebugLog                    ;
    internal_wait_with_dialog        :   TTSWaitWithDialog                 ;
    is_connected                     :   TTSAppIsConnected                 ;
    get_flexray_channel_count        :   TTSAppGetFlexRayChannelCount      ;
    set_flexray_channel_count        :   TTSAppSetFlexRayChannelCount      ;
    db_get_can_database_count         : TDBGetCANDBCount;
    db_get_lin_database_count         : TDBGetLINDBCount;
    db_get_flexray_database_count     : TDBGetFlexRayDBCount;
    db_get_can_database_properties_by_index       : TDBGetCANDBPropertiesByIndex;
    db_get_lin_database_properties_by_index       : TDBGetLINDBPropertiesByIndex;
    db_get_flexray_database_properties_by_index   : TDBGetFlexRayDBPropertiesByIndex;
    db_get_can_ecu_properties_by_index            : TDBGetCANDBECUPropertiesByIndex;
    db_get_lin_ecu_properties_by_index            : TDBGetLINDBECUPropertiesByIndex;
    db_get_flexray_ecu_properties_by_index        : TDBGetFlexRayDBECUPropertiesByIndex;
    db_get_can_frame_properties_by_index          : TDBGetCANDBFramePropertiesByIndex;
    db_get_lin_frame_properties_by_index          : TDBGetLINDBFramePropertiesByIndex;
    db_get_flexray_frame_properties_by_index      : TDBGetFlexRayDBFramePropertiesByIndex;
    db_get_can_signal_properties_by_index         : TDBGetCANDBSignalPropertiesByIndex;
    db_get_lin_signal_properties_by_index         : TDBGetLINDBSignalPropertiesByIndex;
    db_get_flexray_signal_properties_by_index     : TDBGetFlexRayDBSignalPropertiesByIndex;
    db_get_can_database_properties_by_address     : TDBGetCANDBPropertiesByAddress;
    db_get_lin_database_properties_by_address     : TDBGetLINDBPropertiesByAddress;
    db_get_flexray_database_properties_by_address : TDBGetFlexRayDBPropertiesByAddress;
    db_get_can_ecu_properties_by_address          : TDBGetCANDBECUPropertiesByAddress;
    db_get_lin_ecu_properties_by_address          : TDBGetLINDBECUPropertiesByAddress;
    db_get_flexray_ecu_properties_by_address      : TDBGetFlexRayDBECUPropertiesByAddress;
    db_get_can_frame_properties_by_address        : TDBGetCANDBFramePropertiesByAddress;
    db_get_lin_frame_properties_by_address        : TDBGetLINDBFramePropertiesByAddress;
    db_get_flexray_frame_properties_by_address    : TDBGetFlexRayDBFramePropertiesByAddress;
    db_get_can_signal_properties_by_address       : TDBGetCANDBSignalPropertiesByAddress;
    db_get_lin_signal_properties_by_address       : TDBGetLINDBSignalPropertiesByAddress;
    db_get_flexray_signal_properties_by_address   : TDBGetFlexRayDBSignalPropertiesByAddress;
    run_python_function                           : TRunPythonFunction;
    get_current_mp_name                           : TGetCurrentMpName;
    panel_set_selector_items                      : TPanelSetSelectorItems;
    panel_get_selector_items                      : TPanelGetSelectorItems;
    get_system_constant_count                     : TGetSystemConstantCount;
    get_system_constant_value_by_index            : TGetSystemConstantValueByIndex;
    db_get_can_frame_properties_by_db_index       : TDBGetCANDBFramePropertiesByDBIndex     ;
    db_get_lin_frame_properties_by_db_index       : TDBGetLINDBFramePropertiesByDBIndex     ;
    db_get_flexray_frame_properties_by_db_index   : TDBGetFlexRayDBFramePropertiesByDBIndex ;
    db_get_can_signal_properties_by_db_index      : TDBGetCANDBSignalPropertiesByDBIndex    ;
    db_get_lin_signal_properties_by_db_index      : TDBGetLINDBSignalPropertiesByDBIndex    ;
    db_get_flexray_signal_properties_by_db_index  : TDBGetFlexRayDBSignalPropertiesByDBIndex;
    db_get_can_signal_properties_by_frame_index      : TDBGetCANDBSignalPropertiesByFrameIndex    ;
    db_get_lin_signal_properties_by_frame_index      : TDBGetLINDBSignalPropertiesByFrameIndex    ;
    db_get_flexray_signal_properties_by_frame_index  : TDBGetFlexRayDBSignalPropertiesByFrameIndex;
    add_system_constant                              : TAddSystemConstant;
    delete_system_constant                           : TDeleteSystemConstant;    
    db_get_flexray_cluster_parameters: TDBGetFlexRayClusterParameters;
    db_get_flexray_controller_parameters: TDBGetFlexRayControllerParameters;
    set_system_var_event_support: TSetSystemVarEventSupport;
    get_system_var_event_support: TGetSystemVarEventSupport;
    get_date_time: TGetDateTime;
    gpg_delete_all_modules: TGPGDeleteAllModules;
    gpg_create_module: TGPGCreateModule;
    gpg_delete_module: TGPGDeleteModule;
    gpg_deploy_module: TGPGDeployModule;
    gpg_add_action_down: TGPGAddActionDown;
    gpg_add_action_right: TGPGAddActionRight;
    gpg_add_goto_down: TGPGAddGoToDown;
    gpg_add_goto_right: TGPGAddGoToRight;
    gpg_add_from_down: TGPGAddFromDown;
    gpg_add_group_down: TGPGAddGroupDown;
    gpg_add_group_right: TGPGAddGroupRight;
    gpg_delete_action: TGPGDeleteAction;
    gpg_set_action_nop: TGPGSetActionNOP;
    gpg_set_action_signal_read_write: TGPGSetActionSignalReadWrite;
    gpg_set_action_api_call: TGPGSetActionAPICall;
    gpg_set_action_expression: TGPGSetActionExpression;
    gpg_configure_action_basic: TGPGConfigureActionBasic;
    gpg_configure_goto: TGPGConfigureGoTo;
    gpg_configure_from: TGPGConfigureFrom;
    gpg_configure_nop: TGPGConfigureNOP;
    gpg_configure_group: TGPGConfigureGroup;
    gpg_configure_signal_read_write_list_clear: TGPGConfigureSignalReadWriteListClear;
    gpg_configure_signal_write_list_append: TGPGConfigureSignalWriteListAppend;
    gpg_configure_signal_read_list_append: TGPGConfigureSignalReadListAppend;
    gpg_configure_api_call_arguments: TGPGConfigureAPICallArguments;
    gpg_configure_api_call_result: TGPGConfigureAPICallResult;
    gpg_configure_expression: TGPGConfigureExpression;
    gpg_add_local_var: TGPGAddLocalVar;
    gpg_delete_local_var: TGPGDeleteLocalVar;
    gpg_delete_all_local_vars: TGPGDeleteAllLoalVars;
    gpg_delete_group_items: TGPGDeleteGroupItems;
    gpg_configure_signal_read_write_list_delete: TGPGConfigureSignalReadWriteListDelete;
    gpg_configure_module: TGPGConfigureModule;
    ui_show_window: TUIShowWindow;
    ui_graphics_load_configuration: TUIGraphicsLoadConfiguration;
    ui_watchdog_enable: TUIWatchdogEnable;
    ui_watchdog_feed: TUIWatchdogFeed;
    add_path_to_environment: TAddPathToEnvironment;
    delete_path_from_environment: TDeletePathFromEnvironment;
    set_system_var_double_w_time: TTSAppSetSystemVarDoubleWTime;
    set_system_var_int32_w_time: TTSAppSetSystemVarInt32WTime;
    set_system_var_uint32_w_time: TTSAppSetSystemVarInt32WTime;
    set_system_var_int64_w_time: TTSAppSetSystemVarInt64WTime;
    set_system_var_uint64_w_time: TTSAppSetSystemVarUInt64WTime;
    set_system_var_uint8_array_w_time: TTSAppSetSystemVarUInt8ArrayWTime;
    set_system_var_int32_array_w_time: TTSAppSetSystemVarInt32ArrayWTime;
    set_system_var_double_array_w_time: TTSAppSetSystemVarDoubleArrayWTime;
    set_system_var_string_w_time: TTSAppSetSystemVarStringWTime;
    set_system_var_generic_w_time: TTSAppSetSystemVarGenericWTime;
    set_system_var_double_async_w_time: TTSAppSetSystemVarDoubleAsyncWTime;
    set_system_var_int32_async_w_time: TTSAppSetSystemVarInt32AsyncWTime;
    set_system_var_uint32_async_w_time: TTSAppSetSystemVarUInt32AsyncWTime;
    set_system_var_int64_async_w_time: TTSAppSetSystemVarInt64AsyncWTime;
    set_system_var_uint64_async_w_time: TTSAppSetSystemVarUInt64AsyncWTime;
    set_system_var_uint8_array_async_w_time: TTSAppSetSystemVarUInt8ArrayAsyncWTime;
    set_system_var_int32_array_async_w_time: TTSAppSetSystemVarInt32ArrayAsyncWTime;
    set_system_var_int64_array_async_w_time: TTSAppSetSystemVarInt64ArrayAsyncWTime;
    set_system_var_double_array_async_w_time: TTSAppSetSystemVarDoubleArrayAsyncWTime;
    set_system_var_string_async_w_time: TTSAppSetSystemVarStringAsyncWTime;
    set_system_var_generic_async_w_time: TTSAppSetSystemVarGenericAsyncWTime;
    db_get_signal_startbit_by_pdu_offset: TDBGetSignalStartBitByPDUOffset;
    ui_show_save_file_dialog: TUIShowSaveFileDialog;
    ui_show_open_file_dialog: TUIShowOpenFileDialog;
    ui_show_select_directory_dialog: TUIShowSelectDirectoryDialog;
    set_ethernet_channel_count: TSetEthernetChannelCount;
    get_ethernet_channel_count: TGetEthernetChannelCount;
    db_get_can_db_index_by_id: TDBGetCANDBIndexById;
    db_get_lin_db_index_by_id: TDBGetLINDBIndexById;
    db_get_flexray_db_index_by_id: TDBGetFlexRayDBIndexById;
    FDummy: array [0..729-1] of s32; // place holders, TS_APP_PROTO_END
    procedure terminate_application; cdecl;
    function wait(const ATimeMs: s32; const AMessage: PAnsiChar): s32; cdecl;
    function debug_log(const AFile: pansichar; const AFunc: pansichar; const ALine: s32; const AStr: pansichar; const ALevel: Integer): integer; cdecl;
    function start_log: s32; cdecl;
    function end_log: s32; cdecl;
    function check_terminate: s32; cdecl;
    function check(const AErrorCode: s32): s32; cdecl;
    function set_check_failed_terminate(const AToTerminate: Boolean): s32; cdecl;
    function set_thread_priority(const APriorty: s32): s32; cdecl;
    function wait_with_dialog(const ATitle: pansichar; const AMessage: pansichar; const ApResult: pboolean; const ApProgress100: psingle): s32; cdecl;
  end;
  PTSApp = ^TTSApp;

  // TSMaster Communication record in C script
  TTSCOM = packed record // C type
    FObj                                      : Pointer               ;
    // CAN functions
    transmit_can_async                        : TTransmitCANAsync     ;
    transmit_can_sync                         : TTransmitCANSync      ;
    // CAN FD functions
    transmit_canfd_async                      : TTransmitCANFDAsync   ;
    transmit_canfd_sync                       : TTransmitCANFDSync    ;
    // LIN functions
    transmit_lin_async                        : TTransmitLINAsync     ;
    transmit_lin_sync                         : TTransmitLINSync      ;
    // Database functions
    get_can_signal_value                      : TMPGetCANSignalValue  ;
    set_can_signal_value                      : TMPSetCANSignalValue  ;
    // Bus Statistics
    enable_bus_statistics                     : TEnableBusStatistics  ;
    clear_bus_statistics                      : TClearBusStatistics   ;
    get_bus_statistics                        : TGetBusStatistics     ;
    get_fps_can                               : TGetFPSCAN            ;
    get_fps_canfd                             : TGetFPSCANFD          ;
    get_fps_lin                               : TGetFPSLIN            ;
    // Bus functions
    internal_wait_can_message                 : TWaitCANMessage       ;
    internal_wait_canfd_message               : TWaitCANFDMessage     ;
    add_cyclic_message_can                    : TAddCyclicMsgCAN      ;
    add_cyclic_message_canfd                  : TAddCyclicMsgCANFD   ;
    del_cyclic_message_can                    : TDeleteCyclicMsgCAN  ;
    del_cyclic_message_canfd                  : TDeleteCyclicMsgCANFD;
    del_cyclic_messages                       : TDeleteCyclicMsgs    ;
    // bus callbacks
    internal_register_event_can               : TRegisterCANEvent;
    internal_unregister_event_can             : TUnregisterCANEvent;
    internal_register_event_canfd             : TRegisterCANFDEvent;
    internal_unregister_event_canfd           : TUnregisterCANFDEvent;
    internal_register_event_lin               : TRegisterLINEvent;
    internal_unregister_event_lin             : TUnregisterLINEvent;
    internal_unregister_events_can            : TUnregisterCANEvents;
    internal_unregister_events_lin            : TUnregisterLINEvents;
    internal_unregister_events_canfd          : TUnregisterCANFDEvents;
    internal_unregister_events_all            : TUnregisterALLEvents;
    // online replay
    tslog_add_online_replay_config            : Ttslog_add_online_replay_config ;
    tslog_set_online_replay_config            : Ttslog_set_online_replay_config ;
    tslog_get_online_replay_count             : Ttslog_get_online_replay_count  ;
    tslog_get_online_replay_config            : Ttslog_get_online_replay_config ;
    tslog_del_online_replay_config            : Ttslog_del_online_replay_config ;
    tslog_del_online_replay_configs           : Ttslog_del_online_replay_configs;
    tslog_start_online_replay                 : Ttslog_start_online_replay      ;
    tslog_start_online_replays                : Ttslog_start_online_replays     ;
    tslog_pause_online_replay                 : Ttslog_pause_online_replay      ;
    tslog_pause_online_replays                : Ttslog_pause_online_replays     ;
    tslog_stop_online_replay                  : Ttslog_stop_online_replay       ;
    tslog_stop_online_replays                 : Ttslog_stop_online_replays      ;
    tslog_get_online_replay_status            : Ttslog_get_online_replay_status ;
    // can rbs
    can_rbs_start                             : TCANRBSStart                    ;
    can_rbs_stop                              : TCANRBSStop                     ;
    can_rbs_is_running                        : TCANRBSIsRunning                ;
    can_rbs_configure                         : TCANRBSConfigure                ;
    can_rbs_activate_all_networks             : TCANRBSActivateAllNetworks      ;
    can_rbs_activate_network_by_name          : TCANRBSActivateNetworkByName    ;
    can_rbs_activate_node_by_name             : TCANRBSActivateNodeByName       ;
    can_rbs_activate_message_by_name          : TCANRBSActivateMessageByName    ;
    can_rbs_get_signal_value_by_element       : TCANRBSGetSignalValueByElement  ;
    can_rbs_get_signal_value_by_address       : TCANRBSGetSignalValueByAddress  ;
    can_rbs_set_signal_value_by_element       : TCANRBSSetSignalValueByElement  ;
    can_rbs_set_signal_value_by_address       : TCANRBSSetSignalValueByAddress  ;
    // bus internal pre-tx functions
    internal_register_pretx_event_can         : TRegisterPreTxCANEvent     ;
    internal_unregister_pretx_event_can       : TUnregisterPreTxCANEvent   ;
    internal_register_pretx_event_canfd       : TRegisterPreTxCANFDEvent   ;
    internal_unregister_pretx_event_canfd     : TUnregisterPreTxCANFDEvent ;
    internal_register_pretx_event_lin         : TRegisterPreTxLINEvent     ;
    internal_unregister_pretx_event_lin       : TUnregisterPreTxLINEvent   ;
    internal_unregister_pretx_events_can      : TUnregisterPreTxCANEvents  ;
    internal_unregister_pretx_events_lin      : TUnregisterPreTxLINEvents  ;
    internal_unregister_pretx_events_canfd    : TUnregisterPreTxCANFDEvents;
    internal_unregister_pretx_events_all      : TUnregisterPreTxALLEvents  ;
    // blf functions
    tslog_blf_write_start                     : Ttslog_blf_write_start     ;
    tslog_blf_write_can                       : Ttslog_blf_write_can       ;
    tslog_blf_write_can_fd                    : Ttslog_blf_write_can_fd    ;
    tslog_blf_write_lin                       : Ttslog_blf_write_lin       ;
    tslog_blf_write_end                       : Ttslog_blf_write_end       ;
    tslog_blf_read_start                      : Ttslog_blf_read_start      ;
    tslog_blf_read_status                     : Ttslog_blf_read_status     ;
    tslog_blf_read_object                     : Ttslog_blf_read_object     ;
    tslog_blf_read_end                        : Ttslog_blf_read_end        ;
    tslog_blf_seek_object_time                : Ttslog_blf_seek_object_time;
    tslog_blf_to_asc                          : Ttslog_blf_to_asc          ;
    tslog_asc_to_blf                          : Ttslog_asc_to_blf          ;
    // IP functions
    internal_ioip_create                      : TIoIPCreate             ;
    internal_ioip_delete                      : TIoIPDelete             ;
    internal_ioip_enable_tcp_server           : TIoIPEnableTCPServer    ;
    internal_ioip_enable_udp_server           : TIoIPEnableUDPServer    ;
    internal_ioip_connect_tcp_server          : TIoIPConnectTCPServer   ;
    internal_ioip_connect_udp_server          : TIoIPConnectUDPServer   ;
    internal_ioip_disconnect_tcp_server       : TIoIPDisconnectTCPServer;
    internal_ioip_send_buffer_tcp             : TIoIPSendBufferTCP      ;
    internal_ioip_send_buffer_udp             : TIoIPSendBufferUDP      ;
    // blf functions for comment
    tslog_blf_write_realtime_comment          : TTSLog_blf_write_realtime_comment;
    tslog_blf_read_object_w_comment           : TTSLog_blf_read_object_w_comment;
    // IP functions added 2021-07-20
    internal_ioip_receive_tcp_client_response : TIoIPRecvTCPClientResponse;
    internal_ioip_send_tcp_server_response    : TIoIPSendTCPServerResponse;
    internal_ioip_send_udp_broadcast          : TIoIPSendUDPBroadcast;
    internal_ioip_set_udp_server_buffer_size  : TIoIPSetUDPServerBufferSize;
    internal_ioip_receive_udp_client_response : TIoIPRecvUDPClientResponse;
    internal_ioip_send_udp_server_response    : TIoIPSendUDPServerResponse;
    tslog_blf_write_start_w_timestamp         : TTSLog_blf_write_start_w_timestamp;
    tslog_blf_write_set_max_count             : TTSLog_blf_write_set_max_count;
    can_rbs_set_message_cycle_by_name         : TCANRBSSetMessageCycleByName;
    // signal server functions
    sgnsrv_register_can_signal_by_msg_identifier: TSgnSrvRegisterCANSignalByMsgId;
    sgnsrv_register_lin_signal_by_msg_identifier: TSgnSrvRegisterLINSignalByMsgId;
    sgnsrv_register_can_signal_by_msg_name:       TSgnSrvRegisterCANSignalByMsgName;
    sgnsrv_register_lin_signal_by_msg_name:       TSgnSrvRegisterLINSignalByMsgName;
    sgnsrv_get_can_signal_phy_value_latest:       TSgnSrvGetCANSignalPhyValueLatest;
    sgnsrv_get_lin_signal_phy_value_latest:       TSgnSrvGetLINSignalPhyValueLatest;
    sgnsrv_get_can_signal_phy_value_in_msg:       TSgnSrvGetCANSignalPhyValueInMsg;
    sgnsrv_get_lin_signal_phy_value_in_msg:       TSgnSrvGetLINSignalPhyValueInMsg;
    can_rbs_enable                        :       TCANRBSEnable;
    can_rbs_batch_set_start               :       TCANRBSBatchSetStart;
    can_rbs_batch_set_end                 :       TCANRBSBatchSetEnd;
    inject_can_message                    :       TInjectCANMessage;
    inject_lin_message                    :       TInjectLINMessage;
    can_rbs_batch_set_signal              :       TCANRBSBatchSetSignal;
    can_rbs_set_message_direction         :       TCANRBSSetMessageDirection;
    add_precise_cyclic_message            :       Tadd_precise_cyclic_message;
    delete_precise_cyclic_message         :       Tdelete_precise_cyclic_message;
    // pdu container
    pdu_container_set_cycle_count         :       TPDUContainerSetCycleCount;
    pdu_container_set_cycle_by_index      :       TPDUContainerSetCycleByIndex;
    pdu_container_get_cycle_count         :       TPDUContainerGetCycleCount;
    pdu_container_get_cycle_by_index      :       TPDUContainerGetCycleByIndex;
    pdu_container_refresh                 :       TPDUContainerRefresh;
    // rbs fault injection
    can_rbs_fault_injection_clear         :       TCANRBSFaultInjectionClear;
    can_rbs_fault_injection_message_lost  :       TCANRBSFaultInjectionMessageLost;
    can_rbs_fault_injection_signal_alter  :       TCANRBSFaultInjectionSignalAlter;
    // j1939
    j1939_make_id:                         TJ1939MakeId                  ;
    j1939_extract_id:                      TJ1939ExtractId               ;
    j1939_get_pgn:                         TJ1939GetPGN                  ;
    j1939_get_source:                      TJ1939GetSource               ;
    j1939_get_destination:                 TJ1939GetDestination          ;
    j1939_get_priority:                    TJ1939GetPriority             ;
    j1939_get_r:                           TJ1939GetR                    ;
    j1939_get_dp:                          TJ1939GetDP                   ;
    j1939_get_edp:                         TJ1939GetEDP                  ;
    j1939_set_pgn:                         TJ1939SetPGN                  ;
    j1939_set_source:                      TJ1939SetSource               ;
    j1939_set_destination:                 TJ1939SetDestination          ;
    j1939_set_priority:                    TJ1939SetPriority             ;
    j1939_set_r:                           TJ1939SetR                    ;
    j1939_set_dp:                          TJ1939SetDP                   ;
    j1939_set_edp:                         TJ1939SetEDP                  ;
    j1939_get_last_pdu:                    TJ1939GetLastPDU              ;
    j1939_get_last_pdu_as_string:          TJ1939GetLastPDUAsString      ;
    j1939_transmit_pdu_async:              TJ1939TransmitPDUAsync        ;
    j1939_transmit_pdu_sync:               TJ1939TransmitPDUSync         ;
    j1939_transmit_pdu_as_string_async:    TJ1939TransmitPDUAsStringAsync;
    j1939_transmit_pdu_as_string_sync:     TJ1939TransmitPDUAsStringSync ;
    // rbs signal type
    can_rbs_set_normal_signal:             TCANRBSSetNormalSignal        ;
    can_rbs_set_rc_signal:                 TCANRBSSetRCSignal            ;
    can_rbs_set_crc_signal:                TCANRBSSetCRCSignal           ;
    can_rbs_set_rc_signal_with_limit:      TCANRBSSetRCSignalWithLimit   ;
    // 2022-11-15
    get_can_signal_definition_verbose:     TGetCANSignalDefinitionVerbose;
    get_can_signal_definition:             TGetCANSignalDefinition       ;
    // 2022-11-18
    transmit_flexray_async:                        TTransmitFlexRayASync;
    transmit_flexray_sync:                         TTransmitFlexRaySync;
    get_flexray_signal_value:                      TGetFlexRaySignalValue;
    set_flexray_signal_value:                      TSetFlexRaySignalValue;
    internal_register_event_flexray:               TRegisterFlexRayEvent;
    internal_unregister_event_flexray:             TUnregisterFlexRayEvent;
    inject_flexray_frame:                          TInjectFlexRayFrame;
    get_flexray_signal_definition:                 TGetFlexRaySignalDefinition;
    tslog_blf_write_flexray:                       Ttslog_blf_write_flexray;
    sgnsrv_register_flexray_signal_by_frame:       TSgnSrvRegisterFlexRaySignalByFrame;
    sgnsrv_register_flexray_signal_by_frame_name:  TSgnSrvRegisterFlexRaySignalByFrameName;
    sgnsrv_get_flexray_signal_phy_value_latest:    TSgnSrvGetFlexRaySignalPhyValueLatest;
    sgnsrv_get_flexray_signal_phy_value_in_frame:  TSgnSrvGetFlexRaySignalPhyValueInFrame;
    // 2022-11-19
    internal_unregister_events_flexray:            TUnregisterFlexRayEvents;
    internal_register_pretx_event_flexray:         TRegisterPreTxFlexRayEvent;
    internal_unregister_pretx_event_flexray:       TUnregisterPreTxFlexRayEvent;
    internal_unregister_pretx_events_flexray:      TUnregisterPreTxFlexRayEvents;
    // 2022-11-29 flexray rbs
    flexray_rbs_start                       :       TFlexRayRBSStart;
    flexray_rbs_stop                        :       TFlexRayRBSStop;
    flexray_rbs_is_running                  :       TFlexRayRBSIsRunning;
    flexray_rbs_configure                   :       TFlexRayRBSConfigure;
    flexray_rbs_activate_all_clusters       :       TFlexRayRBSActivateAllClusters;
    flexray_rbs_activate_cluster_by_name    :       TFlexRayRBSActivateClusterByName;
    flexray_rbs_activate_ecu_by_name        :       TFlexRayRBSActivateECUByName;
    flexray_rbs_activate_frame_by_name      :       TFlexRayRBSActivateFrameByName;
    flexray_rbs_get_signal_value_by_element :       TFlexRayRBSGetSignalValueByElement;
    flexray_rbs_get_signal_value_by_address :       TFlexRayRBSGetSignalValueByAddress;
    flexray_rbs_set_signal_value_by_element :       TFlexRayRBSSetSignalValueByElement;
    flexray_rbs_set_signal_value_by_address :       TFlexRayRBSSetSignalValueByAddress;
    flexray_rbs_enable                      :       TFlexRayRBSEnable;
    flexray_rbs_batch_set_start             :       TFlexRayRBSBatchSetStart;
    flexray_rbs_batch_set_end               :       TFlexRayRBSBatchSetEnd;
    flexray_rbs_batch_set_signal            :       TFlexRayRBSBatchSetSignal;
    flexray_rbs_set_frame_direction         :       TFlexRayRBSSetFrameDirection;
    flexray_rbs_set_normal_signal           :       TFlexRayRBSSetNormalSignal;
    flexray_rbs_set_rc_signal               :       TFlexRayRBSSetRCSignal;
    flexray_rbs_set_rc_signal_with_limit    :       TFlexRayRBSSetRCSignalWithLimit;
    flexray_rbs_set_crc_signal              :       TFlexRayRBSSetCRCSignal;
    get_lin_signal_value                    :       TMPGetLINSignalValue  ;
    set_lin_signal_value                    :       TMPSetLINSignalValue  ;
    // 2023-04-08 tx without pretx
    transmit_can_async_wo_pretx:      TTransmitCANAsync     ;
    transmit_canfd_async_wo_pretx:    TTransmitCANFDAsync   ;
    transmit_lin_async_wo_pretx:      TTransmitLINAsync     ;
    transmit_flexray_async_wo_pretx:  TTransmitFlexRayASync ;    
    tslog_disable_online_replay_filter: TDisableOnlineReplayFilter;
    tslog_set_online_replay_filter: TSetOnlineReplayFilter;
    set_can_signal_raw_value: TSetCANSignalRawValue;
    get_can_signal_raw_value: TGetCANSignalRawValue;
    set_lin_signal_raw_value: TSetLINSignalRawValue;
    get_lin_signal_raw_value: TGetLINSignalRawValue;
    set_flexray_signal_raw_value: TSetFlexRaySignalRawValue;
    get_flexray_signal_raw_value: TGetFlexRaySignalRawValue;
    flexray_rbs_update_frame_by_header: TFlexRayRBSUpdateFrameByHeader;
    {lin rbs}
    lin_rbs_start                      : TLINRBSStart;
    lin_rbs_stop                       : TLINRBSStop;
    lin_rbs_is_running                 : TLINRBSIsRunning;
    lin_rbs_configure                  : TLINRBSConfigure;
    lin_rbs_activate_all_networks      : TLINRBSActivateAllNetworks;
    lin_rbs_activate_network_by_name   : TLINRBSActivateNetworkByName;
    lin_rbs_activate_node_by_name      : TLINRBSActivateNodeByName;
    lin_rbs_activate_message_by_name   : TLINRBSActivateMessageByName;
    lin_rbs_set_message_delay_time_by_name  : TLINBSSetMessageDelayTimeByName;
    lin_rbs_get_signal_value_by_element: TLINRBSGetSignalValueByElement;
    lin_rbs_get_signal_value_by_address: TLINRBSGetSignalValueByAddress;
    lin_rbs_set_signal_value_by_element: TLINRBSSetSignalValueByElement;
    lin_rbs_set_signal_value_by_address: TLINRBSSetSignalValueByAddress;
    lin_rbs_enable                     : TLINRBSEnable;
    lin_rbs_batch_set_start            : TLINRBSBatchSetStart;
    lin_rbs_batch_set_end              : TLINRBSBatchSetEnd;
    lin_rbs_batch_set_signal           : TLINRBSBatchSetSignal;
    transmit_ethernet_async: TTransmitEthernetASync;
    transmit_ethernet_sync: TTransmitEthernetSync;
    inject_ethernet_frame: TInjectEthernetFrame;
    tslog_blf_write_ethernet: TTSLogBlfWriteEthernet;
    transmit_ethernet_async_wo_pretx: TTransmitEthernetAsyncWoPretx;
    ioip_set_tcp_server_connection_callback: TIoIpSetOnConnectionCallback;
    eth_build_ipv4_udp_packet: TEthBuildIPv4UDPPacket;
    FDummy: array [0..803- 1] of s32; // place holders, TS_COM_PROTO_END
    // internal functions
    function wait_can_message(const ATxCAN: plibcan; const ARxCAN: PLIBCAN; const ATimeoutMs: s32): s32; cdecl;
    function wait_canfd_message(const ATxCANFD: plibcanFD; const ARxCANFD: PLIBCANFD; const ATimeoutMs: s32): s32; cdecl;
    function register_event_can(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function register_event_flexray(const AEvent: TflexrayQueueEvent_Win32): integer; cdecl;
    function unregister_event_can(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function unregister_event_flexray(const AEvent: TflexrayQueueEvent_Win32): integer; cdecl;
    function register_event_canfd(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function unregister_event_canfd(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function register_event_lin(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function unregister_event_lin(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function unregister_events_can(): integer; cdecl;
    function unregister_events_flexray(): integer; cdecl;
    function unregister_events_lin(): integer; cdecl;
    function unregister_events_canfd(): integer; cdecl;
    function unregister_events_all(): integer; cdecl;
    function register_pretx_event_can(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_event_can(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function register_pretx_event_flexray(const AEvent: TflexrayQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_event_flexray(const AEvent: TflexrayQueueEvent_Win32): integer; cdecl;
    function register_pretx_event_canfd(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_event_canfd(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function register_pretx_event_lin(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_event_lin(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_events_can(): integer; cdecl;
    function unregister_pretx_events_flexray(): integer; cdecl;
    function unregister_pretx_events_lin(): integer; cdecl;
    function unregister_pretx_events_canfd(): integer; cdecl;
    function unregister_pretx_events_all(): integer; cdecl;
    function ioip_create(const APortTCP, APortUDP: u16; const AOnTCPDataEvent, AOnUDPDataEvent: TOnIoIPData; AHandle: ps32): s32; cdecl;
    function ioip_delete(const AHandle: s32): s32; cdecl;
    function ioip_enable_tcp_server(const AHandle: s32; const AEnable: Boolean): s32; cdecl;
    function ioip_enable_udp_server(const AHandle: s32; const AEnable: Boolean): s32; cdecl;
    function ioip_connect_tcp_server(const AHandle: s32; const AIpAddress: PAnsiChar; const APort: u16): s32; cdecl;
    function ioip_connect_udp_server(const AHandle: s32; const AIpAddress: PAnsiChar; const APort: u16): s32; cdecl;
    function ioip_disconnect_tcp_server(const AHandle: s32): s32; cdecl;
    function ioip_send_buffer_tcp(const AHandle: s32; const APointer: Pointer; const ASize: s32): s32; cdecl;
    function ioip_send_buffer_udp(const AHandle: s32; const APointer: Pointer; const ASize: s32): s32; cdecl;
    function ioip_receive_tcp_client_response(const AHandle: s32; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32): s32; cdecl;
    function ioip_send_tcp_server_response(const AHandle: s32; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; cdecl;
    function ioip_send_udp_broadcast(const AHandle: s32; const APort: Word; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; cdecl;
    function ioip_set_udp_server_buffer_size(const AHandle: s32; const ASize: s32): s32; cdecl;
    function ioip_receive_udp_client_response(const AHandle: s32; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32): s32; cdecl;
    function ioip_send_udp_server_response(const AHandle: s32; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; cdecl;
  end;
  PTSCOM = ^TTSCOM;

  // TSMaster test feature in C script
  TTSTest = packed record // C type
    FObj: Pointer;
    internal_set_verdict_ok                 : TTestSetVerdictOK;
    internal_set_verdict_nok                : TTestSetVerdictNOK;
    internal_set_verdict_cok                : TTestSetVerdictCOK;
    internal_log                            : TTestLogger;
    internal_write_result_string            : TTestWriteResultString;
    internal_write_result_value             : TTestWriteResultValue;
    check_error_begin                       : TTestCheckErrorBegin;
    check_error_end                         : TTestCheckErrorEnd;
    internal_write_result_image             : TTestWriteResultImage;
    internal_retrieve_current_result_folder : TTestRetrieveCurrentResultFolder;
    check_test_terminate                    : TTestCheckTerminate;
    FCheckVerdict                           : TTestCheckVerdict;
    signal_checker_clear: TTestSignalCheckerClear;
    signal_checker_add_check_with_time: TTestSignalCheckerAddCheckWithTime;
    signal_checker_add_check_with_trigger: TTestSignalCheckerAddCheckWithTrigger;
    signal_checker_add_statistics_with_time: TTestSignalCheckerAddStatisticsWithTime;
    signal_checker_add_statistics_with_trigger: TTestSignalCheckerAddStatisticsWithTrigger;
    signal_checker_get_result: TTestSignalCheckerGetResult;
    signal_checker_enable: TTestSignalCheckerEnable;
    internal_debug_log_info: TTestDebugLog;
    signal_checker_add_rising_edge_with_time: TTestSignalCheckerAddRisingEdgeWithTime;
    signal_checker_add_rising_edge_with_trigger: TTestSignalCheckerAddRisingEdgeWithTrigger;
    signal_checker_add_falling_edge_with_time: TTestSignalCheckerAddFallingEdgeWithTime;
    signal_checker_add_falling_edge_with_trigger: TTestSignalCheckerAddFallingEdgeWithTrigger;
    signal_checker_add_monotony_rising_with_time: TTestSignalCheckerAddMonotonyRisingWithTime;
    signal_checker_add_monotony_rising_with_trigger: TTestSignalCheckerAddMonotonyRisingWithTrigger;
    signal_checker_add_monotony_falling_with_time: TTestSignalCheckerAddMonotonyFallingWithTime;
    signal_checker_add_monotony_falling_with_trigger: TTestSignalCheckerAddMonotonyFallingWithTrigger;
    signal_checker_add_follow_with_time: TTestSignalCheckerAddFollowWithTime;
    signal_checker_add_follow_with_trigger: TTestSignalCheckerAddFollowWithTrigger;
    signal_checker_add_jump_with_time: TTestSignalCheckerAddJumpWithTime;
    signal_checker_add_jump_with_trigger: TTestSignalCheckerAddJumpWithTrigger;
    signal_checker_add_unchange_with_time: TTestSignalCheckerAddUnChangeWithTime;
    signal_checker_add_unchange_with_trigger: TTestSignalCheckerAddUnchangeWithTrigger;
    signal_checker_check_statistics: TTestSignalCheckerCheckStatistics;
    log_value: TTestLogValue;
    log_string: TTestLogString;    
    FDummy: array [0..969-1] of s32; // place holders, TS_TEST_PROTO_END
    procedure set_verdict_ok(const AStr: PAnsiChar); cdecl;
    procedure set_verdict_nok(const AStr: PAnsiChar); cdecl;
    procedure set_verdict_cok(const AStr: PAnsiChar); cdecl;
    function  log(const AStr: PAnsiChar; const ALevel: s32): s32; cdecl;
    function  debug_log_info(const AFile: pansichar; const AFunc: pansichar; const ALine: s32; const AStr: pansichar; const ALevel: Integer): s32; cdecl;
    procedure write_result_string(const AName: PAnsiChar; const AValue: PAnsiChar; const ALevel: s32); cdecl;
    procedure write_result_value(const AName: PAnsiChar; const AValue: Double; const ALevel: s32); cdecl;
    function  write_result_image(const AName: PAnsiChar; const AImageFileFullPath: PAnsiChar): s32; cdecl;
    function  retrieve_current_result_folder(AFolder: PPAnsiChar): s32; cdecl;
  end;
  PTSTest = ^TTSTest;

  // TSMaster Configuration
  TTSMasterConfiguration = packed record // C type
    FTSApp: TTSApp;
    FTSCOM: TTSCOM;
    FTSTest: TTSTest;
    // place holders
    FDummy: array [0..3000-1] of s32;
  end;
  PTSMasterConfiguration = ^TTSMasterConfiguration;

  // Mini program callback prototype
  TTSMP_Step_Function = procedure; cdecl;
  TTSMP_On_CAN_Rx_Callback = procedure (const ACAN: plibcan); cdecl;
  TTSMP_On_CAN_Tx_Callback = procedure (const ACAN: plibcan); cdecl;
  TTSMP_On_CAN_PreTx_Callback = procedure (const ACAN: plibcan); cdecl;
  TTSMP_On_LIN_Rx_Callback = procedure (const ALIN: pliblin); cdecl;
  TTSMP_On_LIN_Tx_Callback = procedure (const ALIN: pliblin); cdecl;
  TTSMP_On_LIN_PreTx_Callback = procedure (const ALIN: pliblin); cdecl;
  TTSMP_On_CANFD_Rx_Callback = procedure (const ACANFD: plibcanfd); cdecl;
  TTSMP_On_CANFD_Tx_Callback = procedure (const ACANFD: plibcanfd); cdecl;
  TTSMP_On_CANFD_PreTx_Callback = procedure (const ACANFD: plibcanfd); cdecl;
  TTSMP_On_Var_Change = procedure (); cdecl;
  TTSMP_On_Timer_Event = procedure (); cdecl;
  TTSMP_On_Start_Event = procedure (); cdecl;
  TTSMP_On_Stop_Event = procedure (); cdecl;
  TTSMP_On_Shortcut_Event = procedure (const AShortcut: s32); cdecl;
  TTSMP_On_Custom_Event = procedure ({can be any kind}); cdecl;
  Tinitialize_miniprogram = function (const AConf: PTSMasterConfiguration): s32; stdcall;
  Tfinalize_miniprogram = function: s32; stdcall;
  TRegTSMasterFunction = function (const AObj: Pointer; const AFuncType: PAnsiChar; const AFuncName: PAnsiChar; const AData: PAnsiChar; const AFuncPointer: Pointer; const ADescription: PAnsiChar): boolean; stdcall;
  Tretrieve_mp_abilities = function (const AObj: pointer; const AReg: TRegTSMasterFunction): s32; stdcall;

function GetStringFromC(const AStr: PAnsiChar): string;
function GetCStringFromString_OnlyOneParameter(const AStr: string): PAnsiChar;
function CheckVariantEmptyOrNull(const Value: Variant): Boolean;
procedure LogInfo(const AApp: TTSApp; const AString: string);
procedure LogError(const AApp: TTSApp; const AString: string);

const
  // sync. with TSimFunctionParameterType
  vSimFunctionParameterTypeNames: array [0..integer(high(TSimFunctionParameterType))] of string = (
    's8', 'u8', 's16', 'u16', 's32', 'u32', 'float', 'double',
    'ps8', 'pu8', 'ps16', 'pu16', 'ps32', 'pu32', 'pfloat', 'pdouble',
    'bool', 'char*', 'pbool', 'char**', 'ppdouble',
    'PCAN', 'PCANFD', 'PLIN', 'PLIBTSMapping', 'TCANFDControllerType', 'TCANFDControllerMode',
    's64', 'u64', 'ps64', 'pu64', 'PLIBSystemVarDef', 'pvoid', 'ppvoid',
    'TOnIoIPData', 'double*', 'float*', 'int*', 's32*', 'uint*', 'u32*',
    'Prealtime_comment_t', 'TLogLevel', 'TCheckResultCallback', 'double**', 'pchar',
    'PCANSignal', 'TSystemVar', 'float**', 'pps32', 'bool*', 'PAutomationModuleRunningState',
    'TSTIMSignalStatus', 'PSTIMSignalStatus', 'TSignalType', 'TSignalCheckKind',
    'TSignalStatisticsKind', 'TReplayPhase', 'TSymbolMappingDirection', 'PFlexRaySignal',
    'PFlexRay', 'PLINSignal', 'PDBProperties', 'PDBECUProperties', 'PDBFrameProperties',
    'PDBSignalProperties', 'TReadProgressCallback'
  );

implementation

uses
  System.Variants;

const
  API_RETURN_GENERIC_FAIL = 82;

{ TMPVarInt }

function TMPVarInt.GetValue: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := FGet(fobj);

end;

procedure TMPVarInt.SetValue(const AValue: s32);
begin
  if not Assigned(fobj) then exit();
  FSet(FObj, AValue);

end;

{ TMPVarDouble }

function TMPVarDouble.GetValue: Double;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := FGet(fobj);

end;

procedure TMPVarDouble.SetValue(const AValue: Double);
begin
  if not Assigned(fobj) then exit;
  FSet(FObj, AValue);

end;

{ TMPVarString }

function TMPVarString.GetValue: PAnsiChar;
begin
  if not Assigned(fobj) then exit(nil);
  Result := FGet(fobj);

end;

procedure TMPVarString.SetValue(const AValue: PAnsiChar);
begin
  if not Assigned(fobj) then exit;
  FSet(FObj, AValue);

end;

{ TMPVarCAN }

function TMPVarCAN.GetValue: TLIBCAN;
begin
  if not Assigned(fobj) then begin
    result.SetStdId(0, 0);
    exit();
  end;
  Result := FGet(fobj);

end;

procedure TMPVarCAN.SetValue(const AValue: TLIBCAN);
begin
  if not Assigned(fobj) then exit;
  FSet(fobj, @avalue);

end;

{ TMPVarCANFD }

function TMPVarCANFD.GetValue: TLIBCANfd;
begin
  if not Assigned(fobj) then begin
    result.SetStdId(0, 0);
    exit;
  end;
  result := FGet(fobj);

end;

procedure TMPVarCANFD.SetValue(const AValue: TLIBCANfd);
begin
  if not Assigned(fobj) then exit;
  FSet(FObj, @avalue);

end;

{ TMPVarLIN }

function TMPVarLIN.GetValue: TLIBLIN;
begin
  if not Assigned(fobj) then begin
    result.setid(0, 0);
    exit();
  end;
  Result := FGet(fobj);

end;

procedure TMPVarLIN.SetValue(const AValue: TLIBLIN);
begin
  if not Assigned(fobj) then exit;
  FSet(fobj, @avalue);

end;

{ TMPTimerMS }

function TMPTimerMS.GetInterval: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := FGetInterval(fobj);

end;

procedure TMPTimerMS.SetInterval(const AInterval: s32);
begin
  if not Assigned(fobj) then exit;
  FSetInterval(FObj, AInterval);

end;

procedure TMPTimerMS.Start;
begin
  if not Assigned(fobj) then exit;
  FStart(fobj);

end;

procedure TMPTimerMS.Stop;
begin
  if not Assigned(fobj) then exit;
  FStop(FObj);

end;

{ TTSApp }

function TTSApp.check(const AErrorCode: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_check(FObj, AErrorCode);

end;

function TTSApp.check_terminate: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_check_terminate(FObj);

end;

function TTSApp.debug_log(const AFile, AFunc: pansichar; const ALine: s32;
  const AStr: pansichar; const ALevel: Integer): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_debug_log(FObj, afile, afunc, aline, astr, alevel);

end;

function TTSApp.end_log: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_end_log(fobj);

end;

function TTSApp.set_check_failed_terminate(const AToTerminate: Boolean): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_set_check_failed_terminate(FObj, AToTerminate);

end;

function TTSApp.set_thread_priority(const APriorty: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_set_thread_priority(FObj, APriorty);

end;

function TTSApp.start_log: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_start_log(FObj);

end;

procedure TTSApp.terminate_application;
begin
  if not Assigned(FObj) then exit;
  internal_terminate_application(FObj);

end;

function TTSApp.wait(const ATimeMs: s32; const AMessage: PAnsiChar): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_wait(fobj, ATimeMs, AMessage);

end;

function TTSApp.wait_with_dialog(const ATitle, AMessage: pansichar;
  const ApResult: pboolean; const ApProgress100: psingle): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_wait_with_dialog(fobj, atitle, amessage, apresult, approgress100);

end;

{ TTSCOM }

function TTSCOM.ioip_connect_tcp_server(const AHandle: s32;
  const AIpAddress: PAnsiChar; const APort: u16): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_connect_tcp_server(fObj, AHandle, AIpAddress, APort);

end;

function TTSCOM.ioip_connect_udp_server(const AHandle: s32;
  const AIpAddress: PAnsiChar; const APort: u16): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_connect_udp_server(fObj, AHandle, AIpAddress, APort);

end;

function TTSCOM.ioip_create(const APortTCP, APortUDP: u16;
  const AOnTCPDataEvent, AOnUDPDataEvent: TOnIoIPData; AHandle: ps32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_create(fObj, APortTCP, APortUDP, AOnTCPDataEvent, AOnUDPDataEvent, AHandle);

end;

function TTSCOM.ioip_delete(const AHandle: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_delete(fObj, AHandle);

end;

function TTSCOM.ioip_disconnect_tcp_server(const AHandle: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_disconnect_tcp_server(fObj, AHandle);

end;

function TTSCOM.ioip_enable_tcp_server(const AHandle: s32;
  const AEnable: Boolean): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_enable_tcp_server(fObj, AHandle, AEnable);

end;

function TTSCOM.ioip_enable_udp_server(const AHandle: s32;
  const AEnable: Boolean): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_enable_udp_server(fObj, AHandle, AEnable);

end;

function TTSCOM.ioip_receive_tcp_client_response(
  const AHandle, ATimeoutMs: s32; const ABufferToReadTo: Pointer;
  const AActualSize: ps32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_receive_tcp_client_response(fObj, AHandle, ATimeoutMs, ABufferToReadTo, AActualSize);

end;

function TTSCOM.ioip_receive_udp_client_response(
  const AHandle, ATimeoutMs: s32; const ABufferToReadTo: Pointer;
  const AActualSize: ps32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_receive_udp_client_response(fObj, AHandle, ATimeoutMs, ABufferToReadTo, AActualSize);

end;

function TTSCOM.ioip_send_buffer_tcp(const AHandle: s32;
  const APointer: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_buffer_tcp(fObj, AHandle, apointer, ASize);

end;

function TTSCOM.ioip_send_buffer_udp(const AHandle: s32;
  const APointer: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_buffer_udp(fObj, AHandle, apointer, ASize);

end;

function TTSCOM.ioip_send_tcp_server_response(
  const AHandle: s32; const ABufferToWriteFrom: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_tcp_server_response(fObj, AHandle, ABufferToWriteFrom, ASize);

end;

function TTSCOM.ioip_send_udp_broadcast(const AHandle: s32;
  const APort: Word; const ABufferToWriteFrom: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_udp_broadcast(fObj, AHandle, APort, ABufferToWriteFrom, ASize);

end;

function TTSCOM.ioip_send_udp_server_response(
  const AHandle: s32; const ABufferToWriteFrom: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_udp_server_response(fObj, AHandle, ABufferToWriteFrom, ASize);

end;

function TTSCOM.ioip_set_udp_server_buffer_size(
  const AHandle, ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_set_udp_server_buffer_size(fObj, AHandle, ASize);

end;

function TTSCOM.register_event_can(const AEvent: TCANQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_register_event_can(FObj, AEvent);

end;

function TTSCOM.register_event_canfd(
  const AEvent: TCANfdQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_register_event_canfd(fobj, AEvent);

end;

function TTSCOM.register_event_flexray(
  const AEvent: TflexrayQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_register_event_flexray(FObj, AEvent);

end;

function TTSCOM.register_event_lin(const AEvent: TliNQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_register_event_lin(FObj, AEvent);

end;

function TTSCOM.register_pretx_event_can(
  const AEvent: TCANQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_register_pretx_event_can(FObj, AEvent);

end;

function TTSCOM.register_pretx_event_canfd(
  const AEvent: TCANfdQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_register_pretx_event_canfd(fobj, AEvent);

end;

function TTSCOM.register_pretx_event_flexray(
  const AEvent: TflexrayQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_register_pretx_event_flexray(FObj, AEvent);

end;

function TTSCOM.register_pretx_event_lin(
  const AEvent: TliNQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_register_pretx_event_lin(FObj, AEvent);

end;

function TTSCOM.unregister_events_all: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_events_all(FObj);

end;

function TTSCOM.unregister_pretx_events_all: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_pretx_events_all(FObj);

end;

function TTSCOM.unregister_event_can(const AEvent: TCANQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_event_can(FObj, AEvent);

end;

function TTSCOM.unregister_events_can: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_events_can(FObj);

end;

function TTSCOM.unregister_event_canfd(
  const AEvent: TCANfdQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_event_canfd(fobj, aevent);

end;

function TTSCOM.unregister_event_flexray(
  const AEvent: TflexrayQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_event_flexray(FObj, AEvent);

end;

function TTSCOM.unregister_events_canfd: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_events_canfd(FObj);

end;

function TTSCOM.unregister_events_flexray: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_events_flexray(FObj);

end;

function TTSCOM.unregister_event_lin(const AEvent: TliNQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_event_lin(fobj, AEvent);

end;

function TTSCOM.unregister_events_lin: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_events_lin(FObj);

end;

function TTSCOM.unregister_pretx_event_can(
  const AEvent: TCANQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_pretx_event_can(FObj, AEvent);

end;

function TTSCOM.unregister_pretx_events_can: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_pretx_events_can(FObj);

end;

function TTSCOM.unregister_pretx_event_canfd(
  const AEvent: TCANfdQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_pretx_event_canfd(fobj, aevent);

end;

function TTSCOM.unregister_pretx_event_flexray(
  const AEvent: TflexrayQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_pretx_event_flexray(FObj, AEvent);

end;

function TTSCOM.unregister_pretx_events_canfd: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_pretx_events_canfd(FObj);

end;

function TTSCOM.unregister_pretx_events_flexray: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_pretx_events_flexray(FObj);

end;

function TTSCOM.unregister_pretx_event_lin(
  const AEvent: TliNQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_pretx_event_lin(fobj, AEvent);

end;

function TTSCOM.unregister_pretx_events_lin: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_unregister_pretx_events_lin(FObj);

end;

function TTSCOM.wait_canfd_message(const ATxCANFD, ARxCANFD: PLIBCANFD;
  const ATimeoutMs: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_wait_canfd_message(FObj, ATxCANFD, ARxCANFD, ATimeoutMs);

end;

function TTSCOM.wait_can_message(const ATxCAN, ARxCAN: PLIBCAN;
  const ATimeoutMs: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_wait_can_message(FObj, ATxCAN, ARxCAN, ATimeoutMs);

end;

{ TTSTest }

function TTSTest.debug_log_info(const AFile, AFunc: pansichar; const ALine: s32;
  const AStr: pansichar; const ALevel: Integer): s32;
begin
  if not Assigned(FObj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_debug_log_info(FObj, afile, afunc, aline, astr, ALevel);

end;

function TTSTest.log(const AStr: PAnsiChar; const ALevel: s32): s32;
begin
  if not Assigned(FObj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_log(FObj, astr, ALevel);

end;

function TTSTest.retrieve_current_result_folder(AFolder: PPAnsiChar): s32;
begin
  if not Assigned(FObj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_retrieve_current_result_folder(FObj, afolder);

end;

procedure TTSTest.set_verdict_cok(const AStr: PAnsiChar);
begin
  if not Assigned(FObj) then exit;
  internal_set_verdict_cok(FObj, astr);

end;

procedure TTSTest.set_verdict_nok(const AStr: PAnsiChar);
begin
  if not Assigned(FObj) then exit;
  internal_set_verdict_nok(FObj, astr);

end;

procedure TTSTest.set_verdict_ok(const AStr: PAnsiChar);
begin
  if not Assigned(FObj) then exit;
  internal_set_verdict_ok(FObj, astr);

end;

function TTSTest.write_result_image(const AName,
  AImageFileFullPath: PAnsiChar): s32;
begin
  if not Assigned(FObj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_write_result_image(FObj, aname, AImageFileFullPath);

end;

procedure TTSTest.write_result_string(const AName, AValue: PAnsiChar;
  const ALevel: s32);
begin
  if not Assigned(FObj) then exit;
  internal_write_result_string(FObj, AName, avalue, ALevel);

end;

procedure TTSTest.write_result_value(const AName: PAnsiChar; const AValue: Double;
  const ALevel: s32);
begin
  if not Assigned(FObj) then exit;
  internal_write_result_value(FObj, AName, avalue, ALevel);

end;

function GetStringFromC(const AStr: PAnsiChar): string;
begin
  Result := string(AnsiString(AStr));

end;

var
  vAnsistringReturn: AnsiString;
function GetCStringFromString_OnlyOneParameter(const AStr: string): PAnsiChar;
begin
  vAnsistringReturn := AnsiString(astr);
  if Length(vAnsistringReturn) = 0 then begin
    result := nil;
  end else begin
    Result := @vAnsistringReturn[1];
  end;

end;

function CheckVariantEmptyOrNull(const Value: Variant): Boolean;
begin
  Result := VarIsClear(Value) or VarIsEmpty(Value) or VarIsNull(Value) or (VarCompareValue(Value, Unassigned) = vrEqual);
  if (not Result) and VarIsStr(Value) then
    Result := Value = '';

end;

procedure LogInfo(const AApp: TTSApp; const AString: string);
begin
  aapp.Log_text(GetCStringFromString_OnlyOneParameter(astring), LVL_INFO);

end;

procedure LogError(const AApp: TTSApp; const AString: string);
begin
  aapp.Log_text(GetCStringFromString_OnlyOneParameter(astring), LVL_ERROR);

end;

procedure CheckMPRecordSize;
const
  SIZE_TSAPP = 4216;
  SIZE_TSCOM = 4128;
  SIZE_TSTEST = 4028;
  SIZE_TSMASTERCONFIGURATION = 24372;
begin
{$IFDEF DEBUG}
  OutputDebugString(PChar('TTSApp size = ' + IntToStr(SizeOf(ttsapp))));
  OutputDebugString(PChar('TTSCOM size = ' + IntToStr(SizeOf(TTSCOM))));
  OutputDebugString(PChar('TTSTest size = ' + IntToStr(SizeOf(ttstest))));
  OutputDebugString(PChar('TTSMasterConfiguration size = ' + IntToStr(SizeOf(TTSMasterConfiguration))));
  // check size
  Assert(SizeOf(ttsapp) = SIZE_TSAPP, 'TTSApp size should be ' + SIZE_TSAPP.tostring);
  Assert(SizeOf(TTSCOM) = SIZE_TSCOM, 'TTSApp size should be ' + SIZE_TSCOM.tostring);
  Assert(SizeOf(ttstest) = SIZE_TSTEST, 'TTSApp size should be ' + SIZE_TSTEST.tostring);
  Assert(SizeOf(TTSMasterConfiguration) = SIZE_TSMASTERCONFIGURATION, 'TTSApp size should be ' + SIZE_TSMASTERCONFIGURATION.tostring);

{$ENDIF}

end;

initialization
  CheckMPRecordSize;

end.

