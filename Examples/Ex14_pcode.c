// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}


pcode_plusUn() {
LOADP(bp + -1)
LOADI(1)
ADDI
return;
}

pcode_main() {
LOADI(1)
SAVEBP
CALL(pcode_plusUn)
RESTOREBP
ENDCALL(1)
return;
}
