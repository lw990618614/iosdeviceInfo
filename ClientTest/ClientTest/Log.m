#include "Log.h"


static NSString *_logPrefix = @"";
void SetMYLogPrefix(NSString *prefix) {
    
    if (!prefix || [prefix isKindOfClass:[NSNull class]]) return;
    
    _logPrefix = prefix;
}

void MyLog(NSString *format, ...) {

	va_list valist;
    va_start(valist, format);
    NSString *formatStr = [[NSString alloc] initWithFormat:format arguments:valist];
    va_end(valist);
    
    int sub_len = 800;
    NSUInteger str_len = [formatStr length];
    for (int i = 0; i < str_len; i += sub_len) {
        NSRange range;
        if (str_len - i > sub_len) {
            range = NSMakeRange(i, sub_len);
        } else {
            range = NSMakeRange(i, str_len - i);
        }
        NSLog(@"%@%@", _logPrefix ,[formatStr substringWithRange:range]);
    }
}
