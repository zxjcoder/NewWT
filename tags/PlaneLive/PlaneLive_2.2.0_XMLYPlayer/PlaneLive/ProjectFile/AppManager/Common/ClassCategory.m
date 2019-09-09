//
//  ClassCategory.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ClassCategory.h"
#import "RegexKeyManager.h"
#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>
#import "sys/sysctl.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "Utils.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation UINavigationBar (ClassCategory)

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    self.userInteractionEnabled = [self pointInside:point withEvent:event];
    return [super hitTest:point withEvent:event];
}

@end

@implementation UIDevice (ClassCategory)

-(NSString*)getMacAddress
{
    @try {
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error/n");
            return nil;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1/n");
            return nil;
        }
        
        if ((buf = malloc(len)) == NULL) {
            printf("Could not allocate memory. error!/n");
            return nil;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 2");
            return nil;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        
        free(buf);
        
        return [outstring uppercaseString];
    } @catch (NSException *exception) {}
    return nil;
}

-(NSString*)getIPAddress
{
    NSString *address = @"192.168.1.1";
    @try {
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while (temp_addr != NULL) {
                if( temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        
        // Free memory
        freeifaddrs(interfaces);
    }
    @catch (NSException *exception) {}
    return address;
}

-(NSString*)getResolution
{
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    CGFloat scale = [UIScreen mainScreen].scale;
    
    return [NSString stringWithFormat:@"%.lf*%.lf", mainScreen.size.width * scale, mainScreen.size.height * scale];
}

-(NSString*)getLanguage
{
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    if (languages.count > 0) {
        return languages[0];
    }
    return nil;
}

-(NSString*)uniqueDeviceIdentifier
{
    NSString *uuid =  [[NSUserDefaults standardUserDefaults] objectForKey:@"comwutonguuid"];
    if (!uuid) {
        uuid = [Utils stringMD5:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"comwutonguuid"];
    }
    return uuid;
}

-(NSString*)getDeviceName
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
//    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
//    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
//    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
//    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
//    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
//    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
//    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
//    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
//    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
//    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (Global)";
//    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
//    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (Global)";
//    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
//    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
//    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S Plus";
//    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6S";
//    // iPod
//    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
//    // iPad
//    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
//    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
//    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
//    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
//    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
//    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
//    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
//    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
//    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
//    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
//    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
//    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
//    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
//    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
//    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (China)";
//    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
//    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
//    // iPad mini
//    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2 (WiFi)";
//    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2 (Cellular)";
//    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad mini 2 (China)";
//    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad mini 3 (WiFi)";
//    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad mini 3 (Cellular)";
//    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad mini 3 (China)";
//    // Simulator
//    if ([platform isEqualToString:@"i386"])         return @"AppleSimulator32";
//    if ([platform isEqualToString:@"x86_64"])       return @"AppleSimulator64";
    return platform;
}

@end

@implementation NSDate (ClassCategory)

-(NSString*)toString
{
    return [self toStringWithFormat:kFormat_Date_All];
}

-(NSString*)toStringWithFormat:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//UTC或GMT
    [formatter setTimeZone:sourceTimeZone];
    
    NSString *re = [formatter stringFromDate:self];
    OBJC_RELEASE(formatter);
    return re;
}
///获取农历日期
-(NSString*)toChineseCalendar
{
    /*
     NSArray *chineseYears=[NSArray arrayWithObjects:
     @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
     @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
     @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
     @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
     @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
     @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];*/
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    
    /*NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];*/
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@",m_str,d_str];
    
    return chineseCal_str;
}
///获取星期几
-(NSString*)toWeekDay
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:self];
    NSString *weak = @"星期日";
    switch ([comps weekday]) {
        case 1: weak = @"星期日"; break;
        case 2: weak = @"星期一"; break;
        case 3: weak = @"星期二"; break;
        case 4: weak = @"星期三"; break;
        case 5: weak = @"星期四"; break;
        case 6: weak = @"星期五"; break;
        case 7: weak = @"星期六"; break;
    }
    return weak;
}
///考虑时区，获取准备的系统时间方法
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//UTC或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
//将时间点转化成日历形式
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate * destinationDateNow = self;
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
//获取时间段
-(NSString *)toTimeSlot
{
    NSDate * currentDate = self;
    if ([currentDate compare:[self getCustomDateWithHour:0]] == NSOrderedDescending
        && [currentDate compare:[self getCustomDateWithHour:9]] == NSOrderedAscending) {
        return @"早上好";
    } else if ([currentDate compare:[self getCustomDateWithHour:9]] == NSOrderedDescending
               && [currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedAscending) {
        return @"上午好";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedDescending
             && [currentDate compare:[self getCustomDateWithHour:13]] == NSOrderedAscending) {
        return @"中午好";
    } else if ([currentDate compare:[self getCustomDateWithHour:13]] == NSOrderedDescending
               && [currentDate compare:[self getCustomDateWithHour:18]] == NSOrderedAscending) {
        return @"下午好";
    } else {
        return @"晚上好";
    }
}

@end

@implementation NSString (ClassCategory)

-(BOOL)isUrl
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_Url];
    return [regex evaluateWithObject:self];
}

-(BOOL)isIdentityCard
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_IdentityCard];
    return [regex evaluateWithObject:self];
}

-(BOOL)isCode
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_Code];
    return [regex evaluateWithObject:self];
}

-(BOOL)isEmail
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_Email];
    return [regex evaluateWithObject:self];
}

-(BOOL)isMobile
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_Mobile];
    return [regex evaluateWithObject:self];
}

-(BOOL)isPhone
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_Phone];
    return [regex evaluateWithObject:self];
}

-(BOOL)isCarNo
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_CarNo];
    return [regex evaluateWithObject:self];
}

-(BOOL)isPassword
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_Password];
    return [regex evaluateWithObject:self];
}

-(BOOL)isNickName
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_NickName];
    return [regex evaluateWithObject:self];
}

-(BOOL)isRealName
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_RealName];
    return [regex evaluateWithObject:self];
}

-(BOOL)isQualifications
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_Qualifications];
    return [regex evaluateWithObject:self];
}

-(BOOL)isBankName
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_BankName];
    return [regex evaluateWithObject:self];
}

-(BOOL)isBankNumber
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_BankNumber];
    return [regex evaluateWithObject:self];
}

-(BOOL)isChinese
{
    for(int i=0; i< [self length];i++) {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
//    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_Chinese];
//    return [regex evaluateWithObject:self];
}

-(BOOL)isQQ
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPredicate_QQ];
    return [regex evaluateWithObject:self];
}

-(BOOL)existChinese
{
    BOOL hasUTF8 = NO;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 127)
        {
            hasUTF8 = YES;
            break;
        }
    }
    return hasUTF8;
}

-(BOOL)isEmpty
{
    if (self == nil || [self isKindOfClass:[NSNull class]] || self.length == 0) {
        return YES;
    }
    return NO;
}

-(BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0)
{
    if (aString==nil||aString.length==0) {
        return NO;
    }
    if ([self rangeOfString:aString].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmoji
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }
    return returnValue;
}

- (BOOL)isIncludingEmoji
{
    BOOL __block result = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring isEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    
    return result;
}

-(instancetype)removedEmojiString
{
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring isEmoji])? @"": substring];
                          }];  
    
    return buffer;  
}

-(NSString*)imgReplacing
{
    if (self.length > 0) {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>" options:0 error:nil];
        NSString *content = [regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:kEmpty];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        return content.toTrim;
    }
    return self;
}

-(NSString*)encodingUTF8
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self, nil, (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8);
}

-(NSDate*)toDate
{
    return [self toDateWithFormat:kFormat_Date_All];
}

-(NSDate*)toDateWithFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    [dateFormatter setDateFormat:format];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//UTC或GMT
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDate *re = [dateFormatter dateFromString:self];
    OBJC_RELEASE(dateFormatter);
    
    return re;
}

-(NSString*)toTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(NSArray*)toArray
{
    NSArray *array = [self componentsSeparatedByString:@","];
    if (array) {
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

-(NSString*)toString
{
    NSString *str = self;
    str=str==nil||[str isKindOfClass:[NSNull class]]?kEmpty:str;
    return [NSString stringWithFormat:@"%@", str];
}

-(NSString*)toURLEncode
{
    NSArray *escapeChars = @[
                             @";",
                             @"/",
                             @"?",
                             @":",
                             @"@",
                             @"&",
                             @"=",
                             @"+",
                             @"$",
                             @",",
                             @"!",
                             @"'",
                             @"(",
                             @")",
                             @"*"
                             ];
    
    NSArray *replaceChars = @[
                              @"%3B",
                              @"%2F",
                              @"%3F",
                              @"%3A",
                              @"%40",
                              @"%26",
                              @"%3D",
                              @"%2B",
                              @"%24",
                              @"%2C",
                              @"%21",
                              @"%27",
                              @"%28",
                              @"%29",
                              @"%2A"
                              ];
    
    NSUInteger len = [escapeChars count];
    
    NSMutableString *temp =
    [[self stringByAddingPercentEscapesUsingEncoding:
      NSUTF8StringEncoding] mutableCopy];
    
    for (int i = 0; i < len; i++) {
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *outStr = [NSString stringWithString:temp];
    
    return outStr;
}

-(NSString*)formatWithAppendString:(NSString*)str, ... NS_FORMAT_FUNCTION(1,2)
{
    NSMutableArray *valueArray = [NSMutableArray array];
    id eachItem;
    va_list argumentList;
    if (str)
    {
        va_start(argumentList, str);
        while((eachItem = va_arg(argumentList, id)))
        {
            [valueArray addObject: eachItem];
        }
        va_end(argumentList);
    }
    return [NSString stringWithFormat:[self stringByAppendingString:str], valueArray];
}

+(NSString*)stringFormatWithTimeStamp:(NSTimeInterval)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSInteger i= [self stringFormatWithDate:date];
    if (i==1) {
        return [NSString stringWithFormat:@"%@ %@", kFormat_Date_Day, [date toStringWithFormat:kFormat_Date_Hour]];
    } else if (i==2) {
        return [NSString stringWithFormat:@"%@ %@", kFormat_Date_Yesterday, [date toStringWithFormat:kFormat_Date_Hour]];
    } else if (i==3){
        return [date toStringWithFormat:kFormat_Date_Time];
    } else {
        return [date toStringWithFormat:kFormat_Date_Time];
    }
}

+(NSInteger)stringFormatWithDate:(NSDate *)oneday
{
    NSDate * today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = oneday;
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString]) { //今天
        return 1;
    } else if ([refDateString isEqualToString:yesterdayString]) { //昨天
        return 2;
    } else { //以前
        return 3;
    }
}

+(NSString*)stringWithTimeStamp:(NSTimeInterval)timeStamp
{
    return [self stringWithTimeStamp:timeStamp format:kFormat_Date_All];
}

+(NSString*)stringWithTimeStamp:(NSTimeInterval)timeStamp format:(NSString*)format
{
    if (timeStamp <= 0) return kEmpty;
    
    NSString *str = [[NSDate dateWithTimeIntervalSince1970:timeStamp] toStringWithFormat:format];
    
    return str;
}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end

@implementation NSNumber (ClassCategory)

-(NSString*)toString
{
    return [NSString stringWithFormat:@"%ld", (long)[self integerValue]];
}

@end

@implementation UIView (ClassCategory)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)ttx
{
    return self.transform.tx;
}

-(void)setTtx:(CGFloat)ttx
{
    CGAffineTransform  transform=self.transform;
    transform.tx=ttx;
    self.transform=transform;
}

-(CGFloat)tty
{
    return self.transform.ty;
}

-(void)setTty:(CGFloat)tty
{
    CGAffineTransform  transform=self.transform;
    transform.ty=tty;
    self.transform=transform;
}

- (void)setViewRound
{
    [self.layer setMasksToBounds:YES];
    [self setViewRound:self.frame.size.width/2.0 borderWidth:kVIEW_BORDER_SIZE borderColor:RGBCOLOR(242, 242, 242)];
}

- (void)setViewRoundNoBorder
{
    [self.layer setMasksToBounds:YES];
    [self setViewRound:self.frame.size.width/2.0 borderWidth:0 borderColor:CLEARCOLOR];
}

- (void)setViewRoundWithRound
{
    [self setViewRound:kVIEW_ROUND_SIZE borderWidth:kVIEW_BORDER_SIZE borderColor:MAINCOLOR];
}

- (void)setViewRoundWithNoBorder
{
    [self.layer setMasksToBounds:YES];
    [self setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
}

- (void)setViewRoundWithButton
{
    [self.layer setMasksToBounds:YES];
    [self setViewRound:10 borderWidth:kVIEW_BORDER_SIZE borderColor:MAINCOLOR];
}

- (void)setViewRoundWithColor:(UIColor *)color
{
    [self.layer setMasksToBounds:YES];
    [self setViewRound:self.frame.size.width/2.0 borderWidth:1 borderColor:color];
}

- (void)setViewRound:(float)radius borderWidth:(float)width borderColor:(UIColor*)color
{
    [self.layer setCornerRadius:radius];
    
    [self.layer setBorderWidth:width];
    
    [self.layer setBorderColor:color.CGColor];
}

//隐藏View上的键盘
- (void)hideKeyboard
{
    [[self getTextFieldWithFocus] resignFirstResponder];
}

//获取当前UIVew中,获得输入焦点的UITextField
-(UITextField *)getTextFieldWithFocus
{
    UITextField *result = nil;
    NSArray *array = [self FilterSubView:[UITextField class]];
    for(UITextField *sub in array){
        if ([sub isFirstResponder]) {
            result = sub;
            break;
        }
    }
    return result;
}

//获取当前view下的所有指定subview,
- (NSArray *)FilterSubView:(Class)findClass
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    [self recuGetSubView:findClass array:array];
    return array;
}

//递归获取当前view下的指定subview
- (void)recuGetSubView:(Class)findClass array:(NSMutableArray *)array
{
    //isKindOfClass: 类或子类;isMemberOfClass: 只是本类
    if([self isKindOfClass:findClass]) {
        [array addObject:self];
    }else if ([[self subviews] count] > 0){
        for(UIView *sub in [self subviews]){
            [sub recuGetSubView:findClass array:array];//递归当前view的所有子view
        }
    }
}

@end


@implementation UILabel (ClassCategory)

- (CGFloat)getLabelHeightWithMinHeight:(CGFloat)minheight
{
    CGRect fontFrame = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: self.font}
                                               context:nil];
    CGFloat h= fontFrame.size.height<=minheight?minheight:fontFrame.size.height+1;
    
    return h;
}

- (CGFloat)getLabelWidthWithMinWidth:(CGFloat)minwidth
{
    CGRect fontFrame = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: self.font}
                                               context:nil];
    CGFloat w= fontFrame.size.width<=minwidth?minwidth:fontFrame.size.width+1;
    
    return w;
}

- (void)setLabelColorWithRange:(NSRange)range color:(UIColor*)color
{
    if (self.text) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
        [str addAttribute:NSForegroundColorAttributeName value:color range:range];
        self.attributedText = str;
    }
}

- (void)setLabelFontWithRange:(NSRange)range font:(UIFont*)font
{
    if (self.text) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
        [str addAttribute:NSFontAttributeName value:font range:range];
        self.attributedText = str;
    }
}

@end

@implementation NSArray (ClassCategory)

-(NSString*)toString
{
    return [self componentsJoinedByString:@","];
}

@end

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (ClassCategory)

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name leftScale:0.5 topScale:0.5];
}

+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale
{
    UIImage *image = [self imageNamed:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftScale topCapHeight:image.size.height * topScale];
}

+(instancetype)circleImageWithUIImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor  {
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (UIImage *)changeImageColorWithColor:(UIColor *)color
{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
-(UIImage *)drawRectWithRoundedCorner:(float)radius sizetoFit:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

@end

@implementation UIImageView (ClassCategory)

- (void)setImageViewRound
{
    [self setImageViewRound:self.frame.size.width/2.0 borderWidth:1.0 borderColor:WHITECOLOR];
}

- (void)setImageViewRoundWithBorderZero
{
    [self setImageViewRound:kVIEW_ROUND_SIZE borderWidth:0.0 borderColor:CLEARCOLOR];
}

- (void)setImageViewRoundWithBorderDefault
{
    [self setImageViewRound:10 borderWidth:1.0 borderColor:RGBCOLOR(220, 220, 220)];
}

- (void)setImageViewRound:(float)radius borderWidth:(float)width borderColor:(UIColor*)color
{
    [self setBackgroundColor:CLEARCOLOR];
    [self.layer setCornerRadius:radius];
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:color.CGColor];
    [self.layer setMasksToBounds:YES];
}
///获取1个点高度的实线分割线
+(UIImageView *)getDLineView
{
    UIImageView *viewLine = [[UIImageView alloc] init];
    [viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    return viewLine;
}
///获取5个点高度的实线分割线
+(UIImageView *)getSLineView
{
    UIImageView *viewLine = [[UIImageView alloc] init];
    [viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    return viewLine;
}
///获取1个点高度的虚线分割线
+(UIImageView *)getTLineView
{
    UIImageView *viewLine = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"image_line"]];
    [viewLine setBackgroundColor:CLEARCOLOR];
    return viewLine;
}

@end


@implementation UITextField (ExtentRange)

- (void)setReplaceRange
{
    NSRange range = NSMakeRange(0, self.text.length);
    
    UITextPosition* beginning = self.beginningOfDocument;
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* replaceRange = [self textRangeFromPosition:beginning toPosition:endPosition];
    
    [self replaceRange:replaceRange withText:self.text];
}

@end




