// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}


pcode_main() {
LOADI(1)
return;
}
