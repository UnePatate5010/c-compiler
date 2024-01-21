// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}


pcode_main() {
LOADI(0)
LOADI(3)
STOREP(bp + 1)
SAVEBP
LOADI(0)
LOADP(stack[bp] + 1)
STOREP(bp + 1)
SAVEBP
LOADI(0)
LOADP(stack[stack[bp]] + 1)
STOREP(bp + 1)
RESTOREBP
RESTOREBP
LOADI(1)
return;
}
