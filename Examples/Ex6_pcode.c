// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

LOADI(0)
LOADF(0.0)

pcode_main() {
LOADI(3)
STOREP(0)
LOADF(2.000000)
STOREP(1)
LOADI(1)
LOADP(1)
LOADP(0)
I2F
MULTF
I2F2
ADDF
return;
}
