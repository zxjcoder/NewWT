//
//  ZCatchCrash.m
//  CatchCrash
//
//  Created by Daniel on 4/7/16.
//  Copyright © 2016 Z. All rights reserved.
//

#import "ZCatchCrash.h"
#import "SQLiteOper.h"
#import "AppSetting.h"
#import "Utils.h"
#import "ClassCategory.h"
#import "AESCrypt.h"

#define kCatchCrashLocalPath [[[AppSetting getDocumentPath] stringByAppendingPathComponent:@"errlog"] stringByAppendingPathExtension:@"txt"]

@interface ZCatchCrash()

@end

@implementation ZCatchCrash

void WTLiveUncaughtExceptionHandler(NSException *exception)
{
    //异常的堆栈信息
    NSArray *stackArray  = [exception callStackSymbols];
    //出现异常的原因
    NSString *errReason  = [exception reason];
    //异常名称
    NSString *errName  = [exception name];
    
    NSMutableDictionary *dicCrash = [NSMutableDictionary dictionary];
    
    NSString *model = [[UIDevice currentDevice] model];
    NSString *name = [[UIDevice currentDevice] name];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *deviceName = [[UIDevice currentDevice] getDeviceName];
    NSString *appVersion = APP_PROJECT_VERSION;
    
    [dicCrash setObject:model forKey:@"phoneModel"];
    [dicCrash setObject:name forKey:@"phoneName"];
    [dicCrash setObject:deviceName forKey:@"deviceName"];
    [dicCrash setObject:systemVersion forKey:@"systemVersion"];
    [dicCrash setObject:systemName forKey:@"systemName"];
    [dicCrash setObject:appVersion forKey:@"appVersion"];
    [dicCrash setObject:@"appStore" forKey:@"appChannel"];
    
    [dicCrash setObject:errName forKey:@"logName"];
    [dicCrash setObject:errReason forKey:@"logReason"];
    NSMutableString *errContent = [[NSMutableString alloc] init];
    for (NSString *string in stackArray) {
        [errContent appendString:string];
        [errContent appendString:@" \r\n "];
    }
    [dicCrash setObject:errContent forKey:@"logContent"];
    
    NSData *errorData = [NSJSONSerialization dataWithJSONObject:dicCrash options:NSJSONWritingPrettyPrinted error:nil];
    if (errorData) {
        NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        if (errorStr) {
            NSString *encryptParams = [AESCrypt DESEncrypt:errorStr password:kDESEncryptedDataUsingKey];
            if (encryptParams) {
                [sqlite setLocalCatchCrashWithContent:encryptParams];
            }
        }
    }
}
///设置监听遗产
+ (void)setDefaultHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSSetUncaughtExceptionHandler(&WTLiveUncaughtExceptionHandler);
    });
}
///获取日志信息
+ (NSString *)getCatchCrashErrorData
{
    NSString *contentEncrypt = [sqlite getLocalCatchCrashTop];
    NSString *content = [AESCrypt DESDecrypt:contentEncrypt password:kDESEncryptedDataUsingKey];
    return content;
}
///删除日志信息
+ (void)delCatchCrashErrorData
{
    [sqlite delLocalCatchCrash];
}

@end
