#include "minisdk/string.h"
#include <ctype.h>
#include <string.h>

size_t minisdk_strnlen(const char *text, size_t max_length)
{
    size_t length = 0U;
    if (text == NULL) return 0U;
    while (length < max_length && text[length] != '\0') ++length;
    return length;
}

int minisdk_streq(const char *left, const char *right)
{
    if (left == NULL || right == NULL) return left == right;
    return strcmp(left, right) == 0;
}

void minisdk_strtrim(char *text)
{
    size_t length;
    size_t start = 0U;
    if (text == NULL) return;
    length = strlen(text);
    while (start < length && isspace((unsigned char)text[start]) != 0) ++start;
    while (length > start && isspace((unsigned char)text[length - 1U]) != 0) --length;
    if (start > 0U) memmove(text, text + start, length - start);
    text[length - start] = '\0';
}
