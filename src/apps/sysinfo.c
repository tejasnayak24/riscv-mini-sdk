#include <stdio.h>
#include "minisdk/log.h"
#include "minisdk/sysinfo.h"
int main(void)
{
    char name[128];
    char release[128];
    if (minisdk_system_name(name, sizeof(name)) != 0 || minisdk_system_release(release, sizeof(release)) != 0) {
        minisdk_log(MINISDK_LOG_ERROR, "uname failed");
        return 1;
    }
    (void)printf("system: %s\nrelease: %s\npid: %ld\n", name, release, minisdk_process_id());
    return 0;
}
