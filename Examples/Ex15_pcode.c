// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}


pcode_plus() {
LOADP(bp + -2)
LOADP(bp + -1)
ADDI
return;
}

pcode_main() {
LOADI(5)
LOADI(6)
SAVEBP
CALL(pcode_plus)
RESTOREBP
ENDCALL(2)
return;
}
