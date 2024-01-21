// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}


pcode_main() {
LOADI(0)
LOADI(0)
LOADI(3)
STOREP(bp + 1)
SAVEBP
LOADI(0)
LOADI(4)
STOREP(bp + 1)
SAVEBP
LOADI(0)
LOADI(5)
STOREP(bp + 1)
RESTOREBP
LOADP(bp + 1)
STOREP(stack[bp] + 2)
RESTOREBP
LOADP(bp + 1)
STOREP(bp + 2)
LOADP(bp + 2)
return;
}
