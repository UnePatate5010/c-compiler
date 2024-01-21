// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

LOADF(0.0)
LOADI(0)

pcode_main() {
LOADP(0)
LOADF(0.000000)
GTF
IFN(False_0)
LOADI(1)
STOREP(1)
GOTO(End_0)
False_0:
LOADI(0)
STOREP(1)
end_0:
LOADP(1)
return;
}
