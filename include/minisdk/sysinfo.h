#ifndef MINISDK_SYSINFO_H
#define MINISDK_SYSINFO_H
#include <stddef.h>
int minisdk_system_name(char *buffer, size_t buffer_size);
int minisdk_system_release(char *buffer, size_t buffer_size);
long minisdk_process_id(void);
#endif
