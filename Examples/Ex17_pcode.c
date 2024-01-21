// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}


pcode_castToFloat() {
LOADP(bp + -1)
return;
}

pcode_main() {
LOADI(1)
SAVEBP
CALL(pcode_castToFloat)
RESTOREBP
ENDCALL(1)
return;
}
