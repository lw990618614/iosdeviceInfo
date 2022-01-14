
#ifndef Log_h
#define Log_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
/* 如果没有采用C++，顺序预编译 */
extern "C" {
#endif

extern void SetMYLogPrefix(NSString *prefix);
extern void MyLog(NSString *format, ...);

#define Log(format, ...)                                                    \
do {                                                                        \
    NSString *__log_fileName = [NSString stringWithFormat:@"%s", __FILE_NAME__];  \
    __log_fileName = [__log_fileName componentsSeparatedByString:@"."].firstObject;          \
    __log_fileName = [NSString stringWithFormat:@"[%@]", __log_fileName];                    \
    NSString *__log_line = [NSString stringWithFormat:@"<%d>", __LINE__];         \
    NSString *__log_log = [NSString stringWithFormat:format, ##__VA_ARGS__];      \
    MyLog(@"%@%@ %@", __log_fileName, __log_line, __log_log);                                  \
} while(0)

#ifdef __cplusplus
    /* 如果没有采用C++，顺序预编译 */
    }
#endif

#endif /* Log_h */
