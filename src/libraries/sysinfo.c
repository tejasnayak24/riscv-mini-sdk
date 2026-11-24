#include "minisdk/sysinfo.h"
#include <sys/utsname.h>
#include <unistd.h>

static int copy_field(char *buffer, size_t buffer_size, const char *value)
{
    size_t index;
    if (buffer == NULL || value == NULL || buffer_size == 0U) return -1;
    for (index = 0U; index + 1U < buffer_size && value[index] != '\0'; ++index) buffer[index] = value[index];
    buffer[index] = '\0';
    return value[index] == '\0' ? 0 : -1;
}

int minisdk_system_name(char *buffer, size_t buffer_size)
{
    struct utsname info;
    if (uname(&info) != 0) return -1;
    return copy_field(buffer, buffer_size, info.sysname);
}

int minisdk_system_release(char *buffer, size_t buffer_size)
{
    struct utsname info;
    if (uname(&info) != 0) return -1;
    return copy_field(buffer, buffer_size, info.release);
}

long minisdk_process_id(void) { return (long)getpid(); }
