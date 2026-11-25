#ifndef MINISDK_LOG_H
#define MINISDK_LOG_H
enum minisdk_log_level { MINISDK_LOG_INFO, MINISDK_LOG_WARN, MINISDK_LOG_ERROR };
void minisdk_log(enum minisdk_log_level level, const char *format, ...);
#endif
