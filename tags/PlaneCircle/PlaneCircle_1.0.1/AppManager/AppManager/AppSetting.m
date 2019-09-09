//
//  AppSetting.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AppSetting.h"
#import "Utils.h"
#import "ClassCategory.h"

@implementation AppSetting

static NSMutableDictionary *dicAllSettings;
static NSMutableDictionary *dicCurrUserSettings;
static NSString *currLoginAccount;
static NSString *const SETTINGFILENAME=@"SETTING.PLIST";

+(void)load:(NSString*)loginaccount
{
    NSString *filepath = [[AppSetting getDocumentPath] stringByAppendingPathComponent:SETTINGFILENAME];
    
    if (currLoginAccount != nil)
    {
        OBJC_RELEASE(currLoginAccount);
    }
    currLoginAccount = [loginaccount copy];
    
    if (dicCurrUserSettings != nil)
    {
        OBJC_RELEASE(dicCurrUserSettings);
    }
    
    if (dicAllSettings != nil)
    {
        OBJC_RELEASE(dicAllSettings);
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        dicAllSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
    }
    
#if ! __has_feature(objc_arc)
    if (dicAllSettings == nil) dicAllSettings = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
#else
    if (dicAllSettings == nil) dicAllSettings = [NSMutableDictionary dictionaryWithCapacity:10];
#endif
    
    dicCurrUserSettings = [dicAllSettings objectForKey:loginaccount];
    if (dicCurrUserSettings == nil)
    {
        dicCurrUserSettings = [NSMutableDictionary dictionaryWithCapacity:10];
        [dicAllSettings setObject:dicCurrUserSettings forKey:loginaccount];
    }
    
#if ! __has_feature(objc_arc)
    [dicCurrUserSettings retain];
#endif
}

+(void)del:(NSString*)loginaccount
{
    [dicAllSettings removeObjectForKey:loginaccount];
    if ([loginaccount isEqualToString:dicCurrUserSettings[@"UserID"]])
    {
        [AppSetting load:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
    }
}

+(void)save
{
    NSString *filepath = [[AppSetting getDocumentPath] stringByAppendingPathComponent:SETTINGFILENAME];
    
    [dicAllSettings writeToFile:filepath atomically:YES];
}

+(NSMutableArray*)getHisLoginAccount
{
    NSMutableArray *arrX = [dicAllSettings objectForKey:@"HisLoginAccount"];
    if (arrX == nil)
    {
        //查看是否有旧版本的
        NSString *oldloginAccPath= [[self getDocumentPath] stringByAppendingPathComponent:SETTINGFILENAME];
        if([[NSFileManager defaultManager] fileExistsAtPath:oldloginAccPath])
        {
            arrX = [NSMutableArray arrayWithContentsOfFile:oldloginAccPath];
        }
        
        if (arrX == nil) arrX = [NSMutableArray array];
        [dicAllSettings setObject:arrX forKey:@"HisLoginAccount"];
    }
    
    return arrX;
}

+(NSString*)getUserSkin
{
    NSString *value = [dicCurrUserSettings objectForKey:@"UserSkin"];
    if (value == nil) value = @"Default";
    return value;
}
+(void)setUserSkin:(NSString*)value
{
    [dicCurrUserSettings setObject:value==nil?@"Default":value forKey:@"UserSkin"];
}

+(bool)getAutoLogin
{
    NSString *value = [dicCurrUserSettings objectForKey:@"AutoLogin"];
    if (value == nil) value = @"0";
    
    return [@"1" isEqualToString:value];
}
+(void)setAutoLogin:(bool)value
{
    [dicCurrUserSettings setObject:value?@"1":@"0" forKey:@"AutoLogin"];
}

+(NSString*)getUserId
{
    NSString *value = [dicCurrUserSettings objectForKey:@"UserID"];
    if (value == nil) value = currLoginAccount;
    
    return value;
}
+(void)setUserId:(NSString*)value
{
    if (![currLoginAccount isEqualToString:value])
    {
        [dicCurrUserSettings setObject:value forKey:@"UserID"];
        [dicAllSettings setObject:dicCurrUserSettings forKey:value];
        [dicAllSettings removeObjectForKey:currLoginAccount];
        OBJC_RELEASE(currLoginAccount);
        currLoginAccount = [value copy];
    }
}

+(NSString*)getUserDetauleId
{
    if (![AppSetting getAutoLogin]) {
        return kOne;
    }
    return [AppSetting getUserId];
}

+(NSString*)getUserAccount
{
    return [dicCurrUserSettings objectForKey:@"UserAccount"];;
}
+(void)setUserAccount:(NSString*)value
{
    if (value == nil) value = kEmpty;
    [dicCurrUserSettings setObject:value forKey:@"UserAccount"];
}

+(NSString*)getUserPassword
{
    return [dicCurrUserSettings objectForKey:@"UserNumber"];;
}
+(void)setUserPassword:(NSString*)value
{
    if (value == nil) value = kEmpty;
    [dicCurrUserSettings setObject:value forKey:@"UserNumber"];
}

+(void)setUserLogin:(ModelUser*)model
{
    if (model) {
        [dicCurrUserSettings setObject:[model getDictionary] forKey:@"UserLogin"];
    }
}

+(ModelUser*)getUserLogin
{
    NSDictionary *dicUser = [dicCurrUserSettings objectForKey:@"UserLogin"];
    if (dicUser) {
        return [[ModelUser alloc] initWithAuto:dicUser];
    }
    return nil;
}

+(NSString*)getDeviceName
{
    NSString *value = [dicCurrUserSettings objectForKey:@"DeviceName"];
    if (value == nil) value = [[UIDevice currentDevice] getDeviceName];
    
    return value;
}
+(void)setDeviceName:(NSString*)value
{
    if (value == nil) value = [[UIDevice currentDevice] getDeviceName];
    [dicCurrUserSettings setObject:value forKey:@"DeviceName"];
}

///获取字体大小
+(NSString*)getFontSize
{
    NSString *value = [dicCurrUserSettings objectForKey:@"FontSize"];
    if (value == nil) value = @"标准";
    
    return value;
}
///设置字体大小
+(void)setFontSize:(NSString*)value
{
    if (value == nil) value = @"标准";
    [dicCurrUserSettings setObject:value forKey:@"FontSize"];
}

+(NSString*)getUserUDID
{
    NSString *value = [dicCurrUserSettings objectForKey:@"UserIdentifier"];
    if (value == nil) value = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    return value;
}
+(void)setUserUDID:(NSString*)value
{
    if (value == nil) value = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    [dicCurrUserSettings setObject:value forKey:@"UserIdentifier"];
}

+(NSString*)getDeviceToken
{
    NSString *value = [dicCurrUserSettings objectForKey:@"DeviceToken"];
    if (value == nil) value = @"";
    
    return value;
}
+(void)setDeviceToken:(NSString*)value
{
    [dicCurrUserSettings setObject:value==nil?@"":value forKey:@"DeviceToken"];
}

+(NSString*)getDocumentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}
+(NSString*)getPersonalFilePath
{
    return [[AppSetting getDocumentPath] stringByAppendingPathComponent:[AppSetting getUserDetauleId]];
}
+(NSString*)getSkinFilePath
{
    return [[AppSetting getPersonalFilePath] stringByAppendingPathComponent:@"Skin"];
}
+(NSString*)getDataFilePath
{
    return [[AppSetting getPersonalFilePath] stringByAppendingPathComponent:@"Data"];
}
+(NSString*)getTempFilePath
{
    return [[AppSetting getPersonalFilePath] stringByAppendingPathComponent:@"Temp"];
}

+(NSString*)getLibraryCachePath
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}
+(NSString*)getProjectFilePath
{
    return [[AppSetting getLibraryCachePath] stringByAppendingPathComponent:APP_PROJECT_NAME];
}
+(NSString*)getCachesFilePath
{
    return [[AppSetting getProjectFilePath] stringByAppendingPathComponent:@"Caches"];
}
+(NSString*)getRecvFilePath
{
    return [[AppSetting getCachesFilePath] stringByAppendingPathComponent:@"Recv"];
}
+(NSString*)getAudioFilePath
{
    return [[AppSetting getCachesFilePath] stringByAppendingPathComponent:@"Audio"];
}
+(NSString*)getAnswerFilePath
{
    return [[AppSetting getCachesFilePath] stringByAppendingPathComponent:@"Answer"];
}
+(NSString*)getHeadFilePath
{
    return [[AppSetting getCachesFilePath] stringByAppendingPathComponent:@"Head"];
}
+(NSString*)getWebKitFilePath
{
    return [[AppSetting getLibraryCachePath] stringByAppendingPathComponent:@"WebKit"];
}

+(void)createFileDir
{
    [Utils createDirectory:[AppSetting getPersonalFilePath]];
    [Utils createDirectory:[AppSetting getSkinFilePath]];
    [Utils createDirectory:[AppSetting getDataFilePath]];
    [Utils createDirectory:[AppSetting getTempFilePath]];
    
    [Utils createDirectory:[AppSetting getProjectFilePath]];
    [Utils createDirectory:[AppSetting getCachesFilePath]];
    [Utils createDirectory:[AppSetting getRecvFilePath]];
    [Utils createDirectory:[AppSetting getHeadFilePath]];
    [Utils createDirectory:[AppSetting getAudioFilePath]];
    [Utils createDirectory:[AppSetting getAnswerFilePath]];
    
    [Utils createDirectory:[AppSetting getWebKitFilePath]];
}

+(void)removeFileDir
{
    [Utils deleteDirectory:[AppSetting getDataFilePath]];
    [Utils deleteDirectory:[AppSetting getTempFilePath]];
    
    [Utils deleteDirectory:[AppSetting getCachesFilePath]];
    
    [Utils deleteDirectory:[AppSetting getWebKitFilePath]];
    
    [self createFileDir];
}

@end
