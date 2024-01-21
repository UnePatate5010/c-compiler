// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

LOADF(0.0)
LOADF(0.0)
LOADI(0)

pcode_main() {
LOADP(0)
LOADF(0.000000)
GTF
IFN(False_0)
SAVEBP
LOADP(1)
LOADF(0.000000)
GTF
IFN(False_1)
LOADI(1)
STOREP(2)
GOTO(End_1)
False_1:
LOADI(2)
STOREP(2)
end_1:
RESTOREBP
GOTO(End_0)
False_0:
SAVEBP
LOADP(1)
LOADF(0.000000)
GTF
IFN(False_2)
LOADI(3)
STOREP(2)
GOTO(End_2)
False_2:
LOADI(4)
STOREP(2)
end_2:
RESTOREBP
end_0:
LOADP(2)
return;
}
