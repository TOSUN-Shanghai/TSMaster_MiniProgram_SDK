#ifndef _TSMaster_MP_H
#define _TSMaster_MP_H

/*
  Note: 
  [1] Definitions of TCAN, TCANFD, TLIN, TFlexRay, TEthernetHeader can be found in this header
  [2] channel index is always starting from 0
  [3] for error codes of API, please see bottem area of this file
  [4] F3 for fast locating: TCAN TCANFD TLIN TFlexRay TEthernetHeader _TTSApp _TTSCOM _TTSTest
*/

#include <stdio.h>
#include <cstring>

#define CH1 0
#define CH2 1
#define CH3 2
#define CH4 3
#define CH5 4
#define CH6 5
#define CH7 6
#define CH8 7
#define CH9 8
#define CH10 9
#define CH11 10
#define CH12 11
#define CH13 12
#define CH14 13
#define CH15 14
#define CH16 15
#define CH17 16
#define CH18 17
#define CH19 18
#define CH20 19
#define CH21 20
#define CH22 21
#define CH23 22
#define CH24 23
#define CH25 24
#define CH26 25
#define CH27 26
#define CH28 27
#define CH29 28
#define CH30 29
#define CH31 30
#define CH32 31

#define GENERIC_STRING_MAX_LENGTH 32

typedef enum {lvlError = 1, lvlWarning = 2, lvlOK = 3, lvlHint = 4, lvlInfo = 5, lvlVerbose = 6} TLogLevel;

// basic var type definition
typedef unsigned __int8 u8;
typedef signed __int8 s8;
typedef unsigned __int16 u16;
typedef signed __int16 s16;
typedef unsigned __int32 u32;
typedef signed __int32 s32;
typedef unsigned __int64 u64;
typedef signed __int64 s64;
// pointer definition
typedef unsigned __int8* pu8;
typedef unsigned __int8** ppu8;
typedef signed __int8* ps8;
typedef unsigned __int16* pu16;
typedef signed __int16* ps16;
typedef unsigned __int32* pu32;
typedef signed __int32* ps32;
typedef signed __int32** pps32;
typedef unsigned __int64* pu64;
typedef signed __int64* ps64;
typedef float* pfloat;
typedef double* pdouble;
typedef char* pchar;
typedef char** ppchar;
typedef bool* pbool;
typedef void* pvoid;
// SOME/IP types
typedef struct someip_handle_t {
    u64 value;
} someip_handle_t;
typedef struct someip_service_instance_t {
    u16 service_id;
    u16 instance_id;
    u8 major_version;
    u32 minor_version;
} someip_service_instance_t;
typedef struct someip_endpoint_options_t {
    u32 network_index;
    const char* participant_name;
    const char* endpoint_name;
} someip_endpoint_options_t;
typedef struct someip_event_options_t {
    u16 event_id;
    u8 reliable;
    u32 cycle_time_ms;
} someip_event_options_t;
typedef struct someip_field_options_t {
    u16 field_event_id;
    u16 setter_id;
    u16 getter_id;
    u8 reliable;
} someip_field_options_t;
typedef struct someip_method_options_t {
    u16 method_id;
    u8 reliable;
} someip_method_options_t;
#ifdef _WIN64
    typedef s64 native_int;
    typedef u64 native_uint;
    typedef u64 ts_nfds_t;
#else
    typedef s32 native_int;
    typedef u32 native_uint;
    typedef u32 ts_nfds_t;
#endif
typedef native_int* pnative_int;
typedef native_uint* pnative_uint;
typedef u32 ts_socket_t;
typedef unsigned __int32 tts_socklen_t;
typedef unsigned __int32* pts_socklen_t;
typedef u8 ts_sa_family_t;
typedef u16 ts_in_port_t;
typedef u32 ts_in_addr_t;


#define MIN(a,b) (((a)<(b))?(a):(b))
#define MAX(a,b) (((a)>(b))?(a):(b))
#define SWAP_BYTES(x) (((x) >> 8) | ((x & 0xFF) << 8))
#if defined(_MSC_VER)
    #define DLLEXPORT extern "C" __declspec(dllexport)
#else
    #define DLLEXPORT extern "C" __attribute__((visibility("default")))
#endif

#pragma pack(push)
#pragma pack(1)

// CAN definitions
#define MASK_CANProp_DIR_TX 0x01
#define MASK_CANProp_REMOTE 0x02
#define MASK_CANProp_EXTEND 0x04
#define MASK_CANProp_ERROR  0x80
#define MASK_CANProp_LOGGED 0x60

// CAN FD message properties
#define MASK_CANFDProp_IS_FD 0x01
#define MASK_CANFDProp_IS_EDL MASK_CANFDProp_IS_FD
#define MASK_CANFDProp_IS_BRS 0x02
#define MASK_CANFDProp_IS_ESI 0x04

// LIN message properties
#define MASK_LINProp_DIR_TX         0x01
#define MASK_LINProp_SEND_BREAK     0x02
#define MASK_LINProp_RECEIVED_BREAK 0x04
#define MASK_LINProp_SEND_SYNC      0x80
#define MASK_LINProp_RECEIVED_SYNC  0x10

const u8 DLC_DATA_BYTE_CNT[16] = {
    0, 1, 2, 3, 4, 5, 6, 7,
    8, 12, 16, 20, 24, 32, 48, 64
};

typedef enum _MBDDataType {
  dtInherit = 0, 
  dtDouble,
  dtSingle,
  dtHalf,
  dtInt8,
  dtUInt8,
  dtInt16,
  dtUInt16,
  dtInt32,
  dtUInt32,
  dtInt64,
  dtUInt64,
  dtBoolean,
  dtString,
} TMBDDataType, *PMBDDataType;

typedef enum {
    AIT_DIAGRAM          = 0,
    AIT_JUNCTION         = 1,
    AIT_GROUP            = 2,
    AIT_STATE            = 3,
    AIT_GRAPHIC_FUNCTION = 4,
    AIT_DIAGRAM_FUNCTION = 5,
    AIT_C_FUNCTION       = 6,
    AIT_TRUTH_TABLE      = 7,
    AIT_COMMENT          = 8,
    AIT_IMAGE            = 9,
    AIT_HISTORY_JUNCTION = 10,
    AIT_DATA             = 11,
    AIT_TRANSITION       = 12,
    AIT_EVENT            = 13
} TAiFlowObjectType, *pTAiFlowObjectType;

typedef enum {
    DECOMP_OR      = 0,
    DECOMP_AND     = 1,
    DECOMP_CLUSTER = 2
} TAiFlowDecomposition, *pTAiFlowDecomposition;

typedef enum {
    DRAG_NONE         = 0,
    DRAG_TOP_LEFT     = 1,
    DRAG_TOP_RIGHT    = 2,
    DRAG_BOTTOM_LEFT  = 3,
    DRAG_BOTTOM_RIGHT = 4,
    DRAG_TOP          = 5,
    DRAG_BOTTOM       = 6,
    DRAG_LEFT         = 7,
    DRAG_RIGHT        = 8
} TAiFlowDragHandlePosition, *pTAiFlowDragHandlePosition;

typedef enum {
    ALIGN_LEFT     = 0,
    ALIGN_RIGHT    = 1,
    ALIGN_TOP      = 2,
    ALIGN_BOTTOM   = 3,
    ALIGN_CENTER_H = 4,
    ALIGN_CENTER_V = 5
} TAiFlowAlignMode, *pTAiFlowAlignMode;

typedef struct _tip4_addr_t{
  u32 addr;
}tip4_addr_t, *pip4_addr_t;

typedef struct _tip6_addr_t{
  u32 addr[4];
  u32 zone;
}tip6_addr_t, *pip6_addr_t;

typedef enum {IPADDR_TYPE_V4 = 0, IPADDR_TYPE_V6 = 6, IPADDR_TYPE_ANY = 46} lwip_ip_addr_type;

typedef struct _tip_addr_t{
   tip6_addr_t ip4Or6;
   u32 FType;
   pip4_addr_t ipv4(void){
      return (pip4_addr_t)(&ip4Or6.addr[0]);
   }
   pip6_addr_t ipv6(void){
      return (pip6_addr_t)(&ip4Or6);
   }
}tip_addr_t, *pip_addr_t;

typedef struct _tts_sockaddr_private{
  u8 sa_len;
  ts_sa_family_t sa_family;
  char sa_data[14];
}tts_sockaddr_private, *pts_sockaddr;

typedef struct _ts_in_addr{
  ts_in_addr_t ts_addr;
}ts_in_addr;

#define   SIN_ZERO_LEN        (8)
typedef struct _tts_sockaddr_in_private{
  u8 sin_len;
  ts_sa_family_t sin_family;
  ts_in_port_t sin_port;
  ts_in_addr sin_addr;
  char sin_zero[SIN_ZERO_LEN];
}tts_sockaddr_in_private, pts_sockaddr_in;


typedef struct _ts_sockaddr_in_union{
  u32 FData[4];
}ts_sockaddr_in_union;

typedef struct _tts_iovec{
  void* iov_base;
  native_int iov_len;
}tts_iovec, *pts_iovec;

typedef struct _tts_timeval{
  s32 tv_sec;
  s32 tv_usec;
}tts_timeval, *pts_timeval;

#define TS_FD_SETSIZE 10
typedef struct _tts_fd_set{
  u8 fd_bits[2];
}tts_fd_set, *pts_fd_set;

typedef struct _tts_pollfd{
  s32 fd;
  s16 events; //short;
  s16 revents; //Short;
}tts_pollfd, *pts_pollfd;

typedef struct _tts_msghdr{ 
  pvoid msg_name;
  tts_socklen_t msg_namelen;
  s32 reserved0;
  pts_iovec msg_iov;
  s32 msg_iovlen;    //received package num
  s32 reserved1;
  pvoid msg_control;
  tts_socklen_t msg_controllen;
  s32 msg_flags;     //set internal
}tts_msghdr, *pts_msghdr;

typedef struct _tts_cmsghdr{
    tts_socklen_t cmsg_len;   ///* number of bytes, including header */
    s32 cmsg_level; ///* originating protocol */
    s32 cmsg_type;  ///* protocol-specific type */
}tts_cmsghdr, *pts_cmsghdr;

typedef struct _tts_in_pktinfo{
  u32 ipi_ifindex;     // Interface index
  ts_in_addr ipi_addr; // Destination (from header) address
}tts_in_pktinfo, *pts_in_pktinfo;

typedef struct _tts_addrinfo{
  s32 ai_flags;                         // Input flags
  s32 ai_family;                        // Address family of socket
  s32 ai_socktype;                      //Socket type
  s32 ai_protocol;                      // Protocol of socket
  tts_socklen_t  ai_addrlen;            // Length of socket address
  pts_sockaddr  ai_addr;                // Socket address of socket
  char*  ai_canonname;              // Canonical name of service location
  struct _tts_addrinfo*  ai_next;       // Pointer to next in list
}tts_addrinfo, *pts_addrinfo, **ppts_addrinfo;

typedef struct _tts_hostent{
  char*  h_name;          // Official name of the host
  char** h_aliases;       // A pointer to an array of pointers to alternative host names// terminated by a null pointer
  s32    h_addrtype;      // Address type
  s32    h_length;        // The length, in bytes, of the address
  char** h_addr_list;     // A pointer to an array of pointers to network addresses (in
                          // network byte order) for the host, terminated by a null pointer
}tts_hostent, *pts_hostent, **ppts_hostent;

#define LWIP_IPV6_NUM_ADDRESSES 3
//packed =  1
typedef struct _tts_net_device{
  tip4_addr_t ip_addr;
  tip4_addr_t netmask;
  tip4_addr_t gw;
  tip6_addr_t ip6_addr[LWIP_IPV6_NUM_ADDRESSES];
  u16 mtu;
  u16 mtu6;
  u16 vlan;
  u8 hwaddr[6];
  u8 flags;
  u8 index;
}tts_net_device, *pts_net_device, **ppts_net_device;

     
// CAN frame type ================================================
typedef enum _TLIBA429BitRate {
    A429_BITRATE_100K = 0,
    A429_BITRATE_12K5 = 1,
    A429_BITRATE_50K = 2
} TLIBA429BitRate;

typedef enum _TLIBA429Bit32Mode {
    A429_BIT32_DATA = 0,
    A429_BIT32_PARITY = 1
} TLIBA429Bit32Mode;

typedef enum _TLIBA429Parity {
    A429_PARITY_ODD = 0,
    A429_PARITY_EVEN = 1
} TLIBA429Parity;

typedef enum _TLIBA429TxMode {
    A429_TX_NORMAL = 0,
    A429_TX_LOOPBACK = 1
} TLIBA429TxMode;

typedef struct _TLIBA429 {
    u8 FVersion;
    u8 FProperties;
    u8 FIdxChn;
    u8 FMessageIndex;
    u32 FData;
    s64 FTimeUs;
} TLIBA429, *PLIBA429;

typedef struct _TLIBA429TxConfig {
    u8 FVersion;
    u8 FIdxChn;
    u8 FBitRate;
    u8 FBit32Mode;
    u8 FParity;
    u8 FTxMode;
    u16 FWordIntervalUs;
} TLIBA429TxConfig, *PLIBA429TxConfig;

typedef struct _TLIBA429RxConfig {
    u8 FVersion;
    u8 FIdxChn;
    u8 FBitRate;
    u8 FBit32Mode;
    u8 FParity;
    u8 FEnableSDIFilter;
    u8 FSDI;
    u8 FEnableLabelFilter;
    u16 FLabelCount;
    u8 FReserved[2];
    u8 FLabels[256];
} TLIBA429RxConfig, *PLIBA429RxConfig;

typedef struct _TLIBA429CyclicMessage {
    u8 FMessageIndex;
    u8 FReserved0;
    u16 FPeriodMs;
    u16 FSendCount;
    u16 FReserved1;
    u32 FData;
} TLIBA429CyclicMessage, *PLIBA429CyclicMessage;

typedef struct _TLIBA429ChannelCapability {
    u8 FVersion;
    u8 FIdxChn;
    u8 FDirectionMask;
    u8 FReserved[5];
} TLIBA429ChannelCapability, *PLIBA429ChannelCapability;

typedef struct _TCAN{
    u8 FIdxChn;
    u8 FProperties;
    u8 FDLC;
    u8 FReserved;
    s32 FIdentifier;
    s64 FTimeUs;
    u8  FData[8];
    // is_tx -----------------------------------------------------
    bool get_is_tx(void) const
    { 
        return (FProperties & MASK_CANProp_DIR_TX) != 0;
    }
    void set_is_tx(const bool value)
    {
        if (value) {
            FProperties = FProperties | MASK_CANProp_DIR_TX;
        } else {
            FProperties = FProperties & (~MASK_CANProp_DIR_TX);
        }
    }
    __declspec(property(get = get_is_tx, put = set_is_tx)) bool is_tx;
    // is_data ----------------------------------------------------
    bool get_is_data(void) const
    { 
        return (FProperties & MASK_CANProp_REMOTE) == 0;
    }
    void set_is_data(const bool value)
    {
        if (value) {
            FProperties = FProperties & (~MASK_CANProp_REMOTE);
        } else {
            FProperties = FProperties | MASK_CANProp_REMOTE;
        }
    }
    __declspec(property(get = get_is_data, put = set_is_data)) bool is_data;
    // is_std -----------------------------------------------------
    bool get_is_std(void) const
    { 
        return (FProperties & MASK_CANProp_EXTEND) == 0;
    }
    void set_is_std(const bool value)
    {
        if (value) {
            FProperties = FProperties & (~MASK_CANProp_EXTEND);
        } else {
            FProperties = FProperties | MASK_CANProp_EXTEND;
        }
    }
    __declspec(property(get = get_is_std, put = set_is_std)) bool is_std;
    // is_err ----------------------------------------------------
    bool get_is_err(void) const
    { 
        return (FProperties & MASK_CANProp_ERROR) != 0;
    }
    void set_is_err(const bool value)
    {
        if (value) {
            FProperties = FProperties | MASK_CANProp_ERROR;
        } else {
            FProperties = FProperties & (~MASK_CANProp_ERROR);
        }
    }
    __declspec(property(get = get_is_err, put = set_is_err)) bool is_err;
    // load data bytes -------------------------------------------
    void load_data(u8* a) {
        for (u32 i = 0; i < 8; i++) {
            FData[i] = *a++;
        }
    }
    void set_data(const u8 d0, const u8 d1, const u8 d2, const u8 d3, const u8 d4, const u8 d5, const u8 d6, const u8 d7){
        FData[0] = d0;
        FData[1] = d1;
        FData[2] = d2;
        FData[3] = d3;
        FData[4] = d4;
        FData[5] = d5;
        FData[6] = d6;
        FData[7] = d7;
    }
    // initialize with standard identifier -----------------------
    void init_w_std_id(s32 AId, s32 ADLC) {
        FIdxChn = 0;
        FIdentifier = AId;
        FDLC = ADLC;
        FReserved = 0;
        FProperties = 0;
        is_tx = false;
        is_std = true;
        is_data = true;
        *(u64*)(&FData[0]) = 0;
        FTimeUs = 0;
    }
    // initialize with extended identifier -----------------------
    void init_w_ext_id(s32 AId, s32 ADLC) {
        FIdxChn = 0;
        FIdentifier = AId;
        FDLC = ADLC;
        FReserved = 0;
        FProperties = 0;
        is_tx = false;
        is_std = false;
        is_data = true;
        *(u64*)(&FData[0]) = 0;
        FTimeUs = 0;
    }
} TCAN, *PCAN;

// CAN FD frame type =============================================
typedef struct _TCANFD{
    u8 FIdxChn;
    u8 FProperties;
    u8 FDLC;
    u8 FFDProperties;
    s32 FIdentifier;
    s64 FTimeUs;
    u8  FData[64];
    // is_tx -----------------------------------------------------
    bool get_is_tx(void) const
    { 
        return (FProperties & MASK_CANProp_DIR_TX) != 0;
    }
    void set_is_tx(const bool value)
    {
        if (value) {
            FProperties = FProperties | MASK_CANProp_DIR_TX;
        } else {
            FProperties = FProperties & (~MASK_CANProp_DIR_TX);
        }
    }
    __declspec(property(get = get_is_tx, put = set_is_tx)) bool is_tx;
    // is_data ---------------------------------------------------
    bool get_is_data(void) const
    { 
        return (FProperties & MASK_CANProp_REMOTE) == 0;
    }
    void set_is_data(const bool value)
    {
        if (value) {
            FProperties = FProperties & (~MASK_CANProp_REMOTE);
        } else {
            FProperties = FProperties | MASK_CANProp_REMOTE;
        }
    }
    __declspec(property(get = get_is_data, put = set_is_data)) bool is_data;
    // is_std ----------------------------------------------------
    bool get_is_std(void) const
    { 
        return (FProperties & MASK_CANProp_EXTEND) == 0;
    }
    void set_is_std(const bool value)
    {
        if (value) {
            FProperties = FProperties & (~MASK_CANProp_EXTEND);
        } else {
            FProperties = FProperties | MASK_CANProp_EXTEND;
        }
    }
    __declspec(property(get = get_is_std, put = set_is_std)) bool is_std;
    // is_err ----------------------------------------------------
    bool get_is_err(void) const
    { 
        return (FProperties & MASK_CANProp_ERROR) != 0;
    }
    void set_is_err(const bool value)
    {
        if (value) {
            FProperties = FProperties | MASK_CANProp_ERROR;
        } else {
            FProperties = FProperties & (~MASK_CANProp_ERROR);
        }
    }
    __declspec(property(get = get_is_err, put = set_is_err)) bool is_err;
    // is_edl ----------------------------------------------------
    bool get_is_edl(void) const
    { 
        return (FFDProperties & MASK_CANFDProp_IS_FD) != 0;
    }
    void set_is_edl(const bool value)
    {
        if (value) {
            FFDProperties = FFDProperties | MASK_CANFDProp_IS_FD;
        } else {
            FFDProperties = FFDProperties & (~MASK_CANFDProp_IS_FD);
        }
    }
    __declspec(property(get = get_is_edl, put = set_is_edl)) bool is_edl;
    // is_brs ----------------------------------------------------
    bool get_is_brs(void) const
    { 
        return (FFDProperties & MASK_CANFDProp_IS_BRS) != 0;
    }
    void set_is_brs(const bool value)
    {
        if (value) {
            FFDProperties = FFDProperties | MASK_CANFDProp_IS_BRS;
        } else {
            FFDProperties = FFDProperties & (~MASK_CANFDProp_IS_BRS);
        }
    }
    __declspec(property(get = get_is_brs, put = set_is_brs)) bool is_brs;
    // is_esi ----------------------------------------------------
    bool get_is_esi(void) const
    { 
        return (FFDProperties & MASK_CANFDProp_IS_ESI) != 0;
    }
    void set_is_esi(const bool value)
    {
        if (value) {
            FFDProperties = FFDProperties | MASK_CANFDProp_IS_ESI;
        } else {
            FFDProperties = FFDProperties & (~MASK_CANFDProp_IS_ESI);
        }
    }
    __declspec(property(get = get_is_esi, put = set_is_esi)) bool is_esi;
    // load data bytes -------------------------------------------
    void load_data(u8* a) {
        for (u32 i = 0; i < 64; i++) {
            FData[i] = *a++;
        }
    }
    // initialize with standard identifier -----------------------
    void init_w_std_id(s32 AId, s32 ADLC) {
        s32 i;
        FIdxChn = 0;
        FIdentifier = AId;
        FDLC = ADLC;
        FProperties = 0;
        FFDProperties = MASK_CANFDProp_IS_FD;
        is_tx = false;
        is_std = true;
        is_data = true;
        for (i = 0; i < 64; i++) FData[i] = 0;
        FTimeUs = 0;
    }
    // initialize with extended identifier -----------------------
    void init_w_ext_id(s32 AId, s32 ADLC) {
        s32 i;
        FIdxChn = 0;
        FIdentifier = AId;
        FDLC = ADLC;
        FFDProperties = MASK_CANFDProp_IS_FD;
        FProperties = 0;
        is_tx = false;
        is_std = false;
        is_data = true;
        for (i = 0; i < 64; i++) FData[i] = 0;
        FTimeUs = 0;
    }
    // get fd data length ----------------------------------------
    s32 get_data_length() const {
        s32 l = MIN(FDLC, 15);
        l = MAX(l, 0);
        return DLC_DATA_BYTE_CNT[l];
    }
    // to CAN struct ---------------------------------------------
    TCAN to_tcan(void){
        return *(TCAN*)(&FIdxChn);
    }
} TCANFD, *PCANFD;

// CAN XL frame type =============================================
typedef struct {
    u64 FTimestamp;   /* hw local timestamp when this command is issued */
    u32 FIdentifier;  /* 0x55, CAN identifier */
    u8  FIdxChn;      /* channel index: 0 -> ch1, 1 -> ch2 */
    u8  FVCID;        /* only for XL mode */
    u8  FStatusGrp;   /* [7] 0-normal,1-error; [6-4] tbd; [3] 0-non XL,1-XL; [1] 0-data,1-remote; [0] dir: 0-RX,1-TX */
    u8  FFDProperties;/* [7] is_v1; [6-3] tbd; [2] ESI; [1] BRS; [0] EDL */
    u16 FDLC;         /* encoded length: 0..2047 represents 1..2048 bytes */
    u8  FSDT;         /* upper layer, e.g., TCP/IP, CANopen */
    u8  FCtrl_0;      /* bit1: FAST; bit2: SEC; bit4-7: ADS */
    u32 FAF;          /* 32-bit hardware address filter */
    u8  FData[2048];
} TCANXL, *PCANXL;

// LIN frame type ================================================
typedef struct _LIN {
    u8  FIdxChn;
    u8  FErrStatus;
    u8  FProperties;
    u8  FDLC;
    u8  FIdentifier;
    u8  FChecksum;
    u8  FStatus;
    s64 FTimeUs;
    u8  FData[8];
    // is_tx -----------------------------------------------------
    bool get_is_tx(void)
    {
        return (FProperties & MASK_LINProp_DIR_TX) != 0;
    }
    void set_is_tx(const bool value)
    {
        if (value) {
            FProperties = FProperties | MASK_LINProp_DIR_TX;
        }
        else {
            FProperties = FProperties & (~MASK_LINProp_DIR_TX);
        }
    }
    __declspec(property(get = get_is_tx, put = set_is_tx)) bool is_tx;
    // load data bytes -------------------------------------------
    void load_data(u8* a) {
        for (u32 i = 0; i < 8; i++) {
            FData[i] = *a++;
        }
    }
    // initialize with identifier --------------------------------
    void init_w_id(const s32 AId, const s32 ADLC) {
        FIdxChn = 0;
        FErrStatus = 0;
        FProperties = 0;
        FDLC = ADLC;
        FIdentifier = AId;
        *(__int64*)(&FData[0]) = 0;
        FChecksum = 0;
        FStatus = 0;
        FTimeUs = 0;
    }
}TLIN, *PLIN;

// FlexRay Frame Type ============================================
typedef struct _TFlexRay {
    u8  FIdxChn;               // channel index starting from 0
    u8  FChannelMask;          // 0: reserved, 1: A, 2: B, 3: AB
    u8  FDir;                  // 0: Rx, 1: Tx, 2: Tx Request
    u8  FPayloadLength;        // payload length in bytes
    u8  FActualPayloadLength;  // actual data bytes
    u8  FCycleNumber;          // cycle number: 0~63
    u8  FCCType;               // 0 = Architecture independent, 1 = Invalid CC type, 2 = Cyclone I, 3 = BUSDOCTOR, 4 = Cyclone II, 5 = Vector VN interface, 6 = VN - Sync - Pulse(only in Status Event, for debugging purposes only)
    u8  FFrameType;            // 0 = raw flexray frame, 1 = error event, 2 = status, 3 = start cycle
    u16 FHeaderCRCA;           // header crc A
    u16 FHeaderCRCB;           // header crc B
    u16 FFrameStateInfo;       // bit 0~15, error flags
    u16 FSlotId;               // static seg: 0~1023
    u32 FFrameFlags;           // bit 0~22
                               // 0 1 = Null frame.
                               // 1 1 = Data segment contains valid data
                               // 2 1 = Sync bit
                               // 3 1 = Startup flag
                               // 4 1 = Payload preamble bit
                               // 5 1 = Reserved bit
                               // 6 1 = Error flag(error frame or invalid frame)
                               // 7 Reserved
                               // 15 1 = Async.monitoring has generated this event
                               // 16 1 = Event is a PDU
                               // 17 Valid for PDUs only.The bit is set if the PDU is valid(either if the PDU has no update bit, or the update bit for the PDU was set in the received frame).
                               // 18 Reserved
                               // 19 1 = Raw frame(only valid if PDUs are used in the configuration).A raw frame may contain PDUs in its payload
                               // 20 1 = Dynamic segment    0 = Static segment
                               // 21 This flag is only valid for frames and not for PDUs.    1 = The PDUs in the payload of this frame are logged in separate logging entries. 0 = The PDUs in the payload of this frame must be extracted out of this frame.The logging file does not contain separate  // PDU - entries.
                               // 22 Valid for PDUs only.The bit is set if the PDU has an update bit
    u32 FFrameCRC;             // frame crc
    u64 FReserved1;            // 8 reserved bytes
    u64 FReserved2;            // 8 reserved bytes
    u64 FTimeUs;               // timestamp in us
    u8  FData[254];            // 254 data bytes
    // is_tx -----------------------------------------------------
    bool get_is_tx(void){
        return FDir != 0;
    }
    void set_is_tx(const bool value){
        if (value) {
            FDir = 1;
        } else {
            FDir = 0;
        }
    }
    __declspec(property(get = get_is_tx, put = set_is_tx)) bool is_tx;
    // is_null ---------------------------------------------------
    bool get_is_null(void){
        return (FFrameFlags & ((u32)1 << 0)) != 0;
    }
    void set_is_null(const bool value){
        if (value) {
            FFrameFlags |= ((u32)1 << 0);
        } else {
            FFrameFlags &= ~((u32)1 << 0);
        }
    }
    __declspec(property(get = get_is_null, put = set_is_null)) bool is_null;
    // is_data ---------------------------------------------------
    bool get_is_data(void){
        return (FFrameFlags & ((u32)1 << 1)) != 0;
    }
    void set_is_data(const bool value){
        if (value) {
            FFrameFlags |= ((u32)1 << 1);
        } else {
            FFrameFlags &= ~((u32)1 << 1);
        }
    }
    __declspec(property(get = get_is_data, put = set_is_data)) bool is_data;
    // is_sync ---------------------------------------------------
    bool get_is_sync(void){
        return (FFrameFlags & ((u32)1 << 2)) != 0;
    }
    void set_is_sync(const bool value){
        if (value) {
            FFrameFlags |= ((u32)1 << 2);
        } else {
            FFrameFlags &= ~((u32)1 << 2);
        }
    }
    __declspec(property(get = get_is_sync, put = set_is_sync)) bool is_sync;
    // is_startup ------------------------------------------------
    bool get_is_startup(void){
        return (FFrameFlags & ((u32)1 << 3)) != 0;
    }
    void set_is_startup(const bool value){
        if (value) {
            FFrameFlags |= ((u32)1 << 3);
        } else {
            FFrameFlags &= ~((u32)1 << 3);
        }
    }
    __declspec(property(get = get_is_startup, put = set_is_startup)) bool is_startup;
    // is_pp -----------------------------------------------------
    bool get_is_pp(void){
        return (FFrameFlags & ((u32)1 << 4)) != 0;
    }
    void set_is_pp(const bool value){
        if (value) {
            FFrameFlags |= ((u32)1 << 4);
        } else {
            FFrameFlags &= ~((u32)1 << 4);
        }
    }
    __declspec(property(get = get_is_pp, put = set_is_pp)) bool is_pp;
    // is_err ----------------------------------------------------
    bool get_is_err(void){
        return (FFrameFlags & ((u32)1 << 6)) != 0;
    }
    void set_is_err(const bool value){
        if (value) {
            FFrameFlags |= ((u32)1 << 6);
        } else {
            FFrameFlags &= ~((u32)1 << 6);
        }
    }
    __declspec(property(get = get_is_err, put = set_is_err)) bool is_err;
    // is_static_segment -----------------------------------------
    bool get_is_static_segment(void){
        return (FFrameFlags & ((u32)1 << 20)) != 0;
    }
    void set_is_static_segment(const bool value){
        if (value) {
            FFrameFlags |= ((u32)1 << 20);
        } else {
            FFrameFlags &= ~((u32)1 << 20);
        }
    }
    __declspec(property(get = get_is_static_segment, put = set_is_static_segment)) bool is_static_segment;
    // initialize with slot id -----------------------------------
    void init_w_slot_id(const s32 ASlotId, const s32 ADLC) {
        FIdxChn = 0;
        FChannelMask = 1;
        FDir = 0;
        FPayloadLength = ADLC;
        FActualPayloadLength = ADLC;
        FCycleNumber = 0;
        FCCType = 5;
        FFrameType = 0;
        FHeaderCRCA = 0;
        FHeaderCRCB = 0;
        FFrameStateInfo = 0;
        FFrameFlags = 1 << 1; // data frame
        FSlotId = ASlotId;
        FFrameCRC = 0;
        FReserved1 = 0;
        FReserved2 = 0;
        FTimeUs = 0;
        for (u32 i = 0; i < 254; i++) {
            FData[i] = 0;
        }
    }
    // load data bytes -------------------------------------------
    void load_data(u8* a) {
        for (u32 i = 0; i < 254; i++) {
            FData[i] = *a++;
        }
    }
} TFlexRay, *PFlexRay;

// Ethernet Frame Type
typedef struct _TEthernetHeader{ // size = 24 B
    u8  FIdxChn;                 // Application channel index starting from 0 = Network index
    u8  FIdxSwitch;              // Network's switch index
    u8  FIdxPort;                // Network's switch's port index, 0~127: measurement port, 128~255: virtual port
    u8  FConfig;                 // 0-1: 0 = Rx, 1 = Tx, 2 = TxRq
                                 // 2: crc status, for tx, 0: crc is included in data, 1: crc is not included in data
                                 //                for rx, 0: crc is ok, 1: crc is not ok
                                 // 3: tx done type, 0: only report timestamp, 1: report full info(header+frame)
    u16 FEthernetPayloadLength;  // Length of Ethernet payload data in bytes. Max 1582 (1600 packet length - 18 header) data bytes per frame
    u16 FReserved;               // reserved for padding
    u64 FTimeUs;                 // timestamp in us
    pu8 FEthernetDataAddr;       // Ethernet data (from destination MAC to ending of payload)
#ifndef _WIN64
    u32 FPadding;                // to be compatible with x64
#endif
    u8 get_Payloads(const int index) {
        return *(ethernet_payload_addr() + index);
    }
    void set_Payloads(const int index, const u8 value) {
        *(ethernet_payload_addr() + index) = value;
    }
    __declspec(property(get = get_Payloads, put = set_Payloads)) u8 Payloads[];
    inline bool get_tx() {
        return (FConfig & 0x1) != 0;
    }
    inline void set_tx(bool a) {
        if (a) {
            FConfig |= 1;
        } else {
            FConfig &= 0xFC;
        }
    }
    void reset_data_pointer(){
        FEthernetDataAddr = actual_data_pointer();
    }
    void init(const u16 APayloadLength){
        FIdxChn = 0;
        FIdxSwitch = 0;
        FIdxPort = 0;
        FConfig = 0;
        FEthernetPayloadLength = APayloadLength;
        FReserved = 0;
        FTimeUs = 0;
        reset_data_pointer();
#ifndef _WIN64
        FPadding = 0;
#endif
        s32 i;
        pu8 p = FEthernetDataAddr;
        s32 n = MIN(1612 - 14, APayloadLength);
        n += 14;
        for (i=0; i<n; i++){
            *p++ = 0;
        }
        *(pu16)(ethernet_type_addr()) = 0x00; // IPV4 = SWAP_BYTES(0x0800)
        p = destination_mac_addr();
        for (i=0; i<6; i++){
            *p++ = 0xFF;
        }
    }
    bool is_virtual(){
        return FIdxPort >= 128;
    }
    bool is_ip_frame(){
        return ethernet_type() == 0x0800;
    }
    bool is_tcp_frame(){
        u16 o;
        has_vlans(&o);
        return (ethernet_type() == 0x0800) && (0x06 == *(FEthernetDataAddr + 0x17 + o));
    }
    bool is_udp_frame(){
        u16 o;
        has_vlans(&o);
        return (ethernet_type() == 0x0800) && (0x11 == *(FEthernetDataAddr + 0x17 + o));
    }
    pu16 first_vlan_addr(){
        return (pu16)(actual_data_pointer() + 6 + 6);
    }
    bool has_vlans(pu16 AOffsetBytes){
        *AOffsetBytes = 0;
        while (*(pu16)(actual_data_pointer() + 6 + 6 + (*AOffsetBytes)) == 0x0081){
            *AOffsetBytes = *AOffsetBytes + 4;
        }
        return *AOffsetBytes > 0;
    }
    pu8 actual_data_pointer() {
        return &FIdxChn + sizeof(_TEthernetHeader);
    }
    s32 total_ethernet_packet_length() {
        u16 o;
        has_vlans(&o);
        return sizeof(_TEthernetHeader) + 6 + 6 + 2 + o + FEthernetPayloadLength;
    }
    s32 ethernet_data_length(){
        u16 o;
        has_vlans(&o);
        return FEthernetPayloadLength + 6 + 6 + o + 2;
    }
    void set_ethernet_data_length(const u16 ALength) {
        u16 o;
        has_vlans(&o);
        o += 14;
        if (ALength > o){
            FEthernetPayloadLength = ALength - o;
        }
    }
    pu8 ethernet_payload_addr() {
        u16 o;
        has_vlans(&o);
        return FEthernetDataAddr + 6 + 6 + 2 + o;
    }
    pu8 destination_mac_addr() {
        return FEthernetDataAddr;
    }
    pu8 source_mac_addr() {
        return FEthernetDataAddr + 6;
    }
    pu8 destination_ip_addr(){
        if (!is_ip_frame()) return nullptr;
        u16 o;
        has_vlans(&o);
        return FEthernetDataAddr + 0x1E + o;
    }
    pu8 source_ip_addr(){
        if (!is_ip_frame()) return nullptr;
        u16 o;
        has_vlans(&o);
        return FEthernetDataAddr + 0x1A + o;
    }
    u16 destination_port_value(){
        if (!is_ip_frame()) return 0;
        u16 o;
        has_vlans(&o);
        o = *(u16*)(FEthernetDataAddr + 0x24 + o);
        return SWAP_BYTES(o);
    }
    u16 source_port_value(){
        if (!is_ip_frame()) return 0;
        u16 o;
        has_vlans(&o);
        o = *(u16*)(FEthernetDataAddr + 0x22 + o);
        return SWAP_BYTES(o);
    }
    pu16 ethernet_type_addr() {
        u16 o;
        has_vlans(&o);
        pu8 p = FEthernetDataAddr + 6 + 6 + o;
        return (pu16)(p);
    }
    u16 ethernet_type() {
        u16 t = *(pu16)(ethernet_type_addr());
        return SWAP_BYTES(t);
    }
    u16 get_ip_header_checksum(){
        u16 o;
        if (!is_ip_frame()) return 0;
        has_vlans(&o);
        o = *(pu16)(FEthernetDataAddr + 0x18 + o);
        return SWAP_BYTES(o);
    }
    void set_ip_header_checksum(const u16 AValue){
        u16 o;
        if (!is_ip_frame()) return;
        has_vlans(&o);
        *(pu16)(FEthernetDataAddr + 0x18 + o) = SWAP_BYTES(AValue);
    }
    void copy_payload(const pu8 ABuffer, const u16 ALength){
        u16 l = MIN(ALength, FEthernetPayloadLength);
        std::memcpy(ethernet_payload_addr(), ABuffer, l);
    }
    void set_ip_packet_payload_length(const u16 ALength){
        u16 o;
        if (!is_ip_frame()) return;
        has_vlans(&o);
        *(pu16)(FEthernetDataAddr + 16 + o) = SWAP_BYTES(ALength + 20);
    }
    u16 get_ip_packet_payload_length(){
        u16 o;
        if (!is_ip_frame()) return 0;
        has_vlans(&o);
        o = *(pu16)(FEthernetDataAddr + 16 + o);
        return SWAP_BYTES(o) - 20;
    }
    pu8 get_ip_packet_data_addr(){
        u16 o;
        if (!is_ip_frame()) return nullptr;
        has_vlans(&o);
        return FEthernetDataAddr + 0x0E + o;
    }
    pu8 get_ip_packet_payload_addr(){
        u16 o;
        if (!is_ip_frame()) return nullptr;
        has_vlans(&o);
        return FEthernetDataAddr + 0x22 + o;
    }
    void set_udp_payload_length(const u16 ALength){
        u16 o;
        if (!is_udp_frame()) return;
        has_vlans(&o);
        *(pu16)(FEthernetDataAddr + 0x26 + o) = SWAP_BYTES(ALength + 8/*header length*/);
    }
    u16 get_udp_payload_length(){
        u16 o;
        if (!is_udp_frame()) return 0;
        has_vlans(&o);
        o = *(pu16)(FEthernetDataAddr + 0x26 + o);
        return SWAP_BYTES(o) - 8/*header length*/;
    }
    pu8 get_ip_address_destination_addr(){
        u16 o;
        if (!is_ip_frame()) return 0;
        has_vlans(&o);
        return FEthernetDataAddr + 0x1E + o;
    }
    pu8 get_ip_address_source_addr(){
        u16 o;
        if (!is_ip_frame()) return 0;
        has_vlans(&o);
        return FEthernetDataAddr + 0x1A + o;
    }
    u16 get_udp_port_destination(){
        u16 o;
        if (!is_udp_frame()) return 0;
        has_vlans(&o);
        o = *(pu16)(FEthernetDataAddr + 0x24 + o);
        return SWAP_BYTES(o);
    }
    u16 get_udp_port_source(){
        u16 o;
        if (!is_udp_frame()) return 0;
        has_vlans(&o);
        o = *(pu16)(FEthernetDataAddr + 0x22 + o);
        return SWAP_BYTES(o);
    }
    void set_udp_port_destination(const u16 AValue){
        u16 o;
        if (!is_udp_frame()) return;
        has_vlans(&o);
        *(pu16)(FEthernetDataAddr + 0x24 + o) = SWAP_BYTES(AValue);
    }
    void set_udp_port_source(const u16 AValue){
        u16 o;
        if (!is_udp_frame()) return;
        has_vlans(&o);
        *(pu16)(FEthernetDataAddr + 0x22 + o) = SWAP_BYTES(AValue);
    }
    bool check_udp_fragment(pu16 AId, pu16 AOffset){
        u16 o;
        bool r;
        has_vlans(&o);
        r = (0x40 & *(FEthernetDataAddr + 0x14 + o)) == 0;
        if (r) {
            *AOffset = *(pu16)(FEthernetDataAddr + 0x14 + o);
            *AOffset = (SWAP_BYTES(*AOffset) & 0x1FFF) << 3;
            *AId = *(pu16)(FEthernetDataAddr + 0x12 + o);
            *AId = SWAP_BYTES(*AId);
        }
        return r;
    }
    pu8 get_udp_payload_addr(){
        u16 o, id, fo;
        if (!is_udp_frame()) return nullptr;        
        if (check_udp_fragment(&id, &fo)){
            if (fo > 0){
                return get_ip_packet_data_addr();
            }
        }
        has_vlans(&o);
        return FEthernetDataAddr + 0x2A + o;
    }
} TEthernetHeader, *PEthernetHeader;
typedef struct _TEthernetMAX {
    TEthernetHeader FHeader;
    u8 FBytes[1612];
    void reset_data_pointer(){
        FHeader.FEthernetDataAddr = FHeader.actual_data_pointer();
    }
} TEthernetMAX, *PEthernetMAX;

// FlexRay Cluster Parameters (size = 440)
typedef struct _TFlexRayClusterParameters {
    // general parameters
    char FShortName[GENERIC_STRING_MAX_LENGTH];
    char FLongName[GENERIC_STRING_MAX_LENGTH];
    char FDescription[GENERIC_STRING_MAX_LENGTH];
    char FSpeed[GENERIC_STRING_MAX_LENGTH];
    char FChannels[GENERIC_STRING_MAX_LENGTH];
    char FBitCountingPolicy[GENERIC_STRING_MAX_LENGTH];
    char FProtocol[GENERIC_STRING_MAX_LENGTH];
    char FProtocolVersion[GENERIC_STRING_MAX_LENGTH];
    char FMedium[GENERIC_STRING_MAX_LENGTH];
    int FIsHighLowBitOrder;
    int FMaxFrameLengthByte;
    int FNumberOfCycles;
    // cycle parameters
    int FCycle_us;
    double FBit_us;
    double FSampleClockPeriod_us;
    double FMacrotick_us;
    int FMacroPerCycle;
    int FNumberOfStaticSlots;
    int FStaticSlot_MT;
    int FActionPointOffset_MT;
    int FTSSTransmitter_gdBit;
    int FPayloadLengthStatic_WORD;
    int FNumberOfMiniSlots;
    int FMiniSlot_MT;
    int FMiniSlotActionPointOffset_MT;
    int FDynamicSlotIdlePhase_MiniSlots;
    int FSymbolWindow_MT;
    int FNIT_MT;
    int FSyncNodeMax;
    int FNetworkManagementVectorLength;
    // Wakeup and startup parameters
    int FListenNoise;
    int FColdStartAttempts;
    int FCASRxLowMax_gdBit;
    int FWakeupSymbolRxIdle_gdBit;
    int FWakeupSymbolRxLow_gdBit;
    int FWakeupSymbolRxWindow_gdBit;
    int FWakeupSymbolTxIdle_gdBit;
    int FWakeupSymbolTxLow_gdBit;
    double FMaxInitializationError_us;
    // clock correction parameters
    int FClusterDriftDamping_uT;
    int FOffsetCorrectionStart_MT;
    int FMaxWithoutClockCorrectionFatal;
    int FMaxWithoutClockCorrectionPassive;
} TFlexRayClusterParameters, *PFlexRayClusterParameters;

// FlexRay Controller Parameters (size = 212)
typedef struct _TFlexRayControllerParameters {
    // general parameters
    char FShortName[GENERIC_STRING_MAX_LENGTH];
    char FConnectedChannels[GENERIC_STRING_MAX_LENGTH];
    // cycle parameters
    int FMicroPerCycle_uT;
    int FMicroPerMacroNom_uT;
    double FMicroTick_us;
    int FSamplesPerMicrotick;
    // wakeup & startup parameters
    int FWakeupChannelA;
    int FWakeupChannelB;
    int FMaxDrift_uT;
    int FWakeupPattern;
    int FListenTimeout_uT;
    int FAcceptedStartupRange_uT;
    int FMacroInitialOffsetA_MT;
    int FMacroInitialOffsetB_MT;
    int FMicroInitialOffsetA_uT;
    int FMicroInitialOffsetB_uT;
    // clock correction parameters
    char FKeySlotUsage[GENERIC_STRING_MAX_LENGTH];
    int FKeySlotID;
    int FSingleSlotEnabled;
    int FClusterDriftDamping_uT;
    int FDocodingCorrection_uT;
    int FDelayCompensationA_uT;
    int FDelayCompensationB_uT;
    int FOffsetCorrectionOut_uT;
    int FExternRateCorrection_uT;
    int FRateCorrectionOut_uT;
    int FExternOffsetCorrection_uT;
    int FAllowHaltDueToClock;
    int FAllowPassivToActive;
    // latesttx
    int FLatestTx;
    int FMaxDynamicPayloadLength;
} TFlexRayControllerParameters, *PFlexRayControllerParameters;

// Generic definitions ===========================================
typedef void (__stdcall* TProcedure)(const void* AObj);
typedef void (__stdcall* TProcedureByIndex)(const void* AObj, const s32 AIndex);
typedef void (__stdcall* TProcedureSetInt)(const void* AObj, const s64 AValue);
typedef void (__stdcall* TProcedureSetIntByIndex)(const void* AObj, const s64 AValue, const s32 AIndex);
typedef s64 (__stdcall* TIntFunction)(const void* AObj);
typedef s64 (__stdcall* TIntFunctionByIndex)(const void* AObj, const s32 AIndex);
typedef void (__stdcall* TProcedureSetDouble)(const void* AObj, const double AValue);
typedef double (__stdcall* TDoubleFunction)(const void* AObj);
typedef void (__stdcall* TProcedureSetString)(const void* AObj, const char* AValue);
typedef char* (__stdcall* TStringFunction)(const void* AObj);
typedef void (__stdcall* TProcedureSetCAN)(const void* AObj, const PCAN AValue);
typedef TCAN (__stdcall* TTCANFunction)(const void* AObj);
typedef void (__stdcall* TProcedureSetCANFD)(const void* AObj, const PCANFD AValue);
typedef TCANFD (__stdcall* TTCANFDFunction)(const void* AObj);
typedef void (__stdcall* TProcedureSetLIN)(const void* AObj, const PLIN AValue);
typedef TLIN (__stdcall* TTLINFunction)(const void* AObj);
typedef void(__stdcall* TWriteAPIDocumentFunc)(const void* AOpaque, const char* AName, const char* AGroup, const char* ADesc, const char* AExample, const s32 AParaCount);
typedef void(__stdcall* TWriteAPIParaFunc)(const void* AOpaque, const s32 AIdx, const char* AAPIName, const char* AParaName, const bool AIsConst, const char* AParaType, const char* ADesc);                            

// TSMaster variable =============================================
typedef struct _TMPVarInt {
    void* FObj;
    TIntFunction internal_get;
    TProcedureSetInt internal_set;
    s64 get(void) {
        return internal_get(FObj);
    }
    void set(const s64 AValue) {
        internal_set(FObj, AValue);
    }
}TMPVarInt;

typedef struct _TMPVarDouble {
    void* FObj;
    TDoubleFunction internal_get;
    TProcedureSetDouble internal_set;
    double get(void) {
        return internal_get(FObj);
    }
    void set(const double AValue) {
        internal_set(FObj, AValue);
    }
}TMPVarDouble;

typedef struct _TMPVarString {
    void* FObj;
    TStringFunction internal_get;
    TProcedureSetString internal_set;
    char* get(void) {
        return internal_get(FObj);
    }
    void set(const char* AValue) {
        internal_set(FObj, AValue);
    }
}TMPVarString;

typedef struct _TMPVarCAN {
    void* FObj;
    TTCANFunction internal_get;
    TProcedureSetCAN internal_set;
    TCAN get(void) {
        return internal_get(FObj);
    }
    void set(TCAN AValue) {
        internal_set(FObj, &AValue);
    }
}TMPVarCAN;

typedef struct _TMPVarCANFD {
    void* FObj;
    TTCANFDFunction internal_get;
    TProcedureSetCANFD internal_set;
    TCANFD get(void) {
        return internal_get(FObj);
    }
    void set(TCANFD AValue) {
        internal_set(FObj, &AValue);
    }
}TMPVarCANFD;

typedef struct _TMPVarLIN {
    void* FObj;
    TTLINFunction internal_get;
    TProcedureSetLIN internal_set;
    TLIN get(void) {
        return internal_get(FObj);
    }
    void set(TLIN AValue) {
        internal_set(FObj, &AValue);
    }
}TMPVarLIN;

// TSMaster timer ================================================
// legacy timer before 2025-07-26
typedef struct _TMPTimerMS {
    void* FObj;
    TProcedure internal_start;
    TProcedure internal_stop;
    TProcedureSetInt internal_set_interval;
    TIntFunction internal_get_interval;
    void start(void) {
        internal_start(FObj);
    }
    void stop(void) {
        internal_stop(FObj);
    }
    void set_interval(const s64 AInterval) {
        internal_set_interval(FObj, AInterval);
    }
    s64 get_interval(void) {
        return internal_get_interval(FObj);
    }
}TMPTimerMS, *PMPTimerMS;

// timer with singleshot since 2025-07-26
typedef struct _TMPTimerMSUpg1 {
    void* FObj;
    TProcedure internal_start;
    TProcedure internal_stop;
    TProcedureSetInt internal_set_interval;
    TIntFunction internal_get_interval;
    TProcedure internal_start_singleshot;
    native_int FDummy[3]; 
    void start(void) {
        internal_start(FObj);
    }
    void stop(void) {
        internal_stop(FObj);
    }
    void set_interval(const s64 AInterval) {
        internal_set_interval(FObj, AInterval);
    }
    s64 get_interval(void) {
        return internal_get_interval(FObj);
    }
    void start_singleshot(void) {
        internal_start_singleshot(FObj);
    }
}TMPTimerMSUpg1, *PMPTimerMSUpg1;

// timer group since 2025-09-05
typedef PMPTimerMSUpg1 (__stdcall* TMpGetTimerByIndex)(const void* AObj, const s32 AIndex);
typedef struct _TMPTimerMsGroup {
    void* FObj;
    TIntFunction internal_get_count;
    TProcedureByIndex internal_start;
    TProcedureByIndex internal_stop;
    TProcedureByIndex internal_start_singleshot;
    TProcedure internal_start_all;
    TProcedure internal_stop_all;
    TProcedure internal_start_all_singleshot;
    TProcedureSetIntByIndex internal_set_interval;
    TIntFunctionByIndex internal_get_interval;
    TProcedureSetInt internal_set_all_interval;
    native_int FDummy[3];
    s32 get_count(void) {
        return internal_get_count(FObj);
    }
    void start_by_index(const s32 AIndex) {
        internal_start(FObj, AIndex);
    }
    void stop_by_index(const s32 AIndex) {
        internal_stop(FObj, AIndex);
    }
    void start_singleshot_by_index(const s32 AIndex) {
        internal_start_singleshot(FObj, AIndex);
    }
    void start_all(void) {
        internal_start_all(FObj);
    }
    void stop_all(void) {
        internal_stop_all(FObj);
    }
    void start_all_singleshot(void) {
        internal_start_all_singleshot(FObj);
    }
    void set_interval_by_index(const s32 AIndex, const s64 AInterval) {
        internal_set_interval(FObj, AInterval, AIndex);
    }
    s64 get_interval_by_index(const s32 AIndex) {
        return internal_get_interval(FObj, AIndex);
    }
    void set_all_interval(const s64 AInterval) {
        internal_set_all_interval(FObj, AInterval);
    }
}TMPTimerMsGroup;

// TSMaster application definition ===============================
#define APP_DEVICE_NAME_LENGTH 32
typedef enum _TLIBBusToolDeviceType{
    BUS_UNKNOWN_TYPE           = 0, 
    TS_TCP_DEVICE              = 1, 
    XL_USB_DEVICE              = 2, 
    TS_USB_DEVICE              = 3, 
    PEAK_USB_DEVICE            = 4,
    KVASER_USB_DEVICE          = 5,
    ZLG_USB_DEVICE             = 6,
    ICS_USB_DEVICE             = 7,
    TS_TC1005_DEVICE           = 8,
    CANABLE_USB_DEVICE         = 9
} TLIBBusToolDeviceType;
typedef enum _TLIBApplicationChannelType{
    APP_CAN = 0,
    APP_LIN = 1,
    APP_FlexRay = 2,
    APP_Ethernet = 3,
    APP_AI = 4,
    APP_AO = 5,
    APP_DI = 6,
    APP_DO = 7,
    APP_GPS = 8,
    APP_DAP = 9,
    APP_A429 = 10
} TLIBApplicationChannelType;
typedef enum _TReplayPhase{rppInit = 0, rppReplaying, rppEnded} TReplayPhase;
typedef enum _TLIBCANBusStatistics{
    cbsBusLoad = 0, cbsPeakLoad, cbsFpsStdData, cbsAllStdData,
    cbsFpsExtData, cbsAllExtData, cbsFpsStdRemote, cbsAllStdRemote,
    cbsFpsExtRemote, cbsAllExtRemote, cbsFpsErrorFrame, cbsAllErrorFrame    
} TLIBCANBusStatistics;
typedef struct _TLIBHWInfo{
    TLIBBusToolDeviceType FDeviceType;
    s32 FDeviceIndex;
    char FVendorName[32];
    char FDeviceName[32];
    char FSerialString[64];
} TLIBHWInfo, *PLIBHWInfo;
struct _TLIBTSMapping {
    char                       FAppName[APP_DEVICE_NAME_LENGTH];
    s32                        FAppChannelIndex;
    TLIBApplicationChannelType FAppChannelType;
    TLIBBusToolDeviceType      FHWDeviceType;
    s32                        FHWIndex;
    s32                        FHWChannelIndex;
    s32                        FHWDeviceSubType;
    char                       FHWDeviceName[APP_DEVICE_NAME_LENGTH];
    bool                       FMappingDisabled;
    void init(void) {
        s32 i;
        for (i = 0; i < APP_DEVICE_NAME_LENGTH; i++) {
            FAppName[i] = 0;
            FHWDeviceName[i] = 0;
        }
        FAppChannelIndex = 0;
        FAppChannelType = APP_CAN;
        FHWDeviceType = TS_USB_DEVICE;
        FHWIndex = 0;
        FHWChannelIndex = 0;
        FHWDeviceSubType = 0;
        FMappingDisabled = false;
    }
};
typedef struct _TLIBTSMapping TLIBTSMapping, * PLIBTSMapping;
// system var def
typedef enum _TLIBSystemVarType{
  svtInt32 = 0, svtUInt32, svtInt64, svtUInt64, svtUInt8Array,
  svtInt32Array, svtInt64Array, svtDouble, svtDoubleArray, svtString
} TLIBSystemVarType, *PLIBSystemVarType;
typedef struct {
    char              FName[APP_DEVICE_NAME_LENGTH];
    char              FCategory[APP_DEVICE_NAME_LENGTH];
    char              FComment[APP_DEVICE_NAME_LENGTH];
    TLIBSystemVarType FDataType;
    bool              FIsReadOnly;
    double            FValueMin;
    double            FValueMax;
    char              FUnit[APP_DEVICE_NAME_LENGTH];
} TLIBSystemVarDef, *PLIBSystemVarDef;
typedef enum _TCANFDControllerType{fdtCAN = 0, fdtISOCANFD = 1, fdtNonISOCANFD = 2} TCANFDControllerType;
typedef enum _TCANFDControllerMode{fdmNormal = 0, fdmACKOff = 1, fdmRestricted = 2, fdmInternalLoopback = 3, fdmExternalLoopback = 4, fdmSelfACK = 5} TCANFDControllerMode;
// log def
typedef enum _TLIBOnlineReplayTimingMode{ortImmediately = 0, ortAsLog = 1, ortDelayed = 2} TLIBOnlineReplayTimingMode;
typedef enum _TLIBOnlineReplayStatus{orsNotStarted = 0, orsRunning = 1, orsPaused = 2, orsCompleted = 3, orsTerminated = 4} TLIBOnlineReplayStatus;
typedef enum _TSupportedBLFObjType {sotCAN = 0, sotLIN = 1, sotCANFD = 2, sotRealtimeComment = 3, sotSystemVar = 4, sotFlexRay = 5, sotEthernet = 6} TSupportedBLFObjType;
// database utilities
#define DATABASE_STR_LEN 512
// CAN signal record, size = 26
typedef struct _TCANSignal{
    u8     FCANSgnType; // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
    bool   FIsIntel;
    s32    FStartBit;
    s32    FLength;    
    double FFactor;
    double FOffset;    
} TCANSignal, *PCANSignal;
// LIN signal record, size = 26
typedef struct _TLINSignal{
    u8     FLINSgnType; // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
    bool   FIsIntel;
    s32    FStartBit;
    s32    FLength;    
    double FFactor;
    double FOffset;    
} TLINSignal, *PLINSignal;
// FlexRay signal record, size = 32
typedef struct _TFlexRaySignal{
    u8     FFRSgnType;   // 0 - Unsigned, 1 - Signed, 2 - Single 32, 3 - Double 64
    u8     FCompuMethod; // 0 - Identical, 1 - Linear, 2 - Scale Linear, 3 - TextTable, 4 - TABNoIntp, 5 - Formula
    u8     FReserved;
    bool   FIsIntel;
    s32    FStartBit;
    s32    FUpdateBit;
    s32    FLength;
    double FFactor;
    double FOffset;
    s32    FActualStartBit;
    s32    FActualUpdateBit;
} TFlexRaySignal, *PFlexRaySignal;
#define CANMsgDecl(typ, name, chn, prop, dlc, id) const typ name = {{chn, prop, MIN(8, dlc), 0, id, 0, {0}}};
#define CANFDMsgDecl(typ, name, chn, prop, dlc, id) const typ name = {{chn, prop, MIN(15, dlc), 1, id, 0, {0}}};
#define FlexRayFrameDecl(typ, name, chn, chnmask, prop, dlc, cycle, slot) const typ name = {{chn, chnmask, 0, MIN(254, dlc), MIN(254, dlc), cycle, 5, 0, 0, 0, 0, slot, prop, 0, 0, 0, 0, {0}}};
#define LINMsgDecl(typ, name, chn, prop, dlc, id) const typ name = {{chn, 0, prop, MIN(8, dlc), id, 0, 0, 0, {0}}};
#define CANSgnDecl(name, typ, isIntel, startBit, len, factor, offset) const TCANSignal name = {typ, isIntel, startBit, len, factor, offset};
#define LINSgnDecl(name, typ, isIntel, startBit, len, factor, offset) const TLINSignal name = {typ, isIntel, startBit, len, factor, offset};
#define FlexRaySgnDecl(name, typ, isIntel, compuMethod, startBit, updateBit, len, factor, offset, actualStartBit, actualUpdateBit) const TFlexRaySignal name = {typ, compuMethod, 0, isIntel, startBit, updateBit, len, factor, offset, actualStartBit, actualUpdateBit};
typedef enum _TSignalType {stCANSignal, stLINSignal, stSystemVar, stFlexRay, stEthernet} TSignalType;
typedef enum _TSignalCheckKind {sckAlways, sckAppear, sckStatistics, sckRisingEdge, sckFallingEdge, sckMonotonyRising, sckMonotonyFalling, sckFollow, sckJump, sckNoChange, sckBaselineFluctuation = 10} TSignalCheckKind;
typedef enum _TSignalStatisticsKind {sskMin, sskMax, sskAverage, sskStdDeviation} TSignalStatisticsKind;
typedef enum _TLIBRBSInitValueOptions{rivUseDB = 0, rivUseLast, rivUse0} TLIBRBSInitValueOptions;
typedef enum _TSymbolMappingDirection{smdBiDirection = 0, smdSgnToSysVar, smdSysVarToSgn} TSymbolMappingDirection;
typedef void(__stdcall* TProgressCallback)(const void* AObj, const double AProgress100);
typedef bool(__stdcall* TCheckResultCallback)(void);
// TDBProperties for database properties, size = 1056
typedef struct _TDBProperties {
    s32 FDBIndex;
    s32 FSignalCount;
    s32 FFrameCount;
    s32 FECUCount;
    u64 FSupportedChannelMask;
    char FName[DATABASE_STR_LEN];
    char FComment[DATABASE_STR_LEN];
    u32  FFlags;
    u32  FDBId;
} TDBProperties, *PDBProperties;
// TDBECUProperties for database ECU properties, size = 1040
typedef struct _TDBECUProperties {
    s32 FDBIndex;
    s32 FECUIndex;
    s32 FTxFrameCount;
    s32 FRxFrameCount;
    char FName[DATABASE_STR_LEN];
    char FComment[DATABASE_STR_LEN];
} TDBECUProperties, *PDBECUProperties;
// TDBFrameProperties for database Frame properties, size = 1092
typedef struct _TDBFrameProperties {
    s32 FDBIndex;
    s32 FECUIndex;
    s32 FFrameIndex;
    u8  FIsTx;    
    u8  FReserved1;
    u16 FCycleTimeMs;
    TSignalType FFrameType;
    // CAN
    u8  FCANIsDataFrame;
    u8  FCANIsStdFrame;
    u8  FCANIsEdl;
    u8  FCANIsBrs;
    s32 FCANIdentifier;
    s32 FCANDLC;
    s32 FCANDataBytes;
    // LIN
    s32 FLINIdentifier;
    s32 FLINDLC;
    // FlexRay
    u8  FFRChannelMask;
    u8  FFRBaseCycle;
    u8  FFRCycleRepetition;
    u8  FFRIsStartupFrame;
    u16 FFRSlotId;  
    u16 FFRDLC;
    u64 FFRCycleMask;
    s32 FPDUCount;
    s32 FSignalCount;
    char FName[DATABASE_STR_LEN];
    char FComment[DATABASE_STR_LEN];
} TDBFrameProperties, *PDBFrameProperties;
// TDBPDUProperties for database signal properties, size = 1052
typedef struct _TDBPDUProperties {
    s32 FDBIndex;
    s32 FECUIndex;
    s32 FFrameIndex;
    s32 FPDUIndex;
    u8 FIsTx;
    u8 FReserved1;
    u16 FCycleTimeMs;
    TSignalType FPDUType;
    s32 FSignalCount;
    char FName[DATABASE_STR_LEN];
    char FComment[DATABASE_STR_LEN];
 } TDBPDUProperties, *PDBPDUProperties;
// TDBSignalProperties for database signal properties, size = 1148
typedef struct _TDBSignalProperties {
    s32 FDBIndex;
    s32 FECUIndex;
    s32 FFrameIndex;
    s32 FPDUIndex;
    s32 FSignalIndex;
    u8  FIsTx;    
    u8  FReserved1;
    u8  FReserved2;
    u8  FReserved3;
    TSignalType    FSignalType;    
    TCANSignal     FCANSignal;
    TLINSignal     FLINSignal;
    TFlexRaySignal FFlexRaySignal;
    s32            FParentFrameId;
    double         FInitValue;
    char FName[DATABASE_STR_LEN];
    char FComment[DATABASE_STR_LEN];
} TDBSignalProperties, *PDBSignalProperties;
// Realtime comment
typedef struct _realtime_comment_t {
    s64 FTimeUs;
    s32 FEventType;
    u32 FCapacity;
    char* FComment;
} Trealtime_comment_t, *Prealtime_comment_t;
// callbacks
typedef void(__cdecl* TCProcedure)(void); 
typedef void(__stdcall* TOnRpcData)(const pu8 AAddr, const native_int ASize);
typedef void (__stdcall* TOnAutoSARE2ECanEvt)(const PCANFD ACAN, const u32 ADataId, pu64 AValue);
typedef void (__stdcall* TOnUSBPlugEvent)(const char* AVidPid, const char* ASerial);
// Sys Var
typedef void(__stdcall* TOnSysVarChange)(const char* ACompleteName);
// IP
typedef void(__stdcall* TOnIoIPData)(pu8 APointer, s32 ASize);
typedef void(__stdcall* TOnIoIPConnection)(const char* AIPAddress, const s32 APort);
typedef enum _TUDPFragmentProcessStatus {ufpsNotFragment, ufpsInvalid, ufpsProcessing, ufpsDone} TUDPFragmentProcessStatus, *PUDPFragmentProcessStatus;
// PDU
typedef void(__stdcall* TOnAutoSARPDUQueueEvent)(const s32 AChnIdx, const char* APDUName, const u64 ATimestamp, const u8 AIsTx, const u32 AID, const u32 ADataLength, const pu8 AData);
typedef s32(__stdcall* TOnAutoSARPDUPreTxEvent)(const s32 AChnIdx, const char* APDUName, const u32 AID, const u32 ASrcDataLength, const u32 ASrcSecuredDataLength, const pu8 ASrcData);
typedef void(__stdcall* TOnSignalEvent)(const char* ASignalName, const s64 ARawValue, const double APhyValue);
typedef void(__stdcall* TOnSystemVarPreReadEvent)(const char* ASystemVarName, const s32 ADataType);
// Automation Module - Graphic Program
typedef enum _TAutomationModuleRunningState {amrsNotRun, amrsPrepareRun, amrsRunning, amrsPaused, amrsStepping, amrsFinished} TAutomationModuleRunningState, *PAutomationModuleRunningState;
typedef enum _TLIBAutomationSignalType {lastCANSignal, lastLINSignal, lastSysVar, lastLocalVar, lastConst, lastFlexRaySignal, lastImmediateValue} TLIBAutomationSignalType, *PLIBAutomationSignalType;
typedef enum _TSignalTesterFailReason {
    tfrNoError = 0,
    tfrCheckSignalNotExistsInDB,
    tfrMinBiggerThanMax,
    tfrStartTimeBiggerThanEndTime,
    tfrTriggerMinBiggerThanMax,
    tfrSignalCountIs0,
    tfrFollowSignalNotExistsInDB,
    tfrTriggerSignalNotExistsInDB,
    tfrSignalFollowViolation,
    tfrSignalMonotonyRisingViolation,
    tfrSignalMonotonyFallingViolation,
    tfrSignalNoChangeViolation,
    tfrSignalValueOutOfRange,
    tfrCANSignalNotExists,
    tfrLINSignalNotExists,
    tfrFlexRaySignalNotExists,
    tfrSystemVarNotExists,
    tfrSignalTesterStartFailedDueToInvalidConf,
    tfrSignalValueNotExists,
    tfrStatisticsCheckViolation,
    tfrTriggerValueNotExists,
    tfrFollowValueNotExists,
    tfrTriggerValueNeverInRange,
    tfrTimeRangeNotTouched,
    tfrRisingNotDetected,
    tfrFallingNotDetected,
    tfrNotAppeared,
    tfrJumpNotDetected = 27,
    tfrBaselineFluctuationSignalCountInvalid = 28,
    tfrBaselineFluctuationSignalTypeNotSupported = 29,
    tfrBaselineFluctuationStartMissed = 30,
    tfrBaselineFluctuationNotCaptured = 31,
    tfrBaselineFluctuationSampleInvalid = 32,
    tfrBaselineFluctuationRangeOverflow = 33,
    tfrBaselineFluctuationBelowRange = 34,
    tfrBaselineFluctuationAboveRange = 35
} TSignalTesterFailReason, *PSignalTesterFailReason;
typedef enum _TSignalTesterLifecycle {
    stlNotStarted = 0,
    stlTesting = 1,
    stlInterrupted = 2,
    stlCompleted = 3
} TSignalTesterLifecycle, *PSignalTesterLifecycle;
typedef enum _TSignalTesterTestResult {
    sttrNotTested = 0,
    sttrFailed = 1,
    sttrSucceeded = 2
} TSignalTesterTestResult, *PSignalTesterTestResult;
typedef struct _TSignalTesterItemState {
    s32 Lifecycle;
    s32 TestResult;
    s32 FailReason;
    s64 EventTimeUs;
} TSignalTesterItemState, *PSignalTesterItemState;
typedef struct _TSignalTesterState {
    s32 Lifecycle;
    s32 TestResult;
    s32 TotalCount;
    s32 NotStartedCount;
    s32 TestingCount;
    s32 InterruptedCount;
    s32 CompletedCount;
    s32 NotTestedCount;
    s32 FailedCount;
    s32 SucceededCount;
} TSignalTesterState, *PSignalTesterState;
typedef enum _TLIBMPFuncSource {lmfsSystemFunc, lmfsMPLib, lmfsInternal} TLIBMPFuncSource;
typedef enum _TLIBSimVarType {lvtInteger, lvtDouble, lvtString, lvtCANMsg, lvtCANFDMsg, lvtLINMsg} TLIBSimVarType;
typedef TLIBSimVarType* PLIBSimVarType;
// stim
typedef enum _TSTIMSignalStatus {sssStopped, sssRunning, sssPaused} TSTIMSignalStatus, *PSTIMSignalStatus;
// UI Panel
typedef enum _TLIBPanelSignalType {pstNone, pstCANSignal, pstLINSignal, pstSystemVar, pstFlexRaySignal, pstAPICall} TLIBPanelSignalType, *PLIBPanelSignalType;
typedef enum _TLIBPanelControlType {
    pctText,             // Text
    pctImage,            // Image
    pctGroupBox,         // Group Box
    pctPanel,            // Container
    pctPathButton,       // Path Button
    pctCheckBox,         // Check Box
    pctTrackBar,         // Track Bar
    pctScrollBar,        // Scroll Bar
    pctInputOutputBox,   // Input Output Box
    pctImageButton,      // Image Button
    pctSelector,         // Selector
    pctButton,           // Button
    pctProgressBar,      // Progress Bar
    pctRadioButton,      // Radio Button
    pctStartStopButton,  // Start Stop Button
    pctSwitch,           // Switch
    pctLED,              // LED
    pctPageControl,      // Page Control
    pctGauge,            // Gauge
    pctGraphics,         // Graphics
    pctPie,              // Pie
    pctRelationChart,    // Relation Chart
    pctMemo,             // Memo
    pctScrollBox,        // Scroll Box
} TLIBPanelControlType, *PLIBPanelControlType;

// =========================== DDS ===========================
typedef s32(__stdcall* Tdds_pre_deserialize_callback)(const u32 idxChn,
   const char* typeName, const char* topicName, const u8* oriData, const u32 oriLength, u8* newData, u32* newLength);
                                                                                
typedef s32(__stdcall* Tdds_after_serialize_callback)(const u32 idxChn,
   const char* typeName, const char* topicName, const u8* oriData, const u32 oriLength, u8* newData, u32* newLength);

// ========================= Metric ==========================
typedef struct _TTSMetricIntegerSnapshot {
    u64 FCount;
    s64 FMinValue;
    s64 FMaxValue;
    s64 FCurrValue;
    double FMean;
    double FStdDev;
    s64 FModifyTimestamp;
    s64 FMinEventTimestamp;
    s64 FMaxEventTimestamp;
} TTSMetricIntegerSnapshot, *PTSMetricIntegerSnapshot;

// =========================== APP ===========================
typedef s32 (__stdcall* TTSAppSetCurrentApplication)(const char* AAppName);
typedef s32 (__stdcall* TTSAppGetCurrentApplication)(char** AAppName);
typedef s32 (__stdcall* TTSAppDelApplication)(const char* AAppName);
typedef s32 (__stdcall* TTSAppAddApplication)(const char* AAppName);
typedef s32 (__stdcall* TTSAppGetApplicationList)(char** AAppNameList);
typedef s32 (__stdcall* TTSAppSetCANChannelCount)(const s32 ACount);
typedef s32 (__stdcall* TTSAppSetLINChannelCount)(const s32 ACount);
typedef s32 (__stdcall* TTSAppGetCANChannelCount)(const ps32 ACount);
typedef s32 (__stdcall* TTSAppGetLINChannelCount)(const ps32 ACount);
typedef s32 (__stdcall* TTSAppGetFlexRayChannelCount)(const ps32 ACount);
typedef s32 (__stdcall* TTSAppSetFlexRayChannelCount)(const s32 ACount);
typedef s32 (__stdcall* TTSAppSetMapping)(const PLIBTSMapping AMapping);
typedef s32 (__stdcall* TTSAppGetMapping)(const PLIBTSMapping AMapping);
typedef s32 (__stdcall* TTSAppDeleteMapping)(const PLIBTSMapping AMapping);
typedef s32 (__stdcall* TTSAppConnectApplication)(void);
typedef s32 (__stdcall* TTSAppDisconnectApplication)(const void* AObj);
typedef s32 (__stdcall* TTSAppIsConnected)(void);
typedef s32 (__stdcall* TTSAppLogger)(const char* AStr, const TLogLevel ALevel);
typedef s32 (__stdcall* TTSDebugLog)(const void* AObj, const char* AFile, const char* AFunc, const s32 ALine, const char* AStr, const TLogLevel ALevel);
typedef s32 (__stdcall* TTSAppSetTurboMode)(const bool AEnable);
typedef s32 (__stdcall* TTSAppGetTurboMode)(const bool* AEnable);
typedef s32 (__stdcall* TTSAppGetErrorDescription)(const s32 ACode, char** ADesc);
typedef s32 (__stdcall* TTSAppConfigureBaudrateCAN)(const s32 AIdxChn, const float ABaudrateKbps, const bool AListenOnly, const bool AInstallTermResistor120Ohm);
typedef s32 (__stdcall* TTSAppConfigureBaudrateCANFD)(const s32 AIdxChn, const float ABaudrateArbKbps, const float ABaudrateDataKbps, const TCANFDControllerType AControllerType, const TCANFDControllerMode AControllerMode, const bool AInstallTermResistor120Ohm);
typedef s32 (__stdcall* TTSAppTerminate)(const void* AObj);
typedef s32 (__stdcall* TTSWaitTime)(const void* AObj, const s32 ATimeMs, const char* AMsg);
typedef s32 (__stdcall* TTSCheckError)(const void* AObj, const s32 AErrorCode);
typedef s32 (__stdcall* TTSStartLog)(const void* AObj);
typedef s32 (__stdcall* TTSEndLog)(const void* AObj);
typedef s32 (__stdcall* TTSCheckTerminate)(const void* AObj);
typedef s32 (__stdcall* TTSGetTimestampUs)(s64* ATimestamp);
typedef s32 (__stdcall* TTSShowConfirmDialog)(const char* ATitle, const char* APrompt, const char* AImage, const s32 ATimeoutMs, const bool ADefaultOK);
typedef s32 (__stdcall* TTSPause)(void);
typedef s32 (__stdcall* TTSSetCheckFailedTerminate)(const void* AObj, const s32 AToTerminate);
typedef s32 (__stdcall* TTSAppSplitString)(const char* ASplitter, const char* AStr, char** AArray, const s32 ASingleStrSize, const s32 AArraySize, s32* AActualCount);
typedef s32 (__stdcall* TTSAppGetConfigurationFileName)(char** AFileName);
typedef s32 (__stdcall* TTSAppGetConfigurationFilePath)(char** AFilePath);
typedef s32 (__stdcall* TTSAppSetDefaultOutputDir)(const char* APath);
typedef s32 (__stdcall* TTSAppSaveScreenshot)(const char* AFormCaption, const char* AFilePath);
typedef s32 (__stdcall* TTSAppRunForm)(const char* AFormCaption);
typedef s32 (__stdcall* TTSAppStopForm)(const char* AFormCaption);
typedef s32 (__stdcall* TClearMeasurementForm)(const char* AFormCaption);
// system var def
typedef s32 (__stdcall* TTSAppGetSystemVarCount)(s32* AInternalCount, s32* AUserCount);
typedef s32 (__stdcall* TTSAppGetSystemVarDefByIndex)(const bool AIsUser, const s32 AIndex, const PLIBSystemVarDef AVarDef);
typedef s32 (__stdcall* TTSAppFindSystemVarDefByName)(const bool AIsUser, const char* ACompleteName, const PLIBSystemVarDef AVarDef);
typedef s32 (__stdcall* TTSAppCreateSystemVar)(const char* ACompleteName, const TLIBSystemVarType AType, const char* ADefaultValue, const char* AComment);
typedef s32 (__stdcall* TTSAppDeleteSystemVar)(const char* ACompleteName);
typedef s32 (__stdcall* TTSAppSetSystemVarUnit)(const char* ACompleteName, const char* AUnit);
typedef s32 (__stdcall* TTSAppSetSystemVarValueTable)(const char* ACompleteName, const char* ATable);
typedef s32 (__stdcall* TTSAppGetSystemVarAddress)(const char* ACompleteName, pnative_int AAddress);
typedef s32 (__stdcall* TTSAppSetSystemVarLogging)(const char* ACompleteName, const bool AIsLogging);
typedef s32 (__stdcall* TTSAppGetSystemVarLogging)(const char* ACompleteName, bool* AIsLogging);
typedef s32 (__stdcall* TTSAppLogSystemVarValue)(const void* AObj, const char* ACompleteName);
// system var get
typedef s32 (__stdcall* TTSAppGetSystemVarDouble)(const char* ACompleteName, double* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarInt32)(const char* ACompleteName, s32* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarUInt32)(const char* ACompleteName, u32* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarInt64)(const char* ACompleteName, s64* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarUInt64)(const char* ACompleteName, u64* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarUInt8Array)(const char* ACompleteName, const s32 AValueCapacity, s32* AVarCount, u8* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarInt32Array)(const char* ACompleteName, const s32 AValueCapacity, s32* AVarCount, s32* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarInt64Array)(const char* ACompleteName, const s32 AValueCapacity, s32* AVarCount, s64* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarDoubleArray)(const char* ACompleteName, const s32 AValueCapacity, s32* AVarCount, double* AValue);
typedef s32 (__stdcall* TTSAppGetSystemVarString)(const char* ACompleteName, const s32 AValueCapacity, char* AString);
typedef s32 (__stdcall* TTSAppGetSystemVarGerneric)(const char* ACompleteName, const s32 AValueCapacity, char* AValue);
typedef s32 (__stdcall* TTSWaitSystemVariable)(const char* ACompleteName, const char* AValue, const s32 ATimeoutMs);
// system var sync set
typedef s32 (__stdcall* TTSAppSetSystemVarDouble)(const char* ACompleteName, const double AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarInt32)(const char* ACompleteName, const s32 AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt32)(const char* ACompleteName, const u32 AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarInt64)(const char* ACompleteName, const s64 AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt64)(const char* ACompleteName, const u64 AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt8Array)(const char* ACompleteName, const s32 ACount, const u8* AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarInt32Array)(const char* ACompleteName, const s32 ACount, const s32* AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarInt64Array)(const char* ACompleteName, const s32 ACount, const s64* AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarDoubleArray)(const char* ACompleteName, const s32 ACount, const double* AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarString)(const char* ACompleteName, const char* AString);
typedef s32 (__stdcall* TTSAppSetSystemVarGeneric)(const char* ACompleteName, const char* AValue);
// system var async set
typedef s32 (__stdcall* TTSAppSetSystemVarDoubleAsync)(const char* ACompleteName, const double AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarInt32Async)(const char* ACompleteName, const s32 AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt32Async)(const char* ACompleteName, const u32 AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarInt64Async)(const char* ACompleteName, const s64 AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt64Async)(const char* ACompleteName, const u64 AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt8ArrayAsync)(const char* ACompleteName, const s32 ACount, const u8* AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarInt32ArrayAsync)(const char* ACompleteName, const s32 ACount, const s32* AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarInt64ArrayAsync)(const char* ACompleteName, const s32 ACount, const s64* AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarDoubleArrayAsync)(const char* ACompleteName, const s32 ACount, const double* AValue);
typedef s32 (__stdcall* TTSAppSetSystemVarStringAsync)(const char* ACompleteName, const char* AString);
typedef s32 (__stdcall* TTSAppSetSystemVarGenericAsync)(const char* ACompleteName, const char* AValue);
// system var utils
typedef s32 (__stdcall* TTSAppLogSystemVar)(const char* ACompleteName);
typedef s32 (__stdcall* TTSAppWaitSystemVarExistance)(const char* ACompleteName, const s32 ATimeOutMs);
typedef s32 (__stdcall* TTSAppWaitSystemVarDisappear)(const char* ACompleteName, const s32 ATimeOutMs);
// excel
typedef s32 (__stdcall* Texcel_load)(const char* AFileName, void** AObj);
typedef s32 (__stdcall* Texcel_get_sheet_count)(const void* AObj, s32* ACount);
typedef s32 (__stdcall* Texcel_set_sheet_count)(const void* AObj, const s32 ACount);
typedef s32 (__stdcall* Texcel_get_sheet_name)(const void* AObj, const s32 AIdxSheet, char** AName);
typedef s32 (__stdcall* Texcel_set_sheet_name)(const void* AObj, const s32 AIdxSheet, const char* AName);
typedef s32 (__stdcall* Texcel_get_cell_count)(const void* AObj, const s32 AIdxSheet, s32* ARowCount, s32* AColCount);
typedef s32 (__stdcall* Texcel_get_cell_value)(const void* AObj, const s32 AIdxSheet, const s32 AIdxRow, const s32 AIdxCol, char** AValue);
typedef s32 (__stdcall* Texcel_set_cell_count)(const void* AObj, const s32 AIdxSheet, const s32 ARowCount, const s32 AColCount);
typedef s32 (__stdcall* Texcel_set_cell_value)(const void* AObj, const s32 AIdxSheet, const s32 AIdxRow, const s32 AIdxCol, char* AValue);
typedef s32 (__stdcall* Texcel_unload)(const void* AObj);
typedef s32 (__stdcall* Texcel_unload_all)(void);
// text file write
typedef s32 (__stdcall* TWriteTextFileStart)(const char* AFileName, native_int* AHandle);
typedef s32 (__stdcall* TWriteTextFileLine)(const native_int AHandle, const char* ALine);
typedef s32 (__stdcall* TWriteTextFileLineWithDoubleArray)(const native_int AHandle, const double* AArray, const s32 ACount);
typedef s32 (__stdcall* TWriteTextFileLineWithStringArray)(const native_int AHandle, const char** AArray, const s32 ACount);
typedef s32 (__stdcall* TWriteTextFileEnd)(const native_int AHandle);
// text file read
typedef s32 (__stdcall* TReadTextFileStart)(const char* AFileName, native_int* AHandle);
typedef s32 (__stdcall* TReadTextFileLine)(const native_int AHandle, const s32 ALineCapacity, ps32 AReadCharCount, char* ALine);
typedef s32 (__stdcall* TReadTextFileEnd)(const native_int AHandle);
// mat file
typedef s32 (__stdcall* TWriteMatFileStart)(const char* AFileName, native_int* AHandle);
typedef s32 (__stdcall* TWriteMatFileVariableDouble)(const native_int AHandle, const char* AVarName, const double AValue);
typedef s32 (__stdcall* TWriteMatFileVariableString)(const native_int AHandle, const char* AVarName, const char* AValue);
typedef s32 (__stdcall* TWriteMatFileVariableDoubleArray)(const native_int AHandle, const char* AVarName, const double* AArray, const s32 ACount);
typedef s32 (__stdcall* TWriteMatFileEnd)(const native_int AHandle);
typedef s32 (__stdcall* TReadMatFileStart)(const char* AFileName, native_int* AHandle);
typedef s32 (__stdcall* TReadMatFileVariableCount)(const native_int AHandle, const char* AVarName, ps32 ACount);
typedef s32 (__stdcall* TReadMatFileVariableString)(const native_int AHandle, const char* AVarName, char* AValue, const s32 AValueCapacity);
typedef s32 (__stdcall* TReadMatFileVariableDouble)(const native_int AHandle, const char* AVarName, const double* AValue, const s32 AStartIdx, const s32 ACount);
typedef s32 (__stdcall* TReadMatFileEnd)(const native_int AHandle);
// ini file
typedef s32 (__stdcall* TIniCreate)(const char* AFileName, native_int* AHandle);
typedef s32 (__stdcall* TIniWriteInt32)(const native_int AHandle, const char* ASection, const char* AKey, const s32 AValue);
typedef s32 (__stdcall* TIniWriteInt64)(const native_int AHandle, const char* ASection, const char* AKey, const s64 AValue);
typedef s32 (__stdcall* TIniWriteBool)(const native_int AHandle, const char* ASection, const char* AKey, const bool AValue);
typedef s32 (__stdcall* TIniWriteFloat)(const native_int AHandle, const char* ASection, const char* AKey, const double AValue);
typedef s32 (__stdcall* TIniWriteString)(const native_int AHandle, const char* ASection, const char* AKey, const char* AValue);
typedef s32 (__stdcall* TIniReadInt32)(const native_int AHandle, const char* ASection, const char* AKey, const s32* AValue, const s32 ADefault);
typedef s32 (__stdcall* TIniReadInt64)(const native_int AHandle, const char* ASection, const char* AKey, const s64* AValue, const s64 ADefault);
typedef s32 (__stdcall* TIniReadBool)(const native_int AHandle, const char* ASection, const char* AKey, const bool* AValue, const bool ADefault);
typedef s32 (__stdcall* TIniReadFloat)(const native_int AHandle, const char* ASection, const char* AKey, const double* AValue, const double ADefault);
typedef s32 (__stdcall* TIniReadString)(const native_int AHandle, const char* ASection, const char* AKey, const char* AValue, s32* AValueCapacity, const char* ADefault);
typedef s32 (__stdcall* TIniSectionExists)(const native_int AHandle, const char* ASection);
typedef s32 (__stdcall* TIniKeyExists)(const native_int AHandle, const char* ASection, const char* AKey);
typedef s32 (__stdcall* TIniDeleteKey)(const native_int AHandle, const char* ASection, const char* AKey);
typedef s32 (__stdcall* TIniDeleteSection)(const native_int AHandle, const char* ASection);
typedef s32 (__stdcall* TIniClose)(const native_int AHandle);
// automation module - Graphic Program
typedef s32 (__stdcall* TAMGetRunningState)(const char* AModuleName, PAutomationModuleRunningState AState, char** ASubModuleName, char** ACurrentParameterGroupName);
typedef s32 (__stdcall* TAMRun)(const char* AModuleName, const char* ASubModuleName, const char* AParameterGroupName, const bool AIsSync);
typedef s32 (__stdcall* TAMStop)(const char* AModuleName, const bool AIsSync);
typedef s32 (__stdcall* TAMSelectSubModule)(const bool AIsSelect, const char* AModuleName, const char* ASubModuleName, const char* AParameterGroupName);
// panel set
typedef s32 (__stdcall* TPanelSetEnable)(const char* APanelName, const char* AControlName, const bool AEnable);
typedef s32 (__stdcall* TPanelSetPositionX)(const char* APanelName, const char* AControlName, const float AX);
typedef s32 (__stdcall* TPanelSetPositionY)(const char* APanelName, const char* AControlName, const float AY);
typedef s32 (__stdcall* TPanelSetPositionXY)(const char* APanelName, const char* AControlName, const float AX, const float AY);
typedef s32 (__stdcall* TPanelSetOpacity)(const char* APanelName, const char* AControlName, const float AOpacity);
typedef s32 (__stdcall* TPanelSetWidth)(const char* APanelName, const char* AControlName, const float AWidth);
typedef s32 (__stdcall* TPanelSetHeight)(const char* APanelName, const char* AControlName, const float AHeight);
typedef s32 (__stdcall* TPanelSetWidthHeight)(const char* APanelName, const char* AControlName, const float AWidth, const float AHeight);
typedef s32 (__stdcall* TPanelSetRotationAngle)(const char* APanelName, const char* AControlName, const float AAngleDegree);
typedef s32 (__stdcall* TPanelSetRotationCenter)(const char* APanelName, const char* AControlName, const float ARatioX, const float ARatioY);
typedef s32 (__stdcall* TPanelSetScaleX)(const char* APanelName, const char* AControlName, const float AScaleX);
typedef s32 (__stdcall* TPanelSetScaleY)(const char* APanelName, const char* AControlName, const float AScaleY);
typedef s32 (__stdcall* TPanelSetBkgdColor)(const char* APanelName, const char* AControlName, const u32 AAlphaColor);
typedef s32 (__stdcall* TPanelSetSelectorItems)(const char* APanelName, const char* AControlName, const char* AItemsList);
// panel get
typedef s32 (__stdcall* TPanelGetEnable)(const char* APanelName, const char* AControlName, bool* AEnable);
typedef s32 (__stdcall* TPanelGetPositionXY)(const char* APanelName, const char* AControlName, float* AX, float* AY);
typedef s32 (__stdcall* TPanelGetOpacity)(const char* APanelName, const char* AControlName, float* AOpacity);
typedef s32 (__stdcall* TPanelGetWidthHeight)(const char* APanelName, const char* AControlName, float* AWidth, float* AHeight);
typedef s32 (__stdcall* TPanelGetRotationAngle)(const char* APanelName, const char* AControlName, float* AAngleDegree);
typedef s32 (__stdcall* TPanelGetRotationCenter)(const char* APanelName, const char* AControlName, float* ARatioX, float* ARatioY);
typedef s32 (__stdcall* TPanelGetScaleXY)(const char* APanelName, const char* AControlName, float* AScaleX, float* AScaleY);
typedef s32 (__stdcall* TPanelGetBkgdColor)(const char* APanelName, const char* AControlName, pu32 AAlphaColor);
typedef s32 (__stdcall* TPanelGetSelectorItems)(const char* APanelName, const char* AControlName, char** AItemsList);
// stim
typedef s32 (__stdcall* TSTIMSetSignalStatus)(const char* ASTIMName, const char* AUserLabel, TSTIMSignalStatus AStatus);
typedef s32 (__stdcall* TSTIMGetSignalStatus)(const char* ASTIMName, const char* AUserLabel, PSTIMSignalStatus AStatus);
// Atomic
typedef s32 (__stdcall* TAtomicIncrement32)(const ps32 AAddr, const s32 AValue, ps32 AResult);
typedef s32 (__stdcall* TAtomicIncrement64)(const ps64 AAddr, const s64 AValue, ps64 AResult);
typedef s32 (__stdcall* TAtomicSet32)(const ps32 AAddr, const s32 AValue);
typedef s32 (__stdcall* TAtomicSet64)(const ps64 AAddr, const s64 AValue);
// symbol mapping
typedef s32 (__stdcall* TAddDirectMappingCAN)(const char* ADestinationVarName, const char* ASignalAddress, const TSymbolMappingDirection ADirection);
typedef s32 (__stdcall* TAddDirectMappingWithFactorOffsetCAN)(const char* ADestinationVarName, const char* ASignalAddress, const TSymbolMappingDirection ADirection, const double AFactor, const double AOffset);
typedef s32 (__stdcall* TAddExpressionMapping)(const char* ADestinationVarName, const char* AExpression, const char* AArguments);
typedef s32 (__stdcall* TDeleteSymbolMappingItem)(const char* ADestinationVarName);
typedef s32 (__stdcall* TDeleteSymbolMappingItems)(void);
typedef s32 (__stdcall* TEnableSymbolMappingItem)(const char* ADestinationVarName, const bool AEnable);
typedef s32 (__stdcall* TEnableSymbolMappingEngine)(const bool AEnable);
typedef s32 (__stdcall* TSaveSymbolMappingSettings)(const char* AFileName);
typedef s32 (__stdcall* TLoadSymbolMappingSettings)(const char* AFileName);
// database
typedef s32 (__stdcall* TDBGetCANDBCount)(ps32 ACount);
typedef s32 (__stdcall* TDBGetLINDBCount)(ps32 ACount);
typedef s32 (__stdcall* TDBGetFlexRayDBCount)(ps32 ACount);
typedef s32 (__stdcall* TDBGetCANDBPropertiesByIndex)(PDBProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBPropertiesByIndex)(PDBProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBPropertiesByIndex)(PDBProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBECUPropertiesByIndex)(PDBECUProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBECUPropertiesByIndex)(PDBECUProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBECUPropertiesByIndex)(PDBECUProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBFramePropertiesByIndex)(PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBFramePropertiesByIndex)(PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBFramePropertiesByIndex)(PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBSignalPropertiesByIndex)(PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBSignalPropertiesByIndex)(PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBSignalPropertiesByIndex)(PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBPropertiesByAddress)(const char* AAddr, PDBProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBPropertiesByAddress)(const char* AAddr, PDBProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBPropertiesByAddress)(const char* AAddr, PDBProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBECUPropertiesByAddress)(const char* AAddr, PDBECUProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBECUPropertiesByAddress)(const char* AAddr, PDBECUProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBECUPropertiesByAddress)(const char* AAddr, PDBECUProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBFramePropertiesByAddress)(const char* AAddr, PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBFramePropertiesByAddress)(const char* AAddr, PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBFramePropertiesByAddress)(const char* AAddr, PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBSignalPropertiesByAddress)(const char* AAddr, PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBSignalPropertiesByAddress)(const char* AAddr, PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBSignalPropertiesByAddress)(const char* AAddr, PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBFramePropertiesByDBIndex)(const s32 AIdxDB, const s32 AIndex, PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBFramePropertiesByDBIndex)(const s32 AIdxDB, const s32 AIndex, PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBFramePropertiesByDBIndex)(const s32 AIdxDB, const s32 AIndex, PDBFrameProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBSignalPropertiesByDBIndex)(const s32 AIdxDB, const s32 AIndex, PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBSignalPropertiesByDBIndex)(const s32 AIdxDB, const s32 AIndex, PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBSignalPropertiesByDBIndex)(const s32 AIdxDB, const s32 AIndex, PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetCANDBSignalPropertiesByFrameIndex)(const s32 AIdxDB, const s32 AIdxFrame, const s32 ASgnIndexInFrame, PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetLINDBSignalPropertiesByFrameIndex)(const s32 AIdxDB, const s32 AIdxFrame, const s32 ASgnIndexInFrame, PDBSignalProperties AValue);
typedef s32 (__stdcall* TDBGetFlexRayDBSignalPropertiesByFrameIndex)(const s32 AIdxDB, const s32 AIdxFrame, const s32 ASgnIndexInFrame, PDBSignalProperties AValue);
// misc
typedef s32 (__stdcall* TTSAppMakeToast)(const char* AString, const TLogLevel ALevel);
typedef s32 (__stdcall* TTSAppMakeToastUntil)(const char* AString, const TLogLevel ALevel, const bool* ACloseCriteria, const bool AUserCanBreak);
typedef s32 (__stdcall* TTSAppMakeToastWithCallback)(const char* AString, const TLogLevel ALevel, const TCheckResultCallback ACallback, const bool AUserCanBreak);
typedef s32 (__stdcall* TTSAppExecutePythonString)(const char* AString, const char* AArguments, const bool AIsSync, const bool AIsX64, char** AResultLog);
typedef s32 (__stdcall* TTSAppExecutePythonScript)(const char* AFilePath, const char* AArguments, const bool AIsSync, const bool AIsX64, char** AResultLog);
typedef s32 (__stdcall* TTSAppExecuteApp)(const char* AAppPath,  const char* AWorkingDir, const char* AParameter, const s32 AWaitTimeMS);
typedef s32 (__stdcall* TTSAppTerminateAppByName)(const char* AImageName);
typedef s32 (__stdcall* TTSAppCallMPAPI)(const char* ALibName, const char* AFuncName, const char* AInParameters, char** AOutParameters);
typedef s32 (__stdcall* TTSAppSetAnalysisTimeRange)(const s64 ATimeStartUs, const s64 ATimeEndUs);
typedef s32 (__stdcall* TTSAppEnableAllGraphics)(const bool AEnable, const char* AExceptCaptions);
typedef s32 (__stdcall* TTSAppGetTSMasterVersion)(ps32 AYear, ps32 AMonth, ps32 ADay, ps32 ABuildNumber);
typedef s32 (__stdcall* TUIShowPageByIndex)(const s32 AIndex);
typedef s32 (__stdcall* TUIShowPageByName)(const char* AName);
typedef s32 (__stdcall* TWriteRealtimeComment)(const void* AObj, const char* AName);
typedef s32 (__stdcall* TTSAppSetThreadPriority)(const void* AObj, const s32 APriority);
typedef s32 (__stdcall* TTSAppForceDirectory)(const char* ADir);
typedef s32 (__stdcall* TTSAppDirectoryExists)(const char* ADir);
typedef s32 (__stdcall* TTSAppOpenDirectoryAndSelectFile)(const char* AFileName);
typedef s32 (__stdcall* TTSMiniDelayCPU)(void);
typedef s32 (__stdcall* TPromptUserInputValue)(const char* APrompt, double* AValue);
typedef s32 (__stdcall* TPromptUserInputString)(const char* APrompt, char* AValue, const s32 AValueCapacity);
typedef s32 (__stdcall* TTSAppGetDocPath)(char** AFilePath);
typedef s32 (__stdcall* TTSAppGetHWIDString)(char** AIDString);
typedef s32 (__stdcall* TTSAppGetHWIDArray)(pu8 AArray8B);
typedef s32 (__stdcall* TPlaySound)(const bool AIsSync, const char* AWaveFileName);
typedef s32 (__stdcall* TUILoadPlugin)(const char* APluginName);
typedef s32 (__stdcall* TUIUnloadPlugin)(const char* APluginName);
typedef s32 (__stdcall* TUIGetMainWindowHandle)(pnative_int AHandle);
typedef s32 (__stdcall* TPrintDeltaTime)(const char* AInfo);
typedef s32 (__stdcall* TGetConstantDouble)(const char* AName, double* AValue);
typedef s32 (__stdcall* TWaitWithDialog)(const void* AObj, const char* ATitle, const char* AMessage, const bool* ApResult, const float* ApProgress100);
typedef s32 (__cdecl* TRunPythonFunction)(const void* AObj, const char* AModuleName, const char* AFuncName, const char* AArgFormat, ...);
typedef char* (__stdcall* TGetCurrentMpName)(const void* AObj);
typedef s32 (__stdcall* TGetSystemConstantCount)(const s32 AIdxType, ps32 ACount);
typedef s32 (__stdcall* TGetSystemConstantValueByIndex)(const s32 AIdxType, const s32 AIdxValue, char** AName, pdouble AValue, char** ADescription);
typedef s32 (__stdcall* TAddSystemConstant)(const char* AName, const double AValue, const char* ADescription);
typedef s32 (__stdcall* TDeleteSystemConstant)(const char* AName);
typedef s32 (__stdcall* TDBGetFlexRayClusterParameters)(const s32 AIdxChn, const pchar AClusterName, PFlexRayClusterParameters AValue);
typedef s32 (__stdcall* TDBGetFlexRayControllerParameters)(const s32 AIdxChn,  pchar AClusterName, const pchar AECUName, PFlexRayControllerParameters AValue);
typedef s32 (__stdcall* TSetSystemVarEventSupport)(const pchar ACompleteName, const bool ASupport);
typedef s32 (__stdcall* TGetSystemVarEventSupport)(const pchar ACompleteName, pbool ASupport);
typedef s32 (__stdcall* TGetDateTime)(ps32 AYear, ps32 AMonth, ps32 ADay, ps32 AHour, ps32 AMinute, ps32 ASecond, ps32 AMilliseconds);
typedef s32 (__stdcall* TGPGDeleteAllModules)(void);
typedef s32 (__stdcall* TGPGCreateModule)(const pchar AProgramName, const pchar ADisplayName, ps64 AModuleId, ps64 AEntryPointId);
typedef s32 (__stdcall* TGPGDeleteModule)(const s64 AModuleId);
typedef s32 (__stdcall* TGPGDeployModule)(const s64 AModuleId, const pchar AGraphicProgramWindowTitle);
typedef s32 (__stdcall* TGPGAddActionDown)(const s64 AModuleId, const s64 AUpperActionId, const pchar ADisplayName, const pchar AComment, ps64 AActionId);
typedef s32 (__stdcall* TGPGAddActionRight)(const s64 AModuleId, const s64 ALeftActionId, const pchar ADisplayName, const pchar AComment, ps64 AActionId);
typedef s32 (__stdcall* TGPGAddGoToDown)(const s64 AModuleId, const s64 AUpperActionId, const pchar ADisplayName, const pchar AComment, const pchar AJumpLabel, ps64 AActionId);
typedef s32 (__stdcall* TGPGAddGoToRight)(const s64 AModuleId, const s64 ALeftActionId, const pchar ADisplayName, const pchar AComment, const pchar AJumpLabel, ps64 AActionId);
typedef s32 (__stdcall* TGPGAddFromDown)(const s64 AModuleId, const s64 AUpperActionId, const pchar ADisplayName, const pchar AComment, const pchar AJumpLabel, ps64 AActionId);
typedef s32 (__stdcall* TGPGAddGroupDown)(const s64 AModuleId, const s64 AUpperActionId, const pchar ADisplayName, const pchar AComment, ps64 AGroupId, ps64 AEntryPointId);
typedef s32 (__stdcall* TGPGAddGroupRight)(const s64 AModuleId, const s64 ALeftActionId, const pchar ADisplayName, const pchar AComment, ps64 AGroupId, ps64 AEntryPointId);
typedef s32 (__stdcall* TGPGDeleteAction)(const s64 AModuleId, const s64 AActionId);
typedef s32 (__stdcall* TGPGSetActionNOP)(const s64 AModuleId, const s64 AActionId);
typedef s32 (__stdcall* TGPGSetActionSignalReadWrite)(const s64 AModuleId, const s64 AActionId);
typedef s32 (__stdcall* TGPGSetActionAPICall)(const s64 AModuleId, const s64 AActionId);
typedef s32 (__stdcall* TGPGSetActionExpression)(const s64 AModuleId, const s64 AActionId);
typedef s32 (__stdcall* TGPGConfigureActionBasic)(const s64 AModuleId, const s64 AActionId, const pchar ADisplayName, const pchar AComment, const s32 ATimeoutMs);
typedef s32 (__stdcall* TGPGConfigureGoTo)(const s64 AModuleId, const s64 AActionId, const pchar ADisplayName, const pchar AComment, const pchar AJumpLabel);
typedef s32 (__stdcall* TGPGConfigureFrom)(const s64 AModuleId, const s64 AActionId, const pchar ADisplayName, const pchar AComment, const pchar AJumpLabel);
typedef s32 (__stdcall* TGPGConfigureNOP)(const s64 AModuleId, const s64 AActionId, const bool ANextDirectionIsDown, const bool AResultOK, const bool AJumpBackIfEnded);
typedef s32 (__stdcall* TGPGConfigureGroup)(const s64 AModuleId, const s64 AActionId, const TLIBAutomationSignalType ARepeatCountType, const pchar ARepeatCountRepr);
typedef s32 (__stdcall* TGPGConfigureSignalReadWriteListClear)(const s64 AModuleId, const s64 AActionId);
typedef s32 (__stdcall* TGPGConfigureSignalWriteListAppend)(const s64 AModuleId, const s64 AActionId, const TLIBAutomationSignalType ADestSignalType, const TLIBAutomationSignalType ASrcSignalType, const pchar ADestSignalExpr, const pchar ASrcSignalExpr, ps32 AItemIndex);
typedef s32 (__stdcall* TGPGConfigureSignalReadListAppend)(s64 AModuleId, s64 AActionId, bool AIsConditionAND, TLIBAutomationSignalType ADestSignalType, TLIBAutomationSignalType AMinSignalType, TLIBAutomationSignalType AMaxSignalType, const pchar ADestSignalExpr, const pchar AMinSignalExpr, const pchar AMaxSignalExpr, ps32 AItemIndex);
typedef s32 (__stdcall* TGPGConfigureAPICallArguments)(const s64 AModuleId, const s64 AActionId, const TLIBMPFuncSource AAPIType, const pchar AAPIName, const PLIBAutomationSignalType AAPIArgTypes, char** AAPIArgNames, char** AAPIArgExprs, const s32 AArraySize);
typedef s32 (__stdcall* TGPGConfigureAPICallResult)(const s64 AModuleId, const s64 AActionId, const bool AIgnoreResult, const TLIBAutomationSignalType ASignalType, const pchar ASignalExpr);
typedef s32 (__stdcall* TGPGConfigureExpression)(const s64 AModuleId, const s64 AActionId, const s32 AxCount, const pchar AExpression, const PLIBAutomationSignalType AArgumentTypes, char** AArgumentExprs, const TLIBAutomationSignalType AResultType, const pchar AResultExpr);
typedef s32 (__stdcall* TGPGAddLocalVar)(const s64 AModuleId, const TLIBSimVarType AType, const pchar AName, const pchar AInitValue, const pchar AComment, ps32 AItemIndex);
typedef s32 (__stdcall* TGPGDeleteLocalVar)(const s64 AModuleId, const s32 AItemIndex);
typedef s32 (__stdcall* TGPGDeleteAllLoalVars)(const s64 AModuleId);
typedef s32 (__stdcall* TGPGDeleteGroupItems)(const s64 AModuleId, const s64 AGroupId);
typedef s32 (__stdcall* TGPGConfigureSignalReadWriteListDelete)(const s64 AModuleId, const s64 AActionId, const s32 AItemIndex);
typedef s32 (__stdcall* TGPGConfigureModule)(const s64 AModuleId, const pchar AProgramName, const pchar ADisplayName, const s32 ARepeatCount, const bool ASelected);
typedef s32 (__stdcall* TUIShowWindow)(const pchar AWindowTitle, const bool AIsShow);
typedef s32 (__stdcall* TUIGraphicsLoadConfiguration)(const pchar AWindowTitle, const pchar AConfigurationName);
typedef s32 (__stdcall* TUIWatchdogEnable)(const bool AEnable);
typedef s32 (__stdcall* TUIWatchdogFeed)(void);
typedef s32 (__stdcall* TAddPathToEnvironment)(const char* APath);
typedef s32 (__stdcall* TDeletePathFromEnvironment)(const char* APath);
typedef s32 (__stdcall* TTSAppSetSystemVarDoubleWTime)(const char* ACompleteName, const double AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarInt32WTime)(const char* ACompleteName, const s32 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt32WTime)(const char* ACompleteName, const u32 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarInt64WTime)(const char* ACompleteName, const s64 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt64WTime)(const char* ACompleteName, const u64 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt8ArrayWTime)(const char* ACompleteName, const s32 ACount, const pu8 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarInt32ArrayWTime)(const char* ACompleteName, const s32 ACount, const ps32 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarInt64ArrayWTime)(const char* ACompleteName, const s32 ACount, const ps64 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarDoubleArrayWTime)(const char* ACompleteName, const s32 ACount, const double* AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarStringWTime)(const char* ACompleteName, const char* AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarGenericWTime)(const char* ACompleteName, const char* AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarDoubleAsyncWTime)(const char* ACompleteName, const double AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarInt32AsyncWTime)(const char* ACompleteName, const s32 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt32AsyncWTime)(const char* ACompleteName, const u32 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarInt64AsyncWTime)(const char* ACompleteName, const s64 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt64AsyncWTime)(const char* ACompleteName, const u64 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarUInt8ArrayAsyncWTime)(const char* ACompleteName, const s32 ACount, const pu8 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarInt32ArrayAsyncWTime)(const char* ACompleteName, const s32 ACount, const ps32 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarInt64ArrayAsyncWTime)(const char* ACompleteName, const s32 ACount, const ps64 AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarDoubleArrayAsyncWTime)(const char* ACompleteName, const s32 ACount, const double* AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarStringAsyncWTime)(const char* ACompleteName, const char* AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TTSAppSetSystemVarGenericAsyncWTime)(const char* ACompleteName, const char* AValue, const s64 ATimeUs);
typedef s32 (__stdcall* TDBGetSignalStartBitByPDUOffset)(const s32 ASignalStartBitInPDU, const s32 ASignalBitLength, const bool AIsSignalIntel, const bool AIsPDUIntel, const s32 APDUStartBit, const s32 APDUBitLength, ps32 AActualStartBit);
typedef s32 (__stdcall* TUIShowSaveFileDialog)(const char* ATitle, const char* AFileTypeDesc, const char* AFilter, const char* ASuggestFileName, char** ADestinationFileName);
typedef s32 (__stdcall* TUIShowOpenFileDialog)(const char* ATitle, const char* AFileTypeDesc, const char* AFilter, const char* ASuggestFileName, char** ADestinationFileName);
typedef s32 (__stdcall* TUIShowSelectDirectoryDialog)(char** ADestinationDirectory);
typedef s32 (__stdcall* TSetEthernetChannelCount)(const s32 ACount);
typedef s32 (__stdcall* TGetEthernetChannelCount)(ps32 ACount);
typedef s32 (__stdcall* TDBGetCANDBIndexById)(const s32 AId, ps32 AIndex);
typedef s32 (__stdcall* TDBGetLINDBIndexById)(const s32 AId, ps32 AIndex);
typedef s32 (__stdcall* TDBGetFlexRayDBIndexById)(const s32 AId, ps32 AIndex);
typedef s32 (__stdcall* TRegisterSystemVarChangeEvent)(const void* AObj, const char* ACompleteName, const TOnSysVarChange AEvent);
typedef s32 (__stdcall* TUnRegisterSystemVarChangeEvent)(const void* AObj, const char* ACompleteName, const TOnSysVarChange AEvent);
typedef s32 (__stdcall* TUnRegisterSystemVarChangeEvents)(const void* AObj, const TOnSysVarChange AEvent);
typedef s32 (__stdcall* TCallSystemAPI)(const char* AAPIName, const s32 AArgCount, const s32 AArgCapacity, char** AArgs);
typedef s32 (__stdcall* TCallLibraryAPI)(const char* AAPIName, const s32 AArgCount, const s32 AArgCapacity, char** AArgs);
typedef s32 (__stdcall* TIniReadStringWoQuotes)(const native_int AHandle, const char* ASection, const char* AKey, char* AValue, ps32 AValueCapacity, const char* ADefault);
typedef s32 (__stdcall* TUIGraphicsAddSignal)(const char* AWindowCaption, const s32 AIdxSplit, const TSignalType ASgnType, const char* ASignalAddress);
typedef s32 (__stdcall* TUIGraphicsClearSignals)(const char* AWindowCaption, const s32 AIdxSplit);
typedef s32 (__stdcall* TGPGLoadExcel)(const char* AFileName, char** AGraphicProgramName, char** ASubModuleName);
typedef s32 (__stdcall* TRunProcedure)(const TCProcedure AProcedure);
typedef s32 (__stdcall* TOpenHelpDoc)(const char* AFileNameWoSuffix, const char* ATitle);
typedef s32 (__stdcall* TGetLangString)(const char* AEnglishStr, const char* AIniSection, char** ATranslatedStr);
typedef s32 (__stdcall* TConvertBlfToCsv)(const char* ABlfFile, const char* ACSVFile, const pbool AToTerminate);
typedef s32 (__stdcall* TConvertBlfToCsvWFilter)(const char* ABlfFile, const char* ACSVFile, const char* AFilterConf, const pbool AToTerminate);
typedef s32 (__stdcall* TStartLogWFileName)(const void* AObj, const char* AFileName);
typedef s32 (__stdcall* TConvertBlfToMatWFilter)(const char* ABlfFile, const char* AMatFile, const char* AFilterConf, const pbool AToTerminate);
typedef s32 (__stdcall* TConvertASCToMatWFilter)(const char* AASCFile, const char* AMatFile, const char* AFilterConf, const pbool AToTerminate);
typedef s32 (__stdcall* TConvertASCToCSVWFilter)(const char* AASCFile, const char* ACSVFile, const char* AFilterConf, const pbool AToTerminate);
typedef s32 (__stdcall* TSetDebugLogLevel)(const TLogLevel ALevel);
typedef s32 (__stdcall* TGetFormUniqueId)(const char* AClassName, const s32 AFormIdx, ps64 AUniqueId);
typedef s32 (__stdcall* Tpanel_clear_control)(const char* APanelName, const char* AControlName);
typedef s32 (__stdcall* Tset_form_unique_id)(const s64 AOldId, const s64 ANewId);
typedef s32 (__stdcall* Tshow_form)(const char* AFormCaption, const bool AShow);
typedef s32 (__stdcall* Tkill_form)(const char* AFormCaption);
typedef s32 (__stdcall* Tplace_form)(const char* AFormCaption, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Ttoggle_mdi_form)(const char* AFormCaption, const bool AIsMDI);
typedef s32 (__stdcall* Tget_language_id)(ps32 AId);
typedef s32 (__stdcall* Tcreate_form)(const char* AClassName, const bool AForceCreate, ps64 AFormId);
typedef s32 (__stdcall* Tset_form_caption)(const char* AOldCaption, const char* ANewCaption);
typedef s32 (__stdcall* Tenter_critical_section)(const void* AObj);
typedef s32 (__stdcall* Tleave_critical_section)(const void* AObj);
typedef s32 (__stdcall* Ttry_enter_critical_section)(const void* AObj);
typedef s32 (__stdcall* Tdb_load_can_db)(const char* ADBFileName, const char* ASupportedChannelsBased0, ps32 AId);
typedef s32 (__stdcall* Tdb_load_lin_db)(const char* ADBFileName, const char* ASupportedChannelsBased0, ps32 AId);
typedef s32 (__stdcall* Tdb_load_flexray_db)(const char* ADBFileName, const char* ASupportedChannelsBased0, ps32 AId);
typedef s32 (__stdcall* Tdb_unload_can_db)(const s32 AId);
typedef s32 (__stdcall* Tdb_unload_lin_db)(const s32 AId);
typedef s32 (__stdcall* Tdb_unload_flexray_db)(const s32 AId);
typedef s32 (__stdcall* Tdb_unload_can_dbs)(void);
typedef s32 (__stdcall* Tdb_unload_lin_dbs)(void);
typedef s32 (__stdcall* Tdb_unload_flexray_dbs)(void);
typedef s32 (__stdcall* TSecurityUpdateNewKeySync)(const s32 AChnIdx, const char* AOldKey, const u8 AOldKeyLength, const char* ANewKey, const u8 ANewKeyLength, const s32 ATimeoutMS);
typedef s32 (__stdcall* TSecurityUnlockWriteAuthoritySync)(const s32 AChnIdx, const char* AKey, const u8 AKeyLength, const s32 ATimeoutMS);
typedef s32 (__stdcall* TSecurityUnlockWriteAuthorityASync)(const s32 AChnIdx, const char* AKey, const u8 AKeyLength);
typedef s32 (__stdcall* TSecurityWriteStringSync)(const s32 AChnIdx, const s32 ASlotIndex, const char* AString, const u8 AStringLength, const s32 ATimeoutMs);
typedef s32 (__stdcall* TSecurityWriteStringASync)(const s32 AChnIdx, const s32 ASlotIndex, const char* AString, const u8 AStringLength);
typedef s32 (__stdcall* TSecurityReadStringSync)(const s32 AChnIdx, const s32 ASlotIndex, const char* AString, const pu8 AStringLength, const s32 ATimeoutMS);
typedef s32 (__stdcall* TSecurityUnlockEncChannelSync)(const s32 AChnIdx, const s32 ASlotIndex, const char* AString, const u8 AStringLength, const s32 ATimeoutMS);
typedef s32 (__stdcall* TSecurityUnlockEncChannelASync)(const s32 AChnIdx, const s32 ASlotIndex, const char* AString, const u8 AStringLength);
typedef s32 (__stdcall* TSecurityEncryptStringSync)(const s32 AChnIdx, const s32 ASlotIndex, const char* AString, const pu8 AStringLength, const s32 ATimeoutMS);
typedef s32 (__stdcall* TSecurityDecryptStringSync)(const s32 AChnIdx, const s32 ASlotIndex, const char* AString, const pu8 AStringLength, const s32 ATimeoutMS);
typedef s32 (__stdcall* Tset_channel_timestamp_deviation_factor)(const TLIBApplicationChannelType ABusType, const s32 AIdxLogicalChn, const s64 APCTimeUs, const s64 AHwTimeUs);
typedef s32 (__stdcall* Tstart_system_message_log)(const void* AObj, const char* ADirectory);
typedef s32 (__stdcall* Tend_system_message_log)(const void* AObj, char** ALogFileName);
typedef s32 (__stdcall* Tmask_fpu_exceptions)(const bool AMasked);
typedef s32 (__stdcall* Tcreate_process_shared_memory)(ppu8 AAddress, const s32 ASizeBytes);
typedef s32 (__stdcall* Tget_process_shared_memory)(ppu8 AAddress, ps32 ASizeBytes);
typedef s32 (__stdcall* Tclear_user_constants)(void);
typedef s32 (__stdcall* Tappend_user_constants_from_c_header)(const char* AHeaderFile);
typedef s32 (__stdcall* Tappend_user_constant)(const char* AConstantName, const double AValue, const char* ADesc);
typedef s32 (__stdcall* Tdelete_user_constant)(const char* AConstantName);
typedef s32 (__stdcall* Tget_mini_program_count)(ps32 ACount);
typedef s32 (__stdcall* Tget_mini_program_info_by_index)(const s32 AIndex, ps32 AKind, char** AProgramName, char** ADisplayName);
typedef s32 (__stdcall* Tcompile_mini_programs)(const char* AProgramNames);
typedef s32 (__stdcall* Tset_system_var_init_value)(const char* ACompleteName, const char* AValue);
typedef s32 (__stdcall* Tget_system_var_init_value)(const char* ACompleteName, char** AValue);
typedef s32 (__stdcall* Treset_system_var_to_init)(const char* ACompleteName);
typedef s32 (__stdcall* Treset_all_system_var_to_init)(const char* AOwner);
typedef s32 (__stdcall* Tget_system_var_generic_upg1)(const char* ACompleteName, char** AValue);
typedef s32 (__stdcall* Tmplib_load)(const char* AMPFileName,const bool ARunAfterLoad);
typedef s32 (__stdcall* Tmplib_unload)(const char* AMPFileName);
typedef s32 (__stdcall* Tmplib_unload_all)(void);
typedef s32 (__stdcall* Tmplib_run)(const char* AMPFileName);
typedef s32 (__stdcall* Tmplib_is_running)(const char* AMPFileName,bool* AIsRunning);
typedef s32 (__stdcall* Tmplib_stop)(const char* AMPFileName);
typedef s32 (__stdcall* Tmplib_run_all)(void);
typedef s32 (__stdcall* Tmplib_stop_all)(void);
typedef s32 (__stdcall* Tmplib_get_function_address)(const char* AGroupName,const char* AFuncName,void** AAddress);
typedef s32 (__stdcall* Tmplib_get_function_prototype)(const char* AGroupName,const char* AFuncName,const ppchar APrototype);
typedef s32 (__stdcall* Tmplib_get_mp_function_list)(const char* AGroupName,const ppchar AList);
typedef s32 (__stdcall* Tmplib_get_mp_list)(const ppchar AList);
typedef s32 (__stdcall* Tget_tsmaster_binary_location)(char** ADirectory);
typedef s32 (__stdcall* Tget_form_instance_count)(const char* AClassName, ps32 ACount);
typedef s32 (__stdcall* Tget_active_application_list)(char** ATSMasterAppNames);
typedef s32 (__stdcall* Tenumerate_hw_devices)(ps32 ACount);
typedef s32 (__stdcall* Tget_hw_info_by_index)(const s32 AIndex, PLIBHWInfo AHWInfo);
typedef s32 (__stdcall* Tui_graphics_set_measurement_cursor)(const char* AWindowCaption, const s64 ATimeUs);
typedef s32 (__stdcall* Tui_graphics_set_diff_cursor)(const char* AWindowCaption, const s64 ATime1Us, const s64 ATime2Us);
typedef s32 (__stdcall* Tui_graphics_hide_diff_cursor)(const char* AWindowCaption);
typedef s32 (__stdcall* Tui_graphics_hide_measurement_cursor)(const char* AWindowCaption);
typedef s32 (__stdcall* Tencode_string)(const char* ASrc, char** ADest);
typedef s32 (__stdcall* Tdecode_string)(const char* ASrc, char** ADest);
typedef s32 (__stdcall* Tis_realtime_mode)(pbool AValue);
typedef s32 (__stdcall* Tis_simulation_mode)(pbool AValue);
typedef s32 (__stdcall* Tui_ribbon_add_icon)(const char* AFormClassName, const char* ATabName, const char* AGroupName, const char* AButtonName, const s32 AIdxImageSmall, const s32 AIdxImageLarge);
typedef s32 (__stdcall* Tui_ribbon_del_icon)(const char* AFormClassName);
typedef s32 (__stdcall* Tpanel_create_control)(const char* APanelName, const char* AParentCtrlName, s32 AParentCtrlSubIdx, const char* AName, TLIBPanelControlType ACtrlType, float ALeft, float ATop, float AWidth, float AHeight, TLIBPanelSignalType AVarType, const char* AVarLink);
typedef s32 (__stdcall* Tpanel_delete_control)(const char* APanelName, const char* ACtrlName);
typedef s32 (__stdcall* Tpanel_set_var)(const char* APanelName, const char* ACtrlName, const TLIBPanelSignalType AVarType, const char* AVarLink);
typedef s32 (__stdcall* Tpanel_get_var)(const char* APanelName, const char* ACtrlName, PLIBPanelSignalType AVarType, char** AVarLink);
typedef s32 (__stdcall* Tpanel_get_control_count)(const char* APanelName, ps32 ACount);
typedef s32 (__stdcall* Tpanel_get_control_by_index)(const char* APanelName, const s32 AIndex, PLIBPanelControlType ACtrlType, char** AName);
typedef s32 (__stdcall* Tui_save_project)(const char* AProjectFullPath);
typedef s32 (__stdcall* Tretrieve_api_address)(const char* AApiName, ps32 AFlags, pnative_int AAddr);
typedef s32 (__stdcall* Tui_load_rpc_ip_configuration)(const char* AFileName);
typedef s32 (__stdcall* Tui_unload_rpc_ip_configuration)(const char* AFileName);
typedef s32 (__stdcall* Tui_unload_rpc_ip_configurations)(void);
typedef s32 (__stdcall* Tam_set_custom_columns)(const char* AModuleName, const char* AColumnsConfig);
typedef s32 (__stdcall* Twrite_realtime_comment_w_time)(const void* AObj, const char* AComment, const s64 ATimeUs);
typedef s32 (__stdcall* Tui_graphics_set_relative_time)(const char* AWindowCaption, const s64 ATimeUs);
typedef s32 (__stdcall* Tpanel_import_configuration)(const char* APanelName, const char* AFileName);
typedef s32 (__stdcall* Tui_graphics_set_y_axis_fixed_range)(const char* AWindowCaption, const s32 AIdxSplit, const char* ASignalName, const double AMin, const double AMax);
typedef s32 (__stdcall* Texport_system_messages)(const char* AFileName);
typedef s32 (__stdcall* Tui_graphics_export_csv)(const char* AWindowCaption, const char* ASgnNames, const char* AFileName, const s64 ATimeStartUs, const s64 ATimeEndUs);
typedef s32 (__stdcall* Tregister_usb_insertion_event)(const pvoid AObj, const TOnUSBPlugEvent AEvent);
typedef s32 (__stdcall* Tunregister_usb_insertion_event)(const pvoid AObj, const TOnUSBPlugEvent AEvent);
typedef s32 (__stdcall* Tregister_usb_removal_event)(const pvoid AObj, const TOnUSBPlugEvent AEvent);
typedef s32 (__stdcall* Tunregister_usb_removal_event)(const pvoid AObj, const TOnUSBPlugEvent AEvent);
typedef s32 (__stdcall* Tsecurity_check_custom_license_valid)(const char* ALicenseName);
typedef s32 (__stdcall* Tcall_model_initialization)(const pvoid AObj, const char* ADiagramName, const s32 AInCnt, const s32 AOutCnt, const PMBDDataType AInTypes, const PMBDDataType AOutTypes, pnative_int AHandle);
typedef s32 (__stdcall* Tcall_model_step)(const pvoid AObj, const native_int AHandle, const s64 ATimeUs, const pvoid AInValues, pvoid AOutValues);
typedef s32 (__stdcall* Tcall_model_finalization)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Tui_hide_main_form)(void);
typedef s32 (__stdcall* Tui_show_main_form)(const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Tconfigure_can_regs)(const s32 AChn, const float ABaudrateKbps, const u32 ASEG1, const u32 ASEG2, const u32 APrescaler, const u32 ASJW, const bool AOnlyListen, const bool A120OhmConnected);
typedef s32 (__stdcall* Tconfigure_canfd_regs)(const s32 AChn, const float AArbBaudrateKbps, const u32 AArbSEG1, const u32 AArbSEG2, const u32 AArbPrescaler, const u32 AArbSJW, const float ADataBaudrateKbps, const u32 ADataSEG1, const u32 ADataSEG2, const u32 ADataPrescaler, const u32 ADataSJW, const TCANFDControllerType AControllerType, const TCANFDControllerMode AControllerMode, const bool A120OhmConnected);
typedef s32 (__stdcall* Tstart_log_verbose)(const pvoid AObj, s32 AFilesizeType, s64 ASizeValue);
typedef s32 (__stdcall* Tstart_log_w_filename_verbose)(const pvoid AObj, char* AFileName, s32 AFilesizeType, s64 ASizeValue);
typedef s32 (__stdcall* Ttsio_start_configuration)(void);
typedef s32 (__stdcall* Ttsio_end_configuration)(void);
typedef s32 (__stdcall* Ttsdi_config_sync)(const s32 AChn, const double ASampleRate, const s32 AInputThrsholdMv, const s32 AReportPWMFreq, const s32 ATimeoutMs);
typedef s32 (__stdcall* Ttsdo_config_sync)(const s32 AChn, const s32 AEnableReport, const double ASampleRate, const s32 AOutputLevel, const s32 AOutputModes, const s32 AOutputType, const s32 ATimeoutMs);
typedef s32 (__stdcall* Tset_di_channel_count)(const s32 ACount);
typedef s32 (__stdcall* Tset_do_channel_count)(const s32 ACount);
typedef s32 (__stdcall* Tset_ao_channel_count)(const s32 ACount);
typedef s32 (__stdcall* Tset_ai_channel_count)(const s32 ACount);
typedef s32 (__stdcall* Tget_ai_channel_count)(const ps32 ACount);
typedef s32 (__stdcall* Tget_ao_channel_count)(const ps32 ACount);
typedef s32 (__stdcall* Tget_do_channel_count)(const ps32 ACount);
typedef s32 (__stdcall* Tget_di_channel_count)(const ps32 ACount);
typedef void* TTSX509_handle_t;
typedef TTSX509_handle_t* PTTSX509_handle_t;
typedef s32 (__stdcall* Ttls_rawsocket_get_errno)(void);
typedef s32 (__stdcall* Ttls_rawsocket_close)(s32 s, s32 force_exit_time_wait);
typedef native_int (__stdcall* Ttls_rawsocket_recv)(s32 s, pvoid mem, native_int len, s32 flags);
typedef native_int (__stdcall* Ttls_rawsocket_write)(s32 s, pvoid dataptr, native_int size);
typedef s32 (__stdcall* Ttls_rawsocket_setsockopt)(s32 s, s32 level, s32 optname, pvoid optval, u32 optlen);
typedef s32 (__stdcall* Ttls_rawsocket_shutdown)(s32 s, s32 how);
typedef s32 (__stdcall* Tcrypto_get_error_description)(char* buffer, native_uint buffer_length);
typedef s32 (__stdcall* Tcrypto_encrypt_aes_128_ecb)(pu8 key, native_uint key_length, pu8 plaintext, native_uint plaintext_length, pu8 ciphertext, pnative_uint ciphertext_length);
typedef s32 (__stdcall* Tcrypto_decrypt_aes_128_ecb)(pu8 key, native_uint key_length, pu8 ciphertext, native_uint ciphertext_length, pu8 plaintext, pnative_uint plaintext_length);
typedef s32 (__stdcall* Tcrypto_decrypt_aes_128_cbc)(pu8 key, native_uint key_length, pu8 ciphertext, native_uint ciphertext_length, pu8 iv, native_uint iv_length, pu8 plaintext, pnative_uint plaintext_length);
typedef s32 (__stdcall* Tcrypto_decrypt_aes_256_cbc)(pu8 key, native_uint key_length, pu8 ciphertext, native_uint ciphertext_length, pu8 iv, native_uint iv_length, pu8 plaintext, pnative_uint plaintext_length);
typedef s32 (__stdcall* Tcrypto_decrypt_rsa)(s8 key_coding, pu8 private_key, native_uint key_length, pu8 ciphertext, native_uint ciphertext_length, pu8 plaintext, pnative_uint plaintext_length, u8 padding_mode);
typedef s32 (__stdcall* Tcrypto_encrypt_rsa)(s8 key_coding, pu8 public_key, native_uint key_length, pu8 plaintext, native_uint plaintext_length, pu8 ciphertext, pnative_uint ciphertext_length,  u8 padding_mode);
typedef s32 (__stdcall* Tcrypto_encrypt_aes_128_cbc)(pu8 key, native_uint key_length, pu8 plaintext, native_uint plaintext_length, pu8 iv, native_uint iv_length, pu8 ciphertext, pnative_uint ciphertext_length);
typedef s32 (__stdcall* Tcrypto_encrypt_aes_256_cbc)(pu8 key, native_uint key_length, pu8 plaintext, native_uint plaintext_length, pu8 iv, native_uint iv_length, pu8 ciphertext, pnative_uint ciphertext_length);
typedef s32 (__stdcall* Tcrypto_digest_sha2_256)(pvoid data, native_uint data_length, pu8 hash, pnative_uint hash_length);
typedef s32 (__stdcall* Tcrypto_digest_sha2_512)(pvoid data, native_uint data_length, pu8 hash, pnative_uint hash_length);
typedef s32 (__stdcall* Tcrypto_digest_sha3_512)(pvoid data, native_uint data_length, pu8 hash, pnative_uint hash_length);
typedef s32 (__stdcall* Tcrypto_digest_sha3_256)(pvoid data, native_uint data_length, pu8 hash, pnative_uint hash_length);
typedef s32 (__stdcall* Tcrypto_digest_md5)(pvoid data, native_uint data_length, pu8 hash, pnative_uint hash_length);
typedef s32 (__stdcall* Tcrypto_generate_cmac)(pu8 key, native_uint key_length, pu8 data, native_uint data_length, pu8 cmac, pnative_uint cmac_length);
typedef s32 (__stdcall* Tcrypto_generate_hmac)(u8 hash_method, pu8 key, native_uint key_length, pu8 data, native_uint data_length, pu8 hmac, pnative_uint hmac_length);
typedef s32 (__stdcall* Tcrypto_generate_siphash_2_4)(pu8 key, native_uint key_length, pu8 data, native_uint data_length, pu8 siphash, pnative_uint siphash_length);
typedef s32 (__stdcall* Tcrypto_generate_random_bytes)(pu8 data, s32 data_length);
typedef s32 (__stdcall* Tcrypto_crypt_aes_128_ctr)(pu8 key, native_uint key_length, pu8 plaintext, pu8 ciphertext, native_uint text_length, pu8 nonce, native_uint noncelength);
typedef s32 (__stdcall* Tcrypto_verify_rsa)(const s8 key_coding, const u8 hash_method, const u8 rsa_padding_mode, const pu8 data, const native_uint datalength, const pu8 privatekey, const native_uint keylength, const pu8 signature, const native_uint signaturelength);
typedef s32 (__stdcall* Ttls_register_tssocket)(Ttls_rawsocket_get_errno _1, Ttls_rawsocket_close _2, Ttls_rawsocket_recv _3, Ttls_rawsocket_write _4, Ttls_rawsocket_setsockopt _5, Ttls_rawsocket_shutdown _6);
typedef s32 (__stdcall* Ttls_tcp_client_internal)(s32 s, s32 verify_mode, const char* CA_file, const char* CA_path);
typedef s32 (__stdcall* Ttls_tcp_server_internal)(s32 s, const char* cert_file, const char* private_key_file, s32 private_key_type);
typedef s32 (__stdcall* Ttls_connect)(s32 s);
typedef s32 (__stdcall* Ttls_accept)(s32 s);
typedef s32 (__stdcall* Ttls_write)(s32 s, pu8 data, s32 data_size);
typedef s32 (__stdcall* Ttls_read)(s32 s, pu8 data, s32 data_size);
typedef s32 (__stdcall* Ttls_shutdown)(s32 s);
typedef s32 (__stdcall* Ttls_free)(s32 s);
typedef s32 (__stdcall* Tcertificate_load)(pvoid data, native_uint size, PTTSX509_handle_t handle);
typedef s32 (__stdcall* Tcertificate_unload)(TTSX509_handle_t handle);
typedef s32 (__stdcall* Tcertificate_get_version)(TTSX509_handle_t handle, ps32 version);
typedef s32 (__stdcall* Tcertificate_get_subject_name)(TTSX509_handle_t handle, char* out_, pnative_uint out_len);
typedef s32 (__stdcall* Tcertificate_get_issuer_name)(TTSX509_handle_t handle, char* out_, pnative_uint out_len);
typedef s32 (__stdcall* Tcertificate_get_serial_number)(TTSX509_handle_t handle, char* out_, pnative_uint out_len);
typedef s32 (__stdcall* Tcertificate_get_tbs_signature_algorithm)(TTSX509_handle_t handle, char* out_, pnative_uint out_len);
typedef s32 (__stdcall* Tcertificate_get_signature_algorithm)(TTSX509_handle_t handle, char* out_, pnative_uint out_len);
typedef s32 (__stdcall* Tcertificate_get_not_before)(TTSX509_handle_t handle, char* out_, pnative_uint out_len);
typedef s32 (__stdcall* Tcertificate_get_not_after)(TTSX509_handle_t handle, char* out_, pnative_uint out_len);
typedef s32 (__stdcall* Tcertificate_get_pubkey_algorithm)(TTSX509_handle_t handle, char* out_, pnative_uint out_len);
typedef s32 (__stdcall* Tcrypto_crypt_test_ctr)(const char* AInput, const s32 AIdx);
typedef s32 (__stdcall* Tui_graphics_set_split_count)(const char* AWindowCaption, const s32 ACount);
typedef s32 (__stdcall* Tui_graphics_set_y_axis_split_mode)(const char* AWindowCaption, const bool AIsSplitMode);
typedef s32 (__stdcall* Tui_graphics_set_signal_step_style)(const char* AWindowCaption, const s32 AIdxSplit, const char* ASgnName, const bool AIsStepStyle);
typedef s32 (__stdcall* Tcrypto_signature_rsa)(const s8 key_coding, const u8 hash_method, const u8 rsa_padding_mode, const pu8 data, const native_uint datalength, const pu8 privatekey, const native_uint keylength, const pu8 signature, const pnative_uint signaturelength);
typedef s32 (__stdcall* Tregister_app_system_var_module)(const char* AAppModuleName);
typedef s32 (__stdcall* Tunregister_app_system_var_module)(const char* AAppModuleName);
typedef s32 (__stdcall* Tcreate_app_system_var)(const char* AAppModuleName, const char* ACompleteName, const TLIBSystemVarType AType, const char* ADefaultValue, const char* AComment);
typedef s32 (__stdcall* Tdelete_app_system_var)(const char* AAppModuleName, const char* ACompleteName);
typedef s32 (__stdcall* Tui_hide_toolbar)(const char* AWindowCaption);
typedef s32 (__stdcall* Tui_show_toolbar)(const char* AWindowCaption);
typedef s32 (__stdcall* Tui_maximize_form)(const char* AWindowCaption);
typedef s32 (__stdcall* Tui_restore_form)(const char* AWindowCaption);
typedef s32 (__stdcall* Tconfigure_lin_baudrate)(const s32 AChn, const float ABaudrateKbps, const s32 AProtocol);
typedef s32 (__stdcall* Tdb_get_can_network_info_by_index)(const s32 AChn, const char** ANetworkInfo);
typedef s32 (__stdcall* Tdb_get_lin_network_info_by_index)(const s32 AChn, const char** ANetworkInfo);
typedef s32 (__stdcall* Tdb_get_flexray_network_info_by_index)(const s32 AChn, const char** ANetworkInfo);
typedef s32 (__stdcall* Tdb_get_ethernet_network_info_by_index)(const s32 AChn, const char** ANetworkInfo);
typedef s32 (__stdcall* Tdb_get_can_signal_range_json_by_address)(const char* AAdress, const char** AJson);
typedef s32 (__stdcall* Tdb_get_lin_signal_range_json_by_address)(const char* AAdress, const char** AJson);
typedef s32 (__stdcall* Tdb_get_lin_schedule_table_json_by_address)(const char* AAdress, const char** AJson);
typedef s32 (__stdcall* Tdb_get_lin_schedule_tables_json_by_address)(const char* AAdress, const char** AJson);
typedef s32 (__stdcall* Tdb_get_lin_frame_category_json_by_address)(const char* AAdress, const char** AJson);
typedef s32 (__stdcall* Tdb_get_lin_node_mode_json_by_address)(const char* AAdress, const char** AJson);
typedef s32 (__stdcall* Tset_system_var_uint8_array_element)(const char* ACompleteName, const s32 AIdx, const u8 AValue);
typedef s32 (__stdcall* Tget_system_var_uint8_array_element)(const char* ACompleteName, const s32 AIdx, pu8 AValue);
typedef s32 (__stdcall* Tget_system_var_int32_array_element)(const char* ACompleteName, const s32 AIdx, ps32 AValue);
typedef s32 (__stdcall* Tset_system_var_int32_array_element)(const char* ACompleteName, const s32 AIdx, const s32 AValue);
typedef s32 (__stdcall* Tget_system_var_int64_array_element)(const char* ACompleteName, const s32 AIdx, ps64 AValue);
typedef s32 (__stdcall* Tset_system_var_int64_array_element)(const char* ACompleteName, const s32 AIdx, const s64 AValue);
typedef s32 (__stdcall* Tget_system_var_double_array_element)(const char* ACompleteName, const s32 AIdx, pdouble AValue);
typedef s32 (__stdcall* Tset_system_var_double_array_element)(const char* ACompleteName, const s32 AIdx, const double AValue);
typedef s32 (__stdcall* Tget_system_var_type)(const char* ACompleteName, PLIBSystemVarType AType);
typedef s32 (__stdcall* Tmetric_get_can_frame_interval_stat)(const s32 AIdxChn, const u64 AFrameId, const PTSMetricIntegerSnapshot AIdxStat);
typedef s32 (__stdcall* Tmetric_start)(void);
typedef s32 (__stdcall* Tmetric_stop)(void);
typedef s32 (__stdcall* Tmetric_is_running)(pbool AIsRunning);
typedef s32 (__stdcall* Tmetric_register_can_frame_interval)(const s32 AIdxChn, const u64 AFrameId);
typedef s32 (__stdcall* Tmetric_unregister_can_frame_interval)(const s32 AIdxChn, const u64 AFrameId);
typedef s32 (__stdcall* Tmetric_get_w_reset_can_frame_interval_stat)(const s32 AIdxChn, const u64 AFrameId, const PTSMetricIntegerSnapshot AIdxStat);
typedef s32 (__stdcall* Tmetric_reset_can_frame_interval_stat)(const s32 AIdxChn, const u64 AFrameId);
typedef s32 (__stdcall* Tmetric_reset_frames_interval_stat_of_channel)(const TLIBApplicationChannelType ABusType, const s32 AIdxChn);
typedef s32 (__stdcall* Tmetric_reset_frames_interval_stat_of_bus)(const TLIBApplicationChannelType ABusType);
typedef s32 (__stdcall* Tmetric_reset_frames_interval_stat_of_all)(void);
typedef s32 (__stdcall* Ttsai_config_sync)(const s32 AChn, const double ASampleRate, const s32 ASampleBits, const s32 ATimeoutMs);
typedef s32 (__stdcall* Ttsao_config_sync)(const s32 AChn, const s32 AEnableReport, const double ASampleRate, const s32 AOutputValue, const s32 ATimeoutMs);
typedef s32 (__stdcall* Tcall_system_api_w_serialized_args)(const char* AAPIName, const char* ASeparator, const s32 AArgsCapacity, char* AArgs);
typedef s32 (__stdcall* Tcall_library_api_w_serialized_args)(const char* AAPIName, const char* ASeparator, const s32 AArgsCapacity, char* AArgs);
typedef s32 (__stdcall* Tcan_set_load_balance_control)(const s32 AIdxChn, const u8 AIsEnabled, const u32 ADelayUs, const s32 ATimeoutMS);
typedef s32 (__stdcall* Tget_hardware_id_string_upg1)(char** AIDString);
typedef s32 (__stdcall* Tget_hardware_id_array_upg1)(pu8 AArray8B);
typedef s32 (__stdcall* Tget_mapping_property)(const PLIBTSMapping AMapping, const s32 AKey, const char** AValue);
typedef s32 (__stdcall* Tdb_get_can_pdu_properties_by_index)(const PDBPDUProperties AValue);
typedef s32 (__stdcall* Tdb_get_can_pdu_properties_by_address)(const char* AAdress, const PDBPDUProperties AValue);
typedef s32 (__stdcall* Tdb_resolve_can_signal_address)(const char* AAddress, const bool AIsTx, char* AFullAddress, const ps32 AFullAddressCapacity);
typedef s32 (__stdcall* Tdb_resolve_can_message_address)(const char* AAddress, const bool AIsTx, char* AFullAddress, const ps32 AFullAddressCapacity);
typedef s32 (__stdcall* Tdb_resolve_lin_signal_address)(const char* AAddress, const bool AIsTx, char* AFullAddress, const ps32 AFullAddressCapacity);
typedef s32 (__stdcall* Tdb_resolve_lin_message_address)(const char* AAddress, const bool AIsTx, char* AFullAddress, const ps32 AFullAddressCapacity);
typedef s32 (__stdcall* Tdb_resolve_flexray_signal_address)(const char* AAddress, const bool AIsTx, char* AFullAddress, const ps32 AFullAddressCapacity);
typedef s32 (__stdcall* Tdb_resolve_flexray_message_address)(const char* AAddress, const bool AIsTx, char* AFullAddress, const ps32 AFullAddressCapacity);
typedef s32 (__stdcall* Tdb_resolve_ethernet_signal_address)(const char* AAddress, const bool AIsTx, char* AFullAddress, const ps32 AFullAddressCapacity);
typedef s32 (__stdcall* Tdb_resolve_ethernet_pdu_address)(const char* AAddress, const bool AIsTx, char* AFullAddress, const ps32 AFullAddressCapacity);
typedef s32 (__stdcall* Tdb_get_flexray_pdu_properties_by_address)(const char* AAdress, const PDBPDUProperties AValue);
typedef s32 (__stdcall* Tdb_get_flexray_pdu_properties_by_index)(const PDBPDUProperties AValue);
typedef s32 (__stdcall* Tregister_system_var_pre_read_event)(const char* ACompleteName, TOnSystemVarPreReadEvent AEvent);
typedef s32 (__stdcall* Tunregister_system_var_pre_read_event)(const char* ACompleteName, TOnSystemVarPreReadEvent AEvent);
typedef s32 (__stdcall* Tunregister_system_var_pre_read_events)(void);
typedef s32 (__stdcall* Ttransmit_lin_wakeup_async)(const s32 AIdxChn, const s32 AWakeupLength, const s32 AWakeupIntervalTime, const s32 AWakeupTimes);
typedef s32 (__stdcall* Ttransmit_lin_gotosleep_async)(const s32 AIdxChn);
typedef s32 (__stdcall* Tam_get_name_by_index)(const s32 AIndex, char** AName);
typedef s32 (__stdcall* Tam_get_sub_module_count)(const pchar AModuleName, ps32 ACount);
typedef s32 (__stdcall* Tam_get_sub_module_name_by_index)(const pchar AModuleName, const s32 AIndex, char** ASubModuleName, char** ADisplayName);
typedef s32 (__stdcall* Tam_get_sub_module_info)(const pchar AModuleName, const pchar ASubModuleName, pvoid AInfo);
typedef s32 (__stdcall* Tam_find_sub_module)(const pchar AModuleName, const pchar ASubModuleName, ps32 AIndex);
typedef s32 (__stdcall* Tam_get_sub_module_running_state)(const pchar AModuleName, const pchar ASubModuleName, PAutomationModuleRunningState AState);
typedef s32 (__stdcall* Tam_get_variant_group_count)(const pchar AModuleName, const pchar ASubModuleName, ps32 ACount);
typedef s32 (__stdcall* Tam_get_variant_group_name_by_index)(const pchar AModuleName, const pchar ASubModuleName, const s32 AIndex, char** AGroupName, char** AComment, pbool ASelected);
typedef s32 (__stdcall* Tam_add_variant_group)(const pchar AModuleName, const pchar ASubModuleName, const pchar AGroupName, const pchar AComment);
typedef s32 (__stdcall* Tam_delete_variant_group)(const pchar AModuleName, const pchar ASubModuleName, const pchar AGroupName);
typedef s32 (__stdcall* Tam_get_variant_count)(const pchar AModuleName, const pchar ASubModuleName, const pchar AGroupName, ps32 ACount);
typedef s32 (__stdcall* Tam_get_variant_by_index)(const pchar AModuleName, const pchar ASubModuleName, const pchar AGroupName, const s32 AIndex, char** AArgName, char** AArgValue, char** AComment);
typedef s32 (__stdcall* Tam_set_variant_value)(const pchar AModuleName, const pchar ASubModuleName, const pchar AGroupName, const pchar AArgName, const pchar AArgValue);
typedef s32 (__stdcall* Tam_select_variant_group)(const pchar AModuleName, const pchar ASubModuleName, const pchar AGroupName, const bool AIsSelect);
typedef s32 (__stdcall* Tam_get_local_var_count)(const pchar AModuleName, const pchar ASubModuleName, ps32 ACount);
typedef s32 (__stdcall* Tam_get_local_var_by_index)(const pchar AModuleName, const pchar ASubModuleName, const s32 AIndex, char** AName, PLIBSimVarType AType, char** AInitValue, char** AComment);
typedef s32 (__stdcall* Tam_compile_current)(const pchar AModuleName, const pchar ASubModuleName);
typedef s32 (__stdcall* Tam_compile_all)(const pchar AModuleName);
typedef s32 (__stdcall* Tam_pause)(const pchar AModuleName);
typedef s32 (__stdcall* Tam_continue)(const pchar AModuleName);
typedef s32 (__stdcall* Tam_step_over)(const pchar AModuleName);
typedef s32 (__stdcall* Tam_step_into)(const pchar AModuleName);
typedef s32 (__stdcall* Tam_get_progress)(const pchar AModuleName, pfloat AProgress100);
typedef s32 (__stdcall* Tam_get_execution_result)(const pchar AModuleName, const pchar ASubModuleName, ps32 AResult);
typedef s32 (__stdcall* Tam_get_variant_group_result)(const pchar AModuleName, const pchar ASubModuleName, const pchar AGroupName, ps32 AResult);
typedef s32 (__stdcall* Tam_run_all_checked)(const pchar AModuleName, const bool AIsSync);
typedef s32 (__stdcall* Tam_run_all)(const pchar AModuleName, const bool AIsSync);
typedef s32 (__stdcall* Tam_move_sub_module)(const pchar AModuleName, const s32 ASrcIndex, const s32 ADstIndex);
typedef s32 (__stdcall* Tam_export_sub_module)(const pchar AModuleName, const pchar ASubModuleName, const pchar ADestFileName);
typedef s32 (__stdcall* Tam_export_sub_modules)(const pchar AModuleName, const char** ASubModuleNames, const s32 ACount, const pchar ADestFileName);
typedef s32 (__stdcall* Tam_import_sub_module)(const pchar AModuleName, const pchar ASrcFileName, ps32 AImportedCount, char** ALastImportedSubModuleName);
typedef s32 (__stdcall* Tam_export_excel)(const pchar AModuleName, const pchar ASubModuleName, const pchar ADestFileName);
typedef s32 (__stdcall* Tam_import_excel)(const pchar AModuleName, const pchar ASrcFileName, char** AImportedGraphicProgramName, char** AImportedSubModuleName);
typedef s32 (__stdcall* Tam_save_configuration)(const pchar AModuleName, const pchar ADestFileName);
typedef s32 (__stdcall* Tam_load_configuration)(const pchar AModuleName, const pchar ASrcFileName);
typedef s32 (__stdcall* Tam_get_current_log_dir)(const pchar AModuleName, char** ALogDir);
typedef s32 (__stdcall* Tam_get_overall_result)(const pchar AModuleName, ps32 AResult);
typedef s32 (__stdcall* Tam_clear_results)(const pchar AModuleName);
typedef s32 (__stdcall* Tam_add_sub_module)(const pchar AModuleName, const pchar ASubModuleName, const pchar ADisplayName, char** ACreatedSubModuleName);
typedef s32 (__stdcall* Tam_delete_sub_module)(const pchar AModuleName, const pchar ASubModuleName);
typedef s32 (__stdcall* Tam_delete_all_sub_modules)(const pchar AModuleName);
typedef s32 (__stdcall* Tam_set_editor_locked)(const pchar AModuleName, const bool ALocked);
typedef s32 (__stdcall* Tam_get_editor_locked)(const pchar AModuleName, pbool ALocked);
typedef s32 (__stdcall* Tam_get_count)(ps32 ACount);
typedef s32 (__stdcall* Tget_system_var_app_def_by_index)(const char* AAppName, const s32 AIndex, PLIBSystemVarDef AVarDef);
typedef s32 (__stdcall* Tget_system_var_app_def_by_name)(const char* AAppName, const char* ACompleteName, PLIBSystemVarDef AVarDef);
typedef s32 (__stdcall* Tget_system_var_app_count)(const char* AAppName, s32* ACount);
typedef s32 (__stdcall* Tgpg_begin_batch_import)(void);
typedef s32 (__stdcall* Tgpg_end_batch_import)(void);
typedef s32 (__stdcall* Tgpg_set_module_execution_record_options)(const pchar AModuleName, const u32 AOptionMask, const s32 AEnableLog, const s32 ALogFlowchart, const s32 ALogScreen, const s32 AInclSgnLog, const s32 ASaveInOneDir, const s32 AUseDefaultLogDir, const char* ALogLocation, const s32 AApplyImmediately, pu32 AChangedMask);
typedef s32 (__stdcall* Tam_select_sub_module_verbose)(const bool AIsSelect, const char* AModuleName, const char* ASubModuleDisplayName, const char* AParameterGroupName);
typedef s32 (__stdcall* TTSAppSetA429ChannelCount)(const s32 ACount);
typedef s32 (__stdcall* TTSAppGetA429ChannelCount)(s32* ACount);
typedef s32 (__stdcall* TTSAppGetA429ChannelCapability)(const s32 AIdxChn, PLIBA429ChannelCapability ACapability);
typedef s32 (__stdcall* TTSAppConfigureA429Tx)(const PLIBA429TxConfig AConfig);
typedef s32 (__stdcall* TTSAppConfigureA429Rx)(const PLIBA429RxConfig AConfig);
typedef s32 (__stdcall* TTSAppGetA429TxConfig)(const s32 AIdxChn, PLIBA429TxConfig AConfig);
typedef s32 (__stdcall* TTSAppGetA429RxConfig)(const s32 AIdxChn, PLIBA429RxConfig AConfig);
typedef s32 (__stdcall* TTSAppStartA429Channel)(const s32 AIdxChn);
typedef s32 (__stdcall* TTSAppStopA429Channel)(const s32 AIdxChn);
typedef s32 (__stdcall* Tload_code_file_to_ccode_editor)(const char* AEditorDisplayName, const char* AFilePath, const bool ACreateIfEditorNotReady);
typedef s32 (__stdcall* Tload_code_file_to_python_editor)(const char* AEditorDisplayName, const char* AFilePath, const bool ACreateIfEditorNotReady);
typedef s32 (__stdcall* Tconfigure_ethernet_parameter_ex)(const s32 AIdxChn, const s32 AEnabled, const s32 APhyType, const s32 AIsMaster, const s32 AIsAutoNegotiation, const s32 ASpeedType, const s32 ALoopModeType, const s32 AByPassMode, const char* AMacAddress, const s32 AEnableLayer2Switch);
// >>> mp app prototype end <<<

typedef struct _TTSApp {
    void*                                          FObj;
    // >>> mp app start <<<     
    TTSAppSetCurrentApplication                    set_current_application;
    TTSAppGetCurrentApplication                    get_current_application;
    TTSAppDelApplication                           del_application;
    TTSAppAddApplication                           add_application;
    TTSAppGetApplicationList                       get_application_list;
    TTSAppSetCANChannelCount                       set_can_channel_count;
    TTSAppSetLINChannelCount                       set_lin_channel_count;
    TTSAppGetCANChannelCount                       get_can_channel_count;
    TTSAppGetLINChannelCount                       get_lin_channel_count;
    TTSAppSetMapping                               set_mapping;
    TTSAppGetMapping                               get_mapping;
    TTSAppDeleteMapping                            del_mapping;
    TTSAppConnectApplication                       connect;
    TTSAppDisconnectApplication                    internal_disconnect;
    TTSAppLogger                                   log_text;
    TTSAppConfigureBaudrateCAN                     configure_can_baudrate;
    TTSAppConfigureBaudrateCANFD                   configure_canfd_baudrate;
    TTSAppSetTurboMode                             set_turbo_mode;
    TTSAppGetTurboMode                             get_turbo_mode;
    TTSAppGetErrorDescription                      get_error_description;
    TTSAppTerminate                                internal_terminate_application;
    TTSWaitTime                                    internal_wait;                 
    TTSCheckError                                  internal_check;                
    TTSStartLog                                    internal_start_log;            
    TTSEndLog                                      internal_end_log;              
    TTSCheckTerminate                              internal_check_terminate;      
    TTSGetTimestampUs                              get_timestamp;
    TTSShowConfirmDialog                           show_confirm_dialog;
    TTSPause                                       pause;
    TTSSetCheckFailedTerminate                     internal_set_check_failed_terminate;
    TTSAppGetSystemVarCount                        get_system_var_count;
    TTSAppGetSystemVarDefByIndex                   get_system_var_def_by_index;
    TTSAppFindSystemVarDefByName                   get_system_var_def_by_name;
    TTSAppGetSystemVarDouble                       get_system_var_double;
    TTSAppGetSystemVarInt32                        get_system_var_int32;
    TTSAppGetSystemVarUInt32                       get_system_var_uint32;
    TTSAppGetSystemVarInt64                        get_system_var_int64;
    TTSAppGetSystemVarUInt64                       get_system_var_uint64;
    TTSAppGetSystemVarUInt8Array                   get_system_var_uint8_array;
    TTSAppGetSystemVarInt32Array                   get_system_var_int32_array;
    TTSAppGetSystemVarInt64Array                   get_system_var_int64_array;
    TTSAppGetSystemVarDoubleArray                  get_system_var_double_array;
    TTSAppGetSystemVarString                       get_system_var_string;
    TTSAppSetSystemVarDouble                       set_system_var_double;
    TTSAppSetSystemVarInt32                        set_system_var_int32;
    TTSAppSetSystemVarUInt32                       set_system_var_uint32;
    TTSAppSetSystemVarInt64                        set_system_var_int64;
    TTSAppSetSystemVarUInt64                       set_system_var_uint64;
    TTSAppSetSystemVarUInt8Array                   set_system_var_uint8_array;
    TTSAppSetSystemVarInt32Array                   set_system_var_int32_array;
    TTSAppSetSystemVarInt64Array                   set_system_var_int64_array;
    TTSAppSetSystemVarDoubleArray                  set_system_var_double_array;
    TTSAppSetSystemVarString                       set_system_var_string;
    TTSAppMakeToast                                make_toast;
    TTSAppExecutePythonString                      execute_python_string;
    TTSAppExecutePythonScript                      execute_python_script;
    TTSAppExecuteApp                               execute_app;
    TTSAppTerminateAppByName                       terminate_app_by_name;
    Texcel_load                                    excel_load           ;
    Texcel_get_sheet_count                         excel_get_sheet_count;
    Texcel_set_sheet_count                         excel_set_sheet_count;
    Texcel_get_sheet_name                          excel_get_sheet_name ;
    Texcel_get_cell_count                          excel_get_cell_count ;
    Texcel_get_cell_value                          excel_get_cell_value ;
    Texcel_set_cell_count                          excel_set_cell_count ;
    Texcel_set_cell_value                          excel_set_cell_value ;
    Texcel_unload                                  excel_unload         ;
    Texcel_unload_all                              excel_unload_all     ;
    TTSAppLogSystemVar                             log_system_var       ;
    Texcel_set_sheet_name                          excel_set_sheet_name ;
    TTSAppCallMPAPI                                call_mini_program_api;
    TTSAppSplitString                              split_string         ;
    TTSAppWaitSystemVarExistance                   wait_system_var_existance;
    TTSAppWaitSystemVarDisappear                   wait_system_var_disappear;
    TTSAppSetAnalysisTimeRange                     set_analysis_time_range;
    TTSAppGetConfigurationFileName                 get_configuration_file_name;
    TTSAppGetConfigurationFilePath                 get_configuration_file_path;
    TTSAppSetDefaultOutputDir                      set_default_output_dir;
    TTSAppSaveScreenshot                           save_screenshot;
    TTSAppEnableAllGraphics                        enable_all_graphics;
    TTSAppGetTSMasterVersion                       get_tsmaster_version;
    TUIShowPageByIndex                             ui_show_page_by_index;
    TUIShowPageByName                              ui_show_page_by_name;
    TWriteRealtimeComment                          internal_write_realtime_comment;
    TTSAppSetThreadPriority                        internal_set_thread_priority;
    TTSAppGetSystemVarGerneric                     get_system_var_generic;
    TTSAppSetSystemVarGeneric                      set_system_var_generic;
    TWriteTextFileStart                            write_text_file_start;
    TWriteTextFileLine                             write_text_file_line;
    TWriteTextFileLineWithDoubleArray              write_text_file_line_double_array;
    TWriteTextFileLineWithStringArray              write_text_file_line_string_array;
    TWriteTextFileEnd                              write_text_file_end;
    TTSAppForceDirectory                           force_directory;
    TTSAppDirectoryExists                          directory_exists;
    TTSAppOpenDirectoryAndSelectFile               open_directory_and_select_file;
    TTSMiniDelayCPU                                mini_delay_cpu;
    TTSWaitSystemVariable                          wait_system_var;
    TWriteMatFileStart                             write_mat_file_start;
    TWriteMatFileVariableDouble                    write_mat_file_variable_double;
    TWriteMatFileVariableString                    write_mat_file_variable_string;
    TWriteMatFileVariableDoubleArray               write_mat_file_variable_double_array;
    TWriteMatFileEnd                               write_mat_file_end;
    TReadMatFileStart                              read_mat_file_start;
    TReadMatFileVariableCount                      read_mat_file_variable_count;
    TReadMatFileVariableString                     read_mat_file_variable_string;
    TReadMatFileVariableDouble                     read_mat_file_variable_double;
    TReadMatFileEnd                                read_mat_file_end;
    TPromptUserInputValue                          prompt_user_input_value;
    TPromptUserInputString                         prompt_user_input_string;
    TIniCreate                                     ini_create;
    TIniWriteInt32                                 ini_write_int32;
    TIniWriteInt64                                 ini_write_int64;
    TIniWriteBool                                  ini_write_bool;
    TIniWriteFloat                                 ini_write_float;
    TIniWriteString                                ini_write_string;
    TIniReadInt32                                  ini_read_int32;
    TIniReadInt64                                  ini_read_int64;
    TIniReadBool                                   ini_read_bool;
    TIniReadFloat                                  ini_read_float;
    TIniReadString                                 ini_read_string;
    TIniSectionExists                              ini_section_exists;
    TIniKeyExists                                  ini_key_exists;
    TIniDeleteKey                                  ini_delete_key;
    TIniDeleteSection                              ini_delete_section;
    TIniClose                                      ini_close;
    TTSAppMakeToastUntil                           make_toast_until;
    TTSAppMakeToastWithCallback                    make_toast_with_callback;
    TTSAppGetDocPath                               get_doc_path;
    TTSAppGetHWIDString                            get_hardware_id_string;
    TTSAppGetHWIDArray                             get_hardware_id_array;
    TTSAppCreateSystemVar                          create_system_var;
    TTSAppDeleteSystemVar                          delete_system_var;
    TTSAppRunForm                                  run_form;
    TTSAppStopForm                                 stop_form;
    TReadTextFileStart                             read_text_file_start;
    TReadTextFileLine                              read_text_file_line;
    TReadTextFileEnd                               read_text_file_end;
    TPlaySound                                     play_sound;
    TTSAppSetSystemVarUnit                         set_system_var_unit;
    TTSAppSetSystemVarValueTable                   set_system_var_value_table;
    TUILoadPlugin                                  load_plugin;
    TUIUnloadPlugin                                unload_plugin;
    TTSAppSetSystemVarDoubleAsync                  set_system_var_double_async;
    TTSAppSetSystemVarInt32Async                   set_system_var_int32_async;
    TTSAppSetSystemVarUInt32Async                  set_system_var_uint32_async;
    TTSAppSetSystemVarInt64Async                   set_system_var_int64_async;
    TTSAppSetSystemVarUInt64Async                  set_system_var_uint64_async;
    TTSAppSetSystemVarUInt8ArrayAsync              set_system_var_uint8_array_async;
    TTSAppSetSystemVarInt32ArrayAsync              set_system_var_int32_array_async;
    TTSAppSetSystemVarInt64ArrayAsync              set_system_var_int64_array_async;
    TTSAppSetSystemVarDoubleArrayAsync             set_system_var_double_array_async;
    TTSAppSetSystemVarStringAsync                  set_system_var_string_async;
    TTSAppSetSystemVarGenericAsync                 set_system_var_generic_async;
    TAMGetRunningState                             am_get_running_state;
    TAMRun                                         am_run;
    TAMStop                                        am_stop;
    TAMSelectSubModule                             am_select_sub_module;
    TPanelSetEnable                                panel_set_enable;
    TPanelSetPositionX                             panel_set_position_x;
    TPanelSetPositionY                             panel_set_position_y;
    TPanelSetPositionXY                            panel_set_position_xy;
    TPanelSetOpacity                               panel_set_opacity;
    TPanelSetWidth                                 panel_set_width;
    TPanelSetHeight                                panel_set_height;
    TPanelSetWidthHeight                           panel_set_width_height;
    TPanelSetRotationAngle                         panel_set_rotation_angle;
    TPanelSetRotationCenter                        panel_set_rotation_center;
    TPanelSetScaleX                                panel_set_scale_x;
    TPanelSetScaleY                                panel_set_scale_y;
    TPanelGetEnable                                panel_get_enable;
    TPanelGetPositionXY                            panel_get_position_xy;
    TPanelGetOpacity                               panel_get_opacity;
    TPanelGetWidthHeight                           panel_get_width_height;
    TPanelGetRotationAngle                         panel_get_rotation_angle;
    TPanelGetRotationCenter                        panel_get_rotation_center;
    TPanelGetScaleXY                               panel_get_scale_xy;
    TSTIMSetSignalStatus                           stim_set_signal_status;
    TSTIMGetSignalStatus                           stim_get_signal_status;
    TPanelSetBkgdColor                             panel_set_bkgd_color;
    TPanelGetBkgdColor                             panel_get_bkgd_color;
    TClearMeasurementForm                          clear_measurement_form;
    TTSAppGetSystemVarAddress                      get_system_var_address;
    TTSAppSetSystemVarLogging                      set_system_var_logging;
    TTSAppGetSystemVarLogging                      get_system_var_logging;
    TTSAppLogSystemVarValue                        internal_log_system_var_value;
    TUIGetMainWindowHandle                         get_main_window_handle;
    TPrintDeltaTime                                print_delta_time;
    TAtomicIncrement32                             atomic_increment32;
    TAtomicIncrement64                             atomic_increment64;
    TAtomicSet32                                   atomic_set_32;
    TAtomicSet64                                   atomic_set_64;
    TGetConstantDouble                             get_constant_double;
    TAddDirectMappingCAN                           add_direct_mapping_can;
    TAddExpressionMapping                          add_expression_mapping;
    TDeleteSymbolMappingItem                       delete_symbol_mapping_item;
    TEnableSymbolMappingItem                       enable_symbol_mapping_item;
    TEnableSymbolMappingEngine                     enable_symbol_mapping_engine;
    TDeleteSymbolMappingItems                      delete_symbol_mapping_items;
    TSaveSymbolMappingSettings                     save_symbol_mapping_settings;
    TLoadSymbolMappingSettings                     load_symbol_mapping_settings;
    TAddDirectMappingWithFactorOffsetCAN           add_direct_mapping_with_factor_offset_can;
    TTSDebugLog                                    internal_debug_log;
    TWaitWithDialog                                internal_wait_with_dialog;
    TTSAppIsConnected                              is_connected;
    TTSAppGetFlexRayChannelCount                   get_flexray_channel_count;
    TTSAppSetFlexRayChannelCount                   set_flexray_channel_count;
    TDBGetCANDBCount                               db_get_can_database_count;
    TDBGetLINDBCount                               db_get_lin_database_count;
    TDBGetFlexRayDBCount                           db_get_flexray_database_count;
    TDBGetCANDBPropertiesByIndex                   db_get_can_database_properties_by_index;
    TDBGetLINDBPropertiesByIndex                   db_get_lin_database_properties_by_index;
    TDBGetFlexRayDBPropertiesByIndex               db_get_flexray_database_properties_by_index;
    TDBGetCANDBECUPropertiesByIndex                db_get_can_ecu_properties_by_index;
    TDBGetLINDBECUPropertiesByIndex                db_get_lin_ecu_properties_by_index;
    TDBGetFlexRayDBECUPropertiesByIndex            db_get_flexray_ecu_properties_by_index;
    TDBGetCANDBFramePropertiesByIndex              db_get_can_frame_properties_by_index;
    TDBGetLINDBFramePropertiesByIndex              db_get_lin_frame_properties_by_index;
    TDBGetFlexRayDBFramePropertiesByIndex          db_get_flexray_frame_properties_by_index;
    TDBGetCANDBSignalPropertiesByIndex             db_get_can_signal_properties_by_index;
    TDBGetLINDBSignalPropertiesByIndex             db_get_lin_signal_properties_by_index;
    TDBGetFlexRayDBSignalPropertiesByIndex         db_get_flexray_signal_properties_by_index;
    TDBGetCANDBPropertiesByAddress                 db_get_can_database_properties_by_address;
    TDBGetLINDBPropertiesByAddress                 db_get_lin_database_properties_by_address;
    TDBGetFlexRayDBPropertiesByAddress             db_get_flexray_database_properties_by_address;
    TDBGetCANDBECUPropertiesByAddress              db_get_can_ecu_properties_by_address;
    TDBGetLINDBECUPropertiesByAddress              db_get_lin_ecu_properties_by_address;
    TDBGetFlexRayDBECUPropertiesByAddress          db_get_flexray_ecu_properties_by_address;
    TDBGetCANDBFramePropertiesByAddress            db_get_can_frame_properties_by_address;
    TDBGetLINDBFramePropertiesByAddress            db_get_lin_frame_properties_by_address;
    TDBGetFlexRayDBFramePropertiesByAddress        db_get_flexray_frame_properties_by_address;
    TDBGetCANDBSignalPropertiesByAddress           db_get_can_signal_properties_by_address;
    TDBGetLINDBSignalPropertiesByAddress           db_get_lin_signal_properties_by_address;
    TDBGetFlexRayDBSignalPropertiesByAddress       db_get_flexray_signal_properties_by_address;
    TRunPythonFunction                             run_python_function;
    TGetCurrentMpName                              internal_get_current_mp_name;
    TPanelSetSelectorItems                         panel_set_selector_items;
    TPanelGetSelectorItems                         panel_get_selector_items;
    TGetSystemConstantCount                        get_system_constant_count;
    TGetSystemConstantValueByIndex                 get_system_constant_value_by_index;
    TDBGetCANDBFramePropertiesByDBIndex            db_get_can_frame_properties_by_db_index;
    TDBGetLINDBFramePropertiesByDBIndex            db_get_lin_frame_properties_by_db_index;
    TDBGetFlexRayDBFramePropertiesByDBIndex        db_get_flexray_frame_properties_by_db_index;
    TDBGetCANDBSignalPropertiesByDBIndex           db_get_can_signal_properties_by_db_index;
    TDBGetLINDBSignalPropertiesByDBIndex           db_get_lin_signal_properties_by_db_index;
    TDBGetFlexRayDBSignalPropertiesByDBIndex       db_get_flexray_signal_properties_by_db_index;
    TDBGetCANDBSignalPropertiesByFrameIndex        db_get_can_signal_properties_by_frame_index;
    TDBGetLINDBSignalPropertiesByFrameIndex        db_get_lin_signal_properties_by_frame_index;
    TDBGetFlexRayDBSignalPropertiesByFrameIndex    db_get_flexray_signal_properties_by_frame_index;
    TAddSystemConstant                             add_system_constant;
    TDeleteSystemConstant                          delete_system_constant;
    TDBGetFlexRayClusterParameters                 db_get_flexray_cluster_parameters;
    TDBGetFlexRayControllerParameters              db_get_flexray_controller_parameters;
    TSetSystemVarEventSupport                      set_system_var_event_support;
    TGetSystemVarEventSupport                      get_system_var_event_support;
    TGetDateTime                                   get_date_time;    
    TGPGDeleteAllModules gpg_delete_all_modules;
    TGPGCreateModule gpg_create_module;
    TGPGDeleteModule gpg_delete_module;
    TGPGDeployModule gpg_deploy_module;
    TGPGAddActionDown gpg_add_action_down;
    TGPGAddActionRight gpg_add_action_right;
    TGPGAddGoToDown gpg_add_goto_down;
    TGPGAddGoToRight gpg_add_goto_right;
    TGPGAddFromDown gpg_add_from_down;
    TGPGAddGroupDown gpg_add_group_down;
    TGPGAddGroupRight gpg_add_group_right;
    TGPGDeleteAction gpg_delete_action;
    TGPGSetActionNOP gpg_set_action_nop;
    TGPGSetActionSignalReadWrite gpg_set_action_signal_read_write;
    TGPGSetActionAPICall gpg_set_action_api_call;
    TGPGSetActionExpression gpg_set_action_expression;
    TGPGConfigureActionBasic gpg_configure_action_basic;
    TGPGConfigureGoTo gpg_configure_goto;
    TGPGConfigureFrom gpg_configure_from;
    TGPGConfigureNOP gpg_configure_nop;
    TGPGConfigureGroup gpg_configure_group;
    TGPGConfigureSignalReadWriteListClear gpg_configure_signal_read_write_list_clear;
    TGPGConfigureSignalWriteListAppend gpg_configure_signal_write_list_append;
    TGPGConfigureSignalReadListAppend gpg_configure_signal_read_list_append;
    TGPGConfigureAPICallArguments gpg_configure_api_call_arguments;
    TGPGConfigureAPICallResult gpg_configure_api_call_result;
    TGPGConfigureExpression gpg_configure_expression;
    TGPGAddLocalVar gpg_add_local_var;
    TGPGDeleteLocalVar gpg_delete_local_var;
    TGPGDeleteAllLoalVars gpg_delete_all_local_vars;
    TGPGDeleteGroupItems gpg_delete_group_items;
    TGPGConfigureSignalReadWriteListDelete gpg_configure_signal_read_write_list_delete;
    TGPGConfigureModule gpg_configure_module;
    TUIShowWindow ui_show_window;
    TUIGraphicsLoadConfiguration ui_graphics_load_configuration;
    TUIWatchdogEnable ui_watchdog_enable;
    TUIWatchdogFeed ui_watchdog_feed;
    TAddPathToEnvironment add_path_to_environment;
    TDeletePathFromEnvironment delete_path_from_environment;
    TTSAppSetSystemVarDoubleWTime set_system_var_double_w_time;
    TTSAppSetSystemVarInt32WTime set_system_var_int32_w_time;
    TTSAppSetSystemVarUInt32WTime set_system_var_uint32_w_time;
    TTSAppSetSystemVarInt64WTime set_system_var_int64_w_time;
    TTSAppSetSystemVarUInt64WTime set_system_var_uint64_w_time;
    TTSAppSetSystemVarUInt8ArrayWTime set_system_var_uint8_array_w_time;
    TTSAppSetSystemVarInt32ArrayWTime set_system_var_int32_array_w_time;
    TTSAppSetSystemVarDoubleArrayWTime set_system_var_double_array_w_time;
    TTSAppSetSystemVarStringWTime set_system_var_string_w_time;
    TTSAppSetSystemVarGenericWTime set_system_var_generic_w_time;
    TTSAppSetSystemVarDoubleAsyncWTime set_system_var_double_async_w_time;
    TTSAppSetSystemVarInt32AsyncWTime set_system_var_int32_async_w_time;
    TTSAppSetSystemVarUInt32AsyncWTime set_system_var_uint32_async_w_time;
    TTSAppSetSystemVarInt64AsyncWTime set_system_var_int64_async_w_time;
    TTSAppSetSystemVarUInt64AsyncWTime set_system_var_uint64_async_w_time;
    TTSAppSetSystemVarUInt8ArrayAsyncWTime set_system_var_uint8_array_async_w_time;
    TTSAppSetSystemVarInt32ArrayAsyncWTime set_system_var_int32_array_async_w_time;
    TTSAppSetSystemVarInt64ArrayAsyncWTime set_system_var_int64_array_async_w_time;
    TTSAppSetSystemVarDoubleArrayAsyncWTime set_system_var_double_array_async_w_time;
    TTSAppSetSystemVarStringAsyncWTime set_system_var_string_async_w_time;
    TTSAppSetSystemVarGenericAsyncWTime set_system_var_generic_async_w_time;
    TDBGetSignalStartBitByPDUOffset db_get_signal_startbit_by_pdu_offset;
    TUIShowSaveFileDialog ui_show_save_file_dialog;
    TUIShowOpenFileDialog ui_show_open_file_dialog;
    TUIShowSelectDirectoryDialog ui_show_select_directory_dialog;
    TSetEthernetChannelCount set_ethernet_channel_count;
    TGetEthernetChannelCount get_ethernet_channel_count;
    TDBGetCANDBIndexById db_get_can_db_index_by_id;
    TDBGetLINDBIndexById db_get_lin_db_index_by_id;
    TDBGetFlexRayDBIndexById db_get_flexray_db_index_by_id;
    TRegisterSystemVarChangeEvent internal_register_system_var_change_event;
    TUnRegisterSystemVarChangeEvent internal_unregister_system_var_change_event;
    TUnRegisterSystemVarChangeEvents internal_unregister_system_var_change_events;
    TCallSystemAPI call_system_api;
    TCallLibraryAPI call_library_api;
    TIniReadStringWoQuotes ini_read_string_wo_quotes;
    TUIGraphicsAddSignal ui_graphics_add_signal;
    TUIGraphicsClearSignals ui_graphics_clear_signals;
    TGPGLoadExcel gpg_load_excel;
    TRunProcedure run_in_main_thread;
    TOpenHelpDoc open_help_doc;
    TGetLangString get_language_string;
    TConvertBlfToCsv convert_blf_to_csv;
    TConvertBlfToCsvWFilter convert_blf_to_csv_with_filter;
    TStartLogWFileName internal_start_log_w_filename;
    TConvertBlfToMatWFilter convert_blf_to_mat_w_filter;
    TConvertASCToMatWFilter convert_asc_to_mat_w_filter;
    TConvertASCToCSVWFilter convert_asc_to_csv_w_filter;
    TSetDebugLogLevel set_debug_log_level;
    TGetFormUniqueId get_form_unique_id;
    Tpanel_clear_control panel_clear_control;
    Tset_form_unique_id set_form_unique_id;
    Tshow_form show_form;
    Tkill_form kill_form;
    Tplace_form place_form;
    Ttoggle_mdi_form toggle_mdi_form;
    Tget_language_id get_language_id;
    Tcreate_form create_form;
    Tset_form_caption set_form_caption;
    Tenter_critical_section internal_enter_critical_section;
    Tleave_critical_section internal_leave_critical_section;
    Ttry_enter_critical_section internal_try_enter_critical_section;
    Tdb_load_can_db db_load_can_db;
    Tdb_load_lin_db db_load_lin_db;
    Tdb_load_flexray_db db_load_flexray_db;
    Tdb_unload_can_db db_unload_can_db;
    Tdb_unload_lin_db db_unload_lin_db;
    Tdb_unload_flexray_db db_unload_flexray_db;
    Tdb_unload_can_dbs db_unload_can_dbs;
    Tdb_unload_lin_dbs db_unload_lin_dbs;
    Tdb_unload_flexray_dbs db_unload_flexray_dbs;
    TSecurityUpdateNewKeySync security_update_new_key_sync;
    TSecurityUnlockWriteAuthoritySync security_unlock_write_authority_sync;
    TSecurityUnlockWriteAuthorityASync security_unlock_write_authority_async;
    TSecurityWriteStringSync security_write_string_sync;
    TSecurityWriteStringASync security_write_string_async;
    TSecurityReadStringSync security_read_string_sync;
    TSecurityUnlockEncChannelSync security_unlock_encrypt_channel_sync;
    TSecurityUnlockEncChannelASync security_unlock_encrypt_channel_async;
    TSecurityEncryptStringSync security_encrypt_string_sync;
    TSecurityDecryptStringSync security_decrypt_string_sync;
    Tset_channel_timestamp_deviation_factor set_channel_timestamp_deviation_factor;
    Tstart_system_message_log internal_start_system_message_log;
    Tend_system_message_log internal_end_system_message_log;
    Tmask_fpu_exceptions mask_fpu_exceptions;
    Tcreate_process_shared_memory create_process_shared_memory;
    Tget_process_shared_memory get_process_shared_memory;
    Tclear_user_constants clear_user_constants;
    Tappend_user_constants_from_c_header append_user_constants_from_c_header;
    Tappend_user_constant append_user_constant;
    Tdelete_user_constant delete_user_constant;
    Tget_mini_program_count get_mini_program_count;
    Tget_mini_program_info_by_index get_mini_program_info_by_index;
    Tcompile_mini_programs compile_mini_programs;
    Tset_system_var_init_value set_system_var_init_value;
    Tget_system_var_init_value get_system_var_init_value;
    Treset_system_var_to_init reset_system_var_to_init;
    Treset_all_system_var_to_init reset_all_system_var_to_init;
    Tget_system_var_generic_upg1 get_system_var_generic_upg1;
    Tmplib_load mplib_load;
    Tmplib_unload mplib_unload;
    Tmplib_unload_all mplib_unload_all;
    Tmplib_run mplib_run;
    Tmplib_is_running mplib_is_running;
    Tmplib_stop mplib_stop;
    Tmplib_run_all mplib_run_all;
    Tmplib_stop_all mplib_stop_all;
    Tmplib_get_function_prototype mplib_get_function_prototype;
    Tmplib_get_mp_function_list mplib_get_mp_function_list;
    Tmplib_get_mp_list mplib_get_mp_list;
    Tget_tsmaster_binary_location get_tsmaster_binary_location;
    Tget_form_instance_count get_form_instance_count;
    Tget_active_application_list get_active_application_list;
    Tenumerate_hw_devices enumerate_hw_devices;
    Tget_hw_info_by_index get_hw_info_by_index;
    Tui_graphics_set_measurement_cursor ui_graphics_set_measurement_cursor;
    Tui_graphics_set_diff_cursor ui_graphics_set_diff_cursor;
    Tui_graphics_hide_diff_cursor ui_graphics_hide_diff_cursor;
    Tui_graphics_hide_measurement_cursor ui_graphics_hide_measurement_cursor;
    Tencode_string encode_string;
    Tdecode_string decode_string;
    Tis_realtime_mode is_realtime_mode;
    Tis_simulation_mode is_simulation_mode;
    Tui_ribbon_add_icon ui_ribbon_add_icon;
    Tui_ribbon_del_icon ui_ribbon_del_icon;
    Tpanel_create_control panel_create_control;
    Tpanel_delete_control panel_delete_control;
    Tpanel_set_var panel_set_var;
    Tpanel_get_var panel_get_var;
    Tpanel_get_control_count panel_get_control_count;
    Tpanel_get_control_by_index panel_get_control_by_index;
    Tui_save_project ui_save_project;
    Tretrieve_api_address retrieve_api_address;
    Tui_load_rpc_ip_configuration ui_load_rpc_ip_configuration;
    Tui_unload_rpc_ip_configuration ui_unload_rpc_ip_configuration;
    Tui_unload_rpc_ip_configurations ui_unload_rpc_ip_configurations;
    Tam_set_custom_columns am_set_custom_columns;
    Twrite_realtime_comment_w_time internal_write_realtime_comment_w_time;
    Tui_graphics_set_relative_time ui_graphics_set_relative_time;
    Tpanel_import_configuration panel_import_configuration;
    Tui_graphics_set_y_axis_fixed_range ui_graphics_set_y_axis_fixed_range;
    Texport_system_messages export_system_messages;
    Tui_graphics_export_csv ui_graphics_export_csv;
    Tregister_usb_insertion_event internal_register_usb_insertion_event;
    Tunregister_usb_insertion_event internal_unregister_usb_insertion_event;
    Tregister_usb_removal_event internal_register_usb_removal_event;
    Tunregister_usb_removal_event internal_unregister_usb_removal_event;
    Tsecurity_check_custom_license_valid security_check_custom_license_valid;
    Tcall_model_initialization internal_call_model_initialization;
    Tcall_model_step internal_call_model_step;
    Tcall_model_finalization internal_call_model_finalization;
    Tui_hide_main_form ui_hide_main_form;
    Tui_show_main_form ui_show_main_form;
    Tconfigure_can_regs configure_can_regs;
    Tconfigure_canfd_regs configure_canfd_regs;
    Tstart_log_verbose internal_start_log_verbose;
    Tstart_log_w_filename_verbose internal_start_log_w_filename_verbose;
    Ttsio_start_configuration tsio_start_configuration;
    Ttsio_end_configuration tsio_end_configuration;
    Ttsdi_config_sync tsdi_config_sync;
    Ttsdo_config_sync tsdo_config_sync;
    Tset_di_channel_count set_di_channel_count;
    Tset_do_channel_count set_do_channel_count;
    Tset_ao_channel_count set_ao_channel_count;
    Tset_ai_channel_count set_ai_channel_count;
    Tget_ai_channel_count get_ai_channel_count;
    Tget_ao_channel_count get_ao_channel_count;
    Tget_do_channel_count get_do_channel_count;
    Tget_di_channel_count get_di_channel_count;
    Tcrypto_encrypt_aes_128_ecb crypto_encrypt_aes_128_ecb;
    Tcrypto_decrypt_aes_128_ecb crypto_decrypt_aes_128_ecb;
    Tcrypto_decrypt_aes_128_cbc crypto_decrypt_aes_128_cbc;
    Tcrypto_decrypt_aes_256_cbc crypto_decrypt_aes_256_cbc;
    Tcrypto_decrypt_rsa crypto_decrypt_rsa;
    Tcrypto_encrypt_rsa crypto_encrypt_rsa;
    Tcrypto_encrypt_aes_128_cbc crypto_encrypt_aes_128_cbc;
    Tcrypto_encrypt_aes_256_cbc crypto_encrypt_aes_256_cbc;
    Tcrypto_digest_sha2_256 crypto_digest_sha2_256;
    Tcrypto_digest_sha2_512 crypto_digest_sha2_512;
    Tcrypto_digest_sha3_512 crypto_digest_sha3_512;
    Tcrypto_digest_sha3_256 crypto_digest_sha3_256;
    Tcrypto_digest_md5 crypto_digest_md5;
    Tcrypto_generate_cmac crypto_generate_cmac;
    Tcrypto_generate_random_bytes crypto_generate_random_bytes;
    Tcrypto_crypt_aes_128_ctr crypto_crypt_aes_128_ctr;
    Tcrypto_crypt_test_ctr crypto_crypt_test_ctr;
    Tui_graphics_set_split_count ui_graphics_set_split_count;
    Tui_graphics_set_y_axis_split_mode ui_graphics_set_y_axis_split_mode;
    Tui_graphics_set_signal_step_style ui_graphics_set_signal_step_style;
    Tcrypto_signature_rsa crypto_signature_rsa;
    Tregister_app_system_var_module register_app_system_var_module;
    Tunregister_app_system_var_module unregister_app_system_var_module;
    Tcreate_app_system_var create_app_system_var;
    Tdelete_app_system_var delete_app_system_var;
    Tui_hide_toolbar ui_hide_toolbar;
    Tui_show_toolbar ui_show_toolbar;
    Tui_maximize_form ui_maximize_form;
    Tui_restore_form ui_restore_form;
    Tconfigure_lin_baudrate configure_lin_baudrate;
    Tdb_get_can_network_info_by_index db_get_can_network_info_by_index;
    Tdb_get_lin_network_info_by_index db_get_lin_network_info_by_index;
    Tdb_get_flexray_network_info_by_index db_get_flexray_network_info_by_index;
    Tdb_get_ethernet_network_info_by_index db_get_ethernet_network_info_by_index;
    Tset_system_var_uint8_array_element set_system_var_uint8_array_element;
    Tget_system_var_uint8_array_element get_system_var_uint8_array_element;
    Tget_system_var_int32_array_element get_system_var_int32_array_element;
    Tset_system_var_int32_array_element set_system_var_int32_array_element;
    Tget_system_var_int64_array_element get_system_var_int64_array_element;
    Tset_system_var_int64_array_element set_system_var_int64_array_element;
    Tget_system_var_double_array_element get_system_var_double_array_element;
    Tset_system_var_double_array_element set_system_var_double_array_element;
    Tget_system_var_type get_system_var_type;
    Tmetric_get_can_frame_interval_stat metric_get_can_frame_interval_stat;
    Tmetric_start metric_start;
    Tmetric_stop metric_stop;
    Tmetric_is_running metric_is_running;
    Tmetric_register_can_frame_interval metric_register_can_frame_interval;
    Tmetric_unregister_can_frame_interval metric_unregister_can_frame_interval;
    Tmetric_get_w_reset_can_frame_interval_stat metric_get_w_reset_can_frame_interval_stat;
    Tmetric_reset_can_frame_interval_stat metric_reset_can_frame_interval_stat;
    Tmetric_reset_frames_interval_stat_of_channel metric_reset_frames_interval_stat_of_channel;
    Tmetric_reset_frames_interval_stat_of_bus metric_reset_frames_interval_stat_of_bus;
    Tmetric_reset_frames_interval_stat_of_all metric_reset_frames_interval_stat_of_all;
    Ttsai_config_sync tsai_config_sync;
    Ttsao_config_sync tsao_config_sync;
    Tcall_system_api_w_serialized_args call_system_api_w_serialized_args;
    Tcall_library_api_w_serialized_args call_library_api_w_serialized_args;
    Tcan_set_load_balance_control can_set_load_balance_control;
    Tget_hardware_id_string_upg1 get_hardware_id_string_upg1;
    Tget_hardware_id_array_upg1 get_hardware_id_array_upg1;
    Tget_mapping_property get_mapping_property;
    Tdb_get_can_pdu_properties_by_index db_get_can_pdu_properties_by_index;
    Tdb_get_can_pdu_properties_by_address db_get_can_pdu_properties_by_address;
    Tdb_get_flexray_pdu_properties_by_address db_get_flexray_pdu_properties_by_address;
    Tdb_get_flexray_pdu_properties_by_index db_get_flexray_pdu_properties_by_index;
    Tregister_system_var_pre_read_event register_system_var_pre_read_event;
    Tunregister_system_var_pre_read_event unregister_system_var_pre_read_event;
    Tunregister_system_var_pre_read_events unregister_system_var_pre_read_events;
    Ttransmit_lin_wakeup_async transmit_lin_wakeup_async;
    Ttransmit_lin_gotosleep_async transmit_lin_gotosleep_async;
    Tam_get_name_by_index am_get_name_by_index;
    Tam_get_sub_module_count am_get_sub_module_count;
    Tam_get_sub_module_name_by_index am_get_sub_module_name_by_index;
    Tam_get_sub_module_info am_get_sub_module_info;
    Tam_find_sub_module am_find_sub_module;
    Tam_get_sub_module_running_state am_get_sub_module_running_state;
    Tam_get_variant_group_count am_get_variant_group_count;
    Tam_get_variant_group_name_by_index am_get_variant_group_name_by_index;
    Tam_add_variant_group am_add_variant_group;
    Tam_delete_variant_group am_delete_variant_group;
    Tam_get_variant_count am_get_variant_count;
    Tam_get_variant_by_index am_get_variant_by_index;
    Tam_set_variant_value am_set_variant_value;
    Tam_select_variant_group am_select_variant_group;
    Tam_get_local_var_count am_get_local_var_count;
    Tam_get_local_var_by_index am_get_local_var_by_index;
    Tam_compile_current am_compile_current;
    Tam_compile_all am_compile_all;
    Tam_pause am_pause;
    Tam_continue am_continue;
    Tam_step_over am_step_over;
    Tam_step_into am_step_into;
    Tam_get_progress am_get_progress;
    Tam_get_execution_result am_get_execution_result;
    Tam_get_variant_group_result am_get_variant_group_result;
    Tam_run_all_checked am_run_all_checked;
    Tam_run_all am_run_all;
    Tam_move_sub_module am_move_sub_module;
    Tam_export_sub_module am_export_sub_module;
    Tam_export_sub_modules am_export_sub_modules;
    Tam_import_sub_module am_import_sub_module;
    Tam_export_excel am_export_excel;
    Tam_import_excel am_import_excel;
    Tam_save_configuration am_save_configuration;
    Tam_load_configuration am_load_configuration;
    Tam_get_current_log_dir am_get_current_log_dir;
    Tam_get_overall_result am_get_overall_result;
    Tam_clear_results am_clear_results;
    Tam_add_sub_module am_add_sub_module;
    Tam_delete_sub_module am_delete_sub_module;
    Tam_delete_all_sub_modules am_delete_all_sub_modules;
    Tam_set_editor_locked am_set_editor_locked;
    Tam_get_editor_locked am_get_editor_locked;
    Tam_get_count am_get_count;
    Tget_system_var_app_def_by_index get_system_var_app_def_by_index;
    Tget_system_var_app_def_by_name get_system_var_app_def_by_name;
    Tget_system_var_app_count get_system_var_app_count;
    // Keep ABI compatibility: append new function pointers at tail and consume FDummy slots.
    Tdb_get_can_signal_range_json_by_address db_get_can_signal_range_json_by_address;
    Tdb_get_lin_signal_range_json_by_address db_get_lin_signal_range_json_by_address;
    Tdb_get_lin_schedule_table_json_by_address db_get_lin_schedule_table_json_by_address;
    Tdb_get_lin_frame_category_json_by_address db_get_lin_frame_category_json_by_address;
    Tdb_get_lin_node_mode_json_by_address db_get_lin_node_mode_json_by_address;
    Tdb_get_lin_schedule_tables_json_by_address db_get_lin_schedule_tables_json_by_address;
    Tcrypto_get_error_description crypto_get_error_description;
    Tcrypto_generate_hmac crypto_generate_hmac;
    Tcrypto_generate_siphash_2_4 crypto_generate_siphash_2_4;
    Tcrypto_verify_rsa crypto_verify_rsa;
    Ttls_register_tssocket tls_register_tssocket;
    Ttls_tcp_client_internal tls_tcp_client_internal;
    Ttls_tcp_server_internal tls_tcp_server_internal;
    Ttls_connect tls_connect;
    Ttls_accept tls_accept;
    Ttls_write tls_write;
    Ttls_read tls_read;
    Ttls_shutdown tls_shutdown;
    Ttls_free tls_free;
    Tcertificate_load certificate_load;
    Tcertificate_unload certificate_unload;
    Tcertificate_get_version certificate_get_version;
    Tcertificate_get_subject_name certificate_get_subject_name;
    Tcertificate_get_issuer_name certificate_get_issuer_name;
    Tcertificate_get_serial_number certificate_get_serial_number;
    Tcertificate_get_tbs_signature_algorithm certificate_get_tbs_signature_algorithm;
    Tcertificate_get_signature_algorithm certificate_get_signature_algorithm;
    Tcertificate_get_not_before certificate_get_not_before;
    Tcertificate_get_not_after certificate_get_not_after;
    Tcertificate_get_pubkey_algorithm certificate_get_pubkey_algorithm;
    Tgpg_begin_batch_import gpg_begin_batch_import;
    Tgpg_end_batch_import gpg_end_batch_import;
    Tgpg_set_module_execution_record_options gpg_set_module_execution_record_options;
    Tam_select_sub_module_verbose am_select_sub_module_verbose;
    TTSAppSetSystemVarInt64ArrayWTime set_system_var_int64_array_w_time;
    Tmplib_get_function_address mplib_get_function_address;
    TTSAppSetA429ChannelCount set_a429_channel_count;
    TTSAppGetA429ChannelCount get_a429_channel_count;
    TTSAppGetA429ChannelCapability get_a429_channel_capability;
    TTSAppConfigureA429Tx configure_a429_tx;
    TTSAppConfigureA429Rx configure_a429_rx;
    TTSAppGetA429TxConfig get_a429_tx_config;
    TTSAppGetA429RxConfig get_a429_rx_config;
    TTSAppStartA429Channel start_a429_channel;
    TTSAppStopA429Channel stop_a429_channel;
    Tload_code_file_to_ccode_editor load_code_file_to_ccode_editor;
    Tload_code_file_to_python_editor load_code_file_to_python_editor;
    Tconfigure_ethernet_parameter_ex configure_ethernet_parameter_ex;
    Tdb_resolve_can_signal_address db_resolve_can_signal_address;
    Tdb_resolve_can_message_address db_resolve_can_message_address;
    Tdb_resolve_lin_signal_address db_resolve_lin_signal_address;
    Tdb_resolve_lin_message_address db_resolve_lin_message_address;
    Tdb_resolve_flexray_signal_address db_resolve_flexray_signal_address;
    Tdb_resolve_flexray_message_address db_resolve_flexray_message_address;
    Tdb_resolve_ethernet_signal_address db_resolve_ethernet_signal_address;
    Tdb_resolve_ethernet_pdu_address db_resolve_ethernet_pdu_address;
    native_int FDummy[416]; // >>> mp app end <<<
    s32 start_log_w_filename_verbose(char* AFileName, s32 AFilesizeType, s64 ASizeValue){return internal_start_log_w_filename_verbose(FObj, AFileName, AFilesizeType, ASizeValue);}
    s32 start_log_verbose(s32 AFilesizeType, s64 ASizeValue){return internal_start_log_verbose(FObj, AFilesizeType, ASizeValue);}
    s32 call_model_finalization(const native_int AHandle){return internal_call_model_finalization(FObj, AHandle);}
    s32 call_model_step(const native_int AHandle, const s64 ATimeUs, const pvoid AInValues, pvoid AOutValues){return internal_call_model_step(FObj, AHandle, ATimeUs, AInValues, AOutValues);}
    s32 call_model_initialization(const char* ADiagramName, const s32 AInCnt, const s32 AOutCnt, const PMBDDataType AInTypes, const PMBDDataType AOutTypes, pnative_int AHandle){return internal_call_model_initialization(FObj, ADiagramName, AInCnt, AOutCnt, AInTypes, AOutTypes, AHandle);}
    s32 unregister_usb_removal_event(const TOnUSBPlugEvent AEvent){return internal_unregister_usb_removal_event(FObj, AEvent);}
    s32 register_usb_removal_event(const TOnUSBPlugEvent AEvent){return internal_register_usb_removal_event(FObj, AEvent);}
    s32 unregister_usb_insertion_event(const TOnUSBPlugEvent AEvent){return internal_unregister_usb_insertion_event(FObj, AEvent);}
    s32 register_usb_insertion_event(const TOnUSBPlugEvent AEvent){return internal_register_usb_insertion_event(FObj, AEvent);}
    s32 start_log_w_filename(const char* AFileName){
        return internal_start_log_w_filename(FObj, AFileName);
    }
    s32 disconnect(void){
        return internal_disconnect(FObj);
    }
    void terminate_application(void){
        internal_terminate_application(FObj);
    }
    s32 wait(const s32 ATimeMs, const char* AMsg){
        return internal_wait(FObj, ATimeMs, AMsg);
    }
    s32 check(const s32 AErrorCode){
        return internal_check(FObj, AErrorCode);
    }
    s32 debug_log(const char* AFile, const char* AFunc, const s32 ALine, const char* AStr, const TLogLevel ALevel){
        return internal_debug_log(FObj, AFile, AFunc, ALine, AStr, ALevel);
    }
    s32 start_log(void){
        return internal_start_log(FObj);
    }
    s32 end_log(void){
        return internal_end_log(FObj);
    }
    s32 write_realtime_comment(const char* AName){
        return internal_write_realtime_comment(FObj, AName);
    }
    s32 check_terminate(void){
        return internal_check_terminate(FObj);
    }
    s32 set_check_failed_terminate(const s32 AToTerminate){
        return internal_set_check_failed_terminate(FObj, AToTerminate);
    }
    s32 set_thread_priority(const s32 APriority){
        return internal_set_thread_priority(FObj, APriority);
    }
    s32 log_system_var_value(const char* ACompleteName){
        return internal_log_system_var_value(FObj, ACompleteName);
    }
    s32 wait_with_dialog(const char* ATitle, const char* AMessage, const bool* ApResult, const float* ApProgress100){
        return internal_wait_with_dialog(FObj, ATitle, AMessage, ApResult, ApProgress100);
    }
    char* get_current_mp_name(void){
        return internal_get_current_mp_name(FObj);
    }
    s32 register_system_var_change_event(const char* ACompleteName, const TOnSysVarChange AEvent){
        return internal_register_system_var_change_event(FObj, ACompleteName, AEvent);
    }
    s32 unregister_system_var_change_event(const char* ACompleteName, const TOnSysVarChange AEvent){
        return internal_unregister_system_var_change_event(FObj, ACompleteName, AEvent);
    }
    s32 unregister_system_var_change_events(const TOnSysVarChange AEvent){
        return internal_unregister_system_var_change_events(FObj, AEvent); 
    }
    s32 enter_critical_section(void){
        return internal_enter_critical_section(FObj);
    }
    s32 leave_critical_section(void){
        return internal_leave_critical_section(FObj);
    }
    s32 try_enter_critical_section(void){
        return internal_try_enter_critical_section(FObj);
    }
    s32 start_system_message_log(const char* ADirectory){
        return internal_start_system_message_log(FObj, ADirectory);
    }
    s32 end_system_message_log(char** ALogFileName){
        return internal_end_system_message_log(FObj, ALogFileName);
    }
    s32 write_realtime_comment_w_time(const char* AName, const s64 ATimeUs){
        return internal_write_realtime_comment_w_time(FObj, AName, ATimeUs);
    }
}TTSApp, * PTSApp;

// =========================== COM ===========================
typedef s32 (__stdcall* TTransmitCANAsync)(const PCAN ACAN);
typedef s32 (__stdcall* TTransmitCANFDAsync)(const PCANFD ACANFD);
typedef s32 (__stdcall* TTransmitLINAsync)(const PLIN ALIN);
typedef s32 (__stdcall* TTransmitCANSync)(const PCAN ACAN, const s32 ATimeoutMS);
typedef s32 (__stdcall* TTransmitCANFDSync)(const PCANFD ACANFD, const s32 ATimeoutMS);
typedef s32 (__stdcall* TTransmitLINSync)(const PLIN ALIN, const s32 ATimeoutMS);
typedef s32 (__stdcall* TTransmitFlexRayASync)(const PFlexRay AFlexRay);
typedef s32 (__stdcall* TTransmitFlexRaySync)(const PFlexRay AFlexRay, const s32 ATimeoutMS);
typedef double (__stdcall* TGetCANSignalValue)(const PCANSignal ACANSignal, const pu8 AData);
typedef void (__stdcall* TSetCANSignalValue)(const PCANSignal ACANSignal, const pu8 AData, const double AValue);
typedef double (__stdcall* TGetLINSignalValue)(const PLINSignal ACANSignal, const pu8 AData);
typedef void (__stdcall* TSetLINSignalValue)(const PLINSignal ACANSignal, const pu8 AData, const double AValue);
typedef double (__stdcall* TGetFlexRaySignalValue)(const PFlexRaySignal AFlexRaySignal, const pu8 AData);
typedef void (__stdcall* TSetFlexRaySignalValue)(const PFlexRaySignal AFlexRaySignal, const pu8 AData, const double AValue);
typedef void (__stdcall* TCANEvent)(const pnative_int AObj, const PCAN ACAN);
typedef void (__stdcall* TCANFDEvent)(const pnative_int AObj, const PCANFD ACANFD);
typedef void (__stdcall* TCANXLEvent)(const pnative_int AObj, const PCANXL ACANXL);
typedef void (__stdcall* TLINEvent)(const pnative_int AObj, const PLIN ALIN);
typedef void (__stdcall* TFlexRayEvent)(const pnative_int AObj, const PFlexRay AFlexRay);
typedef void (__stdcall* TEthernetEvent)(const pnative_int AObj, const PEthernetHeader AEthernet);
typedef void (__stdcall* TA429Event)(const pnative_int AObj, const PLIBA429 AFrame);
typedef s32 (__stdcall* TTransmitA429Async)(const PLIBA429 AFrame);
typedef s32 (__stdcall* TTransmitA429Sync)(const PLIBA429 AFrame, const s32 ATimeoutMS);
typedef s32 (__stdcall* TAddA429CyclicMessage)(const s32 AIdxChn, const PLIBA429CyclicMessage AMessage);
typedef s32 (__stdcall* TUpdateA429CyclicMessage)(const s32 AIdxChn, const PLIBA429CyclicMessage AMessage);
typedef s32 (__stdcall* TDeleteA429CyclicMessage)(const s32 AIdxChn, const u8 AMessageIndex);
typedef s32 (__stdcall* TRegisterA429Event)(const pnative_int AObj, const TA429Event AEvent);
typedef s32 (__stdcall* TUnregisterA429Event)(const pnative_int AObj, const TA429Event AEvent);
typedef s32 (__stdcall* TRegisterCANEvent)(const pnative_int AObj, const TCANEvent AEvent);
typedef s32 (__stdcall* TUnregisterCANEvent)(const pnative_int AObj, const TCANEvent AEvent);
typedef s32 (__stdcall* TRegisterCANFDEvent)(const pnative_int AObj, const TCANFDEvent AEvent);
typedef s32 (__stdcall* TUnregisterCANFDEvent)(const pnative_int AObj, const TCANFDEvent AEvent);
typedef s32 (__stdcall* TRegisterCANXLEvent)(const pnative_int AObj, const TCANXLEvent AEvent);
typedef s32 (__stdcall* TUnregisterCANXLEvent)(const pnative_int AObj, const TCANXLEvent AEvent);
typedef s32 (__stdcall* TRegisterLINEvent)(const pnative_int AObj, const TLINEvent AEvent);
typedef s32 (__stdcall* TUnregisterLINEvent)(const pnative_int AObj, const TLINEvent AEvent);
typedef s32 (__stdcall* TRegisterFlexRayEvent)(const pnative_int AObj, const TFlexRayEvent AEvent);
typedef s32 (__stdcall* TUnregisterFlexRayEvent)(const pnative_int AObj, const TFlexRayEvent AEvent);
typedef s32 (__stdcall* TRegisterEthernetEvent)(const pnative_int AObj, const TEthernetEvent AEvent);
typedef s32 (__stdcall* TUnregisterEthernetEvent)(const pnative_int AObj, const TEthernetEvent AEvent);
typedef s32 (__stdcall* TUnregisterCANEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterLINEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterCANFDEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterCANXLEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterFlexRayEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterEthernetEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterALLEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TRegisterPreTxCANEvent)(const pnative_int AObj, const TCANEvent AEvent);
typedef s32 (__stdcall* TUnregisterPreTxCANEvent)(const pnative_int AObj, const TCANEvent AEvent);
typedef s32 (__stdcall* TRegisterPreTxCANFDEvent)(const pnative_int AObj, const TCANFDEvent AEvent);
typedef s32 (__stdcall* TUnregisterPreTxCANFDEvent)(const pnative_int AObj, const TCANFDEvent AEvent);
typedef s32 (__stdcall* TRegisterPreTxLINEvent)(const pnative_int AObj, const TLINEvent AEvent);
typedef s32 (__stdcall* TUnregisterPreTxLINEvent)(const pnative_int AObj, const TLINEvent AEvent);
typedef s32 (__stdcall* TRegisterPreTxFlexRayEvent)(const pnative_int AObj, const TFlexRayEvent AEvent);
typedef s32 (__stdcall* TUnregisterPreTxFlexRayEvent)(const pnative_int AObj, const TFlexRayEvent AEvent);
typedef s32 (__stdcall* TRegisterPreTxEthernetEvent)(const pnative_int AObj, const TEthernetEvent AEvent);
typedef s32 (__stdcall* TUnregisterPreTxEthernetEvent)(const pnative_int AObj, const TEthernetEvent AEvent);
typedef s32 (__stdcall* TUnregisterPreTxCANEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterPreTxLINEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterPreTxCANFDEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterPreTxFlexRayEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterPreTxEthernetEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TUnregisterPreTxALLEvents)(const pnative_int AObj);
typedef s32 (__stdcall* TEnableBusStatistics)(const bool AEnable);
typedef s32 (__stdcall* TClearBusStatistics)(void);
typedef s32 (__stdcall* TGetBusStatistics)(const TLIBApplicationChannelType ABusType, const s32 AIdxChn, const TLIBCANBusStatistics AIdxStat, pdouble AStat);
typedef s32 (__stdcall* TGetFPSCAN)(const s32 AIdxChn, const s32 AIdentifier, ps32 AFPS);
typedef s32 (__stdcall* TGetFPSCANFD)(const s32 AIdxChn, const s32 AIdentifier, ps32 AFPS);
typedef s32 (__stdcall* TGetFPSLIN)(const s32 AIdxChn, const s32 AIdentifier, ps32 AFPS);
typedef s32 (__stdcall* TWaitCANMessage)(const void* AObj, const PCAN ATxCAN, const PCAN ARxCAN, const s32 ATimeoutMS);
typedef s32 (__stdcall* TWaitCANFDMessage)(const void* AObj, const PCANFD ATxCANFD, const PCANFD ARxCANFD, const s32 ATimeoutMS);
typedef s32 (__stdcall* TAddCyclicMsgCAN)(const PCAN ACAN, const float APeriodMS);
typedef s32 (__stdcall* TAddCyclicMsgCANFD)(const PCANFD ACANFD, const float APeriodMS);
typedef s32 (__stdcall* TDeleteCyclicMsgCAN)(const PCAN ACAN);
typedef s32 (__stdcall* TDeleteCyclicMsgCANFD)(const PCANFD ACANFD);
typedef s32 (__stdcall* TDeleteCyclicMsgs)(void);
typedef s32 (__stdcall* Tadd_precise_cyclic_message)(const s32 AIdentifier, const u8 AChn, const u8 AIsExt, const float APeriodMS, const s32 ATimeoutMS);
typedef s32 (__stdcall* Tdelete_precise_cyclic_message)(const s32 AIdentifier, const u8 AChn, const u8 AIsExt, const s32 ATimeoutMS);
typedef s32 (__stdcall* TInjectCANMessage)(const PCANFD ACANFD);
typedef s32 (__stdcall* TInjectLINMessage)(const PLIN ALIN);
typedef s32 (__stdcall* TInjectFlexRayFrame)(const PFlexRay AFlexRay);
typedef s32 (__stdcall* TGetCANSignalDefinitionVerbose)(const s32 AIdxChn, const char* ANetworkName, const char* AMsgName, const char* ASignalName, ps32 AMsgIdentifier, PCANSignal ASignalDef);
typedef s32 (__stdcall* TGetCANSignalDefinition)(const char* ASignalAddress, ps32 AMsgIdentifier, PCANSignal ASignalDef);
typedef s32 (__stdcall* TGetFlexRaySignalDefinition)(const char* ASignalAddress, PFlexRaySignal ASignalDef);
// online replay functions
typedef s32 (__stdcall* Ttslog_add_online_replay_config)(const char* AFileName, s32* AIndex);
typedef s32 (__stdcall* Ttslog_set_online_replay_config)(const s32 AIndex, const char* AName, const char* AFileName, const bool AAutoStart, const bool AIsRepetitiveMode, const TLIBOnlineReplayTimingMode AStartTimingMode, const s32 AStartDelayTimeMs, const bool ASendTx, const bool ASendRx, const char* AMappings);
typedef s32 (__stdcall* Ttslog_get_online_replay_count)(s32* ACount);
typedef s32 (__stdcall* Ttslog_get_online_replay_config)(const s32 AIndex, char** AName, char** AFileName, bool* AAutoStart, bool* AIsRepetitiveMode, TLIBOnlineReplayTimingMode* AStartTimingMode, s32* AStartDelayTimeMs, bool* ASendTx, bool* ASendRx, char** AMappings);
typedef s32 (__stdcall* Ttslog_del_online_replay_config)(const s32 AIndex);
typedef s32 (__stdcall* Ttslog_del_online_replay_configs)(void);
typedef s32 (__stdcall* Ttslog_start_online_replay)(const s32 AIndex);
typedef s32 (__stdcall* Ttslog_start_online_replays)(void);
typedef s32 (__stdcall* Ttslog_pause_online_replay)(const s32 AIndex);
typedef s32 (__stdcall* Ttslog_pause_online_replays)(void);
typedef s32 (__stdcall* Ttslog_stop_online_replay)(const s32 AIndex);
typedef s32 (__stdcall* Ttslog_stop_online_replays)(void);
typedef s32 (__stdcall* Ttslog_get_online_replay_status)(const s32 AIndex, TLIBOnlineReplayStatus* AStatus, float* AProgressPercent100);
// CAN rbs functions
typedef s32 (__stdcall* TCANRBSStart)(void);
typedef s32 (__stdcall* TCANRBSStop)(void);
typedef s32 (__stdcall* TCANRBSIsRunning)(bool* AIsRunning);
typedef s32 (__stdcall* TCANRBSConfigure)(const bool AAutoStart, const bool AAutoSendOnModification, const bool AActivateNodeSimulation, const TLIBRBSInitValueOptions AInitValueOptions);
typedef s32 (__stdcall* TCANRBSEnable)(const bool AEnable);
typedef s32 (__stdcall* TCANRBSActivateAllNetworks)(const bool AEnable, const bool AIncludingChildren);
typedef s32 (__stdcall* TCANRBSActivateNetworkByName)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, const bool AIncludingChildren);
typedef s32 (__stdcall* TCANRBSActivateNodeByName)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, const char* ANodeName, const bool AIncludingChildren);
typedef s32 (__stdcall* TCANRBSActivateMessageByName)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, const char* ANodeName, const char* AMsgName);
typedef s32 (__stdcall* TCANRBSSetMessageCycleByName)(const s32 AIdxChn, const s32 AIntervalMs, const char* ANetworkName, const char* ANodeName, const char* AMsgName);
typedef s32 (__stdcall* TCANRBSGetSignalValueByElement)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const char* ASignalName, double* AValue);
typedef s32 (__stdcall* TCANRBSGetSignalValueByAddress)(const char* ASymbolAddress, double* AValue);
typedef s32 (__stdcall* TCANRBSSetSignalValueByElement)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const char* ASignalName, const double AValue);
typedef s32 (__stdcall* TCANRBSSetSignalValueByAddress)(const char* ASymbolAddress, const double AValue);
typedef s32 (__stdcall* TCANRBSBatchSetStart)(void);
typedef s32 (__stdcall* TCANRBSBatchSetEnd)(void);
typedef s32 (__stdcall* TCANRBSBatchSetSignal)(const char* ASymbolAddress, const double AValue);
typedef s32 (__stdcall* TCANRBSSetMessageDirection)(const s32 AIdxChn, const bool AIsTx, const char* ANetworkName, const char* ANodeName, const char* AMsgName);
typedef s32 (__stdcall* TCANRBSFaultInjectionClear)(void);
typedef s32 (__stdcall* TCANRBSFaultInjectionMessageLost)(const bool AEnable, const s32 AIdxChn, const s32 AIdentifier);
typedef s32 (__stdcall* TCANRBSFaultInjectionSignalAlter)(const bool AEnable, const char* ASymbolAddress, const double AAlterValue);
typedef s32 (__stdcall* TCANRBSSetNormalSignal)(const char* ASymbolAddress);
typedef s32 (__stdcall* TCANRBSSetRCSignal)(const char* ASymbolAddress);
typedef s32 (__stdcall* TCANRBSSetRCSignalWithLimit)(const char* ASymbolAddress, const s32 ALowerLimit, const s32 AUpperLimit);
typedef s32 (__stdcall* TCANRBSSetCRCSignal)(const char* ASymbolAddress, const char* AAlgorithmName, const s32 AIdxByteStart, const s32 AByteCount);
// FlexRay rbs functions
typedef s32 (__stdcall* TFlexRayRBSStart)(void);
typedef s32 (__stdcall* TFlexRayRBSStop)(void);
typedef s32 (__stdcall* TFlexRayRBSIsRunning)(bool* AIsRunning);
typedef s32 (__stdcall* TFlexRayRBSConfigure)(const bool AAutoStart, const bool AAutoSendOnModification, const bool AActivateECUSimulation, const TLIBRBSInitValueOptions AInitValueOptions);
typedef s32 (__stdcall* TFlexRayRBSEnable)(const bool AEnable);
typedef s32 (__stdcall* TFlexRayRBSActivateAllClusters)(const bool AEnable, const bool AIncludingChildren);
typedef s32 (__stdcall* TFlexRayRBSActivateClusterByName)(const s32 AIdxChn, const bool AEnable, const char* AClusterName, const bool AIncludingChildren);
typedef s32 (__stdcall* TFlexRayRBSActivateECUByName)(const s32 AIdxChn, const bool AEnable, const char* AClusterName, const char* AECUName, const bool AIncludingChildren);
typedef s32 (__stdcall* TFlexRayRBSActivateFrameByName)(const s32 AIdxChn, const bool AEnable, const char* AClusterName, const char* AECUName, const char* AFrameName);
typedef s32 (__stdcall* TFlexRayRBSGetSignalValueByElement)(const s32 AIdxChn, const char* AClusterName, const char* AECUName, const char* AFrameName, const char* ASignalName, double* AValue);
typedef s32 (__stdcall* TFlexRayRBSGetSignalValueByAddress)(const char* ASymbolAddress, double* AValue);
typedef s32 (__stdcall* TFlexRayRBSSetSignalValueByElement)(const s32 AIdxChn, const char* AClusterName, const char* AECUName, const char* AFrameName, const char* ASignalName, const double AValue);
typedef s32 (__stdcall* TFlexRayRBSSetSignalValueByAddress)(const char* ASymbolAddress, const double AValue);
typedef s32 (__stdcall* TFlexRayRBSBatchSetStart)(void);
typedef s32 (__stdcall* TFlexRayRBSBatchSetEnd)(void);
typedef s32 (__stdcall* TFlexRayRBSBatchSetSignal)(const char* ASymbolAddress, const double AValue);
typedef s32 (__stdcall* TFlexRayRBSSetFrameDirection)(const s32 AIdxChn, const bool AIsTx, const char* AClusterName, const char* AECUName, const char* AFrameName);
typedef s32 (__stdcall* TFlexRayRBSSetNormalSignal)(const char* ASymbolAddress);
typedef s32 (__stdcall* TFlexRayRBSSetRCSignal)(const char* ASymbolAddress);
typedef s32 (__stdcall* TFlexRayRBSSetRCSignalWithLimit)(const char* ASymbolAddress, const s32 ALowerLimit, const s32 AUpperLimit);
typedef s32 (__stdcall* TFlexRayRBSSetCRCSignal)(const char* ASymbolAddress, const char* AAlgorithmName, const s32 AIdxByteStart, const s32 AByteCount);
// log file functions
typedef s32 (__stdcall* Ttslog_blf_write_start)(const char* AFileName, native_int* AHandle);
typedef s32 (__stdcall* Ttslog_blf_write_start_w_timestamp)(const char* AFileName, native_int* AHandle, u16* AYear, u16* AMonth, u16* ADay, u16* AHour, u16* AMinute, u16* ASecond, u16* AMilliseconds);
typedef s32 (__stdcall* Ttslog_blf_write_set_max_count)(const native_int AHandle, const u32 ACount);
typedef s32 (__stdcall* Ttslog_blf_write_can)(const native_int AHandle, const PCAN ACAN);
typedef s32 (__stdcall* Ttslog_blf_write_can_fd)(const native_int AHandle, const PCANFD ACANFD);
typedef s32 (__stdcall* Ttslog_blf_write_lin)(const native_int AHandle, const PLIN ALIN);
typedef s32 (__stdcall* Ttslog_blf_write_flexray)(const native_int AHandle, const PFlexRay AFlexRay);
typedef s32 (__stdcall* Ttslog_blf_write_realtime_comment)(const native_int AHandle, const s64 ATimeUs, const char* AComment);
typedef s32 (__stdcall* Ttslog_blf_write_end)(const native_int AHandle);
typedef s32 (__stdcall* Ttslog_blf_read_start)(const char* AFileName, native_int* AHandle, s32* AObjCount);
typedef s32 (__stdcall* Ttslog_blf_read_status)(const native_int AHandle, s32* AObjReadCount);
typedef s32 (__stdcall* Ttslog_blf_read_object)(const native_int AHandle, s32* AProgressedCnt, TSupportedBLFObjType* AType, PCAN ACAN, PLIN ALIN, PCANFD ACANFD);
typedef s32 (__stdcall* Ttslog_blf_read_object_w_comment)(const native_int AHandle, s32* AProgressedCnt, TSupportedBLFObjType* AType, PCAN ACAN, PLIN ALIN, PCANFD ACANFD, Prealtime_comment_t AComment);
typedef s32 (__stdcall* Ttslog_blf_read_end)(const native_int AHandle);
typedef s32 (__stdcall* Ttslog_blf_seek_object_time)(const native_int AHandle, const double AProg100, s64* ATime, s32* AProgressedCnt);
typedef s32 (__stdcall* Ttslog_blf_to_asc)(const void* AObj, const char* ABLFFileName, const char* AASCFileName, const TProgressCallback AProgressCallback);
typedef s32 (__stdcall* Ttslog_asc_to_blf)(const void* AObj, const char* AASCFileName, const char* ABLFFileName, const TProgressCallback AProgressCallback);
// IP functions
typedef s32 (__stdcall* TIoIPCreate)(void* AObj, u16 APortTCP, u16 APortUDP, TOnIoIPData AOnTCPDataEvent, TOnIoIPData AOnUDPDataEvent, native_int* AHandle);
typedef s32 (__stdcall* TIoIPDelete)(const void* AObj, const native_int AHandle);
typedef s32 (__stdcall* TIoIPEnableTCPServer)(const void* AObj, const native_int AHandle, const bool AEnable);
typedef s32 (__stdcall* TIoIPEnableUDPServer)(const void* AObj, const native_int AHandle, const bool AEnable);
typedef s32 (__stdcall* TIoIPConnectTCPServer)(const void* AObj, const native_int AHandle, const char* AIpAddress, const u16 APort);
typedef s32 (__stdcall* TIoIPConnectUDPServer)(const void* AObj, const native_int AHandle, const char* AIpAddress, const u16 APort);
typedef s32 (__stdcall* TIoIPDisconnectTCPServer)(const void* AObj, const native_int AHandle);
typedef s32 (__stdcall* TIoIPSendBufferTCP)(const void* AObj, const native_int AHandle, const pu8 APointer, const s32 ASize);
typedef s32 (__stdcall* TIoIPSendBufferUDP)(const void* AObj, const native_int AHandle, const pu8 APointer, const s32 ASize);
typedef s32 (__stdcall* TIoIPRecvTCPClientResponse)(const void* AObj, const native_int AHandle, const s32 ATimeoutMs, const pu8 ABufferToReadTo, ps32 AActualSize);
typedef s32 (__stdcall* TIoIPSendTCPServerResponse)(const void* AObj, const native_int AHandle, const pu8 ABufferToWriteFrom, const s32 ASize);
typedef s32 (__stdcall* TIoIPSendUDPBroadcast)(const void* AObj, const native_int AHandle, const u16 APort, const pu8 ABufferToWriteFrom, const s32 ASize);
typedef s32 (__stdcall* TIoIPSetUDPServerBufferSize)(const void* AObj, const native_int AHandle, const s32 ASize);
typedef s32 (__stdcall* TIoIPRecvUDPClientResponse)(const void* AObj, const native_int AHandle, const s32 ATimeoutMs, const pu8 ABufferToReadTo, ps32 AActualSize);
typedef s32 (__stdcall* TIoIPSendUDPServerResponse)(const void* AObj, const native_int AHandle, const pu8 ABufferToWriteFrom, const s32 ASize);
// signal server
typedef s32 (__stdcall* TSgnSrvRegisterCANSignalByMsgId)(const s32 AIdxChn, const s32 AMsgId, const char* ASgnName, ps32 AClientId);
typedef s32 (__stdcall* TSgnSrvRegisterLINSignalByMsgId)(const s32 AIdxChn, const s32 AMsgId, const char* ASgnName, ps32 AClientId);
typedef s32 (__stdcall* TSgnSrvRegisterCANSignalByMsgName)(const s32 AIdxChn, const char* ANetworkName, const char* AMsgName, const char* ASgnName, ps32 AClientId);
typedef s32 (__stdcall* TSgnSrvRegisterLINSignalByMsgName)(const s32 AIdxChn, const char* ANetworkName, const char* AMsgName, const char* ASgnName, ps32 AClientId);
typedef s32 (__stdcall* TSgnSrvGetCANSignalPhyValueLatest)(const s32 AIdxChn, const s32 AClientId, pdouble AValue, ps64 ATimeUs);
typedef s32 (__stdcall* TSgnSrvGetLINSignalPhyValueLatest)(const s32 AIdxChn, const s32 AClientId, pdouble AValue, ps64 ATimeUs);
typedef s32 (__stdcall* TSgnSrvGetCANSignalPhyValueInMsg)(const s32 AIdxChn, const s32 AClientId, const PCANFD AMsg, pdouble AValue, ps64 ATimeUs);
typedef s32 (__stdcall* TSgnSrvGetLINSignalPhyValueInMsg)(const s32 AIdxChn, const s32 AClientId, const PLIN AMsg, pdouble AValue, ps64 ATimeUs);
typedef s32 (__stdcall* TSgnSrvRegisterFlexRaySignalByFrame)(const s32 AIdxChn, const u8 AChnMask, const u8 ACycleNumber, const s32 ASlotId, const char* ASgnName, ps32 AClientId);
typedef s32 (__stdcall* TSgnSrvRegisterFlexRaySignalByFrameName)(const s32 AIdxChn, const char* ANetworkName, const char* AFrameName, const char* ASgnName, ps32 AClientId);
typedef s32 (__stdcall* TSgnSrvGetFlexRaySignalPhyValueLatest)(const s32 AIdxChn, const s32 AClientId, pdouble AValue, ps64 ATimeUs);
typedef s32 (__stdcall* TSgnSrvGetFlexRaySignalPhyValueInFrame)(const s32 AIdxChn, const s32 AClientId, const PFlexRay AFrame, pdouble AValue, ps64 ATimeUs);
// pdu container
typedef s32 (__stdcall* TPDUContainerSetCycleCount)(const s32 AIdxChn, const s32 AMsgId, const s32 ACount);
typedef s32 (__stdcall* TPDUContainerSetCycleByIndex)(const s32 AIdxChn, const s32 AMsgId, const s32 AIdxCycle, const pchar ASignalGroupIdList);
typedef s32 (__stdcall* TPDUContainerGetCycleCount)(const s32 AIdxChn, const s32 AMsgId, ps32 ACount);
typedef s32 (__stdcall* TPDUContainerGetCycleByIndex)(const s32 AIdxChn, const s32 AMsgId, const s32 AIdxCycle, char** ASignalGroupIdList);
typedef s32 (__stdcall* TPDUContainerRefresh)(const s32 AIdxChn, const s32 AMsgId);
// j1939
typedef s32 (__stdcall* TJ1939MakeId)(const s32 APGN, const u8 ASource, const u8 ADestination, const u8 APriority, ps32 AIdentifier);
typedef s32 (__stdcall* TJ1939ExtractId)(const s32 AIdentifier, ps32 APGN, pu8 ASource, pu8 ADestination, pu8 APriority);
typedef s32 (__stdcall* TJ1939GetPGN)(const s32 AIdentifier, ps32 APGN);
typedef s32 (__stdcall* TJ1939GetSource)(const s32 AIdentifier, pu8 ASource);
typedef s32 (__stdcall* TJ1939GetDestination)(const s32 AIdentifier, pu8 ADestination);
typedef s32 (__stdcall* TJ1939GetPriority)(const s32 AIdentifier, pu8 APriority);
typedef s32 (__stdcall* TJ1939GetR)(const s32 AIdentifier, pu8 AR);
typedef s32 (__stdcall* TJ1939GetDP)(const s32 AIdentifier, pu8 ADP);
typedef s32 (__stdcall* TJ1939GetEDP)(const s32 AIdentifier, pu8 AEDP);
typedef s32 (__stdcall* TJ1939SetPGN)(const ps32 AIdentifier, const s32 APGN);
typedef s32 (__stdcall* TJ1939SetSource)(const ps32 AIdentifier, const u8 ASource);
typedef s32 (__stdcall* TJ1939SetDestination)(const ps32 AIdentifier, const u8 ADestination);
typedef s32 (__stdcall* TJ1939SetPriority)(const ps32 AIdentifier, const u8 APriority);
typedef s32 (__stdcall* TJ1939SetR)(const ps32 AIdentifier, const u8 AR);
typedef s32 (__stdcall* TJ1939SetDP)(const ps32 AIdentifier, const u8 ADP);
typedef s32 (__stdcall* TJ1939SetEDP)(const ps32 AIdentifier, const u8 AEDP);
typedef s32 (__stdcall* TJ1939GetLastPDU)(const u8 AIdxChn, const s32 AIdentifier, const bool AIsTx, const s32 APDUBufferSize, pu8 APDUBuffer, ps32 APDUActualSize, ps64 ATimeUs);
typedef s32 (__stdcall* TJ1939GetLastPDUAsString)(const u8 AIdxChn, const s32 AIdentifier, const bool AIsTx, char** APDUData, ps32 APDUActualSize, ps64 ATimeUs);
typedef s32 (__stdcall* TJ1939TransmitPDUAsync)(const u8 AIdxChn, const s32 APGN, const u8 APriority, const u8 ASource, const u8 ADestination, const pu8 APDUData, const s32 APDUSize);
typedef s32 (__stdcall* TJ1939TransmitPDUSync)(const u8 AIdxChn, const s32 APGN, const u8 APriority, const u8 ASource, const u8 ADestination, const pu8 APDUData, const s32 APDUSize, const s32 ATimeoutMs);
typedef s32 (__stdcall* TJ1939TransmitPDUAsStringAsync)(const u8 AIdxChn, const s32 APGN, const u8 APriority, const u8 ASource, const u8 ADestination, const char* APDUData);
typedef s32 (__stdcall* TJ1939TransmitPDUAsStringSync)(const u8 AIdxChn, const s32 APGN, const u8 APriority, const u8 ASource, const u8 ADestination, const char* APDUData, const s32 ATimeoutMs);
typedef s32 (__stdcall* TDisableOnlineReplayFilter)(const s32 AIndex);
typedef s32 (__stdcall* TSetOnlineReplayFilter)(const s32 AIndex, const bool AIsPassFilter, const s32 ACount, const ps32 AIdxChannels, const ps32 AIdentifiers);
typedef s32 (__stdcall* TSetCANSignalRawValue)(const PCANSignal ACANSignal, const pu8 AData, const u64 AValue);
typedef u64 (__stdcall* TGetCANSignalRawValue)(const PCANSignal ACANSignal, const pu8 AData);
typedef s32 (__stdcall* TSetLINSignalRawValue)(const PLINSignal ALINSignal, const pu8 AData, const u64 AValue);
typedef u64 (__stdcall* TGetLINSignalRawValue)(const PLINSignal ALINSignal, const pu8 AData);
typedef s32 (__stdcall* TSetFlexRaySignalRawValue)(const PFlexRaySignal AFlexRaySignal, const pu8 AData, const u64 AValue);
typedef u64 (__stdcall* TGetFlexRaySignalRawValue)(const PFlexRaySignal AFlexRaySignal, const pu8 AData);
typedef s32 (__stdcall* TFlexRayRBSUpdateFrameByHeader)(const TFlexRay* AFlexRay);
// LIN rbs functions
typedef s32 (__stdcall* TLINRBSStart)(void);
typedef s32 (__stdcall* TLINRBSStop)(void);
typedef s32 (__stdcall* TLINRBSIsRunning)(bool* AIsRunning);
typedef s32 (__stdcall* TLINRBSConfigure)(const bool AAutoStart, const bool AAutoSendOnModification, const bool AActivateNodeSimulation, const TLIBRBSInitValueOptions AInitValueOptions);
typedef s32 (__stdcall* TLINRBSEnable)(const bool AEnable);
typedef s32 (__stdcall* TLINRBSActivateAllNetworks)(const bool AEnable, const bool AIncludingChildren);
typedef s32 (__stdcall* TLINRBSActivateNetworkByName)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, const bool AIncludingChildren);
typedef s32 (__stdcall* TLINRBSActivateNodeByName)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, const char* ANodeName, const bool AIncludingChildren);
typedef s32 (__stdcall* TLINRBSActivateMessageByName)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, const char* ANodeName, const char* AMsgName);
typedef s32 (__stdcall* TLINBSSetMessageDelayTimeByName)(const s32 AIdxChn, const s32 AIntervalMs, const char* ANetworkName, const char* ANodeName, const char* AMsgName);
typedef s32 (__stdcall* TLINRBSGetSignalValueByElement)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const char* ASignalName, double* AValue);
typedef s32 (__stdcall* TLINRBSGetSignalValueByAddress)(const char* ASymbolAddress, double* AValue);
typedef s32 (__stdcall* TLINRBSSetSignalValueByElement)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const char* ASignalName, const double AValue);
typedef s32 (__stdcall* TLINRBSSetSignalValueByAddress)(const char* ASymbolAddress, const double AValue);
typedef s32 (__stdcall* TLINRBSBatchSetStart)(void);
typedef s32 (__stdcall* TLINRBSBatchSetEnd)(void);
typedef s32 (__stdcall* TLINRBSBatchSetSignal)(const char* ASymbolAddress, const double AValue);
typedef s32 (__stdcall* TTransmitEthernetASync)(const PEthernetHeader AEthernetHeader);
typedef s32 (__stdcall* TTransmitEthernetSync)(const PEthernetHeader AEthernetHeader, const s32 ATimeoutMs);
typedef s32 (__stdcall* TInjectEthernetFrame)(const PEthernetHeader AEthernetHeader);
typedef s32 (__stdcall* TTSLogBlfWriteEthernet)(const native_int AHandle, const PEthernetHeader AEthernetHeader);

typedef s32 (__stdcall* TTransmitEthernetAsyncWoPretx)(const PEthernetHeader AEthernetHeader);
typedef s32 (__stdcall* TIoIpSetOnConnectionCallback)(const void* AObj, const native_int AHandle, const TOnIoIPConnection AConnectedCallback, const TOnIoIPConnection ADisconnectedCallback);
typedef s32 (__stdcall* TEthBuildIPv4UDPPacket)(PEthernetHeader AHeader, pu8 ASrcIp, pu8 ADstIp, u16 ASrcPort, u16 ADstPort, pu8 APayload, u16 APayloadLength, ps32 AIdentification, ps32 AFragmentIndex);
typedef s32 (__stdcall* TBlockCurrentPreTx)(const void* AObj);
typedef s32 (__stdcall* TEthernetIsUDPPacket)(const PEthernetHeader AHeader, pu16 AIdentification, pu16 AUDPPacketLength, pu16 AUDPDataOffset, pbool AIsPacketEnded);
typedef s32 (__stdcall* TEthernetIPCalcHeaderChecksum)(const PEthernetHeader AHeader, const bool AOverwriteChecksum, pu16 AChecksum);
typedef s32 (__stdcall* TEthernetUDPCalcChecksum)(const PEthernetHeader AHeader, const pu8 AUDPPayloadAddr, const u16 AUDPPayloadLength, const bool AOverwriteChecksum, pu16 AChecksum);
typedef s32 (__stdcall* TEthernetUDPCalcChecksumOnFrame)(const PEthernetHeader AHeader, const bool AOverwriteChecksum, pu16 AChecksum);
typedef s32 (__stdcall* TEthLogEthernetFrameData)(const PEthernetHeader AHeader);


typedef s32 (__stdcall* Tlin_clear_schedule_tables)(const s32 AChnIdx);
typedef s32 (__stdcall* Tlin_stop_lin_channel)(const s32 AChnIdx);
typedef s32 (__stdcall* Tlin_start_lin_channel)(const s32 AChnIdx);
typedef s32 (__stdcall* Tlin_switch_runtime_schedule_table)(const s32 AChnIdx);
typedef s32 (__stdcall* Tlin_switch_idle_schedule_table)(const s32 AChnIdx);
typedef s32 (__stdcall* Tlin_switch_normal_schedule_table)(const s32 AChnIdx, const s32 ASchIndex);
typedef s32 (__stdcall* Tlin_batch_set_schedule_start)(const s32 AChnIdx);
typedef s32 (__stdcall* Tlin_batch_add_schedule_frame)(const s32 AChnIdx, const PLIN ALINData, const s32 ADelayMs);
typedef s32 (__stdcall* Tlin_batch_set_schedule_end)(const s32 AChnIdx);
typedef s32 (__stdcall* Tlin_set_node_functiontype)(const s32 AChnIdx, const s32 AFunctionType);
typedef s32 (__stdcall* Tlin_active_frame_in_schedule_table)(const u32 AChnIdx, const u8 AID, const s32 AIndex);
typedef s32 (__stdcall* Tlin_deactive_frame_in_schedule_table)(const u32 AChnIdx, const u8 AID, const s32 AIndex);
typedef s32 (__stdcall* Tflexray_disable_frame)(const s32 AChnIdx, const u8 ASlot, const u8 ABaseCycle, const u8 ACycleRep, const s32 ATimeoutMs);
typedef s32 (__stdcall* Tflexray_enable_frame)(const s32 AChnIdx, const u8 ASlot, const u8 ABaseCycle, const u8 ACycleRep, const s32 ATimeoutMs);
typedef s32 (__stdcall* Tflexray_start_net)(const s32 AChnIdx, const s32 ATimeoutMs);
typedef s32 (__stdcall* Tflexray_stop_net)(const s32 AChnIdx, const s32 ATimeoutMs);
typedef s32 (__stdcall* Tflexray_wakeup_pattern)(const s32 AChnIdx, const s32 ATimeoutMs);
typedef s32 (__stdcall* TSetFlexRayAutoUBHandle)(const bool AIsAutoHandle);
typedef s32 (__stdcall* Teth_frame_clear_vlans)(const PEthernetHeader AHeader);
typedef s32 (__stdcall* Teth_frame_append_vlan)(PEthernetHeader AHeader, const u16 AVLANId, const u8 APriority, const u8 ACFI);
typedef s32 (__stdcall* Teth_frame_append_vlans)(PEthernetHeader AHeader, const pu16 AVLANIds, const s32 ACount, const u8 APriority, const u8 ACFI);
typedef s32 (__stdcall* Teth_frame_remove_vlan)(PEthernetHeader AHeader);
typedef s32 (__stdcall* Teth_build_ipv4_udp_packet_on_frame)(PEthernetHeader AInputHeader, pu8 APayload, u16 APayloadLength, ps32 AIdentification, ps32 AFragmentIndex);
typedef s32 (__stdcall* Teth_udp_fragment_processor_clear)(const void* AObj);
typedef s32 (__stdcall* Teth_udp_fragment_processor_parse)(const void* AObj, const PEthernetHeader AHeader, PUDPFragmentProcessStatus AStatus, ppu8 APayload, pu16 APayloadLength, PEthernetHeader ACompleteHeader);
typedef s32 (__stdcall* Teth_frame_insert_vlan)(PEthernetHeader AHeader, const u16 AVLANId, const u8 APriority, const u8 ACFI);
typedef s32 (__stdcall* Ttelnet_create)(const void* AObj, const char* AHost, const u16 APort, const TOnIoIPData ADataEvent, pnative_int AHandle);
typedef s32 (__stdcall* Ttelnet_delete)(const void* AObj, const native_int AHandle);
typedef s32 (__stdcall* Ttelnet_send_string)(const void* AObj, const native_int AHandle, const char* AStr);
typedef s32 (__stdcall* Ttelnet_connect)(const void* AObj, const native_int AHandle);
typedef s32 (__stdcall* Ttelnet_disconnect)(const void* AObj, const native_int AHandle);
typedef s32 (__stdcall* Ttelnet_set_connection_callback)(const void* AObj, const native_int AHandle, const TOnIoIPConnection AConnectedCallback, const TOnIoIPConnection ADisconnectedCallback);
typedef s32 (__stdcall* Ttelnet_enable_debug_print)(const void* AObj, const native_int AHandle, const bool AEnable);
typedef s32 (__stdcall* Ttslog_blf_to_pcap)(const pvoid AObj, const char* ABlfFileName, const char* APcapFileName, const TProgressCallback AProgressCallback);
typedef s32 (__stdcall* Ttslog_pcap_to_blf)(const pvoid AObj, const char* APcapFileName, const char* ABlfFileName, const TProgressCallback AProgressCallback);
typedef s32 (__stdcall* Ttslog_pcapng_to_blf)(const pvoid AObj, const char* APcapngFileName, const char* ABlfFileName, const TProgressCallback AProgressCallback);
typedef s32 (__stdcall* Ttslog_blf_to_pcapng)(const pvoid AObj, const char* ABlfFileName, const char* APcapngFileName, const TProgressCallback AProgressCallback);
typedef s32 (__stdcall* Ttssocket_tcp)(const s32 ANetworkIndex, const char* AIPEndPoint, const ps32 ASocket);
typedef s32 (__stdcall* Ttssocket_udp)(const s32 ANetworkIndex, const char* AIPEndPoint, const ps32 ASocket);
typedef s32 (__stdcall* Ttssocket_tcp_start_listen)(const s32 ASocket);
typedef s32 (__stdcall* Ttssocket_tcp_start_receive)(const s32 ASocket);
typedef s32 (__stdcall* Ttssocket_tcp_close)(const s32 ASocket);
typedef s32 (__stdcall* Ttssocket_udp_start_receive)(const s32 ASocket);
typedef s32 (__stdcall* Ttssocket_udp_close)(const s32 ASocket);
typedef s32 (__stdcall* Ttssocket_tcp_connect)(const s32 ASocket, const char* AIPEndPoint);
typedef s32 (__stdcall* Ttssocket_tcp_send)(const s32 ASocket, const pu8 AData, const s32 ASize);
typedef s32 (__stdcall* Ttssocket_tcp_send_sync)(const s32 ASocket, const pu8 AData, const s32 ASize);
typedef s32 (__stdcall* Ttssocket_tcp_send_async)(const s32 ASocket, const pu8 AData, const s32 ASize);
typedef s32 (__stdcall* Ttssocket_tcp_sendto_client)(const s32 ASocket, const char* AIPEndPoint, const pu8 AData, const s32 ASize);
typedef s32 (__stdcall* Ttssocket_udp_sendto)(const s32 ASocket, const char* AIPEndPoint, const pu8 AData, const s32 ASize);
typedef s32 (__stdcall* Ttssocket_udp_sendto_v2)(const s32 ASocket, const u32 AIPAddress, const u16 APort, const pu8 AData, const s32 ASize);
typedef s32 (__stdcall* Ttssocket_tcp_close_v2)(const s32 ASocket, const s32 AForceExitTimeWait);
typedef s32 (__stdcall* Trpc_create_server)(const pvoid AObj, const char* ARpcName, const native_int ABufferSizeBytes, const TOnRpcData ARxEvent, pnative_int AHandle);
typedef s32 (__stdcall* Trpc_activate_server)(const pvoid AObj, const native_int AHandle, const bool AActivate);
typedef s32 (__stdcall* Trpc_delete_server)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_server_write_sync)(const pvoid AObj, const native_int AHandle, const pu8 AAddr, const native_int ASizeBytes);
typedef s32 (__stdcall* Trpc_create_client)(const pvoid AObj, const char* ARpcName, const native_int ABufferSizeBytes, pnative_int AHandle);
typedef s32 (__stdcall* Trpc_activate_client)(const pvoid AObj, const native_int AHandle, const bool AActivate);
typedef s32 (__stdcall* Trpc_delete_client)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_client_transmit_sync)(const pvoid AObj, const native_int AHandle, const pu8 AAddr, const native_int ASizeBytes, const s32 ATimeOutMs);
typedef s32 (__stdcall* Trpc_client_receive_sync)(const pvoid AObj, const native_int AHandle, pnative_int ASizeBytes, pu8 AAddr, const s32 ATimeOutMs);
typedef s32 (__stdcall* Trpc_tsmaster_activate_server)(const pvoid AObj, const bool AActivate);
typedef s32 (__stdcall* Trpc_tsmaster_create_client)(const pvoid AObj, const char* ATSMasterAppName, pnative_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_activate_client)(const pvoid AObj, const native_int AHandle, const bool AActivate);
typedef s32 (__stdcall* Trpc_tsmaster_delete_client)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_start_simulation)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_stop_simulation)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_write_system_var)(const pvoid AObj, const native_int AHandle, const char* ACompleteName, const char* AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_transfer_memory)(const pvoid AObj, const native_int AHandle, const pu8 AAddr, const native_int ASizeBytes);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_log)(const pvoid AObj, const native_int AHandle, const char* AMsg, const TLogLevel ALevel);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_set_mode_sim)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_set_mode_realtime)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_set_mode_free)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_sim_step)(const pvoid AObj, const native_int AHandle, const s64 ATimeUs);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_sim_step_batch_start)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_sim_step_batch_end)(const pvoid AObj, const native_int AHandle, const s64 ATimeUs);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_get_project)(const pvoid AObj, const native_int AHandle, char** AProjectFullPath);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_read_system_var)(const pvoid AObj, const native_int AHandle, char* ASysVarName, pdouble AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_read_signal)(const pvoid AObj, const native_int AHandle, const TLIBApplicationChannelType ABusType, char* AAddr, pdouble AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_write_signal)(const pvoid AObj, const native_int AHandle, const TLIBApplicationChannelType ABusType, char* AAddr, const double AValue);
typedef u16 (__stdcall* Trawsocket_htons)(const u16 x);
typedef u32 (__stdcall* Trawsocket_htonl)(const u32 x);
typedef s32 (__stdcall* Trawsocket_get_errno)(s32 ANetworkIndex);
typedef s32 (__stdcall* Trawsocket_dhcp_start)(s32 ANetworkIndex);
typedef void (__stdcall* Trawsocket_dhcp_stop)(s32 ANetworkIndex);
typedef s32 (__stdcall* Trawsocket)(s32 ANetworkIndex, s32  domain, s32 atype, s32 protocol);
typedef s32 (__stdcall* Trawsocket_close)(s32 s);
typedef s32 (__stdcall* Trawsocket_close_v2)(s32 s, s32 AForceExitTimeWait);
typedef s32 (__stdcall* Trawsocket_shutdown)(s32 s, s32 how);
typedef s32 (__stdcall* Trawsocket_listen)(s32 s, s32 backlog);
typedef native_int (__stdcall* Trawsocket_recv)(s32 s, pvoid mem, native_int len, s32 flags);
typedef native_int (__stdcall* Trawsocket_read)(s32 s, pvoid mem, native_int len);
typedef s32 (__stdcall* Trawsocket_aton)(char* cp, pip4_addr_t addr);
typedef char* (__stdcall* Trawsocket_ntoa)(pip4_addr_t addr);
typedef char* (__stdcall* Trawsocket_ntoa6)(pip6_addr_t addr);
typedef s32 (__stdcall* Trawsocket_aton6)(char* cp, pip6_addr_t addr);
typedef void (__stdcall* Ttssocket_ping4)(s32 ANetworkIndex, pip4_addr_t ping_addr, s32 repeatcnt, u32 interval_ms, u32 timeout_ms);
typedef void (__stdcall* Ttssocket_ping6)(s32 ANetworkIndex, pip6_addr_t ping_addr, s32 repeatcnt, u32 interval_ms, u32 timeout_ms);
typedef native_int (__stdcall* Trawsocket_recvmsg)(s32 s, pts_msghdr amessage, s32 flags);
typedef native_int (__stdcall* Trawsocket_recvfrom)(s32 s, pvoid mem, native_int len, s32 flags, pts_sockaddr from, pts_socklen_t fromlen);
typedef native_int (__stdcall* Trawsocket_readv)(s32 s, pts_iovec iov, s32 iovcnt);
typedef native_int (__stdcall* Trawsocket_send)(s32 s, pvoid dataptr, native_int size, s32 flags);
typedef native_int (__stdcall* Trawsocket_sendto)(s32 s, pvoid dataptr, native_int size, s32 flags, pts_sockaddr ato, tts_socklen_t tolen);
typedef native_int (__stdcall* Trawsocket_sendmsg)(s32 s, pts_msghdr amessage, s32 flags);
typedef native_int (__stdcall* Trawsocket_write)(s32 s, pvoid dataptr, native_int size);
typedef native_int (__stdcall* Trawsocket_writev)(s32 s, pts_iovec iov, s32 iovcnt);
typedef s32 (__stdcall* Trawsocket_fcntl)(s32 s, s32 cmd, s32 val);
typedef s32 (__stdcall* Trawsocket_ioctl)(s32 s, s32 cmd, pvoid argp);
typedef s32 (__stdcall* Trawsocket_accept)(s32 s, pts_sockaddr addr, pts_socklen_t addrlen);
typedef s32 (__stdcall* Trawsocket_bind)(s32 s, pts_sockaddr name, tts_socklen_t addrlen);
typedef s32 (__stdcall* Trawsocket_getsockname)(s32 s, pts_sockaddr name, pts_socklen_t namelen);
typedef s32 (__stdcall* Trawsocket_getpeername)(s32 s, pts_sockaddr name, pts_socklen_t namelen);
typedef s32 (__stdcall* Trawsocket_getsockopt)(s32 s, s32 level, s32 optname, pvoid optval, pts_socklen_t optlen);
typedef s32 (__stdcall* Trawsocket_setsockopt)(s32 s, s32 level, s32 optname, pvoid optval, tts_socklen_t optlen);
typedef s32 (__stdcall* Trawsocket_poll)(s32 ANetworkIndex, pts_pollfd fds, ts_nfds_t nfds, s32 timeout);
typedef s32 (__stdcall* Trawsocket_connect)(s32 s, pts_sockaddr name, tts_socklen_t namelen);
typedef char* (__stdcall* Trawsocket_inet_ntop)(s32 af, pvoid src, char* dst, tts_socklen_t size);
typedef s32 (__stdcall* Trawsocket_inet_pton)(s32 af, char* src, pvoid dst);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_set_can_signal)(const pvoid AObj, const native_int AHandle, const char* ASgnAddress, double AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_get_can_signal)(const pvoid AObj, const native_int AHandle, const char* ASgnAddress, pdouble AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_get_lin_signal)(const pvoid AObj, const native_int AHandle, const char* ASgnAddress, pdouble AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_set_lin_signal)(const pvoid AObj, const native_int AHandle, const char* ASgnAddress, double AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_set_flexray_signal)(const pvoid AObj, const native_int AHandle, const char* ASgnAddress, double AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_get_flexray_signal)(const pvoid AObj, const native_int AHandle, const char* ASgnAddress, pdouble AValue);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_get_constant)(const pvoid AObj, const native_int AHandle, const char* AConstName, pdouble AValue);
typedef s32 (__stdcall* Trpc_tsmaster_is_simulation_running)(const pvoid AObj, const native_int AHandle, const pbool AIsRunning);
typedef s32 (__stdcall* Trpc_tsmaster_call_system_api)(const pvoid AObj, const native_int AHandle, const char* AAPIName, const s32 AArgCount, const s32 AArgCapacity, char** AArgs);
typedef s32 (__stdcall* Trpc_tsmaster_call_library_api)(const pvoid AObj, const native_int AHandle, const char* AAPIName, const s32 AArgCount, const s32 AArgCapacity, char** AArgs);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_register_signal_cache)(const pvoid AObj, const native_int AHandle, const TLIBApplicationChannelType ABusType, const char* ASgnAddress, ps64 AId);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_unregister_signal_cache)(const pvoid AObj, const native_int AHandle, const s64 AId);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_get_signal_cache_value)(const pvoid AObj, const native_int AHandle, const s64 AId, pdouble AValue);
typedef s32 (__stdcall* Tcan_rbs_set_crc_signal_w_head_tail)(const char* ASymbolAddress, const char* AAlgorithmName, const s32 AIdxByteStart, const s32 AByteCount, const pu8 AHeadAddr, const s32 AHeadSizeBytes, const pu8 ATailAddr, const s32 ATailSizeBytes);
typedef s32 (__stdcall* Tcal_get_data_by_row_and_col)(const char* AECUName, const char* AVarName, const s32 AIdxRow, const s32 AIdxCol, double* AValue);
typedef s32 (__stdcall* Tcal_set_data_by_row_and_col)(const char* AECUName, const char* AVarName, const s32 AIdxRow, const s32 AIdxCol, const double AValue, const u8 AImmediateDownload);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_double)(const native_int AHandle, const char* AName, const s64 ATimeUs, const double AValue);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_s32)(const native_int AHandle, const char* AName, const s64 ATimeUs, const s32 AValue);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_u32)(const native_int AHandle, const char* AName, const s64 ATimeUs, const u32 AValue);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_s64)(const native_int AHandle, const char* AName, const s64 ATimeUs, const s64 AValue);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_u64)(const native_int AHandle, const char* AName, const s64 ATimeUs, const u64 AValue);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_string)(const native_int AHandle, const char* AName, const s64 ATimeUs, const char* AValue);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_double_array)(const native_int AHandle, const char* AName, const s64 ATimeUs, const pdouble AValue, const s32 AValueCount);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_s32_array)(const native_int AHandle, const char* AName, const s64 ATimeUs, const ps32 AValue, const s32 AValueCount);
typedef s32 (__stdcall* Ttslog_blf_write_sysvar_u8_array)(const native_int AHandle, const char* AName, const s64 ATimeUs, const pu8 AValue, const s32 AValueCount);
typedef s32 (__stdcall* Tcal_add_measurement_item)(const char* AECUName, const char* AVarName, const char* AEvt, const s32 AEvtType, const s32 APeriodMs);
typedef s32 (__stdcall* Tcal_delete_measurement_item)(const char* AECUName, const char* AVarName);
typedef s32 (__stdcall* Tcal_clear_measurement_items)(const char* AECUName);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_start_can_rbs)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_stop_can_rbs)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_start_lin_rbs)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_stop_lin_rbs)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_start_flexray_rbs)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_stop_flexray_rbs)(const pvoid AObj, const native_int AHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_is_can_rbs_running)(const pvoid AObj, const native_int AHandle, pbool AIsRunning);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_is_lin_rbs_running)(const pvoid AObj, const native_int AHandle, pbool AIsRunning);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_is_flexray_rbs_running)(const pvoid AObj, const native_int AHandle, pbool AIsRunning);
typedef s32 (__stdcall* Ttssocket_add_ipv4_device)(const s32 AChannel, const char* AMacAddress, const s32 AHasVlan, const s32 AVLanID, const s32 AVLanPriority, const char* AIPAddress, const char* AIPMask);
typedef s32 (__stdcall* Ttssocket_delete_ipv4_device)(const s32 AChannel, const char* AMacAddress, const s32 AHasVlan, const s32 AVLanID, const s32 AVLanPriority, const char* AIPAddress);
typedef s32 (__stdcall* Ttssocket_add_ipv6_device)(const s32 AChannel, const char* AMacAddress, const s32 AHasVlan, const s32 AVLanID, const s32 AVLanPriority, const char* AIPAddress, const char* APrefix);
typedef s32 (__stdcall* Ttssocket_delete_ipv6_device)(const s32 AChannel, const char* AMacAddress, const s32 AHasVlan, const s32 AVLanID, const s32 AVLanPriority, const char* AIPAddress);
typedef void (__stdcall* Ttsfifo_enable_receive_fifo)(void);
typedef void (__stdcall* Ttsfifo_disable_receive_fifo)(void);
typedef s32 (__stdcall* Ttsfifo_add_can_canfd_pass_filter)(s32 AIdxChn, s32 AIdentifier, bool AIsStd);
typedef s32 (__stdcall* Ttsfifo_add_lin_pass_filter)(s32 AIdxChn, s32 AIdentifier);
typedef s32 (__stdcall* Ttsfifo_delete_can_canfd_pass_filter)(s32 AIdxChn, s32 AIdentifier);
typedef s32 (__stdcall* Ttsfifo_delete_lin_pass_filter)(s32 AIdxChn, s32 AIdentifier);
typedef void (__stdcall* Ttsfifo_enable_receive_error_frames)(void);
typedef void (__stdcall* Ttsfifo_disable_receive_error_frames)(void);
typedef s32 (__stdcall* Ttsfifo_receive_can_msgs)(PCAN ACANBuffers, ps32 ACANBufferSize, s32 AIdxChn, bool AIncludeTx);
typedef s32 (__stdcall* Ttsfifo_receive_canfd_msgs)(PCANFD ACANFDBuffers, ps32 ACANBufferSize, s32 AIdxChn, bool AIncludeTx);
typedef s32 (__stdcall* Ttsfifo_receive_lin_msgs)(PLIN ALINBuffers, ps32 ABufferSize, s32 AIdxChn, bool AIncludeTx);
typedef s32 (__stdcall* Ttsfifo_receive_flexray_msgs)(PFlexRay AFRBuffers, ps32 ABufferSize, s32 AIdxChn, bool AIncludeTx);
typedef s32 (__stdcall* Ttsfifo_clear_can_receive_buffers)(s32 AIdxChn);
typedef s32 (__stdcall* Ttsfifo_clear_canfd_receive_buffers)(s32 AIdxChn);
typedef s32 (__stdcall* Ttsfifo_clear_lin_receive_buffers)(s32 AIdxChn);
typedef s32 (__stdcall* Ttsfifo_clear_flexray_receive_buffers)(s32 AIdxChn);
typedef s32 (__stdcall* Ttsfifo_read_can_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_can_tx_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_can_rx_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_canfd_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_canfd_tx_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_canfd_rx_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_lin_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_lin_tx_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_lin_rx_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_flexray_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_flexray_tx_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Ttsfifo_read_flexray_rx_buffer_frame_count)(s32 AIdxChn, ps32 ACount);
typedef s32 (__stdcall* Tflexray_rbs_reset_update_bits)(void);
typedef s32 (__stdcall* Tcan_rbs_reset_update_bits)(void);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_handle_on_autosar_crc_event)(const pvoid AObj, const TOnAutoSARE2ECanEvt AEvent);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_handle_on_autosar_rc_event)(const pvoid AObj, const TOnAutoSARE2ECanEvt AEvent);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_unhandle_on_autosar_rc_event)(const TOnAutoSARE2ECanEvt AEvent);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_unhandle_on_autosar_crc_event)(const TOnAutoSARE2ECanEvt AEvent);
typedef s32 (__stdcall* Teth_rbs_set_pdu_phase_and_cycle_by_name)(const s32 AIdxChn, const s32 APhaseMs, const s32 ACycleMs, const char* ANetworkName, const char* ANodeName, const char* APDUName);
typedef s32 (__stdcall* Tcan_rbs_set_update_bits)(void);
typedef s32 (__stdcall* Tflexray_rbs_set_update_bits)(void);
typedef s32 (__stdcall* Trpc_ip_trigger_data_group)(const s32 AGroupId);
typedef s32 (__stdcall* Tcan_rbs_get_signal_raw_by_address)(const char* ASymbolAddress, pu64 ARaw);
typedef s32 (__stdcall* Teth_rbs_start)(void);
typedef s32 (__stdcall* Teth_rbs_stop)(void);
typedef s32 (__stdcall* Teth_rbs_is_running)(const pbool AIsRunning);
typedef s32 (__stdcall* Teth_rbs_configure)(const bool AAutoStart, const bool AAutoSendOnModification, const bool AActivateNodeSimulation, const s32 AInitValueOptions);
typedef s32 (__stdcall* Teth_rbs_activate_all_networks)(const bool AEnable, const bool AIncludingChildren);
typedef s32 (__stdcall* Teth_rbs_activate_network_by_name)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, const bool AIncludingChildren);
typedef s32 (__stdcall* Teth_rbs_activate_node_by_name)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, char* ANodeName, const bool AIncludingChildren);
typedef s32 (__stdcall* Teth_rbs_activate_pdu_by_name)(const s32 AIdxChn, const bool AEnable, const char* ANetworkName, char* ANodeName, const char* APDUName);
typedef s32 (__stdcall* Teth_rbs_get_signal_value_by_element)(const s32 AIdxChn, const char* ANetworkName, char* ANodeName, const char* APDUName, const char* ASignalName, const pdouble AValue);
typedef s32 (__stdcall* Teth_rbs_set_signal_value_by_element)(const s32 AIdxChn, const char* ANetworkName, char* ANodeName, const char* APDUName, const char* ASignalName, const double AValue);
typedef s32 (__stdcall* Teth_rbs_get_signal_value_by_address)(const char* ASymbolAddress, const pdouble AValue);
typedef s32 (__stdcall* Teth_rbs_set_signal_value_by_address)(const char* ASymbolAddress, const double AValue);
typedef s32 (__stdcall* Tlin_rbs_update_frame_by_id)(const s32 AChnIdx, const u8 AId);
typedef s32 (__stdcall* Tlin_rbs_register_force_refresh_frame_by_id)(const s32 AChnIdx, const u8 AId);
typedef s32 (__stdcall* Tlin_rbs_unregister_force_refresh_frame_by_id)(const s32 AChnIdx, const u8 AId);
typedef s32 (__stdcall* Trpc_data_channel_create)(const pvoid AObj, const char* ARpcName, const s32 AIsMaster, const native_int ABufferSizeBytes, const TOnRpcData ARxEvent, pnative_int AHandle);
typedef s32 (__stdcall* Trpc_data_channel_delete)(const pvoid AObj, native_int AHandle);
typedef s32 (__stdcall* Trpc_data_channel_transmit)(const pvoid AObj, native_int AHandle, pu8 AAddr, native_int ASizeBytes, s32 ATimeOutMs);
typedef s32 (__stdcall* Ttssocket_getaddrinfo)(const s32 ANetworkIndex, const char* nodename, const char* servname, const pts_addrinfo hints, ppts_addrinfo res);
typedef s32 (__stdcall* Ttssocket_freeaddrinfo)(const s32 ANetworkIndex, const pts_addrinfo ai);
typedef s32 (__stdcall* Ttssocket_gethostname)(const s32 ANetworkIndex, const char* name, ppts_hostent ahostent);
typedef s32 (__stdcall* Ttssocket_getalldevices)(const s32 ANetworkIndex, ppts_net_device devs);
typedef s32 (__stdcall* Ttssocket_freedevices)(const s32 ANetworkIndex, pts_net_device devs);
typedef s32 (__stdcall* Trawsocket_select)(const s32 ANetworkIndex, const s32 maxfdp1, const pts_fd_set readset, const pts_fd_set writeset, const pts_fd_set exceptset, const pts_timeval timeout);
typedef s32 (__stdcall* Ttssocket_set_host_name)(const s32 ANetworkIndex, const char* AIPAddress, const char* AHostName);
typedef s32 (__stdcall* Ttsdo_set_pwm_output_async)(const s32 AChn, double ADuty, double AFrequency);
typedef s32 (__stdcall* Ttsdo_set_vlevel_output_async)(const s32 AChn, s32 AIOStatus);
typedef s32 (__stdcall* Tcan_il_register_autosar_pdu_event)(const s32 AChn, const s32 AID, const TOnAutoSARPDUQueueEvent AEvent);
typedef s32 (__stdcall* Tcan_il_unregister_autosar_pdu_event)(const s32 AChn, const s32 AID, const TOnAutoSARPDUQueueEvent AEvent);
typedef s32 (__stdcall* Tcan_il_register_autosar_pdu_pretx_event)(const s32 AChn, const s32 AID, const TOnAutoSARPDUPreTxEvent AEvent);
typedef s32 (__stdcall* Tcan_il_unregister_autosar_pdu_pretx_event)(const s32 AChn, const s32 AID, const TOnAutoSARPDUPreTxEvent AEvent);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_disturb_sequencecounter)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* ASignalGroupName, const s32 type, const s32 disturbanceMode, const s32 disturbanceCount, const s32 disturbanceValue, const s32 continueMode);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_disturb_checksum)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* ASignalGroupName, const s32 type, const s32 disturbanceMode, const s32 disturbanceCount, const s32 disturbanceValue);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_disturb_updatebit)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* ASignalGroupName, const s32 disturbanceMode, const s32 disturbanceCount, const s32 disturbanceValue);
typedef s32 (__stdcall* Tcal_add_xcp_ecu)(const char* AECUName, const char* AA2LFile, const s32 ATPLayer, const s32 AChnIdx, const s32 AEnabled);
typedef s32 (__stdcall* Tcal_add_ccp_ecu)(const char* AECUName, const char* AA2LFile, const s32 AChnIdx, const s32 AEnabled);
typedef s32 (__stdcall* Tcal_remove_ecu)(const char* AECUName);
typedef s32 (__stdcall* Tcal_get_var_property)(const char* AECUName, const char* AVarName, char** ADataType, pdouble ALowerValue, pdouble AUpperValue, pdouble AStepValue);
typedef s32 (__stdcall* Tcal_get_measurement_list)(const char* AECUName, char** AMeasurementList);
typedef s32 (__stdcall* Trpc_set_global_timeout)(const s32 ATimeOutMs);
typedef s32 (__stdcall* Ttsdi_get_vlevel_input_sync)(const s32 AChnIdx, ps32 AIOStatus, const s32 ATimeoutMs);
typedef s32 (__stdcall* Ttsdi_get_pwm_input_sync)(const s32 AChnIdx, pdouble ADuty, pdouble AFreq, const s32 ATimeoutMs);
typedef s32 (__stdcall* Tcal_get_ecu_a2l_list)(char** AECUsAndA2Ls);
typedef s32 (__stdcall* Tcal_set_all_datas_by_value)(const char* AECUName, const char* AVarName, double AValue, u8 AImmediateDownload);
typedef s32 (__stdcall* Tcal_set_all_datas_by_offset)(const char* AECUName, const char* AVarName, double AOffset, u8 AImmediateDownload);
typedef s32 (__stdcall* Tcal_set_datas_by_offset)(const char* AECUName, const char* AVarName, const s32 AStartX, const s32 AStartY, const s32 AXPointsNum, const s32 AYPointsNum, double AOffset, u8 AImmediateDownload);
typedef s32 (__stdcall* Tcal_set_datas_by_value)(const char* AECUName, const char* AVarName, const s32 AStartX, const s32 AStartY, const s32 AXPointsNum, const s32 AYPointsNum, double AValue, u8 AImmediateDownload);
typedef s32 (__stdcall* Tcal_get_axisnum_and_address)(const char* AECUName, const char* AVarName, ps32 AXPointsNum, ps32 AYPointsNum, pu32 AAdress, pu32 AExtAddress);
typedef s32 (__stdcall* Tcan_rbs_transmit_pdu)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, pu8 AData, s32 ADataLength);
typedef s32 (__stdcall* Tcan_rbs_get_signal_value_by_element_verbose)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, pdouble AValue);
typedef s32 (__stdcall* Tcan_rbs_set_signal_value_by_element_verbose)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, double AValue);
typedef s32 (__stdcall* Tflexray_rbs_set_signal_value_by_element_verbose)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, double AValue);
typedef s32 (__stdcall* Tflexray_rbs_get_signal_value_by_element_verbose)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, pdouble AValue);
typedef s32 (__stdcall* Tcan_il_register_signal_event)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, s32 ATriggerOnlyChanged, TOnSignalEvent AEvent);
typedef s32 (__stdcall* Tcan_il_unregister_signal_event)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, TOnSignalEvent AEvent);
typedef s32 (__stdcall* Tcan_rbs_time_monitor_config)(const bool AEnableTimeMonitor, const s32 ATimeoutMs, const bool AEnableCyclicPeriodRate, const s32 ACyclicPeriodRateValue);
typedef s32 (__stdcall* Tcan_il_register_signal_event_by_id)(const s32 AIdxChn, const s32 AFrameID, const u32 APDUID, const char* ASignalName, const s32 ATriggerOnlyChanged, TOnSignalEvent AEvent);
typedef s32 (__stdcall* Tcan_il_unregister_signal_event_by_id)(const s32 AIdxChn, const s32 AFrameID, const u32 APDUID, const char* ASignalName, TOnSignalEvent AEvent);
typedef s32 (__stdcall* Teth_il_register_autosar_pdu_event)(const s32 AChn, const u32 AHeaderID, const TOnAutoSARPDUQueueEvent AEvent);
typedef s32 (__stdcall* Teth_il_unregister_autosar_pdu_event)(const s32 AChn, const u32 AHeaderID, const TOnAutoSARPDUQueueEvent AEvent);
typedef s32 (__stdcall* Teth_il_register_autosar_pdu_pretx_event)(const s32 AChn, const u32 AHeaderID, const TOnAutoSARPDUPreTxEvent AEvent);
typedef s32 (__stdcall* Teth_il_unregister_autosar_pdu_pretx_event)(const s32 AChn, const u32 AHeaderID, const TOnAutoSARPDUPreTxEvent AEvent);
typedef s32 (__stdcall* Tsimulate_can_async)(const PCAN ACAN, const u8 AIsTx);
typedef s32 (__stdcall* Tsimulate_canfd_async)(const PCANFD ACANFD, const u8 AIsTx);
typedef s32 (__stdcall* Tsimulate_lin_async)(const PLIN ALIN, const u8 AIsTx);
typedef s32 (__stdcall* Tsimulate_flexray_async)(const PFlexRay AFlexRay, const u8 AIsTx);
typedef s32 (__stdcall* Tsimulate_ethernet_async)(const PEthernetHeader AEthernetHeader, const u8 AIsTx);
typedef s32 (__stdcall* Tcan_rbs_set_signal_raw_by_address)(const char* ASymbolAddress, const u64 ARaw);
typedef s32 (__stdcall* Tlin_rbs_set_signal_raw_by_address)(const char* ASymbolAddress, const u64 ARaw);
typedef s32 (__stdcall* Tlin_rbs_get_signal_raw_by_address)(const char* ASymbolAddress, pu64 ARaw);
typedef s32 (__stdcall* Trbs_get_signal_value_by_address)(const char* ASymbolAddress, double* AValue);
typedef s32 (__stdcall* Trbs_set_signal_value_by_address)(const char* ASymbolAddress, const double AValue);
typedef s32 (__stdcall* Ttsai_get_value_input_sync)(const s32 AChnIdx, ps32 AIOStatus, const s32 ATimeoutMs);
typedef s32 (__stdcall* Ttsao_set_value_output_async)(const s32 AChnIdx, s32 AIOStatus);
typedef s32 (__stdcall* Trpc_tsmaster_call_system_api_w_serialized_args)(const pvoid AObj, const native_int AHandle, const char* AAPIName, const char* ASeparator, const s32 AArgsCapacity, char* AArgs);
typedef s32 (__stdcall* Trpc_tsmaster_call_library_api_w_serialized_args)(const pvoid AObj, const native_int AHandle, const char* AAPIName, const char* ASeparator, const s32 AArgsCapacity, char* AArgs);
typedef s32 (__stdcall* Tcan_rbs_get_e2e_list_and_save_to_file)(const s32 AChnIdx, const char* AFilePath);
typedef s32 (__stdcall* Tcal_set_logical_channel_index)(const char* AECUName, const s32 AChnIdx);
typedef s32 (__stdcall* Tcal_load_new_a2l)(const char* AECUName, const char* AA2LPath);
typedef s32 (__stdcall* Tcal_switch_to_xcp)(const char* AECUName, const s32 ATPLayer);
typedef s32 (__stdcall* Tcal_switch_to_ccp)(const char* AECUName);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_disturb_checksum_verbose)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* ASignalName, const s32 AType, const s32 disturbanceMode, const s32 disturbanceCount, const s32 disturbanceValue);
typedef s32 (__stdcall* Tcan_rbs_fault_inject_disturb_sequencecounter_verbose)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* ASignalName, const s32 AType, const s32 disturbanceMode, const s32 disturbanceCount, const s32 disturbanceValue, const s32 continueMode);
typedef s32 (__stdcall* Tset_can_signal_value_verbose)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, const PCANFD ACANFD, double AValue);
typedef s32 (__stdcall* Tget_can_signal_value_verbose)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, const PCANFD ACANFD, pdouble AValue);
typedef s32 (__stdcall* Tget_flexray_signal_value_verbose)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, const PFlexRay AFlexray, pdouble AValue);
typedef s32 (__stdcall* Tset_flexray_signal_value_verbose)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ASignalName, const PFlexRay AFlexray, double AValue);
typedef s32 (__stdcall* Tset_lin_signal_value_verbose)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* ASignalName, const PLIN ALIN, double AValue);
typedef s32 (__stdcall* Tget_lin_signal_value_verbose)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* ASignalName, const PLIN ALIN, pdouble AValue);
typedef s32 (__stdcall* Tget_ethernet_signal_value_verbose)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* APDUName, const char* ASignalName, const PEthernetHeader AEthernet, pdouble AValue);
typedef s32 (__stdcall* Tset_ethernet_signal_value_verbose)(const s32 AChn, const char* ANetworkName, const char* ANodeName, const char* APDUName, const char* ASignalName, const PEthernetHeader AEthernet, double AValue);
typedef s32 (__stdcall* Ttransmit_canfd_sequential)(const s32 AIdxChn, const PCANFD ACANFDs, const pu32 AIntervalsUs, const s32 ACount, const u8 AFlags);
typedef s32 (__stdcall* Ttransmit_canfd_sequential_w_json)(const s32 AIdxChn, const char* AJsonString, const u8 AFlags, const u8 AJsonEncoding);
typedef s32 (__stdcall* Ttransmit_canxl_async)(const PCANXL ACANXL);
typedef s32 (__stdcall* Trawsocket_etharp_add_static_entry_ex)(
    const s32 ANetworkIndex,
    const char* AIpAddr,
    char* AEthAddr
);
typedef s32 (__stdcall* Trawsocket_etharp_remove_static_entry_ex)(
    const s32 ANetworkIndex,
    const char* ipaddr
);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_batch_get_signal_create_handle)(const pvoid AObj, const native_int AHandle, ps64 ABatchHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_batch_get_signal_register)(const pvoid AObj, const native_int AHandle, const s64 ABatchHandle, const TLIBApplicationChannelType ABusType, const char* ASgnAddress);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_batch_get_signal_unregister)(const pvoid AObj, const native_int AHandle, const s64 ABatchHandle, const TLIBApplicationChannelType ABusType, const char* ASgnAddress);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_batch_get_signal_read)(const pvoid AObj, const native_int AHandle, const s64 ABatchHandle, const s32 AValuesCapacity, char* AValueText);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_batch_get_signal_release)(const pvoid AObj, const native_int AHandle, const s64 ABatchHandle);
typedef s32 (__stdcall* Trpc_tsmaster_cmd_batch_get_signal_list)(const pvoid AObj, const native_int AHandle, const s64 ABatchHandle, const s32 AListCapacity, char* ARegisteredListText);
typedef s32 (__stdcall* Tcan_rbs_register_first_frame_monitor_by_node)(const s32 AChnIdx, const char* ANetworkName, const char* AECUName);
typedef s32 (__stdcall* Tcan_rbs_unregister_first_frame_monitor_by_node)(const s32 AChnIdx, const char* ANetworkName, const char* AECUName);
typedef s32 (__stdcall* Tcan_rbs_register_first_frame_monitor_by_id)(const s32 AChnIdx, const s32 AIdentifier);
typedef s32 (__stdcall* Tcan_rbs_unregister_first_frame_monitor_by_id)(const s32 AChnIdx, const s32 AIdentifier);
typedef s32 (__stdcall* Tcan_rbs_clear_first_frame_monitor_registrations)(const s32 AChnIdx);
typedef s32 (__stdcall* Tcan_rbs_start_first_frame_monitor)(const s32 AChnIdx);
typedef s32 (__stdcall* Tcan_rbs_stop_first_frame_monitor)(const s32 AChnIdx);
typedef s32 (__stdcall* Tcan_rbs_read_first_frame)(const s32 AChnIdx,
  const char* ANetworkName, const char* ANodeName, const char* AFrameName,
  const PCANFD AFrame);
typedef s32 (__stdcall* Tcan_rbs_read_first_signal)(const s32 AChnIdx,
  const char* ANetworkName, const char* ANodeName, const char* AFrameName,
  const char* APDUName, const char* ASignalName, const pdouble AValue, const ps64 ATimestampUs);
typedef s32 (__stdcall* Tcan_rbs_read_first_frame_monitor_by_id)(const s32 AChnIdx, const s32 AIdentifier, const PCANFD AFrame);
typedef s32 (__stdcall* Tcan_rbs_get_first_frame_monitor_undefined_count)(const s32 AChnIdx, const ps32 ACount);
typedef s32 (__stdcall* Tcan_rbs_get_first_frame_monitor_undefined_by_index)(const s32 AChnIdx, const s32 AIndex, const PCANFD AFrame);
typedef s32 (__stdcall* Tcan_rbs_activate_appointed_channel)(const s32 AChnIdx, const bool AEnable, const bool AIncludingChildren);
typedef s32 (__stdcall* Tcan_rbs_set_frame_data)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const pu8 ADatas, const s32 ADataLength);
typedef s32 (__stdcall* Tcan_rbs_get_frame_data)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const pu8 ADatas, const ps32 ADataLength);
typedef s32 (__stdcall* Tcan_rbs_set_byte_in_frame)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const s32 AIndex, const u8 AByteData);
typedef s32 (__stdcall* Tcan_rbs_get_byte_in_frame)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const s32 AIndex, const pu8 AByteData);
typedef s32 (__stdcall* Tcan_rbs_fault_injection_dlc_error)(const bool AEnable, const s32 AIdxChn, const s32 AIdentifier, const s32 ADLC);
typedef s32 (__stdcall* Tcan_rbs_get_read_first_frame_all_ready_timestamp)(const s32 AIdxChn, const ps64 ATimestamp);
typedef s32 (__stdcall* Tcan_rbs_is_first_received_frame)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AFrameName, const ps32 AIsFirstFrame);
typedef s32 (__stdcall* Tcan_rbs_check_frame_undefined_bits_by_address)(const char* AFrameAddress, const u8 AExpectedBit, const pbool AIsMatched);
typedef s32 (__stdcall* Tlin_rbs_check_frame_undefined_bits_by_address)(const char* AFrameAddress, const u8 AExpectedBit, const pbool AIsMatched);
typedef s32 (__stdcall* Tflexray_rbs_check_frame_undefined_bits_by_address)(const char* AFrameAddress, const u8 AExpectedBit, const pbool AIsMatched);
typedef s32 (__stdcall* Tethernet_rbs_check_pdu_undefined_bits_by_address)(const char* APDUAddress, const u8 AExpectedBit, const pbool AIsMatched);
typedef s32 (__stdcall* Tcan_rbs_check_frame_trailing_undefined_bytes_by_address)(const char* AFrameAddress, const u8 AExpectedByte, const pbool AIsMatched);
typedef s32 (__stdcall* Tlin_rbs_check_frame_trailing_undefined_bytes_by_address)(const char* AFrameAddress, const u8 AExpectedByte, const pbool AIsMatched);
typedef s32 (__stdcall* Tflexray_rbs_check_frame_trailing_undefined_bytes_by_address)(const char* AFrameAddress, const u8 AExpectedByte, const pbool AIsMatched);
typedef s32 (__stdcall* Tethernet_rbs_check_pdu_trailing_undefined_bytes_by_address)(const char* APDUAddress, const u8 AExpectedByte, const pbool AIsMatched);
typedef s32 (__stdcall* Tcan_rbs_is_first_received_frame_by_id)(const s32 AChnIdx, const u32 AIdentifier, const bool ARequireRegisteredId, const ps32 AIsFirstFrame);
typedef struct _TCANRBSFramePeriodStatistics {
    u32 FStructSize;
    u32 FFlags;
    u64 FFrameCount;
    u64 FPeriodSampleCount;
    u64 FFirstTimestampUs;
    u64 FLastTimestampUs;
    u64 FCurrentPeriodUs;
    u64 FMinPeriodUs;
    u64 FMaxPeriodUs;
    double FAveragePeriodUs;
    u64 FNonMonotonicTimestampCount;
} TCANRBSFramePeriodStatistics, *PCANRBSFramePeriodStatistics;
typedef s32 (__stdcall* Tcan_rbs_enable_frame_property_monitor)(const s32 AChnIdx, const bool AEnable, const bool AReset);
typedef s32 (__stdcall* Tcan_rbs_get_frame_dlc_monitor_result)(const s32 AChnIdx, const u32 AIdentifier, const u8 ADLC);
typedef s32 (__stdcall* Tcan_rbs_get_frame_period_statistics)(const s32 AChnIdx, const u32 AIdentifier, const PCANRBSFramePeriodStatistics AStatistics);
typedef s32 (__stdcall* Tcan_rbs_get_frame_ack_error_monitor_result)(const s32 AChnIdx, const ps32 AHasACKError, const ps64 AFirstACKTimestampUs);
typedef s32 (__stdcall* Tcan_rbs_get_rx_rc_error_by_address)(const char* ASymbolAddress, const ps32 AHasError);
typedef s32 (__stdcall* Tcan_rbs_get_rx_crc_error_by_address)(const char* ASymbolAddress, const ps32 AHasError);
typedef s32 (__stdcall* Tcan_rbs_fault_injection_message_lost_count)(const s32 AIdxChn, const s32 AIdentifier, const s32 ALostCount);
typedef s32 (__stdcall* Tcan_rbs_send_message_by_name_n_times)(const s32 AIdxChn, const char* ANetworkName, const char* ANodeName, const char* AMsgName, const s32 ASendCount, const s32 AIntervalMs);
typedef s32 (__stdcall* Tcan_rbs_set_rc_fault_mode)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ARCSignalName, const s32 AMode);
typedef s32 (__stdcall* Tcan_rbs_set_crc_fault_mode)(const s32 AChnIdx, const char* ANetworkName, const char* ANodeName, const char* AMessageName, const char* APDUName, const char* ACRCSignalName, const s32 AMode);
typedef s32 (__stdcall* Tcan_rbs_enable_automatic_tx_algorithm)(const bool AEnable);
typedef s32 (__stdcall* Tcan_rbs_enable_automatic_rx_algorithm)(const bool AEnable);
typedef s32 (__stdcall* Tcan_rbs_read_first_received_frame)(const s32 AChnIdx, const PCANFD AActualFirstFrame);
// >>> mp com prototype end <<<

typedef struct _TTSCOM {
    void*                                   FObj;
    // >>> mp com start <<<
    TTransmitCANAsync                       transmit_can_async;
    TTransmitCANSync                        transmit_can_sync;
    TTransmitCANFDAsync                     transmit_canfd_async;
    TTransmitCANFDSync                      transmit_canfd_sync;
    TTransmitLINAsync                       transmit_lin_async;
    TTransmitLINSync                        transmit_lin_sync;
    TGetCANSignalValue                      get_can_signal_value;
    TSetCANSignalValue                      set_can_signal_value;
    TEnableBusStatistics                    enable_bus_statistics;
    TClearBusStatistics                     clear_bus_statistics;
    TGetBusStatistics                       get_bus_statistics;
    TGetFPSCAN                              get_fps_can;
    TGetFPSCANFD                            get_fps_canfd;
    TGetFPSLIN                              get_fps_lin;
    TWaitCANMessage                         internal_wait_can_message;
    TWaitCANFDMessage                       internal_wait_canfd_message;
    TAddCyclicMsgCAN                        add_cyclic_message_can;
    TAddCyclicMsgCANFD                      add_cyclic_message_canfd;
    TDeleteCyclicMsgCAN                     del_cyclic_message_can;
    TDeleteCyclicMsgCANFD                   del_cyclic_message_canfd;
    TDeleteCyclicMsgs                       del_cyclic_messages;    
    TRegisterCANEvent                       internal_register_event_can;
    TUnregisterCANEvent                     internal_unregister_event_can;
    TRegisterCANFDEvent                     internal_register_event_canfd;
    TUnregisterCANFDEvent                   internal_unregister_event_canfd;
    TRegisterLINEvent                       internal_register_event_lin;
    TUnregisterLINEvent                     internal_unregister_event_lin;    
    TUnregisterCANEvents                    internal_unregister_events_can;
    TUnregisterLINEvents                    internal_unregister_events_lin;
    TUnregisterCANFDEvents                  internal_unregister_events_canfd;
    TUnregisterALLEvents                    internal_unregister_events_all;
    Ttslog_add_online_replay_config         tslog_add_online_replay_config ;
    Ttslog_set_online_replay_config         tslog_set_online_replay_config ;
    Ttslog_get_online_replay_count          tslog_get_online_replay_count  ;
    Ttslog_get_online_replay_config         tslog_get_online_replay_config ;
    Ttslog_del_online_replay_config         tslog_del_online_replay_config ;
    Ttslog_del_online_replay_configs        tslog_del_online_replay_configs;
    Ttslog_start_online_replay              tslog_start_online_replay      ;
    Ttslog_start_online_replays             tslog_start_online_replays     ;
    Ttslog_pause_online_replay              tslog_pause_online_replay      ;
    Ttslog_pause_online_replays             tslog_pause_online_replays     ;
    Ttslog_stop_online_replay               tslog_stop_online_replay       ;
    Ttslog_stop_online_replays              tslog_stop_online_replays      ;
    Ttslog_get_online_replay_status         tslog_get_online_replay_status ;
    TCANRBSStart                            can_rbs_start;
    TCANRBSStop                             can_rbs_stop;
    TCANRBSIsRunning                        can_rbs_is_running;
    TCANRBSConfigure                        can_rbs_configure;
    TCANRBSActivateAllNetworks              can_rbs_activate_all_networks;
    TCANRBSActivateNetworkByName            can_rbs_activate_network_by_name;
    TCANRBSActivateNodeByName               can_rbs_activate_node_by_name;
    TCANRBSActivateMessageByName            can_rbs_activate_message_by_name;
    TCANRBSGetSignalValueByElement          can_rbs_get_signal_value_by_element;
    TCANRBSGetSignalValueByAddress          can_rbs_get_signal_value_by_address;
    TCANRBSSetSignalValueByElement          can_rbs_set_signal_value_by_element;
    TCANRBSSetSignalValueByAddress          can_rbs_set_signal_value_by_address;
    TRegisterPreTxCANEvent                  internal_register_pretx_event_can;
    TUnregisterPreTxCANEvent                internal_unregister_pretx_event_can;    
    TRegisterPreTxCANFDEvent                internal_register_pretx_event_canfd;
    TUnregisterPreTxCANFDEvent              internal_unregister_pretx_event_canfd;
    TRegisterPreTxLINEvent                  internal_register_pretx_event_lin;
    TUnregisterPreTxLINEvent                internal_unregister_pretx_event_lin;    
    TUnregisterPreTxCANEvents               internal_unregister_pretx_events_can;
    TUnregisterPreTxLINEvents               internal_unregister_pretx_events_lin;
    TUnregisterPreTxCANFDEvents             internal_unregister_pretx_events_canfd;
    TUnregisterPreTxALLEvents               internal_unregister_pretx_events_all;
    Ttslog_blf_write_start                  tslog_blf_write_start     ;
    Ttslog_blf_write_can                    tslog_blf_write_can       ;
    Ttslog_blf_write_can_fd                 tslog_blf_write_can_fd    ;
    Ttslog_blf_write_lin                    tslog_blf_write_lin       ;
    Ttslog_blf_write_end                    tslog_blf_write_end       ;
    Ttslog_blf_read_start                   tslog_blf_read_start      ;
    Ttslog_blf_read_status                  tslog_blf_read_status     ;
    Ttslog_blf_read_object                  tslog_blf_read_object     ;
    Ttslog_blf_read_end                     tslog_blf_read_end        ;
    Ttslog_blf_seek_object_time             tslog_blf_seek_object_time;
    Ttslog_blf_to_asc                       tslog_blf_to_asc          ;
    Ttslog_asc_to_blf                       tslog_asc_to_blf          ;
    TIoIPCreate                             internal_ioip_create               ;
    TIoIPDelete                             internal_ioip_delete               ;
    TIoIPEnableTCPServer                    internal_ioip_enable_tcp_server    ;
    TIoIPEnableUDPServer                    internal_ioip_enable_udp_server    ;
    TIoIPConnectTCPServer                   internal_ioip_connect_tcp_server   ;
    TIoIPConnectUDPServer                   internal_ioip_connect_udp_server   ;
    TIoIPDisconnectTCPServer                internal_ioip_disconnect_tcp_server;
    TIoIPSendBufferTCP                      internal_ioip_send_buffer_tcp      ;
    TIoIPSendBufferUDP                      internal_ioip_send_buffer_udp      ;
    Ttslog_blf_write_realtime_comment       tslog_blf_write_realtime_comment   ;
    Ttslog_blf_read_object_w_comment        tslog_blf_read_object_w_comment    ;
    TIoIPRecvTCPClientResponse              internal_ioip_receive_tcp_client_response;
    TIoIPSendTCPServerResponse              internal_ioip_send_tcp_server_response;
    TIoIPSendUDPBroadcast                   internal_ioip_send_udp_broadcast;
    TIoIPSetUDPServerBufferSize             internal_ioip_set_udp_server_buffer_size;
    TIoIPRecvUDPClientResponse              internal_ioip_receive_udp_client_response;
    TIoIPSendUDPServerResponse              internal_ioip_send_udp_server_response;
    Ttslog_blf_write_start_w_timestamp      tslog_blf_write_start_w_timestamp;
    Ttslog_blf_write_set_max_count          tslog_blf_write_set_max_count;
    TCANRBSSetMessageCycleByName            can_rbs_set_message_cycle_by_name;
    TSgnSrvRegisterCANSignalByMsgId         sgnsrv_register_can_signal_by_msg_identifier;
    TSgnSrvRegisterLINSignalByMsgId         sgnsrv_register_lin_signal_by_msg_identifier;
    TSgnSrvRegisterCANSignalByMsgName       sgnsrv_register_can_signal_by_msg_name;
    TSgnSrvRegisterLINSignalByMsgName       sgnsrv_register_lin_signal_by_msg_name;
    TSgnSrvGetCANSignalPhyValueLatest       sgnsrv_get_can_signal_phy_value_latest;
    TSgnSrvGetLINSignalPhyValueLatest       sgnsrv_get_lin_signal_phy_value_latest;
    TSgnSrvGetCANSignalPhyValueInMsg        sgnsrv_get_can_signal_phy_value_in_msg;
    TSgnSrvGetLINSignalPhyValueInMsg        sgnsrv_get_lin_signal_phy_value_in_msg;
    TCANRBSEnable                           can_rbs_enable;
    TCANRBSBatchSetStart                    can_rbs_batch_set_start;
    TCANRBSBatchSetEnd                      can_rbs_batch_set_end;
    TInjectCANMessage                       inject_can_message;
    TInjectLINMessage                       inject_lin_message;
    TCANRBSBatchSetSignal                   can_rbs_batch_set_signal;
    TCANRBSSetMessageDirection              can_rbs_set_message_direction;
    Tadd_precise_cyclic_message             add_precise_cyclic_message;
    Tdelete_precise_cyclic_message          delete_precise_cyclic_message;
    TPDUContainerSetCycleCount              pdu_container_set_cycle_count;
    TPDUContainerSetCycleByIndex            pdu_container_set_cycle_by_index;
    TPDUContainerGetCycleCount              pdu_container_get_cycle_count;
    TPDUContainerGetCycleByIndex            pdu_container_get_cycle_by_index;
    TPDUContainerRefresh                    pdu_container_refresh;
    TCANRBSFaultInjectionClear              can_rbs_fault_inject_clear;
    TCANRBSFaultInjectionMessageLost        can_rbs_fault_inject_message_lost;
    TCANRBSFaultInjectionSignalAlter        can_rbs_fault_inject_signal_alter;
    TJ1939MakeId                            j1939_make_id;
    TJ1939ExtractId                         j1939_extract_id;
    TJ1939GetPGN                            j1939_get_pgn;
    TJ1939GetSource                         j1939_get_source;
    TJ1939GetDestination                    j1939_get_destination;
    TJ1939GetPriority                       j1939_get_priority;
    TJ1939GetR                              j1939_get_r;
    TJ1939GetDP                             j1939_get_dp;
    TJ1939GetEDP                            j1939_get_edp;
    TJ1939SetPGN                            j1939_set_pgn;
    TJ1939SetSource                         j1939_set_source;
    TJ1939SetDestination                    j1939_set_destination;
    TJ1939SetPriority                       j1939_set_priority;
    TJ1939SetR                              j1939_set_r;
    TJ1939SetDP                             j1939_set_dp;
    TJ1939SetEDP                            j1939_set_edp;
    TJ1939GetLastPDU                        j1939_get_last_pdu;
    TJ1939GetLastPDUAsString                j1939_get_last_pdu_as_string;
    TJ1939TransmitPDUAsync                  j1939_transmit_pdu_async;
    TJ1939TransmitPDUSync                   j1939_transmit_pdu_sync;
    TJ1939TransmitPDUAsStringAsync          j1939_transmit_pdu_as_string_async;
    TJ1939TransmitPDUAsStringSync           j1939_transmit_pdu_as_string_sync;
    TCANRBSSetNormalSignal                  can_rbs_set_normal_signal;
    TCANRBSSetRCSignal                      can_rbs_set_rc_signal;
    TCANRBSSetCRCSignal                     can_rbs_set_crc_signal;
    TCANRBSSetRCSignalWithLimit             can_rbs_set_rc_signal_with_limit;
    TGetCANSignalDefinitionVerbose          get_can_signal_definition_verbose;
    TGetCANSignalDefinition                 get_can_signal_definition;
    TTransmitFlexRayASync                   transmit_flexray_async;
    TTransmitFlexRaySync                    transmit_flexray_sync;
    TGetFlexRaySignalValue                  get_flexray_signal_value;
    TSetFlexRaySignalValue                  set_flexray_signal_value;
    TRegisterFlexRayEvent                   internal_register_event_flexray;
    TUnregisterFlexRayEvent                 internal_unregister_event_flexray;
    TInjectFlexRayFrame                     inject_flexray_frame;
    TGetFlexRaySignalDefinition             get_flexray_signal_definition;
    Ttslog_blf_write_flexray                tslog_blf_write_flexray;
    TSgnSrvRegisterFlexRaySignalByFrame     sgnsrv_register_flexray_signal_by_frame;
    TSgnSrvRegisterFlexRaySignalByFrameName sgnsrv_register_flexray_signal_by_frame_name;
    TSgnSrvGetFlexRaySignalPhyValueLatest   sgnsrv_get_flexray_signal_phy_value_latest;
    TSgnSrvGetFlexRaySignalPhyValueInFrame  sgnsrv_get_flexray_signal_phy_value_in_frame;
    TUnregisterFlexRayEvents                internal_unregister_events_flexray;
    TRegisterPreTxFlexRayEvent              internal_register_pretx_event_flexray;
    TUnregisterPreTxFlexRayEvent            internal_unregister_pretx_event_flexray;  
    TUnregisterPreTxFlexRayEvents           internal_unregister_pretx_events_flexray;
    TFlexRayRBSStart                        flexray_rbs_start;
    TFlexRayRBSStop                         flexray_rbs_stop;
    TFlexRayRBSIsRunning                    flexray_rbs_is_running;
    TFlexRayRBSConfigure                    flexray_rbs_configure;
    TFlexRayRBSEnable                       flexray_rbs_enable;
    TFlexRayRBSActivateAllClusters          flexray_rbs_activate_all_clusters;
    TFlexRayRBSActivateClusterByName        flexray_rbs_activate_cluster_by_name;
    TFlexRayRBSActivateECUByName            flexray_rbs_activate_ecu_by_name;
    TFlexRayRBSActivateFrameByName          flexray_rbs_activate_frame_by_name;
    TFlexRayRBSGetSignalValueByElement      flexray_rbs_get_signal_value_by_element;
    TFlexRayRBSGetSignalValueByAddress      flexray_rbs_get_signal_value_by_address;
    TFlexRayRBSSetSignalValueByElement      flexray_rbs_set_signal_value_by_element;
    TFlexRayRBSSetSignalValueByAddress      flexray_rbs_set_signal_value_by_address;
    TFlexRayRBSBatchSetStart                flexray_rbs_batch_set_start;
    TFlexRayRBSBatchSetEnd                  flexray_rbs_batch_set_end;
    TFlexRayRBSBatchSetSignal               flexray_rbs_batch_set_signal;
    TFlexRayRBSSetFrameDirection            flexray_rbs_set_frame_direction;
    TFlexRayRBSSetNormalSignal              flexray_rbs_set_normal_signal;
    TFlexRayRBSSetRCSignal                  flexray_rbs_set_rc_signal;
    TFlexRayRBSSetRCSignalWithLimit         flexray_rbs_set_rc_signal_with_limit;
    TFlexRayRBSSetCRCSignal                 flexray_rbs_set_crc_signal;
    TGetLINSignalValue                      get_lin_signal_value;
    TSetLINSignalValue                      set_lin_signal_value;
    TTransmitCANAsync                       transmit_can_async_wo_pretx;
    TTransmitCANFDAsync                     transmit_canfd_async_wo_pretx;
    TTransmitLINAsync                       transmit_lin_async_wo_pretx;
    TTransmitFlexRayASync                   transmit_flexray_async_wo_pretx;
    TDisableOnlineReplayFilter              tslog_disable_online_replay_filter;
    TSetOnlineReplayFilter                  tslog_set_online_replay_filter;    
    TSetCANSignalRawValue set_can_signal_raw_value;
    TGetCANSignalRawValue get_can_signal_raw_value;
    TSetLINSignalRawValue set_lin_signal_raw_value;
    TGetLINSignalRawValue get_lin_signal_raw_value;
    TSetFlexRaySignalRawValue set_flexray_signal_raw_value;
    TGetFlexRaySignalRawValue get_flexray_signal_raw_value;
    TFlexRayRBSUpdateFrameByHeader flexray_rbs_update_frame_by_header;
    TLINRBSStart                            lin_rbs_start;
    TLINRBSStop                             lin_rbs_stop;
    TLINRBSIsRunning                        lin_rbs_is_running;
    TLINRBSConfigure                        lin_rbs_configure;
    TLINRBSActivateAllNetworks              lin_rbs_activate_all_networks;
    TLINRBSActivateNetworkByName            lin_rbs_activate_network_by_name;
    TLINRBSActivateNodeByName               lin_rbs_activate_node_by_name;
    TLINRBSActivateMessageByName            lin_rbs_activate_message_by_name;
    TLINBSSetMessageDelayTimeByName         lin_rbs_set_message_delay_time_by_name;
    TLINRBSGetSignalValueByElement          lin_rbs_get_signal_value_by_element;
    TLINRBSGetSignalValueByAddress          lin_rbs_get_signal_value_by_address;
    TLINRBSSetSignalValueByElement          lin_rbs_set_signal_value_by_element;
    TLINRBSSetSignalValueByAddress          lin_rbs_set_signal_value_by_address;
    TLINRBSEnable                           lin_rbs_enable;
    TLINRBSBatchSetStart                    lin_rbs_batch_set_start;
    TLINRBSBatchSetEnd                      lin_rbs_batch_set_end;
    TLINRBSBatchSetSignal                   lin_rbs_batch_set_signal;
    TTransmitEthernetASync transmit_ethernet_async;
    TTransmitEthernetSync transmit_ethernet_sync;
    TInjectEthernetFrame inject_ethernet_frame;
    TTSLogBlfWriteEthernet tslog_blf_write_ethernet;
    TRegisterEthernetEvent internal_register_event_ethernet;
    TUnregisterEthernetEvent internal_unregister_event_ethernet;
    TUnregisterEthernetEvents internal_unregister_events_ethernet;
    TRegisterPreTxEthernetEvent internal_register_pretx_event_ethernet;
    TUnregisterPreTxEthernetEvent internal_unregister_pretx_event_ethernet;  
    TUnregisterPreTxEthernetEvents internal_unregister_pretx_events_ethernet;
    TTransmitEthernetAsyncWoPretx transmit_ethernet_async_wo_pretx;
    TIoIpSetOnConnectionCallback internal_ioip_set_tcp_server_connection_callback;
    TEthBuildIPv4UDPPacket eth_build_ipv4_udp_packet;
    TBlockCurrentPreTx internal_block_current_pretx;
    TEthernetIsUDPPacket eth_is_udp_packet;
    TEthernetIPCalcHeaderChecksum eth_ip_calc_header_checksum;
    TEthernetUDPCalcChecksum eth_udp_calc_checksum;
    TEthernetUDPCalcChecksumOnFrame eth_udp_calc_checksum_on_frame;
    TEthLogEthernetFrameData eth_log_ethernet_frame_data;
    Tlin_clear_schedule_tables lin_clear_schedule_tables;
    Tlin_stop_lin_channel lin_stop_lin_channel;
    Tlin_start_lin_channel lin_start_lin_channel;
    Tlin_switch_runtime_schedule_table lin_switch_runtime_schedule_table;
    Tlin_switch_idle_schedule_table lin_switch_idle_schedule_table;
    Tlin_switch_normal_schedule_table lin_switch_normal_schedule_table;
    Tlin_batch_set_schedule_start lin_batch_set_schedule_start;
    Tlin_batch_add_schedule_frame lin_batch_add_schedule_frame;
    Tlin_batch_set_schedule_end lin_batch_set_schedule_end;
    Tlin_set_node_functiontype lin_set_node_functiontype;
    Tlin_active_frame_in_schedule_table lin_active_frame_in_schedule_table;
    Tlin_deactive_frame_in_schedule_table lin_deactive_frame_in_schedule_table;
    Tflexray_disable_frame flexray_disable_frame;
    Tflexray_enable_frame flexray_enable_frame;
    Tflexray_start_net flexray_start_net;
    Tflexray_stop_net flexray_stop_net;
    Tflexray_wakeup_pattern flexray_wakeup_pattern;
    TSetFlexRayAutoUBHandle set_flexray_ub_bit_auto_handle;
    Teth_frame_clear_vlans eth_frame_clear_vlans;
    Teth_frame_append_vlan eth_frame_append_vlan;
    Teth_frame_append_vlans eth_frame_append_vlans;
    Teth_frame_remove_vlan eth_frame_remove_vlan;
    Teth_build_ipv4_udp_packet_on_frame eth_build_ipv4_udp_packet_on_frame;
    Teth_udp_fragment_processor_clear internal_eth_udp_fragment_processor_clear;
    Teth_udp_fragment_processor_parse internal_eth_udp_fragment_processor_parse;
    Teth_frame_insert_vlan eth_frame_insert_vlan;
    Ttelnet_create internal_telnet_create;
    Ttelnet_delete internal_telnet_delete;
    Ttelnet_send_string internal_telnet_send_string;
    Ttelnet_connect internal_telnet_connect;
    Ttelnet_disconnect internal_telnet_disconnect;
    Ttelnet_set_connection_callback internal_telnet_set_connection_callback;
    Ttelnet_enable_debug_print internal_telnet_enable_debug_print;
    Ttslog_blf_to_pcap tslog_blf_to_pcap;
    Ttslog_pcap_to_blf tslog_pcap_to_blf;
    Ttslog_pcapng_to_blf tslog_pcapng_to_blf;
    Ttslog_blf_to_pcapng tslog_blf_to_pcapng;
    Ttssocket_tcp tssocket_tcp;
    Ttssocket_udp tssocket_udp;
    Ttssocket_tcp_start_listen tssocket_tcp_start_listen;
    Ttssocket_tcp_start_receive tssocket_tcp_start_receive;
    Ttssocket_tcp_close tssocket_tcp_close;
    Ttssocket_udp_start_receive tssocket_udp_start_receive;
    Ttssocket_udp_close tssocket_udp_close;
    Ttssocket_tcp_connect tssocket_tcp_connect;
    Ttssocket_tcp_send tssocket_tcp_send;
    Ttssocket_tcp_sendto_client tssocket_tcp_sendto_client;
    Ttssocket_udp_sendto tssocket_udp_sendto;
    Ttssocket_udp_sendto_v2 tssocket_udp_sendto_v2;
    Ttssocket_tcp_close_v2 tssocket_tcp_close_v2;
    Trpc_create_server internal_rpc_create_server;
    Trpc_activate_server internal_rpc_activate_server;
    Trpc_delete_server internal_rpc_delete_server;
    Trpc_server_write_sync internal_rpc_server_write_sync;
    Trpc_create_client internal_rpc_create_client;
    Trpc_activate_client internal_rpc_activate_client;
    Trpc_delete_client internal_rpc_delete_client;
    Trpc_client_transmit_sync internal_rpc_client_transmit_sync;
    Trpc_client_receive_sync internal_rpc_client_receive_sync;
    Trpc_tsmaster_activate_server internal_rpc_tsmaster_activate_server;
    Trpc_tsmaster_create_client internal_rpc_tsmaster_create_client;
    Trpc_tsmaster_activate_client internal_rpc_tsmaster_activate_client;
    Trpc_tsmaster_delete_client internal_rpc_tsmaster_delete_client;
    Trpc_tsmaster_cmd_start_simulation internal_rpc_tsmaster_cmd_start_simulation;
    Trpc_tsmaster_cmd_stop_simulation internal_rpc_tsmaster_cmd_stop_simulation;
    Trpc_tsmaster_cmd_write_system_var internal_rpc_tsmaster_cmd_write_system_var;
    Trpc_tsmaster_cmd_transfer_memory internal_rpc_tsmaster_cmd_transfer_memory;
    Trpc_tsmaster_cmd_log internal_rpc_tsmaster_cmd_log;
    Trpc_tsmaster_cmd_set_mode_sim internal_rpc_tsmaster_cmd_set_mode_sim;
    Trpc_tsmaster_cmd_set_mode_realtime internal_rpc_tsmaster_cmd_set_mode_realtime;
    Trpc_tsmaster_cmd_set_mode_free internal_rpc_tsmaster_cmd_set_mode_free;
    Trpc_tsmaster_cmd_sim_step internal_rpc_tsmaster_cmd_sim_step;
    Trpc_tsmaster_cmd_sim_step_batch_start internal_rpc_tsmaster_cmd_sim_step_batch_start;
    Trpc_tsmaster_cmd_sim_step_batch_end internal_rpc_tsmaster_cmd_sim_step_batch_end;
    Trpc_tsmaster_cmd_get_project internal_rpc_tsmaster_cmd_get_project;
    Trpc_tsmaster_cmd_read_system_var internal_rpc_tsmaster_cmd_read_system_var;
    Trpc_tsmaster_cmd_read_signal internal_rpc_tsmaster_cmd_read_signal;
    Trpc_tsmaster_cmd_write_signal internal_rpc_tsmaster_cmd_write_signal;
    Trawsocket_htons rawsocket_htons;
    Trawsocket_htonl rawsocket_htonl;
    Trawsocket_get_errno rawsocket_get_errno;
    Trawsocket_dhcp_start rawsocket_dhcp_start;
    Trawsocket_dhcp_stop rawsocket_dhcp_stop;
    Trawsocket rawsocket;
    Trawsocket_close rawsocket_close;
    Trawsocket_close_v2 rawsocket_close_v2;
    Trawsocket_shutdown rawsocket_shutdown;
    Trawsocket_listen rawsocket_listen;
    Trawsocket_recv rawsocket_recv;
    Trawsocket_read rawsocket_read;
    Trawsocket_aton rawsocket_aton;
    Trawsocket_ntoa rawsocket_ntoa;
    Trawsocket_ntoa6 rawsocket_ntoa6;
    Trawsocket_aton6 rawsocket_aton6;
    Ttssocket_ping4 tssocket_ping4;
    Ttssocket_ping6 tssocket_ping6;
    Trawsocket_recvmsg rawsocket_recvmsg;
    Trawsocket_recvfrom rawsocket_recvfrom;
    Trawsocket_readv rawsocket_readv;
    Trawsocket_send rawsocket_send;
    Trawsocket_sendto rawsocket_sendto;
    Trawsocket_sendmsg rawsocket_sendmsg;
    Trawsocket_write rawsocket_write;
    Trawsocket_writev rawsocket_writev;
    Trawsocket_fcntl rawsocket_fcntl;
    Trawsocket_ioctl rawsocket_ioctl;
    Trawsocket_accept rawsocket_accept;
    Trawsocket_bind rawsocket_bind;
    Trawsocket_getsockname rawsocket_getsockname;
    Trawsocket_getpeername rawsocket_getpeername;
    Trawsocket_getsockopt rawsocket_getsockopt;
    Trawsocket_setsockopt rawsocket_setsockopt;
    Trawsocket_poll rawsocket_poll;
    Trawsocket_connect rawsocket_connect;
    Trawsocket_inet_ntop rawsocket_inet_ntop;
    Trawsocket_inet_pton rawsocket_inet_pton;
    Trpc_tsmaster_cmd_set_can_signal internal_rpc_tsmaster_cmd_set_can_signal;
    Trpc_tsmaster_cmd_get_can_signal internal_rpc_tsmaster_cmd_get_can_signal;
    Trpc_tsmaster_cmd_get_lin_signal internal_rpc_tsmaster_cmd_get_lin_signal;
    Trpc_tsmaster_cmd_set_lin_signal internal_rpc_tsmaster_cmd_set_lin_signal;
    Trpc_tsmaster_cmd_set_flexray_signal internal_rpc_tsmaster_cmd_set_flexray_signal;
    Trpc_tsmaster_cmd_get_flexray_signal internal_rpc_tsmaster_cmd_get_flexray_signal;
    Trpc_tsmaster_cmd_get_constant internal_rpc_tsmaster_cmd_get_constant;
    Trpc_tsmaster_is_simulation_running internal_rpc_tsmaster_is_simulation_running;
    Trpc_tsmaster_call_system_api internal_rpc_tsmaster_call_system_api;
    Trpc_tsmaster_call_library_api internal_rpc_tsmaster_call_library_api;    
    Trpc_tsmaster_cmd_register_signal_cache internal_rpc_tsmaster_cmd_register_signal_cache;
    Trpc_tsmaster_cmd_unregister_signal_cache internal_rpc_tsmaster_cmd_unregister_signal_cache;
    Trpc_tsmaster_cmd_get_signal_cache_value internal_rpc_tsmaster_cmd_get_signal_cache_value;
    Tcan_rbs_set_crc_signal_w_head_tail can_rbs_set_crc_signal_w_head_tail;
    Tcal_get_data_by_row_and_col cal_get_data_by_row_and_col;
    Tcal_set_data_by_row_and_col cal_set_data_by_row_and_col;
    Ttslog_blf_write_sysvar_double tslog_blf_write_sysvar_double;
    Ttslog_blf_write_sysvar_s32 tslog_blf_write_sysvar_s32;
    Ttslog_blf_write_sysvar_u32 tslog_blf_write_sysvar_u32;
    Ttslog_blf_write_sysvar_s64 tslog_blf_write_sysvar_s64;
    Ttslog_blf_write_sysvar_u64 tslog_blf_write_sysvar_u64;
    Ttslog_blf_write_sysvar_string tslog_blf_write_sysvar_string;
    Ttslog_blf_write_sysvar_double_array tslog_blf_write_sysvar_double_array;
    Ttslog_blf_write_sysvar_s32_array tslog_blf_write_sysvar_s32_array;
    Ttslog_blf_write_sysvar_u8_array tslog_blf_write_sysvar_u8_array;
    Tcal_add_measurement_item cal_add_measurement_item;
    Tcal_delete_measurement_item cal_delete_measurement_item;
    Tcal_clear_measurement_items cal_clear_measurement_items;
    Trpc_tsmaster_cmd_start_can_rbs internal_rpc_tsmaster_cmd_start_can_rbs;
    Trpc_tsmaster_cmd_stop_can_rbs internal_rpc_tsmaster_cmd_stop_can_rbs;
    Trpc_tsmaster_cmd_start_lin_rbs internal_rpc_tsmaster_cmd_start_lin_rbs;
    Trpc_tsmaster_cmd_stop_lin_rbs internal_rpc_tsmaster_cmd_stop_lin_rbs;
    Trpc_tsmaster_cmd_start_flexray_rbs internal_rpc_tsmaster_cmd_start_flexray_rbs;
    Trpc_tsmaster_cmd_stop_flexray_rbs internal_rpc_tsmaster_cmd_stop_flexray_rbs;
    Trpc_tsmaster_cmd_is_can_rbs_running internal_rpc_tsmaster_cmd_is_can_rbs_running;
    Trpc_tsmaster_cmd_is_lin_rbs_running internal_rpc_tsmaster_cmd_is_lin_rbs_running;
    Trpc_tsmaster_cmd_is_flexray_rbs_running internal_rpc_tsmaster_cmd_is_flexray_rbs_running;
    Ttssocket_add_ipv4_device tssocket_add_ipv4_device;
    Ttssocket_delete_ipv4_device tssocket_delete_ipv4_device;
    Ttsfifo_enable_receive_fifo tsfifo_enable_receive_fifo;
    Ttsfifo_disable_receive_fifo tsfifo_disable_receive_fifo;
    Ttsfifo_add_can_canfd_pass_filter tsfifo_add_can_canfd_pass_filter;
    Ttsfifo_add_lin_pass_filter tsfifo_add_lin_pass_filter;
    Ttsfifo_delete_can_canfd_pass_filter tsfifo_delete_can_canfd_pass_filter;
    Ttsfifo_delete_lin_pass_filter tsfifo_delete_lin_pass_filter;
    Ttsfifo_enable_receive_error_frames tsfifo_enable_receive_error_frames;
    Ttsfifo_disable_receive_error_frames tsfifo_disable_receive_error_frames;
    Ttsfifo_receive_can_msgs tsfifo_receive_can_msgs;
    Ttsfifo_receive_canfd_msgs tsfifo_receive_canfd_msgs;
    Ttsfifo_receive_lin_msgs tsfifo_receive_lin_msgs;
    Ttsfifo_receive_flexray_msgs tsfifo_receive_flexray_msgs;
    Ttsfifo_clear_can_receive_buffers tsfifo_clear_can_receive_buffers;
    Ttsfifo_clear_canfd_receive_buffers tsfifo_clear_canfd_receive_buffers;
    Ttsfifo_clear_lin_receive_buffers tsfifo_clear_lin_receive_buffers;
    Ttsfifo_clear_flexray_receive_buffers tsfifo_clear_flexray_receive_buffers;
    Ttsfifo_read_can_buffer_frame_count tsfifo_read_can_buffer_frame_count;
    Ttsfifo_read_can_tx_buffer_frame_count tsfifo_read_can_tx_buffer_frame_count;
    Ttsfifo_read_can_rx_buffer_frame_count tsfifo_read_can_rx_buffer_frame_count;
    Ttsfifo_read_canfd_buffer_frame_count tsfifo_read_canfd_buffer_frame_count;
    Ttsfifo_read_canfd_tx_buffer_frame_count tsfifo_read_canfd_tx_buffer_frame_count;
    Ttsfifo_read_canfd_rx_buffer_frame_count tsfifo_read_canfd_rx_buffer_frame_count;
    Ttsfifo_read_lin_buffer_frame_count tsfifo_read_lin_buffer_frame_count;
    Ttsfifo_read_lin_tx_buffer_frame_count tsfifo_read_lin_tx_buffer_frame_count;
    Ttsfifo_read_lin_rx_buffer_frame_count tsfifo_read_lin_rx_buffer_frame_count;
    Ttsfifo_read_flexray_buffer_frame_count tsfifo_read_flexray_buffer_frame_count;
    Ttsfifo_read_flexray_tx_buffer_frame_count tsfifo_read_flexray_tx_buffer_frame_count;
    Ttsfifo_read_flexray_rx_buffer_frame_count tsfifo_read_flexray_rx_buffer_frame_count;
    Tflexray_rbs_reset_update_bits flexray_rbs_reset_update_bits;
    Tcan_rbs_reset_update_bits can_rbs_reset_update_bits;
    Tcan_rbs_fault_inject_handle_on_autosar_crc_event internal_can_rbs_fault_inject_handle_on_autosar_crc_event;
    Tcan_rbs_fault_inject_handle_on_autosar_rc_event internal_can_rbs_fault_inject_handle_on_autosar_rc_event;
    Tcan_rbs_fault_inject_unhandle_on_autosar_rc_event can_rbs_fault_inject_unhandle_on_autosar_rc_event;
    Tcan_rbs_fault_inject_unhandle_on_autosar_crc_event can_rbs_fault_inject_unhandle_on_autosar_crc_event;
    Teth_rbs_set_pdu_phase_and_cycle_by_name eth_rbs_set_pdu_phase_and_cycle_by_name;
    Tcan_rbs_set_update_bits can_rbs_set_update_bits;
    Tflexray_rbs_set_update_bits flexray_rbs_set_update_bits;
    Trpc_ip_trigger_data_group rpc_ip_trigger_data_group;
    Tcan_rbs_get_signal_raw_by_address can_rbs_get_signal_raw_by_address;
    Teth_rbs_start eth_rbs_start;
    Teth_rbs_stop eth_rbs_stop;
    Teth_rbs_is_running eth_rbs_is_running;
    Teth_rbs_configure eth_rbs_configure;
    Teth_rbs_activate_all_networks eth_rbs_activate_all_networks;
    Teth_rbs_activate_network_by_name eth_rbs_activate_network_by_name;
    Teth_rbs_activate_node_by_name eth_rbs_activate_node_by_name;
    Teth_rbs_activate_pdu_by_name eth_rbs_activate_pdu_by_name;
    Teth_rbs_get_signal_value_by_element eth_rbs_get_signal_value_by_element;
    Teth_rbs_set_signal_value_by_element eth_rbs_set_signal_value_by_element;
    Teth_rbs_get_signal_value_by_address eth_rbs_get_signal_value_by_address;
    Teth_rbs_set_signal_value_by_address eth_rbs_set_signal_value_by_address;
    Tlin_rbs_update_frame_by_id lin_rbs_update_frame_by_id;
    Tlin_rbs_register_force_refresh_frame_by_id lin_rbs_register_force_refresh_frame_by_id;
    Tlin_rbs_unregister_force_refresh_frame_by_id lin_rbs_unregister_force_refresh_frame_by_id;
    Trpc_data_channel_create internal_rpc_data_channel_create;
    Trpc_data_channel_delete internal_rpc_data_channel_delete;
    Trpc_data_channel_transmit internal_rpc_data_channel_transmit;
    Ttssocket_getaddrinfo tssocket_getaddrinfo;
    Ttssocket_freeaddrinfo tssocket_freeaddrinfo;
    Ttssocket_gethostname tssocket_gethostname;
    Ttssocket_getalldevices tssocket_getalldevices;
    Ttssocket_freedevices tssocket_freedevices;
    Trawsocket_select rawsocket_select;
    Ttssocket_set_host_name tssocket_set_host_name;
    Ttsdo_set_pwm_output_async tsdo_set_pwm_output_async;
    Ttsdo_set_vlevel_output_async tsdo_set_vlevel_output_async;
    Tcan_il_register_autosar_pdu_event can_il_register_autosar_pdu_event;
    Tcan_il_unregister_autosar_pdu_event can_il_unregister_autosar_pdu_event;
    Tcan_il_register_autosar_pdu_pretx_event can_il_register_autosar_pdu_pretx_event;
    Tcan_il_unregister_autosar_pdu_pretx_event can_il_unregister_autosar_pdu_pretx_event;
    Tcan_rbs_fault_inject_disturb_sequencecounter can_rbs_fault_inject_disturb_sequencecounter;
    Tcan_rbs_fault_inject_disturb_checksum can_rbs_fault_inject_disturb_checksum;
    Tcan_rbs_fault_inject_disturb_updatebit can_rbs_fault_inject_disturb_updatebit;
    Tcal_add_xcp_ecu cal_add_xcp_ecu;
    Tcal_add_ccp_ecu cal_add_ccp_ecu;
    Tcal_remove_ecu cal_remove_ecu;
    Tcal_get_var_property cal_get_var_property;
    Tcal_get_measurement_list cal_get_measurement_list;
    Trpc_set_global_timeout rpc_set_global_timeout;
    Ttsdi_get_vlevel_input_sync tsdi_get_vlevel_input_sync;
    Ttsdi_get_pwm_input_sync tsdi_get_pwm_input_sync;
    Tcal_get_ecu_a2l_list cal_get_ecu_a2l_list;
    Tcal_set_all_datas_by_value cal_set_all_datas_by_value;
    Tcal_set_all_datas_by_offset cal_set_all_datas_by_offset;
    Tcal_set_datas_by_offset cal_set_datas_by_offset;
    Tcal_set_datas_by_value cal_set_datas_by_value;
    Tcal_get_axisnum_and_address cal_get_axisnum_and_address;
    Tcan_rbs_transmit_pdu can_rbs_transmit_pdu;
    Tcan_rbs_get_signal_value_by_element_verbose can_rbs_get_signal_value_by_element_verbose;
    Tcan_rbs_set_signal_value_by_element_verbose can_rbs_set_signal_value_by_element_verbose;
    Tflexray_rbs_set_signal_value_by_element_verbose flexray_rbs_set_signal_value_by_element_verbose;
    Tflexray_rbs_get_signal_value_by_element_verbose flexray_rbs_get_signal_value_by_element_verbose;
    Tcan_il_register_signal_event can_il_register_signal_event;
    Tcan_il_unregister_signal_event can_il_unregister_signal_event;
    Tcan_rbs_time_monitor_config can_rbs_time_monitor_config;
    Tcan_il_register_signal_event_by_id can_il_register_signal_event_by_id;
    Tcan_il_unregister_signal_event_by_id can_il_unregister_signal_event_by_id;
    Teth_il_register_autosar_pdu_event eth_il_register_autosar_pdu_event;
    Teth_il_unregister_autosar_pdu_event eth_il_unregister_autosar_pdu_event;
    Teth_il_register_autosar_pdu_pretx_event eth_il_register_autosar_pdu_pretx_event;
    Teth_il_unregister_autosar_pdu_pretx_event eth_il_unregister_autosar_pdu_pretx_event;
    Tsimulate_can_async simulate_can_async;
    Tsimulate_canfd_async simulate_canfd_async;
    Tsimulate_lin_async simulate_lin_async;
    Tsimulate_flexray_async simulate_flexray_async;
    Tsimulate_ethernet_async simulate_ethernet_async;
    Ttssocket_tcp_send_sync tssocket_tcp_send_sync;
    Ttssocket_tcp_send_async tssocket_tcp_send_async;
    Tcan_rbs_set_signal_raw_by_address can_rbs_set_signal_raw_by_address;
    Tlin_rbs_set_signal_raw_by_address lin_rbs_set_signal_raw_by_address;
    Tlin_rbs_get_signal_raw_by_address lin_rbs_get_signal_raw_by_address;
    Trbs_get_signal_value_by_address rbs_get_signal_value_by_address;
    Trbs_set_signal_value_by_address rbs_set_signal_value_by_address;
    Ttsai_get_value_input_sync tsai_get_value_input_sync;
    Ttsao_set_value_output_async tsao_set_value_output_async;
    Trpc_tsmaster_call_system_api_w_serialized_args internal_rpc_tsmaster_call_system_api_w_serialized_args;
    Trpc_tsmaster_call_library_api_w_serialized_args internal_rpc_tsmaster_call_library_api_w_serialized_args;
    Tcan_rbs_get_e2e_list_and_save_to_file can_rbs_get_e2e_list_and_save_to_file;
    Tcal_set_logical_channel_index cal_set_logical_channel_index;
    Tcal_load_new_a2l cal_load_new_a2l;
    Tcal_switch_to_xcp cal_switch_to_xcp;
    Tcal_switch_to_ccp cal_switch_to_ccp;
    Tcan_rbs_fault_inject_disturb_checksum_verbose can_rbs_fault_inject_disturb_checksum_verbose;
    Tcan_rbs_fault_inject_disturb_sequencecounter_verbose can_rbs_fault_inject_disturb_sequencecounter_verbose;
    Tset_can_signal_value_verbose set_can_signal_value_verbose;
    Tget_can_signal_value_verbose get_can_signal_value_verbose;
    Tget_flexray_signal_value_verbose get_flexray_signal_value_verbose;
    Tset_flexray_signal_value_verbose set_flexray_signal_value_verbose;
    Tset_lin_signal_value_verbose set_lin_signal_value_verbose;
    Tget_lin_signal_value_verbose get_lin_signal_value_verbose;
    Tget_ethernet_signal_value_verbose get_ethernet_signal_value_verbose;
    Tset_ethernet_signal_value_verbose set_ethernet_signal_value_verbose;
    Ttransmit_canfd_sequential transmit_canfd_sequential;
    Ttransmit_canfd_sequential_w_json transmit_canfd_sequential_w_json;
    Ttransmit_canxl_async transmit_canxl_async;
    Trawsocket_etharp_add_static_entry_ex rawsocket_etharp_add_static_entry_ex;
    Trawsocket_etharp_remove_static_entry_ex rawsocket_etharp_remove_static_entry_ex;
    Trpc_tsmaster_cmd_batch_get_signal_create_handle internal_rpc_tsmaster_cmd_batch_get_signal_create_handle;
    Trpc_tsmaster_cmd_batch_get_signal_register internal_rpc_tsmaster_cmd_batch_get_signal_register;
    Trpc_tsmaster_cmd_batch_get_signal_unregister internal_rpc_tsmaster_cmd_batch_get_signal_unregister;
    Trpc_tsmaster_cmd_batch_get_signal_read internal_rpc_tsmaster_cmd_batch_get_signal_read;
    Trpc_tsmaster_cmd_batch_get_signal_release internal_rpc_tsmaster_cmd_batch_get_signal_release;
    Trpc_tsmaster_cmd_batch_get_signal_list internal_rpc_tsmaster_cmd_batch_get_signal_list;
    TTransmitA429Async transmit_a429_async;
    TTransmitA429Sync transmit_a429_sync;
    TAddA429CyclicMessage add_a429_cyclic_message;
    TUpdateA429CyclicMessage update_a429_cyclic_message;
    TDeleteA429CyclicMessage delete_a429_cyclic_message;
    TRegisterA429Event internal_register_event_a429;
    TUnregisterA429Event internal_unregister_event_a429;
    TRegisterA429Event internal_register_pretx_event_a429;
    TUnregisterA429Event internal_unregister_pretx_event_a429;
    TRegisterCANXLEvent internal_register_event_canxl;
    TUnregisterCANXLEvent internal_unregister_event_canxl;
    TUnregisterCANXLEvents internal_unregister_events_canxl;
    Tcan_rbs_register_first_frame_monitor_by_node can_rbs_register_first_frame_monitor_by_node;
    Tcan_rbs_unregister_first_frame_monitor_by_node can_rbs_unregister_first_frame_monitor_by_node;
    Tcan_rbs_register_first_frame_monitor_by_id can_rbs_register_first_frame_monitor_by_id;
    Tcan_rbs_unregister_first_frame_monitor_by_id can_rbs_unregister_first_frame_monitor_by_id;
    Tcan_rbs_clear_first_frame_monitor_registrations can_rbs_clear_first_frame_monitor_registrations;
    Tcan_rbs_start_first_frame_monitor can_rbs_start_first_frame_monitor;
    Tcan_rbs_stop_first_frame_monitor can_rbs_stop_first_frame_monitor;
    Tcan_rbs_read_first_frame can_rbs_read_first_frame;
    Tcan_rbs_read_first_signal can_rbs_read_first_signal;
    Tcan_rbs_read_first_frame_monitor_by_id can_rbs_read_first_frame_monitor_by_id;
    Tcan_rbs_get_first_frame_monitor_undefined_count can_rbs_get_first_frame_monitor_undefined_count;
    Tcan_rbs_get_first_frame_monitor_undefined_by_index can_rbs_get_first_frame_monitor_undefined_by_index;
    Ttssocket_add_ipv6_device tssocket_add_ipv6_device;
    Ttssocket_delete_ipv6_device tssocket_delete_ipv6_device;
    Tcan_rbs_activate_appointed_channel can_rbs_activate_appointed_channel;
    Tcan_rbs_set_frame_data can_rbs_set_frame_data;
    Tcan_rbs_get_frame_data can_rbs_get_frame_data;
    Tcan_rbs_set_byte_in_frame can_rbs_set_byte_in_frame;
    Tcan_rbs_get_byte_in_frame can_rbs_get_byte_in_frame;
    Tcan_rbs_fault_injection_dlc_error can_rbs_fault_injection_dlc_error;
    Tcan_rbs_get_read_first_frame_all_ready_timestamp can_rbs_get_read_first_frame_all_ready_timestamp;
    Tcan_rbs_is_first_received_frame can_rbs_is_first_received_frame;
    Tcan_rbs_check_frame_undefined_bits_by_address can_rbs_check_frame_undefined_bits_by_address;
    Tlin_rbs_check_frame_undefined_bits_by_address lin_rbs_check_frame_undefined_bits_by_address;
    Tflexray_rbs_check_frame_undefined_bits_by_address flexray_rbs_check_frame_undefined_bits_by_address;
    Tethernet_rbs_check_pdu_undefined_bits_by_address ethernet_rbs_check_pdu_undefined_bits_by_address;
    Tcan_rbs_check_frame_trailing_undefined_bytes_by_address can_rbs_check_frame_trailing_undefined_bytes_by_address;
    Tlin_rbs_check_frame_trailing_undefined_bytes_by_address lin_rbs_check_frame_trailing_undefined_bytes_by_address;
    Tflexray_rbs_check_frame_trailing_undefined_bytes_by_address flexray_rbs_check_frame_trailing_undefined_bytes_by_address;
    Tethernet_rbs_check_pdu_trailing_undefined_bytes_by_address ethernet_rbs_check_pdu_trailing_undefined_bytes_by_address;
    Tcan_rbs_is_first_received_frame_by_id can_rbs_is_first_received_frame_by_id;
    Tcan_rbs_enable_frame_property_monitor can_rbs_enable_frame_property_monitor;
    Tcan_rbs_get_frame_dlc_monitor_result can_rbs_get_frame_dlc_monitor_result;
    Tcan_rbs_get_frame_period_statistics can_rbs_get_frame_period_statistics;
    Tcan_rbs_get_frame_ack_error_monitor_result can_rbs_get_frame_ack_error_monitor_result;
    Tcan_rbs_get_rx_rc_error_by_address can_rbs_get_rx_rc_error_by_address;
    Tcan_rbs_get_rx_crc_error_by_address can_rbs_get_rx_crc_error_by_address;
    Tcan_rbs_fault_injection_message_lost_count can_rbs_fault_injection_message_lost_count;
    Tcan_rbs_send_message_by_name_n_times can_rbs_send_message_by_name_n_times;
    Tcan_rbs_set_rc_fault_mode can_rbs_set_rc_fault_mode;
    Tcan_rbs_set_crc_fault_mode can_rbs_set_crc_fault_mode;
    Tcan_rbs_enable_automatic_tx_algorithm can_rbs_enable_automatic_tx_algorithm;
    Tcan_rbs_enable_automatic_rx_algorithm can_rbs_enable_automatic_rx_algorithm;
    Tcan_rbs_read_first_received_frame can_rbs_read_first_received_frame;
    native_int FDummy[437]; // >>> mp com end <<<
    s32 rpc_tsmaster_cmd_batch_get_signal_list(const native_int AHandle, const s64 ABatchHandle, const s32 AListCapacity, char* ARegisteredListText){return internal_rpc_tsmaster_cmd_batch_get_signal_list(FObj, AHandle, ABatchHandle, AListCapacity, ARegisteredListText);}
    s32 rpc_tsmaster_cmd_batch_get_signal_release(const native_int AHandle, const s64 ABatchHandle){return internal_rpc_tsmaster_cmd_batch_get_signal_release(FObj, AHandle, ABatchHandle);}
    s32 rpc_tsmaster_cmd_batch_get_signal_read(const native_int AHandle, const s64 ABatchHandle, const s32 AValuesCapacity, char* AValueText){return internal_rpc_tsmaster_cmd_batch_get_signal_read(FObj, AHandle, ABatchHandle, AValuesCapacity, AValueText);}
    s32 rpc_tsmaster_cmd_batch_get_signal_unregister(const native_int AHandle, const s64 ABatchHandle, const TLIBApplicationChannelType ABusType, const char* ASgnAddress){return internal_rpc_tsmaster_cmd_batch_get_signal_unregister(FObj, AHandle, ABatchHandle, ABusType, ASgnAddress);}
    s32 rpc_tsmaster_cmd_batch_get_signal_register(const native_int AHandle, const s64 ABatchHandle, const TLIBApplicationChannelType ABusType, const char* ASgnAddress){return internal_rpc_tsmaster_cmd_batch_get_signal_register(FObj, AHandle, ABatchHandle, ABusType, ASgnAddress);}
    s32 rpc_tsmaster_cmd_batch_get_signal_create_handle(const native_int AHandle, ps64 ABatchHandle){return internal_rpc_tsmaster_cmd_batch_get_signal_create_handle(FObj, AHandle, ABatchHandle);}
    s32 rpc_tsmaster_call_library_api_w_serialized_args(const native_int AHandle, const char* AAPIName, const char* ASeparator, const s32 AArgsCapacity, char* AArgs){return internal_rpc_tsmaster_call_library_api_w_serialized_args(FObj, AHandle, AAPIName, ASeparator, AArgsCapacity, AArgs);}
    s32 rpc_tsmaster_call_system_api_w_serialized_args(const native_int AHandle, const char* AAPIName, const char* ASeparator, const s32 AArgsCapacity, char* AArgs){return internal_rpc_tsmaster_call_system_api_w_serialized_args(FObj, AHandle, AAPIName, ASeparator, AArgsCapacity, AArgs);}
    s32 rpc_data_channel_transmit(native_int AHandle, pu8 AAddr, native_int ASizeBytes, s32 ATimeOutMs){return internal_rpc_data_channel_transmit(FObj, AHandle, AAddr, ASizeBytes, ATimeOutMs);}
    s32 rpc_data_channel_delete(native_int AHandle){return internal_rpc_data_channel_delete(FObj, AHandle);}
    s32 rpc_data_channel_create(const char* ARpcName, const s32 AIsMaster, const native_int ABufferSizeBytes, const TOnRpcData ARxEvent, pnative_int AHandle){return internal_rpc_data_channel_create(FObj, ARpcName, AIsMaster, ABufferSizeBytes, ARxEvent, AHandle);}
    s32 can_rbs_fault_inject_handle_on_autosar_rc_event(const TOnAutoSARE2ECanEvt AEvent){return internal_can_rbs_fault_inject_handle_on_autosar_rc_event(FObj, AEvent);}
    s32 can_rbs_fault_inject_handle_on_autosar_crc_event(const TOnAutoSARE2ECanEvt AEvent){return internal_can_rbs_fault_inject_handle_on_autosar_crc_event(FObj, AEvent);}
    s32 rpc_tsmaster_cmd_is_flexray_rbs_running(const native_int AHandle, pbool AIsRunning){return internal_rpc_tsmaster_cmd_is_flexray_rbs_running(FObj, AHandle, AIsRunning);}
    s32 rpc_tsmaster_cmd_is_lin_rbs_running(const native_int AHandle, pbool AIsRunning){return internal_rpc_tsmaster_cmd_is_lin_rbs_running(FObj, AHandle, AIsRunning);}
    s32 rpc_tsmaster_cmd_is_can_rbs_running(const native_int AHandle, pbool AIsRunning){return internal_rpc_tsmaster_cmd_is_can_rbs_running(FObj, AHandle, AIsRunning);}
    s32 rpc_tsmaster_cmd_stop_flexray_rbs(const native_int AHandle){return internal_rpc_tsmaster_cmd_stop_flexray_rbs(FObj, AHandle);}
    s32 rpc_tsmaster_cmd_start_flexray_rbs(const native_int AHandle){return internal_rpc_tsmaster_cmd_start_flexray_rbs(FObj, AHandle);}
    s32 rpc_tsmaster_cmd_stop_lin_rbs(const native_int AHandle){return internal_rpc_tsmaster_cmd_stop_lin_rbs(FObj, AHandle);}
    s32 rpc_tsmaster_cmd_start_lin_rbs(const native_int AHandle){return internal_rpc_tsmaster_cmd_start_lin_rbs(FObj, AHandle);}
    s32 rpc_tsmaster_cmd_stop_can_rbs(const native_int AHandle){return internal_rpc_tsmaster_cmd_stop_can_rbs(FObj, AHandle);}
    s32 rpc_tsmaster_cmd_start_can_rbs(const native_int AHandle){return internal_rpc_tsmaster_cmd_start_can_rbs(FObj, AHandle);}
    s32 block_current_pretx(){
        return internal_block_current_pretx(FObj);
    }
    s32 wait_can_message(const PCAN ATxCAN, const PCAN ARxCAN, const s32 ATimeoutMS) {
        return internal_wait_can_message(FObj, ATxCAN, ARxCAN, ATimeoutMS);
    }
    s32 wait_canfd_message(const PCANFD ATxCANFD, const PCANFD ARxCANFD, const s32 ATimeoutMS) {
        return internal_wait_canfd_message(FObj, ATxCANFD, ARxCANFD, ATimeoutMS);
    }
    // 设计说明：A429 回调沿用 COM 对象公开包装模式，隐藏 internal_* 函数指针字段。
    s32 register_event_a429(const pnative_int AObj, const TA429Event AEvent){
        return internal_register_event_a429(AObj, AEvent);
    }
    s32 unregister_event_a429(const pnative_int AObj, const TA429Event AEvent){
        return internal_unregister_event_a429(AObj, AEvent);
    }
    s32 register_pretx_event_a429(const pnative_int AObj, const TA429Event AEvent){
        return internal_register_pretx_event_a429(AObj, AEvent);
    }
    s32 unregister_pretx_event_a429(const pnative_int AObj, const TA429Event AEvent){
        return internal_unregister_pretx_event_a429(AObj, AEvent);
    }
    s32 register_event_can(const pnative_int AObj, const TCANEvent AEvent){
        return internal_register_event_can(AObj, AEvent);
    }
    s32 unregister_event_can(const pnative_int AObj, const TCANEvent AEvent){
        return internal_unregister_event_can(AObj, AEvent);
    }
    s32 register_event_canfd(const pnative_int AObj, const TCANFDEvent AEvent){
        return internal_register_event_canfd(AObj, AEvent);
    }
    s32 unregister_event_canfd(const pnative_int AObj, const TCANFDEvent AEvent){
        return internal_unregister_event_canfd(AObj, AEvent);
    }
    s32 register_event_lin(const pnative_int AObj, const TLINEvent AEvent){
        return internal_register_event_lin(AObj, AEvent);
    }
    s32 unregister_event_lin(const pnative_int AObj, const TLINEvent AEvent){
        return internal_unregister_event_lin(AObj, AEvent);
    }
    s32 unregister_events_can(const pnative_int AObj){
        return internal_unregister_events_can(AObj);
    }
    s32 unregister_events_lin(const pnative_int AObj){
        return internal_unregister_events_lin(AObj);
    }
    s32 unregister_events_canfd(const pnative_int AObj){
        return internal_unregister_events_canfd(AObj);
    }
    s32 unregister_events_all(const pnative_int AObj){
        return internal_unregister_events_all(AObj);
    }
    s32 register_event_canxl(const pnative_int AObj, const TCANXLEvent AEvent){
        return internal_register_event_canxl(AObj, AEvent);
    }
    s32 unregister_event_canxl(const pnative_int AObj, const TCANXLEvent AEvent){
        return internal_unregister_event_canxl(AObj, AEvent);
    }
    s32 unregister_events_canxl(const pnative_int AObj){
        return internal_unregister_events_canxl(AObj);
    }
    s32 register_pretx_event_can(const pnative_int AObj, const TCANEvent AEvent){
        return internal_register_pretx_event_can(AObj, AEvent);
    }
    s32 unregister_pretx_event_can(const pnative_int AObj, const TCANEvent AEvent){
        return internal_unregister_pretx_event_can(AObj, AEvent);
    }
    s32 register_pretx_event_canfd(const pnative_int AObj, const TCANFDEvent AEvent){
        return internal_register_pretx_event_canfd(AObj, AEvent);
    }
    s32 unregister_pretx_event_canfd(const pnative_int AObj, const TCANFDEvent AEvent){
        return internal_unregister_pretx_event_canfd(AObj, AEvent);
    }
    s32 register_pretx_event_lin(const pnative_int AObj, const TLINEvent AEvent){
        return internal_register_pretx_event_lin(AObj, AEvent);
    }
    s32 unregister_pretx_event_lin(const pnative_int AObj, const TLINEvent AEvent){
        return internal_unregister_pretx_event_lin(AObj, AEvent);
    }
    s32 unregister_pretx_events_can(const pnative_int AObj){
        return internal_unregister_pretx_events_can(AObj);
    }
    s32 unregister_pretx_events_lin(const pnative_int AObj){
        return internal_unregister_pretx_events_lin(AObj);
    }
    s32 unregister_pretx_events_canfd(const pnative_int AObj){
        return internal_unregister_pretx_events_canfd(AObj);
    }
    s32 unregister_pretx_events_all(const pnative_int AObj){
        return internal_unregister_pretx_events_all(AObj);
    }
    s32 register_event_flexray(const pnative_int AObj, const TFlexRayEvent AEvent){
        return internal_register_event_flexray(AObj, AEvent);
    }
    s32 unregister_event_flexray(const pnative_int AObj, const TFlexRayEvent AEvent){
        return internal_unregister_event_flexray(AObj, AEvent);
    }
    s32 unregister_events_flexray(const pnative_int AObj){
        return internal_unregister_events_flexray(AObj);
    }
    s32 register_pretx_event_flexray(const pnative_int AObj, const TFlexRayEvent AEvent){
        return internal_register_pretx_event_flexray(AObj, AEvent);
    }
    s32 unregister_pretx_event_flexray(const pnative_int AObj, const TFlexRayEvent AEvent){
        return internal_unregister_pretx_event_flexray(AObj, AEvent);
    }
    s32 unregister_pretx_events_flexray(const pnative_int AObj){
        return internal_unregister_pretx_events_flexray(AObj);
    }
    s32 register_event_ethernet(const pnative_int AObj, const TEthernetEvent AEvent){
        return internal_register_event_ethernet(AObj, AEvent);
    }
    s32 unregister_event_ethernet(const pnative_int AObj, const TEthernetEvent AEvent){
        return internal_unregister_event_ethernet(AObj, AEvent);
    }
    s32 unregister_events_ethernet(const pnative_int AObj){
        return internal_unregister_events_ethernet(AObj);
    }
    s32 register_pretx_event_ethernet(const pnative_int AObj, const TEthernetEvent AEvent){
        return internal_register_pretx_event_ethernet(AObj, AEvent);
    }
    s32 unregister_pretx_event_ethernet(const pnative_int AObj, const TEthernetEvent AEvent){
        return internal_unregister_pretx_event_ethernet(AObj, AEvent);
    }
    s32 unregister_pretx_events_ethernet(const pnative_int AObj){
        return internal_unregister_pretx_events_ethernet(AObj);
    }
    // IP functions
    s32 ioip_create(const u16 APortTCP, const u16 APortUDP, const TOnIoIPData AOnTCPDataEvent, const TOnIoIPData AOnUDPEvent, native_int* AHandle){
        return internal_ioip_create(FObj, APortTCP, APortUDP, AOnTCPDataEvent, AOnUDPEvent, AHandle);
    }
    s32 ioip_delete(const native_int AHandle){
        return internal_ioip_delete(FObj, AHandle);
    }
    s32 ioip_enable_tcp_server(const native_int AHandle, const bool AEnable){
        return internal_ioip_enable_tcp_server(FObj, AHandle, AEnable);
    }
    s32 ioip_enable_udp_server(const native_int AHandle, const bool AEnable){
        return internal_ioip_enable_udp_server(FObj, AHandle, AEnable);
    }
    s32 ioip_connect_tcp_server(const native_int AHandle, const char* AIpAddress, const u16 APort){
        return internal_ioip_connect_tcp_server(FObj, AHandle, AIpAddress, APort);
    }
    s32 ioip_connect_udp_server(const native_int AHandle, const char* AIpAddress, const u16 APort){
        return internal_ioip_connect_udp_server(FObj, AHandle, AIpAddress, APort);
    }
    s32 ioip_disconnect_tcp_server(const native_int AHandle){
        return internal_ioip_disconnect_tcp_server(FObj, AHandle);
    }
    s32 ioip_send_buffer_tcp(const native_int AHandle, const pu8 APointer, const s32 ASize){
        return internal_ioip_send_buffer_tcp(FObj, AHandle, APointer, ASize);
    }
    s32 ioip_send_buffer_udp(const native_int AHandle, const pu8 APointer, const s32 ASize){
        return internal_ioip_send_buffer_udp(FObj, AHandle, APointer, ASize);
    }
    s32 ioip_receive_tcp_client_response(const native_int AHandle, const s32 ATimeoutMs, const pu8 ABufferToReadTo, ps32 AActualSize){
        return internal_ioip_receive_tcp_client_response(FObj, AHandle, ATimeoutMs, ABufferToReadTo, AActualSize);
    }
    s32 ioip_send_tcp_server_response(const native_int AHandle, const pu8 ABufferToWriteFrom, const s32 ASize){
        return internal_ioip_send_tcp_server_response(FObj, AHandle, ABufferToWriteFrom, ASize);
    }
    s32 ioip_send_udp_broadcast(const native_int AHandle, const u16 APort, const pu8 ABufferToWriteFrom, const s32 ASize){
        return internal_ioip_send_udp_broadcast(FObj, AHandle, APort, ABufferToWriteFrom, ASize);
    }
    s32 ioip_set_udp_server_buffer_size(const native_int AHandle, const s32 ASize){
        return internal_ioip_set_udp_server_buffer_size(FObj, AHandle, ASize);
    }
    s32 ioip_receive_udp_client_response(const native_int AHandle, const s32 ATimeoutMs, const pu8 ABufferToReadTo, ps32 AActualSize){
        return internal_ioip_receive_udp_client_response(FObj, AHandle, ATimeoutMs, ABufferToReadTo, AActualSize);
    }
    s32 ioip_send_udp_server_response(const native_int AHandle, const pu8 ABufferToWriteFrom, const s32 ASize){
        return internal_ioip_send_udp_server_response(FObj, AHandle, ABufferToWriteFrom, ASize);
    }
    s32 ioip_set_tcp_server_connection_callback(const native_int AHandle, const TOnIoIPConnection AConnectedCallback, const TOnIoIPConnection ADisconnectedCallback){
        return internal_ioip_set_tcp_server_connection_callback(FObj, AHandle, AConnectedCallback, ADisconnectedCallback);
    }
    s32 eth_udp_fragment_processor_clear(void){
        return internal_eth_udp_fragment_processor_clear(FObj);
    }
    s32 eth_udp_fragment_processor_parse(const PEthernetHeader AHeader, PUDPFragmentProcessStatus AStatus, ppu8 APayload, pu16 APayloadLength, PEthernetHeader ACompleteHeader){
        return internal_eth_udp_fragment_processor_parse(FObj, AHeader, AStatus, APayload, APayloadLength, ACompleteHeader);
    }
    s32 telnet_create(const char* AHost, const u16 APort, const TOnIoIPData ADataEvent, pnative_int AHandle){
        return internal_telnet_create(FObj, AHost, APort, ADataEvent, AHandle);
    }
    s32 telnet_delete(const native_int AHandle){
        return internal_telnet_delete(FObj, AHandle);
    }
    s32 telnet_send_string(const native_int AHandle, const char* AStr){
        return internal_telnet_send_string(FObj, AHandle, AStr);
    }
    s32 telnet_connect(const native_int AHandle){
        return internal_telnet_connect(FObj, AHandle);
    }
    s32 telnet_disconnect(const native_int AHandle){
        return internal_telnet_disconnect(FObj, AHandle);
    }
    s32 telnet_set_connection_callback(const native_int AHandle, const TOnIoIPConnection AConnectedCallback, const TOnIoIPConnection ADisconnectedCallback){
        return internal_telnet_set_connection_callback(FObj, AHandle, AConnectedCallback, ADisconnectedCallback);
    }
    s32 telnet_enable_debug_print(const native_int AHandle, const bool AEnable){
        return internal_telnet_enable_debug_print(FObj, AHandle, AEnable);
    }
    s32 rpc_create_server(const char* ARpcName, const native_int ABufferSizeBytes, const TOnRpcData ARxEvent, pnative_int AHandle){
        return internal_rpc_create_server(FObj, ARpcName, ABufferSizeBytes, ARxEvent, AHandle);
    }
    s32 rpc_activate_server(const native_int AHandle, const bool AActivate){
        return internal_rpc_activate_server(FObj, AHandle, AActivate);
    }
    s32 rpc_delete_server(const native_int AHandle){
        return internal_rpc_delete_server(FObj, AHandle);
    }
    s32 rpc_server_write_sync(const native_int AHandle, const pu8 AAddr, const native_int ASizeBytes){
        return internal_rpc_server_write_sync(FObj, AHandle, AAddr, ASizeBytes);
    }
    s32 rpc_create_client(const char* ARpcName, const native_int ABufferSizeBytes, pnative_int AHandle){
        return internal_rpc_create_client(FObj, ARpcName, ABufferSizeBytes, AHandle);
    }
    s32 rpc_activate_client(const native_int AHandle, const bool AActivate){
        return internal_rpc_activate_client(FObj, AHandle, AActivate);
    }
    s32 rpc_delete_client(const native_int AHandle){
        return internal_rpc_delete_client(FObj, AHandle);
    }
    s32 rpc_client_transmit_sync(const native_int AHandle, const pu8 AAddr, const native_int ASizeBytes, const s32 ATimeOutMs){
        return internal_rpc_client_transmit_sync(FObj, AHandle, AAddr, ASizeBytes, ATimeOutMs);
    }
    s32 rpc_client_receive_sync(const native_int AHandle, pnative_int ASizeBytes, pu8 AAddr, const s32 ATimeOutMs){
        return internal_rpc_client_receive_sync(FObj, AHandle, ASizeBytes, AAddr, ATimeOutMs);
    }
    s32 rpc_tsmaster_activate_server(const bool AActivate){
        return internal_rpc_tsmaster_activate_server(FObj, AActivate);
    }
    s32 rpc_tsmaster_create_client(const char* ATSMasterAppName, pnative_int AHandle){
        return internal_rpc_tsmaster_create_client(FObj, ATSMasterAppName, AHandle);
    }
    s32 rpc_tsmaster_activate_client(const native_int AHandle, const bool AActivate){
        return internal_rpc_tsmaster_activate_client(FObj, AHandle, AActivate);
    }
    s32 rpc_tsmaster_delete_client(const native_int AHandle){
        return internal_rpc_tsmaster_delete_client(FObj, AHandle);
    }
    s32 rpc_tsmaster_cmd_start_simulation(const native_int AHandle){
        return internal_rpc_tsmaster_cmd_start_simulation(FObj, AHandle);
    }
    s32 rpc_tsmaster_cmd_stop_simulation(const native_int AHandle){
        return internal_rpc_tsmaster_cmd_stop_simulation(FObj, AHandle);
    }
    s32 rpc_tsmaster_cmd_write_system_var(const native_int AHandle, const char* ACompleteName, const char* AValue){
        return internal_rpc_tsmaster_cmd_write_system_var(FObj, AHandle, ACompleteName, AValue);
    }
    s32 rpc_tsmaster_cmd_transfer_memory(const native_int AHandle, const pu8 AAddr, const native_int ASizeBytes){
        return internal_rpc_tsmaster_cmd_transfer_memory(FObj, AHandle, AAddr, ASizeBytes);
    }
    s32 rpc_tsmaster_cmd_log(const native_int AHandle, const char* AMsg, const TLogLevel ALevel){
        return internal_rpc_tsmaster_cmd_log(FObj, AHandle, AMsg, ALevel);
    }
    s32 rpc_tsmaster_cmd_set_mode_sim(const native_int AHandle){
        return internal_rpc_tsmaster_cmd_set_mode_sim(FObj, AHandle);
    }
    s32 rpc_tsmaster_cmd_set_mode_realtime(const native_int AHandle){
        return internal_rpc_tsmaster_cmd_set_mode_realtime(FObj, AHandle);
    }
    s32 rpc_tsmaster_cmd_set_mode_free(const native_int AHandle){
        return internal_rpc_tsmaster_cmd_set_mode_free(FObj, AHandle);
    }
    s32 rpc_tsmaster_cmd_sim_step(const native_int AHandle, const s64 ATimeUs){
        return internal_rpc_tsmaster_cmd_sim_step(FObj, AHandle, ATimeUs);
    }
    s32 rpc_tsmaster_cmd_sim_step_batch_start(const native_int AHandle){
        return internal_rpc_tsmaster_cmd_sim_step_batch_start(FObj, AHandle);
    }
    s32 rpc_tsmaster_cmd_sim_step_batch_end(const native_int AHandle, const s64 ATimeUs){
        return internal_rpc_tsmaster_cmd_sim_step_batch_end(FObj, AHandle, ATimeUs);
    }
    s32 rpc_tsmaster_cmd_get_project(const native_int AHandle, char** AProjectFullPath){
        return internal_rpc_tsmaster_cmd_get_project(FObj, AHandle, AProjectFullPath);
    }
    s32 rpc_tsmaster_cmd_read_system_var(const native_int AHandle, char* ASysVarName, pdouble AValue){
        return internal_rpc_tsmaster_cmd_read_system_var(FObj, AHandle, ASysVarName, AValue);
    }
    s32 rpc_tsmaster_cmd_read_signal(const native_int AHandle, const TLIBApplicationChannelType ABusType, char* AAddr, pdouble AValue){
        return internal_rpc_tsmaster_cmd_read_signal(FObj, AHandle, ABusType, AAddr, AValue);
    }
    s32 rpc_tsmaster_cmd_write_signal(const native_int AHandle, const TLIBApplicationChannelType ABusType, char* AAddr, const double AValue){
        return internal_rpc_tsmaster_cmd_write_signal(FObj, AHandle, ABusType, AAddr, AValue);
    }
    s32 rpc_tsmaster_cmd_set_can_signal(const native_int AHandle, const char* ASgnAddress, double AValue){
        return internal_rpc_tsmaster_cmd_set_can_signal(FObj, AHandle, ASgnAddress, AValue);
    }
    s32 rpc_tsmaster_cmd_get_can_signal(const native_int AHandle, const char* ASgnAddress, pdouble AValue){
        return internal_rpc_tsmaster_cmd_get_can_signal(FObj, AHandle, ASgnAddress, AValue);
    }
    s32 rpc_tsmaster_cmd_get_lin_signal(const native_int AHandle, const char* ASgnAddress, pdouble AValue){
        return internal_rpc_tsmaster_cmd_get_lin_signal(FObj, AHandle, ASgnAddress, AValue);
    }
    s32 rpc_tsmaster_cmd_set_lin_signal(const native_int AHandle, const char* ASgnAddress, double AValue){
        return internal_rpc_tsmaster_cmd_set_lin_signal(FObj, AHandle, ASgnAddress, AValue);
    }
    s32 rpc_tsmaster_cmd_set_flexray_signal(const native_int AHandle, const char* ASgnAddress, double AValue){
        return internal_rpc_tsmaster_cmd_set_flexray_signal(FObj, AHandle, ASgnAddress, AValue);
    }
    s32 rpc_tsmaster_cmd_get_flexray_signal(const native_int AHandle, const char* ASgnAddress, pdouble AValue){
        return internal_rpc_tsmaster_cmd_get_flexray_signal(FObj, AHandle, ASgnAddress, AValue);
    }
    s32 rpc_tsmaster_cmd_get_constant(const native_int AHandle, const char* AConstName, pdouble AValue){
        return internal_rpc_tsmaster_cmd_get_constant(FObj, AHandle, AConstName, AValue);
    }
    s32 rpc_tsmaster_is_simulation_running(const native_int AHandle, const pbool AIsRunning){
        return internal_rpc_tsmaster_is_simulation_running(FObj, AHandle, AIsRunning);
    }
    s32 rpc_tsmaster_call_system_api(const native_int AHandle, const char* AAPIName, const s32 AArgCount, const s32 AArgCapacity, char** AArgs){
        return internal_rpc_tsmaster_call_system_api(FObj, AHandle, AAPIName, AArgCount, AArgCapacity, AArgs);
    }
    s32 rpc_tsmaster_call_library_api(const native_int AHandle, const char* AAPIName, const s32 AArgCount, const s32 AArgCapacity, char** AArgs){
        return internal_rpc_tsmaster_call_library_api(FObj, AHandle, AAPIName, AArgCount, AArgCapacity, AArgs);
    }
    s32 rpc_tsmaster_cmd_register_signal_cache(const native_int AHandle, const TLIBApplicationChannelType ABusType, const char* ASgnAddress, ps64 AId){
        return internal_rpc_tsmaster_cmd_register_signal_cache(FObj, AHandle, ABusType, ASgnAddress, AId);
    }
    s32 rpc_tsmaster_cmd_unregister_signal_cache(const native_int AHandle, const s64 AId){
        return internal_rpc_tsmaster_cmd_unregister_signal_cache(FObj, AHandle, AId);
    }
    s32 rpc_tsmaster_cmd_get_signal_cache_value(const native_int AHandle, const s64 AId, pdouble AValue){
        return internal_rpc_tsmaster_cmd_get_signal_cache_value(FObj, AHandle, AId, AValue);
    }
}TTSCOM, * PTSCOM;

// =========================== Test ===========================
typedef s32 (__stdcall* TTestSetVerdictOK)(const void* AObj, const char* AStr);
typedef s32 (__stdcall* TTestSetVerdictNOK)(const void* AObj, const char* AStr);
typedef s32 (__stdcall* TTestSetVerdictCOK)(const void* AObj, const char* AStr);
typedef s32 (__stdcall* TTestCheckVerdict)(const void* AObj, const char* AName, const double AValue, const double AMin, const double AMax);
typedef s32 (__stdcall* TTestLog)(const void* AObj, const char* AStr, const TLogLevel ALevel);
typedef s32 (__stdcall* TTestLogValue)(const void* AObj, const char* AStr, const double AValue, const TLogLevel ALevel);
typedef s32 (__stdcall* TTestLogString)(const void* AObj, const char* AStr, const char* AInfo, const TLogLevel ALevel);
typedef s32 (__stdcall* TTestDebugLog)(const void* AObj, const char* AFile, const char* AFunc, const s32 ALine, const char* AStr, const TLogLevel ALevel);
typedef s32 (__stdcall* TTestWriteResultString)(const void* AObj, const char* AName, const char* AValue, const TLogLevel ALevel);
typedef s32 (__stdcall* TTestWriteResultValue)(const void* AObj, const char* AName, const double AValue, const TLogLevel ALevel);
typedef s32 (__stdcall* TTestCheckErrorBegin)(void);
typedef s32 (__stdcall* TTestCheckErrorEnd)(const ps32 AErrorCount);
typedef s32 (__stdcall* TTestWriteResultImage)(const void* AObj, const char* AName, const char* AImageFileFullPath);
typedef s32 (__stdcall* TTestRetrieveCurrentResultFolder)(const void* AObj, char** AFolder);
typedef s32 (__stdcall* TTestCheckTerminate)(void);
typedef s32 (__stdcall* TTestSignalCheckerClear)(void);
typedef s32 (__stdcall* TTestSignalCheckerAddCheckWithTime)(const TSignalType ASgnType, const TSignalCheckKind ACheckKind, const char* ASgnName, const double ASgnMin, const double ASgnMax, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddCheckWithTrigger)(const TSignalType ASgnType, const TSignalCheckKind ACheckKind, const char* ASgnName, const double ASgnMin, const double ASgnMax, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddStatisticsWithTime)(const TSignalType ASgnType, const TSignalStatisticsKind AStatisticsKind, const char* ASgnName, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddStatisticsWithTrigger)(const TSignalType ASgnType, const TSignalStatisticsKind AStatisticsKind, const char* ASgnName, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerGetResult)(const void* AObj, const s32 ACheckId, bool* APass, pdouble AResult, char** AResultRepr);
typedef s32 (__stdcall* TTestSignalCheckerEnable)(const s32 ACheckId, const bool AEnable);
typedef s32 (__stdcall* TTestSignalCheckerAddRisingEdgeWithTime)(const TSignalType ASgnType, const char* ASgnName, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddRisingEdgeWithTrigger)(const TSignalType ASgnType, const char* ASgnName, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddFallingEdgeWithTime)(const TSignalType ASgnType, const char* ASgnName, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddFallingEdgeWithTrigger)(const TSignalType ASgnType, const char* ASgnName, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddMonotonyRisingWithTime)(const TSignalType ASgnType, const char* ASgnName, const s32 ASampleIntervalMs, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddMonotonyRisingWithTrigger)(const TSignalType ASgnType, const char* ASgnName, const s32 ASampleIntervalMs, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddMonotonyFallingWithTime)(const TSignalType ASgnType, const char* ASgnName, const s32 ASampleIntervalMs, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddMonotonyFallingWithTrigger)(const TSignalType ASgnType, const char* ASgnName, const s32 ASampleIntervalMs, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddFollowWithTime)(const TSignalType ASgnType, const TSignalType AFollowSignalType, const char* ASgnName, const char* AFollowSgnName, const double AErrorRange, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddFollowWithTrigger)(const TSignalType ASgnType, const TSignalType AFollowSignalType, const char* ASgnName, const char* AFollowSgnName, const double AErrorRange, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddJumpWithTime)(const TSignalType ASgnType, const char* ASgnName, const bool AIgnoreFrom, const double AFrom, const double ATo, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddJumpWithTrigger)(const TSignalType ASgnType, const char* ASgnName, const bool AIgnoreFrom, const double AFrom, const double ATo, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddUnChangeWithTime)(const TSignalType ASgnType, const char* ASgnName, const double ATimeStartS, const double ATimeEndS, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerAddUnChangeWithTrigger)(const TSignalType ASgnType, const char* ASgnName, const TSignalType ATriggerType, const char* ATriggerName, const double ATriggerMin, const double ATriggerMax, ps32 ACheckId);
typedef s32 (__stdcall* TTestSignalCheckerCheckStatistics)(const void* AObj, const s32 ACheckId, const double AMin, const double AMax, bool* APass, pdouble AResult, char** AResultRepr);
typedef s32 (__stdcall* TSignalTesterClearAll)(void);
typedef s32 (__stdcall* TSignalTesterLoadConfiguration)(const char* AFilePath);
typedef s32 (__stdcall* TSignalTesterSaveConfiguration)(const char* AFilePath);
typedef s32 (__stdcall* TSignalTesterRunItemByName)(const char* AName);
typedef s32 (__stdcall* TSignalTesterStopItemByName)(const char* AName);
typedef s32 (__stdcall* TSignalTesterRunItemByIndex)(const s32 AIndex);
typedef s32 (__stdcall* TSignalTesterStopItemByIndex)(const s32 AIndex);
typedef s32 (__stdcall* TSignalTesterGetItemVerdictByIndex)(const void* AObj, const s32 AIndex, pbool AIsPass);
typedef s32 (__stdcall* TSignalTesterGetItemResultByName)(const void* AObj, const char* AName, pbool AIsPass, ps64 AEventTimeUs, char** AValues, char** ADescription);
typedef s32 (__stdcall* TSignalTesterGetItemResultByIndex)(const void* AObj, const s32 AIndex, pbool AIsPass, ps64 AEventTimeUs, char** AValues, char** ADescription);
typedef s32 (__stdcall* TSignalTesterGetItemVerdictByName)(const void* AObj, const char* AName, pbool AIsPass);
typedef s32 (__stdcall* TSignalTesterCheckStatisticsByIndex)(const void* AObj, const s32 AIndex, const double AMin, const double AMax, bool* APass, char** AValues, char** AResultRepr);
typedef s32 (__stdcall* TSignalTesterCheckStatisticsByName)(const void* AObj, const char* AItemName, const double AMin, const double AMax, bool* APass, char** AValues, char** AResultRepr);
typedef s32 (__stdcall* TSignalTesterEnableItem)(const s32 AIndex, const bool AEnable);
typedef s32 (__stdcall* TSignalTesterEnableItemByName)(const char* AItemName, const bool AEnable);
typedef s32 (__stdcall* TSignalTesterRunAll)(void);
typedef s32 (__stdcall* TSignalTesterStopAll)(void);
typedef s32 (__stdcall* TSetClassicTestSystemReportName)(const char* AName);
typedef s32 (__stdcall* TSignalTesterGetItemStatusByIndex)(const s32 AIdx, pbool AIsRunning, pbool AIsCheckDone, PSignalTesterFailReason AFailReason);
typedef s32 (__stdcall* TSignalTesterGetItemStatusByName)(const char* ATesterName, pbool AIsRunning, pbool AIsCheckDone, PSignalTesterFailReason AFailReason);
typedef s32 (__stdcall* TSignalTesterSetItemTimeRangeByIndex)(const s32 AIdx, const double ATimeBegin, const double ATimeEnd);
typedef s32 (__stdcall* TSignalTesterSetItemTimeRangeByName)(const char* AName, const double ATimeBegin, const double ATimeEnd);
typedef s32 (__stdcall* TSignalTesterSetItemValueRangeByIndex)(const s32 AIdx, const double ALow, const double AHigh);
typedef s32 (__stdcall* TSignalTesterSetItemValueRangeByName)(const char* AName, const double ALow, const double AHigh);
typedef s32 (__stdcall* Tclassic_test_system_login)(const char* AUserName, const char* APassword);
typedef s32 (__stdcall* Tclassic_test_system_import)(const char* AConfFile);
typedef s32 (__stdcall* Tlog_formatted_value)(const void* AObj, const char* AStr, const char* AFormat, const double AValue, const TLogLevel ALevel);
typedef s32 (__stdcall* TSignalTesterConfigureItemByIndex)(const s32 AIdx, const double ATimeBegin, const double ATimeEnd, const double AMin, const double AMax, const bool AEnabled);
typedef s32 (__stdcall* TSignalTesterConfigureItemByName)(const char* AName, const double ATimeBegin, const double ATimeEnd, const double AMin, const double AMax, const bool AEnabled);
typedef s32 (__stdcall* TSignalTesterGetItemStateByIndex)(const s32 AIdx, PSignalTesterItemState AState, char** AValues, char** ADescription);
typedef s32 (__stdcall* TSignalTesterGetItemStateByName)(const char* AName, PSignalTesterItemState AState, char** AValues, char** ADescription);
typedef s32 (__stdcall* TSignalTesterGetState)(PSignalTesterState AState);
// >>> mp test prototype end <<<

typedef struct _TTSTest {
    void* FObj;
    // >>> mp test start <<<
    TTestSetVerdictOK                                internal_set_verdict_ok;
    TTestSetVerdictNOK                               internal_set_verdict_nok;
    TTestSetVerdictCOK                               internal_set_verdict_cok;
    TTestLog                                         internal_log_info;
    TTestWriteResultString                           internal_write_result_string;
    TTestWriteResultValue                            internal_write_result_value;
    TTestCheckErrorBegin                             check_error_begin;
    TTestCheckErrorEnd                               check_error_end;
    TTestWriteResultImage                            internal_write_result_image;
    TTestRetrieveCurrentResultFolder                 internal_retrieve_current_result_folder;
    TTestCheckTerminate                              check_test_terminate;
    TTestCheckVerdict                                internal_check_verdict;
    TTestSignalCheckerClear                          signal_checker_clear;
    TTestSignalCheckerAddCheckWithTime               signal_checker_add_check_with_time;
    TTestSignalCheckerAddCheckWithTrigger            signal_checker_add_check_with_trigger;
    TTestSignalCheckerAddStatisticsWithTime          signal_checker_add_statistics_with_time;
    TTestSignalCheckerAddStatisticsWithTrigger       signal_checker_add_statistics_with_trigger;
    TTestSignalCheckerGetResult                      internal_signal_checker_get_result;
    TTestSignalCheckerEnable                         signal_checker_enable;
    TTestDebugLog                                    internal_debug_log_info;
    TTestSignalCheckerAddRisingEdgeWithTime          signal_checker_add_rising_edge_with_time;
    TTestSignalCheckerAddRisingEdgeWithTrigger       signal_checker_add_rising_edge_with_trigger;
    TTestSignalCheckerAddFallingEdgeWithTime         signal_checker_add_falling_edge_with_time;
    TTestSignalCheckerAddFallingEdgeWithTrigger      signal_checker_add_falling_edge_with_trigger;
    TTestSignalCheckerAddMonotonyRisingWithTime      signal_checker_add_monotony_rising_with_time;
    TTestSignalCheckerAddMonotonyRisingWithTrigger   signal_checker_add_monotony_rising_with_trigger;
    TTestSignalCheckerAddMonotonyFallingWithTime     signal_checker_add_monotony_falling_with_time;
    TTestSignalCheckerAddMonotonyFallingWithTrigger  signal_checker_add_monotony_falling_with_trigger;
    TTestSignalCheckerAddFollowWithTime              signal_checker_add_follow_with_time;
    TTestSignalCheckerAddFollowWithTrigger           signal_checker_add_follow_with_trigger;
    TTestSignalCheckerAddJumpWithTime                signal_checker_add_jump_with_time;
    TTestSignalCheckerAddJumpWithTrigger             signal_checker_add_jump_with_trigger;
    TTestSignalCheckerAddUnChangeWithTime            signal_checker_add_unchange_with_time;
    TTestSignalCheckerAddUnChangeWithTrigger         signal_checker_add_unchange_with_trigger;
    TTestSignalCheckerCheckStatistics                internal_signal_checker_check_statistics;
    TTestLogValue                                    internal_log_value;
    TTestLogString                                   internal_log_string;
    TSignalTesterClearAll signal_tester_clear_all;
    TSignalTesterLoadConfiguration signal_tester_load_configuration;
    TSignalTesterSaveConfiguration signal_tester_save_configuration;
    TSignalTesterRunItemByName signal_tester_run_item_by_name;
    TSignalTesterStopItemByName signal_tester_stop_item_by_name;
    TSignalTesterRunItemByIndex signal_tester_run_item_by_index;
    TSignalTesterStopItemByIndex signal_tester_stop_item_by_index;
    TSignalTesterGetItemVerdictByIndex internal_signal_tester_get_item_verdict_by_index;
    TSignalTesterGetItemResultByName internal_signal_tester_get_item_result_by_name;
    TSignalTesterGetItemResultByIndex internal_signal_tester_get_item_result_by_index;
    TSignalTesterGetItemVerdictByName internal_signal_tester_get_item_verdict_by_name;
    TSignalTesterCheckStatisticsByIndex internal_signal_tester_check_statistics_by_index;
    TSignalTesterCheckStatisticsByName internal_signal_tester_check_statistics_by_name;
    TSignalTesterEnableItem signal_tester_enable_item_by_index;
    TSignalTesterEnableItemByName signal_tester_enable_item_by_name;
    TSignalTesterRunAll signal_tester_run_all;
    TSignalTesterStopAll signal_tester_stop_all;
    TSetClassicTestSystemReportName set_classic_test_system_report_name;
    TSignalTesterGetItemStatusByIndex signal_tester_get_item_status_by_index;
    TSignalTesterGetItemStatusByName signal_tester_get_item_status_by_name;
    TSignalTesterSetItemTimeRangeByIndex signal_tester_set_item_time_range_by_index;
    TSignalTesterSetItemTimeRangeByName signal_tester_set_item_time_range_by_name;
    TSignalTesterSetItemValueRangeByIndex signal_tester_set_item_value_range_by_index;
    TSignalTesterSetItemValueRangeByName signal_tester_set_item_value_range_by_name;
    Tclassic_test_system_login classic_test_system_login;
    Tclassic_test_system_import classic_test_system_import;
    Tlog_formatted_value internal_log_formatted_value;
    TSignalTesterConfigureItemByIndex signal_tester_configure_item_by_index;
    TSignalTesterConfigureItemByName signal_tester_configure_item_by_name;
    TSignalTesterGetItemStateByIndex signal_tester_get_item_state_by_index;
    TSignalTesterGetItemStateByName signal_tester_get_item_state_by_name;
    TSignalTesterGetState signal_tester_get_state;
    native_int FDummy[137]; // >>> mp test end <<<
    void set_verdict_ok(const char* AStr) {
        internal_set_verdict_ok(FObj, AStr);
    }
    void set_verdict_nok(const char* AStr) {
        internal_set_verdict_nok(FObj, AStr);
    }
    void set_verdict_cok(const char* AStr) {
        internal_set_verdict_cok(FObj, AStr);
    }
    s32 check_verdict(const char* AName, const double AValue, const double AMin, const double AMax){
        return internal_check_verdict(FObj, AName, AValue, AMin, AMax);
    }
    void log_info(const char* AStr, const TLogLevel ALevel) {
        internal_log_info(FObj, AStr, ALevel);
    }
    void log_value(const char* AStr, const double AValue, const TLogLevel ALevel) {
        internal_log_value(FObj, AStr, AValue, ALevel);
    }
    void log_string(const char* AStr, const char* AValue, const TLogLevel ALevel) {
        internal_log_string(FObj, AStr, AValue, ALevel);
    }
    void debug_log_info(const char* AFile, const char* AFunc, const s32 ALine, const char* AStr, const TLogLevel ALevel) {
        internal_debug_log_info(FObj, AFile, AFunc, ALine, AStr, ALevel);
    }
    void write_result_string(const char* AName, const char* AValue, const TLogLevel ALevel) {
        internal_write_result_string(FObj, AName, AValue, ALevel);
    }
    void write_result_value(const char* AName, const double AValue, const TLogLevel ALevel) {
        internal_write_result_value(FObj, AName, AValue, ALevel);
    }
    s32 write_result_image(const char* AName, const char* AImageFileFullPath) {
        return internal_write_result_image(FObj, AName, AImageFileFullPath);
    }
    s32 retrieve_current_result_folder(char** AFolder) {
        return internal_retrieve_current_result_folder(FObj, AFolder);
    }
    s32 signal_checker_get_result(const s32 ACheckId, bool* APass, pdouble AResult, char** AResultRepr){
        return internal_signal_checker_get_result(FObj, ACheckId, APass, AResult, AResultRepr);
    }
    s32 signal_checker_check_statistics(const s32 ACheckId, const double AMin, const double AMax, bool* APass, pdouble AResult, char** AResultRepr){
        return internal_signal_checker_check_statistics(FObj, ACheckId, AMin, AMax, APass, AResult, AResultRepr);
    }
    s32 signal_tester_get_item_verdict_by_index(const s32 AIndex, pbool AIsPass){
        return internal_signal_tester_get_item_verdict_by_index(FObj, AIndex, AIsPass);
    }
    s32 signal_tester_get_item_result_by_name(const char* AName, pbool AIsPass, ps64 AEventTimeUs, char** AValues, char** ADescription){
        return internal_signal_tester_get_item_result_by_name(FObj, AName, AIsPass, AEventTimeUs, AValues, ADescription);
    }
    s32 signal_tester_get_item_result_by_index(const s32 AIndex, pbool AIsPass, ps64 AEventTimeUs, char** AValues, char** ADescription){
        return internal_signal_tester_get_item_result_by_index(FObj, AIndex, AIsPass, AEventTimeUs, AValues, ADescription);
    }
    s32 signal_tester_get_item_verdict_by_name(const char* AName, pbool AIsPass){
        return internal_signal_tester_get_item_verdict_by_name(FObj, AName, AIsPass);
    }
    s32 signal_tester_check_statistics_by_index(const s32 AIndex, const double AMin, const double AMax, bool* APass, char** AResults, char** AResultRepr){
        return internal_signal_tester_check_statistics_by_index(FObj, AIndex, AMin, AMax, APass, AResults, AResultRepr);
    }
    s32 signal_tester_check_statistics_by_name(const char* AItemName, const double AMin, const double AMax, bool* APass, char** AResults, char** AResultRepr){
        return internal_signal_tester_check_statistics_by_name(FObj, AItemName, AMin, AMax, APass, AResults, AResultRepr);
    }
    s32 log_formatted_value(const char* AStr, const char* AFormat, const double AValue, const TLogLevel ALevel){
        return internal_log_formatted_value(FObj, AStr, AFormat, AValue, ALevel);
    }
}TTSTest, * PTSTest;

// =========================== MBD ===========================
typedef enum _TMBD_PriorityKind {
    mpkPriority = 0,
    mpkFirst = 1,
    mpkLast = 2
} TMBD_PriorityKind, *PMBD_PriorityKind;
typedef s32 (__stdcall* Tdelete_all_diagrams)(void);
typedef s32 (__stdcall* Tget_diagram_count)(ps32 ACount);
typedef s32 (__stdcall* Tget_diagram_id_by_index)(const s32 AIndex, ps64 AId);
typedef s32 (__stdcall* Tget_diagram_name)(const s64 AId, char** AName);
typedef s32 (__stdcall* Tset_diagram_name)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tfind_diagram_by_name)(const pchar AName, ps64 AId);
typedef s32 (__stdcall* Tcreate_diagram)(const pchar AName, ps64 AId);
typedef s32 (__stdcall* Tdelete_diagram)(const s64 AId);
typedef s32 (__stdcall* Tshow_diagram)(const s64 AId, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Thide_diagram)(const s64 AId);
typedef s32 (__stdcall* Tget_diagram_info)(const s64 AId, char** AName, pbool AIsLibrary, char** AVersion, char** ALastModifiedBy, char** ALastModified, char** AFilePath);
typedef s32 (__stdcall* Tcreate_block)(const s64 AId, const pchar AName, const pchar AType, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Tdelete_block)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tget_block_count)(const s64 AId, const pchar AParentBlockName, ps32 ACount);
typedef s32 (__stdcall* Tget_block_name_by_index)(const s64 AId, const pchar AParentBlockName, const s32 AIndex, char** AName);
typedef s32 (__stdcall* Tset_block_name)(const s64 AId, const pchar AOldName, const pchar ANewName);
typedef s32 (__stdcall* Tis_block_exist)(const s64 AId, const pchar AName, pbool AExist);
typedef s32 (__stdcall* Tenable_block)(const s64 AId, const pchar AName, const bool AEnable);
typedef s32 (__stdcall* Tget_block_info)(const s64 AId, const pchar AName, pbool AEnable, char** AType, ps32 ALeft, ps32 ATop, ps32 AWidth, ps32 AHeight);
typedef s32 (__stdcall* Tbring_block_to_front)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tsend_block_to_back)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tget_block_z_order)(const s64 AId, const pchar AName, ps32 AIndex);
typedef s32 (__stdcall* Tset_block_z_order)(const s64 AId, const pchar AName, const s32 AIndex);
typedef s32 (__stdcall* Tget_block_show_name)(const s64 AId, const pchar AName, pbool AShowName);
typedef s32 (__stdcall* Tset_block_show_name)(const s64 AId, const pchar AName, const bool AShowName);
typedef s32 (__stdcall* Tget_block_bounds)(const s64 AId, const pchar AName, ps32 ALeft, ps32 ATop, ps32 AWidth, ps32 AHeight);
typedef s32 (__stdcall* Tset_block_bounds)(const s64 AId, const pchar AName, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Tget_block_color_fill)(const s64 AId, const pchar AName, ps32 AColor);
typedef s32 (__stdcall* Tset_block_color_fill)(const s64 AId, const pchar AName, const s32 AColor);
typedef s32 (__stdcall* Tget_block_color_stroke)(const s64 AId, const pchar AName, ps32 AColor);
typedef s32 (__stdcall* Tset_block_color_stroke)(const s64 AId, const pchar AName, const s32 AColor);
typedef s32 (__stdcall* Tget_block_priority)(const s64 AId, const pchar AName, ps32 APriority);
typedef s32 (__stdcall* Tget_block_priority_kind)(const s64 AId, const pchar AName, PMBD_PriorityKind APriorityKind);
typedef s32 (__stdcall* Tset_block_priority_kind)(const s64 AId, const pchar AName, const TMBD_PriorityKind APriorityKind);
typedef s32 (__stdcall* Tget_block_tag)(const s64 AId, const pchar AName, char** ATag);
typedef s32 (__stdcall* Tset_block_tag)(const s64 AId, const pchar AName, const pchar ATag);
typedef s32 (__stdcall* Tset_block_property_generic)(const s64 AId, const pchar AName, const pchar AProperty, const pchar AValue);
typedef s32 (__stdcall* Tget_block_property_generic)(const s64 AId, const pchar AName, const pchar AProperty, char** AValue);
typedef s32 (__stdcall* Tset_block_priority)(const s64 AId, const pchar AName, const s32 APriority);
typedef s32 (__stdcall* Tclear_all_in_diagram)(const s64 AId, const pchar AParentBlockName);
typedef s32 (__stdcall* Tset_view_rect)(const s64 AId, const pchar AParentBlockName, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Tget_view_rect)(const s64 AId, const pchar AParentBlockName, ps32 ALeft, ps32 ATop, ps32 AWidth, ps32 AHeight);
typedef s32 (__stdcall* Tauto_zoom_view)(const s64 AId, const pchar AParentBlockName);
typedef s32 (__stdcall* Tget_content_rect)(const s64 AId, const pchar AParentBlockName, ps32 ALeft, ps32 ATop, ps32 AWidth, ps32 AHeight);
typedef s32 (__stdcall* Tis_diagram_running)(const s64 AId, pbool AIsRunning);
typedef s32 (__stdcall* Tget_block_io_count)(const s64 AId, const pchar AName, ps32 AInportCount, ps32 AOutportCount);
typedef s32 (__stdcall* Tget_block_inport_name)(const s64 AId, const pchar AName, const s32 AInportIndex, char** AInportName);
typedef s32 (__stdcall* Tget_block_outport_name)(const s64 AId, const pchar AName, const s32 AOutportIndex, char** AOutportName);
typedef s32 (__stdcall* Tis_block_inport_connected)(const s64 AId, const pchar AName, const s32 AInportIndex, pbool AIsConnected);
typedef s32 (__stdcall* Tis_block_outport_connected)(const s64 AId, const pchar AName, const s32 AOutportIndex, pbool AIsConnected);
typedef s32 (__stdcall* Tremove_block_io_lines)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tremove_block_inport_line)(const s64 AId, const pchar AName, const s32 AInportIndex);
typedef s32 (__stdcall* Tremove_block_outport_line)(const s64 AId, const pchar AName, const s32 AOutportIndex);
typedef s32 (__stdcall* Tconnect_block_io)(const s64 AId, const pchar ASrcName, const pchar ADstName, const s32 ASrcOutPortIndex, const s32 ADstInPortIndex);
typedef s32 (__stdcall* Tenter_subsystem)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tset_view_on_block)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tsort_diagram_z_order)(const s64 AId, const pchar AName, const bool AUp);
typedef s32 (__stdcall* Tset_block_io_count)(const s64 AId, const pchar AName, const s32 AInportCount, const s32 AOutportCount);
typedef s32 (__stdcall* Tremove_block_enable_line)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tremove_block_trigger_line)(const s64 AId, const pchar AName);
typedef s32 (__stdcall* Tis_block_enable_connected)(const s64 AId, const pchar AName, pbool AIsConnected);
typedef s32 (__stdcall* Tis_block_trigger_connected)(const s64 AId, const pchar AName, pbool AIsConnected);
typedef s32 (__stdcall* Tconnect_block_enable)(const s64 AId, const pchar ASrcName, const pchar ADstName, const s32 ASrcOutPortIndex);
typedef s32 (__stdcall* Tconnect_block_trigger)(const s64 AId, const pchar ASrcName, const pchar ADstName, const s32 ASrcOutPortIndex);
typedef s32 (__stdcall* Tget_block_value_config)(const s64 AId, const pchar AName, char** AValue);
typedef s32 (__stdcall* Tset_block_value_config)(const s64 AId, const pchar AName, const pchar AValue);
typedef s32 (__stdcall* Tswitch_block_types)(const s64 AId, const pchar AName, const pchar AFromType, const pchar AToType);
typedef s32 (__stdcall* Tset_block_out_datatype)(const s64 AId, const pchar AName, const pchar ADataType);
typedef s32 (__stdcall* Taiflow_get_chart_diagram)(const s64 ABlockId, ps64 ADiagramSID);
typedef s32 (__stdcall* Taiflow_clear_chart)(const s64 ABlockId);
typedef s32 (__stdcall* Taiflow_get_chart_name)(const s64 ABlockId, char** AName);
typedef s32 (__stdcall* Taiflow_set_chart_name)(const s64 ABlockId, const pchar AName);
typedef s32 (__stdcall* Taiflow_get_chart_info)(const s64 ABlockId, char** AName, ps32 AObjectCount, ps32 AStateCount, ps32 ATransitionCount);
typedef s32 (__stdcall* Taiflow_refresh_chart_ui)(const s64 ABlockId);
typedef s32 (__stdcall* Taiflow_create_state)(const s64 ABlockId, const pchar AName, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_junction)(const s64 ABlockId, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_transition)(const s64 ABlockId, const s64 ASourceSID, const s64 ATargetSID, const pchar ACondition, const pchar AAction, ps64 ANewTransitionSID);
typedef s32 (__stdcall* Taiflow_create_group)(const s64 ABlockId, const pchar AName, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_graphic_function)(const s64 ABlockId, const pchar AName, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_c_function)(const s64 ABlockId, const pchar AName, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_truth_table)(const s64 ABlockId, const pchar AName, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_history_junction)(const s64 ABlockId, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_comment)(const s64 ABlockId, const pchar AText, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_image)(const s64 ABlockId, const pchar AImagePath, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_data)(const s64 ABlockId, const pchar AName, const pchar ADataType, const pchar AScope, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_create_event)(const s64 ABlockId, const pchar AName, const pchar AScope, ps64 ANewSID);
typedef s32 (__stdcall* Taiflow_delete_object_by_sid)(const s64 ABlockId, const s64 ASID);
typedef s32 (__stdcall* Taiflow_delete_object_by_name)(const s64 ABlockId, const pchar AName);
typedef s32 (__stdcall* Taiflow_delete_selected)(const s64 ABlockId);
typedef s32 (__stdcall* Taiflow_find_object_by_name)(const s64 ABlockId, const pchar AName, ps64 ASID);
typedef s32 (__stdcall* Taiflow_get_object_type)(const s64 ABlockId, const s64 ASID, pTAiFlowObjectType AType);
typedef s32 (__stdcall* Taiflow_get_object_exists)(const s64 ABlockId, const s64 ASID, ps32 AExists);
typedef s32 (__stdcall* Taiflow_get_object_at_point)(const s64 ABlockId, const s32 AX, const s32 AY, ps64 ASID);
typedef s32 (__stdcall* Taiflow_get_selected_count)(const s64 ABlockId, ps32 ACount);
typedef s32 (__stdcall* Taiflow_get_selected_sids)(const s64 ABlockId, ps64 ASIDs, ps32 AMaxCount);
typedef s32 (__stdcall* Taiflow_get_object_name)(const s64 ABlockId, const s64 ASID, char** AName);
typedef s32 (__stdcall* Taiflow_set_object_name)(const s64 ABlockId, const s64 ASID, const pchar ANewName);
typedef s32 (__stdcall* Taiflow_get_object_bounds)(const s64 ABlockId, const s64 ASID, ps32 ALeft, ps32 ATop, ps32 AWidth, ps32 AHeight);
typedef s32 (__stdcall* Taiflow_set_object_bounds)(const s64 ABlockId, const s64 ASID, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Taiflow_get_object_selected)(const s64 ABlockId, const s64 ASID, ps32 ASelected);
typedef s32 (__stdcall* Taiflow_set_object_selected)(const s64 ABlockId, const s64 ASID, const s32 ASelected);
typedef s32 (__stdcall* Taiflow_get_object_commented)(const s64 ABlockId, const s64 ASID, ps32 ACommented);
typedef s32 (__stdcall* Taiflow_set_object_commented)(const s64 ABlockId, const s64 ASID, const s32 ACommented);
typedef s32 (__stdcall* Taiflow_get_object_locked)(const s64 ABlockId, const s64 ASID, ps32 ALocked);
typedef s32 (__stdcall* Taiflow_set_object_locked)(const s64 ABlockId, const s64 ASID, const s32 ALocked);
typedef s32 (__stdcall* Taiflow_get_comment_text)(const s64 ABlockId, const s64 ACommentSID, char** AText);
typedef s32 (__stdcall* Taiflow_set_comment_text)(const s64 ABlockId, const s64 ACommentSID, const pchar AText);
typedef s32 (__stdcall* Taiflow_get_data_type)(const s64 ABlockId, const s64 ADataSID, char** ADataType);
typedef s32 (__stdcall* Taiflow_set_data_type)(const s64 ABlockId, const s64 ADataSID, const pchar ADataType);
typedef s32 (__stdcall* Taiflow_get_data_scope)(const s64 ABlockId, const s64 ADataSID, char** AScope);
typedef s32 (__stdcall* Taiflow_set_data_scope)(const s64 ABlockId, const s64 ADataSID, const pchar AScope);
typedef s32 (__stdcall* Taiflow_get_state_label)(const s64 ABlockId, const s64 ASID, char** ALabel);
typedef s32 (__stdcall* Taiflow_set_state_label)(const s64 ABlockId, const s64 ASID, const pchar ALabel);
typedef s32 (__stdcall* Taiflow_get_state_decomposition)(const s64 ABlockId, const s64 ASID, pTAiFlowDecomposition ADecomposition);
typedef s32 (__stdcall* Taiflow_set_state_decomposition)(const s64 ABlockId, const s64 ASID, const TAiFlowDecomposition ADecomposition);
typedef s32 (__stdcall* Taiflow_get_transition_condition)(const s64 ABlockId, const s64 ATransitionSID, char** ACondition);
typedef s32 (__stdcall* Taiflow_set_transition_condition)(const s64 ABlockId, const s64 ATransitionSID, const pchar ACondition);
typedef s32 (__stdcall* Taiflow_get_transition_action)(const s64 ABlockId, const s64 ATransitionSID, char** AAction);
typedef s32 (__stdcall* Taiflow_set_transition_action)(const s64 ABlockId, const s64 ATransitionSID, const pchar AAction);
typedef s32 (__stdcall* Taiflow_get_transition_execution_order)(const s64 ABlockId, const s64 ATransitionSID, ps32 AOrder);
typedef s32 (__stdcall* Taiflow_set_transition_execution_order)(const s64 ABlockId, const s64 ATransitionSID, const s32 AOrder);
typedef s32 (__stdcall* Taiflow_get_transition_breakpoint)(const s64 ABlockId, const s64 ATransitionSID, ps32 ABreakpoint);
typedef s32 (__stdcall* Taiflow_set_transition_breakpoint)(const s64 ABlockId, const s64 ATransitionSID, const s32 ABreakpoint);
typedef s32 (__stdcall* Taiflow_get_state_entry_action)(const s64 ABlockId, const s64 AStateSID, char** AAction);
typedef s32 (__stdcall* Taiflow_set_state_entry_action)(const s64 ABlockId, const s64 AStateSID, const pchar AAction);
typedef s32 (__stdcall* Taiflow_get_state_during_action)(const s64 ABlockId, const s64 AStateSID, char** AAction);
typedef s32 (__stdcall* Taiflow_set_state_during_action)(const s64 ABlockId, const s64 AStateSID, const pchar AAction);
typedef s32 (__stdcall* Taiflow_get_state_exit_action)(const s64 ABlockId, const s64 AStateSID, char** AAction);
typedef s32 (__stdcall* Taiflow_set_state_exit_action)(const s64 ABlockId, const s64 AStateSID, const pchar AAction);
typedef s32 (__stdcall* Taiflow_get_state_breakpoint)(const s64 ABlockId, const s64 AStateSID, ps32 ABreakpoint);
typedef s32 (__stdcall* Taiflow_set_state_breakpoint)(const s64 ABlockId, const s64 AStateSID, const s32 ABreakpoint);
typedef s32 (__stdcall* Taiflow_get_junction_breakpoint)(const s64 ABlockId, const s64 AJunctionSID, ps32 ABreakpoint);
typedef s32 (__stdcall* Taiflow_set_junction_breakpoint)(const s64 ABlockId, const s64 AJunctionSID, const s32 ABreakpoint);
typedef s32 (__stdcall* Taiflow_set_current_container)(const s64 ABlockId, const s64 AContainerSID);
typedef s32 (__stdcall* Taiflow_get_current_container)(const s64 ABlockId, ps64 AContainerSID);
typedef s32 (__stdcall* Taiflow_go_to_subchart)(const s64 ABlockId, const s64 AStateSID);
typedef s32 (__stdcall* Taiflow_go_to_parent)(const s64 ABlockId);
typedef s32 (__stdcall* Taiflow_connect_objects)(const s64 ABlockId, const s64 ASourceSID, const s64 ATargetSID);
typedef s32 (__stdcall* Taiflow_disconnect_objects)(const s64 ABlockId, const s64 ASourceSID, const s64 ATargetSID);
typedef s32 (__stdcall* Taiflow_get_transition_source)(const s64 ABlockId, const s64 ATransitionSID, ps64 ASourceSID);
typedef s32 (__stdcall* Taiflow_get_transition_target)(const s64 ABlockId, const s64 ATransitionSID, ps64 ATargetSID);
typedef s32 (__stdcall* Taiflow_get_object_transitions)(const s64 ABlockId, const s64 AObjectSID, ps64 ATransitionSIDs, ps32 AMaxCount);
typedef s32 (__stdcall* Taiflow_get_transition_count_between)(const s64 ABlockId, const s64 ASourceSID, const s64 ATargetSID, ps32 ACount);
typedef s32 (__stdcall* Taiflow_save_to_string)(const s64 ABlockId, char** AData);
typedef s32 (__stdcall* Taiflow_load_from_string)(const s64 ABlockId, const pchar AData);
typedef s32 (__stdcall* Taiflow_clear_selections)(const s64 ABlockId);
typedef s32 (__stdcall* Taiflow_select_all_objects)(const s64 ABlockId);
typedef s32 (__stdcall* Taiflow_select_objects_by_type)(const s64 ABlockId, const TAiFlowObjectType AType);
typedef s32 (__stdcall* Taiflow_select_objects_in_rect)(const s64 ABlockId, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Taiflow_invert_selection)(const s64 ABlockId);
typedef s32 (__stdcall* Taiflow_fit_view)(const s64 ABlockId);
typedef s32 (__stdcall* Taiflow_get_view_rect)(const s64 ABlockId, ps32 ALeft, ps32 ATop, ps32 AWidth, ps32 AHeight);
typedef s32 (__stdcall* Taiflow_set_view_rect)(const s64 ABlockId, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight);
typedef s32 (__stdcall* Taiflow_get_content_rect)(const s64 ABlockId, ps32 ALeft, ps32 ATop, ps32 AWidth, ps32 AHeight);
typedef s32 (__stdcall* Taiflow_center_view_on_object)(const s64 ABlockId, const s64 AObjectSID);
typedef s32 (__stdcall* Taiflow_enum_objects_by_type)(const s64 ABlockId, const TAiFlowObjectType AType, ps64 ASIDs, ps32 AMaxCount);
typedef s32 (__stdcall* Taiflow_get_object_parent)(const s64 ABlockId, const s64 ASID, ps64 AParentSID);
typedef s32 (__stdcall* Taiflow_get_state_children)(const s64 ABlockId, const s64 AStateSID, ps64 AChildSIDs, ps32 AMaxCount);
typedef s32 (__stdcall* Tcreate_block_w_sid)(const s64 AId, const pchar AName, const pchar AType, const s32 ALeft, const s32 ATop, const s32 AWidth, const s32 AHeight, ps64 ASid);
typedef s32 (__stdcall* Tget_block_sid)(const s64 AId, const pchar AName, ps64 ASid);
typedef s32 (__stdcall* Tgenerate_code)(const s64 AId, const char* ADir);
typedef s32 (__stdcall* Tload_diagram)(const char* AFile, ps64 AId);
// >>> mp mbd prototype end <<<

typedef struct _TTSMBD {
    void* FObj;
    // >>> mp mbd start <<<
    Tdelete_all_diagrams delete_all_diagrams;
    Tget_diagram_count get_diagram_count;
    Tget_diagram_id_by_index get_diagram_id_by_index;
    Tget_diagram_name get_diagram_name;
    Tset_diagram_name set_diagram_name;
    Tfind_diagram_by_name find_diagram_by_name;
    Tcreate_diagram create_diagram;
    Tdelete_diagram delete_diagram;
    Tshow_diagram show_diagram;
    Thide_diagram hide_diagram;
    Tget_diagram_info get_diagram_info;
    Tcreate_block create_block;
    Tdelete_block delete_block;
    Tget_block_count get_block_count;
    Tget_block_name_by_index get_block_name_by_index;
    Tset_block_name set_block_name;
    Tis_block_exist is_block_exist;
    Tenable_block enable_block;
    Tget_block_info get_block_info;
    Tbring_block_to_front bring_block_to_front;
    Tsend_block_to_back send_block_to_back;
    Tget_block_z_order get_block_z_order;
    Tset_block_z_order set_block_z_order;
    Tget_block_show_name get_block_show_name;
    Tset_block_show_name set_block_show_name;
    Tget_block_bounds get_block_bounds;
    Tset_block_bounds set_block_bounds;
    Tget_block_color_fill get_block_color_fill;
    Tset_block_color_fill set_block_color_fill;
    Tget_block_color_stroke get_block_color_stroke;
    Tset_block_color_stroke set_block_color_stroke;
    Tget_block_priority get_block_priority;
    Tget_block_priority_kind get_block_priority_kind;
    Tset_block_priority_kind set_block_priority_kind;
    Tget_block_tag get_block_tag;
    Tset_block_tag set_block_tag;
    Tset_block_property_generic set_block_property_generic;
    Tget_block_property_generic get_block_property_generic;
    Tset_block_priority set_block_priority;
    Tclear_all_in_diagram clear_all_in_diagram;
    Tset_view_rect set_view_rect;
    Tget_view_rect get_view_rect;
    Tauto_zoom_view auto_zoom_view;
    Tget_content_rect get_content_rect;
    Tis_diagram_running is_diagram_running;
    Tget_block_io_count get_block_io_count;
    Tget_block_inport_name get_block_inport_name;
    Tget_block_outport_name get_block_outport_name;
    Tis_block_inport_connected is_block_inport_connected;
    Tis_block_outport_connected is_block_outport_connected;
    Tremove_block_io_lines remove_block_io_lines;
    Tremove_block_inport_line remove_block_inport_line;
    Tremove_block_outport_line remove_block_outport_line;
    Tconnect_block_io connect_block_io;
    Tenter_subsystem enter_subsystem;
    Tset_view_on_block set_view_on_block;
    Tsort_diagram_z_order sort_diagram_z_order;
    Tset_block_io_count set_block_io_count;
    Tremove_block_enable_line remove_block_enable_line;
    Tremove_block_trigger_line remove_block_trigger_line;
    Tis_block_enable_connected is_block_enable_connected;
    Tis_block_trigger_connected is_block_trigger_connected;
    Tconnect_block_enable connect_block_enable;
    Tconnect_block_trigger connect_block_trigger;
    Tget_block_value_config get_block_value_config;
    Tset_block_value_config set_block_value_config;
    Tswitch_block_types switch_block_types;
    Tset_block_out_datatype set_block_out_datatype;
    Taiflow_get_chart_diagram aiflow_get_chart_diagram;
    Taiflow_clear_chart aiflow_clear_chart;
    Taiflow_get_chart_name aiflow_get_chart_name;
    Taiflow_set_chart_name aiflow_set_chart_name;
    Taiflow_get_chart_info aiflow_get_chart_info;
    Taiflow_refresh_chart_ui aiflow_refresh_chart_ui;
    Taiflow_create_state aiflow_create_state;
    Taiflow_create_junction aiflow_create_junction;
    Taiflow_create_transition aiflow_create_transition;
    Taiflow_create_group aiflow_create_group;
    Taiflow_create_graphic_function aiflow_create_graphic_function;
    Taiflow_create_c_function aiflow_create_c_function;
    Taiflow_create_truth_table aiflow_create_truth_table;
    Taiflow_create_history_junction aiflow_create_history_junction;
    Taiflow_create_comment aiflow_create_comment;
    Taiflow_create_image aiflow_create_image;
    Taiflow_create_data aiflow_create_data;
    Taiflow_create_event aiflow_create_event;
    Taiflow_delete_object_by_sid aiflow_delete_object_by_sid;
    Taiflow_delete_object_by_name aiflow_delete_object_by_name;
    Taiflow_delete_selected aiflow_delete_selected;
    Taiflow_find_object_by_name aiflow_find_object_by_name;
    Taiflow_get_object_type aiflow_get_object_type;
    Taiflow_get_object_exists aiflow_get_object_exists;
    Taiflow_get_object_at_point aiflow_get_object_at_point;
    Taiflow_get_selected_count aiflow_get_selected_count;
    Taiflow_get_selected_sids aiflow_get_selected_sids;
    Taiflow_get_object_name aiflow_get_object_name;
    Taiflow_set_object_name aiflow_set_object_name;
    Taiflow_get_object_bounds aiflow_get_object_bounds;
    Taiflow_set_object_bounds aiflow_set_object_bounds;
    Taiflow_get_object_selected aiflow_get_object_selected;
    Taiflow_set_object_selected aiflow_set_object_selected;
    Taiflow_get_object_commented aiflow_get_object_commented;
    Taiflow_set_object_commented aiflow_set_object_commented;
    Taiflow_get_object_locked aiflow_get_object_locked;
    Taiflow_set_object_locked aiflow_set_object_locked;
    Taiflow_get_comment_text aiflow_get_comment_text;
    Taiflow_set_comment_text aiflow_set_comment_text;
    Taiflow_get_data_type aiflow_get_data_type;
    Taiflow_set_data_type aiflow_set_data_type;
    Taiflow_get_data_scope aiflow_get_data_scope;
    Taiflow_set_data_scope aiflow_set_data_scope;
    Taiflow_get_state_label aiflow_get_state_label;
    Taiflow_set_state_label aiflow_set_state_label;
    Taiflow_get_state_decomposition aiflow_get_state_decomposition;
    Taiflow_set_state_decomposition aiflow_set_state_decomposition;
    Taiflow_get_transition_condition aiflow_get_transition_condition;
    Taiflow_set_transition_condition aiflow_set_transition_condition;
    Taiflow_get_transition_action aiflow_get_transition_action;
    Taiflow_set_transition_action aiflow_set_transition_action;
    Taiflow_get_transition_execution_order aiflow_get_transition_execution_order;
    Taiflow_set_transition_execution_order aiflow_set_transition_execution_order;
    Taiflow_get_transition_breakpoint aiflow_get_transition_breakpoint;
    Taiflow_set_transition_breakpoint aiflow_set_transition_breakpoint;
    Taiflow_get_state_entry_action aiflow_get_state_entry_action;
    Taiflow_set_state_entry_action aiflow_set_state_entry_action;
    Taiflow_get_state_during_action aiflow_get_state_during_action;
    Taiflow_set_state_during_action aiflow_set_state_during_action;
    Taiflow_get_state_exit_action aiflow_get_state_exit_action;
    Taiflow_set_state_exit_action aiflow_set_state_exit_action;
    Taiflow_get_state_breakpoint aiflow_get_state_breakpoint;
    Taiflow_set_state_breakpoint aiflow_set_state_breakpoint;
    Taiflow_get_junction_breakpoint aiflow_get_junction_breakpoint;
    Taiflow_set_junction_breakpoint aiflow_set_junction_breakpoint;
    Taiflow_set_current_container aiflow_set_current_container;
    Taiflow_get_current_container aiflow_get_current_container;
    Taiflow_go_to_subchart aiflow_go_to_subchart;
    Taiflow_go_to_parent aiflow_go_to_parent;
    Taiflow_connect_objects aiflow_connect_objects;
    Taiflow_disconnect_objects aiflow_disconnect_objects;
    Taiflow_get_transition_source aiflow_get_transition_source;
    Taiflow_get_transition_target aiflow_get_transition_target;
    Taiflow_get_object_transitions aiflow_get_object_transitions;
    Taiflow_get_transition_count_between aiflow_get_transition_count_between;
    Taiflow_save_to_string aiflow_save_to_string;
    Taiflow_load_from_string aiflow_load_from_string;
    Taiflow_clear_selections aiflow_clear_selections;
    Taiflow_select_all_objects aiflow_select_all_objects;
    Taiflow_select_objects_by_type aiflow_select_objects_by_type;
    Taiflow_select_objects_in_rect aiflow_select_objects_in_rect;
    Taiflow_invert_selection aiflow_invert_selection;
    Taiflow_fit_view aiflow_fit_view;
    Taiflow_get_view_rect aiflow_get_view_rect;
    Taiflow_set_view_rect aiflow_set_view_rect;
    Taiflow_get_content_rect aiflow_get_content_rect;
    Taiflow_center_view_on_object aiflow_center_view_on_object;
    Taiflow_enum_objects_by_type aiflow_enum_objects_by_type;
    Taiflow_get_object_parent aiflow_get_object_parent;
    Taiflow_get_state_children aiflow_get_state_children;
    Tcreate_block_w_sid create_block_w_sid;
    Tget_block_sid get_block_sid;
    Tgenerate_code generate_code;
    Tload_diagram load_diagram;
    native_int FDummy[638]; // >>> mp mbd end <<<
} TTSMBD, *PTSMBD;

// =========================== TAC ===========================
typedef void* tac_debugger_t;   ///< Opaque handle to a TAC debugger and its engine.
typedef void* tac_value_t;      ///< Opaque handle to a TAC value.
typedef void* tac_breakpoint_t; ///< Opaque handle to a breakpoint.
typedef tac_debugger_t* p_tac_debugger_t;     ///< Pointer to a TAC debugger handle.
typedef tac_value_t* p_tac_value_t;           ///< Pointer to a TAC value handle.
typedef tac_breakpoint_t* p_tac_breakpoint_t; ///< Pointer to a TAC breakpoint handle.
typedef enum {
    TAC_TYPE_NULL,
    TAC_TYPE_INTEGER,
    TAC_TYPE_FLOAT,
    TAC_TYPE_BOOLEAN,
    TAC_TYPE_STRING,
    TAC_TYPE_ARRAY,
    TAC_TYPE_STRUCT,
    TAC_TYPE_FUNCTION,
    TAC_TYPE_UNKNOWN
} tac_value_type_t, *p_tac_value_type_t;
typedef enum {
    TAC_EVENT_BREAKPOINT_HIT,   ///< Execution stopped at a breakpoint.
    TAC_EVENT_PAUSED,           ///< Execution was paused by `tac_debugger_pause()`.
    TAC_EVENT_STEP_COMPLETE,    ///< A step operation (in, over, out) has completed.
    TAC_EVENT_SCRIPT_END,       ///< The script finished execution.
    TAC_EVENT_RUNTIME_ERROR,    ///< Execution stopped due to a runtime error.
    TAC_EVENT_TERMINATED,       ///< The debug session was terminated.
} tac_debug_event_t, *p_tac_debug_event_t;
/**
 * @brief Callback function for debugger events.
 *
 * @param debugger The debugger handle that triggered the event.
 * @param event The type of debug event.
 * @param file The file where the event occurred. Can be NULL if not from a file.
 * @param line The line number where the event occurred.
 * @param user_data The custom user data pointer provided when the debugger was created.
 */
typedef void (*tac_debug_callback_t)(const tac_debugger_t debugger, const tac_debug_event_t event, const char* file, const int line, const void* user_data);
typedef s32 (__stdcall* Ttac_debugger_create)(const void* AObj, const tac_debug_callback_t callback, const void* user_data, tac_debugger_t* debugger_ptr);
typedef s32 (__stdcall* Ttac_debugger_destroy)(const void* AObj, const tac_debugger_t debugger);
typedef s32 (__stdcall* Tdebugger_terminate)(const pvoid AObj, const tac_debugger_t debugger);
typedef s32 (__stdcall* Tdebugger_register_struct_from_json)(const pvoid AObj, const tac_debugger_t debugger, const char* type_name, const char* json_definition);
typedef s32 (__stdcall* Tdebugger_get_last_error)(const pvoid AObj, const tac_debugger_t debugger, char* message, ps32 message_size, char* file, ps32 file_size, ps32 line, ps32 column);
typedef s32 (__stdcall* Tdebugger_run_script)(const pvoid AObj, const tac_debugger_t debugger, const char* script_content, const char* script_name);
typedef s32 (__stdcall* Tdebugger_run_file)(const pvoid AObj, const tac_debugger_t debugger, const char* file_path);
typedef s32 (__stdcall* Tdebugger_is_running)(const pvoid AObj, const tac_debugger_t debugger, bool* is_running);
typedef s32 (__stdcall* Tdebugger_set_breakpoint)(const pvoid AObj, const tac_debugger_t debugger, const char* file, s32 line, tac_breakpoint_t breakpoint_ptr);
typedef s32 (__stdcall* Tdebugger_remove_breakpoint)(const pvoid AObj, const tac_debugger_t debugger, const tac_breakpoint_t breakpoint);
typedef s32 (__stdcall* Tdebugger_clear_breakpoints)(const pvoid AObj, const tac_debugger_t debugger);
typedef s32 (__stdcall* Tdebugger_get_breakpoints)(const pvoid AObj, const tac_debugger_t debugger, tac_breakpoint_t breakpoints_array, ps32 count);
typedef s32 (__stdcall* Tdebugger_has_breakpoint_at)(const pvoid AObj, const tac_debugger_t debugger, const char* file, s32 line, bool* exists);
typedef s32 (__stdcall* Ttac_breakpoint_get_info)(const pvoid AObj, const tac_breakpoint_t breakpoint, char* file_buffer, const s32 file_buffer_size, ps32 line_ptr);
typedef s32 (__stdcall* Tdebugger_pause)(const pvoid AObj, const tac_debugger_t debugger);
typedef s32 (__stdcall* Tdebugger_continue)(const pvoid AObj, const tac_debugger_t debugger);
typedef s32 (__stdcall* Tdebugger_step_over)(const pvoid AObj, const tac_debugger_t debugger);
typedef s32 (__stdcall* Tdebugger_step_into)(const pvoid AObj, const tac_debugger_t debugger);
typedef s32 (__stdcall* Tdebugger_step_out)(const pvoid AObj, const tac_debugger_t debugger);
typedef s32 (__stdcall* Tdebugger_get_call_stack_count)(const pvoid AObj, const tac_debugger_t debugger, ps32 frame_count);
typedef s32 (__stdcall* Tdebugger_get_call_stack_item)(const pvoid AObj, const tac_debugger_t debugger, const s32 frame_index, char* item, ps32 item_buffer_cnt);
typedef s32 (__stdcall* Tdebugger_get_local_variables_count)(const pvoid AObj, const tac_debugger_t debugger, const s32 frame_index, ps32 variable_cnt);
typedef s32 (__stdcall* Tdebugger_get_local_variable)(const pvoid AObj, const tac_debugger_t debugger, const s32 frame_index, const s32 var_index, p_tac_value_t variable);
typedef s32 (__stdcall* Tdebugger_evaluate_expression)(const pvoid AObj, const tac_debugger_t debugger, s32 frame_index, const char* expression, p_tac_value_t result_value);
typedef s32 (__stdcall* Tvalue_destroy)(const pvoid AObj, const tac_value_t value);
typedef s32 (__stdcall* Tvalue_get_type)(const pvoid AObj, const tac_value_t value, p_tac_value_type_t type_out);
typedef s32 (__stdcall* Tvalue_get_name)(const pvoid AObj, const tac_value_t value, char* name_buffer, const s32 buffer_size);
typedef s32 (__stdcall* Tvalue_to_string)(const pvoid AObj, const tac_value_t value, char* str_buffer, const s32 buffer_size);
typedef s32 (__stdcall* Tvalue_as_integer)(const pvoid AObj, const tac_value_t value, ps64 out);
typedef s32 (__stdcall* Tvalue_as_float)(const pvoid AObj, const tac_value_t value, pdouble out);
typedef s32 (__stdcall* Tvalue_as_boolean)(const pvoid AObj, const tac_value_t value, pbool out);
typedef s32 (__stdcall* Trun_script_sync)(const char* script_content, const char* script_name);
typedef s32 (__stdcall* Trun_file_sync)(const char* file_path);
// >>> mp tac prototype end <<<

typedef struct _TTSTAC {
    void* FObj;
    // >>> mp tac start <<<
    Ttac_debugger_create internal_tac_debugger_create;
    Ttac_debugger_destroy internal_tac_debugger_destroy;
    Tdebugger_terminate internal_debugger_terminate;
    Tdebugger_register_struct_from_json internal_debugger_register_struct_from_json;
    Tdebugger_get_last_error internal_debugger_get_last_error;
    Tdebugger_run_script internal_debugger_run_script;
    Tdebugger_run_file internal_debugger_run_file;
    Tdebugger_is_running internal_debugger_is_running;
    Tdebugger_set_breakpoint internal_debugger_set_breakpoint;
    Tdebugger_remove_breakpoint internal_debugger_remove_breakpoint;
    Tdebugger_clear_breakpoints internal_debugger_clear_breakpoints;
    Tdebugger_get_breakpoints internal_debugger_get_breakpoints;
    Tdebugger_has_breakpoint_at internal_debugger_has_breakpoint_at;
    Ttac_breakpoint_get_info internal_tac_breakpoint_get_info;
    Tdebugger_pause internal_debugger_pause;
    Tdebugger_continue internal_debugger_continue;
    Tdebugger_step_over internal_debugger_step_over;
    Tdebugger_step_into internal_debugger_step_into;
    Tdebugger_step_out internal_debugger_step_out;
    Tdebugger_get_call_stack_count internal_debugger_get_call_stack_count;
    Tdebugger_get_call_stack_item internal_debugger_get_call_stack_item;
    Tdebugger_get_local_variables_count internal_debugger_get_local_variables_count;
    Tdebugger_get_local_variable internal_debugger_get_local_variable;
    Tdebugger_evaluate_expression internal_debugger_evaluate_expression;
    Tvalue_destroy internal_value_destroy;
    Tvalue_get_type internal_value_get_type;
    Tvalue_get_name internal_value_get_name;
    Tvalue_to_string internal_value_to_string;
    Tvalue_as_integer internal_value_as_integer;
    Tvalue_as_float internal_value_as_float;
    Tvalue_as_boolean internal_value_as_boolean;
    Trun_script_sync run_script_sync;
    Trun_file_sync run_file_sync;
    native_int FDummy[67]; // >>> mp tac end <<<
    s32 value_as_boolean(const tac_value_t value, pbool out){return internal_value_as_boolean(FObj, value, out);}
    s32 value_as_float(const tac_value_t value, pdouble out){return internal_value_as_float(FObj, value, out);}
    s32 value_as_integer(const tac_value_t value, ps64 out){return internal_value_as_integer(FObj, value, out);}
    s32 value_to_string(const tac_value_t value, char* str_buffer, const s32 buffer_size){return internal_value_to_string(FObj, value, str_buffer, buffer_size);}
    s32 value_get_name(const tac_value_t value, char* name_buffer, const s32 buffer_size){return internal_value_get_name(FObj, value, name_buffer, buffer_size);}
    s32 value_get_type(const tac_value_t value, p_tac_value_type_t type_out){return internal_value_get_type(FObj, value, type_out);}
    s32 value_destroy(const tac_value_t value){return internal_value_destroy(FObj, value);}
    s32 debugger_evaluate_expression(const tac_debugger_t debugger, s32 frame_index, const char* expression, p_tac_value_t result_value){return internal_debugger_evaluate_expression(FObj, debugger, frame_index, expression, result_value);}
    s32 debugger_get_local_variable(const tac_debugger_t debugger, const s32 frame_index, const s32 var_index, p_tac_value_t variable){return internal_debugger_get_local_variable(FObj, debugger, frame_index, var_index, variable);}
    s32 debugger_get_local_variables_count(const tac_debugger_t debugger, const s32 frame_index, ps32 variable_cnt){return internal_debugger_get_local_variables_count(FObj, debugger, frame_index, variable_cnt);}
    s32 debugger_get_call_stack_item(const tac_debugger_t debugger, const s32 frame_index, char* item, ps32 item_buffer_cnt){return internal_debugger_get_call_stack_item(FObj, debugger, frame_index, item, item_buffer_cnt);}
    s32 debugger_get_call_stack_count(const tac_debugger_t debugger, ps32 frame_count){return internal_debugger_get_call_stack_count(FObj, debugger, frame_count);}
    s32 debugger_step_out(const tac_debugger_t debugger){return internal_debugger_step_out(FObj, debugger);}
    s32 debugger_step_into(const tac_debugger_t debugger){return internal_debugger_step_into(FObj, debugger);}
    s32 debugger_step_over(const tac_debugger_t debugger){return internal_debugger_step_over(FObj, debugger);}
    s32 debugger_continue(const tac_debugger_t debugger){return internal_debugger_continue(FObj, debugger);}
    s32 debugger_pause(const tac_debugger_t debugger){return internal_debugger_pause(FObj, debugger);}
    s32 breakpoint_get_info(const tac_breakpoint_t breakpoint, char* file_buffer, const s32 file_buffer_size, ps32 line_ptr){return internal_tac_breakpoint_get_info(FObj, breakpoint, file_buffer, file_buffer_size, line_ptr);}
    s32 debugger_has_breakpoint_at(const tac_debugger_t debugger, const char* file, s32 line, bool* exists){return internal_debugger_has_breakpoint_at(FObj, debugger, file, line, exists);}
    s32 debugger_get_breakpoints(const tac_debugger_t debugger, tac_breakpoint_t breakpoints_array, ps32 count){return internal_debugger_get_breakpoints(FObj, debugger, breakpoints_array, count);}
    s32 debugger_clear_breakpoints(const tac_debugger_t debugger){return internal_debugger_clear_breakpoints(FObj, debugger);}
    s32 debugger_remove_breakpoint(const tac_debugger_t debugger, const tac_breakpoint_t breakpoint){return internal_debugger_remove_breakpoint(FObj, debugger, breakpoint);}
    s32 debugger_set_breakpoint(const tac_debugger_t debugger, const char* file, s32 line, tac_breakpoint_t breakpoint_ptr){return internal_debugger_set_breakpoint(FObj, debugger, file, line, breakpoint_ptr);}
    s32 debugger_is_running(const tac_debugger_t debugger, bool* is_running){return internal_debugger_is_running(FObj, debugger, is_running);}
    s32 debugger_run_file(const tac_debugger_t debugger, const char* file_path){return internal_debugger_run_file(FObj, debugger, file_path);}
    s32 debugger_run_script(const tac_debugger_t debugger, const char* script_content, const char* script_name){return internal_debugger_run_script(FObj, debugger, script_content, script_name);}
    s32 debugger_get_last_error(const tac_debugger_t debugger, char* message, ps32 message_size, char* file, ps32 file_size, ps32 line, ps32 column){return internal_debugger_get_last_error(FObj, debugger, message, message_size, file, file_size, line, column);}
    s32 debugger_register_struct_from_json(const tac_debugger_t debugger, const char* type_name, const char* json_definition){return internal_debugger_register_struct_from_json(FObj, debugger, type_name, json_definition);}
    s32 debugger_create(const tac_debug_callback_t callback, const void* user_data, tac_debugger_t* debugger_ptr){
        return internal_tac_debugger_create(FObj, callback, user_data, debugger_ptr);
    }
    s32 debugger_destroy(const tac_debugger_t debugger){
        return internal_tac_debugger_destroy(FObj, debugger);
    }
    s32 debugger_terminate(const tac_debugger_t debugger){return internal_debugger_terminate(FObj, debugger);}
} TTSTAC, *PSTSTAC;

// TSMaster Configuration ========================================
typedef struct {
    TTSApp  FTSApp;
    TTSCOM  FTSCOM;
    TTSTest FTSTest;
    TTSMBD  FTSMBD;
    TTSTAC  FTSTAC;
    native_int FDummy[3000];
} TTSMasterConfiguration, *PTSMasterConfiguration;

// Variables definition
extern TTSApp app;
extern TTSCOM com;
extern TTSTest test;
extern TTSMBD mbd;
extern TTSTAC tac;

// Utility functions definition
#ifdef _MSC_VER
extern void internal_log(const char* AFile, const char* AFunc, const s32 ALine,
                         const TLogLevel ALevel,
                         _Printf_format_string_ const char* fmt, ...);
extern void internal_test_log(const char* AFile, const char* AFunc, const s32 ALine, const TLogLevel ALevel, _Printf_format_string_ const char* fmt, ...);						 
#else
extern void internal_log(const char* AFile, const char* AFunc, const s32 ALine, const TLogLevel ALevel, const char* fmt, ...) __attribute__((format(printf, 5, 6)));
extern void internal_test_log(const char* AFile, const char* AFunc, const s32 ALine, const TLogLevel ALevel, const char* fmt, ...) __attribute__((format(printf, 5, 6)));
#endif
extern void test_logCAN(const char* ADesc, PCAN ACAN, const TLogLevel ALevel);
#ifndef DONT_USE_TS_LOGGER
    #define log math_log
    #if __cplusplus == 201103L
    #include <xtgmath.h>
    #undef log
    #endif
    #include <cmath>
    #undef log
    #include <math.h>
    #undef log
    #define log(...)           internal_log(__FILE__, __FUNCTION__, __LINE__, lvlInfo, __VA_ARGS__)
#endif
#define printf(...)        internal_log(__FILE__, __FUNCTION__, __LINE__, lvlInfo, __VA_ARGS__)
#define log_ok(...)        internal_log(__FILE__, __FUNCTION__, __LINE__, lvlOK, __VA_ARGS__)
#define log_nok(...)       internal_log(__FILE__, __FUNCTION__, __LINE__, lvlError, __VA_ARGS__)
#define log_hint(...)      internal_log(__FILE__, __FUNCTION__, __LINE__, lvlHint, __VA_ARGS__)
#define log_warning(...)   internal_log(__FILE__, __FUNCTION__, __LINE__, lvlWarning, __VA_ARGS__)
#define test_log(...)      internal_test_log(__FILE__, __FUNCTION__, __LINE__, lvlInfo, __VA_ARGS__)
#define test_log_ok(...)   internal_test_log(__FILE__, __FUNCTION__, __LINE__, lvlOK, __VA_ARGS__)
#define test_log_nok(...)  internal_test_log(__FILE__, __FUNCTION__, __LINE__, lvlError, __VA_ARGS__)

#pragma pack(pop)

// Templates definition
template <typename T>
void output(T* msg);

// Software Constants
#define CONST_LOG_ERROR                                       1    /* error message will be displayed with red color */
#define CONST_LOG_WARNING                                     2    /* warning message will be displayed with blue color */
#define CONST_LOG_OK                                          3    /* OK message will be displayed with green color */
#define CONST_LOG_HINT                                        4    /* hint message will be displayed with yellow color */
#define CONST_LOG_INFO                                        5    /* info. message will be displayed with black color */
#define CONST_LOG_VERBOSE                                     6    /* verbose message will be displayed with gray color */
#define CONST_CH1                                             0    /* Channel 1 index */
#define CONST_CH2                                             1    /* Channel 2 index */
#define CONST_CH3                                             2    /* Channel 3 index */
#define CONST_CH4                                             3    /* Channel 4 index */
#define CONST_CH5                                             4    /* Channel 5 index */
#define CONST_CH6                                             5    /* Channel 6 index */
#define CONST_CH7                                             6    /* Channel 7 index */
#define CONST_CH8                                             7    /* Channel 8 index */
#define CONST_CH9                                             8    /* Channel 9 index */
#define CONST_CH10                                            9    /* Channel 10 index */
#define CONST_CH11                                            10   /* Channel 11 index */
#define CONST_CH12                                            11   /* Channel 12 index */
#define CONST_CH13                                            12   /* Channel 13 index */
#define CONST_CH14                                            13   /* Channel 14 index */
#define CONST_CH15                                            14   /* Channel 15 index */
#define CONST_CH16                                            15   /* Channel 16 index */
#define CONST_CH17                                            16   /* Channel 17 index */
#define CONST_CH18                                            17   /* Channel 18 index */
#define CONST_CH19                                            18   /* Channel 19 index */
#define CONST_CH20                                            19   /* Channel 20 index */
#define CONST_CH21                                            20   /* Channel 21 index */
#define CONST_CH22                                            21   /* Channel 22 index */
#define CONST_CH23                                            22   /* Channel 23 index */
#define CONST_CH24                                            23   /* Channel 24 index */
#define CONST_CH25                                            24   /* Channel 25 index */
#define CONST_CH26                                            25   /* Channel 26 index */
#define CONST_CH27                                            26   /* Channel 27 index */
#define CONST_CH28                                            27   /* Channel 28 index */
#define CONST_CH29                                            28   /* Channel 29 index */
#define CONST_CH30                                            29   /* Channel 30 index */
#define CONST_CH31                                            30   /* Channel 31 index */
#define CONST_CH32                                            31   /* Channel 32 index */
#define CONST_APP_CAN_TYPE                                    0    /* Application CAN channel type */
#define CONST_APP_LIN_TYPE                                    1    /* Application LIN channel type */
#define CONST_APP_FLEXRAY_TYPE                                2    /* Application FlexRay channel type */
#define CONST_APP_ETHERNET_TYPE                               3    /* Application Ethernet channel type */
#define CONST_BUS_UNKNOWN_TYPE                                0    /* device type - unknown */ 
#define CONST_TS_TCP_DEVICE                                   1    /* device type - TS Virtual Channel */ 
#define CONST_XL_USB_DEVICE                                   2    /* device type - XL USB Device */ 
#define CONST_TS_USB_DEVICE                                   3    /* device type - TS USB Device */ 
#define CONST_PEAK_USB_DEVICE                                 4    /* device type - PEAK USB Device */ 
#define CONST_KVASER_USB_DEVICE                               5    /* device type - Kvaser USB Device */ 
#define CONST_ZLG_USB_DEVICE                                  6    /* device type - ZLG USB Device */ 
#define CONST_ICS_USB_DEVICE                                  7    /* device type - ICS USB Device */ 
#define CONST_TS_TC1005_DEVICE                                8    /* device type - TS TC1005 Device */ 
#define CONST_CANABLE_DEVICE                                  9    /* device type - CANable Device */
#define CONST_STIM_STOPPED                                    0    /* STIM Signal - Stopped State */ 
#define CONST_STIM_RUNNING                                    1    /* STIM Signal - Running State */ 
#define CONST_STIM_PAUSED                                     2    /* STIM Signal - Paused State */ 
#define CONST_AM_NOT_RUN                                      0    /* Graphic Program (Automation Module) Running State - not running state */
#define CONST_AM_PREPARE_RUN                                  1    /* Graphic Program (Automation Module) Running State - Prepare running state */
#define CONST_AM_RUNNING                                      2    /* Graphic Program (Automation Module) Running State - Running state */
#define CONST_AM_PAUSED                                       3    /* Graphic Program (Automation Module) Running State - Paused state */
#define CONST_AM_STEPPING                                     4    /* Graphic Program (Automation Module) Running State - Stepping state */
#define CONST_AM_FINISHED                                     5    /* Graphic Program (Automation Module) Running State - Finished state */
#define CONST_SIGNAL_TYPE_CAN                                 0    /* Signal Checker - TSignalType.stCANSignal */
#define CONST_SIGNAL_TYPE_LIN                                 1    /* Signal Checker - TSignalType.stLINSignal */
#define CONST_SIGNAL_TYPE_SYSTEM_VAR                          2    /* Signal Checker - TSignalType.stSystemVar */
#define CONST_SIGNAL_TYPE_FLEXRAY                             3    /* Signal Checker - TSignalType.stFlexRay */
#define CONST_SIGNAL_TYPE_ETHERNET                            4    /* Signal Checker - TSignalType.stEthernet */
#define CONST_SIGNAL_CHECK_ALWAYS                             0    /* Signal Checker - TSignalCheckKind.sckAlways */
#define CONST_SIGNAL_CHECK_APPEAR                             1    /* Signal Checker - TSignalCheckKind.sckAppear */
#define CONST_SIGNAL_CHECK_STATISTICS                         2    /* Signal Checker - TSignalCheckKind.sckStatistics */
#define CONST_SIGNAL_CHECK_RISING_EDGE                        3    /* Signal Checker - TSignalCheckKind.sckRisingEdge */
#define CONST_SIGNAL_CHECK_FALLING_EDGE                       4    /* Signal Checker - TSignalCheckKind.sckFallingEdge */
#define CONST_SIGNAL_CHECK_MONOTONY_RISING                    5    /* Signal Checker - TSignalCheckKind.sckMonotonyRising */
#define CONST_SIGNAL_CHECK_MONOTONY_FALLING                   6    /* Signal Checker - TSignalCheckKind.sckMonotonyFalling */
#define CONST_SIGNAL_CHECK_FOLLOW                             7    /* Signal Checker - TSignalCheckKind.sckFollow */
#define CONST_SIGNAL_CHECK_JUMP                               8    /* Signal Checker - TSignalCheckKind.sckJump */
#define CONST_SIGNAL_CHECK_NO_CHANGE                          9    /* Signal Checker - TSignalCheckKind.sckNoChange */
#define CONST_SIGNAL_CHECK_BASELINE_FLUCTUATION               10    /* Signal Checker - TSignalCheckKind.sckBaselineFluctuation */
#define CONST_STATISTICS_MIN                                  0    /* Signal Checker - TSignalStatisticsKind.sskMin */
#define CONST_STATISTICS_MAX                                  1    /* Signal Checker - TSignalStatisticsKind.sskMax */
#define CONST_STATISTICS_AVERAGE                              2    /* Signal Checker - TSignalStatisticsKind.sskAverage */
#define CONST_STATISTICS_STANDARD_DEVIATION                   3    /* Signal Checker - TSignalStatisticsKind.sskStdDeviation */
#define CONST_SYMBOL_MAPPING_DIR_BIDIRECTION                  0    /* Symbol mapping direction - bidirection */
#define CONST_SYMBOL_MAPPING_DIR_SGN_TO_SYSVAR                1    /* Symbol mapping direction - from signal to sys var */
#define CONST_SYMBOL_MAPPING_DIR_SYSVAR_TO_SGN                2    /* Symbol mapping direction - from sys var to signal */
#define CONST_SYSTEM_VAR_TYPE_INT32                           0    /* System Var Type - svtInt32 */
#define CONST_SYSTEM_VAR_TYPE_UINT32                          1    /* System Var Type - svtUInt32 */
#define CONST_SYSTEM_VAR_TYPE_INT64                           2    /* System Var Type - svtInt64 */
#define CONST_SYSTEM_VAR_TYPE_UINT64                          3    /* System Var Type - svtUInt64 */
#define CONST_SYSTEM_VAR_TYPE_UINT8ARRAY                      4    /* System Var Type - svtUInt8Array */
#define CONST_SYSTEM_VAR_TYPE_INT32ARRAY                      5    /* System Var Type - svtInt32Array */
#define CONST_SYSTEM_VAR_TYPE_INT64ARRAY                      6    /* System Var Type - svtInt64Array */
#define CONST_SYSTEM_VAR_TYPE_DOUBLE                          7    /* System Var Type - svtDouble */
#define CONST_SYSTEM_VAR_TYPE_DOUBLEARRAY                     8    /* System Var Type - svtDoubleArray */
#define CONST_SYSTEM_VAR_TYPE_STRING                          9    /* System Var Type - svtString */
#define CONST_CANFD_CONTROLLER_TYPE_CAN                       0    /* CAN FD Controller Type - fdtCAN */
#define CONST_CANFD_CONTROLLER_TYPE_ISOCANFD                  1    /* CAN FD Controller Type - fdtISOCANFD */
#define CONST_CANFD_CONTROLLER_TYPE_NonISOCANFD               2    /* CAN FD Controller Type - fdtNonISOCANFD */
#define CONST_CANFD_CONTROLLER_MODE_NORMAL                    0    /* CAN FD Controller Mode - fdmNormal */
#define CONST_CANFD_CONTROLLER_MODE_ACKOFF                    1    /* CAN FD Controller Mode - fdmACKOff */
#define CONST_CANFD_CONTROLLER_MODE_RESTRICTED                2    /* CAN FD Controller Mode - fdmRestricted */
#define CONST_ONLINE_REPLAY_TIMEING_IMMEDIATELY               0    /* Online replay timing mode - ortImmediately */
#define CONST_ONLINE_REPLAY_TIMEING_ASLOG                     1    /* Online replay timing mode - ortAsLog */
#define CONST_ONLINE_REPLAY_TIMEING_DELAYED                   2    /* Online replay timing mode - ortDelayed */
#define CONST_ONLINE_REPLAY_STATUS_NOTSTARTED                 0    /* Online replay status - orsNotStarted */
#define CONST_ONLINE_REPLAY_STATUS_RUNNING                    1    /* Online replay status - orsRunning */
#define CONST_ONLINE_REPLAY_STATUS_PAUSED                     2    /* Online replay status - orsPaused */
#define CONST_ONLINE_REPLAY_STATUS_COMPLETED                  3    /* Online replay status - orsCompleted */
#define CONST_ONLINE_REPLAY_STATUS_TERMINATED                 4    /* Online replay status - orsTerminated */
#define CONST_BLF_OBJECT_CAN                                  0    /* BLF Object Type - sotCAN */
#define CONST_BLF_OBJECT_LIN                                  1    /* BLF Object Type - sotLIN */
#define CONST_BLF_OBJECT_CANFD                                2    /* BLF Object Type - sotCANFD */
#define CONST_BLF_OBJECT_REALTIMECOMMENT                      3    /* BLF Object Type - sotRealtimeComment */
#define CONST_BLF_OBJECT_SYSTEMVAR                            4    /* BLF Object Type - sotSystemVar */
#define CONST_BLF_OBJECT_FLEXRAY                              5    /* BLF Object Type - sotFlexRay */
#define CONST_BLF_OBJECT_ETHERNET                             6    /* BLF Object Type - sotEthernet */
#define CONST_RBS_INIT_VALUE_OPTIONS_USEDB                    0    /* RBS Init Value Options - rivUseDB */
#define CONST_RBS_INIT_VALUE_OPTIONS_USELAST                  1    /* RBS Init Value Options - rivUseLast */
#define CONST_RBS_INIT_VALUE_OPTIONS_USE0                     2    /* RBS Init Value Options - rivUse0 */
#define CONST_AM_SIGNAL_TYPE_CANSIGNAL                        0    /* Graphic Program (Automation Module) Signal Type - lastCANSignal */
#define CONST_AM_SIGNAL_TYPE_LINSIGNAL                        1    /* Graphic Program (Automation Module) Signal Type - lastLINSignal */
#define CONST_AM_SIGNAL_TYPE_SYSVAR                           2    /* Graphic Program (Automation Module) Signal Type - lastSysVar */
#define CONST_AM_SIGNAL_TYPE_LOCALVAR                         3    /* Graphic Program (Automation Module) Signal Type - lastLocalVar */
#define CONST_AM_SIGNAL_TYPE_CONST                            4    /* Graphic Program (Automation Module) Signal Type - lastConst */
#define CONST_AM_SIGNAL_TYPE_FLEXRAYSIGNAL                    5    /* Graphic Program (Automation Module) Signal Type - lastFlexRaySignal */
#define CONST_AM_SIGNAL_TYPE_IMMEDIATEVALUE                   6    /* Graphic Program (Automation Module) Signal Type - lastImmediateValue */
#define CONST_MP_FUNCTION_SOURCE_SYSTEMFUNC                   0    /* Mini Program Function Source - lmfsSystemFunc */
#define CONST_MP_FUNCTION_SOURCE_MPLIB                        1    /* Mini Program Function Source - lmfsMPLib */
#define CONST_MP_FUNCTION_SOURCE_INTERNAL                     2    /* Mini Program Function Source - lmfsInternal */
#define CONST_MP_VAR_TYPE_INTEGER                             0    /* Mini Program Variable Type - lvtInteger */
#define CONST_MP_VAR_TYPE_DOUBLE                              1    /* Mini Program Variable Type - lvtDouble */
#define CONST_MP_VAR_TYPE_STRING                              2    /* Mini Program Variable Type - lvtString */
#define CONST_MP_VAR_TYPE_CANMSG                              3    /* Mini Program Variable Type - lvtCANMsg */
#define CONST_MP_VAR_TYPE_CANFDMSG                            4    /* Mini Program Variable Type - lvtCANFDMsg */
#define CONST_MP_VAR_TYPE_LINMSG                              5    /* Mini Program Variable Type - lvtLINMsg */
#define CONST_STIM_SIGNAL_STATUS_STOPPED                      0    /* STIM Signal Status - sssStopped */
#define CONST_STIM_SIGNAL_STATUS_RUNNING                      1    /* STIM Signal Status - sssRunning */
#define CONST_STIM_SIGNAL_STATUS_PAUSED                       2    /* STIM Signal Status - sssPaused */
#define CONST_SIGNAL_TESTER_NO_ERROR                          0  /* No Error */
#define CONST_SIGNAL_TESTER_CHECK_SIGNAL_NOT_EXISTS_IN_DB     1  /* Check signal not exists in DB */
#define CONST_SIGNAL_TESTER_MIN_BIGGER_THAN_MAX               2  /* Minimum value larger than Maximum value */
#define CONST_SIGNAL_TESTER_STAR_TTIME_BIGGER_THAN_END_TIME   3  /* Start Time larger than End Time */
#define CONST_SIGNAL_TESTER_TRIGGER_MIN_BIGGER_THAN_MAX       4  /* Trigger Minimum value larger than maximum value */
#define CONST_SIGNAL_TESTER_SIGNAL_COUNT_IS_0                 5  /* Check signal count is zero */
#define CONST_SIGNAL_TESTER_FOLLOW_SIGNAL_NOT_EXISTS_IN_DB    6  /* Follow signal not exists in DB */
#define CONST_SIGNAL_TESTER_TRIGGER_SIGNAL_NOT_EXISTS_IN_DB   7  /* Trigger signal not exists in DB */
#define CONST_SIGNAL_TESTER_SIGNAL_FOLLOW_VIOLATION           8  /* Signal follow violation */
#define CONST_SIGNAL_TESTER_SIGNAL_MONOTONY_RISING_VIOLATION  9  /* Signal Monotony Rising voilation */
#define CONST_SIGNAL_TESTER_SIGNAL_MONOTONY_FALLING_VIOLATION 10 /* Signal Monotony Falling violation */
#define CONST_SIGNAL_TESTER_SIGNAL_NO_CHANGE_VIOLATION        11 /* Signal no change violation */
#define CONST_SIGNAL_TESTER_SIGNAL_VALUEOUTOFRANGE            12 /* Signal value out of range */
#define CONST_SIGNAL_TESTER_CAN_SIGNAL_NOT_EXISTS             13 /* CAN signal not exists */
#define CONST_SIGNAL_TESTER_LIN_SIGNAL_NOT_EXISTS             14 /* LIN signal not signals */
#define CONST_SIGNAL_TESTER_FLEXRAY_SIGNAL_NOT_EXISTS         15 /* FlexRay signal not exists */
#define CONST_SIGNAL_TESTER_SYSTEM_VAR_NOT_EXISTS             16 /* System variable not exists */
#define CONST_SIGNAL_TESTER_START_FAILED_DUE_TO_INVALID_CONF  17 /* Signal tester start failed due to invalid configuration */
#define CONST_SIGNAL_TESTER_SIGNAL_VALUE_NOT_EXISTS           18 /* Check Signal value not exist */
#define CONST_SIGNAL_TESTER_STATISTICS_CHECK_VIOLATION        19 /* Statistics value not within required rang */
#define CONST_SIGNAL_TESTER_TRIGGER_VALUE_NOT_EXISTS          20 /* Trigger signal value not exist */
#define CONST_SIGNAL_TESTER_FOLLOW_VALUE_NOT_EXISTS           21 /* Follow signal value not exist */
#define CONST_SIGNAL_TESTER_TRIGGER_VALUE_NEVER_IN_RANGE      22 /* Trigger signal value never in rang */
#define CONST_SIGNAL_TESTER_TIME_RANGE_NOT_TOUCHED            23 /* Allowed time range not touche */
#define CONST_SIGNAL_TESTER_RISING_NOT_DETECTED               24 /* Check signal rising edge not detecte */
#define CONST_SIGNAL_TESTER_FALLING_NOT_DETECTED              25 /* Check signal falling edge not detecte */
#define CONST_SIGNAL_TESTER_NOT_APPEARED                      26 /* Check Signal not appeared in rang */
#define CONST_SIGNAL_TESTER_JUMP_NOT_DETECTED                 27 /* Check signal jump not detect */

// API error codes
#define IDX_ERR_OK                                         0    /* OK */ 
#define IDX_ERR_IDX_OUT_OF_RANGE                           1    /* Index out of range */ 
#define IDX_ERR_CONNECT_FAILED                             2    /* Connect failed */ 
#define IDX_ERR_DEV_NOT_FOUND                              3    /* Device not found */ 
#define IDX_ERR_CODE_NOT_VALID                             4    /* Error code not valid */ 
#define IDX_ERR_ALREADY_CONNECTED                          5    /* HID device already connected */ 
#define IDX_ERR_HID_WRITE_FAILED                           6    /* HID write data failed */ 
#define IDX_ERR_HID_READ_FAILED                            7    /* HID read data failed */ 
#define IDX_ERR_HID_TX_BUFF_OVERRUN                        8    /* HID TX buffer overrun */ 
#define IDX_ERR_HID_TX_TOO_LARGE                           9    /* HID TX buffer too large */ 
#define IDX_ERR_PACKET_ID_INVALID                          10   /* HID RX packet report ID invalid */  
#define IDX_ERR_PACKET_LEN_INVALID                         11   /* HID RX packet length invalid */  
#define IDX_ERR_INTERNAL_TEST_FAILED                       12   /* Internal test failed */  
#define IDX_ERR_RX_PACKET_LOST                             13   /* RX packet lost */  
#define IDX_ERR_HID_SETUP_DI                               14   /* SetupDiGetDeviceInterfaceDetai */  
#define IDX_ERR_HID_CREATE_FILE                            15   /* Create file failed */  
#define IDX_ERR_HID_READ_HANDLE                            16   /* CreateFile failed for read handle */  
#define IDX_ERR_HID_WRITE_HANDLE                           17   /* CreateFile failed for write handle */  
#define IDX_ERR_HID_SET_INPUT_BUFF                         18   /* HidD_SetNumInputBuffers */  
#define IDX_ERR_HID_GET_PREPAESED                          19   /* HidD_GetPreparsedData */  
#define IDX_ERR_HID_GET_CAPS                               20   /* HidP_GetCaps */  
#define IDX_ERR_HID_WRITE_FILE                             21   /* WriteFile */  
#define IDX_ERR_HID_GET_OVERLAPPED                         22   /* GetOverlappedResult */  
#define IDX_ERR_HID_SET_FEATURE                            23   /* HidD_SetFeature */  
#define IDX_ERR_HID_GET_FEATURE                            24   /* HidD_GetFeature */  
#define IDX_ERR_HID_DEVICE_IO_CTRL                         25   /* Send Feature Report DeviceIoContro */  
#define IDX_ERR_HID_SEND_FEATURE_RPT                       26   /* Send Feature Report GetOverLappedResult */  
#define IDX_ERR_HID_GET_MANU_STR                           27   /* HidD_GetManufacturerString */  
#define IDX_ERR_HID_GET_PROD_STR                           28   /* HidD_GetProductString */  
#define IDX_ERR_HID_GET_SERIAL_STR                         29   /* HidD_GetSerialNumberString */  
#define IDX_ERR_HID_GET_INDEXED_STR                        30   /* HidD_GetIndexedString */  
#define IDX_ERR_TX_TIMEDOUT                                31   /* Transmit timed out */  
#define IDX_ERR_HW_DFU_WRITE_FLASH_FAILED                  32   /* HW DFU flash write failed */  
#define IDX_ERR_HW_DFU_WRITE_WO_ERASE                      33   /* HW DFU write without erase */  
#define IDX_ERR_HW_DFU_CRC_CHECK_ERROR                     34   /* HW DFU crc check error */  
#define IDX_ERR_HW_DFU_COMMAND_TIMED_OUT                   35   /* HW DFU reset before crc check success */  
#define IDX_ERR_HW_PACKET_ID_INVALID                       36   /* HW packet identifier invalid */  
#define IDX_ERR_HW_PACKET_LEN_INVALID                      37   /* HW packet length invalid */  
#define IDX_ERR_HW_INTERNAL_TEST_FAILED                    38   /* HW internal test failed */  
#define IDX_ERR_HW_RX_FROM_PC_PACKET_LOST                  39   /* HW rx from pc packet lost */  
#define IDX_ERR_HW_TX_TO_PC_BUFF_OVERRUN                   40   /* HW tx to pc buffer overrun */  
#define IDX_ERR_HW_API_PARAMETER_INVALID                   41   /* HW API parameter invalid */  
#define IDX_ERR_DFU_FILE_LOAD_FAILED                       42   /* DFU file load failed */  
#define IDX_ERR_DFU_HEADER_WRITE_FAILED                    43   /* DFU header write failed */  
#define IDX_ERR_READ_STATUS_TIMEDOUT                       44   /* Read status timed out */  
#define IDX_ERR_CALLBACK_ALREADY_EXISTS                    45   /* Callback already exists */  
#define IDX_ERR_CALLBACK_NOT_EXISTS                        46   /* Callback not exists */  
#define IDX_ERR_FILE_INVALID                               47   /* File corrupted or not recognized */  
#define IDX_ERR_DB_ID_NOT_FOUND                            48   /* Database unique id not found */  
#define IDX_ERR_SW_API_PARAMETER_INVALID                   49   /* Software API parameter invalid */  
#define IDX_ERR_SW_API_GENERIC_TIMEOUT                     50   /* Software API generic timed out */  
#define IDX_ERR_SW_API_SET_CONF_FAILED                     51   /* Software API set hw config. failed */  
#define IDX_ERR_SW_API_INDEX_OUT_OF_BOUNDS                 52   /* Index out of bounds */  
#define IDX_ERR_SW_API_WAIT_TIMEOUT                        53   /* RX wait timed out */  
#define IDX_ERR_SW_API_GET_IO_FAILED                       54   /* Get I/O failed */  
#define IDX_ERR_SW_API_SET_IO_FAILED                       55   /* Set I/O failed */  
#define IDX_ERR_SW_API_REPLAY_ON_GOING                     56   /* An active replay is already running */  
#define IDX_ERR_SW_API_INSTANCE_NOT_EXISTS                 57   /* Instance not exists */  
#define IDX_ERR_HW_CAN_TRANSMIT_FAILED                     58   /* CAN message transmit failed */  
#define IDX_ERR_HW_NO_RESPONSE                             59   /* No response from hardware */  
#define IDX_ERR_SW_CAN_MSG_NOT_FOUND                       60   /* CAN message not found */  
#define IDX_ERR_SW_CAN_RECV_BUFFER_EMPTY                   61   /* User CAN receive buffer empty */  
#define IDX_ERR_SW_CAN_RECV_PARTIAL_READ                   62   /* CAN total receive count <> desired count */  
#define IDX_ERR_SW_API_LINCONFIG_FAILED                    63   /* LIN config failed */  
#define IDX_ERR_SW_API_FRAMENUM_OUTOFRANGE                 64   /* LIN frame number out of range */  
#define IDX_ERR_SW_API_LDFCONFIG_FAILED                    65   /* LDF config failed */  
#define IDX_ERR_SW_API_LDFCONFIG_CMDERR                    66   /* LDF config cmd error */  
#define IDX_ERR_SW_ENV_NOT_READY                           67   /* TSMaster envrionment not ready */  
#define IDX_ERR_SECURITY_FAILED                            68   /* reserved failed */  
#define IDX_ERR_XL_ERROR                                   69   /* XL driver error */  
#define IDX_ERR_SEC_INDEX_OUTOFRANGE                       70   /* index out of range */  
#define IDX_ERR_STRINGLENGTH_OUTFOF_RANGE                  71   /* string length out of range */  
#define IDX_ERR_KEY_IS_NOT_INITIALIZATION                  72   /* key is not initialized */  
#define IDX_ERR_KEY_IS_WRONG                               73   /* key is wrong */  
#define IDX_ERR_NOT_PERMIT_WRITE                           74   /* write not permitted */  
#define IDX_ERR_16BYTES_MULTIPLE                           75   /* 16 bytes multiple */  
#define IDX_ERR_LIN_CHN_OUTOF_RANGE                        76   /* LIN channel out of range */  
#define IDX_ERR_DLL_NOT_READY                              77   /* DLL not ready */  
#define IDX_ERR_FEATURE_NOT_SUPPORTED                      78   /* Feature not supported */  
#define IDX_ERR_COMMON_SERV_ERROR                          79   /* common service error */  
#define IDX_ERR_READ_PARA_OVERFLOW                         80   /* read parameter overflow */  
#define IDX_ERR_INVALID_CHANNEL_MAPPING                    81   /* Invalid application channel mapping */  
#define IDX_ERR_TSLIB_GENERIC_OPERATION_FAILED             82   /* libTSMaster generic operation failed */  
#define IDX_ERR_TSLIB_ITEM_ALREADY_EXISTS                  83   /* item already exists */  
#define IDX_ERR_TSLIB_ITEM_NOT_FOUND                       84   /* item not found */  
#define IDX_ERR_TSLIB_LOGICAL_CHANNEL_INVALID              85   /* logical channel invalid */  
#define IDX_ERR_FILE_NOT_EXISTS                            86   /* file not exists */  
#define IDX_ERR_NO_INIT_ACCESS                             87   /* no init access, cannot set baudrate */  
#define IDX_ERR_CHN_NOT_ACTIVE                             88   /* the channel is inactive */  
#define IDX_ERR_CHN_NOT_CREATED                            89   /* the channel is not created */  
#define IDX_ERR_APPNAME_LENGTH_OUT_OF_RANGE                90   /* length of the appname is out of range */  
#define IDX_ERR_PROJECT_IS_MODIFIED                        91   /* project is modified */  
#define IDX_ERR_SIGNAL_NOT_FOUND_IN_DB                     92   /* signal not found in database */  
#define IDX_ERR_MESSAGE_NOT_FOUND_IN_DB                    93   /* message not found in database */  
#define IDX_ERR_TSMASTER_IS_NOT_INSTALLED                  94   /* TSMaster is not installed */  
#define IDX_ERR_LIB_LOAD_FAILED                            95   /* Library load failed */  
#define IDX_ERR_LIB_FUNCTION_NOT_FOUND                     96   /* Library function not found */  
#define IDX_ERR_LIB_NOT_INITIALIZED                        97   /* cannot find libTSMaster.dll, use "set_libtsmaster_location" to set its location before calling initialize_lib_tsmaster */  
#define IDX_ERR_PCAN_GENRIC_ERROR                          98   /* PCAN generic operation error */  
#define IDX_ERR_KVASER_GENERIC_ERROR                       99   /* Kvaser generic operation error */  
#define IDX_ERR_ZLG_GENERIC_ERROR                          100  /* ZLG generic operation error */   
#define IDX_ERR_ICS_GENERIC_ERROR                          101  /* ICS generic operation error */   
#define IDX_ERR_TC1005_GENERIC_ERROR                       102  /* TC1005 generic operation error */   
#define IDX_ERR_SYSTEM_VAR_NOT_FOUND                       103  /* System variable not found */   
#define IDX_ERR_INCORRECT_SYSTEM_VAR_TYPE                  104  /* Incorrect system variable type */   
#define IDX_ERR_CYCLIC_MSG_NOT_EXIST                       105  /* Message not existing, update failed */   
#define IDX_ERR_BAUD_NOT_AVAIL                             106  /* Specified baudrate not available */   
#define IDX_ERR_DEV_NOT_SUPPORT_SYNC_SEND                  107  /* Device does not support sync. transmit */   
#define IDX_ERR_MP_WAIT_TIME_NOT_SATISFIED                 108  /* Wait time not satisfied */   
#define IDX_ERR_CANNOT_OPERATE_WHILE_CONNECTED             109  /* Cannot operate while app is connected */   
#define IDX_ERR_CREATE_FILE_FAILED                         110  /* Create file failed */   
#define IDX_ERR_PYTHON_EXECUTE_FAILED                      111  /* Execute python failed */   
#define IDX_ERR_SIGNAL_MULTIPLEXED_NOT_ACTIVE              112  /* Current multiplexed signal is not active */   
#define IDX_ERR_GET_HANDLE_BY_CHANNEL_FAILED               113  /* Get handle by logic channel failed */   
#define IDX_ERR_CANNOT_OPERATE_WHILE_APP_CONN              114  /* Cannot operate while application is connected, please stop application first */   
#define IDX_ERR_FILE_LOAD_FAILED                           115  /* File load failed */   
#define IDX_ERR_READ_LINDATA_FAILED                        116  /* Read LIN Data Failed */   
#define IDX_ERR_FIFO_NOT_ENABLED                           117  /* FIFO not enabled */   
#define IDX_ERR_INVALID_HANDLE                             118  /* Invalid handle */   
#define IDX_ERR_READ_FILE_ERROR                            119  /* Read file error */   
#define IDX_ERR_READ_TO_EOF                                120  /* Read to EOF */   
#define IDX_ERR_CONF_NOT_SAVED                             121  /* Configuration not saved */   
#define IDX_ERR_IP_PORT_OPEN_FAILED                        122  /* IP port open failed */   
#define IDX_ERR_IP_TCP_CONNECT_FAILED                      123  /* TCP connect failed */   
#define IDX_ERR_DIR_NOT_EXISTS                             124  /* Directory not exists */   
#define IDX_ERR_CURRENT_LIB_NOT_SUPPORTED                  125  /* Current library not supported */   
#define IDX_ERR_TEST_NOT_RUNNING                           126  /* Test is not running */   
#define IDX_ERR_SERV_RESPONSE_NOT_RECV                     127  /* Server response not received */   
#define IDX_ERR_CREATE_DIR_FAILED                          128  /* Create directory failed */   
#define IDX_ERR_INCORRECT_ARGUMENT_TYPE                    129  /* Invalid argument type */   
#define IDX_ERR_READ_DATA_PACKAGE_OVERFLOW                 130  /* Read Data Package from Device Failed */   
#define IDX_ERR_REPLAY_IS_ALREADY_RUNNING                  131  /* Precise replay is running */   
#define IDX_ERR_REPALY_MAP_ALREADY_EXIST                   132  /* Replay map is already */   
#define IDX_ERR_USER_CANCEL_INPUT                          133  /* User cancel input */   
#define IDX_ERR_API_CHECK_FAILED                           134  /* API check result is negative */   
#define IDX_ERR_CANABLE_GENERIC_ERROR                      135  /* CANable generic error */   
#define IDX_ERR_WAIT_CRITERIA_NOT_SATISFIED                136  /* Wait criteria not satisfied */   
#define IDX_ERR_REQUIRE_APP_CONNECTED                      137  /* Operation requires application connected */   
#define IDX_ERR_PROJECT_PATH_ALREADY_USED                  138  /* Project path is used by another application */   
#define IDX_ERR_TP_TIMEOUT_AS                              139  /* Timeout for the sender to transmit data to the receiver */   
#define IDX_ERR_TP_TIMEOUT_AR                              140  /* Timeout for the receiver to transmit flow control to the sender */   
#define IDX_ERR_TP_TIMEOUT_BS                              141  /* Timeout for the sender to send first data frame after receiving FC frame */   
#define IDX_ERR_TP_TIMEOUT_CR                              142  /* Timeout for the receiver to receiving first CF frame after sending FC frame */   
#define IDX_ERR_TP_WRONG_SN                                143  /* Serial Number Error */   
#define IDX_ERR_TP_INVALID_FS                              144  /* Invalid flow status of the flow control frame */   
#define IDX_ERR_TP_UNEXP_PDU                               145  /* Unexpected Protocol Data Unit */   
#define IDX_ERR_TP_WFT_OVRN                                146  /* Wait counter of the FC frame out of the maxWFT */   
#define IDX_ERR_TP_BUFFER_OVFLW                            147  /* Buffer of the receiver is overflow */   
#define IDX_ERR_TP_NOT_IDLE                                148  /* TP Module is busy */   
#define IDX_ERR_TP_ERROR_FROM_CAN_DRIVER                   149  /* There is error from CAN Driver */   
#define IDX_ERR_TP_HANDLE_NOT_EXIST                        150  /* Handle of the TP Module is not exist */   
#define IDX_ERR_UDS_EVENT_BUFFER_IS_FULL                   151  /* UDS event buffer is full */   
#define IDX_ERR_UDS_HANDLE_POOL_IS_FULL                    152  /* Handle pool is full, can not add new UDS module */   
#define IDX_ERR_UDS_NULL_POINTER                           153  /* Pointer of UDS module is null */   
#define IDX_ERR_UDS_MESSAGE_INVALID                        154  /* UDS message is invalid */   
#define IDX_ERR_UDS_NO_DATA                                155  /* No uds data received */   
#define IDX_ERR_UDS_MODULE_NOT_EXISTING                    156  /* Handle of uds is not existing */   
#define IDX_ERR_UDS_MODULE_NOT_READY                       157  /* UDS module is not ready */   
#define IDX_ERR_UDS_SEND_DATA_FAILED                       158  /* Transmit UDS frame data failed */   
#define IDX_ERR_UDS_NOT_SUPPORTED                          159  /* This UDS Service is not supported */   
#define IDX_ERR_UDS_TIMEOUT_SENDING_REQUEST                160  /* Timeout to send uds request */   
#define IDX_ERR_UDS_TIMEOUT_GET_RESPONSE                   161  /* Timeout to get uds response */   
#define IDX_ERR_UDS_NEGATIVE_RESPONSE                      162  /* Get uds negative response */   
#define IDX_ERR_UDS_NEGATIVE_WITH_EXPECTED_NRC             163  /* Get uds negative response with expected NRC */   
#define IDX_ERR_UDS_NEGATIVE_UNEXPECTED_NRC                164  /* Get uds negative response with unexpected NRC */   
#define IDX_ERR_UDS_CANTOOL_NOT_READY                      165  /* UDS CAN Tool is not ready */   
#define IDX_ERR_UDS_DATA_OUTOF_RANGE                       166  /* UDS Dta outof range */   
#define IDX_ERR_UDS_UNEXPECTED_FRAME                       167  /* Get Unexpected UDS frame */   
#define IDX_ERR_UDS_UNEXPECTED_POSTIVE_RESPONSE            168  /* Receive unpexted positive response frame */   
#define IDX_ERR_UDS_POSITIVE_REPONSE_WITH_WRONG_DATA       169  /* Receive positive response with wrong data */   
#define IDX_ERR_UDS_REV_DATA_SHORT_THAN_EXPECTED           170  /* Length of received data package is short than expected */
#define IDX_ERR_UDS_MaxNumOfBlockLen_OVER_FLOW             171  /* MaxNumOfBlockLen out of range */   
#define IDX_ERR_UDS_NEGATIVE_RESPONSE_WITH_UNEXPECTED_NRC  172  /* Receive negative response with unexpected NRC */   
#define IDX_ERR_UDS_SERVICE_IS_RUNNING                     173  /* UDS serive is busy */   
#define IDX_ERR_UDS_NEED_APPLY_DOWNLOAD_FIRST              174  /* Apply download first before transfer data */   
#define IDX_ERR_UDS_RESPONSE_DATA_LENGTH_ERR               175  /* Length of the uds reponse is wrong */   
#define IDX_ERR_TEST_CHECK_LOWER                           176  /* Verdict value smaller than specification */   
#define IDX_ERR_TEST_CHECK_UPPER                           177  /* Verdict value greater than specification */   
#define IDX_ERR_TEST_VERDICT_CHECK_FAILED                  178  /* Verdict check failed */
#define IDX_ERR_AM_NOT_LOADED                              179  /* Graphic Program not loaded, please load it first */
#define IDX_ERR_PANEL_NOT_FOUND                            180  /* Panel not found */
#define IDX_ERR_CONTROL_NOT_FOUND_IN_PANEL                 181  /* Control not found in panel */
#define IDX_ERR_PANEL_NOT_LOADED                           182  /* Panel not loaded, please load it first */
#define IDX_ERR_STIM_SIGNAL_NOT_FOUND                      183  /* STIM signal not found */
#define IDX_ERR_AM_SUB_MODULE_NOT_AVAIL                    184  /* Graphic Program sub module not available */
#define IDX_ERR_AM_VARIANT_GROUP_NOT_FOUND                 185  /* Graphic Program variant group not found */
#define IDX_ERR_PANEL_CONTROL_NOT_FOUND                    186  /* Control not found in panel */
#define IDX_ERR_PANEL_CONTROL_NOT_SUPPORT_THIS             187  /* Panel control does not support this property */
#define IDX_ERR_RBS_NOT_RUNNING                            188  /* RBS engine is not running */
#define IDX_ERR_MSG_NOT_SUPPORT_PDU_CONTAINER              189  /* This message does not support PDU container */
#define IDX_ERR_DATA_NOT_AVAILABLE                         190  /* Data not available */
#define IDX_ERR_J1939_NOT_SUPPORTED                        191  /* J1939 not supported */
#define IDX_ERR_J1939_ANOTHER_PDU_IS_SENDING               192  /* Transmit J1939 PDU failed due to another PDU is already being transmitted */
#define IDX_ERR_J1939_TX_FAILED_PROTOCOL_ERROR             193  /* Transmit J1939 PDU failed due to protocol error */
#define IDX_ERR_J1939_TX_FAILED_NODE_INACTIVE              194  /* Transmit J1939 PDU failed due to node inactive */
#define IDX_ERR_NO_LICENSE                                 195  /* API is called without license support*/
#define IDX_ERR_SIGNAL_CHECK_RANGE_VIOLATION               196  /* Signal range check violation */
#define IDX_ERR_LOG_READ_CATEGORY_FAILED                   197  /* DataLogger read category failed */
#define IDX_ERR_CHECK_BOOT_VERSION_FAILED                  198  /* Check Flash Bootloader Version Failed */
#define IDX_ERR_LOG_FILE_NOT_CREATED                       199  /* Log file not created */
#define IDX_ERR_MODULE_IS_BEING_EDITED_BY_USER             200  /* the current module is being edited by user in dialog */
#define IDX_ERR_LOG_DEVICE_IS_BUSY                         201  /* The Logger device is busy, can not operation at the same time */
#define IDX_ERR_LIN_MASTER_TRANSMIT_N_AS_TIMEOUT           202  /* Master node transmit diagnostic package timeout */
#define IDX_ERR_LIN_MASTER_TRANSMIT_TRANSMIT_ERROR         203  /* Master node transmit frame failed */
#define IDX_ERR_LIN_MASTER_REV_N_CR_TIMEOUT                204  /* Master node receive diagnostic package timeout */
#define IDX_ERR_LIN_MASTER_REV_ERROR                       205  /* Master node receive frame failed */
#define IDX_ERR_LIN_MASTER_REV_INTERLLEAVE_TIMEOUT         206  /* Internal time runs out before reception is completed */
#define IDX_ERR_LIN_MASTER_REV_NO_RESPONSE                 207  /* Master node received no response */
#define IDX_ERR_LIN_MASTER_REV_SN_ERROR                    208  /* Serial Number Error when receiving multi frames */
#define IDX_ERR_LIN_SLAVE_TRANSMIT_N_CR_TIMEOUT            209  /* Slave node transmit diagnostic package timeout */
#define IDX_ERR_LIN_SLAVE_REV_N_CR_TIMEOUT                 210  /* Slave node receive diagnostic pacakge timeout */
#define IDX_ERR_LIN_SLAVE_TRANSMIT_ERROR                   211  /* Slave node transmit frames error */
#define IDX_ERR_LIN_SLAVE_REV_ERROR                        212  /* Slave node receive frames error */
#define IDX_ERR_CLOSE_FILE_FAILED                          213  /* Close file failed */
#define IDX_ERR_CONF_LOG_FILE_FAILED                       214  /* Configure log file failed */
#define IDX_ERR_CONVERT_LOG_FAILED                         215  /* Convert log file failed */
#define IDX_ERR_HALTED_DUE_TO_USER_BREAK                   216  /* Operation halted due to user break */
#define IDX_ERR_WRITE_FILE_FAILED                          217  /* Write file failed */
#define IDX_ERR_UNKNOWN_OBJECT_DETECTED                    218  /* Unknown object detected */
#define IDX_ERR_THIS_FUNC_SHOULD_BE_CALLED_IN_MP           219  /* this function should be called in mini program thread */
#define IDX_ERR_USER_CANCEL_WAIT                           220  /* user canceled wait */
#define IDX_ERR_DECOMPRESS_DATA_FAILED                     221  /* Decompress data failed */
#define IDX_ERR_AUTOMATION_OBJ_NOT_CREATED                 222  /* Automation object not created */
#define IDX_ERR_ITEM_DUPLICATED                            223  /* Item duplicated */
#define IDX_ERR_DIVIDE_BY_ZERO                             224  /* Divide by zero */
#define IDX_ERR_REQUIRE_MINI_PROGRAM_RUNNING               225  /* This operation requires mini program running */
#define IDX_ERR_FORM_NOT_EXIST                             226  /* Form not exists */
#define IDX_ERR_CANNOT_CONFIG_WHEN_DEVICE_RUNNING          227  /* Can not config when the device is running */
#define IDX_ERR_DATA_NOT_READY                             228  /* The data of the device is not ready */
#define IDX_ERR_STOP_DEVICE_FAILED                         229  /* Stop device failed */
#define IDX_ERR_PYTHON_CODE_CRASH                          230  /* Python code crashed */
#define IDX_ERR_CONDITION_NOT_MET                          231  /* Condition not met */
#define IDX_ERR_PYTHON_MODULE_NOT_DEPLOYED                 232  /* Cannot call API because Python module not deployed */
#define IDX_ERR_UDS_CONNECT_DUT_FAILED                     233  /* Connect Ethernet DUT Failed */
#define IDX_ERR_ETH_GENERIC_ACK                            234  /* Generic ACK of DOIP Frame */
#define IDX_ERR_ETH_VEHILCE_INFO_RES                       235  /* Response of Vehicle Information */
#define IDX_ERR_ETH_ACTIVATE_RES                           236  /* Response of Active Request */
#define IDX_ERR_ETH_ALIVE_RES                              237  /* Response of Alive Request */
#define IDX_ERR_ETH_NODE_STATE_RES                         238  /* Response of Node State */
#define IDX_ERR_ETH_DIAG_POWER_MODE_RES                    239  /* Response of Diagnostic Power Mode */
#define IDX_ERR_ETH_DIAG_POSITIVE_ACK                      240  /* Positive ACK of Diagnostic Request */
#define IDX_ERR_ETH_DIAG_NEGATIVE_ACK                      241  /* Negative ACK of Diagnostic Request */
#define IDX_ERR_ETH_VEHICLE_REQ_ID                         242  /* Vehicle ID Request */
#define IDX_ERR_ETH_VEHICLE_REQ_EID_ID                     243  /* Vehicle ID with EID Request */
#define IDX_ERR_ETH_VEHICLE_REQ_VIN_ID                     244  /* Vehicle ID with VIN Request */
#define IDX_ERR_ETH_ACTIVE_REQ                             245  /* Routing Activation Request */
#define IDX_ERR_ETH_ALIVE_REQ                              246  /* Alive Check Request */
#define IDX_ERR_ETH_NODE_STATE_REQ                         247  /* Node State Request */
#define IDX_ERR_ETH_DIAG_POWER_MODE_REQ                    248  /* Diagnostic Power Mode Request */
#define IDX_ERR_ETH_DIAG_REQ_RES                           249  /* DOIP Reqeust And Response */
#define IDX_ERR_SOCKET_PREPARE_ENVIROMENT_FIRST            250  /* Please prepare enviroment in TSMaster first */
#define IDX_ERR_ETH_RESERVED1                              251  /* Reserved1 for Ethernet */
#define IDX_ERR_GP_MODULE_NOT_FOUND                        252  /* Graphic program module not found */
#define IDX_ERR_GP_ACTION_NOT_FOUND                        253  /* Graphic program action not found */
#define IDX_ERR_GP_CANNOT_INSERT_GOTO_BETWEEN_ACTIONS      254  /* Graphic program Cannot insert goto between actions */
#define IDX_ERR_GP_CANNOT_DELETE_ACTION_WITH_BOTH_DIR      255  /* Graphic program Cannot delete action with both directions */
#define IDX_ERR_GP_ENTRY_POINT_CANNOT_BE_DELETED           256  /* Graphic program entry point cannot be deleted */
#define IDX_ERR_GP_KIND_CANNOT_BE_CHANGED                  257  /* Graphic program action type cannot be changed */
#define IDX_ERR_GP_INCORRECT_ACTION_TYPE                   258  /* Graphic program incorrect action type being edited */
#define IDX_ERR_GP_INCORRECT_EXECUTION_KIND                259  /* Graphic program incorrect execution kind being edited */
#define IDX_ERR_GP_ACTION_GROUP_REQUIRED                   260  /* Graphic program action group required */
#define IDX_ERR_GP_CANNOT_ADD_DOWNWARD_ACTION              261  /* Graphic program cannot add downward action */
#define IDX_ERR_GP_CANNOT_ADD_RIGHTWARD_ACTION             262  /* Graphic program cannot add rightward action */
#define IDX_ERR_RBS_NODE_SIMULATION_IS_NOT_ACTIVE          263  /* RBS node simulation is not active */
#define IDX_ERR_RBS_FRAME_INFO_NOT_FOUND                   264  /* RBS frame info not found */
#define IDX_ERR_RBS_IS_NOT_ENABLED                         265  /* RBS engine is not enabled */
#define IDX_ERR_GPG_EXCEL_FORMAT_INVALID                   266  /* Graphic program generator excel format invalid */
#define IDX_ERR_GPG_EXCEL_UNKNOWN_OBJ                      267  /* Graphic program generator excel unknown object*/
#define IDX_ERR_GPG_EXCEL_OBJ_NOT_FOUND                    268  /* Graphic program generator excel object not found */
#define IDX_ERR_GPG_EXCEL_OBJ_NOT_DEFINED                  269  /* Graphic program generator excel object not defined */
#define IDX_ERR_MP_CODE_CRASH                              270  /* Mini program code crash */
#define IDX_ERR_USER_ABORTED_OPERATION                     271  /* User aborted operation */
#define IDX_ERR_INVALID_MEMORY_ADDRESS                     272  /* Invalid memory address */
#define IDX_ERR_IP_FRAGMENTATION_NEED                      273  /* Fragmentation is needed when building IPv4 packet */
#define IDX_ERR_IP_IPV4_ID_REQUIRED                        274  /* IPv4 Id is required */
#define IDX_ERR_SYS_VAR_NOT_EXISTS                         275  /* System variable not exists */
#define IDX_ERR_WRITE_DEVICE_INT_CONFIG_FAILED             276  /* Write internal configuration of Device(such as TC1011 Etc) Failed */
#define IDX_ERR_READ_DEVICE_INT_CONFIG_FAILED              277  /* Read internal configuration of Device(such as TC1011 Etc) Failed */
#define IDX_ERR_ARGUMENT_COUNT_DIFFER                      278  /* API caller argument count differ */
#define IDX_ERR_API_CALLER_CALL_FAILED                     279  /* API caller call API failed */
#define IDX_ERR_ETH_FRAME_IS_NOT_IP                        280  /* Current ethernet frame is not IP frame */
#define IDX_ERR_ETH_FRAME_IS_NOT_TCP                       281  /* Current ethernet frame is not TCP frame */
#define IDX_ERR_ETH_FRAME_IS_NOT_UDP                       282  /* Current ethernet frame is not UDP frame */
#define IDX_ERR_ETH_FRAME_DOES_NOT_CONTAIN_CRC             283  /* Current ethernet frame does not contain CRC */
#define IDX_ERR_ETH_API_REQUIRES_SINGLE_FRAME              284  /* This API requires single frame, not fragment frame */
#define IDX_ERR_ITEM_NOT_ENABLED                           285  /* This item is not enabled in configuration */
#define IDX_ERR_ITEM_CONFIGURATION_NOT_VALID               286  /* This item configuration is not valid */
#define IDX_ERR_RESERVED01                                 287  /* Reserved definition */
#define IDX_ERR_SHOULD_START_BATCH_FIRST                   288  /* Should start batch first before this operation */
#define IDX_ERR_TEST_SYSTEM_MODULE_NOT_LOADED              289  /* Test system module not loaded */
#define IDX_ERR_VISA_COMMAD_FAILED                         290  /* VISA Command failed */
#define IDX_ERR_VISA_DEVICE_NOT_READY                      291  /* VISA Device not ready */                                             
#define IDX_ERR_ADD_INSTRUMENT_FAILED                      292  /* Add new instrument failed */                                         
#define IDX_ERR_LANG_KEY_NOT_FOUND                         293  /* Language item not found ini ini file */
#define IDX_ERR_MAC_ADDRESS_NOT_EXITS                      294  /* Mac Address not exists in router table */                             
#define IDX_ERR_IP_PORT_NOT_EXISTS                         295  /* IP and Port not exists in router table */                             
#define IDX_ERR_CRITICAL_SECTION_ENTER_FAILED              296  /* Critical section try enter failed */
#define IDX_ERR_REQUIRE_APP_DISCONNECTED                   297  /* This operation requires application disconnected */
#define IDX_ERR_SOCKET_ALREADY_EXISTS                      298  /* This socket is ready exists */      
#define IDX_ERR_SOCKET_NOT_EXISTS                          299  /* This socket is not exists */          
#define IDX_ERR_INVALID_IPV4_ENDPOINT                      300  /* The IPV4 Endpoint is invalid */      
#define IDX_ERR_TCP_CLIENT_NOT_SUPPORT_THIS_FEATURE        301  /* TCP Client not support this feature */
#define IDX_ERR_TCP_SERVER_NOT_SUPPORT_THIS_FEATURE        302  /* TCP Server not support this feature */
#define IDX_ERR_TCP_CLIENT_CONNECT_FAILED                  303  /* TCP Client connect to server failed */
#define IDX_ERR_TCP_START_LISTEN_FAILED                    304  /* TCP Server start listen failed */
#define IDX_ERR_TCP_DUPLICATE_START_LISTEN                 305  /* TCP Server start listen repeatedly is not allowed */
#define IDX_ERR_CREATE_SOCKET_FAILED                       306  /* Create socket failed */
#define IDX_ERR_RPC_SERVER_NOT_ACTIVATED                   307  /* RPC Server not activated */
#define IDX_ERR_RPC_CLIENT_NOT_ACTIVATED                   308  /* RPC Client not activated */
#define IDX_ERR_RPC_CALL_FAILED                            309  /* RPC call failed */
#define IDX_ERR_TSMASTER_NOT_IN_COSIMULATION               310  /* TSMaster is not in co-simulation mode */
#define IDX_ERR_OBJECT_NOT_CREATED                         311  /* Object not created */
#define IDX_ERR_OPERATION_NOT_SUPP_IN_BATCH_MODE           312  /* Operation not supported in batch mode */
#define IDX_ERR_NOT_IMPLEMENTED                            313  /* Not implemented */
#define IDX_ERR_OPERATION_PENDING                          314  /* Operation is pending */
#define IDX_ERR_COMPILE_FAILED                             315  /* Compile failed */
#define IDX_ERR_RPC_SERVER_RUN_FAILED                      316  /* Rpc Server run failed */
#define IDX_ERR_RPC_COMMAND_INVALID                        317  /* Invalid Rpc Command */
#define IDX_ERR_INIT_SIMULATION_FAILED                     318  /* Initialize simulation failed */
#define IDX_ERR_SIM_RUN_TO_END                             319  /* Simulation has run to end */
#define IDX_ERR_SIM_VAR_INVALID                            320  /* Simulation variable invalid */
#define IDX_ERR_COM_SERVER_FAILED                          321  /* COM server encounter error */
#define IDX_ERR_APP_NOT_CONNECTED                          322  /* Current application is not connected */
#define IDX_ERR_LOGIN_FAILED                               323  /* Login failed */
#define IDX_ERR_SIGNAL_NOT_INITIALIZED                     324  /* Signal does not appear */
#define IDX_ERR_DIR_SHOULD_BE_EMPTY                        325  /* Directory should be empty */
#define IDX_ERR_FMIL_LOAD_DLL_FAILED                       326  /* FMI dll load failed */
#define IDX_ERR_FMIL_GET_PROC_ADDRESS_FAILED               327  /* FMI get process address failed */
#define IDX_ERR_FMIL_UNLOAD_DLL_FAILED                     328  /* FMI dll unload failed */
#define IDX_ERR_FMIL_API_NOT_IMPL                          329  /* FMI API not implemented */
#define IDX_ERR_FMIL_FMI_VERSION_UNKNOWN                   330  /* FMI version unknown */
#define IDX_ERR_FMIL_FMI_VERSION_UNSUPPORTED               331  /* FMI version unsupported */
#define IDX_ERR_FMIL_FMI_IMPORT_UNEXPECTED                 332  /* FMI import unexpected */
#define IDX_ERR_FMIL_FMI_FMU_ALREADY_LOADED                333  /* FMI FMU already loaded */
#define IDX_ERR_FMIL_FMI_RESERVED1                         334  /* FMI reserved 1 */
#define IDX_ERR_FMIL_FMI_RESERVED2                         335  /* FMI reserved 2 */
#define IDX_ERR_FMIL_FMI_RESERVED3                         336  /* FMI reserved 3 */
#define IDX_ERR_TSMASTER_RPC_IP_PLUGIN_NOT_LOADED          337  /* TSMaster Rpc Ip plugin not loaded */
#define IDX_ERR_REQUIRE_GP_NOT_RUNNING                     338  /* This operation requires graphic program not in running state */
#define IDX_ERR_JAVA_JVM_RUN_FAILED                        339  /* Java virtual machine run failed */
#define IDX_ERR_JAVA_CLASS_NOT_FOUND                       340  /* Java class not found */
#define IDX_ERR_JAVA_JVM_NOT_RUNNING                       341  /* Java virtual machine is not running */
#define IDX_ERR_JAVA_JVM_ATTACH_THREAD_FAILED              342  /* Java virtual machine attach thread failed */
#define IDX_ERR_JAVA_CREATION_METHOD_NOT_FOUND             343  /* Java class creation method not found */
#define IDX_ERR_JAVA_OBJ_METHOD_NOT_FOUND                  344  /* Java object method not found */
#define IDX_ERR_JAVA_STATIC_METHOD_NOT_FOUND               345  /* Java class static method not found */
#define IDX_ERR_JAVA_API_NOT_VALID                         346  /* Java API not valid */
#define IDX_ERR_JAVA_API_ARG_COUNT_DIFFER                  347  /* Java API argument count differ */
#define IDX_ERR_JAVA_API_ARG_INVALID                       348  /* Java API argument invalid */
#define IDX_ERR_JAVA_API_OBJ_CREATE_FAILED                 349  /* Java API object create failed */
#define IDX_ERR_JAVA_API_RETN_NOT_SUPPORTED                350  /* Java API return value type not supported */
#define IDX_ERR_JAVA_API_ACCESS_VIOLATION                  351  /* Java API access violation */
#define IDX_ERR_JAVA_RESERVED1                             352  /* Java reserved 1 */
#define IDX_ERR_JAVA_RESERVED2                             353  /* Java reserved 2 */
#define IDX_ERR_JAVA_RESERVED3                             354  /* Java reserved 3 */
#define IDX_ERR_JAVA_RESERVED4                             355  /* Java reserved 4 */
#define IDX_ERR_JAVA_RESERVED5                             356  /* Java reserved 5 */
#define IDX_ERR_JAVA_RESERVED6                             357  /* Java reserved 6 */
#define IDX_ERR_JAVA_RESERVED7                             358  /* Java reserved 7 */
#define IDX_ERR_JAVA_RESERVED8                             359  /* Java reserved 8 */
#define IDX_ERR_PREREQUISITE_NOT_SATISFIED                 360  /* prerequisite not satisfied */
#define IDX_ERR_SWITCH_HW_DIAG_MODE_FIRST                  361  /* Switch the transport layer to run on the real-time system */
#define IDX_ERR_MBD_NOT_LOADED                             362  /* MBD module not loaded */
#define IDX_ERR_MODEL_IS_ALREADY_RUNNING                   363  /* Model is already running */
#define IDX_ERR_INVALID_MODEL_CONFIG                       364  /* Invalid model configuration */
#define IDX_ERR_INVALID_DATA_TYPE                          365  /* Invalid data type */
#define IDX_ERR_MODEL_INIT_FAILED                          366  /* Model initialization failed */
#define IDX_ERR_MODEL_STEP_FAILED                          367  /* Model step failed */
#define IDX_ERR_MODEL_NOT_FOUND                            368  /* Model not found */
#define IDX_ERR_MODEL_STOP_FAILED                          369  /* Model stop failed */
#define IDX_ERR_MODEL_SET_INPUT_FAILED                     370  /* Model set input failed */
#define IDX_ERR_MODEL_GET_OUTPUT_FAILED                    371  /* Model get output failed */
#define IDX_ERR_FEATURE_NOT_SUPPORTED_IN_CUR_CONFIG        372  /* Feature not supported in current configuration */
#define IDX_ERR_RPC_LOCAL_RX_SHARED_MEM_OPEN_FAIL1         373  /* Local Rpc Rx shared memory open failed 1 */
#define IDX_ERR_RPC_LOCAL_RX_SHARED_MEM_OPEN_FAIL2         374  /* Local Rpc Rx shared memory open failed as existing memory size smaller than request */
#define IDX_ERR_RPC_LOCAL_RX_SHARED_MEM_OPEN_FAIL3         375  /* Local Rpc Rx shared memory open failed 3 */
#define IDX_ERR_RPC_LOCAL_RX_SHARED_MEM_OPEN_FAIL4         376  /* Local Rpc Rx shared memory open failed 4 */
#define IDX_ERR_RPC_LOCAL_RX_SHARED_MEM_OPEN_FAIL5         377  /* Local Rpc Rx shared memory open failed 5 */
#define IDX_ERR_RPC_LOCAL_TX_SHARED_MEM_OPEN_FAIL1         378  /* Local Rpc Tx shared memory open failed 1 */
#define IDX_ERR_RPC_LOCAL_TX_SHARED_MEM_OPEN_FAIL2         379  /* Local Rpc Tx shared memory open failed as existing memory size smaller than request */
#define IDX_ERR_RPC_LOCAL_TX_SHARED_MEM_OPEN_FAIL3         380  /* Local Rpc Tx shared memory open failed 3 */
#define IDX_ERR_RPC_LOCAL_TX_SHARED_MEM_OPEN_FAIL4         381  /* Local Rpc Tx shared memory open failed 4 */
#define IDX_ERR_RPC_LOCAL_TX_SHARED_MEM_OPEN_FAIL5         382  /* Local Rpc Tx shared memory open failed 5 */
#define IDX_ERR_MBD_BLOCK_NOT_FOUND                        383  /* MBD block not found */
#define IDX_ERR_MBD_BLOCK_CANNOT_BE_ADDED_TWICE            384  /* MBD block cannot be added twice */
#define IDX_ERR_MBD_BLOCK_TYPE_NOT_SUPPORTED               385  /* MBD block type not supported */
#define IDX_ERR_MBD_BLOCK_PROPERTY_NOT_SUPPORTED           386  /* MBD block property not supported */
#define IDX_ERR_MBD_BLOCK_NOT_IN_SAME_DIAGRAM              387  /* MBD block not in same diagram */
#define IDX_ERR_MBD_BLOCK_IO_ALREADY_CONNECTED             388  /* MBD block io already connected */
#define IDX_ERR_SET_HW_CONFIG_MODE_FIRST                   389  /* Switch to config mode before calling the HW config API */
#define IDX_ERR_TAC_GENERIC_ERROR                          390  /* TAC generic error */
#define IDX_ERR_TAC_INVALID_HANDLE                         391  /* TAC invalid handle */
#define IDX_ERR_TAC_INVALID_ARG                            392  /* TAC invalid argument */
#define IDX_ERR_TAC_MEMORY_ALLOCATION_FAILED               393  /* TAC memory allocation failed */
#define IDX_ERR_TAC_SYNTAX_ERROR                           394  /* TAC syntax error */
#define IDX_ERR_TAC_RUNTIME_ERROR                          395  /* TAC runtime error */
#define IDX_ERR_TAC_NOT_PAUSED                             396  /* TAC not paused */
#define IDX_ERR_TAC_IS_RUNNING                             397  /* TAC is running */
#define IDX_ERR_TAC_BREAKPOINT_NOT_FOUND                   398  /* TAC breakpoint not found */
#define IDX_ERR_TAC_TERMINATED                             399  /* TAC terminated */
#define IDX_ERR_TAC_EVENT_TIMEOUT                          400  /* TAC event wait timeout */
#define IDX_ERR_TAC_NOT_RUNNING                            401  /* TAC not running (control call in stopped state) */
#define IDX_ERR_TAC_BUFFER_TOO_SMALL                       402  /* TAC output buffer too small */
#define IDX_ERR_TAC_FILE_MISMATCH                          403  /* TAC breakpoint file mismatch */
#define IDX_ERR_TAC_JSON_INVALID                           404  /* TAC JSON invalid */
#define IDX_ERR_TAC_WATCH_NOT_FOUND                        405  /* TAC watch id not found */
#define IDX_ERR_TAC_EVALUATE_FAILED                        406  /* TAC evaluate expression failed */
#define IDX_ERR_TAC_UNSUPPORTED                            407  /* TAC unsupported operation */
#define IDX_ERR_TAC_HANDLE_ALREADY_DESTROYED               408  /* TAC handle already destroyed */
#define IDX_ERR_TAC_VALUE_TYPE_MISMATCH                    409  /* TAC value type mismatch */
#define IDX_ERR_TAC_OVERFLOW                               410  /* TAC overflow */
#define IDX_ERR_TAC_UNDERFLOW                              411  /* TAC underflow */
#define IDX_ERR_TAC_STRING_ENCODING_INVALID                412  /* TAC string encoding invalid */
#define IDX_ERR_TAC_OUT_OF_RANGE                           413  /* TAC out of range */
#define IDX_ERR_TAC_INTERNAL_STATE                         414  /* TAC internal state error */
#define IDX_ERR_TAC_RESERVED16                             415  /* TAC reserved 16 */
#define IDX_ERR_TAC_RESERVED17                             416  /* TAC reserved 17 */
#define IDX_ERR_TAC_RESERVED18                             417  /* TAC reserved 18 */
#define IDX_ERR_TAC_RESERVED19                             418  /* TAC reserved 19 */
#define IDX_ERR_TAC_RESERVED20                             419  /* TAC reserved 20 */
#define IDX_ERR_TAC_RESERVED21                             420  /* TAC reserved 21 */
#define IDX_ERR_TAC_RESERVED22                             421  /* TAC reserved 22 */
#define IDX_ERR_TAC_RESERVED23                             422  /* TAC reserved 23 */
#define IDX_ERR_TAC_RESERVED24                             423  /* TAC reserved 24 */
#define IDX_ERR_TAC_RESERVED25                             424  /* TAC reserved 25 */
#define IDX_ERR_TAC_RESERVED26                             425  /* TAC reserved 26 */
#define IDX_ERR_TAC_RESERVED27                             426  /* TAC reserved 27 */
#define IDX_ERR_TAC_RESERVED28                             427  /* TAC reserved 28 */
#define IDX_ERR_TAC_RESERVED29                             428  /* TAC reserved 29 */
#define IDX_ERR_TAC_RESERVED30                             429  /* TAC reserved 30 */
#define IDX_ERR_TAC_RESERVED31                             430  /* TAC reserved 31 */
#define IDX_ERR_CAL_WRITE_DATA_FAILED                      431  /* Calibration data write failed. Verify authorization */
#define IDX_ERR_CAL_READ_DATA_FAILED                       432  /* Calibration data read failed */
// MBD AiFlow Error Codes (433-453) - Reserved 21 error codes for future expansion
#define IDX_ERR_MBD_AIFLOW_INVALID_CHART                   433  /* MBD AiFlow: Invalid Chart ID */
#define IDX_ERR_MBD_AIFLOW_NOT_FOUND                       434  /* MBD AiFlow: Object not found */
#define IDX_ERR_MBD_AIFLOW_INVALID_PARAM                   435  /* MBD AiFlow: Invalid parameter */
#define IDX_ERR_MBD_AIFLOW_NAME_EXISTS                     436  /* MBD AiFlow: Name already exists */
#define IDX_ERR_MBD_AIFLOW_INVALID_TYPE                    437  /* MBD AiFlow: Invalid type */
#define IDX_ERR_MBD_AIFLOW_INVALID_PARENT                  438  /* MBD AiFlow: Invalid parent object */
#define IDX_ERR_MBD_AIFLOW_CANNOT_DELETE                   439  /* MBD AiFlow: Cannot delete */
#define IDX_ERR_MBD_AIFLOW_BUFFER_TOO_SMALL                440  /* MBD AiFlow: Buffer too small */
#define IDX_ERR_MBD_AIFLOW_NO_SELECTION                    441  /* MBD AiFlow: No selection */
#define IDX_ERR_MBD_AIFLOW_SERIALIZATION_FAILED            442  /* MBD AiFlow: Serialization failed */
#define IDX_ERR_MBD_AIFLOW_CONNECTION_FAILED               443  /* MBD AiFlow: Connection failed */
#define IDX_ERR_MBD_AIFLOW_UI_NOT_AVAILABLE                444  /* MBD AiFlow: UI not available */
#define IDX_ERR_MBD_AIFLOW_NO_AIFLOW                       445  /* MBD AiFlow: Chart has no AiFlow */
#define IDX_ERR_MBD_AIFLOW_INTERNAL_ERROR                  446  /* MBD AiFlow: Internal error */
#define IDX_ERR_MBD_AIFLOW_RESERVED1                       447  /* MBD AiFlow: Reserved 1 */
#define IDX_ERR_MBD_AIFLOW_RESERVED2                       448  /* MBD AiFlow: Reserved 2 */
#define IDX_ERR_MBD_AIFLOW_RESERVED3                       449  /* MBD AiFlow: Reserved 3 */
#define IDX_ERR_MBD_AIFLOW_RESERVED4                       450  /* MBD AiFlow: Reserved 4 */
#define IDX_ERR_MBD_AIFLOW_RESERVED5                       451  /* MBD AiFlow: Reserved 5 */
#define IDX_ERR_MBD_AIFLOW_RESERVED6                       452  /* MBD AiFlow: Reserved 6 */
#define IDX_ERR_MBD_AIFLOW_RESERVED7                       453  /* MBD AiFlow: Reserved 7 */
#define IDX_ERR_HW_CAN_SEQ_TX_INVALID_HANDLE               454  /* Invalid handle when transmitting sequential CAN frames */
#define IDX_ERR_HW_CAN_SEQ_TX_CHN_NOT_READY                455  /* Channel not ready when transmitting sequential CAN frames */
#define IDX_ERR_HW_CAN_SEQ_TX_OUT_OF_RANGE                 456  /* Out of range when transmitting sequential CAN frames */
#define IDX_ERR_LIN_FRAME_OVER_FLOW                        457  /* LIN frame buffer over flow */                                    
#define IDX_ERR_LIN_SCHD_OVER_FLOW                         458  /* Schedule index is out of range */                                  
#define IDX_ERR_LIN_RESERVED00                             459  /* IDX_ERR_LIN_RESERVED00 */                                         
#define IDX_ERR_LIN_INVALID_FUNCTION_TYPE                  460  /* Invalid LIN function type, should be in [Master, Slave, Monitor] */
#define IDX_ERR_LIN_BAUDRATE_OUTOF_RANGE                   461  /* LIN baudrate is out of range */                                    
#define IDX_ERR_LIN_DIAG_IN_PROCESSING                     462  /* LIN diagnostic module is in processing */                          
#define IDX_ERR_LIN_RESERVED001                            463  /* IDX_ERR_LIN_RESERVED001 */                                       
#define IDX_ERR_LIN_NOT_SUPPORTED_IN_CUR_CONFIG            464  /* The feature is not supported in current configuration */          
#define IDX_ERR_NOT_SUPPORTED_IN_CUR_VERSION               465  /* The feature is not supported in current firmware version */         
#define IDX_ERR_LIN_FRAME_NOT_EXISTS                       466  /* IDX_ERR_LIN_RESERVED001 */                                           
#define IDX_ERR_LIN_RESERVED01                             467  /* IDX_ERR_LIN_RESERVED001 */                                       
#define IDX_ERR_LIN_RESERVED02                             468  /* IDX_ERR_LIN_RESERVED001 */                                          
#define IDX_ERR_LIN_RESERVED03                             469  /* IDX_ERR_LIN_RESERVED001 */                                         
#define IDX_ERR_LIN_RESERVED04                             470  /* IDX_ERR_LIN_RESERVED001 */                                        
#define IDX_ERR_LIN_RESERVED05                             471  /* IDX_ERR_LIN_RESERVED001 */                                        
#define IDX_ERR_LIN_RESERVED06                             472  /* IDX_ERR_LIN_RESERVED001 */                                        
#define IDX_ERR_LIN_RESERVED07                             473  /* IDX_ERR_LIN_RESERVED001 */                                          
#define IDX_ERR_LIN_RESERVED08                             474  /* IDX_ERR_LIN_RESERVED001 */                                         
#define IDX_ERR_LIN_RESERVED09                             475  /* IDX_ERR_LIN_RESERVED001 */                                         
#define IDX_ERR_LIN_RESERVED10                             476  /* IDX_ERR_LIN_RESERVED001 */                                          
#define IDX_ERR_MCP_PROVIDER_INVALID_ID                    477  /* Invalid MCP provider identifier */
#define IDX_ERR_MCP_PROVIDER_INVALID_HANDLER               478  /* Invalid MCP provider handler */
#define IDX_ERR_MCP_PROVIDER_ID_CONFLICT                   479  /* MCP provider identifier is already registered by another handler */
#define IDX_ERR_MCP_PROVIDER_HANDLER_MISMATCH              480  /* MCP provider handler does not match the registered handler */
#define IDX_ERR_MCP_PROVIDER_OWNER_UNRESOLVED              481  /* MCP provider owner module could not be resolved */
#define IDX_ERR_MCP_PROVIDER_OWNER_MISMATCH                482  /* MCP provider owner instance does not match the handler module */
#define IDX_ERR_MCP_PROVIDER_RUNTIME_NOT_READY             483  /* MCP provider runtime is not ready */
#define IDX_ERR_MCP_PROVIDER_NOT_REGISTERED                484  /* MCP provider is not registered */
#define IDX_ERR_MCP_PROVIDER_AUTOLOAD_MAPPING_NOT_FOUND    485  /* MCP provider auto-load mapping was not found */
#define IDX_ERR_MCP_PROVIDER_AUTOLOAD_MAPPING_INVALID      486  /* MCP provider auto-load mapping is invalid */
#define IDX_ERR_MCP_PROVIDER_LOAD_FAILED                   487  /* MCP provider module load failed */
#define IDX_ERR_MCP_PROVIDER_LOAD_WAIT_TERMINATED          488  /* MCP provider module load wait was terminated */
#define IDX_ERR_MCP_PROVIDER_REGISTRATION_FAILED           489  /* MCP provider registration transaction failed */
#define IDX_ERR_MCP_PROVIDER_REGISTRATION_MISSING_AFTER_LOAD 490  /* MCP provider registration is missing after module load */
#define IDX_ERR_MCP_PROVIDER_LOADING                       491  /* MCP provider module is loading */
#define IDX_ERR_MCP_PROVIDER_UNLOADING                     492  /* MCP provider module is unloading */
#define IDX_ERR_MCP_PROVIDER_BUSY                          493  /* MCP provider operation is busy */
#define IDX_ERR_MCP_PROVIDER_HANDLER_FAILED                494  /* MCP provider handler failed */
#define IDX_ERR_MCP_PROVIDER_UNLOAD_INDETERMINATE          495  /* MCP provider module could not complete safe unregister */
#define IDX_ERR_MEMORY_ALLOCATION_FAILED                   496  /* Memory allocation failed */
#define IDX_ERR_API_RETURN_VALUE_INVALID                   497  /* API returned an invalid value */
#define IDX_ERR_TARGET_RESOLUTION_AMBIGUOUS                498  /* Target resolution is ambiguous */
#define IDX_ERR_OUTPUT_BUFFER_TOO_SMALL                    499  /* Output buffer is too small */
#define IDX_ERR_NUMERIC_OVERFLOW                           500  /* Numeric value overflow */
#define IDX_ERR_CONFIGURATION_PATH_INVALID                 501  /* Configuration path is invalid */

// Note: error code should be started with IDX_ERR_

#endif

