//
//  Utils.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface Utils : NSObject

///获取分割线
+(UIImageView *)getLineView;

///获取小图片地址
+(NSString *)getMinPicture:(NSString *)imagePath;

///是否是自己
+(BOOL)isMyUserId:(NSString *)userId;

///判断微信是否安装
+(BOOL)isWXAppInstalled;
///判断QQ是否安装
+(BOOL)isQQAppInstalled;

///根据邮箱或者手机号处理****
+(NSString *)getStringStarWithStr:(NSString *)str;

///传入 秒  得到 xx:xx:xx
+(NSString *)getHHMMSSFromSS:(NSString *)totalTime;
///传入 秒  得到 xx:xx:xx
+(NSString *)getHHMMSSFromSSTime:(NSTimeInterval)totalTime;
///传入 秒  得到  xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;

+(void) createDirectory:(NSString *)dirname;
+(void) deleteDirectory:(NSString *)dirname;
///写图片
+ (NSData *)writeImage:(UIImage *)image toFileAtPath:(NSString *)aPath;
///图片添加模糊度
+ (UIImage *)blurryImage:(UIImage *)image size:(CGSize)size withBlurLevel:(CGFloat)blur;
///转换成指定大小的图片
+ (UIImage *)resizedTransformtoSize:(CGSize)Newsize image:(UIImage *)image;

+(double)getSNSDouble:(NSString *)str;
+(int)getSNSInt:(NSString *)str;
+(NSInteger)getSNSInteger:(NSString *)str;
+(long)getSNSLong:(NSString *)str;
+(NSTimeInterval)getSNSTimeInterval:(NSString *)str;
+(NSString*)getSNSString:(NSString *)str;
+(CGFloat)getSNSFloat:(NSString *)str;
+(BOOL)getSNSBool:(NSString *)str;
+(NSArray*)getSNSArray:(id)array;
+(NSDictionary*)getSNSDictionary:(id)dic;

/*
 *  加密模块
 */
#define CHUNK_SIZE 8192


+(NSString *)sha1:(NSString *)str;
+(NSString *)md5Hash:(NSString *)str;

+(NSString *)Sha1Hash:(NSString *)str;
+(NSString *)Sha256Hash:(NSString *)str;

+(NSString*)stringMD5:(NSString*)str;
+(NSString*)fileMD5:(NSString*)path;
+(NSString*)dataMD5:(NSData*)data;

///颜色生成图片
+(UIImage *)createImageWithColor:(UIColor *)color;

///判断是否包含表情
+ (BOOL)isContainsEmoji:(NSString *)string;

///获取字符串中图片标签集合
+(NSArray *)getRegularImg:(NSString *)string;

///获取IMG,SRC地址
+(NSString *)getTrimImg:(NSString *)string;

///获取URL参数的值
+(NSString *)getParamValueFromUrl:(NSString *)url paramName:(NSString *)paramName;

@end
