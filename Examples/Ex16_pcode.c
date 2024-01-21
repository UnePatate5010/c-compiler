// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}


pcode_fact() {
LOADP(bp + -1)
LOADI(1)
LTI
IFN(False_0)
LOADI(1)
return;
GOTO(End_0)
False_0:
LOADP(bp + -1)
LOADP(bp + -1)
LOADI(1)
SUBI
SAVEBP
CALL(pcode_fact)
RESTOREBP
ENDCALL(1)
MULTI
return;
end_0:
}

pcode_main() {
LOADI(5)
SAVEBP
CALL(pcode_fact)
RESTOREBP
ENDCALL(1)
return;
}
