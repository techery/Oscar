//
//  OSLog.h
//  Pods
//
//  Created by Anastasiya Gorban on 2/9/16.
//
//

#ifndef OS_LOGGING_ENABLED
#define OS_LOGGING_ENABLED 1
#endif

#ifndef OS_LOGGING_LEVEL_VERBOSE
#define OS_LOGGING_LEVEL_VERBOSE 0
#endif

#ifndef OS_LOGGING_LEVEL_ERROR
#define OS_LOGGING_LEVEL_ERROR 1
#endif

#if !(defined(OS_LOGGING_ENABLED) && OS_LOGGING_ENABLED)
#undef OS_LOGGING_LEVEL_VERBOSE
#undef OS_LOGGING_LEVEL_ERROR
#endif

#if OS_LOGGING_LEVEL_VERBOSE
#define OSLogVerbose(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define OSLogVerbose(s, ...)
#endif

#if OS_LOGGING_LEVEL_ERROR
#define OSLogError(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define OSLogError(s, ...)
#endif
