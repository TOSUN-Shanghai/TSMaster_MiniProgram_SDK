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
    FFRSgnType: uint8;    // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
    FCompuMethod: uint8;  // 0 - Identical, 1 - Linear, 2 - Scale Linear, 3 - TextTable, 4 - TABNoIntp, 5 - Formula
    FReserved: uint8;
    FIsIntel: Boolean;
    FStartBit: int32;
    FUpdateBit: int32;
    FLength: int32;
    FFactor: Double;
    FOffset: Double;
    FActualStartBit: Int32;  // added 2023-07-18
    FActualUpdateBit: Int32; // added 2023-07-18
  end;
  PMPFlexRaySignal = ^TMPFlexRaySignal;

  // TMPDBProperties for database properties, size = 1048
  TMPDBProperties = packed record
    FDBIndex: int32;
    FSignalCount: int32;
    FFrameCount: int32;
    FECUCount: int32;
    FSupportedChannelMask: uint64;
    FName: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FComment: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FFlags: UInt32;                                        // Bit 0: whether generate mp header
    FDBId: uint32;                                         // database id for legacy support
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
    FCycleTimeMs: u16;
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
    FDBIndex: int32;
    FECUIndex: int32;
    FFrameIndex: int32;
    FSignalIndex: int32;
    FIsTx: uint8;
    FReserved1: uint8;
    FReserved2: uint8;
    FReserved3: uint8;
    FSignalType: TSignalType;
    FCANSignal: TMPCANSignal;
    FLINSignal: TMPLINSignal;
    FFlexRaySignal: TMPFlexRaySignal;
    FParentFrameId: int32;
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
  TTSAppDisconnectApplication = function(const AObj: Pointer): integer; stdcall;
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
  TWriteTextFileStart = function(const AFileName: PAnsiChar; AHandle: PNativeInt): s32; stdcall;
  TWriteTextFileLine = function(const AHandle: NativeInt; const ALine: PAnsiChar): s32; stdcall;
  TWriteTextFileLineWithDoubleArray = function(const AHandle: NativeInt; const AArray: PDouble; const ACount: s32): s32; stdcall;
  TWriteTextFileLineWithStringArray = function(const AHandle: NativeInt; const AArray: PPAnsiChar; const ACount: s32): s32; stdcall;
  TWriteTextFileEnd = function(const AHandle: NativeInt): s32; stdcall;
  TReadTextFileStart = function(const AFileName: pansichar; AHandle: PNativeInt): s32; stdcall;
  TReadTextFileLine = function(const AHandle: NativeInt; const ACapacity: s32; AReadCharCount: ps32; ALine: pansichar): s32; stdcall;
  TReadTextFileEnd = function(const AHandle: NativeInt): s32; stdcall;
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
  TWriteMatFileStart = function(const AFileName: PAnsiChar; AHandle: PNativeInt): s32; stdcall;
  TWriteMatFileVariableDouble = function(const AHandle: NativeInt; const AVarName: PAnsiChar; const AValue: Double): s32; stdcall;
  TWriteMatFileVariableString = function(const AHandle: NativeInt; const AVarName: PAnsiChar; const AValue: PAnsiChar): s32; stdcall;
  TWriteMatFileVariableDoubleArray = function(const AHandle: NativeInt; const AVarName: PAnsiChar; const AArray: PDouble; const ACount: s32): s32; stdcall;
  TWriteMatFileEnd = function(const AHandle: NativeInt): s32; stdcall;
  TReadMatFileStart = function(const AFileName: PAnsiChar; AHandle: PNativeInt): s32; stdcall;
  TReadMatFileVariableCount = function(const AHandle: NativeInt; const AVarName: PAnsiChar; ACount: ps32): s32; stdcall;
  TReadMatFileVariableString = function(const AHandle: NativeInt; const AVarName: PAnsiChar; AValue: PPAnsiChar; const ACapacity: s32): s32; stdcall;
  TReadMatFileVariableDouble = function(const AHandle: NativeInt; const AVarName: PAnsiChar; const AValue: PDouble; const AStartIdx: s32; const ACount: s32): s32; stdcall;
  TReadMatFileEnd = function(const AHandle: NativeInt): s32; stdcall;
  // ini file
  TIniCreate = function(const AFileName: PAnsiChar; AHandle: PNativeInt): s32; stdcall;
  TIniWriteInt32 = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: s32): s32; stdcall;
  TIniWriteInt64 = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: s64): s32; stdcall;
  TIniWriteBool = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: Boolean): s32; stdcall;
  TIniWriteFloat = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: Double): s32; stdcall;
  TIniWriteString = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; const AValue: PAnsiChar): s32; stdcall;
  TIniReadInt32 = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: ps32; const ADefault: s32): s32; stdcall;
  TIniReadInt64 = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: ps64; const ADefault: s64): s32; stdcall;
  TIniReadBool = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: PBoolean; const ADefault: boolean): s32; stdcall;
  TIniReadFloat = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: PDouble; const ADefault: double): s32; stdcall;
  TIniReadString = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar; AValue: PAnsiChar; ACapacity: ps32; const ADefault: pansichar): s32; stdcall;
  TIniSectionExists = function(const AHandle: NativeInt; const ASection: PAnsiChar): s32; stdcall;
  TIniKeyExists = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar): s32; stdcall;
  TIniDeleteKey = function(const AHandle: NativeInt; const ASection: PAnsiChar; const AKey: PAnsiChar): s32; stdcall;
  TIniDeleteSection = function(const AHandle: NativeInt; const ASection: PAnsiChar): s32; stdcall;
  TIniClose = function(const AHandle: NativeInt): s32; stdcall;
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
  TUIGetMainWindowHandle = function(AHandle: PNativeInt): s32; stdcall;
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
  TRegisterSystemVarChangeEvent = function(const ACompleteName: pansichar; const AEvent: TlibOnSysVarChange): s32; stdcall;
  TUnRegisterSystemVarChangeEvent = function(const ACompleteName: pansichar; const AEvent: TlibOnSysVarChange): s32; stdcall;
  TUnRegisterSystemVarChangeEvents = function(const AEvent: TlibOnSysVarChange): s32; stdcall;
  TCallSystemAPI = function(const AAPIName: pansichar; const AArgCount: int32; const AArgCapacity: int32; AArgs: PPAnsiChar): s32; stdcall;
  TCallLibraryAPI = function(const AAPIName: pansichar; const AArgCount: int32; const AArgCapacity: int32; AArgs: PPAnsiChar): s32; stdcall;
  TIniReadStringWoQuotes = function(const AHandle: NativeInt; const ASection: pansichar; const AKey: pansichar; const AValue: pansichar; AValueCapacity: pInt32; const ADefault: pansichar): s32; stdcall;
  TUIGraphicsAddSignal = function(const AWindowCaption: pansichar; const AIdxSplit: int32; const ASgnType: TSignalType; const ASignalAddress: pansichar): s32; stdcall;
  TUIGraphicsClearSignals = function(const AWindowCaption: pansichar; const AIdxSplit: int32): s32; stdcall;
  TGPGLoadExcel = function(const AFileName: pansichar; AGraphicProgramName: PPAnsiChar; ASubModuleName: PPAnsiChar): s32; stdcall;
  TRunProcedure = function(const AProcedure: TCProcedure): s32; stdcall;
  TOpenHelpDoc = function(const AFileNameWoSuffix: pansichar; const ATitle: pansichar): s32; stdcall;
  TGetLangString = function(const AEnglishStr: pansichar; const AIniSection: pansichar; ATranslatedStr: PPAnsiChar): s32; stdcall;
  TConvertBlfToCsv = function(const ABlfFile: pansichar; const ACSVFile: pansichar; const AToTerminate: PBoolean): s32; stdcall;
  TConvertBlfToCsvWFilter = function(const ABlfFile: pansichar; const ACSVFile: pansichar; const AFilterConf: pansichar; const AToTerminate: PBoolean): s32; stdcall;
  TStartLogWFileName = function(const AObj: Pointer; const AFileName: pansichar): s32; stdcall;
  TConvertBlfToMatWFilter = function(const ABlfFile: pansichar; const AMatFile: pansichar; const AFilterConf: pansichar; const AToTerminate: PBoolean): s32; stdcall;
  TConvertASCToMatWFilter = function(const AASCFile: pansichar; const AMatFile: pansichar; const AFilterConf: pansichar; const AToTerminate: PBoolean): s32; stdcall;
  TConvertASCToCSVWFilter = function(const AASCFile: pansichar; const ACSVFile: pansichar; const AFilterConf: pansichar; const AToTerminate: PBoolean): s32; stdcall;
  TSetDebugLogLevel = function(const ALevel: Integer): s32; stdcall;
  TGetFormUniqueId = function(const AClassName: pansichar; const AFormIdx: int32; AUniqueId: pInt64): s32; stdcall;
  Tpanel_clear_control = function(const APanelName: pansichar; const AControlName: pansichar): s32; stdcall;
  Tset_form_unique_id = function(const AOldId: int64; const ANewId: int64): s32; stdcall;
  Tshow_form = function(const AFormCaption: pansichar; const AShow: boolean): s32; stdcall;
  Tkill_form = function(const AFormCaption: pansichar): s32; stdcall;
  Tplace_form = function(const AFormCaption: pansichar; const ALeft: int32; const ATop: int32; const AWidth: int32; const AHeight: int32): s32; stdcall;
  Ttoggle_mdi_form = function(const AFormCaption: pansichar; const AIsMDI: boolean): s32; stdcall;
  Tget_language_id = function(AId: pInt32): s32; stdcall;
  Tcreate_form = function(const AClassName: pansichar; const AForceCreate: boolean; AFormId: pint64): s32; stdcall;
  Tset_form_caption = function(const AOldCaption: pansichar; const ANewCaption: pansichar): s32; stdcall;
  Tenter_critical_section = function(): s32; stdcall;
  Tleave_critical_section = function(): s32; stdcall;
  Ttry_enter_critical_section = function(): s32; stdcall;
  Tdb_load_can_db = function(const ADBFileName: pansichar; const ASupportedChannelsBased0: pansichar; AId: pInt32): s32; stdcall;
  Tdb_load_lin_db = function(const ADBFileName: pansichar; const ASupportedChannelsBased0: pansichar; AId: pInt32): s32; stdcall;
  Tdb_load_flexray_db = function(const ADBFileName: pansichar; const ASupportedChannelsBased0: pansichar; AId: pInt32): s32; stdcall;
  Tdb_unload_can_db = function(const AId: int32): s32; stdcall;
  Tdb_unload_lin_db = function(const AId: int32): s32; stdcall;
  Tdb_unload_flexray_db = function(const AId: int32): s32; stdcall;
  Tdb_unload_can_dbs = function(): s32; stdcall;
  Tdb_unload_lin_dbs = function(): s32; stdcall;
  Tdb_unload_flexray_dbs = function(): s32; stdcall;
  TSecurityUpdateNewKeySync = function(const AChnIdx: int32; const AOldKey: pansichar; const AOldKeyLength: byte; const ANewKey: pansichar; const ANewKeyLength: byte; const ATimeoutMS: int32): s32; stdcall;
  TSecurityUnlockWriteAuthoritySync = function(const AChnIdx: int32; const AKey: pansichar; const AKeyLength: byte; const ATimeoutMS: int32): s32; stdcall;
  TSecurityUnlockWriteAuthorityASync = function(const AChnIdx: int32; const AKey: pansichar; const AKeyLength: byte): s32; stdcall;
  TSecurityWriteStringSync = function(const AChnIdx: int32; const ASlotIndex: int32; const AString: pansichar; const AStringLength: byte; const ATimeoutMs: int32): s32; stdcall;
  TSecurityWriteStringASync = function(const AChnIdx: int32; const ASlotIndex: int32; const AString: pansichar; const AStringLength: byte): s32; stdcall;
  TSecurityReadStringSync = function(const AChnIdx: int32; const ASlotIndex: int32; const AString: pansichar; const AStringLength: pbyte; const ATimeoutMS: int32): s32; stdcall;
  TSecurityUnlockEncChannelSync = function(const AChnIdx: int32; const ASlotIndex: int32; const AString: pansichar; const AStringLength: byte; const ATimeoutMS: int32): s32; stdcall;
  TSecurityUnlockEncChannelASync = function(const AChnIdx: int32; const ASlotIndex: int32; const AString: pansichar; const AStringLength: byte): s32; stdcall;
  TSecurityEncryptStringSync = function(const AChnIdx: int32; const ASlotIndex: int32; const AString: pansichar; const AStringLength: pbyte; const ATimeoutMS: int32): s32; stdcall;
  TSecurityDecryptStringSync = function(const AChnIdx: int32; const ASlotIndex: int32; const AString: pansichar; const AStringLength: pbyte; const ATimeoutMS: int32): s32; stdcall;
  Tset_channel_timestamp_deviation_factor = function(const ABusType: TLIBApplicationChannelType; const AIdxLogicalChn: int32; const APCTimeUs: int64; const AHwTimeUs: int64): s32; stdcall;
  Tstart_system_message_log = function(const ADirectory: pansichar): s32; stdcall;
  Tend_system_message_log = function(ALogFileName: PPAnsiChar): s32; stdcall;
  Tmask_fpu_exceptions = function(const AMasked: boolean): s32; stdcall;
  Tcreate_process_shared_memory = function(AAddress: ppByte; const ASizeBytes: int32): s32; stdcall;
  Tget_process_shared_memory = function(AAddress: ppByte; ASizeBytes: pInt32): s32; stdcall;
  Tclear_user_constants = function(): s32; stdcall;
  Tappend_user_constants_from_c_header = function(const AHeaderFile: pansichar): s32; stdcall;
  Tappend_user_constant = function(const AConstantName: pansichar; const AValue: double; const ADesc: pansichar): s32; stdcall;
  Tdelete_user_constant = function(const AConstantName: pansichar): s32; stdcall;
  Tget_mini_program_count = function(ACount: pInt32): s32; stdcall;
  Tget_mini_program_info_by_index = function(const AIndex: int32; AKind: pInt32; AProgramName: PPAnsiChar; ADisplayName: PPAnsiChar): s32; stdcall;
  Tcompile_mini_programs = function(const AProgramNames: pansichar): s32; stdcall;
  Tset_system_var_init_value = function(const ACompleteName: pansichar; const AValue: pansichar): s32; stdcall;
  Tget_system_var_init_value = function(const ACompleteName: pansichar; AValue: PPAnsiChar): s32; stdcall;
  Treset_system_var_to_init = function(const ACompleteName: pansichar): s32; stdcall;
  Treset_all_system_var_to_init = function(const AOwner: pansichar): s32; stdcall;
  Tget_system_var_generic_upg1 = function(const ACompleteName: pansichar; AValue: PPAnsiChar): s32; stdcall;
  Tmplib_load = function(const AMPFileName: PAnsiChar; const ARunAfterLoad: boolean): integer; stdcall;
  Tmplib_unload = function(const AMPFileName: PAnsiChar): integer; stdcall;
  Tmplib_unload_all = function(): integer; stdcall;
  Tmplib_run = function(const AMPFileName: PAnsiChar): integer; stdcall;
  Tmplib_is_running = function(const AMPFileName: PAnsiChar; out AIsRunning: boolean): integer; stdcall;
  Tmplib_stop = function(const AMPFileName: pansichar): integer; stdcall;
  Tmplib_run_all = function(): integer; stdcall;
  Tmplib_stop_all = function(): integer; stdcall;
  Tmplib_get_function_prototype = function(const AGroupName: pansichar; const AFuncName: pansichar; const APrototype: ppansichar): integer; stdcall;
  Tmplib_get_mp_function_list = function(const AGroupName: pansichar; const AList: ppansichar): integer; stdcall;
  Tmplib_get_mp_list = function(const AList: ppansichar): integer; stdcall;
  Tget_tsmaster_binary_location = function(ADirectory: PPAnsiChar): s32; stdcall;
  Tget_form_instance_count = function(const AClassName: pansichar; ACount: pInt32): s32; stdcall;
  Tget_active_application_list = function(ATSMasterAppNames: PPAnsiChar): s32; stdcall;
  Tenumerate_hw_devices = function(out ACount: integer): s32; stdcall;
  Tget_hw_info_by_index = function(const AIndex: s32; const AInfo: PLIBHWInfo): s32; stdcall;
  Tui_graphics_set_measurement_cursor = function(const AWindowCaption: pansichar; const ATimeUs: int64): s32; stdcall;
  Tui_graphics_set_diff_cursor = function(const AWindowCaption: pansichar; const ATime1Us: int64; const ATime2Us: int64): s32; stdcall;
  Tui_graphics_hide_diff_cursor = function(const AWindowCaption: pansichar): s32; stdcall;
  Tui_graphics_hide_measurement_cursor = function(const AWindowCaption: pansichar): s32; stdcall;
  Tencode_string = function(const ASrc: pansichar; ADest: PPAnsiChar): s32; stdcall;
  Tdecode_string = function(const ASrc: pansichar; ADest: PPAnsiChar): s32; stdcall;
  Tis_realtime_mode = function(AValue: PBoolean): s32; stdcall;
  Tis_simulation_mode = function(AValue: PBoolean): s32; stdcall;
  Tui_ribbon_add_icon = function(const AFormClassName: pansichar; const ATabName: pansichar; const AGroupName: pansichar; const AButtonName: pansichar; const AIdxImageSmall: int32; const AIdxImageLarge: int32): s32; stdcall;
  Tui_ribbon_del_icon = function(const AFormClassName: pansichar): s32; stdcall;
  Tpanel_create_control = function(const APanelName: pansichar; const AParentCtrlName: pansichar; const AParentCtrlSubIdx: int32; const AName: pansichar; const ACtrlType: TLIBPanelControlType; const ALeft: single; const ATop: single; const AWidth: single; const AHeight: single; const AVarType: TLIBPanelSignalType; const AVarLink: pansichar): s32; stdcall;
  Tpanel_delete_control = function(const APanelName: pansichar; const ACtrlName: pansichar): s32; stdcall;
  Tpanel_set_var = function(const APanelName: pansichar; const ACtrlName: pansichar; const AVarType: TLIBPanelSignalType; const AVarLink: pansichar): s32; stdcall;
  Tpanel_get_var = function(const APanelName: pansichar; const ACtrlName: pansichar; AVarType: PLIBPanelSignalType; AVarLink: PPAnsiChar): s32; stdcall;
  Tpanel_get_control_count = function(const APanelName: pansichar; ACount: pInt32): s32; stdcall;
  Tpanel_get_control_by_index = function(const APanelName: pansichar; const AIndex: int32; ACtrlType: PLIBPanelControlType; AName: PPAnsiChar): s32; stdcall;
  Tui_save_project = function(const AProjectFullPath: pansichar): s32; stdcall;
  Tretrieve_api_address = function(const AApiName: pansichar; AFlags: pInt32; AAddr: PNativeInt): s32; stdcall;
  Tui_load_rpc_ip_configuration = function(const AFileName: pansichar): s32; stdcall;
  Tui_unload_rpc_ip_configuration = function(const AFileName: pansichar): s32; stdcall;
  Tui_unload_rpc_ip_configurations = function(): s32; stdcall;
  Tam_set_custom_columns = function(const AModuleName: pansichar; const AColumnsConfig: pansichar): s32; stdcall;
  Twrite_realtime_comment_w_time = function(const AComment: pansichar; const ATimeUs: int64): s32; stdcall;
  Tui_graphics_set_relative_time = function(const AWindowCaption: pansichar; const ATimeUs: int64): s32; stdcall;
  Tpanel_import_configuration = function(const APanelName: pansichar; const AFileName: pansichar): s32; stdcall;
  Tui_graphics_set_y_axis_fixed_range = function(const AWindowCaption: pansichar; const AIdxSplit: int32; const ASignalName: pansichar; const AMin: double; const AMax: double): s32; stdcall;
  Texport_system_messages = function(const AFileName: pansichar): s32; stdcall;
  Tui_graphics_export_csv = function(const AWindowCaption: pansichar; const ASgnNames: pansichar; const AFileName: pansichar; const ATimeStartUs: int64; const ATimeEndUs: int64): s32; stdcall;
  Tregister_usb_insertion_event = function(const AObj: Pointer; const AEvent: TOnUSBPlugEvent): s32; stdcall;
  Tunregister_usb_insertion_event = function(const AObj: Pointer; const AEvent: TOnUSBPlugEvent): s32; stdcall;
  Tregister_usb_removal_event = function(const AObj: Pointer; const AEvent: TOnUSBPlugEvent): s32; stdcall;
  Tunregister_usb_removal_event = function(const AObj: Pointer; const AEvent: TOnUSBPlugEvent): s32; stdcall;
  Tsecurity_check_custom_license_valid = function(const ALicenseName: pansichar): s32; stdcall;
  Tcall_model_initialization = function(const AObj: Pointer; const ADiagramName: pansichar; const AInCnt: int32; const AOutCnt: int32; const AInTypes: PlibMBDDataType; const AOutTypes: PlibMBDDataType; AHandle: PNativeInt): s32; stdcall;
  Tcall_model_step = function(const AObj: Pointer; const AHandle: NativeInt; const ATimeUs: int64; const AInValues: Pointer; AOutValues: Pointer): s32; stdcall;
  Tcall_model_finalization = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Tui_hide_main_form = function(): s32; stdcall;
  Tui_show_main_form = function(const ALeft: int32; const ATop: int32; const AWidth: int32; const AHeight: int32): s32; stdcall;
  Tconfigure_can_regs = function(const AChn: int32; const ABaudrateKbps: single; const ASEG1: uint32; const ASEG2: uint32; const APrescaler: uint32; const ASJW: uint32; const AOnlyListen: boolean; const A120OhmConnected: boolean): s32; stdcall;
  Tconfigure_canfd_regs = function(const AChn: int32; const AArbBaudrateKbps: single; const AArbSEG1: uint32; const AArbSEG2: uint32; const AArbPrescaler: uint32; const AArbSJW: uint32; const ADataBaudrateKbps: single; const ADataSEG1: uint32; const ADataSEG2: uint32; const ADataPrescaler: uint32; const ADataSJW: uint32; const AControllerType: TLIBCANFDControllerType; const AControllerMode: TLIBCANFDControllerMode; const A120OhmConnected: boolean): s32; stdcall;
  Tstart_log_verbose = function(const AObj: Pointer; AFilesizeType: int32; ASizeValue: int64): s32; stdcall;
  Tstart_log_w_filename_verbose = function(const AObj: Pointer; AFileName: pansichar; AFilesizeType: int32; ASizeValue: int64): s32; stdcall;
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
  TTSLog_blf_write_start = function (const AFileName: PAnsiChar; AHandle: PNativeInt): s32; stdcall;
  TTSLog_blf_write_start_w_timestamp = function (const AFileName: PAnsiChar; AHandle: PNativeInt; AYear: ps32; AMonth: ps32; ADay: ps32; AHour: ps32; AMinue: ps32; ASecond: ps32; AMilliSeconds: ps32): s32; stdcall;
  TTSLog_blf_write_set_max_count = function (const AHandle: NativeInt; const ACount: u32): s32; stdcall;
  TTSLog_blf_write_can = function (const AHandle: NativeInt; const ACAN: PlibCAN): s32; stdcall;
  TTSLog_blf_write_can_fd = function (const AHandle: NativeInt; const ACANFD: PLIBCANFD): s32; stdcall;
  TTSLog_blf_write_lin = function (const AHandle: NativeInt; const ALIN: PLIBLIN): s32; stdcall;
  TTSLog_blf_write_realtime_comment = function (const AHandle: NativeInt; const ATimeUs: s64; const AComment: PAnsiChar): s32; stdcall;
  TTSLog_blf_write_end = function (const AHandle: NativeInt): s32; stdcall;
  TTSLog_blf_read_start = function (const AFileName: PAnsiChar; AHandle: PNativeInt; AObjCount: ps32): s32; stdcall;
  TTSLog_blf_read_status = function (const AHandle: NativeInt; AObjReadCount: ps32): s32; stdcall;
  TTSLog_blf_read_object = function (const AHandle: NativeInt; AProgressedCnt: ps32; AType: PSupportedObjType; ACAN: PlibCAN; ALIN: PLIBLIN; ACANFD: PLIBCANFD): s32; stdcall;
  TTSLog_blf_read_object_w_comment = function (const AHandle: NativeInt; AProgressedCnt: ps32; AType: PSupportedObjType; ACAN: PlibCAN; ALIN: PlibLIN; ACANFD: PlibCANFD; AComment: Prealtime_comment_t): s32; stdcall;
  TTSLog_blf_read_end = function (const AHandle: NativeInt): s32; stdcall;
  TTSLog_blf_seek_object_time = function (const AHandle: NativeInt; const AProg100: Double; var ATime: s64; var AProgressedCnt: s32): s32; stdcall;
  TTSLog_blf_to_asc = function (const AObj: pointer; const ABLFFileName: PAnsiChar; const AASCFileName: pansichar; const AProgressCallback: TReadProgressCallback): s32; stdcall;
  TTSLog_asc_to_blf = function (const AObj: pointer; const AASCFileName: PAnsiChar; const ABLFFileName: pansichar; const AProgressCallback: TReadProgressCallback): s32; stdcall;
  // IP functions
  TIoIPCreate = function(const AObj: Pointer; const APortTCP, APortUDP: u16; const AOnTCPDataEvent, AOnUDPDataEvent: TOnIoIPData; AHandle: PNativeInt): s32; stdcall;
  TIoIPDelete = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  TIoIPEnableTCPServer = function(const AObj: Pointer; const AHandle: NativeInt; const AEnable: Boolean): s32; stdcall;
  TIoIPEnableUDPServer = function(const AObj: Pointer; const AHandle: NativeInt; const AEnable: Boolean): s32; stdcall;
  TIoIPConnectTCPServer = function(const AObj: Pointer; const AHandle: NativeInt; const AIpAddress: PAnsiChar; const APort: u16): s32; stdcall;
  TIoIPConnectUDPServer = function(const AObj: Pointer; const AHandle: NativeInt; const AIpAddress: PAnsiChar; const APort: u16): s32; stdcall;
  TIoIPDisconnectTCPServer = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  TIoIPSendBufferTCP = function(const AObj: Pointer; const AHandle: NativeInt; const APointer: Pointer; const ASize: s32): s32; stdcall;
  TIoIPSendBufferUDP = function(const AObj: Pointer; const AHandle: NativeInt; const APointer: Pointer; const ASize: s32): s32; stdcall;
  TIoIPRecvTCPClientResponse = function(const AObj: Pointer; const AHandle: NativeInt; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32): s32; stdcall;
  TIoIPSendTCPServerResponse = function(const AObj: Pointer; const AHandle: NativeInt; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; stdcall;
  TIoIPSendUDPBroadcast = function(const AObj: Pointer; const AHandle: NativeInt; const APort: Word; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; stdcall;
  TIoIPSetUDPServerBufferSize = function(const AObj: Pointer; const AHandle: NativeInt; const ASize: s32): s32; stdcall;
  TIoIPRecvUDPClientResponse = function(const AObj: Pointer; const AHandle: NativeInt; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32): s32; stdcall;
  TIoIPSendUDPServerResponse = function(const AObj: Pointer; const AHandle: NativeInt; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; stdcall;
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
  Ttslog_blf_write_flexray = function(const AHandle: NativeInt; const AFlexRay: plibflexray): integer; stdcall;
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
  TTSLogBlfWriteEthernet = function(const AHandle: NativeInt; const AEthernetHeader: PLIBEthernetHeader): s32; stdcall;
  TTransmitEthernetAsyncWoPretx = function(const AEthernetHeader: PLIBEthernetHeader): s32; stdcall;
  TIoIpSetOnConnectionCallback = function(const AHandle: NativeInt; const AConnectedCallback: TOnIoIPConnection; const ADisconnectedCallback: TOnIoIPConnection): s32; stdcall;
  TEthBuildIPv4UDPPacket = function(const AHeader: PLIBEthernetHeader; const ASrcIp: pbyte; const ADstIp: pbyte; const ASrcPort: word; const ADstPort: word; const APayload: pbyte; const APayloadLength: word; AIdentification: pInt32; AFragmentIndex: pInt32): s32; stdcall;
  TBlockCurrentPreTx = function(const AObj: Pointer): s32; stdcall;
  TEthernetIsUDPPacket = function(const AHeader: PLIBEthernetHeader; var AIdentification: u16; var AUDPPacketLength: u16; var AUDPDataOffset: u16; var AIsPacketEnded: boolean): s32; stdcall;
  TEthernetIPCalcHeaderChecksum = function(const AHeader: PLIBEthernetHeader; const AOverwriteChecksum: boolean; AChecksum: pword): s32; stdcall;
  TEthernetUDPCalcChecksum = function(const AHeader: PLIBEthernetHeader; const AUDPPayloadAddr: pbyte; const AUDPPayloadLength: word; const AOverwriteChecksum: boolean; AChecksum: pword): s32; stdcall;
  TEthernetUDPCalcChecksumOnFrame = function(const AHeader: PLIBEthernetHeader; const AOverwriteChecksum: boolean; AChecksum: pword): s32; stdcall;
  TEthLogEthernetFrameData = function(const AHeader: PLIBEthernetHeader): s32; stdcall;
  TRegisterEthernetEvent = function(const AObj: pointer; const AEvent: TEthernetQueueEvent_Win32): s32; stdcall;
  TUnregisterEthernetEvent = function(const AObj: pointer; const AEvent: TEthernetQueueEvent_Win32): s32; stdcall;
  TRegisterPreTxEthernetEvent = function(const AObj: pointer; const AEvent: TEthernetQueueEvent_Win32): s32; stdcall;
  TUnregisterPreTxEthernetEvent = function(const AObj: pointer; const AEvent: TEthernetQueueEvent_Win32): s32; stdcall;
  TUnregisterEthernetEvents = function(const AObj: pointer): s32; stdcall;
  TUnregisterPreTxEthernetEvents = function(const AObj: pointer): s32; stdcall;
  Tlin_clear_schedule_tables = function(const AChnIdx: int32): s32; stdcall;
  Tlin_stop_lin_channel = function(const AChnIdx: int32): s32; stdcall;
  Tlin_start_lin_channel = function(const AChnIdx: int32): s32; stdcall;
  Tlin_switch_runtime_schedule_table = function(const AChnIdx: int32): s32; stdcall;
  Tlin_switch_idle_schedule_table = function(const AChnIdx: int32): s32; stdcall;
  Tlin_switch_normal_schedule_table = function(const AChnIdx: int32; const ASchIndex: int32): s32; stdcall;
  Tlin_batch_set_schedule_start = function(const AChnIdx: int32): s32; stdcall;
  Tlin_batch_add_schedule_frame = function(const AChnIdx: int32; const ALINData: PLIBLIN; const ADelayMs: int32): s32; stdcall;
  Tlin_batch_set_schedule_end = function(const AChnIdx: int32): s32; stdcall;
  Tlin_set_node_functiontype = function(const AChnIdx: int32; const AFunctionType: int32): s32; stdcall;
  Tlin_active_frame_in_schedule_table = function(const AChnIdx: uint32; const AID: byte; const AIndex: int32): s32; stdcall;
  Tlin_deactive_frame_in_schedule_table = function(const AChnIdx: uint32; const AID: byte; const AIndex: int32): s32; stdcall;
  Tflexray_disable_frame = function(const AChnIdx: int32; const ASlot: byte; const ABaseCycle: byte; const ACycleRep: byte; const ATimeoutMs: int32): s32; stdcall;
  Tflexray_enable_frame = function(const AChnIdx: int32; const ASlot: byte; const ABaseCycle: byte; const ACycleRep: byte; const ATimeoutMs: int32): s32; stdcall;
  Tflexray_start_net = function(const AChnIdx: int32; const ATimeoutMs: int32): s32; stdcall;
  Tflexray_stop_net = function(const AChnIdx: int32; const ATimeoutMs: int32): s32; stdcall;
  Tflexray_wakeup_pattern = function(const AChnIdx: int32; const ATimeoutMs: int32): s32; stdcall;
  TSetFlexRayAutoUBHandle = function(const AIsAutoHandle: boolean): s32; stdcall;
  Teth_frame_clear_vlans = function(const AHeader: PLIBEthernetHeader): s32; stdcall;
  Teth_frame_append_vlan = function(AHeader: PLIBEthernetHeader; const AVLANId: word; const APriority: byte; const ACFI: Byte): s32; stdcall;
  Teth_frame_append_vlans = function(AHeader: PLIBEthernetHeader; const AVLANIds: pword; const ACount: int32; const APriority: byte; const ACFI: Byte): s32; stdcall;
  Teth_frame_remove_vlan = function(AHeader: PLIBEthernetHeader): s32; stdcall;
  Teth_build_ipv4_udp_packet_on_frame = function(AInputHeader: PLIBEthernetHeader; APayload: pbyte; APayloadLength: word; AIdentification: pInt32; AFragmentIndex: pInt32): s32; stdcall;
  Teth_udp_fragment_processor_clear = function(const AObj: Pointer): s32; stdcall;
  Teth_udp_fragment_processor_parse = function(const AObj: Pointer; const AHeader: PLIBEthernetHeader; AStatus: PUDPFragmentProcessStatus; APayload: ppByte; APayloadLength: pword; ACompleteHeader: PLIBEthernetHeader): s32; stdcall;
  Teth_frame_insert_vlan = function(AHeader: PLIBEthernetHeader; const AVLANId: word; const APriority: byte; const ACFI: byte): s32; stdcall;
  Ttelnet_create = function(const AObj: Pointer; const AHost: pansichar; const APort: word; ADataEvent: TOnIoIPData; AHandle: PNativeInt): s32; stdcall;
  Ttelnet_delete = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Ttelnet_send_string = function(const AObj: Pointer; const AHandle: NativeInt; const AStr: pansichar): s32; stdcall;
  Ttelnet_connect = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Ttelnet_disconnect = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Ttelnet_set_connection_callback = function(const AObj: Pointer; const AHandle: NativeInt; const AConnectedCallback: TOnIoIPConnection; const ADisconnectedCallback: TOnIoIPConnection): s32; stdcall;
  Ttelnet_enable_debug_print = function(const AObj: Pointer; const AHandle: NativeInt; const AEnable: boolean): s32; stdcall;
  Ttslog_blf_to_pcap = function(const AObj: Pointer; const ABlfFileName: pansichar; const APcapFileName: pansichar; const AProgressCallback: TReadProgressCallback): s32; stdcall;
  Ttslog_pcap_to_blf = function(const AObj: Pointer; const APcapFileName: pansichar; const ABlfFileName: pansichar; const AProgressCallback: TReadProgressCallback): s32; stdcall;
  Ttslog_pcapng_to_blf = function(const AObj: Pointer; const APcapngFileName: pansichar; const ABlfFileName: pansichar; const AProgressCallback: TReadProgressCallback): s32; stdcall;
  Ttslog_blf_to_pcapng = function(const AObj: Pointer; const ABlfFileName: pansichar; const APcapngFileName: pansichar; const AProgressCallback: TReadProgressCallback): s32; stdcall;
  Ttssocket_tcp = function(const ANetworkIndex: int32; const AIPEndPoint: pansichar; const ASocket: pInt32): s32; stdcall;
  Ttssocket_udp = function(const ANetworkIndex: int32; const AIPEndPoint: pansichar; const ASocket: pInt32): s32; stdcall;
  Ttssocket_tcp_start_listen = function(const ASocket: pInt32): s32; stdcall;
  Ttssocket_tcp_start_receive = function(const ASocket: pInt32): s32; stdcall;
  Ttssocket_tcp_close = function(const ASocket: pInt32): s32; stdcall;
  Ttssocket_udp_start_receive = function(const ASocket: pInt32): s32; stdcall;
  Ttssocket_udp_close = function(const ASocket: pInt32): s32; stdcall;
  Ttssocket_tcp_connect = function(const ASocket: int32; const AIPEndPoint: pansichar): s32; stdcall;
  Ttssocket_tcp_send = function(const ASocket: int32; const AData: pbyte; const ASize: int32): s32; stdcall;
  Ttssocket_tcp_sendto_client = function(const ASocket: int32; const AIPEndPoint: pansichar; const AData: pbyte; const ASize: int32): s32; stdcall;
  Ttssocket_udp_sendto = function(const ASocket: int32; const AIPEndPoint: pansichar; const AData: pbyte; const ASize: int32): s32; stdcall;
  Ttssocket_udp_sendto_v2 = function(const ASocket: int32; const AIPAddress: uint32; const APort: word; const AData: pbyte; const ASize: int32): s32; stdcall;
  Ttssocket_tcp_close_v2 = function(const ASocket: pInt32; const AForceExitTimeWait: int32): s32; stdcall;
  Trpc_create_server = function(const ARpcName: pansichar; const ABufferSizeBytes: NativeInt; const ARxEvent: TOnRpcData; AHandle: PNativeInt): s32; stdcall;
  Trpc_activate_server = function(const AHandle: NativeInt; const AActivate: boolean): s32; stdcall;
  Trpc_delete_server = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_server_write_sync = function(const AHandle: NativeInt; const AAddr: pbyte; const ASizeBytes: NativeInt): s32; stdcall;
  Trpc_create_client = function(const ARpcName: pansichar; const ABufferSizeBytes: NativeInt; AHandle: PNativeInt): s32; stdcall;
  Trpc_activate_client = function(const AHandle: NativeInt; const AActivate: boolean): s32; stdcall;
  Trpc_delete_client = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_client_transmit_sync = function(const AHandle: NativeInt; const AAddr: pbyte; const ASizeBytes: NativeInt; const ATimeOutMs: int32): s32; stdcall;
  Trpc_client_receive_sync = function(const AHandle: NativeInt; ASizeBytes: PNativeInt; AAddr: pbyte; const ATimeOutMs: int32): s32; stdcall;
  Trpc_tsmaster_activate_server = function(const AActivate: boolean): s32; stdcall;
  Trpc_tsmaster_create_client = function(const ATSMasterAppName: pansichar; AHandle: PNativeInt): s32; stdcall;
  Trpc_tsmaster_activate_client = function(const AHandle: NativeInt; const AActivate: boolean): s32; stdcall;
  Trpc_tsmaster_delete_client = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_start_simulation = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_stop_simulation = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_write_system_var = function(const AHandle: NativeInt; const ACompleteName: pansichar; const AValue: pansichar): s32; stdcall;
  Trpc_tsmaster_cmd_transfer_memory = function(const AHandle: NativeInt; const AAddr: pbyte; const ASizeBytes: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_log = function(const AHandle: NativeInt; const AMsg: pansichar; const ALevel: Integer): s32; stdcall;
  Trpc_tsmaster_cmd_set_mode_sim = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_set_mode_realtime = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_set_mode_free = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_sim_step = function(const AHandle: NativeInt; const ATimeUs: int64): s32; stdcall;
  Trpc_tsmaster_cmd_sim_step_batch_start = function(const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_sim_step_batch_end = function(const AHandle: NativeInt; const ATimeUs: int64): s32; stdcall;
  Trpc_tsmaster_cmd_get_project = function(const AHandle: NativeInt; AProjectFullPath: PPAnsiChar): s32; stdcall;
  Trpc_tsmaster_cmd_read_system_var = function(const AHandle: NativeInt; ASysVarName: pansichar; AValue: pdouble): s32; stdcall;
  Trpc_tsmaster_cmd_read_signal = function(const AHandle: NativeInt; const ABusType: TLIBApplicationChannelType; AAddr: pansichar; AValue: pdouble): s32; stdcall;
  Trpc_tsmaster_cmd_write_signal = function(const AHandle: NativeInt; const ABusType: TLIBApplicationChannelType; AAddr: pansichar; const AValue: double): s32; stdcall;
  Trawsocket_htons = function(const x: word): u16; stdcall;
  Trawsocket_htonl = function(const x: uint32): u32; stdcall;
  Trawsocket_get_errno = function(ANetworkIndex: int32): s32; stdcall;
  Trawsocket_dhcp_start = function(ANetworkIndex: int32): s32; stdcall;
  Trawsocket_dhcp_stop = procedure(ANetworkIndex: int32); stdcall;
  Trawsocket = function(ANetworkIndex: int32; domain: int32; atype: int32; protocol: int32): s32; stdcall;
  Trawsocket_close = function(s: int32): s32; stdcall;
  Trawsocket_close_v2 = function(s: int32; AForceExitTimeWait: int32): s32; stdcall;
  Trawsocket_shutdown = function(s: int32; how: int32): s32; stdcall;
  Trawsocket_listen = function(s: int32; backlog: int32): s32; stdcall;
  Trawsocket_recv = function(s: int32; mem: Pointer; len: NativeInt; flags: int32): NativeInt; stdcall;
  Trawsocket_read = function(s: int32; mem: Pointer; len: NativeInt): NativeInt; stdcall;
  Trawsocket_aton = function(cp: pansichar; addr: pip4_addr_t): s32; stdcall;
  Trawsocket_ntoa = function(addr: pip4_addr_t): pansichar; stdcall;
  Trawsocket_ntoa6 = function(addr: pip6_addr_t): pansichar; stdcall;
  Trawsocket_aton6 = function(cp: pansichar; addr: pip6_addr_t): s32; stdcall;
  Ttssocket_ping4 = procedure(ANetworkIndex: int32; ping_addr: pip4_addr_t; repeatcnt: int32; interval_ms: uint32; timeout_ms: uint32); stdcall;
  Ttssocket_ping6 = procedure(ANetworkIndex: int32; ping_addr: pip6_addr_t; repeatcnt: int32; interval_ms: uint32; timeout_ms: uint32); stdcall;
  Trawsocket_recvmsg = function(s: int32; amessage: pts_msghdr; flags: int32): NativeInt; stdcall;
  Trawsocket_recvfrom = function(s: int32; mem: Pointer; len: NativeInt; flags: int32; from: pts_sockaddr; fromlen: pts_socklen_t): NativeInt; stdcall;
  Trawsocket_readv = function(s: int32; iov: pts_iovec; iovcnt: int32): NativeInt; stdcall;
  Trawsocket_send = function(s: int32; dataptr: Pointer; size: NativeInt; flags: int32): NativeInt; stdcall;
  Trawsocket_sendto = function(s: int32; dataptr: Pointer; size: NativeInt; flags: int32; ato: pts_sockaddr; tolen: tts_socklen_t): NativeInt; stdcall;
  Trawsocket_sendmsg = function(s: int32; amessage: pts_msghdr; flags: int32): NativeInt; stdcall;
  Trawsocket_write = function(s: int32; dataptr: Pointer; size: NativeInt): NativeInt; stdcall;
  Trawsocket_writev = function(s: int32; iov: pts_iovec; iovcnt: int32): NativeInt; stdcall;
  Trawsocket_fcntl = function(s: int32; cmd: int32; val: int32): s32; stdcall;
  Trawsocket_ioctl = function(s: int32; cmd: int32; argp: Pointer): s32; stdcall;
  Trawsocket_accept = function(s: int32; addr: pts_sockaddr; addrlen: pts_socklen_t): s32; stdcall;
  Trawsocket_bind = function(s: int32; name: pts_sockaddr; addrlen: tts_socklen_t): s32; stdcall;
  Trawsocket_getsockname = function(s: int32; name: pts_sockaddr; namelen: pts_socklen_t): s32; stdcall;
  Trawsocket_getpeername = function(s: int32; name: pts_sockaddr; namelen: pts_socklen_t): s32; stdcall;
  Trawsocket_getsockopt = function(s: int32; level: int32; optname: int32; optval: Pointer; optlen: pts_socklen_t): s32; stdcall;
  Trawsocket_setsockopt = function(s: int32; level: int32; optname: int32; optval: Pointer; optlen: tts_socklen_t): s32; stdcall;
  Trawsocket_poll = function(ANetworkIndex: int32; fds: pts_pollfd; nfds: ts_nfds_t; timeout: int32): s32; stdcall;
  Trawsocket_connect = function(s: int32; name: pts_sockaddr; namelen: tts_socklen_t): s32; stdcall;
  Trawsocket_inet_ntop = function(af: int32; src: Pointer; dst: pansichar; size: tts_socklen_t): pansichar; stdcall;
  Trawsocket_inet_pton = function(af: int32; src: pansichar; dst: Pointer): s32; stdcall;
  Trpc_tsmaster_cmd_set_can_signal = function(const AHandle: NativeInt; const ASgnAddress: pansichar; AValue: double): s32; stdcall;
  Trpc_tsmaster_cmd_get_can_signal = function(const AHandle: NativeInt; const ASgnAddress: pansichar; AValue: pdouble): s32; stdcall;
  Trpc_tsmaster_cmd_get_lin_signal = function(const AHandle: NativeInt; const ASgnAddress: pansichar; AValue: pdouble): s32; stdcall;
  Trpc_tsmaster_cmd_set_lin_signal = function(const AHandle: NativeInt; const ASgnAddress: pansichar; AValue: double): s32; stdcall;
  Trpc_tsmaster_cmd_set_flexray_signal = function(const AHandle: NativeInt; const ASgnAddress: pansichar; AValue: double): s32; stdcall;
  Trpc_tsmaster_cmd_get_flexray_signal = function(const AHandle: NativeInt; const ASgnAddress: pansichar; AValue: pdouble): s32; stdcall;
  Trpc_tsmaster_cmd_get_constant = function(const AHandle: NativeInt; const AConstName: pansichar; AValue: pdouble): s32; stdcall;
  Trpc_tsmaster_is_simulation_running = function(const AHandle: NativeInt; AIsRunning: pboolean): s32; stdcall;
  Trpc_tsmaster_call_system_api = function(const AHandle: NativeInt; const AAPIName: pansichar; const AArgCount: int32; const AArgCapacity: int32; AArgs: PPAnsiChar): s32; stdcall;
  Trpc_tsmaster_call_library_api = function(const AHandle: NativeInt; const AAPIName: pansichar; const AArgCount: int32; const AArgCapacity: int32; AArgs: PPAnsiChar): s32; stdcall;
  Trpc_tsmaster_cmd_register_signal_cache = function(const AHandle: NativeInt; const ABusType: TLIBApplicationChannelType; const ASgnAddress: pansichar; AId: pint64): s32; stdcall;
  Trpc_tsmaster_cmd_unregister_signal_cache = function(const AHandle: NativeInt; const AId: int64): s32; stdcall;
  Trpc_tsmaster_cmd_get_signal_cache_value = function(const AHandle: NativeInt; const AId: int64; AValue: pdouble): s32; stdcall;
  Tcan_rbs_set_crc_signal_w_head_tail = function(const ASymbolAddress: pansichar; const AAlgorithmName: pansichar; const AIdxByteStart: int32; const AByteCount: int32; const AHeadAddr: pbyte; const AHeadSizeBytes: int32; const ATailAddr: pbyte; const ATailSizeBytes: int32): s32; stdcall;
  Tcal_get_data_by_row_and_col = function(const AECUName: pansichar; const AVarName: pansichar; const AIdxRow: int32; const AIdxCol: int32; AValue: pdouble): s32; stdcall;
  Tcal_set_data_by_row_and_col = function(const AECUName: pansichar; const AVarName: pansichar; const AIdxRow: int32; const AIdxCol: int32; const AValue: double; const AImmediateDownload: byte): s32; stdcall;
  Ttslog_blf_write_sysvar_double = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: double): s32; stdcall;
  Ttslog_blf_write_sysvar_s32 = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: int32): s32; stdcall;
  Ttslog_blf_write_sysvar_u32 = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: uint32): s32; stdcall;
  Ttslog_blf_write_sysvar_s64 = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: int64): s32; stdcall;
  Ttslog_blf_write_sysvar_u64 = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: uint64): s32; stdcall;
  Ttslog_blf_write_sysvar_string = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: pansichar): s32; stdcall;
  Ttslog_blf_write_sysvar_double_array = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: pdouble; const AValueCount: int32): s32; stdcall;
  Ttslog_blf_write_sysvar_s32_array = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: pInt32; const AValueCount: int32): s32; stdcall;
  Ttslog_blf_write_sysvar_u8_array = function(const AHandle: NativeInt; const AName: pansichar; const ATimeUs: int64; const AValue: pbyte; const AValueCount: int32): s32; stdcall;
  Tcal_add_measurement_item = function(const AECUName: pansichar; const AVarName: pansichar; const AEvt: pansichar; const AEvtType: int32; const APeriodMs: int32): s32; stdcall;
  Tcal_delete_measurement_item = function(const AECUName: pansichar; const AVarName: pansichar): s32; stdcall;
  Tcal_clear_measurement_items = function(const AECUName: pansichar): s32; stdcall;
  Trpc_tsmaster_cmd_start_can_rbs = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_stop_can_rbs = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_start_lin_rbs = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_stop_lin_rbs = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_start_flexray_rbs = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_stop_flexray_rbs = function(const AObj: Pointer; const AHandle: NativeInt): s32; stdcall;
  Trpc_tsmaster_cmd_is_can_rbs_running = function(const AObj: Pointer; const AHandle: NativeInt; AIsRunning: PBoolean): s32; stdcall;
  Trpc_tsmaster_cmd_is_lin_rbs_running = function(const AObj: Pointer; const AHandle: NativeInt; AIsRunning: PBoolean): s32; stdcall;
  Trpc_tsmaster_cmd_is_flexray_rbs_running = function(const AObj: Pointer; const AHandle: NativeInt; AIsRunning: PBoolean): s32; stdcall;
  Ttssocket_add_ipv4_device = function(const AChannel: int32; const AMacAddress: pansichar; const AHasVlan: int32; const AVLanID: int32; const AVLanPriority: int32; const AIPAddress: pansichar; const AIPMask: pansichar): s32; stdcall;
  Ttssocket_delete_ipv4_device = function(const AChannel: int32; const AMacAddress: pansichar; const AHasVlan: int32; const AVLanID: int32; const AVLanPriority: int32; const AIPAddress: pansichar): s32; stdcall;
  Ttsfifo_enable_receive_fifo = procedure; stdcall;
  Ttsfifo_disable_receive_fifo = procedure; stdcall;
  Ttsfifo_add_can_canfd_pass_filter = function(AIdxChn: int32; AIdentifier: int32; AIsStd: boolean): s32; stdcall;
  Ttsfifo_add_lin_pass_filter = function(AIdxChn: int32; AIdentifier: int32): s32; stdcall;
  Ttsfifo_delete_can_canfd_pass_filter = function(AIdxChn: int32; AIdentifier: int32): s32; stdcall;
  Ttsfifo_delete_lin_pass_filter = function(AIdxChn: int32; AIdentifier: int32): s32; stdcall;
  Ttsfifo_enable_receive_error_frames = procedure; stdcall;
  Ttsfifo_disable_receive_error_frames = procedure; stdcall;
  Ttsfifo_receive_can_msgs = function(ACANBuffers: PLIBCAN; ACANBufferSize: pInt32; AIdxChn: int32; AIncludeTx: boolean): s32; stdcall;
  Ttsfifo_receive_canfd_msgs = function(ACANFDBuffers: PLIBCANFD; ACANBufferSize: pInt32; AIdxChn: int32; AIncludeTx: boolean): s32; stdcall;
  Ttsfifo_receive_lin_msgs = function(ALINBuffers: PLIBLIN; ABufferSize: pInt32; AIdxChn: int32; AIncludeTx: boolean): s32; stdcall;
  Ttsfifo_receive_flexray_msgs = function(AFRBuffers: PLIBFlexRay; ABufferSize: pInt32; AIdxChn: int32; AIncludeTx: boolean): s32; stdcall;
  Ttsfifo_clear_can_receive_buffers = function(AIdxChn: int32): s32; stdcall;
  Ttsfifo_clear_canfd_receive_buffers = function(AIdxChn: int32): s32; stdcall;
  Ttsfifo_clear_lin_receive_buffers = function(AIdxChn: int32): s32; stdcall;
  Ttsfifo_clear_flexray_receive_buffers = function(AIdxChn: int32): s32; stdcall;
  Ttsfifo_read_can_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_can_tx_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_can_rx_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_canfd_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_canfd_tx_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_canfd_rx_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_lin_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_lin_tx_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_lin_rx_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_flexray_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_flexray_tx_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Ttsfifo_read_flexray_rx_buffer_frame_count = function(AIdxChn: int32; ACount: pInt32): s32; stdcall;
  Tflexray_rbs_reset_update_bits = function(): s32; stdcall;
  Tcan_rbs_reset_update_bits = function(): s32; stdcall;
  Tcan_rbs_fault_inject_handle_on_autosar_crc_event = function(const AObj: Pointer; const AEvent: TOnAutoSARE2ECanEvt): s32; stdcall;
  Tcan_rbs_fault_inject_handle_on_autosar_rc_event = function(const AObj: Pointer; const AEvent: TOnAutoSARE2ECanEvt): s32; stdcall;
  Tcan_rbs_fault_inject_unhandle_on_autosar_rc_event = function(const AEvent: TOnAutoSARE2ECanEvt): s32; stdcall;
  Tcan_rbs_fault_inject_unhandle_on_autosar_crc_event = function(const AEvent: TOnAutoSARE2ECanEvt): s32; stdcall;
  Teth_rbs_set_pdu_phase_and_cycle_by_name = function(const AIdxChn: int32; const APhaseMs: int32; const ACycleMs: int32; const ANetworkName: pansichar; const ANodeName: pansichar; const APDUName: pansichar): s32; stdcall;
  Tcan_rbs_set_update_bits = function(): s32; stdcall;
  Tflexray_rbs_set_update_bits = function(): s32; stdcall;
  Trpc_ip_trigger_data_group = function(const AGroupId: int32): s32; stdcall;
  Tcan_rbs_get_signal_raw_by_address = function(const ASymbolAddress: pansichar; ARaw: puint64): s32; stdcall;
  Teth_rbs_start = function(): s32; stdcall;
  Teth_rbs_stop = function(): s32; stdcall;
  Teth_rbs_is_running = function(const AIsRunning: PBoolean): s32; stdcall;
  Teth_rbs_configure = function(const AAutoStart: boolean; const AAutoSendOnModification: boolean; const AActivateNodeSimulation: boolean; const AInitValueOptions: int32): s32; stdcall;
  Teth_rbs_activate_all_networks = function(const AEnable: boolean; const AIncludingChildren: boolean): s32; stdcall;
  Teth_rbs_activate_network_by_name = function(const AIdxChn: int32; const AEnable: boolean; const ANetworkName: pansichar; const AIncludingChildren: boolean): s32; stdcall;
  Teth_rbs_activate_node_by_name = function(const AIdxChn: int32; const AEnable: boolean; const ANetworkName: pansichar; ANodeName: pansichar; const AIncludingChildren: boolean): s32; stdcall;
  Teth_rbs_activate_pdu_by_name = function(const AIdxChn: int32; const AEnable: boolean; const ANetworkName: pansichar; ANodeName: pansichar; const APDUName: pansichar): s32; stdcall;
  Teth_rbs_get_signal_value_by_element = function(const AIdxChn: int32; const ANetworkName: pansichar; ANodeName: pansichar; const APDUName: pansichar; const ASignalName: pansichar; const AValue: pdouble): s32; stdcall;
  Teth_rbs_set_signal_value_by_element = function(const AIdxChn: int32; const ANetworkName: pansichar; ANodeName: pansichar; const APDUName: pansichar; const ASignalName: pansichar; const AValue: double): s32; stdcall;
  Teth_rbs_get_signal_value_by_address = function(const ASymbolAddress: pansichar; const AValue: pdouble): s32; stdcall;
  Teth_rbs_set_signal_value_by_address = function(const ASymbolAddress: pansichar; const AValue: double): s32; stdcall;
  Tlin_rbs_update_frame_by_id = function(const AChnIdx: int32; const AId: byte): s32; stdcall;
  Tlin_rbs_register_force_refresh_frame_by_id = function(const AChnIdx: int32; const AId: byte): s32; stdcall;
  Tlin_rbs_unregister_force_refresh_frame_by_id = function(const AChnIdx: int32; const AId: byte): s32; stdcall;
  Trpc_data_channel_create = function(const AObj: Pointer; const ARpcName: pansichar; const AIsMaster: int32; const ABufferSizeBytes: NativeInt; const ARxEvent: TOnRpcData; AHandle: PNativeInt): s32; stdcall;
  Trpc_data_channel_delete = function(const AObj: Pointer; AHandle: NativeInt): s32; stdcall;
  Trpc_data_channel_transmit = function(const AObj: Pointer; AHandle: NativeInt; AAddr: pbyte; ASizeBytes: NativeInt; ATimeOutMs: int32): s32; stdcall;
  Ttssocket_getaddrinfo = function(const ANetworkIndex: int32; const nodename: pansichar; const servname: pansichar; const hints: pts_addrinfo; res: ppts_addrinfo): s32; stdcall;
  Ttssocket_freeaddrinfo = function(const ANetworkIndex: int32; const ai: pts_addrinfo): s32; stdcall;
  Ttssocket_gethostname = function(const ANetworkIndex: int32; const name: pansichar; ahostent: ppts_hostent): s32; stdcall;
  Ttssocket_getalldevices = function(const ANetworkIndex: int32; devs: ppts_net_device): s32; stdcall;
  Ttssocket_freedevices = function(const ANetworkIndex: int32; devs: pts_net_device): s32; stdcall;
  Trawsocket_select = function(const ANetworkIndex: int32; const maxfdp1: int32; const readset: pts_fd_set; const writeset: pts_fd_set; const exceptset: pts_fd_set; const timeout: pts_timeval): s32; stdcall;
  Ttssocket_set_host_name = function(const ANetworkIndex: int32; const AIPAddress: pansichar; const AHostName: pansichar): s32; stdcall;
  Ttsdio_set_pwm_output_async = function(const AChn: int32; ADuty: double; AFrequency: double): s32; stdcall;
  Ttsdio_set_vlevel_output_async = function(const AChn: int32; AIOStatus: int32): s32; stdcall;
  Tcan_il_register_autosar_pdu_event = function(const AChn: int32; const AID: int32; const AEvent: TOnAutoSARPDUQueueEvent): s32; stdcall;
  Tcan_il_unregister_autosar_pdu_event = function(const AChn: int32; const AID: int32; const AEvent: TOnAutoSARPDUQueueEvent): s32; stdcall;
  Tcan_il_register_autosar_pdu_pretx_event = function(const AChn: int32; const AID: int32; const AEvent: TOnAutoSARPDUPreTxEvent): s32; stdcall;
  Tcan_il_unregister_autosar_pdu_pretx_event = function(const AChn: int32; const AID: int32; const AEvent: TOnAutoSARPDUPreTxEvent): s32; stdcall;
  Tcan_rbs_fault_inject_disturb_sequencecounter = function(const AChn: int32; const ANetworkName: pansichar; const ANodeName: pansichar; const AMessageName: pansichar; const ASignalGroupName: pansichar; const atype: int32; const disturbanceMode: int32; const disturbanceCount: int32; const disturbanceValue: int32; const continueMode: int32): s32; stdcall;
  Tcan_rbs_fault_inject_disturb_checksum = function(const AChn: int32; const ANetworkName: pansichar; const ANodeName: pansichar; const AMessageName: pansichar; const ASignalGroupName: pansichar; const atype: int32; const disturbanceMode: int32; const disturbanceCount: int32; const disturbanceValue: int32): s32; stdcall;
  Tcan_rbs_fault_inject_disturb_updatebit = function(const AChn: int32; const ANetworkName: pansichar; const ANodeName: pansichar; const AMessageName: pansichar; const ASignalGroupName: pansichar; const disturbanceMode: int32; const disturbanceCount: int32; const disturbanceValue: int32): s32; stdcall;
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
  TSignalTesterClearAll = function(): s32; stdcall;
  TSignalTesterLoadConfiguration = function(const AFilePath: pansichar): s32; stdcall;
  TSignalTesterSaveConfiguration = function(const AFilePath: pansichar): s32; stdcall;
  TSignalTesterRunItemByName = function(const AName: pansichar): s32; stdcall;
  TSignalTesterStopItemByName = function(const AName: pansichar): s32; stdcall;
  TSignalTesterRunItemByIndex = function(const AIndex: int32): s32; stdcall;
  TSignalTesterStopItemByIndex = function(const AIndex: int32): s32; stdcall;
  TSignalTesterGetItemVerdictByIndex = function(const AObj: Pointer; const AIndex: int32; AIsPass: PBoolean): s32; stdcall;
  TSignalTesterGetItemResultByName = function(const AObj: Pointer; const AName: pansichar; AIsPass: PBoolean; AEventTimeUs: pint64; AResults, ADescription: PPAnsiChar): s32; stdcall;
  TSignalTesterGetItemResultByIndex = function(const AObj: Pointer; const AIndex: int32; AIsPass: PBoolean; AEventTimeUs: pint64; AResults, ADescription: PPAnsiChar): s32; stdcall;
  TSignalTesterGetItemVerdictByName = function(const AObj: Pointer; const AName: pansichar; AIsPass: PBoolean): s32; stdcall;
  TSignalTesterCheckStatisticsByIndex = function(const AObj: Pointer; const AIndex: int32; const AMin: double; const AMax: double; APass: PBoolean; AResults, AResultRepr: PPAnsiChar): s32; stdcall;
  TSignalTesterCheckStatisticsByName = function(const AObj: Pointer; const AItemName: pansichar; const AMin: double; const AMax: double; APass: PBoolean; AResults, AResultRepr: PPAnsiChar): s32; stdcall;
  TSignalTesterEnableItem = function(const AIndex: int32; const AEnable: boolean): s32; stdcall;
  TSignalTesterEnableItemByName = function(const AItemName: pansichar; const AEnable: boolean): s32; stdcall;
  TSignalTesterRunAll = function(): s32; stdcall;
  TSignalTesterStopAll = function(): s32; stdcall;
  TSetClassicTestSystemReportName = function(const AName: pansichar): s32; stdcall;
  TSignalTesterGetItemStatusByIndex = function(const AIdx: int32; AIsRunning: PBoolean; AIsCheckDone: PBoolean; AFailReason: PSignalTesterFailReason): s32; stdcall;
  TSignalTesterGetItemStatusByName = function(const ATesterName: pansichar; AIsRunning: PBoolean; AIsCheckDone: PBoolean; AFailReason: PSignalTesterFailReason): s32; stdcall;
  TSignalTesterSetItemTimeRangeByIndex = function(const AIdx: int32; const ATimeBegin: double; const ATimeEnd: double): s32; stdcall;
  TSignalTesterSetItemTimeRangeByName = function(const AName: pansichar; const ATimeBegin: double; const ATimeEnd: double): s32; stdcall;
  TSignalTesterSetItemValueRangeByIndex = function(const AIdx: int32; const ALow: double; const AHigh: double): s32; stdcall;
  TSignalTesterSetItemValueRangeByName = function(const AName: pansichar; const ALow: double; const AHigh: double): s32; stdcall;
  Tclassic_test_system_login = function(const AUserName: pansichar; const APassword: pansichar): s32; stdcall;
  Tclassic_test_system_import = function(const AConfFile: pansichar): s32; stdcall;
  Tlog_formatted_value = function(const AStr: pansichar; const AFormat: pansichar; const AValue: double; const ALevel: Integer): s32; stdcall;
  // TS_TEST_PROTO_END (do not modify this line) ================================

  // TSMaster variables =========================================================
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
    internal_disconnect                 : TTSAppDisconnectApplication      ;
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
    register_system_var_change_event: TRegisterSystemVarChangeEvent;
    unregister_system_var_change_event: TUnRegisterSystemVarChangeEvent;
    unregister_system_var_change_events: TUnRegisterSystemVarChangeEvents;
    call_system_api: TCallSystemAPI;
    call_library_api: TCallLibraryAPI;
    ini_read_string_wo_quotes: TIniReadStringWoQuotes;
    ui_graphics_add_signal: TUIGraphicsAddSignal;
    ui_graphics_clear_signals: TUIGraphicsClearSignals;
    gpg_load_excel: TGPGLoadExcel;
    run_in_main_thread: TRunProcedure;
    open_help_doc: TOpenHelpDoc;
    get_language_string: TGetLangString;
    convert_blf_to_csv: TConvertBlfToCsv;
    convert_blf_to_csv_with_filter: TConvertBlfToCsvWFilter;
    internal_start_log_w_filename: TStartLogWFileName;
    convert_blf_to_mat_w_filter: TConvertBlfToMatWFilter;
    convert_asc_to_mat_w_filter: TConvertASCToMatWFilter;
    convert_asc_to_csv_w_filter: TConvertASCToCSVWFilter;
    set_debug_log_level: TSetDebugLogLevel;
    get_form_unique_id: TGetFormUniqueId;
    panel_clear_control: Tpanel_clear_control;
    set_form_unique_id: Tset_form_unique_id;
    show_form: Tshow_form;
    kill_form: Tkill_form;
    place_form: Tplace_form;
    toggle_mdi_form: Ttoggle_mdi_form;
    get_language_id: Tget_language_id;
    create_form: Tcreate_form;
    set_form_caption: Tset_form_caption;
    enter_critical_section: Tenter_critical_section;
    leave_critical_section: Tleave_critical_section;
    try_enter_critical_section: Ttry_enter_critical_section;
    db_load_can_db: Tdb_load_can_db;
    db_load_lin_db: Tdb_load_lin_db;
    db_load_flexray_db: Tdb_load_flexray_db;
    db_unload_can_db: Tdb_unload_can_db;
    db_unload_lin_db: Tdb_unload_lin_db;
    db_unload_flexray_db: Tdb_unload_flexray_db;
    db_unload_can_dbs: Tdb_unload_can_dbs;
    db_unload_lin_dbs: Tdb_unload_lin_dbs;
    db_unload_flexray_dbs: Tdb_unload_flexray_dbs;
    security_update_new_key_sync: TSecurityUpdateNewKeySync;
    security_unlock_write_authority_sync: TSecurityUnlockWriteAuthoritySync;
    security_unlock_write_authority_async: TSecurityUnlockWriteAuthorityASync;
    security_write_string_sync: TSecurityWriteStringSync;
    security_write_string_async: TSecurityWriteStringASync;
    security_read_string_sync: TSecurityReadStringSync;
    security_unlock_encrypt_channel_sync: TSecurityUnlockEncChannelSync;
    security_unlock_encrypt_channel_async: TSecurityUnlockEncChannelASync;
    security_encrypt_string_sync: TSecurityEncryptStringSync;
    security_decrypt_string_sync: TSecurityDecryptStringSync;
    set_channel_timestamp_deviation_factor: Tset_channel_timestamp_deviation_factor;
    start_system_message_log: Tstart_system_message_log;
    end_system_message_log: Tend_system_message_log;
    mask_fpu_exceptions: Tmask_fpu_exceptions;
    create_process_shared_memory: Tcreate_process_shared_memory;
    get_process_shared_memory: Tget_process_shared_memory;
    clear_user_constants: Tclear_user_constants;
    append_user_constants_from_c_header: Tappend_user_constants_from_c_header;
    append_user_constant: Tappend_user_constant;
    delete_user_constant: Tdelete_user_constant;
    get_mini_program_count: Tget_mini_program_count;
    get_mini_program_info_by_index: Tget_mini_program_info_by_index;
    compile_mini_programs: Tcompile_mini_programs;
    set_system_var_init_value: Tset_system_var_init_value;
    get_system_var_init_value: Tget_system_var_init_value;
    reset_system_var_to_init: Treset_system_var_to_init;
    reset_all_system_var_to_init: Treset_all_system_var_to_init;
    get_system_var_generic_upg1: Tget_system_var_generic_upg1;
    mplib_load: Tmplib_load;
    mplib_unload: Tmplib_unload;
    mplib_unload_all: Tmplib_unload_all;
    mplib_run: Tmplib_run;
    mplib_is_running: Tmplib_is_running;
    mplib_stop: Tmplib_stop;
    mplib_run_all: Tmplib_run_all;
    mplib_stop_all: Tmplib_stop_all;
    mplib_get_function_prototype: Tmplib_get_function_prototype;
    mplib_get_mp_function_list: Tmplib_get_mp_function_list;
    mplib_get_mp_list: Tmplib_get_mp_list;
    get_tsmaster_binary_location: Tget_tsmaster_binary_location;
    get_form_instance_count: Tget_form_instance_count;
    get_active_application_list: Tget_active_application_list;
    enumerate_hw_devices: Tenumerate_hw_devices;
    get_hw_info_by_index: Tget_hw_info_by_index;
    ui_graphics_set_measurement_cursor: Tui_graphics_set_measurement_cursor;
    ui_graphics_set_diff_cursor: Tui_graphics_set_diff_cursor;
    ui_graphics_hide_diff_cursor: Tui_graphics_hide_diff_cursor;
    ui_graphics_hide_measurement_cursor: Tui_graphics_hide_measurement_cursor;
    encode_string: Tencode_string;
    decode_string: Tdecode_string;
    is_realtime_mode: Tis_realtime_mode;
    is_simulation_mode: Tis_simulation_mode;
    ui_ribbon_add_icon: Tui_ribbon_add_icon;
    ui_ribbon_del_icon: Tui_ribbon_del_icon;
    panel_create_control: Tpanel_create_control;
    panel_delete_control: Tpanel_delete_control;
    panel_set_var: Tpanel_set_var;
    panel_get_var: Tpanel_get_var;
    panel_get_control_count: Tpanel_get_control_count;
    panel_get_control_by_index: Tpanel_get_control_by_index;
    ui_save_project: Tui_save_project;
    retrieve_api_address: Tretrieve_api_address;
    ui_load_rpc_ip_configuration: Tui_load_rpc_ip_configuration;
    ui_unload_rpc_ip_configuration: Tui_unload_rpc_ip_configuration;
    ui_unload_rpc_ip_configurations: Tui_unload_rpc_ip_configurations;
    am_set_custom_columns: Tam_set_custom_columns;
    write_realtime_comment_w_time: Twrite_realtime_comment_w_time;
    ui_graphics_set_relative_time: Tui_graphics_set_relative_time;
    panel_import_configuration: Tpanel_import_configuration;
    ui_graphics_set_y_axis_fixed_range: Tui_graphics_set_y_axis_fixed_range;
    export_system_messages: Texport_system_messages;
    ui_graphics_export_csv: Tui_graphics_export_csv;
    register_usb_insertion_event: Tregister_usb_insertion_event;
    unregister_usb_insertion_event: Tunregister_usb_insertion_event;
    register_usb_removal_event: Tregister_usb_removal_event;
    unregister_usb_removal_event: Tunregister_usb_removal_event;
    security_check_custom_license_valid: Tsecurity_check_custom_license_valid;
    call_model_initialization: Tcall_model_initialization;
    call_model_step: Tcall_model_step;
    call_model_finalization: Tcall_model_finalization;
    ui_hide_main_form: Tui_hide_main_form;
    ui_show_main_form: Tui_show_main_form;
    configure_can_regs: Tconfigure_can_regs;
    configure_canfd_regs: Tconfigure_canfd_regs;
    start_log_verbose: Tstart_log_verbose;
    start_log_w_filename_verbose: Tstart_log_w_filename_verbose;
    FDummy: array [0..602-1] of NativeInt; // place holders, TS_APP_PROTO_END
    function start_log_w_filename(const AFileName: string): s32; cdecl;
    function disconnect(): s32; cdecl;
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
    internal_register_event_ethernet: TRegisterEthernetEvent;
    internal_unregister_event_ethernet: TUnregisterEthernetEvent;
    internal_unregister_events_ethernet: TUnregisterEthernetEvents;
    internal_register_pretx_event_ethernet: TRegisterPreTxEthernetEvent;
    internal_unregister_pretx_event_ethernet: TUnregisterPreTxEthernetEvent;
    internal_unregister_pretx_events_ethernet: TUnregisterPreTxEthernetEvents;
    transmit_ethernet_async_wo_pretx: TTransmitEthernetAsyncWoPretx;
    ioip_set_tcp_server_connection_callback: TIoIpSetOnConnectionCallback;
    eth_build_ipv4_udp_packet: TEthBuildIPv4UDPPacket;
    block_current_pretx: TBlockCurrentPreTx;
    eth_is_udp_packet: TEthernetIsUDPPacket;
    eth_ip_calc_header_checksum: TEthernetIPCalcHeaderChecksum;
    eth_udp_calc_checksum: TEthernetUDPCalcChecksum;
    ethernet_udp_calc_checksum_on_frame: TEthernetUDPCalcChecksumOnFrame;
    eth_log_ethernet_frame_data: TEthLogEthernetFrameData;
    lin_clear_schedule_tables: Tlin_clear_schedule_tables;
    lin_stop_lin_channel: Tlin_stop_lin_channel;
    lin_start_lin_channel: Tlin_start_lin_channel;
    lin_switch_runtime_schedule_table: Tlin_switch_runtime_schedule_table;
    lin_switch_idle_schedule_table: Tlin_switch_idle_schedule_table;
    lin_switch_normal_schedule_table: Tlin_switch_normal_schedule_table;
    lin_batch_set_schedule_start: Tlin_batch_set_schedule_start;
    lin_batch_add_schedule_frame: Tlin_batch_add_schedule_frame;
    lin_batch_set_schedule_end: Tlin_batch_set_schedule_end;
    lin_set_node_functiontype: Tlin_set_node_functiontype;
    lin_active_frame_in_schedule_table: Tlin_active_frame_in_schedule_table;
    lin_deactive_frame_in_schedule_table: Tlin_deactive_frame_in_schedule_table;
    flexray_disable_frame: Tflexray_disable_frame;
    flexray_enable_frame: Tflexray_enable_frame;
    flexray_start_net: Tflexray_start_net;
    flexray_stop_net: Tflexray_stop_net;
    flexray_wakeup_pattern: Tflexray_wakeup_pattern;
    set_flexray_ub_bit_auto_handle: TSetFlexRayAutoUBHandle;
    eth_frame_clear_vlans: Teth_frame_clear_vlans;
    eth_frame_append_vlan: Teth_frame_append_vlan;
    eth_frame_append_vlans: Teth_frame_append_vlans;
    eth_frame_remove_vlan: Teth_frame_remove_vlan;
    eth_build_ipv4_udp_packet_on_frame: Teth_build_ipv4_udp_packet_on_frame;
    internal_eth_udp_fragment_processor_clear: Teth_udp_fragment_processor_clear;
    internal_eth_udp_fragment_processor_parse: Teth_udp_fragment_processor_parse;
    eth_frame_insert_vlan: Teth_frame_insert_vlan;
    telnet_create: Ttelnet_create;
    telnet_delete: Ttelnet_delete;
    telnet_send_string: Ttelnet_send_string;
    telnet_connect: Ttelnet_connect;
    telnet_disconnect: Ttelnet_disconnect;
    telnet_set_connection_callback: Ttelnet_set_connection_callback;
    telnet_enable_debug_print: Ttelnet_enable_debug_print;
    tslog_blf_to_pcap: Ttslog_blf_to_pcap;
    tslog_pcap_to_blf: Ttslog_pcap_to_blf;
    tslog_pcapng_to_blf: Ttslog_pcapng_to_blf;
    tslog_blf_to_pcapng: Ttslog_blf_to_pcapng;
    tssocket_tcp: Ttssocket_tcp;
    tssocket_udp: Ttssocket_udp;
    tssocket_tcp_start_listen: Ttssocket_tcp_start_listen;
    tssocket_tcp_start_receive: Ttssocket_tcp_start_receive;
    tssocket_tcp_close: Ttssocket_tcp_close;
    tssocket_udp_start_receive: Ttssocket_udp_start_receive;
    tssocket_udp_close: Ttssocket_udp_close;
    tssocket_tcp_connect: Ttssocket_tcp_connect;
    tssocket_tcp_send: Ttssocket_tcp_send;
    tssocket_tcp_sendto_client: Ttssocket_tcp_sendto_client;
    tssocket_udp_sendto: Ttssocket_udp_sendto;
    tssocket_udp_sendto_v2: Ttssocket_udp_sendto_v2;
    tssocket_tcp_close_v2: Ttssocket_tcp_close_v2;
    rpc_create_server: Trpc_create_server;
    rpc_activate_server: Trpc_activate_server;
    rpc_delete_server: Trpc_delete_server;
    rpc_server_write_sync: Trpc_server_write_sync;
    rpc_create_client: Trpc_create_client;
    rpc_activate_client: Trpc_activate_client;
    rpc_delete_client: Trpc_delete_client;
    rpc_client_transmit_sync: Trpc_client_transmit_sync;
    rpc_client_receive_sync: Trpc_client_receive_sync;
    rpc_tsmaster_activate_server: Trpc_tsmaster_activate_server;
    rpc_tsmaster_create_client: Trpc_tsmaster_create_client;
    rpc_tsmaster_activate_client: Trpc_tsmaster_activate_client;
    rpc_tsmaster_delete_client: Trpc_tsmaster_delete_client;
    rpc_tsmaster_cmd_start_simulation: Trpc_tsmaster_cmd_start_simulation;
    rpc_tsmaster_cmd_stop_simulation: Trpc_tsmaster_cmd_stop_simulation;
    rpc_tsmaster_cmd_write_system_var: Trpc_tsmaster_cmd_write_system_var;
    rpc_tsmaster_cmd_transfer_memory: Trpc_tsmaster_cmd_transfer_memory;
    rpc_tsmaster_cmd_log: Trpc_tsmaster_cmd_log;
    rpc_tsmaster_cmd_set_mode_sim: Trpc_tsmaster_cmd_set_mode_sim;
    rpc_tsmaster_cmd_set_mode_realtime: Trpc_tsmaster_cmd_set_mode_realtime;
    rpc_tsmaster_cmd_set_mode_free: Trpc_tsmaster_cmd_set_mode_free;
    rpc_tsmaster_cmd_sim_step: Trpc_tsmaster_cmd_sim_step;
    rpc_tsmaster_cmd_sim_step_batch_start: Trpc_tsmaster_cmd_sim_step_batch_start;
    rpc_tsmaster_cmd_sim_step_batch_end: Trpc_tsmaster_cmd_sim_step_batch_end;
    rpc_tsmaster_cmd_get_project: Trpc_tsmaster_cmd_get_project;
    rpc_tsmaster_cmd_read_system_var: Trpc_tsmaster_cmd_read_system_var;
    rpc_tsmaster_cmd_read_signal: Trpc_tsmaster_cmd_read_signal;
    rpc_tsmaster_cmd_write_signal: Trpc_tsmaster_cmd_write_signal;
    rawsocket_htons: Trawsocket_htons;
    rawsocket_htonl: Trawsocket_htonl;
    rawsocket_get_errno: Trawsocket_get_errno;
    rawsocket_dhcp_start: Trawsocket_dhcp_start;
    rawsocket_dhcp_stop: Trawsocket_dhcp_stop;
    rawsocket: Trawsocket;
    rawsocket_close: Trawsocket_close;
    rawsocket_close_v2: Trawsocket_close_v2;
    rawsocket_shutdown: Trawsocket_shutdown;
    rawsocket_listen: Trawsocket_listen;
    rawsocket_recv: Trawsocket_recv;
    rawsocket_read: Trawsocket_read;
    rawsocket_aton: Trawsocket_aton;
    rawsocket_ntoa: Trawsocket_ntoa;
    rawsocket_ntoa6: Trawsocket_ntoa6;
    rawsocket_aton6: Trawsocket_aton6;
    tssocket_ping4: Ttssocket_ping4;
    tssocket_ping6: Ttssocket_ping6;
    rawsocket_recvmsg: Trawsocket_recvmsg;
    rawsocket_recvfrom: Trawsocket_recvfrom;
    rawsocket_readv: Trawsocket_readv;
    rawsocket_send: Trawsocket_send;
    rawsocket_sendto: Trawsocket_sendto;
    rawsocket_sendmsg: Trawsocket_sendmsg;
    rawsocket_write: Trawsocket_write;
    rawsocket_writev: Trawsocket_writev;
    rawsocket_fcntl: Trawsocket_fcntl;
    rawsocket_ioctl: Trawsocket_ioctl;
    rawsocket_accept: Trawsocket_accept;
    rawsocket_bind: Trawsocket_bind;
    rawsocket_getsockname: Trawsocket_getsockname;
    rawsocket_getpeername: Trawsocket_getpeername;
    rawsocket_getsockopt: Trawsocket_getsockopt;
    rawsocket_setsockopt: Trawsocket_setsockopt;
    rawsocket_poll: Trawsocket_poll;
    rawsocket_connect: Trawsocket_connect;
    rawsocket_inet_ntop: Trawsocket_inet_ntop;
    rawsocket_inet_pton: Trawsocket_inet_pton;
    rpc_tsmaster_cmd_set_can_signal: Trpc_tsmaster_cmd_set_can_signal;
    rpc_tsmaster_cmd_get_can_signal: Trpc_tsmaster_cmd_get_can_signal;
    rpc_tsmaster_cmd_get_lin_signal: Trpc_tsmaster_cmd_get_lin_signal;
    rpc_tsmaster_cmd_set_lin_signal: Trpc_tsmaster_cmd_set_lin_signal;
    rpc_tsmaster_cmd_set_flexray_signal: Trpc_tsmaster_cmd_set_flexray_signal;
    rpc_tsmaster_cmd_get_flexray_signal: Trpc_tsmaster_cmd_get_flexray_signal;
    rpc_tsmaster_cmd_get_constant: Trpc_tsmaster_cmd_get_constant;
    rpc_tsmaster_is_simulation_running: Trpc_tsmaster_is_simulation_running;
    rpc_tsmaster_call_system_api: Trpc_tsmaster_call_system_api;
    rpc_tsmaster_call_library_api: Trpc_tsmaster_call_library_api;
    rpc_tsmaster_cmd_register_signal_cache: Trpc_tsmaster_cmd_register_signal_cache;
    rpc_tsmaster_cmd_unregister_signal_cache: Trpc_tsmaster_cmd_unregister_signal_cache;
    rpc_tsmaster_cmd_get_signal_cache_value: Trpc_tsmaster_cmd_get_signal_cache_value;
    can_rbs_set_crc_signal_w_head_tail: Tcan_rbs_set_crc_signal_w_head_tail;
    cal_get_data_by_row_and_col: Tcal_get_data_by_row_and_col;
    cal_set_data_by_row_and_col: Tcal_set_data_by_row_and_col;
    tslog_blf_write_sysvar_double: Ttslog_blf_write_sysvar_double;
    tslog_blf_write_sysvar_s32: Ttslog_blf_write_sysvar_s32;
    tslog_blf_write_sysvar_u32: Ttslog_blf_write_sysvar_u32;
    tslog_blf_write_sysvar_s64: Ttslog_blf_write_sysvar_s64;
    tslog_blf_write_sysvar_u64: Ttslog_blf_write_sysvar_u64;
    tslog_blf_write_sysvar_string: Ttslog_blf_write_sysvar_string;
    tslog_blf_write_sysvar_double_array: Ttslog_blf_write_sysvar_double_array;
    tslog_blf_write_sysvar_s32_array: Ttslog_blf_write_sysvar_s32_array;
    tslog_blf_write_sysvar_u8_array: Ttslog_blf_write_sysvar_u8_array;
    cal_add_measurement_item: Tcal_add_measurement_item;
    cal_delete_measurement_item: Tcal_delete_measurement_item;
    cal_clear_measurement_items: Tcal_clear_measurement_items;
    rpc_tsmaster_cmd_start_can_rbs: Trpc_tsmaster_cmd_start_can_rbs;
    rpc_tsmaster_cmd_stop_can_rbs: Trpc_tsmaster_cmd_stop_can_rbs;
    rpc_tsmaster_cmd_start_lin_rbs: Trpc_tsmaster_cmd_start_lin_rbs;
    rpc_tsmaster_cmd_stop_lin_rbs: Trpc_tsmaster_cmd_stop_lin_rbs;
    rpc_tsmaster_cmd_start_flexray_rbs: Trpc_tsmaster_cmd_start_flexray_rbs;
    rpc_tsmaster_cmd_stop_flexray_rbs: Trpc_tsmaster_cmd_stop_flexray_rbs;
    rpc_tsmaster_cmd_is_can_rbs_running: Trpc_tsmaster_cmd_is_can_rbs_running;
    rpc_tsmaster_cmd_is_lin_rbs_running: Trpc_tsmaster_cmd_is_lin_rbs_running;
    rpc_tsmaster_cmd_is_flexray_rbs_running: Trpc_tsmaster_cmd_is_flexray_rbs_running;
    tssocket_add_ipv4_device: Ttssocket_add_ipv4_device;
    tssocket_delete_ipv4_device: Ttssocket_delete_ipv4_device;
    tsfifo_enable_receive_fifo: Ttsfifo_enable_receive_fifo;
    tsfifo_disable_receive_fifo: Ttsfifo_disable_receive_fifo;
    tsfifo_add_can_canfd_pass_filter: Ttsfifo_add_can_canfd_pass_filter;
    tsfifo_add_lin_pass_filter: Ttsfifo_add_lin_pass_filter;
    tsfifo_delete_can_canfd_pass_filter: Ttsfifo_delete_can_canfd_pass_filter;
    tsfifo_delete_lin_pass_filter: Ttsfifo_delete_lin_pass_filter;
    tsfifo_enable_receive_error_frames: Ttsfifo_enable_receive_error_frames;
    tsfifo_disable_receive_error_frames: Ttsfifo_disable_receive_error_frames;
    tsfifo_receive_can_msgs: Ttsfifo_receive_can_msgs;
    tsfifo_receive_canfd_msgs: Ttsfifo_receive_canfd_msgs;
    tsfifo_receive_lin_msgs: Ttsfifo_receive_lin_msgs;
    tsfifo_receive_flexray_msgs: Ttsfifo_receive_flexray_msgs;
    tsfifo_clear_can_receive_buffers: Ttsfifo_clear_can_receive_buffers;
    tsfifo_clear_canfd_receive_buffers: Ttsfifo_clear_canfd_receive_buffers;
    tsfifo_clear_lin_receive_buffers: Ttsfifo_clear_lin_receive_buffers;
    tsfifo_clear_flexray_receive_buffers: Ttsfifo_clear_flexray_receive_buffers;
    tsfifo_read_can_buffer_frame_count: Ttsfifo_read_can_buffer_frame_count;
    tsfifo_read_can_tx_buffer_frame_count: Ttsfifo_read_can_tx_buffer_frame_count;
    tsfifo_read_can_rx_buffer_frame_count: Ttsfifo_read_can_rx_buffer_frame_count;
    tsfifo_read_canfd_buffer_frame_count: Ttsfifo_read_canfd_buffer_frame_count;
    tsfifo_read_canfd_tx_buffer_frame_count: Ttsfifo_read_canfd_tx_buffer_frame_count;
    tsfifo_read_canfd_rx_buffer_frame_count: Ttsfifo_read_canfd_rx_buffer_frame_count;
    tsfifo_read_lin_buffer_frame_count: Ttsfifo_read_lin_buffer_frame_count;
    tsfifo_read_lin_tx_buffer_frame_count: Ttsfifo_read_lin_tx_buffer_frame_count;
    tsfifo_read_lin_rx_buffer_frame_count: Ttsfifo_read_lin_rx_buffer_frame_count;
    tsfifo_read_flexray_buffer_frame_count: Ttsfifo_read_flexray_buffer_frame_count;
    tsfifo_read_flexray_tx_buffer_frame_count: Ttsfifo_read_flexray_tx_buffer_frame_count;
    tsfifo_read_flexray_rx_buffer_frame_count: Ttsfifo_read_flexray_rx_buffer_frame_count;
    flexray_rbs_reset_update_bits: Tflexray_rbs_reset_update_bits;
    can_rbs_reset_update_bits: Tcan_rbs_reset_update_bits;
    can_rbs_fault_inject_handle_on_autosar_crc_event: Tcan_rbs_fault_inject_handle_on_autosar_crc_event;
    can_rbs_fault_inject_handle_on_autosar_rc_event: Tcan_rbs_fault_inject_handle_on_autosar_rc_event;
    can_rbs_fault_inject_unhandle_on_autosar_rc_event: Tcan_rbs_fault_inject_unhandle_on_autosar_rc_event;
    can_rbs_fault_inject_unhandle_on_autosar_crc_event: Tcan_rbs_fault_inject_unhandle_on_autosar_crc_event;
    eth_rbs_set_pdu_phase_and_cycle_by_name: Teth_rbs_set_pdu_phase_and_cycle_by_name;
    can_rbs_set_update_bits: Tcan_rbs_set_update_bits;
    flexray_rbs_set_update_bits: Tflexray_rbs_set_update_bits;
    rpc_ip_trigger_data_group: Trpc_ip_trigger_data_group;
    can_rbs_get_signal_raw_by_address: Tcan_rbs_get_signal_raw_by_address;
    eth_rbs_start: Teth_rbs_start;
    eth_rbs_stop: Teth_rbs_stop;
    eth_rbs_is_running: Teth_rbs_is_running;
    eth_rbs_configure: Teth_rbs_configure;
    eth_rbs_activate_all_networks: Teth_rbs_activate_all_networks;
    eth_rbs_activate_network_by_name: Teth_rbs_activate_network_by_name;
    eth_rbs_activate_node_by_name: Teth_rbs_activate_node_by_name;
    eth_rbs_activate_pdu_by_name: Teth_rbs_activate_pdu_by_name;
    eth_rbs_get_signal_value_by_element: Teth_rbs_get_signal_value_by_element;
    eth_rbs_set_signal_value_by_element: Teth_rbs_set_signal_value_by_element;
    eth_rbs_get_signal_value_by_address: Teth_rbs_get_signal_value_by_address;
    eth_rbs_set_signal_value_by_address: Teth_rbs_set_signal_value_by_address;
    lin_rbs_update_frame_by_id: Tlin_rbs_update_frame_by_id;
    lin_rbs_register_force_refresh_frame_by_id: Tlin_rbs_register_force_refresh_frame_by_id;
    lin_rbs_unregister_force_refresh_frame_by_id: Tlin_rbs_unregister_force_refresh_frame_by_id;
    rpc_data_channel_create: Trpc_data_channel_create;
    rpc_data_channel_delete: Trpc_data_channel_delete;
    rpc_data_channel_transmit: Trpc_data_channel_transmit;
    tssocket_getaddrinfo: Ttssocket_getaddrinfo;
    tssocket_freeaddrinfo: Ttssocket_freeaddrinfo;
    tssocket_gethostname: Ttssocket_gethostname;
    tssocket_getalldevices: Ttssocket_getalldevices;
    tssocket_freedevices: Ttssocket_freedevices;
    rawsocket_select: Trawsocket_select;
    tssocket_set_host_name: Ttssocket_set_host_name;
    tsdio_set_pwm_output_async: Ttsdio_set_pwm_output_async;
    tsdio_set_vlevel_output_async: Ttsdio_set_vlevel_output_async;
    can_il_register_autosar_pdu_event: Tcan_il_register_autosar_pdu_event;
    can_il_unregister_autosar_pdu_event: Tcan_il_unregister_autosar_pdu_event;
    can_il_register_autosar_pdu_pretx_event: Tcan_il_register_autosar_pdu_pretx_event;
    can_il_unregister_autosar_pdu_pretx_event: Tcan_il_unregister_autosar_pdu_pretx_event;
    can_rbs_fault_inject_disturb_sequencecounter: Tcan_rbs_fault_inject_disturb_sequencecounter;
    can_rbs_fault_inject_disturb_checksum: Tcan_rbs_fault_inject_disturb_checksum;
    can_rbs_fault_inject_disturb_updatebit: Tcan_rbs_fault_inject_disturb_updatebit;
    FDummy: array [0..563- 1] of NativeInt; // place holders, TS_COM_PROTO_END
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
    function ioip_create(const APortTCP, APortUDP: u16; const AOnTCPDataEvent, AOnUDPDataEvent: TOnIoIPData; AHandle: PNativeInt): s32; cdecl;
    function ioip_delete(const AHandle: NativeInt): s32; cdecl;
    function ioip_enable_tcp_server(const AHandle: NativeInt; const AEnable: Boolean): s32; cdecl;
    function ioip_enable_udp_server(const AHandle: NativeInt; const AEnable: Boolean): s32; cdecl;
    function ioip_connect_tcp_server(const AHandle: NativeInt; const AIpAddress: PAnsiChar; const APort: u16): s32; cdecl;
    function ioip_connect_udp_server(const AHandle: NativeInt; const AIpAddress: PAnsiChar; const APort: u16): s32; cdecl;
    function ioip_disconnect_tcp_server(const AHandle: NativeInt): s32; cdecl;
    function ioip_send_buffer_tcp(const AHandle: NativeInt; const APointer: Pointer; const ASize: s32): s32; cdecl;
    function ioip_send_buffer_udp(const AHandle: NativeInt; const APointer: Pointer; const ASize: s32): s32; cdecl;
    function ioip_receive_tcp_client_response(const AHandle: NativeInt; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32): s32; cdecl;
    function ioip_send_tcp_server_response(const AHandle: NativeInt; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; cdecl;
    function ioip_send_udp_broadcast(const AHandle: NativeInt; const APort: Word; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; cdecl;
    function ioip_set_udp_server_buffer_size(const AHandle: NativeInt; const ASize: s32): s32; cdecl;
    function ioip_receive_udp_client_response(const AHandle: NativeInt; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32): s32; cdecl;
    function ioip_send_udp_server_response(const AHandle: NativeInt; const ABufferToWriteFrom: Pointer; const ASize: s32): s32; cdecl;
    function eth_udp_fragment_processor_clear(): s32; cdecl;
    function eth_udp_fragment_processor_parse(const AHeader: PLIBEthernetHeader; AStatus: PUDPFragmentProcessStatus; APayload: ppByte; APayloadLength: pword; ACompleteHeader: PLIBEthernetHeader): s32; cdecl;
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
    signal_tester_clear_all: TSignalTesterClearAll;
    signal_tester_load_configuration: TSignalTesterLoadConfiguration;
    signal_tester_save_configuration: TSignalTesterSaveConfiguration;
    signal_tester_run_item_by_name: TSignalTesterRunItemByName;
    signal_tester_stop_item_by_name: TSignalTesterStopItemByName;
    signal_tester_run_item_by_index: TSignalTesterRunItemByIndex;
    signal_tester_stop_item_by_index: TSignalTesterStopItemByIndex;
    signal_tester_get_item_verdict_by_index: TSignalTesterGetItemVerdictByIndex;
    signal_tester_get_item_result_by_name: TSignalTesterGetItemResultByName;
    signal_tester_get_item_result_by_index: TSignalTesterGetItemResultByIndex;
    signal_tester_get_item_verdict_by_name: TSignalTesterGetItemVerdictByName;
    signal_tester_check_statistics_by_index: TSignalTesterCheckStatisticsByIndex;
    signal_tester_check_statistics_by_name: TSignalTesterCheckStatisticsByName;
    signal_tester_enable_item_by_index: TSignalTesterEnableItem;
    signal_tester_enable_item_by_name: TSignalTesterEnableItemByName;
    signal_tester_run_all: TSignalTesterRunAll;
    signal_tester_stop_all: TSignalTesterStopAll;
    set_classic_test_system_report_name: TSetClassicTestSystemReportName;
    signal_tester_get_item_status_by_index: TSignalTesterGetItemStatusByIndex;
    signal_tester_get_item_status_by_name: TSignalTesterGetItemStatusByName;
    signal_tester_set_item_time_range_by_index: TSignalTesterSetItemTimeRangeByIndex;
    signal_tester_set_item_time_range_by_name: TSignalTesterSetItemTimeRangeByName;
    signal_tester_set_item_value_range_by_index: TSignalTesterSetItemValueRangeByIndex;
    signal_tester_set_item_value_range_by_name: TSignalTesterSetItemValueRangeByName;
    classic_test_system_login: Tclassic_test_system_login;
    classic_test_system_import: Tclassic_test_system_import;
    log_formatted_value: Tlog_formatted_value;
    FDummy: array [0..942-1] of NativeInt; // place holders, TS_TEST_PROTO_END
    procedure set_verdict_ok(const AStr: PAnsiChar); cdecl;
    procedure set_verdict_nok(const AStr: PAnsiChar); cdecl;
    procedure set_verdict_cok(const AStr: PAnsiChar); cdecl;
    function  log(const AStr: PAnsiChar; const ALevel: s32): s32; cdecl;
    function  debug_log_info(const AFile: pansichar; const AFunc: pansichar; const ALine: s32; const AStr: pansichar; const ALevel: Integer): s32; cdecl;
    procedure write_result_string(const AName: PAnsiChar; const AValue: PAnsiChar; const ALevel: s32); cdecl;
    procedure write_result_value(const AName: PAnsiChar; const AValue: Double; const ALevel: s32); cdecl;
    function  write_result_image(const AName: PAnsiChar; const AImageFileFullPath: PAnsiChar): s32; cdecl;
    function  retrieve_current_result_folder(AFolder: PPAnsiChar): s32; cdecl;
    // TODO: assign fobjs...
  end;
  PTSTest = ^TTSTest;

  // TSMaster Configuration
  TTSMasterConfiguration = packed record // C type
    FTSApp: TTSApp;
    FTSCOM: TTSCOM;
    FTSTest: TTSTest;
    // place holders
    FDummy: array [0..3000-1] of NativeInt;
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

function TTSApp.disconnect: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_disconnect(fobj);

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

function TTSApp.start_log_w_filename(const AFileName: string): s32; cdecl;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_start_log_w_filename(FObj, pansichar(ansistring(AFileName)));

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

function TTSCOM.eth_udp_fragment_processor_clear: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_eth_udp_fragment_processor_clear(FObj);

end;

function TTSCOM.eth_udp_fragment_processor_parse(
  const AHeader: PLIBEthernetHeader; AStatus: PUDPFragmentProcessStatus;
  APayload: ppByte; APayloadLength: pword; ACompleteHeader: PLIBEthernetHeader): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_eth_udp_fragment_processor_parse(FObj, AHeader, AStatus, APayload, APayloadLength, ACompleteHeader);

end;

function TTSCOM.ioip_connect_tcp_server(const AHandle: NativeInt;
  const AIpAddress: PAnsiChar; const APort: u16): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_connect_tcp_server(fObj, AHandle, AIpAddress, APort);

end;

function TTSCOM.ioip_connect_udp_server(const AHandle: NativeInt;
  const AIpAddress: PAnsiChar; const APort: u16): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_connect_udp_server(fObj, AHandle, AIpAddress, APort);

end;

function TTSCOM.ioip_create(const APortTCP, APortUDP: u16;
  const AOnTCPDataEvent, AOnUDPDataEvent: TOnIoIPData; AHandle: PNativeInt): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_create(fObj, APortTCP, APortUDP, AOnTCPDataEvent, AOnUDPDataEvent, AHandle);

end;

function TTSCOM.ioip_delete(const AHandle: NativeInt): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_delete(fObj, AHandle);

end;

function TTSCOM.ioip_disconnect_tcp_server(const AHandle: NativeInt): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_disconnect_tcp_server(fObj, AHandle);

end;

function TTSCOM.ioip_enable_tcp_server(const AHandle: NativeInt;
  const AEnable: Boolean): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_enable_tcp_server(fObj, AHandle, AEnable);

end;

function TTSCOM.ioip_enable_udp_server(const AHandle: NativeInt;
  const AEnable: Boolean): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_enable_udp_server(fObj, AHandle, AEnable);

end;

function TTSCOM.ioip_receive_tcp_client_response(
  const AHandle: NativeInt; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32
): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_receive_tcp_client_response(fObj, AHandle, ATimeoutMs, ABufferToReadTo, AActualSize);

end;

function TTSCOM.ioip_receive_udp_client_response(
  const AHandle: NativeInt; const ATimeoutMs: s32; const ABufferToReadTo: Pointer; const AActualSize: ps32
): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_receive_udp_client_response(fObj, AHandle, ATimeoutMs, ABufferToReadTo, AActualSize);

end;

function TTSCOM.ioip_send_buffer_tcp(const AHandle: NativeInt;
  const APointer: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_buffer_tcp(fObj, AHandle, apointer, ASize);

end;

function TTSCOM.ioip_send_buffer_udp(const AHandle: NativeInt;
  const APointer: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_buffer_udp(fObj, AHandle, apointer, ASize);

end;

function TTSCOM.ioip_send_tcp_server_response(
  const AHandle: NativeInt; const ABufferToWriteFrom: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_tcp_server_response(fObj, AHandle, ABufferToWriteFrom, ASize);

end;

function TTSCOM.ioip_send_udp_broadcast(const AHandle: NativeInt;
  const APort: Word; const ABufferToWriteFrom: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_udp_broadcast(fObj, AHandle, APort, ABufferToWriteFrom, ASize);

end;

function TTSCOM.ioip_send_udp_server_response(
  const AHandle: NativeInt; const ABufferToWriteFrom: Pointer; const ASize: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := internal_ioip_send_udp_server_response(fObj, AHandle, ABufferToWriteFrom, ASize);

end;

function TTSCOM.ioip_set_udp_server_buffer_size(
  const AHandle: NativeInt; const ASize: s32
): s32;
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
{$IFDEF WIN32}
  SIZE_TSAPP = 4216;
  SIZE_TSCOM = 4128;
  SIZE_TSTEST = 4028;
  SIZE_TSMASTERCONFIGURATION = 24372;
{$ELSE}
  SIZE_TSAPP = 8432;
  SIZE_TSCOM = 8256;
  SIZE_TSTEST = 8056;
  SIZE_TSMASTERCONFIGURATION = 48744;
{$ENDIF}
begin
{$ifdef debug}
  OutputDebugString(PChar('TTSApp size = ' + IntToStr(SizeOf(ttsapp))));
  OutputDebugString(PChar('TTSCOM size = ' + IntToStr(SizeOf(TTSCOM))));
  OutputDebugString(PChar('TTSTest size = ' + IntToStr(SizeOf(ttstest))));
  OutputDebugString(PChar('TTSMasterConfiguration size = ' + IntToStr(SizeOf(TTSMasterConfiguration))));
  // check size
  Assert(SizeOf(ttsapp) = SIZE_TSAPP, 'TTSApp size should be ' + SIZE_TSAPP.tostring);
  Assert(SizeOf(TTSCOM) = SIZE_TSCOM, 'TTSApp size should be ' + SIZE_TSCOM.tostring);
  Assert(SizeOf(ttstest) = SIZE_TSTEST, 'TTSApp size should be ' + SIZE_TSTEST.tostring);
  Assert(SizeOf(TTSMasterConfiguration) = SIZE_TSMASTERCONFIGURATION, 'TTSApp size should be ' + SIZE_TSMASTERCONFIGURATION.tostring);
  // 2022-12-03 check record types
  Assert(SizeOf(TMPCANSignal) = 26, 'TMPCANSignal size should be 26');
  Assert(SizeOf(TMPLINSignal) = 26, 'TMPLINSignal size should be 26');
  Assert(SizeOf(TMPFlexRaySignal) = 40, 'TMPFlexRaySignal size should be 40');
  Assert(SizeOf(TMPDBProperties) = 1056, 'TMPDBProperties size should be 1056');
  Assert(SizeOf(TMPDBECUProperties) = 1040, 'TMPDBECUProperties size should be 1040');
  Assert(SizeOf(TMPDBFrameProperties) = 1088, 'TMPDBFrameProperties size should be 1088');
  Assert(SizeOf(TMPDBSignalProperties) = 1152, 'TMPDBSignalProperties size should be 1152');
{$endif}
end;

initialization
  CheckMPRecordSize;
  
end.

