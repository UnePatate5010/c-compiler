// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

LOADI(0)

pcode_main() {
LOADI(3)
STOREP(0)
LOADI(1)
LOADP(0)
ADDI
return;
}
