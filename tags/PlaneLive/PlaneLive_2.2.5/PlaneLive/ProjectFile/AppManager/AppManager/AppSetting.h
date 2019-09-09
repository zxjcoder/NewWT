//
//  AppSetting.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelEntity.h"

@interface AppSetting : NSObject

+(void)load;
+(void)loadAuditUser;
+(void)del;
+(void)save;

///获取用户皮肤
+(NSString*)getUserSkin;
///设置用户皮肤
+(void)setUserSkin:(NSString*)value;

///获取是否自动登录
+(bool)getAutoLogin;
///设置是否自动登录
+(void)setAutoLogin:(bool)value;

///获取用户ID
+(NSString*)getUserId;
///设置用户ID
+(void)setUserId:(NSString*)value;

///设置用户对象
+(void)setUserLogin:(ModelUser*)model;
///获取用户对象
+(ModelUser*)getUserLogin;

///获取字体大小
+(NSString*)getFontSize;
///设置字体大小
+(void)setFontSize:(NSString*)value;

///获取播放倍率
+(CGFloat)getRate;
///设置播放倍率
+(void)setRate:(CGFloat)value;

///获取Bugout开关
+(bool)getBugoutOn;
///设置Bugout开关
+(void)setBugoutOn:(bool)value;

///沙盒目录地址
+(NSString*) getDocumentPath;
///播放进度文件地址
+(NSString*) getPlayTimeFilePath;
///用户文件地址
+(NSString*) getPersonalFilePath;
///皮肤文件地址
+(NSString*) getSkinFilePath;
///临时文件地址
+(NSString*) getTempFilePath;
///数据文件地址
+(NSString*) getDataFilePath;

///缓存文件地址
+(NSString*) getCachesFilePath;
///办公文件地址
+(NSString*)getOfficeFilePath;
///音频文件地址
+(NSString*) getAudioFilePath;
///回答文件地址
+(NSString*) getAnswerFilePath;
///下载音频地址
+(NSString*)getDownloadFilePath;
///获取WebKit缓存文件夹地址
+(NSString*) getWebKitFilePath;
///图片文件地址
+(NSString*)getPictureFilePath;

///创建用户文件夹
+(void) createFileDir;
///删除所用缓存文件夹
+(void) removeFileDir;

+ (void)cancelMemory;

@end
