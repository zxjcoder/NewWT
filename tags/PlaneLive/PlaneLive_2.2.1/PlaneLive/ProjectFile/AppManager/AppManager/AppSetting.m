//
//  AppSetting.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AppSetting.h"
#import "KeyChain.h"
#import "Utils.h"
#import "ClassCategory.h"

@implementation AppSetting

static NSMutableDictionary *dicCurrUserSettings;

UIKIT_EXTERN NSString *const SETTINGFILENAME;
NSString *const SETTINGFILENAME=@"SETTING.PLIST";
UIKIT_EXTERN NSString *const PLAYTIMEFILENAME;
NSString *const PLAYTIMEFILENAME=@"PLAYTIME.PLIST";

#define kKeyChainHisLoginUserKey @"kKeyChainHisLoginUserKey"

+(void)load
{
    NSString *filepath = [[AppSetting getDocumentPath] stringByAppendingPathComponent:SETTINGFILENAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSDictionary *dicAllSettings = [[NSDictionary alloc] initWithContentsOfFile:filepath];
        if (dicAllSettings && [dicAllSettings isKindOfClass:[NSDictionary class]]) {
            NSArray *arrUserIds = [dicAllSettings objectForKey:@"HisLoginAccount"];
            if (arrUserIds && [arrUserIds isKindOfClass:[NSArray class]] && arrUserIds.count > 0) {
                for (NSString *userId in arrUserIds) {
                    NSDictionary *dicCurrUser = [dicAllSettings objectForKey:userId];
                    if (dicCurrUser && [dicCurrUser isKindOfClass:[NSDictionary class]]) {
                        NSString *isAutoLogin = [dicCurrUser objectForKey:@"AutoLogin"];
                        if (isAutoLogin && [isAutoLogin boolValue]) {
                            [dicCurrUser setValue:userId forKey:@"UserID"];
                            dicCurrUserSettings = [NSMutableDictionary dictionaryWithDictionary:dicCurrUser];
                            [AppSetting save];
                            break;
                        }
                    }
                }
            }
        }
        [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
    }
    OBJC_RELEASE(dicCurrUserSettings);
    dicCurrUserSettings = (NSMutableDictionary*)[KeyChain load:kKeyChainHisLoginUserKey];
    if (dicCurrUserSettings == nil) {
        dicCurrUserSettings = [NSMutableDictionary dictionary];
    }
    GBLog(@"CurrUserSettingsDictionary: %@", dicCurrUserSettings);
}
+(void)del
{
    [KeyChain delete:kKeyChainHisLoginUserKey];
}
+(void)save
{
    if (dicCurrUserSettings) {
        NSTimeInterval loginTime = [NSDate timeIntervalSinceReferenceDate];
        [dicCurrUserSettings setObject:[NSString stringWithFormat:@"%ld", (long)loginTime] forKey:@"LoginTime"];
        [KeyChain save:kKeyChainHisLoginUserKey data:dicCurrUserSettings];
    }
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
    
    return [value boolValue];
}
+(void)setAutoLogin:(bool)value
{
    [dicCurrUserSettings setObject:[NSNumber numberWithBool:value] forKey:@"AutoLogin"];
}

+(NSString*)getUserId
{
    NSString *value = [dicCurrUserSettings objectForKey:@"UserID"];
    if (value == nil) value = kUserDefaultId;
    
    return value;
}
+(void)setUserId:(NSString*)value
{
    if (value == nil) value = kUserDefaultId;
    [dicCurrUserSettings setObject:value forKey:@"UserID"];
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
///获取字体大小
+(NSString*)getFontSize
{
    NSString *value = [dicCurrUserSettings objectForKey:@"FontSize"];
    if (value == nil || value.length == 0) value = @"16";
    
    return value;
}
///设置字体大小
+(void)setFontSize:(NSString*)value
{
    if (value == nil || value.length == 0) value = @"16";
    [dicCurrUserSettings setObject:value forKey:@"FontSize"];
}
+(CGFloat)getRate
{
    NSString *value = [dicCurrUserSettings objectForKey:@"Rate"];
    if (value == nil || value.length == 0) value = @"1";
    
    return [value floatValue];
}
+(void)setRate:(CGFloat)value
{
    NSString *strValue = [NSString stringWithFormat:@"%lf", value];
    [dicCurrUserSettings setObject:strValue forKey:@"Rate"];
}

///获取Bugout开关
+(bool)getBugoutOn
{
    NSString *value = [dicCurrUserSettings objectForKey:@"BugoutOn"];
    if (value == nil) value = @"1";
    
    return [value boolValue];
}
///设置Bugout开关
+(void)setBugoutOn:(bool)value
{
    NSString *strValue = [NSString stringWithFormat:@"%d", value];
    [dicCurrUserSettings setObject:strValue forKey:@"BugoutOn"];
}

+(NSString*)getDocumentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}
+(NSString*)getPlayTimeFilePath
{
    return [[AppSetting getDocumentPath] stringByAppendingPathComponent:PLAYTIMEFILENAME];
}
+(NSString*)getPersonalFilePath
{
    return [[AppSetting getDocumentPath] stringByAppendingPathComponent:kLoginUserId];
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
    return [[AppSetting getCachesFilePath] stringByAppendingPathComponent:@"Temp"];
}

+(NSString*)getLibraryCachePath
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}
+(NSString*)getProjectFilePath
{
    return [[AppSetting getLibraryCachePath] stringByAppendingPathComponent:APP_PROJECT_IDENTIFIER];
}
+(NSString*)getCachesFilePath
{
    return [[AppSetting getProjectFilePath] stringByAppendingPathComponent:@"Caches"];
}
+(NSString*)getOfficeFilePath
{
    return [[AppSetting getCachesFilePath] stringByAppendingPathComponent:@"Office"];
}
+(NSString*)getAudioFilePath
{
    return [[AppSetting getCachesFilePath] stringByAppendingPathComponent:@"Audio"];
}
+(NSString*)getAnswerFilePath
{
    return [[AppSetting getCachesFilePath] stringByAppendingPathComponent:@"Answer"];
}
+(NSString*)getWebKitFilePath
{
    return [[AppSetting getLibraryCachePath] stringByAppendingPathComponent:@"WebKit"];
}
+(NSString*)getPictureFilePath
{
    return  [[[AppSetting getLibraryCachePath] stringByAppendingPathComponent:@"default"] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
}

+(void)createFileDir
{
    [Utils createDirectory:[AppSetting getPersonalFilePath]];
    [Utils createDirectory:[AppSetting getSkinFilePath]];
    [Utils createDirectory:[AppSetting getDataFilePath]];
    
    [Utils createDirectory:[AppSetting getTempFilePath]];
    
    [Utils createDirectory:[AppSetting getProjectFilePath]];
    [Utils createDirectory:[AppSetting getCachesFilePath]];
    [Utils createDirectory:[AppSetting getOfficeFilePath]];
    [Utils createDirectory:[AppSetting getAudioFilePath]];
    [Utils createDirectory:[AppSetting getAnswerFilePath]];
    
    [Utils createDirectory:[AppSetting getWebKitFilePath]];
    
    /*
    NSDictionary *dicAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                              forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:dicAttributes
                                     ofItemAtPath:[AppSetting getDocumentPath]
                                            error:nil];
     */
}

+(void)removeFileDir
{
    [Utils deleteDirectory:[AppSetting getDataFilePath]];
    [Utils deleteDirectory:[AppSetting getPictureFilePath]];
    [Utils deleteDirectory:[AppSetting getOfficeFilePath]];
    [Utils deleteDirectory:[AppSetting getTempFilePath]];
    [Utils deleteDirectory:[AppSetting getAnswerFilePath]];
    [Utils deleteDirectory:[AppSetting getWebKitFilePath]];
    
    [self createFileDir];
}

+ (void)cancelMemory {
    [dicCurrUserSettings removeAllObjects];
    dicCurrUserSettings = nil;
}

@end
