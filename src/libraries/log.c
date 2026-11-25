#include "minisdk/log.h"
#include <stdarg.h>
#include <stdio.h>

void minisdk_log(enum minisdk_log_level level, const char *format, ...)
{
    va_list arguments;
    const char *label = "UNKNOWN";

    switch (level) {
    case MINISDK_LOG_INFO:
        label = "INFO";
        break;
    case MINISDK_LOG_WARN:
        label = "WARN";
        break;
    case MINISDK_LOG_ERROR:
        label = "ERROR";
        break;
    default:
        break;
    }
    (void)fprintf(stderr, "[minisdk:%s] ", label);
    if (format == NULL) {
        (void)fputs("<null format>\n", stderr);
        return;
    }
    va_start(arguments, format);
    (void)vfprintf(stderr, format, arguments);
    va_end(arguments);
    (void)fputc('\n', stderr);
}
