#define TSMP_IMPL
#include "TSMasterMP.h"
#include "MPLibrary.h"
#include "Database.h"
#include "Test.h"

// Function Prorotypes
s32 func1(const s32 A1, const s32 A2);

// Variables defintions
TMPVarInt NewVariable1;

// Timers defintions
TMPTimerMS NewTimer1;

// 主step函数，执行周期 500 ms
void step(void) { // 周期 = 500 ms
	log("step function every 500ms");
}

// CAN报文接收事件 "NewOn_CAN_Rx1" 针对标识符 = 0x123 (FD)
void on_canfd_rx_NewOn_CAN_Rx1(const PCANFD ACANFD) { // 针对标识符 = 0x123 (FD)
	log("CAN frame 0x123 has been received");
}

// CAN报文发送成功事件 "NewOn_CAN_Tx1" 针对标识符 = 0x123 (FD)
void on_canfd_tx_NewOn_CAN_Tx1(const PCANFD ACANFD) { // 针对标识符 = 0x123 (FD)
	log("CAN frame 0x123 has been transmitted successfully");
}

// CAN报文预发送事件 "NewOn_CAN_PreTx1" 针对标识符 = 0x123 (FD)
void on_canfd_pretx_NewOn_CAN_PreTx1(const PCANFD ACANFD) { // 针对标识符 = 0x123 (FD)
	log("CAN frame 0x123 is being transmitted, you can modify its content before sending out");
}

// LIN报文接收事件 "NewOn_LIN_Rx1" 针对标识符 = 0x12
void on_lin_rx_NewOn_LIN_Rx1(const PLIN ALIN) { // 针对标识符 = 0x12
	log("LIN frame 0x12 has been received");
}

// LIN报文发送成功事件 "NewOn_LIN_Tx1" 针对标识符 = 0x12
void on_lin_tx_NewOn_LIN_Tx1(const PLIN ALIN) { // 针对标识符 = 0x12
	log("LIN frame 0x12 has been transmitted successfully");
}

// LIN报文预发送事件 "NewOn_LIN_PreTx1" 针对标识符 = 0x12
void on_lin_pretx_NewOn_LIN_PreTx1(const PLIN ALIN) { // 针对标识符 = 0x12
	log("LIN frame 0x12 is being transmitted, you can modify its content before sending out");
}

// 变量变化事件 "NewOn_Var_Change1" 针对变量 "NewVariable1"
void on_var_change_NewOn_Var_Change1(void) { // 变量 = NewVariable1
	log("NewVariable1 has been changed to %d", NewVariable1.get());
}

// 定时器触发事件 "NewOn_Timer1" for Timer NewTimer1
void on_timer_NewOn_Timer1(void) { // 定时器 = NewTimer1
	log("Timer 100ms fired");
}

// 启动事件 "NewOn_Start1"
void on_start_NewOn_Start1(void) { // 程序启动事件
	log("TSMaster mini program is starting...");
	NewTimer1.start();
}

// 停止事件 "NewOn_Stop1"
void on_stop_NewOn_Stop1(void) { // 程序停止事件
	log("TSMaster mini program is stopped");
}

// 快捷键事件 "NewOn_Shortcut1" 快捷键 = Ctrl+R
void on_shortcut_NewOn_Shortcut1(const s32 AShortcut) { // 快捷键事件 = Ctrl+R
	log("You have pressed Ctrl + R short-cut key");
}

// 自定义函数 "func1"
s32 func1(const s32 A1, const s32 A2) { // 自定义函数
	log("Custom function is called with result = %d", A1 + A2);
	return A1 + A2;

}
