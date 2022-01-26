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
  TSimFunctionParameterType = (
    fptS8 = 0, fptU8, fptS16, fptU16, fptS32, fptU32, fptSingle, fptDouble,
    fptpS8, fptpU8, fptpS16, fptpU16, fptpS32, fptpU32, fptpSingle, fptpDouble,
    fptBoolean, fptString, fptpBoolean, fptpString, fptppDouble,
    fptPCAN, fptPCANFD, fptPLIN, fptMapping, fptCANFDControllerType, fptCANFDControllerMode,
    fptS64, fptU64, fptpS64, fptpU64, fptpLIBSystemVarDef, fptpVoid, fptppVoid,
    fptOnIoIPData, fptpDouble1, fptpSingle1, fptpS321, fptpS322, fptpU321, fptpU322,
    fptRealtimeComment, fptpLogLevel, fptCheckResult, fptDoublexx, fptPChar,
    fptPCANSignal, fptSystemVar
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
  TTSAppLogger = procedure(const AStr: pansichar; const ALevel: Integer); stdcall;
  TTSSetTurboMode = function (const AEnable: Boolean): integer; stdcall;
  TTSGetTurboMode = function (out AEnable: Boolean): integer; stdcall;
  TTSGetErrorDescription = function (const ACode: Integer; ADesc: PPAnsiChar): Integer; stdcall;
  TTSTerminate = procedure(const AObj: Pointer); stdcall;
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
  // TS_APP_PROTO_END ==========================================================
  // hardware settings
  TTSConfigureBaudrateCAN = function(const AIdxChn: integer; const ABaudrateKbps: Single; const AListenOnly: boolean; const AInstallTermResistor120Ohm: Boolean): integer; stdcall;
  TTSConfigureBaudrateCANFD = function(const AIdxChn: integer; const ABaudrateKbpsArb, ABaudrateKbpsData: Single; const AControllerType: TLIBCANFDControllerType; const AControllerMode: TLIBCANFDControllerMode; const AInstallTermResistor120Ohm: Boolean): integer; stdcall;
  // communication async functions
  TTransmitCANAsync = function (const ACAN: PLIBCAN): integer; stdcall;
  TTransmitCANFDAsync = function (const ACANFD: PLIBCANFD): integer; stdcall;
  TTransmitLINAsync = function (const ALIN: PLIBLIN): integer; stdcall;
  TTransmitFastLINAsync = function (const ALIN: PLIBLIN): integer; stdcall;
  // database functions
  TMPGetCANSignalValue = function(const ASignal: PMPCANSignal; const AData: pu8): double; stdcall;
  TMPSetCANSignalValue = procedure(const ASignal: PMPCANSignal; const AData: pu8; const AValue: Double); stdcall;
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
  TCANRBSActivateNetworkByName = function (const AEnable: boolean; const ANetworkName: PAnsiChar; const AIncludingChildren: Boolean): integer; stdcall;
  TCANRBSActivateNodeByName = function (const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AIncludingChildren: Boolean): integer; stdcall;
  TCANRBSActivateMessageByName = function (const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall;
  TCANRBSSetMessageCycleByName = function (const AIntervalMs: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall;
  TCANRBSGetSignalValueByElement = function (const AIdxChn: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; out AValue: Double): integer; stdcall;
  TCANRBSGetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; out AValue: Double): integer; stdcall;
  TCANRBSSetSignalValueByElement = function (const AIdxChn: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; const AValue: Double): integer; stdcall;
  TCANRBSSetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; const AValue: Double): integer; stdcall;
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
  TTSLog_blf_to_asc = function (const ABLFFileName: PAnsiChar; const AASCFileName: pansichar; const AProgressCallback: TProgressCallback): s32; stdcall;
  TTSLog_asc_to_blf = function (const AASCFileName: PAnsiChar; const ABLFFileName: pansichar; const AProgressCallback: TProgressCallback): s32; stdcall;
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
  // TS_COM_PROTO_END
  // Test features
  TTestSetVerdictOK = procedure(const AObj: Pointer; const AStr: pansichar); stdcall;
  TTestSetVerdictNOK = procedure(const AObj: Pointer; const AStr: pansichar); stdcall;
  TTestSetVerdictCOK = procedure(const AObj: Pointer; const AStr: pansichar); stdcall;
  TTestLogger = procedure(const AObj: Pointer; const AStr: pansichar; const ALevel: Integer); stdcall;
  TTestWriteResultString = procedure(const AObj: Pointer; const AName: pansichar; const AValue: PAnsiChar; const ALevel: Integer); stdcall;
  TTestWriteResultValue = procedure(const AObj: Pointer; const AName: pansichar; const AValue: Double; const ALevel: Integer); stdcall;
  TTestCheckErrorBegin = procedure; stdcall;
  TTestCheckErrorEnd = function(const ACount: PInteger): integer; stdcall;
  TTestWriteResultImage = function(const AObj: Pointer; const AName: pansichar; const AImageFilePath: PAnsiChar): Integer; stdcall;
  TTestRetrieveCurrentResultFolder = function(const AObj: Pointer; AFolder: PPAnsiChar): Integer; stdcall;
  TTestCheckTerminate = function: integer; stdcall;
  // TS_TEST_PROTO_END

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
    Log                                 : TTSAppLogger                     ;
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
    // place holders
    FDummy                     : array [0.. 916 -1] of s32;
    procedure terminate_application; cdecl;
    function wait(const ATimeMs: s32; const AMessage: PAnsiChar): s32; cdecl;
    function start_log: s32; cdecl;
    function end_log: s32; cdecl;
    function check_terminate: s32; cdecl;
    function check(const AErrorCode: s32): s32; cdecl;
    function set_check_failed_terminate(const AToTerminate: Boolean): s32; cdecl;
    function set_thread_priority(const APriorty: s32): s32; cdecl;
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
    // place holders
    FDummy               : array [0..925 - 1] of s32;
    // internal functions
    function wait_can_message(const ATxCAN: plibcan; const ARxCAN: PLIBCAN; const ATimeoutMs: s32): s32; cdecl;
    function wait_canfd_message(const ATxCANFD: plibcanFD; const ARxCANFD: PLIBCANFD; const ATimeoutMs: s32): s32; cdecl;
    function register_event_can(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function unregister_event_can(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function register_event_canfd(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function unregister_event_canfd(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function register_event_lin(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function unregister_event_lin(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function unregister_events_can(): integer; cdecl;
    function unregister_events_lin(): integer; cdecl;
    function unregister_events_canfd(): integer; cdecl;
    function unregister_events_all(): integer; cdecl;
    function register_pretx_event_can(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_event_can(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function register_pretx_event_canfd(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_event_canfd(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function register_pretx_event_lin(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_event_lin(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function unregister_pretx_events_can(): integer; cdecl;
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
    // place holders
    FDummy                                  : array [0..995-1] of s32;
    procedure set_verdict_ok(const AStr: PAnsiChar); cdecl;
    procedure set_verdict_nok(const AStr: PAnsiChar); cdecl;
    procedure set_verdict_cok(const AStr: PAnsiChar); cdecl;
    procedure log(const AStr: PAnsiChar; const ALevel: s32); cdecl;
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

function TTSCOM.unregister_events_canfd: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_events_canfd(FObj);

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

function TTSCOM.unregister_pretx_events_canfd: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := internal_unregister_pretx_events_canfd(FObj);

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

procedure TTSTest.log(const AStr: PAnsiChar; const ALevel: s32);
begin
  if not Assigned(FObj) then exit;
  internal_log(FObj, astr, ALevel);

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
  aapp.Log(GetCStringFromString_OnlyOneParameter(astring), LVL_INFO);

end;

procedure LogError(const AApp: TTSApp; const AString: string);
begin
  AApp.Log(GetCStringFromString_OnlyOneParameter(astring), LVL_ERROR);

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

