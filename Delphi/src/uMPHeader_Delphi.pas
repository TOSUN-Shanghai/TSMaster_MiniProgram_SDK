unit uMPHeader_Delphi;

{
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
    fptBoolean, fptString, fptpBoolean, fptpString,
    fptPCAN, fptPCANFD, fptPLIN, fptMapping, fptCANFDControllerType, fptCANFDControllerMode
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
  TCANRBSGetSignalValueByElement = function (const AIdxChn: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; out AValue: Double): integer; stdcall;
  TCANRBSGetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; out AValue: Double): integer; stdcall;
  TCANRBSSetSignalValueByElement = function (const AIdxChn: s32; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; const AValue: Double): integer; stdcall;
  TCANRBSSetSignalValueByAddress = function (const ASymbolAddress: PAnsiChar; const AValue: Double): integer; stdcall;
  // blf functions
  TTSLog_blf_write_start = function (const AFileName: PAnsiChar; AHandle: ps32): s32; stdcall;
  TTSLog_blf_write_can = function (const AHandle: s32; const ACAN: PlibCAN): s32; stdcall;
  TTSLog_blf_write_can_fd = function (const AHandle: s32; const ACANFD: PLIBCANFD): s32; stdcall;
  TTSLog_blf_write_lin = function (const AHandle: s32; const ALIN: PLIBLIN): s32; stdcall;
  TTSLog_blf_write_realtime_comment = function (const AHandle: s32; const ATimeUs: s64; const AComment: PAnsiChar): s32; stdcall;
  TTSLog_blf_write_end = function (const AHandle: s32): s32; stdcall;
  TTSLog_blf_read_start = function (const AFileName: PAnsiChar; AHandle: ps32; AObjCount: ps32): s32; stdcall;
  TTSLog_blf_read_status = function (const AHandle: s32; AObjReadCount: ps32): s32; stdcall;
  TTSLog_blf_read_object = function (const AHandle: s32; AProgressedCnt: ps32; AType: PSupportedObjType; ACAN: PlibCAN; ALIN: PLIBLIN; ACANFD: PLIBCANFD): s32; stdcall;
  TTSLog_blf_read_object_w_comment = function (const AHandle: s32; AProgressedCnt: ps32; AType: PSupportedObjType; ACAN: PCAN; ALIN: PLIN; ACANFD: PCANFD; AComment: Prealtime_comment_t): s32; stdcall;
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
    FObj:                         Pointer                    ;
    set_current_application:      TTSAppSetCurrentApplication;
    get_current_application:      TTSAppGetCurrentApplication;
    del_application:              TTSAppDelApplication       ;
    add_application:              TTSAppAddApplication       ;
    get_application_list:         TTSAppGetApplicationList   ;
    set_can_channel_count:        TTSAppSetCANChannelCount   ;
    set_lin_channel_count:        TTSAppSetLINChannelCount   ;
    get_can_channel_count:        TTSAppGetCANChannelCount   ;
    get_lin_channel_count:        TTSAppGetLINChannelCount   ;
    set_mapping:                  TTSAppSetMapping           ;
    get_mapping:                  TTSAppGetMapping           ;
    del_mapping:                  TTSAppDeleteMapping        ;
    connect:                      TTSAppConnectApplication   ;
    disconnect:                   TTSAppDisconnectApplication;
    Log:                          TTSAppLogger               ;
    configure_baudrate_can:       TTSConfigureBaudrateCAN    ;
    configure_baudrate_canfd:     TTSConfigureBaudrateCANFD  ;
    set_turbo_mode:               TTSSetTurboMode            ;
    get_turbo_mode:               TTSGetTurboMode            ;
    get_error_description:        TTSGetErrorDescription     ;
    terminate_application_NA:     TTSTerminate               ;
    wait_NA:                      TTSWait                    ;
    internal_check:               TTSCheckError              ;
    start_log_NA:                 TTSStartLog                ;
    end_log_NA:                   TTSEndLog                  ;
    check_terminate_NA:           TTSCheckTerminate          ;
    get_timestamp:                TTSGetTimestampUs          ;
    show_confirm_dialog:          TTSShowConfirmDialog       ;
    pause:                        TTSPause                   ;
    internal_set_check_failed_terminate:   TTSSetCheckFailedTerminate;
    get_system_var_count       :   TTSAppGetSystemVarCount      ;
    get_system_var_def_by_index:   TTSAppGetSystemVarDefByIndex ;
    get_system_var_def_by_name :   TTSAppFindSystemVarDefByName ;
    get_system_var_double      :   TTSAppGetSystemVarDouble     ;
    get_system_var_int32       :   TTSAppGetSystemVarInt32      ;
    get_system_var_uint32      :   TTSAppGetSystemVarUInt32     ;
    get_system_var_int64       :   TTSAppGetSystemVarInt64      ;
    get_system_var_uint64      :   TTSAppGetSystemVarUInt64     ;
    get_system_var_uint8_array :   TTSAppGetSystemVarUInt8Array ;
    get_system_var_int32_array :   TTSAppGetSystemVarInt32Array ;
    get_system_var_int64_array :   TTSAppGetSystemVarInt64Array ;
    get_system_var_double_array:   TTSAppGetSystemVarDoubleArray;
    get_system_var_string      :   TTSAppGetSystemVarString     ;
    set_system_var_double      :   TTSAppSetSystemVarDouble     ;
    set_system_var_int32       :   TTSAppSetSystemVarInt32      ;
    set_system_var_uint32      :   TTSAppSetSystemVarUInt32     ;
    set_system_var_int64       :   TTSAppSetSystemVarInt64      ;
    set_system_var_uint64      :   TTSAppSetSystemVarUInt64     ;
    set_system_var_uint8_array :   TTSAppSetSystemVarUInt8Array ;
    set_system_var_int32_array :   TTSAppSetSystemVarInt32Array ;
    set_system_var_int64_array :   TTSAppSetSystemVarInt64Array ;
    set_system_var_double_array:   TTSAppSetSystemVarDoubleArray;
    set_system_var_string      :   TTSAppSetSystemVarString     ;
    make_toast                 :   TTSAppMakeToast              ;
    execute_python_string      :   TTSAppExecutePythonString    ;
    execute_python_script      :   TTSAppExecutePythonScript    ;
    execute_app                :   TTSAppExecuteApp             ;
    terminate_app_by_name      :   TTSAppTerminateAppByName     ;
    excel_load                 : Texcel_load                    ;
    excel_get_sheet_count      : Texcel_get_sheet_count         ;
    excel_set_sheet_count      : Texcel_set_sheet_count         ;
    excel_get_sheet_name       : Texcel_get_sheet_name          ;
    excel_get_cell_count       : Texcel_get_cell_count          ;
    excel_get_cell_value       : Texcel_get_cell_value          ;
    excel_set_cell_count       : Texcel_set_cell_count          ;
    excel_set_cell_value       : Texcel_set_cell_value          ;
    excel_unload               : Texcel_unload                  ;
    excel_unload_all           : Texcel_unload_all              ;
    log_system_var             : TTSAppLogSystemVar             ;
    excel_set_sheet_name       : Texcel_set_sheet_name          ;
    call_mini_program_api      : TTSAppCallMPAPI                ;
    split_string               : TTSAppSplitString              ;
    wait_system_var_existance  : TTSAppWaitSystemVarExistance   ;
    wait_system_var_disappear  : TTSAppWaitSystemVarDisappear   ;
    set_analysis_time_range    : TTSAppSetAnalysisTimeRange     ;
    get_configuration_file_name: TTSAppGetConfigurationFileName ;
    get_configuration_file_path: TTSAppGetConfigurationFilePath ;
    set_default_output_dir     : TTSAppSetDefaultOutputDir      ;
    save_screenshot            : TTSAppSaveScreenshot           ;
    enable_all_graphics        : TTSAppEnableGraphics           ;
    get_tsmaster_version       : TTSAppGetTSMasterVersion       ;
    ui_show_page_by_index      : TUIShowPageByIndex             ;
    ui_show_page_by_name       : TUIShowPageByName              ;
    // place holders
    FDummy                     : array [0..970-1] of s32;
    procedure TerminateApplication_NA; cdecl;
    function Wait(const ATimeMs: s32; const AMessage: PAnsiChar): s32; cdecl;
    function start_log: s32; cdecl;
    function end_log: s32; cdecl;
    function CheckTerminate_NA: s32; cdecl;
    function check(const AErrorCode: s32): s32; cdecl;
    function set_check_failed_terminate(const AToTerminate: Boolean): s32; cdecl;
  end;
  PTSApp = ^TTSApp;

  // TSMaster Communication record in C script
  TTSCOM = packed record // C type
    FObj:                    Pointer               ;
    // CAN functions
    transmit_can_async:      TTransmitCANAsync     ;
    transmit_can_sync:       TTransmitCANSync      ;
    // CAN FD functions
    transmit_canfd_async:    TTransmitCANFDAsync   ;
    transmit_canfd_sync:     TTransmitCANFDSync    ;
    // LIN functions
    transmit_lin_async:      TTransmitLINAsync     ;
    transmit_lin_sync:       TTransmitLINSync      ;
    // Database functions
    get_can_signal_value:    TMPGetCANSignalValue  ;
    set_can_signal_value:    TMPSetCANSignalValue  ;
    // Bus Statistics
    enable_bus_statistics:   TEnableBusStatistics  ;
    clear_bus_statistics:    TClearBusStatistics   ;
    get_bus_statistics:      TGetBusStatistics     ;
    get_fps_can:             TGetFPSCAN            ;
    get_fps_canfd:           TGetFPSCANFD          ;
    get_fps_lin:             TGetFPSLIN            ;
    // Bus functions
    wait_can_message_NA:      TWaitCANMessage       ;
    wait_canfd_message_NA:    TWaitCANFDMessage     ;
    add_cyclic_message_can:   TAddCyclicMsgCAN      ;
    add_cyclic_message_canfd: TAddCyclicMsgCANFD   ;
    del_cyclic_message_can:   TDeleteCyclicMsgCAN  ;
    del_cyclic_message_canfd: TDeleteCyclicMsgCANFD;
    del_cyclic_messages:      TDeleteCyclicMsgs    ;
    // bus callbacks
    register_event_can_NA:       TRegisterCANEvent;
    unregister_event_can_NA:     TUnregisterCANEvent;
    register_event_canfd_NA:     TRegisterCANFDEvent;
    unregister_event_canfd_NA:   TUnregisterCANFDEvent;
    register_event_lin_NA:       TRegisterLINEvent;
    unregister_event_lin_NA:     TUnregisterLINEvent;
    unregister_events_can_NA:    TUnregisterCANEvents;
    unregister_events_lin_NA:    TUnregisterLINEvents;
    unregister_events_canfd_NA:  TUnregisterCANFDEvents;
    unregister_events_all_NA:    TUnregisterALLEvents;
    // online replay
    tslog_add_online_replay_config     : Ttslog_add_online_replay_config ;
    tslog_set_online_replay_config     : Ttslog_set_online_replay_config ;
    tslog_get_online_replay_count      : Ttslog_get_online_replay_count  ;
    tslog_get_online_replay_config     : Ttslog_get_online_replay_config ;
    tslog_del_online_replay_config     : Ttslog_del_online_replay_config ;
    tslog_del_online_replay_configs    : Ttslog_del_online_replay_configs;
    tslog_start_online_replay          : Ttslog_start_online_replay      ;
    tslog_start_online_replays         : Ttslog_start_online_replays     ;
    tslog_pause_online_replay          : Ttslog_pause_online_replay      ;
    tslog_pause_online_replays         : Ttslog_pause_online_replays     ;
    tslog_stop_online_replay           : Ttslog_stop_online_replay       ;
    tslog_stop_online_replays          : Ttslog_stop_online_replays      ;
    tslog_get_online_replay_status     : Ttslog_get_online_replay_status ;
    // can rbs
    can_rbs_start                      : TCANRBSStart                    ;
    can_rbs_stop                       : TCANRBSStop                     ;
    can_rbs_is_running                 : TCANRBSIsRunning                ;
    can_rbs_configure                  : TCANRBSConfigure                ;
    can_rbs_activate_all_networks      : TCANRBSActivateAllNetworks      ;
    can_rbs_activate_network_by_name   : TCANRBSActivateNetworkByName    ;
    can_rbs_activate_node_by_name      : TCANRBSActivateNodeByName       ;
    can_rbs_activate_message_by_name   : TCANRBSActivateMessageByName    ;
    can_rbs_get_signal_value_by_element: TCANRBSGetSignalValueByElement  ;
    can_rbs_get_signal_value_by_address: TCANRBSGetSignalValueByAddress  ;
    can_rbs_set_signal_value_by_element: TCANRBSSetSignalValueByElement  ;
    can_rbs_set_signal_value_by_address: TCANRBSSetSignalValueByAddress  ;
    // bus internal pre-tx functions
    register_pretx_event_can_NA:      TRegisterPreTxCANEvent     ;
    unregister_pretx_event_can_NA:    TUnregisterPreTxCANEvent   ;
    register_pretx_event_canfd_NA:    TRegisterPreTxCANFDEvent   ;
    unregister_pretx_event_canfd_NA:  TUnregisterPreTxCANFDEvent ;
    register_pretx_event_lin_NA:      TRegisterPreTxLINEvent     ;
    unregister_pretx_event_lin_NA:    TUnregisterPreTxLINEvent   ;
    unregister_pretx_events_can_NA:   TUnregisterPreTxCANEvents  ;
    unregister_pretx_events_lin_NA:   TUnregisterPreTxLINEvents  ;
    unregister_pretx_events_canfd_NA: TUnregisterPreTxCANFDEvents;
    unregister_pretx_events_all_NA:   TUnregisterPreTxALLEvents  ;
    // blf functions
    tslog_blf_write_start     : Ttslog_blf_write_start     ;
    tslog_blf_write_can       : Ttslog_blf_write_can       ;
    tslog_blf_write_can_fd    : Ttslog_blf_write_can_fd    ;
    tslog_blf_write_lin       : Ttslog_blf_write_lin       ;
    tslog_blf_write_end       : Ttslog_blf_write_end       ;
    tslog_blf_read_start      : Ttslog_blf_read_start      ;
    tslog_blf_read_status     : Ttslog_blf_read_status     ;
    tslog_blf_read_object     : Ttslog_blf_read_object     ;
    tslog_blf_read_end        : Ttslog_blf_read_end        ;
    tslog_blf_seek_object_time: Ttslog_blf_seek_object_time;
    tslog_blf_to_asc          : Ttslog_blf_to_asc          ;
    tslog_asc_to_blf          : Ttslog_asc_to_blf          ;
    // IP functions
    ioip_create               : TIoIPCreate             ;
    ioip_delete               : TIoIPDelete             ;
    ioip_enable_tcp_server    : TIoIPEnableTCPServer    ;
    ioip_enable_udp_server    : TIoIPEnableUDPServer    ;
    ioip_connect_tcp_server   : TIoIPConnectTCPServer   ;
    ioip_connect_udp_server   : TIoIPConnectUDPServer   ;
    ioip_disconnect_tcp_server: TIoIPDisconnectTCPServer;
    ioip_send_buffer_tcp      : TIoIPSendBufferTCP      ;
    ioip_send_buffer_udp      : TIoIPSendBufferUDP      ;
    // blf functions for comment
    tslog_blf_write_realtime_comment: TTSLog_blf_write_realtime_comment;
    tslog_blf_read_object_w_comment : TTSLog_blf_read_object_w_comment;
    // place holders
    FDummy               : array [0..942-1] of s32;
    // internal functions
    function WaitCANMessage_NA(const ATxCAN: plibcan; const ARxCAN: PLIBCAN; const ATimeoutMs: s32): s32; cdecl;
    function WaitCANFDMessage_NA(const ATxCANFD: plibcanFD; const ARxCANFD: PLIBCANFD; const ATimeoutMs: s32): s32; cdecl;
    function RegisterCANEvent(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function UnregisterCANEvent(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function RegisterCANFDEvent(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function UnregisterCANFDEvent(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function RegisterLINEvent(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function UnregisterLINEvent(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function UnregisterCANEvents(): integer; cdecl;
    function UnregisterLINEvents(): integer; cdecl;
    function UnregisterCANFDEvents(): integer; cdecl;
    function UnregisterALLEvents(): integer; cdecl;
    function RegisterPreTxCANEvent(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function UnregisterPreTxCANEvent(const AEvent: TCANQueueEvent_Win32): integer; cdecl;
    function RegisterPreTxCANFDEvent(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function UnregisterPreTxCANFDEvent(const AEvent: TCANfdQueueEvent_Win32): integer; cdecl;
    function RegisterPreTxLINEvent(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function UnregisterPreTxLINEvent(const AEvent: TliNQueueEvent_Win32): integer; cdecl;
    function UnregisterPreTxCANEvents(): integer; cdecl;
    function UnregisterPreTxLINEvents(): integer; cdecl;
    function UnregisterPreTxCANFDEvents(): integer; cdecl;
    function UnregisterALLPreTxEvents(): integer; cdecl;
  end;
  PTSCOM = ^TTSCOM;

  // TSMaster test feature in C script
  TTSTest = packed record // C type
    FObj: Pointer;
    FSetVerdictOK_NA: TTestSetVerdictOK;
    FSetVerdictNOK_NA: TTestSetVerdictNOK;
    FSetVerdictCOK_NA: TTestSetVerdictCOK;
    FTestLog_NA: TTestLogger;
    FWriteResultString: TTestWriteResultString;
    FWriteResultValue: TTestWriteResultValue;
    FCheckErrorBegin: TTestCheckErrorBegin;
    FCheckErrorEnd: TTestCheckErrorEnd;
    FWriteResultImage: TTestWriteResultImage;
    FRetrieveCurrentResultFolder: TTestRetrieveCurrentResultFolder;
    // place holders
    FDummy           : array [0..996-1] of s32;
    procedure SetVerdictOK_NA(const AStr: PAnsiChar); cdecl;
    procedure SetVerdictNOK_NA(const AStr: PAnsiChar); cdecl;
    procedure SetVerdictCOK_NA(const AStr: PAnsiChar); cdecl;
    procedure Log_NA(const AStr: PAnsiChar; const ALevel: s32); cdecl;
    procedure WriteResultString_NA(const AName: PAnsiChar; const AValue: PAnsiChar; const ALevel: s32); cdecl;
    procedure WriteResultValue_NA(const AName: PAnsiChar; const AValue: Double; const ALevel: s32); cdecl;
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
  if 0 = AErrorCode then Exit(1);
  Exit(0);

end;

function TTSApp.CheckTerminate_NA: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := check_terminate_NA(FObj);

end;

function TTSApp.end_log: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := end_log_NA(fobj);

end;

function TTSApp.set_check_failed_terminate(const AToTerminate: Boolean): s32;
begin
  Result := 0;

end;

function TTSApp.start_log: s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := start_log_NA(FObj);

end;

procedure TTSApp.TerminateApplication_NA;
begin
  if not Assigned(FObj) then exit;
  terminate_application_NA(FObj);

end;

function TTSApp.Wait(const ATimeMs: s32; const AMessage: PAnsiChar): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := wait_NA(fobj, ATimeMs, AMessage);

end;

{ TTSCOM }

function TTSCOM.RegisterCANEvent(const AEvent: TCANQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := register_event_can_NA(FObj, AEvent);

end;

function TTSCOM.RegisterCANFDEvent(
  const AEvent: TCANfdQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := register_event_canfd_NA(fobj, AEvent);

end;

function TTSCOM.RegisterLINEvent(const AEvent: TliNQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := register_event_lin_NA(FObj, AEvent);

end;

function TTSCOM.RegisterPreTxCANEvent(
  const AEvent: TCANQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := register_pretx_event_can_NA(FObj, AEvent);

end;

function TTSCOM.RegisterPreTxCANFDEvent(
  const AEvent: TCANfdQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := register_pretx_event_canfd_NA(fobj, AEvent);

end;

function TTSCOM.RegisterPreTxLINEvent(
  const AEvent: TliNQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := register_pretx_event_lin_NA(FObj, AEvent);

end;

function TTSCOM.UnregisterALLEvents: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := unregister_events_all_NA(FObj);

end;

function TTSCOM.UnregisterALLPreTxEvents: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := unregister_pretx_events_all_NA(FObj);

end;

function TTSCOM.UnregisterCANEvent(const AEvent: TCANQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := unregister_event_can_NA(FObj, AEvent);

end;

function TTSCOM.UnregisterCANEvents: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := unregister_events_can_NA(FObj);

end;

function TTSCOM.UnregisterCANFDEvent(
  const AEvent: TCANfdQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := unregister_event_canfd_NA(fobj, aevent);

end;

function TTSCOM.UnregisterCANFDEvents: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := unregister_events_canfd_NA(FObj);

end;

function TTSCOM.UnregisterLINEvent(const AEvent: TliNQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := unregister_event_lin_NA(fobj, AEvent);

end;

function TTSCOM.UnregisterLINEvents: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := unregister_events_lin_NA(FObj);

end;

function TTSCOM.UnregisterPreTxCANEvent(
  const AEvent: TCANQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := unregister_pretx_event_can_NA(FObj, AEvent);

end;

function TTSCOM.UnregisterPreTxCANEvents: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := unregister_pretx_events_can_NA(FObj);

end;

function TTSCOM.UnregisterPreTxCANFDEvent(
  const AEvent: TCANfdQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := unregister_pretx_event_canfd_NA(fobj, aevent);

end;

function TTSCOM.UnregisterPreTxCANFDEvents: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := unregister_pretx_events_canfd_NA(FObj);

end;

function TTSCOM.UnregisterPreTxLINEvent(
  const AEvent: TliNQueueEvent_Win32): integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := unregister_pretx_event_lin_NA(fobj, AEvent);

end;

function TTSCOM.UnregisterPreTxLINEvents: integer;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  result := unregister_pretx_events_lin_NA(FObj);

end;

function TTSCOM.WaitCANFDMessage_NA(const ATxCANFD, ARxCANFD: PLIBCANFD;
  const ATimeoutMs: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := wait_canfd_message_NA(FObj, ATxCANFD, ARxCANFD, ATimeoutMs);

end;

function TTSCOM.WaitCANMessage_NA(const ATxCAN, ARxCAN: PLIBCAN;
  const ATimeoutMs: s32): s32;
begin
  if not Assigned(fobj) then exit(API_RETURN_GENERIC_FAIL);
  Result := wait_can_message_NA(FObj, ATxCAN, ARxCAN, ATimeoutMs);

end;

{ TTSTest }

procedure TTSTest.Log_NA(const AStr: PAnsiChar; const ALevel: s32);
begin
  if not Assigned(FObj) then exit;
  FTestLog_NA(FObj, astr, ALevel);

end;

procedure TTSTest.SetVerdictCOK_NA(const AStr: PAnsiChar);
begin
  if not Assigned(FObj) then exit;
  FSetVerdictcOK_NA(FObj, astr);

end;

procedure TTSTest.SetVerdictNOK_NA(const AStr: PAnsiChar);
begin
  if not Assigned(FObj) then exit;
  FSetVerdictnOK_NA(FObj, astr);

end;

procedure TTSTest.SetVerdictOK_NA(const AStr: PAnsiChar);
begin
  if not Assigned(FObj) then exit;
  FSetVerdictOK_NA(FObj, astr);

end;

procedure TTSTest.WriteResultString_NA(const AName, AValue: PAnsiChar;
  const ALevel: s32);
begin
  if not Assigned(FObj) then exit;
  FWriteResultString(FObj, AName, avalue, ALevel);

end;

procedure TTSTest.WriteResultValue_NA(const AName: PAnsiChar; const AValue: Double;
  const ALevel: s32);
begin
  if not Assigned(FObj) then exit;
  FWriteResultValue(FObj, AName, avalue, ALevel);

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
