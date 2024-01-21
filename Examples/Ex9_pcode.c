// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

LOADI(0)
LOADI(0)
LOADI(0)

pcode_main() {
LOADI(3)
STOREP(0)
LOADI(5)
STOREP(1)
LOADI(0)
STOREP(2)
StartLoop_0:
LOADP(0)
LOADI(0)
GTI
IFN(EndLoop_0)
SAVEBP
LOADP(2)
LOADP(1)
ADDI
STOREP(2)
LOADP(0)
LOADI(1)
SUBI
STOREP(0)
RESTOREBP
GOTO(StartLoop_0)
EndLoop_0:
LOADP(2)
return;
}
