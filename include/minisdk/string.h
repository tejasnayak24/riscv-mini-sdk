#ifndef MINISDK_STRING_H
#define MINISDK_STRING_H
#include <stddef.h>
size_t minisdk_strnlen(const char *text, size_t max_length);
int minisdk_streq(const char *left, const char *right);
void minisdk_strtrim(char *text);
#endif
