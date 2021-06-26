#include "TSMasterBaseInclude.h"

DLLEXPORT void __stdcall write_api_document(const void* AOpaque, const TWriteAPIDocumentFunc AAPIFunc, const TWriteAPIParaFunc AParaFunc){
  AAPIFunc(AOpaque, "func1", "MPLibraryVC", "description of this example API", "s32 i = MPLibraryVC.func1(1, 2);", 2);
  AParaFunc(AOpaque, 0, "func1", "A1", true, "s32", "Parameter 1");
  AParaFunc(AOpaque, 1, "func1", "A2", true, "s32", "Parameter 2");

}

