#include "TSMasterMP.h"
#include "MPLibrary.h"
#include "Test.h"

// Variables definition
TTSApp app;
TTSCOM com;
TTSTest test;

#define TEMP_STR_LEN 1024
typedef char* va_list;
#ifndef __va_rounded_size
#define __va_rounded_size(TYPE) (((sizeof(TYPE)+sizeof(int)-1)/sizeof(int))*sizeof(int))
#endif
 
#ifndef va_start
#define va_start(AP, LASTARG)   (AP = ((char *)& (LASTARG) + __va_rounded_size(LASTARG)))
#endif
 
#ifndef va_arg
#define va_arg(AP, TYPE)        (AP += __va_rounded_size(TYPE), *((TYPE *)(AP - __va_rounded_size(TYPE))))
#endif
 
#ifndef va_end
#define va_end(AP)              (AP = (va_list)0 )
#endif

// Utility functions definition
void log(const char* format, ...)
{
    char s[TEMP_STR_LEN];
    va_list args;
    va_start(args, format);
    vsprintf_s(s, format, args);
    va_end(args);
    app.log(s, lvlInfo);
    
}

void printf(char* format, ...)
{
    char s[TEMP_STR_LEN];
    va_list args;
    va_start(args, format);
    vsprintf_s(s, format, args);
    va_end(args);
    app.log(s, lvlInfo);
    
}

void test_log(const char* format, ...)
{
    char s[TEMP_STR_LEN];
    va_list args;
    va_start(args, format);
    vsprintf_s(s, format, args);
    va_end(args);
    test.log(s, lvlInfo);
    
}

void test_log_ok(const char* format, ...)
{
    char s[TEMP_STR_LEN];
    va_list args;
    va_start(args, format);
    vsprintf_s(s, format, args);
    va_end(args);
    test.log(s, lvlOK);
    
}

void test_log_nok(const char* format, ...)
{
    char s[TEMP_STR_LEN];
    va_list args;
    va_start(args, format);
    vsprintf_s(s, format, args);
    va_end(args);
    test.log(s, lvlError);
    
}

void test_logCAN(const char* ADesc, PCAN ACAN, const TLogLevel ALevel)
{
    char s[TEMP_STR_LEN];
    // channel, id, dlc, [data]
    if (ACAN->is_tx){
        if (ACAN->is_data){
            sprintf_s(s, "%s %d %03X Tx d %d [%02X %02X %02X %02X %02X %02X %02X %02X]", ADesc, ACAN->FIdxChn, ACAN->FIdentifier, ACAN->FDLC, ACAN->FData[0], ACAN->FData[1], ACAN->FData[2], ACAN->FData[3], ACAN->FData[4], ACAN->FData[5], ACAN->FData[6], ACAN->FData[7]);
        } else {
            sprintf_s(s, "%s %d %03X Tx r %d", ADesc, ACAN->FIdxChn, ACAN->FIdentifier, ACAN->FDLC);
        }
    } else {
        if (ACAN->is_data){
            sprintf_s(s, "%s %d %03X Rx d %d [%02X %02X %02X %02X %02X %02X %02X %02X]", ADesc, ACAN->FIdxChn, ACAN->FIdentifier, ACAN->FDLC, ACAN->FData[0], ACAN->FData[1], ACAN->FData[2], ACAN->FData[3], ACAN->FData[4], ACAN->FData[5], ACAN->FData[6], ACAN->FData[7]);
        } else {
            sprintf_s(s, "%s %d %03X Rx r %d", ADesc, ACAN->FIdxChn, ACAN->FIdentifier, ACAN->FDLC);
        }
    }
    test.log(s, ALevel);
}

DLLEXPORT s32 __stdcall initialize_miniprogram(const PTSMasterConfiguration AConf)
{
    app = AConf->FTSApp;
    com = AConf->FTSCOM;
    test = AConf->FTSTest;
    return 0;
    
}

DLLEXPORT s32 __stdcall finalize_miniprogram(void)
{
    return 0;
    
}

// MP library functions definition

// Variables defintions
extern TMPVarInt NewVariable1;

// Timers defintions
extern TMPTimerMS NewTimer1;

// Retrieve TSMP abilities
typedef s32 (__stdcall* TRegTSMasterFunction)(const void* AObj, const char* AFuncType, const char* AFuncName, const char* AData, const void* AFuncPointer, const char* ADescription);
extern void step(void);
extern void on_canfd_rx_NewOn_CAN_Rx1(const PCANFD ACANFD);
extern void on_canfd_tx_NewOn_CAN_Tx1(const PCANFD ACANFD);
extern void on_canfd_pretx_NewOn_CAN_PreTx1(const PCANFD ACANFD);
extern void on_lin_rx_NewOn_LIN_Rx1(const PLIN ALIN);
extern void on_lin_tx_NewOn_LIN_Tx1(const PLIN ALIN);
extern void on_lin_pretx_NewOn_LIN_PreTx1(const PLIN ALIN);
extern void on_var_change_NewOn_Var_Change1(void);
extern void on_timer_NewOn_Timer1(void);
extern void on_start_NewOn_Start1(void);
extern void on_stop_NewOn_Stop1(void);
extern void on_shortcut_NewOn_Shortcut1(const s32 AShortcut);
// extern your custom function definitions here
extern s32 func1(const s32 A1, const s32 A2);
DLLEXPORT s32 __stdcall retrieve_mp_abilities(const void* AObj, const TRegTSMasterFunction AReg) {
  // struct size check, do not modify ======================================================================================================================================
  #define TSMASTER_VERSION "2021.6.22.581" // do not modify this version as it depends on TSMaster implementation !
  if (!AReg(AObj, "check_mp_internal", "version", TSMASTER_VERSION, 0, "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_app", (void *)sizeof(TTSMasterConfiguration), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_tcan", (void *)sizeof(TCAN), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_tcanfd", (void *)sizeof(TCANFD), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_tlin", (void *)sizeof(TLIN), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_TMPVarInt", (void *)sizeof(TMPVarInt), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_TMPVarDouble", (void *)sizeof(TMPVarDouble), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_TMPVarString", (void *)sizeof(TMPVarString), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_TMPVarCAN", (void *)sizeof(TMPVarCAN), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_TMPVarCANFD", (void *)sizeof(TMPVarCANFD), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_TMPVarLIN", (void *)sizeof(TMPVarLIN), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_TLIBTSMapping", (void *)sizeof(TLIBTSMapping), "")) return -1;
  if (!AReg(AObj, "check_mp_internal", "struct_size", "struct_size_TLIBSystemVarDef", (void *)sizeof(TLIBSystemVarDef), "")) return -1;
  // step function will run with 500 ms interval ============================================================================================================================
  if (!AReg(AObj, "step_function", "step", "500", &step, "")) return -1;
  // Mini program variables will be registered here, 0: integer; 1: double; 2: string; 3: TCAN; 4: TCANFD; 5: TLIN ==========================================================
  if (!AReg(AObj, "var", "NewVariable1", "0", &NewVariable1, "")) return -1;
  // Timers can be defined here, 100 means interval = 100ms =================================================================================================================
  if (!AReg(AObj, "timer", "NewTimer1", "100", &NewTimer1, "")) return -1;
  // CAN receive done callback will be registered here, 291: identifier; -1: standard frame and 0 means extended frame; -1: can fd frame and 0 means classical can frame ====
  if (!AReg(AObj, "on_can_rx_callback", "on_canfd_rx_NewOn_CAN_Rx1", "291,-1,-1", &on_canfd_rx_NewOn_CAN_Rx1, "")) return -1;
  // CAN transmit done callback will be registered here, 291: identifier; -1: standard frame and 0 means extended frame; -1: can fd frame and 0 means classical can frame ===
  if (!AReg(AObj, "on_can_tx_callback", "on_canfd_tx_NewOn_CAN_Tx1", "291,-1,-1", &on_canfd_tx_NewOn_CAN_Tx1, "")) return -1;
  // CAN pre-transmit callback will be registered here, 291: identifier; -1: standard frame and 0 means extended frame; -1: can fd frame and 0 means classical can frame ====
  if (!AReg(AObj, "on_can_pretx_callback", "on_canfd_pretx_NewOn_CAN_PreTx1", "291,-1,-1", &on_canfd_pretx_NewOn_CAN_PreTx1, "")) return -1;
  // LIN receive done callback will be registered here, 18: identifier ======================================================================================================
  if (!AReg(AObj, "on_lin_rx_callback", "on_lin_rx_NewOn_LIN_Rx1", "18", &on_lin_rx_NewOn_LIN_Rx1, "")) return -1;
  // LIN transmit done callback will be registered here, 18: identifier =====================================================================================================
  if (!AReg(AObj, "on_lin_tx_callback", "on_lin_tx_NewOn_LIN_Tx1", "18", &on_lin_tx_NewOn_LIN_Tx1, "")) return -1;
  // LIN pre-transmit callback will be registered here, 18: identifier ======================================================================================================
  if (!AReg(AObj, "on_lin_pretx_callback", "on_lin_pretx_NewOn_LIN_PreTx1", "18", &on_lin_pretx_NewOn_LIN_PreTx1, "")) return -1;
  // Mini program variable change callback will be registered here ==========================================================================================================
  if (!AReg(AObj, "on_var_change_callback", "on_var_change_NewOn_Var_Change1", "NewVariable1", &on_var_change_NewOn_Var_Change1, "")) return -1;
  // Timer overflow callback will be registered here ========================================================================================================================
  if (!AReg(AObj, "on_timer_callback", "on_timer_NewOn_Timer1", "NewTimer1", &on_timer_NewOn_Timer1, "")) return -1;
  // Mini program start callback will be registered here ====================================================================================================================
  if (!AReg(AObj, "on_start_callback", "on_start_NewOn_Start1", "", &on_start_NewOn_Start1, "")) return -1;
  // Mini program stop callback will be registered here =====================================================================================================================
  if (!AReg(AObj, "on_stop_callback", "on_stop_NewOn_Stop1", "", &on_stop_NewOn_Stop1, "")) return -1;
  // Short-cut key callback will be registered here =========================================================================================================================
  if (!AReg(AObj, "on_shortcut_callback", "on_shortcut_NewOn_Shortcut1", "Ctrl+R", &on_shortcut_NewOn_Shortcut1, "")) return -1;
  // add your custom functions here =========================================================================================================================================
  if (!AReg(AObj, "on_custom_callback", "func1", "const s32 A1, const s32 A2", &func1, "this is a demo api")) return -1;
  // MP library functions

  return 2; // = 1 + (total number of your custom functions)
}
