#include <stdio.h>
#include "minisdk/log.h"
int main(void)
{
    minisdk_log(MINISDK_LOG_INFO, "starting hello application");
    (void)puts("Hello from RISC-V Mini SDK!");
    return 0;
}
