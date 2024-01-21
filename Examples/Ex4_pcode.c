// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}


pcode_main() {
LOADI(1)
LOADF(2.200000)
LOADI(3)
I2F
MULTF
I2F2
ADDF
return;
}
