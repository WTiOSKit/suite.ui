//
//  TestUtil.m
// fallen.ink
//
//  Created by Ben on 6/10/14.
//  Copyright (c) 2014 QQing. All rights reserved.
//

#import "TestUtil.h"

NSString *const kCommonLogKey = @"Common";
static NSString *const kTestDebugLogFileName = @"QQingTestDebugLog.plist";

NSMutableDictionary *g_testDebugLogDict;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
// 串行队列解决g_testDebugLogDict不是线程安全问题
static dispatch_queue_t writeLogOperationQueue() {
    static dispatch_queue_t s_writeLogOperationQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_writeLogOperationQueue = dispatch_queue_create("com.qq.student.writeLogQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_set_target_queue(priority, s_writeLogOperationQueue);
    });
    
    return s_writeLogOperationQueue;
}
#pragma clang diagnostic pop

@implementation TestUtil

+ (void)initialize
{
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [pathes[0] stringByAppendingPathComponent:kTestDebugLogFileName];
    NSDictionary *dictFromFile = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    g_testDebugLogDict = [[NSMutableDictionary alloc] init];
    for (NSString *logKey in [dictFromFile allKeys]) {
        NSMutableString *logString = [NSMutableString stringWithString:[dictFromFile objectForKey:logKey]];
        [g_testDebugLogDict setObject:logString forKey:logKey];
    }
}

+ (NSData *)getLocalDataFromFileForDeveloper:(DEVELOPER_NAME)devName
{
    NSString *filePath = [TestUtil jsonFilePathForDeveloper:devName];
    return [NSData dataWithContentsOfFile:filePath];
}

+ (NSString *)getLocalDataStringFromFileForDeveloper:(DEVELOPER_NAME)devName
{
    NSString *filePath = [TestUtil jsonFilePathForDeveloper:devName];
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

+ (id)getLocalDataObjectFromFileForDeveloper:(DEVELOPER_NAME)devName
{
    NSString *filePath = [TestUtil jsonFilePathForDeveloper:devName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    id content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return content;
}

+ (void)appendLogForModule:(NSString *)module withArgs:(NSString *)fmt, ...
{
#ifdef DEBUG
    @try {
        va_list args;
        va_start(args, fmt);
        NSString *debugText = [[NSString alloc] initWithFormat:fmt arguments:args];
        va_end(args);
        
        dispatch_async(writeLogOperationQueue(), ^{
            if (!g_testDebugLogDict) {
                g_testDebugLogDict = [[NSMutableDictionary alloc] init];
            }
            
            NSMutableString *logString = [g_testDebugLogDict objectForKey:module];
            if (!logString) {
                logString = [[NSMutableString alloc] init];
                [g_testDebugLogDict setObject:logString forKey:module];
            }
            
            [logString appendString:[NSString stringWithFormat:@"%@\n\n", debugText]];
        });
    }
    @catch (id e) {
        // Ignored
    }
#endif
}

+ (NSDictionary *)currentTestDebugLogDict
{
    return g_testDebugLogDict;
}

+ (void)saveTestDebugLogDictToFile
{
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [pathes[0] stringByAppendingPathComponent:kTestDebugLogFileName];
    
    [g_testDebugLogDict writeToFile:filePath atomically:YES];
}

+ (void)deleteTestDebugLogDictFile
{
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [pathes[0] stringByAppendingPathComponent:kTestDebugLogFileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

#pragma mark - Private Methods

+ (NSString *)jsonFilePathForDeveloper:(DEVELOPER_NAME)devName
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath;
    switch (devName) {
        case SHENXUECHENG: {
            filePath = [mainBundle pathForResource:@"LocalMockData_ShenXueCheng" ofType:@"json"];
        }
            break;
            
        case LIJIE: {
            filePath = [mainBundle pathForResource:@"LocalMockData_LiJie" ofType:@"json"];
        }
            break;
            
        case ANBO: {
            filePath = [mainBundle pathForResource:@"LocalMockData_AnBo" ofType:@"json"];
        }
            break;
            
        case TAOCHENG: {
            filePath = [mainBundle pathForResource:@"LocalMockData_TaoCheng" ofType:@"json"];
        }
            break;
            
        case WANGTAO: {
            filePath = [mainBundle pathForResource:@"LocalMockData_WangTao" ofType:@"json"];
        }
            break;
        
        case XIEXIAOFENG: {
            filePath = [mainBundle pathForResource:@"LocalMockData_XieXiaoFeng" ofType:@"json"];
        }
            break;
            
        case GUOXIAOQIAN: {
            filePath = [mainBundle pathForResource:@"LocalMockData_GuoXiaoQian" ofType:@"json"];
        }
            break;

        case XIAXUQIANG:
        default: {
            filePath = [mainBundle pathForResource:@"LocalMockData_XiaXuQiang" ofType:@"json"];
            break;
        }
    }
    
    return filePath;
}

@end
