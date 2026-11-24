#include "minisdk/log.h"
#include <stdarg.h>
#include <stdio.h>

void minisdk_log(enum minisdk_log_level level, const char *format, ...)
{
    static const char *const labels[] = {"INFO", "WARN", "ERROR"};
    va_list arguments;
    const char *label = "UNKNOWN";
    if ((unsigned int)level < (sizeof(labels) / sizeof(labels[0]))) label = labels[level];
    (void)fprintf(stderr, "[minisdk:%s] ", label);
    va_start(arguments, format);
    (void)vfprintf(stderr, format, arguments);
    va_end(arguments);
    (void)fputc('\n', stderr);
}
