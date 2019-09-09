//
//  Utils.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "Utils.h"
#import "ClassCategory.h"
#import <CoreImage/CoreImage.h>
#import <AudioToolbox/AudioToolbox.h>
#import "VserionManager.h"

#import <ShareSDK/ShareSDK.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wformat"

@implementation Utils

///获取分割线
+(UIImageView *)getLineView
{
    UIImageView *viewLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    return viewLine;
}

///获取小图片地址
+(NSString *)getMinPicture:(NSString *)imagePath
{
    if (imagePath == nil || imagePath.length == 0) {
        return imagePath;
    }
    NSString *imageUrl = [imagePath stringByDeletingPathExtension];
    imageUrl = [NSString stringWithFormat:@"%@_50x50.%@",imageUrl,[imagePath pathExtension]];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:imageUrl]]) {
        imageUrl = imagePath;
    }
    return imageUrl;
}
///是否是自己
+(BOOL)isMyUserId:(NSString *)userId
{
    if (userId && [userId isEqualToString:[AppSetting getUserId]]) {
        return YES;
    }
    return NO;
}

///判断微信是否安装
+(BOOL)isWXAppInstalled
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        return YES;
    }
    return NO;
}
///判断QQ是否安装
+(BOOL)isQQAppInstalled
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if ([QQApiInterface isQQInstalled]) {
        return YES;
    }
    return NO;
}

///根据邮箱或者手机号处理****
+(NSString *)getStringStarWithStr:(NSString *)str
{
    NSString *nickName = str;
    if ([nickName isEmail]) {
        NSArray *arrNickName = [nickName componentsSeparatedByString:@"@"];
        if (arrNickName.count == 2) {
            NSString *account = arrNickName.firstObject;
            account = [NSString stringWithFormat:@"%@****%@",[account substringToIndex:1],[account substringFromIndex:account.length-1]];
            nickName = [account stringByAppendingString:[NSString stringWithFormat:@"@%@",arrNickName.lastObject]];
        }
    } else if ([nickName isMobile]) {
        NSString *account = nickName;
        account = [NSString stringWithFormat:@"%@****%@",[account substringToIndex:3],[account substringFromIndex:account.length-4]];
        nickName = account;
    }
    return nickName;
}

//传入 秒  得到 xx:xx:xx
+(NSString *)getHHMMSSFromSS:(NSString *)totalTime
{
    if (totalTime && ![totalTime isKindOfClass:[NSNull class]]) {
        NSInteger seconds = [totalTime integerValue];
        
        //format of hour
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
        //format of time
        NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        
        return format_time;
    }
    return @"00:00:00";
}

//传入 秒  得到 xx:xx:xx
+(NSString *)getHHMMSSFromSSTime:(NSTimeInterval)totalTime
{
    NSInteger seconds = totalTime;
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

//传入 秒  得到  xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime
{
    if (totalTime && ![totalTime isKindOfClass:[NSNull class]]) {
        NSInteger seconds = [totalTime integerValue];
        
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
        //format of time
        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        
        return format_time;
    }
    return @"00:00";
}

+(void)createDirectory:(NSString *)dirname
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirname]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirname withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+(void)deleteDirectory:(NSString *)dirname
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirname]) {
        [[NSFileManager defaultManager] removeItemAtPath:dirname error:nil];
    }
}

+(NSData *)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || [aPath isEmpty])
        return nil;
    NSData *imageData = nil;
    @try
    {
        imageData = UIImageJPEGRepresentation(image, 0.1);
        
//        NSString *ext = [aPath pathExtension];
//        if ([[ext uppercaseString] isEqualToString:@"PNG"]) {
//            imageData = UIImagePNGRepresentation(image);
//        } else {
//            imageData = UIImageJPEGRepresentation(image, 0.5);
//        }
        if ((imageData == nil) || ([imageData length] <= 0))
            return nil;
        [imageData writeToFile:aPath atomically:YES];
    }
    @catch (NSException *e) {
        imageData = nil;
    }
    return imageData;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
///图片添加模糊度
+ (UIImage *)blurryImage:(UIImage *)image size:(CGSize)size withBlurLevel:(CGFloat)blur
{
    //创建CIContext对象
    CIContext * context = [CIContext contextWithOptions:nil];
    //获取图片
    CIImage *ciimg = [CIImage imageWithCGImage:[image CGImage]];
    //创建CIFilter
    CIFilter * gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    //设置滤镜输入参数
    [gaussianBlur setValue:ciimg forKey:@"inputImage"];
    //设置模糊参数
    [gaussianBlur setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    //得到处理后的图片
    CIImage* resultImage = [gaussianBlur valueForKey:@"outputImage"];
    CGImageRef imageRef = [context createCGImage:resultImage fromRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * imge = [[UIImage alloc]initWithCGImage:imageRef];
    CFRelease(imageRef);
    
    return imge;
}
///转换成指定大小的图片
+ (UIImage *)resizedTransformtoSize:(CGSize)Newsize image:(UIImage *)image
{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(Newsize);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, Newsize.width, Newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}

+(int)getSNSInt:(NSString *)str
{
    int result = 0;
    if (str != nil && ![str isKindOfClass:[NSNull class]]) {
        result = [str intValue];
    }
    return result;
}
+(double)getSNSDouble:(NSString *)str
{
    double result = 0;
    if (str != nil && ![str isKindOfClass:[NSNull class]]) {
        result = [str doubleValue];
    }
    return result;
}

+(NSInteger)getSNSInteger:(NSString *)str
{
    NSInteger result = 0;
    if (str != nil && ![str isKindOfClass:[NSNull class]]) {
        result = [str integerValue];
    }
    return result;
}

+(long)getSNSLong:(NSString *)str
{
    NSInteger result = 0;
    if (str != nil && ![str isKindOfClass:[NSNull class]]) {
        result = (long)[str longLongValue];
    }
    return result;
}

+(NSTimeInterval)getSNSTimeInterval:(NSString *)str
{
    NSTimeInterval result = 0;
    if (str != nil && ![str isKindOfClass:[NSNull class]]) {
        result = (NSTimeInterval)[str longLongValue];
    }
    return result;
}

+(NSString *)getSNSString:(NSString *)str
{
    NSString *result = kEmpty;
    if (str != nil && ![str isKindOfClass:[NSNull class]]) {
        result = [NSString stringWithFormat:@"%@", str];
    }
    return result;
}
+(CGFloat)getSNSFloat:(NSString *)str
{
    CGFloat result = 0;
    if (str != nil && ![str isKindOfClass:[NSNull class]]) {
        result = [str floatValue];
    }
    return result;
}

+(BOOL)getSNSBool:(NSString *)str
{
    BOOL result = NO;
    if (str != nil && ![str isKindOfClass:[NSNull class]]) {
        result = [str boolValue];
    }
    return result;
}

+(NSArray*)getSNSArray:(id)array
{
    NSMutableArray *result = [NSMutableArray array];
    if (array != nil && [array isKindOfClass:[NSArray class]]) {
        result = [NSMutableArray arrayWithArray:array];
    }
    return result;
}

+(NSDictionary*)getSNSDictionary:(id)dic
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
        result = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return result;
}

+ (NSString *)sha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (NSString *)md5Hash:(NSString *)str
{
    const char *cStr = [str UTF8String];
    if (cStr == NULL) {
        cStr = "";
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}

+(NSString *)Sha1Hash:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

+(NSString *)Sha256Hash:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result lowercaseString];
}

+(NSString*)stringMD5:(NSString*)str
{
    if (str == nil || [str isKindOfClass:[NSNull class]] || str.length == 0) {
        return kEmpty;
    }
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return [output lowercaseString];
}

+(NSString*)fileMD5:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: CHUNK_SIZE ];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [[NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                    digest[0], digest[1],
                    digest[2], digest[3],
                    digest[4], digest[5],
                    digest[6], digest[7],
                    digest[8], digest[9],
                    digest[10], digest[11],
                    digest[12], digest[13],
                    digest[14], digest[15]] uppercaseString];
    [handle closeFile];
    return [s lowercaseString];
}

+(NSString*)dataMD5:(NSData*)data
{
    
    if( [data length]<=0 ) return @"ERROR GETTING DATA MD5"; // file didnt exist
    
    return [self dataMD5:(Byte *)[data bytes] Length:(int)[data length]];
    
}

+(NSString*)dataMD5:(Byte*)data Length:(int)len
{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(data, len, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return [output lowercaseString];
    /*if( len<=0 ) return @"ERROR GETTING DATA MD5"; // file didnt exist
     
     CC_MD5_CTX md5;
     
     CC_MD5_Init(&md5);
     
     CC_MD5_Update(&md5, data, (CC_LONG)len);
     
     unsigned char digest[CC_MD5_DIGEST_LENGTH];
     CC_MD5_Final(digest, &md5);
     NSString* s = [[NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
     digest[0], digest[1],
     digest[2], digest[3],
     digest[4], digest[5],
     digest[6], digest[7],
     digest[8], digest[9],
     digest[10], digest[11],
     digest[12], digest[13],
     digest[14], digest[15]] lowercaseString];
     return s;*/
}

///颜色生成图片
+(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (BOOL)isContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
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
    }];
    return returnValue;
}

///获取字符串中图片标签集合
+(NSArray *)getRegularImg:(NSString *)string
{
    NSString *pattern = @"<img src=(.*?)/>";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *theArray = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    return theArray;
}

///获取IMG,SRC地址
+(NSString *)getTrimImg:(NSString *)string
{
    NSString *imgPath = [string stringByReplacingOccurrencesOfString:@"<img src=" withString:kEmpty];
    imgPath = [imgPath stringByReplacingOccurrencesOfString:@"/>" withString:kEmpty];
    imgPath = [imgPath stringByReplacingOccurrencesOfString:@"\"" withString:kEmpty];
    imgPath = [imgPath stringByReplacingOccurrencesOfString:@"'" withString:kEmpty];
    imgPath = [imgPath stringByReplacingOccurrencesOfString:@" " withString:kEmpty];
    return imgPath;
}

///获取URL参数的值
+(NSString *)getParamValueFromUrl:(NSString *)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="]) {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString *str = nil;
    NSRange   start = [url rangeOfString:paramName];
    if (start.location != NSNotFound) {
        // confirm that the parameter is not a partial name match
        unichar  c = '?';
        if (start.location != 0) {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#') {
            NSRange     end = [[url substringFromIndex:start.location + start.length] rangeOfString:@"&"];
            NSUInteger  offset = start.location + start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

@end
#pragma clang diagnostic pop
