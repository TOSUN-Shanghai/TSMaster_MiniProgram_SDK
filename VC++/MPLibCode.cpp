#define TSMP_IMPL
#include "TSMasterMP.h"
#include "MPLibrary.h"
#include "Database.h"
#include "Test.h"

// Function Prorotypes
s32 func1(const s32 A1, const s32 A2);

// 主step函数，执行周期 5 ms
void step(void) { // 周期 = 5 ms

}

// 自定义函数 "func1"
s32 func1(const s32 A1, const s32 A2) { // 自定义函数

	return A1 + A2;

}
