﻿unit uIncLibTSMaster;

interface

uses
  Winapi.Windows;

const
  // DLL
  DLL_LIB_TSMASTER = 'TSMaster.dll';
  LOGGER_COUNT            = 7; // all count
  LOGGER_NO_OUTPUT        = 0; // disable output
  LOGGER_ERROR            = 1; // critical error, NOK, red
  LOGGER_WARNING          = 2; // warning, COK, blue
  LOGGER_OK               = 3; // success, OK, green
  LOGGER_HINT             = 4; // hint message, yellow
  LOGGER_INFO             = 5; // text message, window text
  LOGGER_VERBOSE          = 6; // debug message, gray
  LOGGER_TYPES: array [0..LOGGER_COUNT-1] of string = (
    'No output',
    'Error',
    'Warning',
    'OK',
    'Hint',
    'Info',
    'Verbose'
  );
  // Application channels
  CH1  = 0;
  CH2  = 1;
  CH3  = 2;
  CH4  = 3;
  CH5  = 4;
  CH6  = 5;
  CH7  = 6;
  CH8  = 7;
  CH9  = 8;
  CH10 = 9;
  CH11 = 10;
  CH12 = 11;
  CH13 = 12;
  CH14 = 13;
  CH15 = 14;
  CH16 = 15;
  CH17 = 16;
  CH18 = 17;
  CH19 = 18;
  CH20 = 19;
  CH21 = 20;
  CH22 = 21;
  CH23 = 22;
  CH24 = 23;
  CH25 = 24;
  CH26 = 25;
  CH27 = 26;
  CH28 = 27;
  CH29 = 28;
  CH30 = 29;
  CH31 = 30;
  CH32 = 31;

  MP_DATABASE_STR_LEN = 512;
  GENERIC_STRING_MAX_LENGTH = 32;

  //Data Logger
  MAX_SUPPORT_LOGGER_FILE_NUM  = 128;
  READ_LOGGER_FILE_NUM_ONCE_TIME = 30;

type
  pInt32 = ^Int32;
  ppInt32 = ^pInt32;
  // CAN frame definition = 24 B
  PLIBCAN = ^TLIBCAN;
  TLIBCAN = packed record
    FIdxChn: byte;           // channel index starting from 0        = CAN FD
    FProperties: byte;       // default 0, masked status:            = CAN FD
                             // [7] 0-normal frame, 1-error frame
                             // [6] 0-not logged, 1-already logged
                             // [5-3] tbd
                             // [2] 0-std frame, 1-extended frame
                             // [1] 0-data frame, 1-remote frame
                             // [0] dir: 0-RX, 1-TX
    FDLC: byte;              // dlc from 0 to 8                      = CAN FD
    FReserved: byte;         // reserved to keep alignment           <> CAN FD
    FIdentifier: integer;    // CAN identifier                       = CAN FD
    FTimeUS: int64;          // timestamp in us                      = CAN FD
    FData: array[0..7] of Byte; // 8 data bytes to send                 <> CAN FD
    procedure SetStdId(const AId: Int32; const ADLC: UInt32);
    procedure SetExtId(const AId: Int32; const ADLC: UInt32);
    function GetTX: Boolean;
    function GetData: boolean;
    function GetStd: Boolean;
    function GetErr: Boolean;
    procedure SetTX(const AValue: Boolean);
    procedure SetData(const AValue: Boolean);
    procedure SetStd(const AValue: Boolean);
    procedure SetErr(const AValue: Boolean);
    procedure FromString(const AStr: string);
    function GetLogged: boolean;
    procedure SetLogged(const Value: boolean);
    function ToString: string;
    function GetIsErrorFrame: boolean;
    procedure SetIsErrorFrame(const Value: Boolean);
    // properties
    property IsTX: Boolean read GetTX write SetTX;
    property IsData: boolean read GetData write SetData;
    property IsStd: boolean read GetStd write SetStd;
    property IsErrToken: Boolean read GetErr write SetErr;
    property IsLogged: boolean read GetLogged write SetLogged;
    property IsErrorFrame: Boolean read GetIsErrorFrame write SetIsErrorFrame;
  end;

  // CAN FD frame definition = 80 B
  PLIBCANFD = ^TLIBCANFD;
  TLIBCANFD = packed record
    FIdxChn: byte;           // channel index starting from 0        = CAN
    FProperties: byte;       // default 0, masked status:            = CAN
                             // [7] 0-normal frame, 1-error frame
                             // [6] 0-not logged, 1-already logged
                             // [5-3] tbd
                             // [2] 0-std frame, 1-extended frame
                             // [1] 0-data frame, 1-remote frame
                             // [0] dir: 0-RX, 1-TX
    FDLC: byte;              // dlc from 0 to 15                     = CAN
    FFDProperties: byte;     // [7-3] tbd                            <> CAN
                             // [2] ESI, The E RROR S TATE I NDICATOR (ESI) flag is transmitted dominant by error active nodes, recessive by error passive nodes. ESI does not exist in CAN format frames
                             // [1] BRS, If the bit is transmitted recessive, the bit rate is switched from the standard bit rate of the A RBITRATION P HASE to the preconfigured alternate bit rate of the D ATA P HASE . If it is transmitted dominant, the bit rate is not switched. BRS does not exist in CAN format frames.
                             // [0] EDL: 0-normal CAN frame, 1-FD frame, added 2020-02-12, The E XTENDED D ATA L ENGTH (EDL) bit is recessive. It only exists in CAN FD format frames
    FIdentifier: integer;    // CAN identifier                       = CAN
    FTimeUS: int64;          // timestamp in us                      = CAN
    FData: array [0..63] of Byte; // 64 data bytes to send                <> CAN
    procedure SetStdId(const AId: Int32; const ADLC: UInt32);
    procedure SetExtId(const AId: Int32; const ADLC: UInt32);
    function GetTX: Boolean;
    function GetData: boolean;
    function GetStd: Boolean;
    function GetErr: Boolean;
    procedure SetTX(const AValue: Boolean);
    procedure SetData(const AValue: Boolean);
    procedure SetStd(const AValue: Boolean);
    procedure SetErr(const AValue: Boolean);
    procedure FromString(const AStr: string);
    procedure FromTCAN(const ACAN: PLIBCAN);
    function GetLogged: boolean;
    procedure SetLogged(const Value: boolean);
    function ToString: string;
    function GetIsFD: Boolean;
    procedure SetIsFD(const AIsFD: Boolean);
    function GetIsBRS: boolean;
    procedure SetIsBRS(const AValue: Boolean);
    function GetDataLength: integer;
    function GetIsESI: boolean;
    procedure SetIsESI(const AValue: Boolean);
    function GetIsErrorFrame: boolean;
    procedure SetIsErrorFrame(const Value: Boolean);
    // properties
    property IsTX: Boolean read GetTX write SetTX;
    property IsData: boolean read GetData write SetData;
    property IsStd: boolean read GetStd write SetStd;
    property IsErrToken: Boolean read GetErr write SetErr;
    property IsLogged: boolean read GetLogged write SetLogged;
    property IsEDL: boolean read GetIsFD write setisfd;
    property IsBRS: Boolean read GetIsBRS write SetIsBRS;
    property IsESI: Boolean read GetIsESI write SetIsESI;
    property DataLength: integer read GetDataLength;
    property IsErrorFrame: boolean read GetIsErrorFrame write SetIsErrorFrame;
  end;

  // LIN frame definition = 24 B
  PLIBLIN = ^TLIBLIN;
  TLIBLIN = packed record
    FIdxChn: byte;           // channel index starting from 0
    FErrCode: byte;          //  0: normal
    FProperties: byte;       // default 0, masked status:
                             // [7] tbd
                             // [6] 0-not logged, 1-already logged
                             // [5-4] FHWType //DEV_MASTER,DEV_SLAVE,DEV_LISTENER
                             // [3] 0-not ReceivedSync, 1- ReceivedSync
                             // [2] 0-not received FReceiveBreak, 1-Received Break
                             // [1] 0-not send FReceiveBreak, 1-send Break
                             // [0] dir: 0-RX, 1-TX
    FDLC: byte;              // dlc from 0 to 8
    FIdentifier: byte;       // LIN identifier:0--64
    FChecksum: byte;         // LIN checksum
    FStatus: byte;           // place holder 1
    FTimeUS: int64;          // timestamp in us
    FData: array[0..7] of Byte; // 8 data bytes to send
    function GetTX: boolean;
    procedure SetTX(const AValue: Boolean);
    function GetData: boolean;
    procedure FromString(const AStr: string);
    function ToString: string;
    procedure SetId(const AId: integer; const ADLC: Integer);
    function GetIsErrorFrame: boolean;
    // properties
    property IsTX: Boolean read GetTX write SetTX;
    property IsData: boolean read GetData;
    property IsErrorFrame: boolean read GetIsErrorFrame;
  end;

  // FlexRay Frame 300 B
  TLIBFlexRay = packed record
	  FIdxChn: byte;                // channel index starting from 0
	  FChannelMask: byte;           // 0: reserved, 1: A, 2: B, 3: AB
	  FDir: byte;                   // 0: Rx, 1: Tx, 2: Tx Request
	  FPayloadLength: byte;         // payload length in bytes
	  FActualPayloadLength: byte;   // actual data bytes
	  FCycleNumber: byte;           // cycle number: 0~63
	  FCCType: byte;                // 0 = Architecture independent, 1 = Invalid CC type, 2 = Cyclone I, 3 = BUSDOCTOR, 4 = Cyclone II, 5 = Vector VN interface, 6 = VN - Sync - Pulse(only in Status Event, for debugging purposes only)
	  FReserved0: byte;             // 1 reserved byte
	  FHeaderCRCA: UInt16;          // header crc A
	  FHeaderCRCB: UInt16;          // header crc B
	  FFrameStateInfo: UInt16;      // bit 0~15, error flags
	  FSlotId: UInt16;              // static seg: 0~1023
    FFrameFlags: UInt32;          // bit 0~22
                                  // 0 1 = Null frame.
                                  // 1 1 = Data segment contains valid data
                                  // 2 1 = Sync bit
                                  // 3 1 = Startup flag
                                  // 4 1 = Payload preamble bit
                                  // 5 1 = Reserved bit
                                  // 6 1 = Error flag(error frame or invalid frame)
                                  // 7..14 Reserved
                                  // 15 1 = Async.monitoring has generated this event
                                  // 16 1 = Event is a PDU
                                  // 17 Valid for PDUs only.The bit is set if the PDU is valid(either if the PDU has no  // update bit, or the update bit for the PDU was set in the received frame).
                                  // 18 Reserved
                                  // 19 1 = Raw frame(only valid if PDUs are used in the configuration).A raw frame may  // contain PDUs in its payload
                                  // 20 1 = Dynamic segment	0 = Static segment
                                  // 21 This flag is only valid for frames and not for PDUs.	1 = The PDUs in the payload of  // this frame are logged in separate logging entries. 0 = The PDUs in the payload of this  // frame must be extracted out of this frame.The logging file does not contain separate  // PDU - entries.
                                  // 22 Valid for PDUs only.The bit is set if the PDU has an update bit
	  FFrameCRC: UInt32;            // frame crc
	  FReserved1: UInt64;           // 8 reserved bytes
	  FReserved2: UInt64;           // 8 reserved bytes
	  FTimeUs: UInt64;              // timestamp in us
	  FData: array[0..253] of Byte; // 254 data bytes
  end;
  PLIBFlexRay = ^TLIBFlexRay;

  // Ethernet Frame 28 B
  TLIBEthernetHeader = packed record
    FIdxChn: byte;                             // app channel index starting from 0 = Network index
	  FIdxSwitch: byte;                          // Network's switch index
    FIdxPort: byte;                            // Network's switch's port index, 0~127: measurement port, 128~255: virtual port
	  FDir: byte;                                // 0 = Rx, 1 = Tx, 2 = TxRq
	  FReserved0: byte;                          // 1 padding byte
    FReserved1: byte;                          // 1 padding byte
    FEthernetPayloadLength: word;              // Length of Ethernet payload data in bytes. Max. 1582 Byte(without Ethernet header), 1612 Byte(Inclusive ethernet header)
	  FProperties: uint32;                       // Bit 0
	  FTimeUs: uint64;                           // timestamp in us
    FEthernetDataPointer: pbyte;               // data pointer
{$IFDEF WIN32}
    FPaddings: uint32;                         // to be compatible with x64
{$ENDIF}
    // actual data bytes...
    procedure InitWithData(const AData: pbyte; const ALength: word);
    function  ToDisplayString: string;
    function  GetTX: Boolean;
    procedure SetTX(const Value: Boolean);
    function  ActualDataPointer: pbyte;
    function  TotalEthernetPacketLength: integer;
    function  ToETHFrameHash: integer;
    function  EthernetPayloadPointer: pbyte;   // ethernet data pointer + destination MAC (6B) + source MAC (6B) + ethernet type (2B)
    function  DestinationMACAddr: pbyte;
    function  SourceMACAddr: pbyte;
    function  EthernetTypeAddr: pbyte;
    function  EthernetType: word;
    // properties
    property IsTX: Boolean read GetTX write SetTX;
  end;
  PLIBEthernetHeader = ^TLIBEthernetHeader;
  TLIBEthernetMAX = packed record
    FHeader: TLIBEthernetHeader;
    FBytes: array[0..1612-1] of byte;        // starting by destination MAC, source MAC, ethernet type, payload...
  end;
  PEthernetMAX = ^TLIBEthernetMAX;

  TLibFlexRayClusterParameters = packed record
    // general parameters
    FShortName: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FLongName: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FDescription: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FSpeed: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FChannels: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FBitCountingPolicy: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FProtocol: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FProtocolVersion: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FMedium: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FIsHighLowBitOrder: Integer;
    FMaxFrameLengthByte: Integer;
    FNumberOfCycles: Integer;
    // cycle parameters
    FCycle_us: Integer;
    FBit_us: Double;
    FSampleClockPeriod_us: Double;
    FMacrotick_us: Double;
    FMacroPerCycle: Integer;
    FNumberOfStaticSlots: Integer;
    FStaticSlot_MT: Integer;
    FActionPointOffset_MT: Integer;
    FTSSTransmitter_gdBit: Integer;
    FPayloadLengthStatic_WORD: Integer;
    FNumberOfMiniSlots: Integer;
    FMiniSlot_MT: Integer;
    FMiniSlotActionPointOffset_MT: Integer;
    FDynamicSlotIdlePhase_MiniSlots: Integer;
    FSymbolWindow_MT: Integer;
    FNIT_MT: Integer;
    FSyncNodeMax: Integer;
    FNetworkManagementVectorLength: Integer;
    // Wakeup and startup parameters
    FListenNoise: Integer;
    FColdStartAttempts: Integer;
    FCASRxLowMax_gdBit: Integer;
    FWakeupSymbolRxIdle_gdBit: Integer;
    FWakeupSymbolRxLow_gdBit: Integer;
    FWakeupSymbolRxWindow_gdBit: Integer;
    FWakeupSymbolTxIdle_gdBit: Integer;
    FWakeupSymbolTxLow_gdBit: Integer;
    FMaxInitializationError_us: Double;
    // clock correction parameters
    FClusterDriftDamping_uT: Integer;
    FOffsetCorrectionStart_MT: Integer;
    FMaxWithoutClockCorrectionFatal: Integer;
    FMaxWithoutClockCorrectionPassive: Integer;
  end;
  PLibFlexRayClusterParameters = ^TLibFlexRayClusterParameters;

  TLibFlexRayControllerParameters = packed record
    // general parameters
    FShortName: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FConnectedChannels: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    // cycle parameters
    FMicroPerCycle_uT: Integer;
    FMicroPerMacroNom_uT: Integer;
    FMicroTick_us: Double;
    FSamplesPerMicrotick: Integer;
    // wakeup & startup parameters
    FWakeupChannelA: Integer;
    FWakeupChannelB: Integer;
    FMaxDrift_uT: Integer;
    FWakeupPattern: Integer;
    FListenTimeout_uT: Integer;
    FAcceptedStartupRange_uT: Integer;
    FMacroInitialOffsetA_MT: Integer;
    FMacroInitialOffsetB_MT: Integer;
    FMicroInitialOffsetA_uT: Integer;
    FMicroInitialOffsetB_uT: Integer;
    // clock correction parameters
    FKeySlotUsage: array[0..GENERIC_STRING_MAX_LENGTH-1] of AnsiChar;
    FKeySlotID: Integer;
    FSingleSlotEnabled: Integer;
    FClusterDriftDamping_uT: Integer;
    FDocodingCorrection_uT: Integer;
    FDelayCompensationA_uT: Integer;
    FDelayCompensationB_uT: Integer;
    FOffsetCorrectionOut_uT: Integer;
    FExternRateCorrection_uT: Integer;
    FRateCorrectionOut_uT: Integer;
    FExternOffsetCorrection_uT: Integer;
    FAllowHaltDueToClock: Integer;
    FAllowPassivToActive: Integer;
    // latesttx
    FLatestTx: Integer;
    FMaxDynamicPayloadLength: Integer;
  end;
  PLibFlexRayControllerParameters = ^TLibFlexRayControllerParameters;

    //Flexray
  PLibFlexray_controller_config = ^TLibFlexray_controller_config;
  TLibFlexray_controller_config = packed record
     NETWORK_MANAGEMENT_VECTOR_LENGTH: UInt8;
     PAYLOAD_LENGTH_STATIC: UInt8;
     FReserved: UInt16;
     LATEST_TX: UInt16;
    // __ prtc1Control
     T_S_S_TRANSMITTER: UInt16;
     CAS_RX_LOW_MAX: UInt8;
     SPEED: UInt8;      //0 for 10m, 1 for 5m, 2 for 2.5m, convert from Database
     WAKE_UP_SYMBOL_RX_WINDOW: UInt16;
     WAKE_UP_PATTERN: UInt8;
    // __ prtc2Control
     WAKE_UP_SYMBOL_RX_IDLE: UInt8;
     WAKE_UP_SYMBOL_RX_LOW: UInt8;
     WAKE_UP_SYMBOL_TX_IDLE: UInt8;
     WAKE_UP_SYMBOL_TX_LOW: UInt8;
    // __ succ1Config
     channelAConnectedNode: UInt8;      // Enable ChannelA: 0: Disable 1: Enable
     channelBConnectedNode: UInt8;      // Enable ChannelB: 0: Disable 1: Enable
     channelASymbolTransmitted: UInt8 ; // Enable Symble Transmit function of Channel A: 0: Disable 1: Enable
     channelBSymbolTransmitted: UInt8 ; // Enable Symble Transmit function of Channel B: 0: Disable 1: Enable
     ALLOW_HALT_DUE_TO_CLOCK: UInt8;
     SINGLE_SLOT_ENABLED: UInt8;        // FALSE_0, TRUE_1
     wake_up_idx: UInt8;                // Wake up channe: 0:ChannelA， 1:ChannelB
     ALLOW_PASSIVE_TO_ACTIVE: UInt8;
     COLD_START_ATTEMPTS: UInt8;
     synchFrameTransmitted: UInt8;      // Need to transmit sync frame
     startupFrameTransmitted: UInt8;    // Need to transmit startup frame
    // __ succ2Config
     LISTEN_TIMEOUT: UInt32;
     LISTEN_NOISE: UInt8;               //2_16
    // __ succ3Config
     MAX_WITHOUT_CLOCK_CORRECTION_PASSIVE: UInt8;
     MAX_WITHOUT_CLOCK_CORRECTION_FATAL: UInt8;
     REVERS0: UInt8;                    //Memory Align
    // __ gtuConfig
    // __ gtu01Config
     MICRO_PER_CYCLE: UInt32;
    // __ gtu02Config
     Macro_Per_Cycle: UInt16;
     SYNC_NODE_MAX: UInt8;
     REVERS1: UInt8;  //Memory Align
    // __ gtu03Config
     MICRO_INITIAL_OFFSET_A: UInt8;
     MICRO_INITIAL_OFFSET_B: UInt8;
     MACRO_INITIAL_OFFSET_A: UInt8;
     MACRO_INITIAL_OFFSET_B: UInt8;
    // __ gtu04Config
     N_I_T: UInt16;
     OFFSET_CORRECTION_START: UInt16;
    // __ gtu05Config
     DELAY_COMPENSATION_A: UInt8;
     DELAY_COMPENSATION_B: UInt8;
     CLUSTER_DRIFT_DAMPING: UInt8;
     DECODING_CORRECTION: UInt8;
    // __ gtu06Config
     ACCEPTED_STARTUP_RANGE: UInt16;
     MAX_DRIFT: UInt16;
    // __ gtu07Config
     STATIC_SLOT: UInt16;
     NUMBER_OF_STATIC_SLOTS: UInt16;
    // __ gtu08Config
     MINISLOT: UInt8;
     REVERS2: UInt8;  //Memory Align
     NUMBER_OF_MINISLOTS: UInt16;
    // __ gtu09Config
     DYNAMIC_SLOT_IDLE_PHASE: UInt8;
     ACTION_POINT_OFFSET: UInt8;
     MINISLOT_ACTION_POINT_OFFSET: UInt8;
     REVERS3: UInt8;  //Memory Align
    // __ gtu10Config
     OFFSET_CORRECTION_OUT: UInt16;
     RATE_CORRECTION_OUT: UInt16;
    // __ gtu11Config
     EXTERN_OFFSET_CORRECTION: UInt8;
     EXTERN_RATE_CORRECTION: UInt8;
    //
     REVERS4: UInt8;  //Memory Align
     config_byte: UInt8;  //Memory Align
     //bit0: 1：启用cha上终端电阻  0：不启用
     //bit1: 1：启用chb上终端电阻  0：不启用
     //bit2: 1：启用接收FIFO    0：不启用

     //bit4: 1：cha桥接使能             0：不使能
     //bit5: 1：chb桥接使能             0：不使能
  end;

  PLibTrigger_def = ^TLibTrigger_def;
  TLibTrigger_def = packed record
     frame_idx: UInt8;
     slot_id: UInt8;
     cycle_code: UInt8;//BASE-CYCLE + CYCLE-REPETITION
     config_byte: UInt8;
    //bit 0:是否使能通道A
    //bit 1:是否使能通道B
    //bit 2:是否网络管理报文
    //bit 3:传输模式，0表示连续传输，1表示单次触发
    //bit 4:是否为冷启动报文，只有缓冲区0可以置1
    //bit 5:是否为同步报文，只有缓冲区0/1可以置1
    //bit 6:
    //bit 7:帧类型：0-静态，1-动态
   end;

  PLibGPSData = ^TLibGPSData;
  TLibGPSData = packed record
     FTimeUS: Uint64;          // timestamp in us
     UTCTime: UInt32;
     UTCDate: UInt32;
     Latitude:Single;
     Longitude:Single;
     Speed:Single;
     Direct:Single;
     Altitude:Single;
     N_S:Byte;
     E_W:Byte;
     Satellite:Byte;
     FIdxChn:Byte;
  end;

  //TSLogger
  PEMMC_RECORD_DATA = ^TEMMC_RECORD_DATA;
  TEMMC_RECORD_DATA = packed record
    FUTCDate:UInt32;     //GlobalTimeSecond
    FUTCTime:UInt32;
    FStartSector:UInt32;          //Start Sector
    FSectorSize:UInt32;                 //FSize
    FOffSetMiniSecond:UInt32;
    function FDateTimeString(ATimeZone:Integer):string;
    function FDateTime(ATimeZone:Integer):TDateTime;
  end;   //8bytes, means max support
  PPEMMC_RECORD_NODE = ^PEMMC_RECORD_NODE;
  PEMMC_RECORD_NODE = ^TEMMC_RECORD_NODE;
  TEMMC_RECORD_NODE = packed record
    FIndex: UInt32;                //FIndex
    FRecordData: TEMMC_RECORD_DATA;
    FNext: PEMMC_RECORD_NODE;
    function RecordString:string;
    function GetSlibingNode(AIndex:Integer):PEMMC_RECORD_NODE;
  end;   //8bytes, means max support

  TCANQueueEvent_API = procedure(const AData: PlibCAN) of object; stdcall;
  TGPSQueueEvent_Win32 = procedure(const AObj: Pointer; const AData: PLibGPSData); stdcall;
  TCANQueueEvent_Win32 = procedure(const AObj: Pointer; const AData: PlibCAN); stdcall;
  TCANFDQueueEvent_Win32 = procedure(const AObj: Pointer; const AData: PlibCANFD); stdcall;
  TFlexRayQueueEvent_Win32 = procedure(const AObj: Pointer; const AData: Plibflexray); stdcall;
  TEthernetQueueEvent_Win32 = procedure(const AObj: Pointer; const AData: PlibEthernetHeader); stdcall;
  TLINQueueEvent_Win32 = procedure(const AObj: Pointer; const AData: PlibLIN); stdcall;
  TLIBTSMasterLogger = procedure(const AStr: PAnsiChar; const ALevel: Integer); stdcall;
  TFirmwareUpdateCallback = procedure(const AOpaque: TObject; const AStatus: UInt32; const APercentage100: Single); stdcall;
  TOnIoIPData = procedure(const APointer: Pointer; const ASize: Integer); stdcall;
  TOnIoIPData_API = procedure(const APointer: Pointer; const ASize: Integer) of object; stdcall;
  TOnIoIPConnection = procedure(const AIPAddress: pansichar; const APort: Integer); stdcall;
  TOnIoIPConnection_API = procedure(const AIPAddress: pansichar; const APort: Integer) of object; stdcall;
  TLIBWriteAPIDocumentFunc = procedure (const AObj: Pointer; const AName: pansichar; const AGroup: pansichar; const ADesc: pansichar; const AExample: pansichar; const AParaCount: integer); stdcall;
  TLIBWriteAPIParaFunc = procedure (const AObj: Pointer; const AIdx: integer; const AAPIName: pansichar; const AParaName: pansichar; const AIsConst: boolean; const AParaType: pansichar; const ADesc: pansichar); stdcall;
  TLIBWriteAPIDocument = procedure (const AObj: Pointer; const AWriteDoc: TLIBWriteAPIDocumentFunc; const AWritePara: TLIBWriteAPIParaFunc); stdcall;
  TLIBCheckResult = function: Boolean; stdcall;
  TLIBOnSysVarChange = procedure(const ACompleteName: pansichar); stdcall;

{$Z4}
  // for c type
  PLIBBusToolDeviceType = ^TLIBBusToolDeviceType;
  TLIBBusToolDeviceType = (
    BUS_UNKNOWN_TYPE           = 0,
    TS_TCP_DEVICE              = 1,
    XL_USB_DEVICE              = 2,
    TS_USB_DEVICE              = 3,
    PEAK_USB_DEVICE            = 4,
    KVASER_USB_DEVICE          = 5,
    ZLG_USB_DEVICE             = 6,
    ICS_USB_DEVICE             = 7,
    TS_TC1005_DEVICE           = 8,
    CANABLE_USB_DEVICE         = 9,
    TS_WIRELESS_OBD            = 10,
    BUS_DEV_TYPE_COUNT         = 11
  );
  TLIBApplicationChannelType = (
    APP_CAN = 0,
    APP_LIN = 1,
    APP_FlexRay = 2,
    APP_Ethernet = 3
  );
  TSignalType = (stCANSignal = 0, stLINSignal, stSystemVar, stFlexRay);
  TSignalCheckKind = (
    sckAlways = 0, sckAppear, sckStatistics, sckRisingEdge, sckFallingEdge,
    sckMonotonyRising, sckMonotonyFalling, sckFollow, sckJump, sckNoChange
  );
  TSignalStatisticsKind = (sskMin = 0, sskMax, sskAverage, sskStdDeviation);
  TFlexRayCompuMethod = (fcmIdentical = 0, fcmLinear, fcmScaleLinear, fcmTextTable, fcmTABNoIntp, fcmFormula);
  // CAN bus statistics
  TLIBCANBusStatistics = (
    cbsBusLoad = 0, cbsPeakLoad, cbsFpsStdData, cbsAllStdData,
    cbsFpsExtData, cbsAllExtData, cbsFpsStdRemote, cbsAllStdRemote,
    cbsFpsExtRemote, cbsAllExtRemote, cbsFpsErrorFrame, cbsAllErrorFrame
  );
  // System variables
  TLIBSystemVarType = (
    lsvtInt32 = 0, lsvtUInt32, lsvtInt64, lsvtUInt64, lsvtUInt8Array,
    lsvtInt32Array, lsvtInt64Array, lsvtDouble, lsvtDoubleArray, lsvtString
  );
  TSymbolMappingDirection = (smdBiDirection, smdSgnToSysVar, smdSysVarToSgn);
  // Offline replay
  TReplayPhase = (rppInit = 0, rppReplaying, rppEnded);
  // Online replay
  TLIBOnlineReplayTimingMode = (ortImmediately = 0, ortAsLog, ortDelayed);
  PLIBOnlineReplayTimingMode = ^TLIBOnlineReplayTimingMode;
  TLIBOnlineReplayStatus = (orsNotStarted = 0, orsRunning, orsPaused, orsCompleted, orsTerminated{in case of error});
  PLIBOnlineReplayStatus = ^TLIBOnlineReplayStatus;
  // RBS
  TLIBRBSInitValueOptions = (rivUseDB = 0, rivUseLast, rivUse0);
  // BLF
  TReadTimeCallback = procedure(const AObj: pointer; const ATime: PSystemTime{SystemTimeToDateTime}); stdcall;
  TReadProgressCallback = procedure(const AObj: pointer; const AProgress100: Double); stdcall;
  PSupportedObjType = ^TSupportedObjType; // TSupportedObjType must be 4 bytes aligned
  TSupportedObjType = (sotCAN = 0, sotLIN, sotCANFD, sotRealtimeComment, sotSystemVar, sotFlexRay, sotEthernet, sotUnknown = $FFFFFFF);
  Trealtime_comment_t = packed record
    FTimeUs: int64;
    FEventType: int32;
    FCapacity: uint32;
    FComment: pansichar;
{$IFDEF WIN32}
    FPadding: uint32;                     // to be compatible with x64
{$ENDIF}
  end;
  Prealtime_comment_t = ^Trealtime_comment_t;
  TLibSystemVar = packed record
    FTimeUs: int64;
    FType: TLIBSystemVarType;
    FNameCapacity: uint32;
    FDataCapacity: uint32;
    FName: pansichar;
    FData: pbyte;
{$IFDEF WIN32}
    FPadding: Int64;                      // to be compatible with x64
{$ENDIF}
    function ToDataString: string;
  end;
  PLibSystemVar = ^TLibSystemVar;
  TReadBLFRealtimeCommentCallback = procedure (const AObj: pointer; const AComment: Prealtime_comment_t; const AToTerminate: pboolean); stdcall;
  TReadBLFSystemVarCallback = procedure (const AObj: pointer; const ASysVar: PLibSystemVar; const AToTerminate: pboolean); stdcall;
  TReadUnsupportedCallback = procedure (const AObj: pointer); stdcall;
  // Graphic Program
  TLIBAutomationModuleRunningState = (amrsNotRun, amrsPrepareRun, amrsRunning, amrsPaused, amrsStepping, amrsFinished);
  PLIBAutomationModuleRunningState = ^TLIBAutomationModuleRunningState;
  TLIBAutomationSignalType = (lastCANSignal = 0, lastLINSignal, lastSysVar, lastLocalVar, lastConst, lastFlexRaySignal, lastImmediateValue, lastUnknown = $FFFFFFF);
  PLIBAutomationSignalType = ^TLIBAutomationSignalType;
  TLIBMPFuncSource = (lmfsSystemFunc, lmfsMPLib, lmfsInternal);
  TLIBSimVarType = (lvtInteger = 0, lvtDouble, lvtString, lvtCANMsg, lvtCANFDMsg, lvtLINMsg, lvtUnknown = $FFFFFFF);
  // STIM
  TSTIMSignalStatus = (sssStopped, sssRunning, sssPaused);
  PSTIMSignalStatus = ^TSTIMSignalStatus;
  // TS device type
  TLIBCANFDControllerType = (lfdtCAN = 0, lfdtISOCAN = 1, lfdtNonISOCAN = 2);
  TLIBCANFDControllerMode = (lfdmNormal = 0, lfdmACKOff = 1, lfdmRestricted = 2, lfdmInternalLoopback = 3, lfdmExternalLoopback = 4);
  TLIB_TS_Device_Sub_Type = (
    TS_UNKNOWN_DEVICE   = 0,
    TSCAN_PRO           = 1,  // TSCAN_PRO_4_CHs_SJA1000
    TSCAN_Lite1         = 2,  // TSCAN_LITE_2_CHs_INTL_2515
    TC1001              = 3,  // TSCAN_MINI_1_CHs_INTL
    TL1001              = 4,  // TSLIN_MINI_1_CHs           = 4,
    TC1011              = 5,  // TSCAN_FD_MINI_1_CHs_INTL   = 5,  // TSCAN FD Mini
    TM5011              = 6,  // TSCAN_LIN_IO_2_CHs_F105    = 6,
    TC1002              = 7,  // TSCAN_LITE_2_CHs_F105      = 7,
    TC1014              = 8,  // TSCAN_LIN_DIO_AIO          = 8,  // TSCANLIN
    TSCANFD2517         = 9,   // TSCAN_FD_MINI_1_CHs_2517   = 9
    TC1026              = 10,   //FD_1_LIN_6
    TC1016              = 11,   //FD_4_LIN_2
    TC1012              = 12,   //FD_1_LIN_1
    TC1013              = 13,   //FD_2
    TLog1002            = 14    //FD_2_LIN_2
  );
  // Vector XL device type
  TLIB_XL_Device_Sub_Type = (
    XL_NONE                      =    0,
    XL_VIRTUAL                   =    1,  // Tested, 1 ~ 8 Channels
    XL_CANCARDX                  =    2,
    XL_CANAC2PCI                 =    6,
    XL_CANCARDY                  =   12,
    XL_CANCARDXL                 =   15,
    XL_CANCASEXL                 =   21,
    XL_CANCASEXL_LOG_OBSOLETE    =   23,
    XL_CANBOARDXL                =   25,
    XL_CANBOARDXL_PXI            =   27,
    XL_VN2600                    =   29,
    XL_VN3300                    =   37,
    XL_VN3600                    =   39,
    XL_VN7600                    =   41,
    XL_CANCARDXLE                =   43,
    XL_VN8900                    =   45,
    XL_VN8950                    =   47,
    XL_VN2640                    =   53,
    XL_VN1610                    =   55,
    XL_VN1630                    =   57,  // Tested, 2 ~ 4 Channels
    XL_VN1640                    =   59,  // Tested, 4 Channels
    XL_VN8970                    =   61,
    XL_VN1611                    =   63,
    XL_VN5610                    =   65,
    XL_VN5620                    =   66,
    XL_VN7570                    =   67,
    XL_IPCLIENT                  =   69,
    XL_IPSERVER                  =   71,
    XL_VX1121                    =   73,
    XL_VX1131                    =   75,
    XL_VT6204                    =   77,
    XL_VN1630_LOG                =   79,
    XL_VN7610                    =   81,
    XL_VN7572                    =   83,
    XL_VN8972                    =   85,
    XL_VN0601                    =   87,
    XL_VN5640                    =   89,  // Tested, 2 Channels: CAN 17, CAN 18
    XL_VX0312                    =   91,
    XL_VH6501                    =   94,
    XL_VN8800                    =   95,
    XL_IPCL8800                  =   96,
    XL_IPSRV8800                 =   97,
    XL_CSMCAN                    =   98,
    XL_VN5610A                   =   101,
    XL_VN7640                    =   102,
    XL_VX1135                    =   104,
    XL_VN4610                    =   105,
    XL_VT6306                    =   107,
    XL_VT6104A                   =   108,
    XL_VN5430                    =   109,
    XL_VN1530                    =   112,
    XL_VN1531                    =   113
  );
{$Z1}
  // mp can signal
  TMPCANSignal = packed record
    FCANSgnType: uint8; // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
	  FIsIntel: Boolean;
	  FStartBit: int32;
	  FLength: int32;
	  FFactor: Double;
	  FOffset: Double;
  end;
  PMPCANSignal = ^TMPCANSignal;
  // mp lin signal
  TMPLINSignal = packed record
    FLINSgnType: uint8; // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
	  FIsIntel: Boolean;
	  FStartBit: int32;
	  FLength: int32;
	  FFactor: Double;
	  FOffset: Double;
  end;
  PMPLINSignal = ^TMPLINSignal;
  // mp flexray signal
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
  // TMPDBProperties for database properties, size = 1056
  TMPDBProperties = packed record
    FDBIndex: int32;
    FSignalCount: int32;
    FFrameCount: int32;
    FECUCount: int32;
    FSupportedChannelMask: uint64;
    FName: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FComment: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FFlags: UInt64;                                        // Bit 0: whether generate mp header
  end;
  PMPDBProperties = ^TMPDBProperties;
  // TMPDBECUProperties for database ECU properties, size = 1040
  TMPDBECUProperties = packed record
    FDBIndex: int32;
    FECUIndex: int32;
    FTxFrameCount: int32;
    FRxFrameCount: int32;
    FName: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FComment: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
  end;
  PMPDBECUProperties = ^TMPDBECUProperties;
  // TMPDBFrameProperties for database Frame properties, size = 1088
  TMPDBFrameProperties = packed record
    FDBIndex: int32;
    FECUIndex: int32;
    FFrameIndex: int32;
    FIsTx: uint8;
    FReserved1: uint8;
    FReserved2: uint8;
    FReserved3: uint8;
    FFrameType: TSignalType;
    // CAN
    FCANIsDataFrame: uint8;
    FCANIsStdFrame: uint8;
    FCANIsEdl: uint8;
    FCANIsBrs: uint8;
    FCANIdentifier: int32;
    FCANDLC: int32;
    FCANDataBytes: int32;
    // LIN
    FLINIdentifier: int32;
    FLINDLC: int32;
    // FlexRay
    FFRChannelMask: uint8;
    FFRBaseCycle: uint8;
    FFRCycleRepetition: uint8;
    FFRIsStartupFrame: uint8;
    FFRSlotId: uint16;
    FFRDLC: uint16;
    FFRCycleMask: uint64;
    FSignalCount: int32;
    FName: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
    FComment: array [0..MP_DATABASE_STR_LEN-1] of ansichar;
  end;
  PMPDBFrameProperties = ^TMPDBFrameProperties;
  // TMPDBSignalProperties for database signal properties, size = 1144
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

  // Hardware Info definition
  PLIBHWInfo = ^TLIBHWInfo;
  TLIBHWInfo = packed record
    FDeviceType: TLIBBusToolDeviceType;
    FDeviceIndex: integer;
    FVendorName: array[0..31] of AnsiChar;
    FDeviceName: array[0..31] of AnsiChar;
    FSerialString: array[0..63] of AnsiChar;
  end;
  // Mapping definition
  TLIBTSMapping = packed record
    FAppName: array[0..31] of AnsiChar;
    FAppChannelIndex: integer;
    FAppChannelType: TLIBApplicationChannelType;
    FHWDeviceType: TLIBBusToolDeviceType;
    FHWIndex: integer;
    FHWChannelIndex: integer;
    FHWDeviceSubType: Integer;
    FHWDeviceName: array[0..31] of AnsiChar;
    FMappingDisabled: boolean;
    function ToString: string;
    procedure Init;
    function SetMappingInfo(
      const AAppName: string;
      const AIdxLogicalChannel: integer;
      const AChnType: TLIBApplicationChannelType;
      const AHWDeviceType: TLIBBusToolDeviceType;
      const AIdxHW: integer;
      const AIdxHWChn: integer;
      const AHWDeviceSubType: integer;
      const AHWDeviceName: string
    ): Boolean;
  end;
  PLIBTSMapping = ^TLIBTSMapping;
  // system variable def
  TLIBSystemVarDef = packed record
    FName: array [0..31] of AnsiChar;
    FCategory: array [0..31] of AnsiChar;
    FComment: array [0..31] of ansichar;
    FDataType: TLIBSystemVarType;
    FIsReadOnly: Boolean;
    FValueMin: Double;
    FValueMax: double;
    FUnit: array [0..31] of ansichar;
  end;
  PLIBSystemVarDef = ^TLIBSystemVarDef;

  //LIN APIs
  TLINNodeType = ({0:}T_MasterNode,{1:}T_SlaveNode,{;2:}T_MonitorNode);
  TLINProtocol = ({0:}LIN_PROTOCL_13,{1:}LIN_PROTOCL_20,{;2:}LIN_PROTOCL_21,{;3:}LIN_PROTOCL_J2602);

  ISO_TP_RESAULT = (
      N_OK = 0
      , N_TP_TIMEOUT_AS= 139   //Maximum time for the sender to transmit data to the receiver, default 1000
      , N_TP_TIMEOUT_AR= 140   //Maximum time for the receiver to transmit flow control to the sender, default 1000
      , N_TP_TIMEOUT_BS= 141   //
      , N_TP_TIMEOUT_CR= 142
      , N_TP_WRONG_SN  = 143
      , N_TP_INVALID_FS= 144
      , N_TP_UNEXP_PDU = 145
      , N_TP_WFT_OVRN  = 146
      , N_TP_BUFFER_OVFLW          = 147
      , N_TP_NOT_IDLE              = 148
      , N_TP_ERROR_FROM_CAN_DRIVER = 149
      , N_LIN_MASTER_TRANSMIT_N_AS_TIMEOUT   = 202
      , N_LIN_MASTER_TRANSMIT_TRANSMIT_ERROR = 203
      , N_LIN_MASTER_REV_N_CR_TIMEOUT        = 204
      , N_LIN_MASTER_REV_ERROR               = 205
      , N_LIN_MASTER_REV_INTERLLEAVE_TIMEOUT = 206
      , N_LIN_MASTER_REV_NO_RESPONSE         = 207
      , N_LIN_MASTER_REV_SN_ERROR            = 208
      , N_LIN_SLAVE_TRANSMIT_N_CR_TIMEOUT    = 209
      , N_LIN_SLAVE_REV_N_CR_TIMEOUT         = 210
      , N_LIN_SLAVE_TRANSMIT_ERROR           = 211
      , N_LIN_SLAVE_REV_ERROR                = 212
      , N_ETH_GENERIC_ACK                    = 234
      , N_ETH_VEHILCE_INFO_RES               = 235
      , N_ETH_ACTIVATE_RES                   = 236
      , N_ETH_ALIVE_RES                      = 237
      , N_ETH_NODE_STATE_RES                 = 238
      , N_ETH_DIAG_POWER_MODE_RES            = 239
      , N_ETH_DIAG_POSITIVE_ACK                = 240
      , N_ETH_DIAG_NEGATIVE_ACK              = 241
      , N_ETH_VEHICLE_REQ_ID                 = 242
      , N_ETH_VEHICLE_REQ_EID_ID             = 243
      , N_ETH_VEHICLE_REQ_VIN_ID             = 244
      , N_ETH_ACTIVE_REQ                     = 245
      , N_ETH_ALIVE_REQ                      = 246
      , N_ETH_NODE_STATE_REQ                 = 247
      , N_ETH_DIAG_POWER_MODE_REQ            = 248
      , N_ETH_DIAG_REQ_RES                   = 249
      , N_ETH_RESERVED0                      = 250
      , N_ETH_RESERVED1                      = 251
  );

  N_USData_TranslateCompleted_Recall_Obj = procedure(const ATpModuleIndex:Integer;
                                       const AChn:Integer;
                                       const ABusType: byte;
                                       const ANAD: Integer; //byte->UInt16;
                                       const AIdentifier: Integer;
                                       const ATimeStamp: UInt64;
                                       const APayLoad:PByte; const ASize:UInt32;
                                       const AError: ISO_TP_RESAULT) of object; stdcall;//Reporting Received TP Data to Upper layer

  N_USData_TranslateCompleted_Recall = procedure(const ATpModuleIndex:Integer;
                                       const AChn:Integer;
                                       const ATimeStamp:UInt64;
                                       const APayLoad:PByte;
                                       const ASize:UInt32;
                                       const AError:ISO_TP_RESAULT);stdcall;//Reporting Received TP Data to Upper layer

const
  BUS_TOOL_DEVICE_TYPE_COUNT = 11;
  BUS_TOOL_DEVICE_NAMES: array [0..BUS_TOOL_DEVICE_TYPE_COUNT-1] of string = (
    'Unknown bus tool',
    'TS Virtual Device',
    'Vector',
    'TOSUN',
    'PEAK',
    'Kvaser',
    'ZLG',
    'IntrepidCS',
    'TOSUN TC1005',
    'CANAble',
    'TOSUN Wireless-OBD'
  );
  TS_HWTYPE_MAX_CNT = 17;
  TS_HWTYPE_NAMES: array [0..TS_HWTYPE_MAX_CNT-1] of string = (
    'Unknown',
    'TS.CAN Pro',
    'TS.CAN Lite1',
    'TC1001',       //3"TS.CAN Mini",
    'TL1001',       //4"TS.LIN Mini",
    'TC1011',       //5"TS.CAN FD Mini",
    'TSInterface',  //6"TSCANLIN+Interface"
    'TC1002',       //7"TS.CAN Lite2",
    'TC1014',       //8"TS.CANFD.LIN"
    'TS.CAN FD 2517',  //9
    'TC1026',             //10,   //FD_1_LIN_6
    'TC1016',             //11,   //FD_4_LIN_2
    'TC1012',             //12,   //FD_1_LIN_1
    'TC1013',             //13,   //FD_2
    'TLog1002',           //14    //FD_2_LIN_2
    'TC1034',
    'TC1018'
  );
  XL_HWTYPE_MAX_CNT = 120;
  XL_HWTYPE_NAMES: array [0..XL_HWTYPE_MAX_CNT-1] of string = (
    'None',             // 0
    'VIRTUAL',             // 1
    'CANCARDX',             // 2
    'None',             // 3
    'None',             // 4
    'None',             // 5
    'CANAC2PCI',             // 6
    'None',             // 7
    'None',             // 8
    'None',             // 9
    'None',             // 10
    'None',             // 11
    'CANCARDY',             // 12
    'None',             // 13
    'None',             // 14
    'CANCARDXL',             // 15
    'None',             // 16
    'None',             // 17
    'None',             // 18
    'None',             // 19
    'None',             // 20
    'CANCASEXL',             // 21
    'None',             // 22
    'CANCASEXL_LOG_OBSOLETE',             // 23
    'None',             // 24
    'CANBOARDXL',             // 25
    'None',             // 26
    'CANBOARDXL_PXI',             // 27
    'None',             // 28
    'VN2600',             // 29
    'None',             // 30
    'None',             // 31
    'None',             // 32
    'None',             // 33
    'None',             // 34
    'None',             // 35
    'None',             // 36
    'VN3300',             // 37
    'None',             // 38
    'VN3600',             // 39
    'None',             // 40
    'VN7600',             // 41
    'None',             // 42
    'CANCARDXLE',             // 43
    'None',             // 44
    'VN8900',             // 45
    'None',             // 46
    'VN8950',             // 47
    'None',             // 48
    'None',             // 49
    'None',             // 50
    'None',             // 51
    'None',             // 52
    'VN2640',             // 53
    'None',             // 54
    'VN1610',             // 55
    'None',             // 56
    'VN1630',             // 57
    'None',             // 58
    'VN1640',             // 59
    'None',             // 60
    'VN8970',             // 61
    'None',             // 62
    'VN1611',             // 63
    'None',             // 64
    'VN5610',             // 65
    'VN5620',             // 66
    'VN7570',             // 67
    'None',             // 68
    'IPCLIENT',             // 69
    'None',             // 70
    'IPSERVER',             // 71
    'None',             // 72
    'VX1121',             // 73
    'None',             // 74
    'VX1131',             // 75
    'None',             // 76
    'VT6204',             // 77
    'None',             // 78
    'VN1630_LOG',             // 79
    'None',             // 80
    'VN7610',             // 81
    'None',             // 82
    'VN7572',             // 83
    'None',             // 84
    'VN8972',             // 85
    'None',             // 86
    'VN0601',             // 87
    'None',             // 88
    'VN5640',             // 89
    'None',             // 90
    'VX0312',             // 91
    'None',             // 92
    'None',             // 93
    'VH6501',             // 94
    'VN8800',             // 95
    'IPCL8800',             // 96
    'IPSRV8800',             // 97
    'CSMCAN',             // 98
    'None',             // 99
    'None',             // 100
    'VN5610A',             // 101
    'VN7640',             // 102
    'None',             // 103
    'VX1135',             // 104
    'VN4610',             // 105
    'None',             // 106
    'VT6306',             // 107
    'VT6104A',             // 108
    'VN5430',             // 109
    'None',             // 110
    'None',             // 111
    'VN1530',             // 112
    'VN1531',            // 113
    'VX1161A',           // 114
    'VX1161B',           // 115
    'None',              // 116
    'None',              // 117
    'None',              // 118
    'None'               // 119
  );


{$IFNDEF LIBTSMASTER_IMPL}
const
  // error code
  IDX_ERR_OK                         = 0 ;
  IDX_ERR_IDX_OUT_OF_RANGE           = 1 ;
  IDX_ERR_CONNECT_FAILED             = 2 ;
  IDX_ERR_DEV_NOT_FOUND              = 3 ;
  IDX_ERR_CODE_NOT_VALID             = 4 ;
  IDX_ERR_ALREADY_CONNECTED          = 5 ;
  IDX_ERR_HID_WRITE_FAILED           = 6 ;
  IDX_ERR_HID_READ_FAILED            = 7 ;
  IDX_ERR_HID_TX_BUFF_OVERRUN        = 8 ;
  IDX_ERR_HID_TX_TOO_LARGE           = 9 ;
  IDX_ERR_PACKET_ID_INVALID          = 10;
  IDX_ERR_PACKET_LEN_INVALID         = 11;
  IDX_ERR_INTERNAL_TEST_FAILED       = 12;
  IDX_ERR_RX_PACKET_LOST             = 13;
  IDX_ERR_HID_SETUP_DI               = 14;
  IDX_ERR_HID_CREATE_FILE            = 15;
  IDX_ERR_HID_READ_HANDLE            = 16;
  IDX_ERR_HID_WRITE_HANDLE           = 17;
  IDX_ERR_HID_SET_INPUT_BUFF         = 18;
  IDX_ERR_HID_GET_PREPAESED          = 19;
  IDX_ERR_HID_GET_CAPS               = 20;
  IDX_ERR_HID_WRITE_FILE             = 21;
  IDX_ERR_HID_GET_OVERLAPPED         = 22;
  IDX_ERR_HID_SET_FEATURE            = 23;
  IDX_ERR_HID_GET_FEATURE            = 24;
  IDX_ERR_HID_DEVICE_IO_CTRL         = 25;
  IDX_ERR_HID_SEND_FEATURE_RPT       = 26;
  IDX_ERR_HID_GET_MANU_STR           = 27;
  IDX_ERR_HID_GET_PROD_STR           = 28;
  IDX_ERR_HID_GET_SERIAL_STR         = 29;
  IDX_ERR_HID_GET_INDEXED_STR        = 30;
  IDX_ERR_TX_TIMEDOUT                = 31;
  IDX_ERR_HW_DFU_WRITE_FLASH_FAILED  = 32; // hw write flash failed
  IDX_ERR_HW_DFU_WRITE_WO_ERASE      = 33; // hw write data without erase
  IDX_ERR_HW_DFU_CRC_CHECK_ERROR     = 34; // hw crc check error
  IDX_ERR_HW_DFU_COMMAND_TIMED_OUT   = 35; // hw dfu command timed out
  IDX_ERR_HW_PACKET_ID_INVALID       = 36; // hw packet id invalid
  IDX_ERR_HW_PACKET_LEN_INVALID      = 37; // hw packet len invalid
  IDX_ERR_HW_INTERNAL_TEST_FAILED    = 38; // hw internal test failed
  IDX_ERR_HW_RX_FROM_PC_PACKET_LOST  = 39; // hw rx from pc packet lost
  IDX_ERR_HW_TX_TO_PC_BUFF_OVERRUN   = 40; // hw tx to pc buffer overrun
  IDX_ERR_HW_API_PAEAMETER_INVALID   = 41; // hw api parameter invalid
  IDX_ERR_DFU_FILE_LOAD_FAILED       = 42;
  IDX_ERR_DFU_HEADER_WRITE_FAILED    = 43;
  IDX_ERR_READ_STATUS_TIMEDOUT       = 44;
  IDX_ERR_CALLBACK_ALREADY_EXISTS    = 45;
  IDX_ERR_CALLBACK_NOT_EXISTS        = 46;
  IDX_ERR_FILE_INVALID               = 47; // database file corrupted or not recognized
  IDX_ERR_DB_ID_NOT_FOUND            = 48; // database unique id not found
  IDX_ERR_SW_API_PAEAMETER_INVALID   = 49; // software api parameter invalid
  IDX_ERR_SW_API_GENERIC_TIMEOUT     = 50; // software api generic timed out
  IDX_ERR_SW_API_SET_CONF_FAILED     = 51; // software api set hw conf failed
  IDX_ERR_SW_API_INDEX_OUT_OF_BOUNDS = 52; // index out of bounds
  IDX_ERR_SW_API_WAIT_TIMEOUT        = 53; // rx wait timed out
  IDX_ERR_SW_API_GET_IO_FAILED       = 54; // get io failed
  IDX_ERR_SW_API_SET_IO_FAILED       = 55; // set io failed
  IDX_ERR_SW_API_REPLAY_ON_GOING     = 56; // a replay is already on goning
  IDX_ERR_SW_API_INSTANCE_NOT_EXISTS = 57; // instance not exists
  IDX_ERR_HW_CAN_TRANSMIT_FAILED     = 58; // can transmit frame failed
  IDX_ERR_HW_NO_RESPONSE             = 59; // no response from hardware
  IDX_ERR_SW_CAN_MSG_NOT_FOUND       = 60; // can message not found
  IDX_ERR_SW_CAN_RECV_BUFFER_EMPTY   = 61; // user can recv message buffer empty
  IDX_ERR_SW_CAN_RECV_PARTIAL_READ   = 62; // total read count <> desired read count
  IDX_ERR_SW_API_LINCONFIG_FAILED    = 63;
  IDX_ERR_SW_API_FRAMENUM_OUTOFRANGE = 64;
  IDX_ERR_SW_API_LDFCONFIG_FAILED    = 65;
  IDX_ERR_SW_API_LDFCONFIG_CMDERR    = 66;
  IDX_ERR_SW_ENV_NOT_READY           = 67; // key not retrieved
  IDX_ERR_SECURITY_FAILED            = 68;
  IDX_ERR_XL_ERROR                   = 69; // XL driver failed
  IDX_ERR_SEC_INDEX_OUTOFRANGE           = 70;
  IDX_SEC_ERR_STRINGLENGTH_OUTFOF_RANGE  = 71;
  IDX_SEC_ERR_KEY_IS_NOT_INITIALIZATION  = 72;
  IDX_SEC_ERR_KEY_IS_WRONG               = 73;
  IDX_SEC_ERR_NOT_PERMIT_WRITE           = 74;
  IDX_SEC_ERR_16BYTES_MULTIPLE           = 75;
  IDX_ERR_LIN_CHN_OUTOF_RANGE            = 76;
  IDX_ERR_DLL_NOT_READY                  = 77;
  IDX_ERR_FEATURE_NOT_SUPPORTED          = 78;
  IDX_ERR_COMMON_SERV_ERROR              = 79;
  IDX_ERR_READ_PARA_OVERFLOW             = 80;
  IDX_ERR_INVALID_CHANNEL_MAPPING        = 81;
  IDX_ERR_TSLIB_GENERIC_OPERATION_FAILED = 82;
  IDX_ERR_TSLIB_ITEM_ALREADY_EXISTS      = 83;
  IDX_ERR_TSLIB_ITEM_NOT_FOUND           = 84;
  IDX_ERR_TSLIB_LOGICAL_CHANNEL_INVALID  = 85;
  IDX_ERR_FILE_NOT_EXISTS                = 86;
  IDX_ERR_NO_INIT_ACCESS                 = 87;
  IDX_ERR_CHN_NOT_ACTIVE                 = 88;
  IDX_ERR_CHN_NOT_CREATED                = 89;
  IDX_ERR_APPNAME_LENGTH_OUT_OF_RANGE    = 90;
  IDX_ERR_PROJECT_IS_MODIFIED            = 91;
  IDX_ERR_SIGNAL_NOT_FOUND_IN_DB         = 92;
  IDX_ERR_MESSAGE_NOT_FOUND_IN_DB        = 93;
  IDX_ERR_TSMASTER_IS_NOT_INSTALLED      = 94;
  IDX_ERR_LIB_LOAD_FAILED                = 95;
  IDX_ERR_LIB_FUNCTION_NOT_FOUND         = 96;
  IDX_ERR_LIB_NOT_INITIALIZED            = 97;
  IDX_ERR_PCAN_GENRIC_ERROR              = 98;
  IDX_ERR_KVASER_GENERIC_ERROR           = 99;
  IDX_ERR_ZLG_GENERIC_ERROR              = 100;
  IDX_ERR_ICS_GENERIC_ERROR              = 101;
  IDX_ERR_TC1005_GENERIC_ERROR           = 102;
  IDX_ERR_SYSTEM_VAR_NOT_FOUND           = 103;
  IDX_ERR_INCORRECT_SYSTEM_VAR_TYPE      = 104;
  IDX_ERR_CYCLIC_MSG_NOT_EXIST           = 105;
  IDX_ERR_BAUD_NOT_AVAIL                 = 106;
  IDX_ERR_DEV_NOT_SUPPORT_SYNC_SEND      = 107;
  IDX_ERR_MP_WAIT_TIME_NOT_SATISFIED     = 108;
  IDX_ERR_CANNOT_OPERATE_WHILE_CONNECTED = 109;
  IDX_ERR_CREATE_FILE_FAILED             = 110;
  IDX_ERR_PYTHON_EXECUTE_FAILED          = 111;
  IDX_ERR_SIGNAL_MULTIPLEXED_NOT_ACTIVE  = 112;
  IDX_ERR_GET_HANDLE_BY_CHANNEL_FAILED   = 113;
  IDX_ERR_CANNOT_OPERATE_WHILE_APP_CONN  = 114;
  IDX_ERR_FILE_LOAD_FAILED               = 115;
  IDX_ERR_READ_LINDATA_FAILED            = 116;
  IDX_ERR_FIFO_NOT_ENABLED               = 117;
  IDX_ERR_INVALID_HANDLE                 = 118;
  IDX_ERR_READ_FILE_ERROR                = 119;
  IDX_ERR_READ_TO_EOF                    = 120;
  IDX_ERR_CONF_NOT_SAVED                 = 121;
  IDX_ERR_IP_PORT_OPEN_FAILED            = 122;
  IDX_ERR_IP_TCP_CONNECT_FAILED          = 123;
  IDX_ERR_DIR_NOT_EXISTS                 = 124;
  IDX_ERR_CURRENT_LIB_NOT_SUPPORTED      = 125;
  IDX_ERR_TEST_NOT_RUNNING               = 126;
  IDX_ERR_SERV_RESPONSE_NOT_RECV         = 127;
  IDX_ERR_CREATE_DIR_FAILED              = 128;
  IDX_ERR_INCORRECT_ARGUMENT_TYPE        = 129;
  IDX_ERR_READ_DATA_PACKAGE_OVERFLOW     = 130;
  IDX_ERR_REPLAY_IS_ALREADY_RUNNING      = 131;
  IDX_ERR_REPALY_MAP_ALREADY_EXIST       = 132;
  IDX_ERR_USER_CANCEL_INPUT              = 133;
  IDX_ERR_API_CHECK_FAILED               = 134;
  IDX_ERR_CANABLE_GENERIC_ERROR          = 135;
  IDX_ERR_WAIT_CRITERIA_NOT_SATISFIED    = 136;
  IDX_ERR_REQUIRE_APP_CONNECTED          = 137;
  IDX_ERR_PROJECT_PATH_ALREADY_USED      = 138;
  IDX_ERR_TP_TIMEOUT_AS                  = 139;  {CAN Diagnostic}
  IDX_ERR_TP_TIMEOUT_AR                  = 140;
  IDX_ERR_TP_TIMEOUT_BS                  = 141;
  IDX_ERR_TP_TIMEOUT_CR                  = 142;
  IDX_ERR_TP_WRONG_SN                    = 143;
  IDX_ERR_TP_INVALID_FS                  = 144;
  IDX_ERR_TP_UNEXP_PDU                   = 145;
  IDX_ERR_TP_WFT_OVRN                    = 146;
  IDX_ERR_TP_BUFFER_OVFLW                = 147;
  IDX_ERR_TP_NOT_IDLE                    = 148;
  IDX_ERR_TP_ERROR_FROM_CAN_DRIVER       = 149;
  IDX_ERR_TP_HANDLE_NOT_EXIST            = 150;
  IDX_ERR_UDS_EVENT_BUFFER_IS_FULL       = 151;
  IDX_ERR_UDS_HANDLE_POOL_IS_FULL        = 152;
  IDX_ERR_UDS_NULL_POINTER               = 153;
  IDX_ERR_UDS_MESSAGE_INVALID            = 154;
  IDX_ERR_UDS_NO_DATA                    = 155;
  IDX_ERR_UDS_MODULE_NOT_EXISTING        = 156;
  IDX_ERR_UDS_MODULE_NOT_READY           = 157;
  IDX_ERR_UDS_SEND_DATA_FAILED           = 158;
  IDX_ERR_UDS_NOT_SUPPORTED              = 159;
  IDX_ERR_UDS_TIMEOUT_SENDING_REQUEST    = 160;
  IDX_ERR_UDS_TIMEOUT_GET_RESPONSE       = 161;
  IDX_ERR_UDS_NEGATIVE_RESPONSE          = 162;
  IDX_ERR_UDS_NEGATIVE_WITH_EXPECTED_NRC = 163;
  IDX_ERR_UDS_NEGATIVE_UNEXPECTED_NRC    = 164;
  IDX_ERR_UDS_CANTOOL_NOT_READY          = 165;
  IDX_ERR_UDS_DATA_OUTOF_RANGE           = 166;
  IDX_ERR_UDS_UNEXPECTED_FRAME           = 167;
  IDX_ERR_UDS_UNEXPECTED_POSTIVE_RESPONSE           = 168; // 此服务不想收到肯定答复，结果收到了肯定答复
  IDX_ERR_UDS_POSITIVE_REPONSE_WITH_WRONG_DATA      = 169;
  IDX_ERR_UDS_GET_POSITIVE_RESPONSE_FAILED          = 170;
  IDX_ERR_UDS_MaxNumOfBlockLen_OVER_FLOW            = 171;
  IDX_ERR_UDS_NEGATIVE_RESPONSE_WITH_UNEXPECTED_NRC = 172;
  IDX_ERR_UDS_SERVICE_IS_RUNNING         = 173;
  IDX_ERR_UDS_NEED_APPLY_DOWNLOAD_FIRST  = 174;
  IDX_ERR_UDS_RESPONSE_DATA_LENGTH_ERR   = 175;
  IDX_ERR_TEST_CHECK_LOWER               = 176;
  IDX_ERR_TEST_CHECK_UPPER               = 177;
  IDX_ERR_TEST_VERDICT_CHECK_FAILED      = 178;
  IDX_ERR_AM_NOT_LOADED                  = 179;
  IDX_ERR_PANEL_NOT_FOUND                = 180;
  IDX_ERR_CONTROL_NOT_FOUND_IN_PANEL     = 181;
  IDX_ERR_PANEL_NOT_LOADED               = 182;
  IDX_ERR_STIM_SIGNAL_NOT_FOUND          = 183;
  IDX_ERR_AM_SUB_MODULE_NOT_AVAIL        = 184;
  IDX_ERR_AM_VARIANT_GROUP_NOT_FOUND     = 185;
  IDX_ERR_PANEL_CONTROL_NOT_FOUND        = 186;
  IDX_ERR_PANEL_CONTROL_NOT_SUPPORT_THIS = 187;
  IDX_ERR_RBS_NOT_RUNNING                = 188;
  IDX_ERR_MSG_NOT_SUPPORT_PDU_CONTAINER  = 189;
  IDX_ERR_DATA_NOT_AVAILABLE             = 190;
  IDX_ERR_J1939_NOT_SUPPORTED            = 191;
  IDX_ERR_J1939_ANOTHER_PDU_IS_SENDING   = 192;
  IDX_ERR_J1939_TX_FAILED_PROTOCOL_ERROR = 193;
  IDX_ERR_J1939_TX_FAILED_NODE_INACTIVE  = 194;
  IDX_ERR_NO_LICENSE                     = 195;
  IDX_ERR_SIGNAL_CHECK_RANGE_VIOLATION   = 196;
  IDX_ERR_LOG_READ_CATEGORY_FAILED       = 197;
  IDX_ERR_CHECK_BOOT_VERSION_FAILED      = 198;
  IDX_ERR_LOG_FILE_NOT_CREATED           = 199;
  IDX_ERR_MODULE_IS_BEING_EDITED_BY_USER = 200;
  IDX_ERR_LOG_DEVICE_IS_BUSY             = 201;
  IDX_ERR_LIN_MASTER_TRANSMIT_N_AS_TIMEOUT   = 202;
  IDX_ERR_LIN_MASTER_TRANSMIT_TRANSMIT_ERROR = 203;
  IDX_ERR_LIN_MASTER_REV_N_CR_TIMEOUT        = 204;
  IDX_ERR_LIN_MASTER_REV_ERROR               = 205;
  IDX_ERR_LIN_MASTER_REV_INTERLLEAVE_TIMEOUT = 206;
  IDX_ERR_LIN_MASTER_REV_NO_RESPONSE         = 207;
  IDX_ERR_LIN_MASTER_REV_SN_ERROR            = 208;
  IDX_ERR_LIN_SLAVE_TRANSMIT_N_CR_TIMEOUT    = 209;
  IDX_ERR_LIN_SLAVE_REV_N_CR_TIMEOUT         = 210;
  IDX_ERR_LIN_SLAVE_TRANSMIT_ERROR           = 211;
  IDX_ERR_LIN_SLAVE_REV_ERROR                = 212;
  IDX_ERR_CLOSE_FILE_FAILED                  = 213;
  IDX_ERR_CONF_LOG_FILE_FAILED               = 214;
  IDX_ERR_CONVERT_LOG_FAILED                 = 215;
  IDX_ERR_HALTED_DUE_TO_USER_BREAK           = 216;
  IDX_ERR_WRITE_FILE_FAILED                  = 217;
  IDX_ERR_UNKNOWN_OBJECT_DETECTED            = 218;
  IDX_ERR_THIS_FUNC_SHOULD_BE_CALLED_IN_MP   = 219;
  IDX_ERR_USER_CANCEL_WAIT                   = 220;
  IDX_ERR_DECOMPRESS_DATA_FAILED             = 221;
  IDX_ERR_AUTOMATION_OBJ_NOT_CREATED         = 222;
  IDX_ERR_ITEM_DUPLICATED                    = 223;
  IDX_ERR_DIVIDE_BY_ZERO                     = 224;
  IDX_ERR_REQUIRE_MINI_PROGRAM_RUNNING       = 225;
  IDX_ERR_FORM_NOT_EXIST                     = 226;
  IDX_ERR_CANNOT_CONFIG_WHEN_DEVICE_RUNNING  = 227;
  IDX_ERR_DATA_NOT_READY                     = 228;
  IDX_ERR_STOP_DEVICE_FAILED                 = 229;
  IDX_ERR_PYTHON_CODE_CRASH                  = 230;
  IDX_ERR_CONDITION_NOT_MET                  = 231;
  IDX_ERR_PYTHON_MODULE_NOT_DEPLOYED         = 232;
  IDX_ERR_UDS_CONNECT_DUT_FAILED             = 233;
  IDX_ETH_GENERIC_ACK                        = 234;
  IDX_ETH_VEHILCE_INFO_RES                   = 235;
  IDX_ETH_ACTIVATE_RES                       = 236;
  IDX_ETH_ALIVE_RES                          = 237;
  IDX_ETH_NODE_STATE_RES                     = 238;  //诊断实体状态响应
  IDX_ETH_DIAG_POWER_MODE_RES                = 239;  //诊断电源模式响应
  IDX_ETH_DIAG_POSITIVE_ACK                    = 240;
  IDX_ETH_DIAG_NEGATIVE_ACK                  = 241;
  IDX_ETH_VEHICLE_REQ_ID                     = 242;
  IDX_ETH_VEHICLE_REQ_EID_ID                 = 243;
  IDX_ETH_VEHICLE_REQ_VIN_ID                 = 244;
  IDX_ETH_ACTIVE_REQ                         = 245;
  IDX_ETH_ALIVE_REQ                          = 246;
  IDX_ETH_NODE_STATE_REQ                     = 247;
  IDX_ETH_DIAG_POWER_MODE_REQ                = 248;
  IDX_ETH_DIAG_REQ_RES                       = 249;
  IDX_ETH_RESERVED0                          = 250;
  IDX_ETH_RESERVED1                          = 251;
  ERR_CODE_COUNT                             = 252;

// Note: Should also update C API!!!

// library initialization and finalization
function set_libtsmaster_location(const AFilePath: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function get_libtsmaster_location(const AFilePath: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function initialize_lib_tsmaster(const AAppName: PAnsiChar): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function initialize_lib_tsmaster_with_project(const AAppName: PAnsiChar; const AProjectFileName: PAnsiChar): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
procedure finalize_lib_tsmaster; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_logger(const ALogger: TLIBTSMasterLogger): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

// application management
function tsapp_log(const AStr: pansichar; const ALevel: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_current_application(const AAppName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_current_application(const AAppName: pPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_del_application(const AAppName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_add_application(const AAppName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_application_list(const AAppNameList: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_can_channel_count(const ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_lin_channel_count(const ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_flexray_channel_count(const ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_can_channel_count(out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_lin_channel_count(out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_flexray_channel_count(out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_mapping(const AMapping: PLIBTSMapping): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_mapping_verbose(const AAppName:PAnsiChar;
                                   const AAppChannelType:TLIBApplicationChannelType;
                                   const AAppChannel:Integer;  //APP_CHANNEL
                                   const AHardwareName:PAnsiChar;
                                   const AHardwareType:TLIBBusToolDeviceType;
                                   const AHardwareSubType:Integer;
                                   const AHardwareIndex:Integer;
                                   const AHardwareChannel:Integer;  //HARDWARE_CHANNEL
                                   const AEnableMapping:Boolean): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_mapping(const AMapping: PLIBTSMapping): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_del_mapping(const AMapping: PLIBTSMapping): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_del_mapping_verbose(const AAppName:PAnsiChar;
                                   const AAppChannelType:TLIBApplicationChannelType;
                                   const AAppChannel:Integer):Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_connect: integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_disconnect(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_turbo_mode(const AEnable: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_turbo_mode(out AEnable: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_error_description(const ACode: Integer; ADesc: PPAnsiChar): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_show_channel_mapping_window: integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_show_hardware_configuration_window: integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_show_tsmaster_window(const AWindowName: PAnsiChar; const AWaitClose: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_timestamp(ATimeUs: PInt64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_execute_python_string(const AString: PAnsiChar; const AArguments: pansichar; const ASync: boolean; const AIsX64: Boolean; AResultLog: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_execute_python_script(const AFilePath: PAnsiChar; const AArguments: pansichar; const ASync: boolean; const AIsX64: Boolean; AResultLog: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_analysis_time_range(const ATimeStartUs: int64; const ATimeEndUs: int64): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_tsmaster_version(const AYear: pinteger; const AMonth: pinteger; const ADay: pinteger; const ABuildNumber: pinteger): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_constant_count(const AIdxType: integer; ACount: pinteger): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_constant_value_by_index(const AIdxType: integer; const AIdxValue: integer; AName: ppansichar; AValue: pdouble; ADesc: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

// hardware settings
function tsapp_enumerate_hw_devices(out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_hw_info_by_index(const AIndex: Integer; const AHWInfo: PLIBHWInfo): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_hw_info_by_index_verbose(const AIndex: Integer;
                                      ADeviceType: PLIBBusToolDeviceType;
                                      AVendorNameBuffer: PAnsiChar; //array[0..31] of AnsiChar;
                                      AVendorNameBufferSize:Integer;
                                      ADeviceNameBuffer: PAnsiChar; //array[0..31] of AnsiChar;
                                      ADeviceNameBufferSize:Integer;
                                      ASerialStringBuffer: PAnsiChar; //array[0..63] of AnsiChar
                                      ASerialStringBufferSize: Integer
                                      ): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_vendor_detect_preferences(const AScanTOSUN, AScanVector, AScanPeak, AScanKvaser, AScanZLG, ADetectIntrepidcs, ADetectCANable: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_vendor_detect_preferences(out AScanTOSUN, AScanVector, AScanPeak, AScanKvaser, AScanZLG, ADetectIntrepidcs, ADetectCANable: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_configure_baudrate_lin(const AIdxChn: Integer;const ABaudrateKbps: Single; const AProtocol:Integer): Integer; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}{Bps:such as 19200 bps}
function tsapp_configure_baudrate_can(const AIdxChn: integer; const ABaudrateKbps: Single; const AListenOnly: boolean; const AInstallTermResistor120Ohm: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_configure_baudrate_canfd(const AIdxChn: integer; const AArbRateKbps, ADataRateKbps: Single; const AControllerType: TLIBCANFDControllerType; const AControllerMode: TLIBCANFDControllerMode; const AInstallTermResistor120Ohm: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_configure_can_regs(
      const AIdxChn: Integer;
      const ABaudrateKbps: Single;
      const ASEG1, ASEG2, APrescaler, ASJW: Integer;
      const AOnlyListen:integer;
      const A120OhmConnected: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_configure_canfd_regs(
      const AIdxChn:Integer;
      const AArbBaudrate:Single;
      const AArbSEG1, AArbSEG2, AArbPrescaler, AArbSJW: Integer;
      const ADataBaudrate:Single;
      const ADataSEG1, ADataSEG2, ADataPrescaler, ADataSJW: Integer;
      const AControllerType: TLIBCANFDControllerType;
      const AControllerMode: TLIBCANFDControllerMode;
      const A120OhmConnected: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// communication async functions
function tsapp_transmit_can_async(const ACAN: PLIBCAN): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_transmit_canfd_async(const ACANFD: PLIBCANFD): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_transmit_lin_async(const ALIN: PLIBLIN): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_transmit_fastlin_async(const ALIN: PLIBLIN): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_transmit_lin_wakeup_async(const AIdxChn: Integer; const AWakeupLength: Integer;
                   const AWakeupIntervalTime: Integer; const AWakeupTimes: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_transmit_lin_gotosleep_async(const AIdxChn: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// communication sync functions
function tsapp_transmit_can_sync(const ACAN: PLIBCAN; const ATimeoutMS: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_transmit_canfd_sync(const ACANfd: PLIBCANfd; const ATimeoutMS: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_transmit_lin_sync(const ALIN: PLIBLIN; const ATimeoutMS: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_upgrade_firmware(const AChn: byte; const AFirmwareFile: string; const AOpaque: tobject; const ACallback: TFirmwareUpdateCallback): integer; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// communication receive functions
procedure tsfifo_enable_receive_fifo; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
procedure tsfifo_disable_receive_fifo; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_add_can_canfd_pass_filter(const AIdxChn: integer; const AIdentifier:Integer; const AIsStd:Boolean):integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_add_lin_pass_filter(const AIdxChn: integer; const AIdentifier:Integer):integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_delete_can_canfd_pass_filter(const AIdxChn: integer; const AIdentifier:Integer):integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_delete_lin_pass_filter(const AIdxChn: integer; const AIdentifier:Integer):integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
procedure tsfifo_enable_receive_error_frames; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
procedure tsfifo_disable_receive_error_frames; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_receive_can_msgs(const ACANBuffers: PLIBCAN; const ACANBufferSize: PInteger; const AIdxChn: integer; const AIncludeTx: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_receive_canfd_msgs(const ACANFDBuffers: PLIBCANFD; const ACANFDBufferSize: PInteger; const AIdxChn: integer; const AIncludeTx: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_receive_lin_msgs(const ALINBuffers: PLIBLIN; const ALINBufferSize: PInteger; const AIdxChn: integer; const AIncludeTx: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_receive_fastlin_msgs(const AFastLINBuffers: PLIBLIN; const AFastLINBufferSize: PInteger; const AIdxChn: integer; const AIncludeTx: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_clear_can_receive_buffers(const AIdxChn: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_clear_canfd_receive_buffers(const AIdxChn: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_clear_lin_receive_buffers(const AIdxChn: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_clear_fastlin_receive_buffers(const AIdxChn: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_can_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_can_tx_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_can_rx_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_canfd_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_canfd_tx_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_canfd_rx_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_lin_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_lin_tx_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_lin_rx_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_fastlin_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_fastlin_tx_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_fastlin_rx_buffer_frame_count(const AIdxChn: integer; out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_receive_flexray_msgs(const ADataBuffers: PLIBFlexray;  const ADataBufferSize: PInteger; const AIdxChn: integer; const AIncludeTx: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_clear_flexray_receive_buffers(const AIdxChn: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_flexray_buffer_frame_count(const AIdxChn: integer; out ACount: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_flexray_tx_buffer_frame_count(const AIdxChn: integer; out ACount: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsfifo_read_flexray_rx_buffer_frame_count(const AIdxChn: integer; out ACount: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// periodic
function tsapp_add_cyclic_msg_can(const ACAN: PLIBCAN; const APeriodMS: Single): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_update_cyclic_msg_can(const ACAN: PLIBCAN): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_add_cyclic_msg_canfd(const ACANFD: PLIBCANFD; const APeriodMS: Single): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_delete_cyclic_msg_can(const ACAN: PLIBCAN): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_delete_cyclic_msg_canfd(const ACANFD: PLIBCANFD): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_delete_cyclic_msgs: Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// bus statistics
function tsapp_enable_bus_statistics(const AEnable: Boolean): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_clear_bus_statistics(): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_bus_statistics(const ABusType: TLIBApplicationChannelType; const AIdxChn: Integer; const AIdxStat: TLIBCANBusStatistics; out AStat: Double): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_fps_can(const AIdxChn: Integer; const AIdentifier: Integer; out AFPS: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_fps_canfd(const AIdxChn: Integer; const AIdentifier: Integer; out AFPS: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_fps_lin(const AIdxChn: Integer; const AIdentifier: Integer; out AFPS: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// bus callback handler
function tsapp_register_event_can(const AObj: pointer; const AEvent: TCANQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_event_can(const AObj: pointer; const AEvent: TCANQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_register_event_canfd(const AObj: pointer; const AEvent: TCANfdQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_event_canfd(const AObj: pointer; const AEvent: TCANfdQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_register_event_lin(const AObj: pointer; const AEvent: TliNQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_event_lin(const AObj: pointer; const AEvent: TliNQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_register_event_flexray(const AObj: pointer; const AEvent: TFlexRayQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_event_flexray(const AObj: pointer; const AEvent: TFlexRayQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_events_flexray(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_events_can(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_events_lin(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_events_canfd(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_events_all(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// bus pre-tx callback handler
function tsapp_register_pretx_event_can(const AObj: pointer; const AEvent: TCANQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_event_can(const AObj: pointer; const AEvent: TCANQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_register_pretx_event_canfd(const AObj: pointer; const AEvent: TCANfdQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_event_canfd(const AObj: pointer; const AEvent: TCANfdQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_register_pretx_event_lin(const AObj: pointer; const AEvent: TliNQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_event_lin(const AObj: pointer; const AEvent: TliNQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_register_pretx_event_flexray(const AObj: pointer; const AEvent: TflexrayQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_event_flexray(const AObj: pointer; const AEvent: TflexrayQueueEvent_Win32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_events_flexray(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_events_can(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_events_lin(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_events_canfd(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_unregister_pretx_events_all(const AObj: pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// logger
function tsapp_start_logging(const AFileName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_stop_logging(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// excel
function tsapp_excel_load(const AFileName: PAnsiChar; const AObj: PPointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_get_sheet_count(const AObj: Pointer; out ACount: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_set_sheet_count(const AObj: Pointer; const ACount: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_get_sheet_name(const AObj: Pointer; const AIdxSheet: Integer; const AName: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_set_sheet_name(const AObj: Pointer; const AIdxSheet: Integer; const AName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_get_cell_count(const AObj: Pointer; const AIdxSheet: Integer; out ARowCount: integer; out AColCount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_get_cell_value(const AObj: Pointer; const AIdxSheet: Integer; const AIdxRow: integer; const AIdxCol: Integer; const AValue: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_set_cell_count(const AObj: Pointer; const AIdxSheet: integer; const ARowCount: integer; const AColCount: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_set_cell_value(const AObj: Pointer; const AIdxSheet: Integer; const AIdxRow: integer; const AIdxCol: Integer; const AValue: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_excel_unload(const AObj: Pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// system variables
function tsapp_system_vars_reload_settings(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_count(AinternalCount: pinteger; AUserCount: pinteger): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_def_by_index(const AIsUser: boolean; const AIndex: integer; const AVarDef: PLIBSystemVarDef): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_find_system_var_def_by_name(const AIsUser: boolean; const ACompleteName: PAnsiChar; const AVarDef: PLIBSystemVarDef): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_double(const ACompleteName: PAnsiChar; AValue: Pdouble): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_int32(const ACompleteName: PAnsiChar; AValue: pinteger): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_uint32(const ACompleteName: PAnsiChar; AValue: pcardinal): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_int64(const ACompleteName: PAnsiChar; AValue: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_uint64(const ACompleteName: PAnsiChar; AValue: puint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_uint8_array(const ACompleteName: PAnsiChar; const ACapacity: integer; AVarCount: pinteger; AValue: pbyte): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_int32_array(const ACompleteName: PAnsiChar; const ACapacity: integer; AVarCount: pinteger; AValue: pinteger): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_int64_array(const ACompleteName: PAnsiChar; const ACapacity: integer; AVarCount: pinteger; AValue: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_double_array(const ACompleteName: PAnsiChar; const ACapacity: integer; AVarCount: pinteger; AValue: Pdouble): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_string(const ACompleteName: PAnsiChar; const ACapacity: integer; AValue: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_double(const ACompleteName: PAnsiChar; const AValue: double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_int32(const ACompleteName: PAnsiChar; const AValue: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_uint32(const ACompleteName: PAnsiChar; const AValue: cardinal): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_int64(const ACompleteName: PAnsiChar; const AValue: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_uint64(const ACompleteName: PAnsiChar; const AValue: uint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_uint8_array(const ACompleteName: PAnsiChar; const ACapacity: integer; AValue: pbyte): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_int32_array(const ACompleteName: PAnsiChar; const ACapacity: integer; AValue: pinteger): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_int64_array(const ACompleteName: PAnsiChar; const ACapacity: integer; AValue: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_double_array(const ACompleteName: PAnsiChar; const ACapacity: integer; AValue: Pdouble): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_string(const ACompleteName: PAnsiChar; AValue: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_log_system_var(const ACompleteName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_system_var_generic(const ACompleteName: PAnsiChar; const ACapacity: integer; AValue: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_set_system_var_generic(const ACompleteName: PAnsiChar; const AValue: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_hardware_id_string(AString: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_get_hardware_id_array(AArray8B: pbyte): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_create_system_var(const ACompleteName: PAnsiChar; const AType: TLIBSystemVarType; const ADefaultValue: PAnsiChar; const AComment: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_delete_system_var(const ACompleteName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

// database parser
function tsdb_reload_settings(out ALoadedDBCount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_save_settings(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_load_can_db(const ADBC: PAnsiChar; const ASupportedChannelsBased0: PAnsiChar; out AId: Cardinal): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_unload_can_db(const AId: Cardinal): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_unload_can_dbs(): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_count(out ACount: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_id(const AIndex: integer; out AId: Cardinal): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_info(const ADatabaseId: Cardinal; const AType: integer; const AIndex: integer; const ASubIndex: Integer; AValue: PPAnsiChar): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_load_flexray_db(const AFRFile: pansichar; const ASupportedChannels: pansichar; out AId: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_unload_flexray_db(const AId: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_unload_flexray_dbs: integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_count(out ACount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_properties_by_address_verbose(const AAddr: pansichar; out ADBIndex: Integer;
                                                out ASignalCount: Integer;
                                                out AFrameCount: Integer;
                                                out AECUCount: Integer;
                                                out ASupportedChannelMask: Int64;
                                                out AFlags: Int64;
                                                AName: ppansichar; AComment: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_properties_by_index_verbose(ADBIndex: Integer; out ASignalCount: Integer;
                                                out AFrameCount: Integer; out AECUCount: Integer;
                                                out ASupportedChannelMask: Int64;
                                                out AFlags: Int64;
                                                AName: ppansichar; AComment: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_ecu_properties_by_address_verbose(const AAddr: pansichar; out ADBIndex: Integer;
                                                out AECUIndex: Integer;
                                                out ATxFrameCount: Integer;
                                                out ARxFrameCount: Integer;
                                                AName: ppansichar; AComment: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_ecu_properties_by_index_verbose(ADBIndex: Integer; AECUIndex: Integer;
                                                out ATxFrameCount: Integer;
                                                out ARxFrameCount: Integer;
                                                AName: ppansichar; AComment: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_frame_properties_by_address_verbose(const AAddr: pansichar;
                                                    out ADBIndex: Integer;
                                                    out AECUIndex: Integer;
                                                    out AFrameIndex: Integer;
                                                    out AIsTx: WordBool;
                                                    out AFRChannelMask: Integer;
                                                    out AFRBaseCycle: Integer;
                                                    out AFRCycleRepetition: Integer;
                                                    out AFRIsStartupFrame: WordBool;
                                                    out AFRSlotId: Integer;
                                                    out AFRCycleMask: Int64;
                                                    out ASignalCount: Integer;
                                                    out AFRDLC: integer;
                                                    AName: ppansichar;
                                                    AComment: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_frame_properties_by_index_verbose(ADBIndex: Integer; AECUIndex: Integer;
                                                AFrameIndex: Integer; AIsTx: WordBool;
                                                out AFRChannelMask: Integer;
                                                out AFRBaseCycle: Integer;
                                                out AFRCycleRepetition: Integer;
                                                out AFRIsStartupFrame: WordBool;
                                                out AFRSlotId: Integer;
                                                out AFRCycleMask: Int64;
                                                out ASignalCount: Integer;
                                                out AFRDLC: integer;
                                                AName: ppansichar; AComment: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_signal_properties_by_address_verbose(const AAddr: pansichar;
                                                    out ADBIndex: Integer;
                                                    out AECUIndex: Integer;
                                                    out AFrameIndex: Integer;
                                                    out ASignalIndex: Integer;
                                                    out AIsTx: WordBool;
                                                    out ASignalType: TSignalType;
                                                    out ACompuMethod: TFlexRayCompuMethod;
                                                    out AIsIntel: WordBool;
                                                    out AActualStartBit: Integer;
                                                    out AActualUpdateBit: Integer;
                                                    out ALength: Integer; out AFactor: Double;
                                                    out AOffset: Double; out AInitValue: Double;
                                                    AName: ppansichar;
                                                    AComment: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_signal_properties_by_index_verbose(ADBIndex: Integer; AECUIndex: Integer;
                                                    AFrameIndex: Integer; ASignalIndex: Integer;
                                                    AIsTx: WordBool;
                                                    out ASignalType: TSignalType;
                                                    out ACompuMethod: TFlexRayCompuMethod;
                                                    out AIsIntel: WordBool;
                                                    out AActualStartBit: Integer;
                                                    out AActualUpdateBit: Integer; out ALength: Integer;
                                                    out AFactor: Double; out AOffset: Double;
                                                    out AInitValue: Double; AName: ppansichar;
                                                    AComment: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_id(const AIndex: Integer; out AId: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_properties_by_index(const AValue: PMPDBProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_properties_by_index(const AValue: PMPDBProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_properties_by_index(const AValue: PMPDBProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_ecu_properties_by_index(const AValue: PMPDBECUProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_ecu_properties_by_index(const AValue: PMPDBECUProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_ecu_properties_by_index(const AValue: PMPDBECUProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_frame_properties_by_index(const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_frame_properties_by_index(const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_frame_properties_by_index(const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_signal_properties_by_index(const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_signal_properties_by_index(const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_signal_properties_by_index(const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_properties_by_address(const AAddr: pansichar; const AValue: PMPDBProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_properties_by_address(const AAddr: pansichar; const AValue: PMPDBProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_properties_by_address(const AAddr: pansichar; const AValue: PMPDBProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_ecu_properties_by_address(const AAddr: pansichar; const AValue: PMPDBECUProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_ecu_properties_by_address(const AAddr: pansichar; const AValue: PMPDBECUProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_ecu_properties_by_address(const AAddr: pansichar; const AValue: PMPDBECUProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_frame_properties_by_address(const AAddr: pansichar; const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_frame_properties_by_address(const AAddr: pansichar; const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_frame_properties_by_address(const AAddr: pansichar; const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_signal_properties_by_address(const AAddr: pansichar; const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_signal_properties_by_address(const AAddr: pansichar; const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_signal_properties_by_address(const AAddr: pansichar; const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_load_lin_db(const ALDF: PAnsiChar; const ASupportedChannelsBased0: PAnsiChar; out AId: Cardinal): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_unload_lin_db(const AId: Cardinal): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_unload_lin_dbs(): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_count(out ACount: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_id(const AIndex: integer; out AId: Cardinal): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_frame_properties_by_db_index(const AIdxDB: integer; const AIndex: integer; const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_frame_properties_by_db_index(const AIdxDB: integer; const AIndex: integer; const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_frame_properties_by_db_index(const AIdxDB: integer; const AIndex: integer; const AValue: PMPDBFrameProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_can_db_signal_properties_by_frame_index(const AIdxDB: integer; const AIdxFrame: integer; const ASgnIndexInFrame: integer; const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_lin_db_signal_properties_by_frame_index(const AIdxDB: integer; const AIdxFrame: integer; const ASgnIndexInFrame: integer; const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_flexray_db_signal_properties_by_frame_index(const AIdxDB: integer; const AIdxFrame: integer; const ASgnIndexInFrame: integer; const AValue: PMPDBSignalProperties): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// database signal
function tsdb_set_signal_value_can(const ACAN: PLIBCAN; const AMsgName: PAnsiChar; const ASgnName: PAnsiChar; const AValue: Double): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_signal_value_can(const ACAN: PLIBCAN; const AMsgName: PAnsiChar; const ASgnName: PAnsiChar; out AValue: Double): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_set_signal_value_canfd(const ACANfd: PLIBCANfd; const AMsgName: PAnsiChar; const ASgnName: PAnsiChar; const AValue: Double): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdb_get_signal_value_canfd(const ACANfd: PLIBCANfd; const AMsgName: PAnsiChar; const ASgnName: PAnsiChar; out AValue: Double): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// online replay
function tslog_reload_settings(out ALoadedEngineCount: Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_add_online_replay_config(const AFileName: PAnsiChar; out AIndex: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_set_online_replay_config(const AIndex: Integer; const AName: PAnsiChar; const AFileName: PAnsiChar; const AAutoStart: Boolean; const AIsRepetitiveMode: boolean; const AStartTimingMode: TLIBOnlineReplayTimingMode; const AStartDelayTimeMs: integer; const ASendTx: Boolean; const ASendRx: boolean; const AMappings: PAnsiChar): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_get_online_replay_count(out ACount: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_get_online_replay_config(const AIndex: Integer; AName: PPAnsiChar; AFileName: PPAnsiChar; out AAutoStart: Boolean; out AIsRepetitiveMode: boolean; out AStartTimingMode: TLIBOnlineReplayTimingMode; out AStartDelayTimeMs: integer; out ASendTx: Boolean; out ASendRx: boolean; AMappings: PPAnsiChar): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_del_online_replay_config(const AIndex: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_del_online_replay_configs(): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_start_online_replay(const AIndex: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_start_online_replays(): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_pause_online_replay(const AIndex: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_pause_online_replays(): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_stop_online_replay(const AIndex: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_stop_online_replays(): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_get_online_replay_status(const AIndex: Integer; out AStatus: TLIBOnlineReplayStatus; out AProgressPercent100:Single): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// blf
function tslog_blf_write_start(const AFileName: PAnsiChar; AHandle: pinteger): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_write_set_max_count(const AHandle: integer; const ACount: UInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_write_can(const AHandle: integer; const ACAN: PlibCAN): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_write_can_fd(const AHandle: integer; const ACANFD: PlibCANFD): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_write_lin(const AHandle: integer; const ALIN: PlibLIN): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_write_realtime_comment(const AHandle: Integer; const ATimeUs: int64; const AComment: PAnsiChar): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_write_end(const AHandle: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_read_start(const AFileName: PAnsiChar; AHandle: pinteger; AObjCount: pinteger): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsLog_blf_read_start_verbose(const AFileName: PAnsiChar; AHandle: pinteger; AObjCount: pinteger;
                                         AYear:PWord;AMonth: PWord; ADayOfWeek: PWord;
                                         ADay: PWord; AHour: PWord; AMinute: PWord;
                                         ASecond: PWord;AMilliseconds: PWord): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_read_status(const AHandle: integer; AObjReadCount: pinteger): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_read_object(const AHandle: integer; AProgressedCnt: pinteger; AType: PSupportedObjType; ACAN: PlibCAN; ALIN: PlibLIN; ACANFD: PlibCANFD): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_read_object_w_comment(const AHandle: Integer; AProgressedCnt: pinteger; AType: PSupportedObjType; ACAN: PlibCAN; ALIN: PlibLIN; ACANFD: PlibCANFD; AComment: Prealtime_comment_t): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_read_end(const AHandle: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_seek_object_time(const AHandle: integer; const AProg100: Double; var ATime: int64; var AProgressedCnt: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_to_asc(const AObj: pointer; const ABLFFileName: PAnsiChar; const AASCFileName: pansichar; const AProgressCallback: TReadProgressCallback): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_asc_to_blf(const AObj: pointer; const AASCFileName: PAnsiChar; const ABLFFileName: pansichar; const AProgressCallback: TReadProgressCallback): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

// LIN RBS
function tscom_lin_rbs_reload_settings(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_start(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_stop(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_is_running(out AIsRunning: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_configure(const AAutoStart: boolean; const AAutoSendOnModification: boolean; const AActivateNodeSimulation: boolean; const AInitValueOptions: TLIBRBSInitValueOptions): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_activate_all_networks(const AEnable: boolean; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_activate_network_by_name(const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_activate_node_by_name(const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_activate_message_by_name(const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_set_message_delay_time_by_name(const AIdxChn: integer; const AIntervalMs: Integer; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_get_signal_value_by_element(const AIdxChn: Integer; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; out AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_get_signal_value_by_address(const ASymbolAddress: PAnsiChar; out AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_set_signal_value_by_element(const AIdxChn: Integer; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; const AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_lin_rbs_set_signal_value_by_address(const ASymbolAddress: PAnsiChar; const AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

// CAN RBS
function tscom_can_rbs_reload_settings(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_start(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_stop(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_is_running(out AIsRunning: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_configure(const AAutoStart: boolean; const AAutoSendOnModification: boolean; const AActivateNodeSimulation: boolean; const AInitValueOptions: TLIBRBSInitValueOptions): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_activate_all_networks(const AEnable: boolean; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_activate_network_by_name(const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_activate_node_by_name(const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_activate_message_by_name(const AIdxChn: integer; const AEnable: boolean; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_set_message_cycle_by_name(const AIdxChn: integer; const AIntervalMs: Integer; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_get_signal_value_by_element(const AIdxChn: Integer; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; out AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_get_signal_value_by_address(const ASymbolAddress: PAnsiChar; out AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_set_signal_value_by_element(const AIdxChn: Integer; const ANetworkName: PAnsiChar; const ANodeName: pansichar; const AMsgName: PAnsiChar; const ASignalName: PAnsiChar; const AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_can_rbs_set_signal_value_by_address(const ASymbolAddress: PAnsiChar; const AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

//Flexray RBS
function tscom_flexray_rbs_start(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_stop(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_is_running(out AIsRunning: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_configure(const AAutoStart: boolean; const AAutoSendOnModification: boolean; const AActivateECUSimulation: boolean; const AInitValueOptions: TLIBRBSInitValueOptions): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_activate_all_clusters(const AEnable: boolean; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_activate_cluster_by_name(const AIdxChn: integer; const AEnable: boolean; const AClusterName: PAnsiChar; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_activate_ecu_by_name(const AIdxChn: integer; const AEnable: boolean; const AClusterName: PAnsiChar; const AECUName: pansichar; const AIncludingChildren: Boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_activate_frame_by_name(const AIdxChn: integer; const AEnable: boolean; const AClusterName: PAnsiChar; const AECUName: pansichar; const AFrameName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_get_signal_value_by_element(const AIdxChn: integer; const AClusterName: PAnsiChar; const AECUName: pansichar; const AFrameName: PAnsiChar; const ASignalName: PAnsiChar; out AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_get_signal_value_by_address(const ASymbolAddress: PAnsiChar; out AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_set_signal_value_by_element(const AIdxChn: integer; const AClusterName: PAnsiChar; const AECUName: pansichar; const AFrameName: PAnsiChar; const ASignalName: PAnsiChar; const AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_set_signal_value_by_address(const ASymbolAddress: PAnsiChar; const AValue: Double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_enable(const AEnable: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_batch_set_start: integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_batch_set_end: integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_batch_set_signal(const AAddr: pansichar; const AValue: double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_set_frame_direction(const AIdxChn: integer; const AIsTx: boolean; const AClusterName: PAnsiChar; const AECUName: pansichar; const AFrameName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_set_normal_signal(const ASymbolAddress: pansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_set_rc_signal(const ASymbolAddress: pansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_set_rc_signal_with_limit(const ASymbolAddress: pansichar; const ALowerLimit: integer; const AUpperLimit: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_rbs_set_crc_signal(const ASymbolAddress: pansichar; const AAlgorithmName: pansichar; const AIdxByteStart: integer; const AByteCount: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_set_signal_value_in_raw_frame(const AFlexRaySignal: pmpflexraysignal; const AData: pbyte; const AValue: double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_get_signal_value_in_raw_frame(const AFlexRaySignal: pmpflexraysignal; const AData: pbyte): double; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tscom_flexray_get_signal_definition(const ASignalAddress: pansichar; ASignalDef: PmpFlexRaySignal): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

//Flexray API
function tsflexray_set_controller_frametrigger(const AIdxChn: Integer;
                          const AControllerConfig: PLibFlexray_controller_config;
                          const AFrameLengthArray: PInteger; const AFrameNum: Integer;
                          const AFrameTrigger: PLibTrigger_def; const AFrameTriggerNum:Integer; const ATimeoutMs: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsflexray_set_controller(const AIdxChn: Integer;
                          const AControllerConfig: PLibFlexray_controller_config;
                          const ATimeoutMs: integer): integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsflexray_set_frametrigger(const AIdxChn: Integer;
                          const AFrameLengthArray: PInteger; const AFrameNum: Integer;
                          const AFrameTrigger: PLibTrigger_def; const AFrameTriggerNum:Integer; const ATimeoutMs: integer): integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsflexray_cmdreq(const AChnIdx: Integer; const AAction: integer;
                          const AWriteBuffer: PByte; const AWriteBufferSize: integer;
                          const AReadBuffer: PByte; const AReadBufferSize: PInteger; const ATimeoutMs: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsflexray_transmit_sync(const AIdxChn: Integer; const AData: PLibFlexRay; const ATimeoutMs: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsflexray_transmit_async(const AIdxChn: Integer; const AData: PLibFlexRay): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsflexray_start_net(const AIdxChn: Integer; const ATimeoutMs: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsflexray_stop_net(const AIdxChn: Integer; const ATimeoutMs: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsflexray_wakeup_pattern(const AIdxChn: Integer; const ATimeoutMs: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// LIN apis
function tslin_clear_schedule_tables(const AChnIdx: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//function tslin_download_frames(const AChnIdx: Integer; const ACnt: Integer; const ALINFrames: PConfig_LINFrameStruct): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//function tslin_download_schedule_tables(const AChnIdx: Integer; const ACnt: Integer; const ALINSchedule: Plin_schedule_struct): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//function tslin_download_runtime_schedule_table(const AChnIdx: Integer; const ALINSchedule: Plin_schedule_struct): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslin_enable_runtime_schedule_table(const AChnIdx: Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslin_set_schedule_table(const AChnIdx: Integer; const ASchIndex: Integer): Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslin_stop_lin_channel(const AChnIdx: Integer): Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslin_start_lin_channel(const AChnIdx: Integer): Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslin_set_node_funtiontype(const AChnIdx: Integer; const AFunctionType: TLINNodeType): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//LIN_Diag_Tp_Layer
function tstp_lin_master_request(const AChnIdx: Integer; const ANAD: Byte; const AData: PByte; const ADataNum: Integer; const ATimeoutMs: Integer): Integer;stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_lin_master_request_intervalms(const AChnIdx: Integer; const AData: UInt16): Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_lin_reset(const AChnIdx: Integer): Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_lin_slave_response_intervalms(const AChnIdx: Integer; const AData: UInt16): Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_lin_tp_para_default(const AChnIdx: Integer;const AReqIntervalMs: UInt16; const AResIntervalMs: UInt16;
    const AResRetryTime: UInt16): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_lin_tp_para_special(const AChnIdx: Integer;const AReqIntervalMs: UInt16; const AResIntervalMs: UInt16;
    const AResRetryTime: UInt16): Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//LIN_Diag_Service_Layer
//ServiceID:0x22
function tsdiag_lin_read_data_by_identifier(const AChnIdx: Integer;const ANAD:Byte;const AId:uint16;
                             const AResNAD:PByte;const AResData:PByte;const AResDataNum:PNativeInt;
                             const ATimeoutMS: Integer): Integer;stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

//ServiceID:0x2E
function tsdiag_lin_write_data_by_identifier(const AChnIdx: Integer;
                             const AReqNAD: Byte;
                             const AID: UInt16;
                             const AReqData: PByte;
                             const AReqDataNum: NativeInt;
                             const AResNAD: PByte;
                             const AResData: PByte;
                             const AResDataNum: PNativeInt;
                             const ATimeoutMS: Integer):NativeInt;stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//Session Control: 0x10
function tsdiag_lin_session_control(const AChnIdx: Integer;
                                          const ANAD:Byte;
                                          const ANewSession:Byte;
                                          const ATimeoutMS: Integer): NativeInt;stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//Service ID 0x19
function tsdiag_lin_fault_memory_read(const AChnIdx: Integer;
                                            const ANAD:Byte;
                                            const ATimeoutMS: Integer): NativeInt;stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//ServiceID 0x14
function tsdiag_lin_fault_memory_clear(const AChnIdx: Integer;
                                             const ANAD: Byte;
                                             const ATimeoutMS: Integer): NativeInt;stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//CAN Diagnostic Layer
function tsdiag_can_create(pDiagModuleIndex: PInteger;
                      AChnIndex: Integer;
                      ASupportFDCAN:Byte;
                      AMaxDLC:Byte;
                      ARequestID: UInt32;
                      ARequestIDIsStd: Boolean;
                      AResponseID: UInt32;
                      AResponseIDIsStd: Boolean;
                      AFunctionID: UInt32;
                      AFunctionIDIsStd: Boolean): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_delete(ADiagModuleIndex: Integer): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
procedure tsdiag_can_delete_all; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//function tsdiag_get_tp_handle(ADiagModuleIndex: Integer;AHandle:PInteger):Integer;  stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
{Parameter setting}
function tsdiag_set_channel(ADiagModuleIndex: Integer; AChnIndex:Integer): Integer;  stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_fdmode(ADiagModuleIndex: Integer; AFDMode:boolean; AMaxLength:Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_request_id(ADiagModuleIndex: Integer; ARequestID:Integer; AIsStandard:Boolean): Integer;  stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_response_id(ADiagModuleIndex: Integer; ARequestID:Integer; AIsStandard:Boolean): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_function_id(ADiagModuleIndex: Integer; ARequestID:Integer; AIsStandard:Boolean): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_stmin(ADiagModuleIndex: Integer; ASTMin:Integer): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_blocksize(ADiagModuleIndex: Integer; ABlockSize:Integer): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_maxlength(ADiagModuleIndex: Integer; AMaxLength:Integer): Integer;  stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_fcdelay(ADiagModuleIndex: Integer; AFCDelay:Integer): Integer;  stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_filled_byte(ADiagModuleIndex: Integer; AFilledByte:Byte):Integer;  stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_p2_timeout(ADiagModuleIndex: Integer; ATimeMs:Integer):Integer;  stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_p2_extended(ADiagModuleIndex: Integer; ATimeMs:Integer):Integer;  stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_s3_servertime(ADiagModuleIndex: Integer; ATimeMs:Integer):Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_set_s3_clienttime(ADiagModuleIndex: Integer; ATimeMs:Integer):Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
{TP Raw Function}
function tstp_can_send_functional(ADiagModuleIndex:Integer;AReqDataArray:PByte;AReqDataSize:Integer):integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_can_send_request(ADiagModuleIndex:Integer;AReqDataArray:PByte;AReqDataSize:Integer):integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_can_request_and_get_response(ADiagModuleIndex:Integer;AReqDataArray:PByte;AReqDataSize:Integer;AResponseDataArray:PByte; AResponseDataSize:PInteger):integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_can_register_tx_completed_recall(ADiagModuleIndex: Integer; ATxcompleted: N_USData_TranslateCompleted_Recall): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_can_register_rx_completed_recall(ADiagModuleIndex: Integer; ARxcompleted: N_USData_TranslateCompleted_Recall): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
{Internal for delphi dev}
function tstp_can_register_tx_completed_recall_internal(ADiagModuleIndex:Integer;
           ATxcompleted:N_USData_TranslateCompleted_Recall_Obj):Integer;stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tstp_can_register_rx_completed_recall_internal(ADiagModuleIndex:Integer;
           ARxcompleted:N_USData_TranslateCompleted_Recall_Obj):Integer;stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

{Diagnostic}
function tsdiag_can_session_control(ADiagModuleIndex:Integer;ASubSession: Byte):Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_routine_control(ADiagModuleIndex:Integer;ARoutineControlType: Byte; ARoutintID:UInt16):Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_communication_control(ADiagModuleIndex:Integer;AControlType: Byte):integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_security_access_request_seed(ADiagModuleIndex:Integer;ALevel: Integer;
      ARecSeed: PByte;ARecSeedSize:PInteger): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_security_access_send_key(ADiagModuleIndex:Integer;ALevel: Integer; AKeyValue: Pbyte; AKeySize:Integer): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_request_download(ADiagModuleIndex:Integer;AMemAddr: UInt32; AMemSize: UInt32): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_request_upload(ADiagModuleIndex:Integer;AMemAddr: UInt32; AMemSize: UInt32): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_transfer_data(ADiagModuleIndex:Integer;ASourceDatas: PByte; ADataSize: Integer;
      AReqCase: Integer): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_request_transfer_exit(ADiagModuleIndex:Integer):Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_write_data_by_identifier(ADiagModuleIndex:Integer;ADataIdentifier:UInt16;AWriteData:PByte;
     AWriteDataSize:Integer):integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsdiag_can_read_data_by_identifier(ADiagModuleIndex:Integer;ADataIdentifier:UInt16;AReturnArray:PByte;
     AReturnArraySize:PInteger):integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}


//Logger
{Data Log}
function tslog_logger_get_file_catelog(const AChnIdx:Integer; const ACategory:PPEMMC_RECORD_NODE; ATimeoutMS:Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_delete_file(const AChnIdx:Integer; const AFileIndex:Integer; ATimeoutMS:Integer): Integer; stdcall;  {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_start_export_blf_file(const AChnIdx:Integer; const AFileIndex:Integer; const ABlfFileName:PAnsiChar;
                                            const AStartTimeUs:UInt64; const AMaxSize:Integer; const AProgress:PDouble;
                                            const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMinisecond: UInt16;
                                            const ATimeoutMS:Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_abort_export_blf_file(const AChnIdx:Integer; ATimeoutMS:Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_start_online_replay(const AChnIdx:Integer; const AFileIndex:Integer; const AStartTimeUs:UInt64; const AMaxSize:integer; ATimeoutMS:Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_start_offline_replay(const AChnIdx:Integer; const AFileIndex:Integer; const AStartTimeUs:UInt64; const AMaxSize:integer; ATimeoutMS:Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_stop_replay(const AChnIdx:Integer; ATimeoutMS:Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_set_logger_mode(const AChnIdx:Integer; AMode:Byte; ATimeoutMS:Integer): Integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_update_online_trigger(const AChnIdx: Integer; const AAddOrDelete:boolean; const AData:PLibCANFD; const AIntervalMs:UInt32; const ATimeOutMs: integer):integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_clear_online_trigger(const AChnIdx: Integer; const ATimeOutMs: integer):integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_logger_get_online_triggers(const AChnIdx: Integer;
                                           var ACANFDMsgList: TArray<TLibCANFD>;
                                           var APeriodList: TArray<integer>;
                                           const ATimeoutMS:Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//GPS Module
function tsapp_logger_enable_gps_module(const AChnIdx: Integer; const AEnable: integer; const ATimeoutMS:Integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsapp_reset_gps_module(const AChnIdx:Integer; const AInitBaudrate:Integer; const ATargetBaudrate:Integer; const ATimeoutMS:Integer): Integer; stdcall;{$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
//function Security
function tsapp_unlock_camera_channel(const AChnIdx: integer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

// mini program library
function tsmp_reload_settings(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_load(const AMPFileName: PAnsiChar; const ARunAfterLoad: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_unload(const AMPFileName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_unload_all(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_run(const AMPFileName: PAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_is_running(const AMPFileName: PAnsiChar; out AIsRunning: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_stop(const AMPFileName: pansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_run_all(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_stop_all(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_call_function(const AGroupName: pansichar; const AFuncName: pansichar; const AInParameters: pansichar; const AOutParameters: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_get_function_address(const AGroupName: PAnsiChar; const AFuncName: PAnsiChar; out AAddress: Pointer): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_get_function_prototype(const AGroupName: pansichar; const AFuncName: pansichar; const APrototype: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_get_mp_function_list(const AGroupName: pansichar; const AList: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tsmp_get_mp_list(const AList: ppansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}

function db_get_flexray_cluster_parameters(const AIdxChn: integer; const AClusterName: PAnsiChar; AValue: PLibFlexRayClusterParameters): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function db_get_flexray_controller_parameters(const AIdxChn: integer; const AClusterName: PAnsiChar; const AECUName: PAnsiChar; AValue: PLibFlexRayControllerParameters): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_event_support(const ACompleteName: PAnsiChar; const ASupport: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function get_system_var_event_support(const ACompleteName: PAnsiChar; ASupport: PBoolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function get_date_time(AYear: pInt32; AMonth: pInt32; ADay: pInt32; AHour: pInt32; AMinute: pInt32; ASecond: pInt32; AMilliseconds: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_disable_online_replay_filter(const AIndex: int32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_set_online_replay_filter(const AIndex: Int32; const AIsPassFilter: boolean; const ACount: int32; const AIdxChannels: pInt32; const AIdentifiers: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_can_signal_raw_value(const ACANSignal: PMPCANSignal; const AData: pbyte; const AValue: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function get_can_signal_raw_value(const ACANSignal: PMPCANSignal; const AData: pbyte): uint64; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_lin_signal_raw_value(const ALINSignal: PMPLINSignal; const AData: pbyte; const AValue: double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function get_lin_signal_raw_value(const ALINSignal: PMPLINSignal; const AData: pbyte): uint64; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_flexray_signal_raw_value(const AFlexRaySignal: PMPFlexRaySignal; const AData: pbyte; const AValue: double): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function get_flexray_signal_raw_value(const AFlexRaySignal: PMPFlexRaySignal; const AData: pbyte): uint64; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_delete_all_modules(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_create_module(const AProgramName: PAnsichar; const ADisplayName: PAnsichar; AModuleId: pint64; AEntryPointId: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_delete_module(const AModuleId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_deploy_module(const AModuleId: int64; const AGraphicProgramWindowTitle: PAnsichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_add_action_down(const AModuleId: int64; const AUpperActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; AActionId: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_add_action_right(const AModuleId: int64; const ALeftActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; AActionId: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_add_goto_down(const AModuleId: int64; const AUpperActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar; AActionId: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_add_goto_right(const AModuleId: int64; const ALeftActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar; AActionId: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_add_from_down(const AModuleId: int64; const AUpperActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar; AActionId: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_add_group_down(const AModuleId: int64; const AUpperActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; AGroupId: pint64; AEntryPointId: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_add_group_right(const AModuleId: int64; const ALeftActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; AGroupId: pint64; AEntryPointId: pint64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_delete_action(const AModuleId: int64; const AActionId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_set_action_nop(const AModuleId: int64; const AActionId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_set_action_signal_read_write(const AModuleId: int64; const AActionId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_set_action_api_call(const AModuleId: int64; const AActionId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_set_action_expression(const AModuleId: int64; const AActionId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_action_basic(const AModuleId: int64; const AActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const ATimeoutMs: int32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_goto(const AModuleId: int64; const AActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_from(const AModuleId: int64; const AActionId: int64; const ADisplayName: PAnsichar; const AComment: PAnsichar; const AJumpLabel: PAnsichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_nop(const AModuleId: int64; const AActionId: int64; const ANextDirectionIsDown: boolean; const AResultOK: boolean; const AJumpBackIfEnded: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_group(const AModuleId: int64; const AActionId: int64; const ARepeatCountType: TLIBAutomationSignalType; const ARepeatCountRepr: PAnsichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_signal_read_write_list_clear(const AModuleId: int64; const AActionId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_signal_write_list_append(const AModuleId: int64; const AActionId: int64; const ADestSignalType: TLIBAutomationSignalType; const ASrcSignalType: TLIBAutomationSignalType; const ADestSignalExpr: PAnsichar; const ASrcSignalExpr: PAnsichar; AItemIndex: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_signal_read_list_append(const AModuleId: int64; const AActionId: int64; const AIsConditionAND: boolean; const ADestSignalType: TLIBAutomationSignalType; const AMinSignalType: TLIBAutomationSignalType; const AMaxSignalType: TLIBAutomationSignalType; const ADestSignalExpr: PAnsichar; const AMinSignalExpr: PAnsichar; const AMaxSignalExpr: PAnsichar; AItemIndex: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_api_call_arguments(const AModuleId: int64; const AActionId: int64; const AAPIType: TLIBMPFuncSource; const AAPIName: PAnsichar; const AAPIArgTypes: PLIBAutomationSignalType; const AAPIArgNames: PPAnsiChar; const AAPIArgExprs: PPAnsiChar; const AArraySize: int32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_api_call_result(const AModuleId: int64; const AActionId: int64; const AIgnoreResult: boolean; const ASignalType: TLIBAutomationSignalType; const ASignalExpr: PAnsichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_expression(const AModuleId: int64; const AActionId: int64; const AxCount: int32; const AExpression: PAnsichar; const AArgumentTypes: PLIBAutomationSignalType; const AArgumentExprs: PPAnsiChar; const AResultType: TLIBAutomationSignalType; const AResultExpr: PAnsichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_add_local_var(const AModuleId: int64; const AType: TLIBSimVarType; const AName: PAnsichar; const AInitValue: PAnsichar; const AComment: PAnsichar; AItemIndex: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_delete_local_var(const AModuleId: int64; const AItemIndex: int32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_delete_all_local_vars(const AModuleId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_delete_group_items(const AModuleId: int64; const AGroupId: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_signal_read_write_list_delete(const AModuleId: int64; const AActionId: int64; const AItemIndex: int32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function flexray_rbs_update_frame_by_header(const AFlexRay: PLIBFlexRay): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function gpg_configure_module(const AModuleId: int64; const AProgramName: PAnsichar; const ADisplayName: PAnsichar; const ARepeatCount: int32; const ASelected: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function add_path_to_environment(const APath: pansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function delete_path_from_environment(const APath: pansichar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_double_w_time(const ACompleteName: pansichar; const AValue: double; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_int32_w_time(const ACompleteName: pansichar; const AValue: int32; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_uint32_w_time(const ACompleteName: pansichar; const AValue: uint32; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_int64_w_time(const ACompleteName: pansichar; const AValue: int64; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_uint64_w_time(const ACompleteName: pansichar; const AValue: uint64; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_uint8_array_w_time(const ACompleteName: pansichar; const ACount: int32; const AValue: pbyte; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_int32_array_w_time(const ACompleteName: pansichar; const ACount: int32; const AValue: pInt32; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_double_array_w_time(const ACompleteName: pansichar; const ACount: int32; const AValue: pdouble; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_string_w_time(const ACompleteName: pansichar; const AValue: pansichar; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_generic_w_time(const ACompleteName: pansichar; const AValue: pansichar; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_double_async_w_time(const ACompleteName: pansichar; const AValue: double; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_int32_async_w_time(const ACompleteName: pansichar; const AValue: int32; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_uint32_async_w_time(const ACompleteName: pansichar; const AValue: uint32; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_int64_async_w_time(const ACompleteName: pansichar; const AValue: int64; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_uint64_async_w_time(const ACompleteName: pansichar; const AValue: uint64; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_uint8_array_async_w_time(const ACompleteName: pansichar; const ACount: int32; const AValue: pbyte; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_int32_array_async_w_time(const ACompleteName: pansichar; const ACount: int32; const AValue: pInt32; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_int64_array_async_w_time(const ACompleteName: pansichar; const ACount: int32; const AValue: pint64; ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_double_array_async_w_time(const ACompleteName: pansichar; const ACount: int32; const AValue: pdouble; const ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_string_async_w_time(const ACompleteName: pansichar; const AValue: pansichar; const ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_system_var_generic_async_w_time(const ACompleteName: pansichar; const AValue: pansichar; const ATimeUs: int64): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function db_get_signal_startbit_by_pdu_offset(const ASignalStartBitInPDU: int32; const ASignalBitLength: int32; const AIsSignalIntel: boolean; const AIsPDUIntel: boolean; const APDUStartBit: int32; const APDUBitLength: int32; AActualStartBit: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function ui_show_save_file_dialog(const ATitle: pansichar; const AFileTypeDesc: pansichar; const AFilter: pansichar; const ASuggestFileName: pansichar; ADestinationFileName: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function ui_show_open_file_dialog(const ATitle: pansichar; const AFileTypeDesc: pansichar; const AFilter: pansichar; const ASuggestFileName: pansichar; ADestinationFileName: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function ui_show_select_directory_dialog(ADestinationDirectory: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function transmit_ethernet_async(const AEthernetHeader: PLIBEthernetHeader): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function transmit_ethernet_sync(const AEthernetHeader: PLIBEthernetHeader; const ATimeoutMs: int32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function inject_ethernet_frame(const AEthernetHeader: PLIBEthernetHeader): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function tslog_blf_write_ethernet(const AHandle: int32; const AEthernetHeader: PLIBEthernetHeader): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function set_ethernet_channel_count(const ACount: int32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function get_ethernet_channel_count(ACount: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function transmit_ethernet_async_wo_pretx(const AEthernetHeader: PLIBEthernetHeader): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function db_get_can_db_index_by_id(const AId: int32; AIndex: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function db_get_lin_db_index_by_id(const AId: int32; AIndex: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function db_get_flexray_db_index_by_id(const AId: int32; AIndex: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function ioip_set_tcp_server_connection_callback(const AObj: Pointer; const AHandle: int32; const AConnectedCallback: TOnIoIPConnection; const ADisconnectedCallback: TOnIoIPConnection): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function eth_build_ipv4_udp_packet(const AHeader: PLIBEthernetHeader; const ASrcIp: pbyte; const ADstIp: pbyte; const ASrcPort: word; const ADstPort: word; const APayload: pbyte; const APayloadLength: word; AIdentification: pInt32; AFragmentIndex: pInt32): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function register_system_var_change_event(const ACompleteName: pansichar; const AEvent: TlibOnSysVarChange): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function unregister_system_var_change_event(const ACompleteName: pansichar; const AEvent: TlibOnSysVarChange): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function unregister_system_var_change_events(const AEvent: TlibOnSysVarChange): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function block_current_pretx(): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function call_system_api(const AAPIName: pansichar; const AArgCount: int32; const AArgCapacity: int32; AArgs: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function call_library_api(const AAPIName: pansichar; const AArgCount: int32; const AArgCapacity: int32; AArgs: PPAnsiChar): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function ethernet_is_udp_packet(const AHeader: PLIBEthernetHeader; var AIdentification: word; var AUDPPacketLength: word; var AUDPDataOffset: word; var AIsPacketEnded: boolean): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function ethernet_ip_calc_header_checksum(const AHeader: PLIBEthernetHeader; const AOverwriteChecksum: boolean; AChecksum: pword): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function ethernet_udp_calc_checksum(const AHeader: PLIBEthernetHeader; const AUDPPayloadAddr: pbyte; const AUDPPayloadLength: word; const AOverwriteChecksum: boolean; AChecksum: pword): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function ethernet_udp_calc_checksum_on_frame(const AHeader: PLIBEthernetHeader; const AOverwriteChecksum: boolean; AChecksum: pword): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
function eth_log_ethernet_frame_data(const AHeader: PLIBEthernetHeader): integer; stdcall; {$IFNDEF LIBTSMASTER_IMPL} external DLL_LIB_TSMASTER; {$ENDIF}
// MP DLL function import end (do not modify this line)

{$ENDIF}

implementation

uses
  System.Types,
  System.Math,
  System.AnsiStrings,
  System.SysUtils,
  System.StrUtils,
  system.DateUtils;

const
  // CAN message properties
  MASK_CANProp_DIR_TX  = $01;
  MASK_CANProp_REMOTE  = $02;
  MASK_CANProp_EXTEND  = $04;
  MASK_CANProp_ERROR   = $80;
  MASK_CANProp_LOGGED  = $60;
  // CAN FD message properties
  MASK_CANFDProp_IS_FD = $01;
  MASK_CANFDProp_IS_EDL = MASK_CANFDProp_IS_FD;
  MASK_CANFDProp_IS_BRS = $02;
  MASK_CANFDProp_IS_ESI = $04;
  // LIN message properties
  MASK_LINProp_DIR_TX          = $01;
  MASK_LINProp_SEND_BREAK      = $02;
  MASK_LINProp_RECEIVED_BREAK  = $04;
  MASK_LINProp_RECEIVED_SYNC   = $08;
  MASK_LINProp_HW_TYPE         = $30;
  MASK_LINProp_LOGGED          = $40;
  MASK_LINProp_SEND_SYNC       = $80;
  // CAN error frame
  CAN_ID_ERROR: Integer   = integer($FFFFFFFF);
  // CAN FD DLC Data Count mapping
  DLC_DATA_BYTE_CNT: array [0..15] of Byte = (
    0,  1,  2,  3,  4,  5,  6, 7,
    8,  12, 16, 20, 24, 32, 48, 64
  );

function GetFDDataLength(const ADLC: Integer): integer;
begin
  result := min(ADLC, 15);
  result := Max(result, 0);
  Result := DLC_DATA_BYTE_CNT[result];

end;

function TEMMC_RECORD_DATA.FDateTime(ATimeZone:Integer):TDateTime;
var
  tmp:UInt32;
  tmpUTCDate:UInt32;
  tmpUTCTime:UInt32;
  FSetting : TFormatSettings;
  tmpDateTimeString:string;
begin
{$warnings off}
  FSetting := TFormatSettings.Create(LOCALE_USER_DEFAULT);
{$warnings on}
  FSetting.ShortDateFormat:='yyyy-MM-dd';
  FSetting.DateSeparator:='-';
  //FSetting.TimeSeparator:=':';
  FSetting.LongTimeFormat:='hh:mm:ss.zzz';
  tmpDateTimeString := '';
  //FUTCDate:200822:DayMonthYear
  tmpUTCDate := FUTCDate;
  tmp := UInt32(tmpUTCDate div 10000);
  tmpUTCDate := tmpUTCDate - UInt32(tmp * 10000); //Day
  tmpDateTimeString := Format('-%.2d', [tmp]);
  tmp := tmpUTCDate div 100;
  tmpUTCDate := tmpUTCDate - UInt32(tmp * 100); //Month
  tmpDateTimeString := Format('-%.2d', [tmp]) + tmpDateTimeString;
  tmpDateTimeString := '20' + Format('%.2d', [tmpUTCDate]) + tmpDateTimeString + ' ';  //Year
  //FUTCTime:153053:HourMinuteSecond
  tmpUTCTime := FUTCTime;
  tmp := tmpUTCTime div 10000;
  tmpUTCTime := tmpUTCTime - UInt32(tmp * 10000); //Hour
  tmpDateTimeString := tmpDateTimeString +  Format('%.2d:', [tmp]);
  tmp := tmpUTCTime div 100;
  tmpUTCTime := tmpUTCTime - UInt32(tmp * 100);    //Minute
  tmpDateTimeString := tmpDateTimeString +  Format('%.2d:', [tmp]);
  tmpDateTimeString := tmpDateTimeString +  Format('%.2d:', [tmpUTCTime]) + '000'; //Second
  try
    if TryStrToDateTime(tmpDateTimeString, Result) then
    begin
      Result := StrToDateTime(tmpDateTimeString, FSetting);
      Result.AddHour(ATimeZone);
      Result.AddMilliSecond(FOffSetMiniSecond);
    end
    else
    begin
      result := now;
    end;
  except
    Result := now;
  end;

end;

function TEMMC_RECORD_DATA.FDateTimeString(ATimeZone:Integer):string;
begin
  result := FormatdateTime('YYYY-MM-DD hh:nn:ss:zzz',FDateTime(ATimeZone));

end;

procedure TLIBCAN.FromString(const AStr: string);
var
  ss: TStringDynArray;
begin
  // 100.123456 TX 1 $120 Data 8 12 23 45 56 67 78 89 12
  // 0          1  2 3    4    5 6  7  8  9  10 11 12 13
  ss := SplitString(AStr, ' ');
  if Length(ss) = 14 then begin
    FTimeUS := round(strtofloatdef(ss[0], 0) * 1000000);
    IsTX := ss[1].CompareTo('Tx') = 0;
    FIdxChn := StrToIntDef(ss[2], 1);
    FIdentifier := StrToIntDef(ss[3], 0);
    if ss[4].Equals('D') then begin
      IsData := true;
    end else begin
      IsData := false;
    end;
    FDLC := StrToIntDef(ss[5], 8);
    FDATA[0] := StrToIntDef(ss[6], 0);
    FDATA[1] := StrToIntDef(ss[7], 0);
    FDATA[2] := StrToIntDef(ss[8], 0);
    FDATA[3] := StrToIntDef(ss[9], 0);
    FDATA[4] := StrToIntDef(ss[10], 0);
    FDATA[5] := StrToIntDef(ss[11], 0);
    FDATA[6] := StrToIntDef(ss[12], 0);
    FDATA[7] := StrToIntDef(ss[13], 0);
  end;

end;

function TLIBCAN.GetData: boolean;
begin
  Result := (FProperties and MASK_CANProp_REMOTE) = 0;

end;

function TLIBCAN.GetErr: Boolean;
begin
  Result := (FProperties and MASK_CANProp_ERROR) <> 0;

end;

function TLIBCAN.GetIsErrorFrame: boolean;
begin
  Result := fidentifier = (CAN_ID_ERROR);

end;

function TLIBCAN.GetLogged: boolean;
begin
  Result := (FProperties and MASK_CANProp_LOGGED) <> 0;

end;

function TLIBCAN.GetStd: Boolean;
begin
  Result := (FProperties and MASK_CANProp_EXTEND) = 0;

end;

function TLIBCAN.GetTX: boolean;
begin
  Result := (FProperties and MASK_CANProp_DIR_TX) <> 0;

end;

procedure TLIBCAN.SetData(const AValue: Boolean);
begin
  if avalue then begin
    FProperties := FProperties and (not MASK_CANProp_REMOTE);
  end else begin
    FProperties := FProperties or MASK_CANProp_REMOTE;
  end;

end;

procedure TLIBCAN.SetErr(const AValue: Boolean);
begin
  if not AValue then begin
    FProperties := FProperties and (not MASK_CANProp_ERROR);
  end else begin
    FProperties := FProperties or MASK_CANProp_ERROR;
  end;

end;

procedure TLIBCAN.SetExtId(const AId: Int32; const ADLC: UInt32);
begin
  FIdxChn := 0;
  FIdentifier := AId;
  FDLC := ADLC;
  FProperties := 0;
  SetTX(True);
  SetStd(False);
  SetData(True);
  PUInt64(@FData[0])^ := 0;
  FReserved := 0;
  FTimeUS := 0;

end;

procedure TLIBCAN.SetIsErrorFrame(const Value: Boolean);
begin
  IsErrToken := true;
  fidentifier := (CAN_ID_ERROR);

end;

procedure TLIBCAN.SetLogged(const Value: boolean);
begin
  if not Value then begin
    FProperties := FProperties and (not MASK_CANProp_LOGGED);
  end else begin
    FProperties := FProperties or MASK_CANProp_LOGGED;
  end;

end;

procedure TLIBCAN.SetStd(const AValue: Boolean);
begin
  if avalue then begin
    FProperties := FProperties and (not MASK_CANProp_EXTEND);
  end else begin
    FProperties := FProperties or MASK_CANProp_EXTEND;
  end;

end;

procedure TLIBCAN.SetStdId(const AId: Int32; const ADLC: UInt32);
begin
  FIdxChn := 0;
  FIdentifier := AId;
  FDLC := ADLC;
  FProperties := 0;
  SetTX(True);
  SetStd(True);
  SetData(True);
  PUInt64(@FData[0])^ := 0;
  FReserved := 0;
  FTimeUS := 0;

end;

procedure TLIBCAN.SetTX(const AValue: Boolean);
begin
  if avalue then begin
    FProperties := FProperties or MASK_CANProp_DIR_TX;
  end else begin
    FProperties := FProperties and (not MASK_CANProp_DIR_TX);
  end;

end;

function TLIBCAN.ToString: string;
var
  sDatas: string;
  i: Integer;
begin
  Result := FloatToStr(FTimeUS / 1000000.0);
  if istx then begin
    Result := Result + ' Tx ' + fidxchn.ToString;
  end else begin
    Result := Result + ' Rx ' + fidxchn.ToString;
  end;
  if fidentifier = Byte(-1) then begin
    // error frame
    Result := Result + ' E';
  end else begin
    // normal frame
    if IsStd then begin
      Result := Result + ' $' + IntToHex(fidentifier, 3);
    end else begin
      Result := Result + ' $' + IntToHex(fidentifier, 8);
    end;
    if IsData then begin
      Result := result + ' D ';
    end else begin
      Result := result + ' R ';
    end;
    if FDLC > 8 then begin
      FDLC := 8;
    end;
    Result := Result + fdlc.ToString + ' ';
    sDatas := '';
    for i:=0 to 7 do begin // bug fix: 2020-01-04, data should be 8
      sDatas := sDatas + IntToHex(fdata[i], 2) + ' ';
    end;
    Result := result + sDatas;
  end;

end;

function TLIBLIN.GetTX: boolean;
begin
    Result := (FProperties and MASK_LINProp_DIR_TX) <> 0;

end;

procedure TLIBLIN.SetId(const AId, ADLC: Integer);
begin
  FIdxChn := 0;
  FErrCode := 0;
  FProperties := 0;
  FDLC := ADLC;
  FIdentifier := AId;
  PInt64(@fdata[0])^ := 0;
  FChecksum := 0;
  FStatus := 0;
  FTimeUS := 0;

end;

procedure TLIBLIN.SetTX(const AValue: Boolean);
begin
    if avalue then begin
      FProperties := FProperties or MASK_LINProp_DIR_TX;
    end else begin
      FProperties := FProperties and (not MASK_LINProp_DIR_TX);
    end;

end;

function TLIBLIN.GetData: boolean;
begin
   Result := True;

end;

function TLIBLIN.GetIsErrorFrame: boolean;
begin
  Result := FIdentifier = $FF;

end;

procedure TLIBLIN.FromString(const AStr: string);
var
  ss: TStringDynArray;
begin
  // 100.123456 TX 1 $120 Data 8 12 23 45 56 67 78 89 12
  // 0          1  2 3    4    5 6  7  8  9  10 11 12 13
  ss := SplitString(AStr, ' ');
  if Length(ss) = 14 then begin
    FTimeUS := round(strtofloatdef(ss[0], 0) * 1000000);
    IsTX := ss[1].CompareTo('Tx') = 0;
    FIdxChn := StrToIntDef(ss[2], 1);
    FIdentifier := StrToIntDef(ss[3], 0);
    //IsData := StrToIntDef(ss[4], 1);   //always isdata
    FDLC := StrToIntDef(ss[5], 8);
    FDATA[0] := StrToIntDef(ss[6], 0);
    FDATA[1] := StrToIntDef(ss[7], 0);
    FDATA[2] := StrToIntDef(ss[8], 0);
    FDATA[3] := StrToIntDef(ss[9], 0);
    FDATA[4] := StrToIntDef(ss[10], 0);
    FDATA[5] := StrToIntDef(ss[11], 0);
    FDATA[6] := StrToIntDef(ss[12], 0);
    FDATA[7] := StrToIntDef(ss[13], 0);
  end;

end;

function TLIBLIN.ToString: string;
var
  sDatas: string;
  i, n: Integer;
begin
  Result := FloatToStr(FTimeUS / 1000000.0);
  if istx then begin
    Result := Result + ' Tx ' + fidxchn.ToString;
  end else begin
    Result := Result + ' Rx ' + fidxchn.ToString;
  end;
  if fidentifier = Byte(-1) then begin
    // error frame
    Result := Result + ' E';
  end else begin
    // normal frame
    if FDLC > 8 then begin
      n := 8;
    end else begin
      n := FDLC;
    end;
    sDatas := '';
    for i:=0 to n - 1 do begin
      sDatas := sDatas + IntToHex(fdata[i], 2) + ' ';
    end;
    Result := result + ' $' + IntToHex(FIdentifier, 1) + ' ' + IntToStr(FDLC) + ' ' + sDatas;
  end;

end;

{ TCANFD }

procedure TLIBCANFD.FromString(const AStr: string);
const
  CANFD_CONF_LEN = 70;
var
  i: Integer;
  ss: TStringDynArray;
begin
  // 100.123456 TX 1 $120 Data 8 12 23 45 56 67 78 89 12
  // 0          1  2 3    4    5 6  7  8  9  10 11 12 13
  ss := SplitString(AStr, ' ');
  if Length(ss) = CANFD_CONF_LEN then begin
    FTimeUS := round(strtofloatdef(ss[0], 0) * 1000000);
    IsTX := ss[1].CompareTo('Tx') = 0;
    FIdxChn := StrToIntDef(ss[2], 1);
    FIdentifier := StrToIntDef(ss[3], 0);
    if ss[4].Equals('F') then begin
      IsEDL := true;
    end else if ss[4].Equals('D') then begin
      IsData := true;
    end else begin
      IsData := false;
    end;
    FDLC := StrToIntDef(ss[5], 8);
    for i:=0 to 63 do begin
      FDATA[i] := StrToIntDef(ss[6 + i], 0);
    end;
  end;

end;

procedure TLIBCANFD.FromTCAN(const ACAN: PLIBCAN);
begin
  PLIBCAN(@self)^ := acan^;
  FFDProperties := 0;

end;

function TLIBCANFD.GetData: boolean;
begin
  Result := (FProperties and MASK_CANProp_REMOTE) = 0;

end;

function TLIBCANFD.GetDataLength: integer;
begin
  Result := GetFDDataLength(FDLC);

end;

function TLIBCANFD.GetErr: Boolean;
begin
  Result := (FProperties and MASK_CANProp_ERROR) <> 0;

end;

function TLIBCANFD.GetIsBRS: boolean;
begin
  Result := (FProperties and MASK_CANFDProp_IS_BRS) <> 0;

end;

function TLIBCANFD.GetIsErrorFrame: boolean;
begin
  Result := fidentifier = (CAN_ID_ERROR);

end;

function TLIBCANFD.GetIsESI: boolean;
begin
  Result := (FProperties and MASK_CANFDProp_IS_ESI) <> 0;

end;

function TLIBCANFD.GetIsFD: Boolean;
begin
  Result := (FFDProperties and MASK_CANFDProp_IS_FD) <> 0;

end;

function TLIBCANFD.GetLogged: boolean;
begin
  Result := (FProperties and MASK_CANProp_LOGGED) <> 0;

end;

function TLIBCANFD.GetStd: Boolean;
begin
  Result := (FProperties and MASK_CANProp_EXTEND) = 0;

end;

function TLIBCANFD.GetTX: Boolean;
begin
  Result := (FProperties and MASK_CANProp_DIR_TX) <> 0;

end;

procedure TLIBCANFD.SetData(const AValue: Boolean);
begin
  if avalue then begin
    FProperties := FProperties and (not MASK_CANProp_REMOTE);
  end else begin
    FProperties := FProperties or MASK_CANProp_REMOTE;
  end;

end;

procedure TLIBCANFD.SetErr(const AValue: Boolean);
begin
  if not AValue then begin
    FProperties := FProperties and (not MASK_CANProp_ERROR);
  end else begin
    FProperties := FProperties or MASK_CANProp_ERROR;
  end;

end;

procedure TLIBCANFD.SetExtId(const AId: Int32; const ADLC: UInt32);
begin
  FIdxChn := 0;
  FIdentifier := AId;
  FDLC := ADLC;
  FProperties := 0;
  SetTX(True);
  SetStd(False);
  SetData(True);
  ZeroMemory(@FData[0], Length(FData));
  FFDProperties := MASK_CANFDProp_IS_FD;
  FTimeUS := 0;

end;

procedure TLIBCANFD.SetIsBRS(const AValue: Boolean);
begin
  if AValue then begin
    FFDProperties := FFDProperties or MASK_CANFDProp_IS_BRS;
  end else begin
    FFDProperties := FFDProperties and (not MASK_CANFDProp_IS_BRS);
  end;

end;

procedure TLIBCANFD.SetIsErrorFrame(const Value: Boolean);
begin
  IsErrToken := true;
  fidentifier := (CAN_ID_ERROR);

end;

procedure TLIBCANFD.SetIsESI(const AValue: Boolean);
begin
  if AValue then begin
    FFDProperties := FFDProperties or MASK_CANFDProp_IS_ESI;
  end else begin
    FFDProperties := FFDProperties and (not MASK_CANFDProp_IS_ESI);
  end;

end;

procedure TLIBCANFD.SetIsFD(const AIsFD: Boolean);
begin
  if AIsFD then begin
    FFDProperties := FFDProperties or MASK_CANFDProp_IS_FD;
  end else begin
    FFDProperties := FFDProperties and (not MASK_CANFDProp_IS_FD);
  end;

end;

procedure TLIBCANFD.SetLogged(const Value: boolean);
begin
  if not Value then begin
    FProperties := FProperties and (not MASK_CANProp_LOGGED);
  end else begin
    FProperties := FProperties or MASK_CANProp_LOGGED;
  end;

end;

procedure TLIBCANFD.SetStd(const AValue: Boolean);
begin
  if avalue then begin
    FProperties := FProperties and (not MASK_CANProp_EXTEND);
  end else begin
    FProperties := FProperties or MASK_CANProp_EXTEND;
  end;

end;

procedure TLIBCANFD.SetStdId(const AId: Int32; const ADLC: UInt32);
begin
  FIdxChn := 0;
  FIdentifier := AId;
  FDLC := ADLC;
  FProperties := 0;
  SetTX(True);
  SetStd(True);
  SetData(True);
  ZeroMemory(@FData[0], Length(FData));
  FFDProperties := MASK_CANFDProp_IS_FD;
  FTimeUS := 0;

end;

procedure TLIBCANFD.SetTX(const AValue: Boolean);
begin
  if avalue then begin
    FProperties := FProperties or MASK_CANProp_DIR_TX;
  end else begin
    FProperties := FProperties and (not MASK_CANProp_DIR_TX);
  end;

end;

function TLIBCANFD.ToString: string;
var
  sDatas: string;
  i: Integer;
begin
  Result := FloatToStr(FTimeUS / 1000000.0);
  if istx then begin
    Result := Result + ' Tx ' + fidxchn.ToString;
  end else begin
    Result := Result + ' Rx ' + fidxchn.ToString;
  end;
  if fidentifier = Integer(-1) then begin
    // error frame
    Result := Result + ' E';
  end else begin
    // normal frame
    if IsStd then begin
      Result := Result + ' $' + IntToHex(fidentifier, 3);
    end else begin
      Result := Result + ' $' + IntToHex(fidentifier, 8);
    end;
    if IsEDL then begin
      Result := Result + ' F ';
    end else begin
      if IsData then begin
        Result := result + ' D ';
      end else begin
        Result := result + ' R ';
      end;
    end;
    if FDLC > 15 then begin
      FDLC := 15;
    end;
    Result := Result + fdlc.ToString + ' ';
    sDatas := '';
    for i:=0 to DLC_DATA_BYTE_CNT[FDLC]-1 do begin
      sDatas := sDatas + IntToHex(fdata[i], 2) + ' ';
    end;
    Result := result + sDatas;
  end;

end;

{ TLIBTSMapping }

procedure TLIBTSMapping.Init;
begin
  ZeroMemory(@FAppName[0], Length(FAppName));
  FAppChannelIndex := 0;
  FAppChannelType := TLIBApplicationChannelType.APP_CAN;
  FHWDeviceType := TLIBBusToolDeviceType.BUS_UNKNOWN_TYPE;
  FHWIndex := 0;
  FHWChannelIndex := 0;
  FHWDeviceSubType := 0;
  ZeroMemory(@FHWDeviceName[0], Length(FHWDeviceName));
  FMappingDisabled := False;

end;

function TLIBTSMapping.SetMappingInfo(const AAppName: string;
  const AIdxLogicalChannel: integer; const AChnType: TLIBApplicationChannelType;
  const AHWDeviceType: TLIBBusToolDeviceType; const AIdxHW, AIdxHWChn,
  AHWDeviceSubType: integer; const AHWDeviceName: string): boolean;
begin
  Result := false;
  if Length(AAppName) >= 32 then exit;
  if Length(AHWDeviceName) >= 32 then exit;
  System.AnsiStrings.StrPCopy(@FAppName[0], AnsiString(AAppName));
  FAppChannelIndex := AIdxLogicalChannel;
  FAppChannelType := AChnType;
  FHWDeviceType := AHWDeviceType;
  FHWIndex := AIdxHW;
  FHWChannelIndex := AIdxHWChn;
  FHWDeviceSubType := AHWDeviceSubType;
  System.AnsiStrings.StrPCopy(@FHWDeviceName[0], AnsiString(AHWDeviceName));
  FMappingDisabled := False;
  result := true;

end;

function TLIBTSMapping.ToString: string;
const
  AppChannelTypeNames: array[0..1] of string = (
    'CAN',
    'LIN'
  );
  BUS_TOOL_DEVICE_NAMES: array [0..3] of string = (
    'Unknown bus tool',
    'TS Virtual Device',
    'Vector',
    'TOSUN'
  );
var
  sChannelType: string;
  sHWName: string;
  sDisabled: string;
begin
  sChannelType := AppChannelTypeNames[Integer(FAppChannelType)] + ' Channel ';
  if FHWDeviceType <> BUS_UNKNOWN_TYPE then begin
    if FHWDeviceSubType <> -1 then begin
      sHWName := BUS_TOOL_DEVICE_NAMES[integer(FHWDeviceType)] + ' ' + string(ansistring(FHWDeviceName));
    end else begin
      sHWName := BUS_TOOL_DEVICE_NAMES[integer(FHWDeviceType)];
    end;
    if FMappingDisabled then begin
      sDisabled := '[ Disabled ]';
    end else begin
      sDisabled := '';
    end;
    // device known
    Result := // APP name
              string(ansistring(FAppName)) + ' ' +
              // APP channel type
              sChannelType +
              // APP channel index
              (FAppChannelIndex + 1).ToString + ' - ' +
              // HW type
              sHWName + ' ' +
              // HW index
              (FHWIndex + 1).ToString + ' ' +
              // HW channel index
              sChannelType + (FHWChannelIndex + 1).ToString + ' ' +
              // disabled token
              sDisabled;
  end else begin
    // device unknown
    Result := // APP name
              string(ansistring(FAppName)) + ' ' +
              // APP channel type
              sChannelType +
              // APP channel index
              (FAppChannelIndex + 1).ToString;
  end;

end;

{ TLibSystemVar }

function TLibSystemVar.ToDataString: string;
begin
  var i, n: integer;
  result := '';
  n := FDataCapacity-1;
  case FType of
    TLIBSystemVarType.lsvtInt32: begin
      result := pinteger(FData)^.tostring;
    end;
    TLIBSystemVarType.lsvtUInt32: begin
      result := pcardinal(FData)^.tostring;
    end;
    TLIBSystemVarType.lsvtInt64: begin
      result := pint64(FData)^.tostring;
    end;
    TLIBSystemVarType.lsvtUInt64: begin
      result := puint64(FData)^.tostring;
    end;
    TLIBSystemVarType.lsvtUInt8Array: begin
      var p: pbyte;
      p := FData;
      for i:=0 to n do begin
        result := result + p^.ToString;
        if i < n then result := result + ',';
        inc(p);
      end;
    end;
    TLIBSystemVarType.lsvtInt32Array: begin
      var p: pinteger;
      p := pinteger(FData);
      for i:=0 to n do begin
        result := result + p^.ToString;
        if i < n then result := result + ',';
        inc(p);
      end;
    end;
    TLIBSystemVarType.lsvtInt64Array: begin
      var p: pint64;
      p := pint64(FData);
      for i:=0 to n do begin
        result := result + p^.ToString;
        if i < n then result := result + ',';
        inc(p);
      end;
    end;
    TLIBSystemVarType.lsvtDouble: begin
      result := pdouble(FData)^.tostring;
    end;
    TLIBSystemVarType.lsvtDoubleArray: begin
      var p: pdouble;
      p := pdouble(FData);
      for i:=0 to n do begin
        result := result + p^.ToString;
        if i < n then result := result + ',';
        inc(p);
      end;
    end;
    TLIBSystemVarType.lsvtString: begin
      result := string(ansistring(FName));
    end;
  end;

end;

function TEMMC_RECORD_NODE.RecordString:string;
begin
  Result := FIndex.toString + ':' + FRecordData.FDateTimeString(8);
  //FRecordData:TEMMC_RECORD_DATA;
  Result := Result + ':Size[' + FRecordData.FSectorSize.ToString;
  Result := Result + '][' + FRecordData.FStartSector.ToString  + ',' +
     (FRecordData.FStartSector + FRecordData.FSectorSize - 1).toString + ']';

end;

function TEMMC_RECORD_NODE.GetSlibingNode(AIndex:Integer):PEMMC_RECORD_NODE;
var
  i:integer;
begin
  Result := @Self;
  for i := 0 to AIndex - 1 do   //0
  begin
    if Assigned(Result) = false then
      Break;
    Result := Result.FNext;
  end;

end;

{ TLIBEthernetHeader }

function TLIBEthernetHeader.ActualDataPointer: pbyte;
begin
  result := pbyte(@self);
  Inc(result, SizeOf(Self));

end;

function TLIBEthernetHeader.DestinationMACAddr: pbyte;
begin
  result := FEthernetDataPointer;

end;

function TLIBEthernetHeader.EthernetPayloadPointer: pbyte;
begin
  result := FEthernetDataPointer;
  Inc(result, 6{dest MAC} + 6{source MAC} + 2{ethernet type});

end;

function TLIBEthernetHeader.EthernetType: word;
begin
  var p: pbyte;
  p := FEthernetDataPointer;
  Inc(p, 6{dest MAC} + 6{source MAC});
  result := pword(p)^;

end;

function TLIBEthernetHeader.EthernetTypeAddr: pbyte;
begin
  result := FEthernetDataPointer;
  Inc(result, 6{dest MAC} + 6{source MAC});

end;

function TLIBEthernetHeader.GetTX: Boolean;
begin
  result := fdir <> 0;

end;

procedure TLIBEthernetHeader.InitWithData(const AData: pbyte;
  const ALength: word);
begin
  FIdxChn := 0;
  FDir := 0;
  FProperties := 0;
  FReserved0 := 0;
  FReserved1 := 0;
  FIdxSwitch := 0;
  FIdxPort := 0;
  FTimeUs := 0;
  FEthernetPayloadLength := ALength;
  FEthernetDataPointer := ActualDataPointer;

end;

procedure TLIBEthernetHeader.SetTX(const Value: Boolean);
begin
  if value then begin
    fdir := 1;
  end else begin
    fdir := 0;
  end;

end;

function TLIBEthernetHeader.SourceMACAddr: pbyte;
begin
  result := FEthernetDataPointer;
  Inc(result, 6{dest MAC});

end;

function TLIBEthernetHeader.ToDisplayString: string;
var
  i: integer;
  p: pbyte;
begin
  p := EthernetPayloadPointer;
  if Assigned(p) then begin
    result := '';
    for i:=0 to FEthernetPayloadLength - 1 do begin
      result := result + p^.ToHexString(2);
      if i < FEthernetPayloadLength-1 then result := result + ' ';
    end;
  end else begin
    result := 'n.a.';
  end;
  result := 'IdxNetwork=' + fidxchn.tostring + ',' +
            'IdxSwitch=' + fidxswitch.toString + ',' +
            'IdxPort=' + fidxport.ToString + ',' +
            'Dir=' + fdir.ToString + ',' +
            'Properties=' + fproperties.tohexstring + ',' +
            // 'Source=' + MACAddrToString(SourceMACAddr) + ',' +
            // 'Destination=' + MACAddrToString(destinationmacaddr) + ',' +
            'Time=' + (FTimeUs / 1000000.0).ToString + ',' +
            'EthPayloadLen=' + FethernetPayloadLength.ToString + ',' +
            'Payload=' + result;

end;

function TLIBEthernetHeader.ToETHFrameHash: integer;
begin
  result := -1;

end;

function TLIBEthernetHeader.TotalEthernetPacketLength: integer;
begin
  result := SizeOf(self) + 6 + 6 + 2 + FEthernetPayloadLength;

end;

initialization
  Assert(sizeof(TLIBCAN) = 24, 'TLIBCAN.size = 24');
  Assert(sizeof(TLIBLIN) = 23, 'TLIBLIN.size = 23');
  Assert(sizeof(TLIBCANFD) = 80, 'TLIBCANFD.size = 80');
  Assert(sizeof(TLIBFlexRay) = 302, 'TFlexRay.size = 302');
  Assert(sizeof(TLIBEthernetHeader) = 28, 'TEthernetHeader.size = 28');
  Assert(sizeof(Trealtime_comment_t) = 24, 'Trealtime_comment_t.size = 24');
  Assert(sizeof(TLibSystemVar) = 36, 'TLibSystemVar.size = 36');
  Assert(SizeOf(TLibFlexRayClusterParameters) = 440, 'TLibFlexRayClusterParameters.size = 440');
  Assert(SizeOf(TLibFlexRayControllerParameters) = 212, 'TLibFlexRayControllerParameters.size = 212');

end.
