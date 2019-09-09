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

+(void)load:(NSString*)loginaccount;
+(void)del:(NSString*)loginaccount;
+(void)save;
+(NSMutableArray*)getHisLoginAccount;

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

///获取游客
+(NSString*)getUserDetauleId;

///获取用户帐号
+(NSString*)getUserAccount;
///设置用户帐号
+(void)setUserAccount:(NSString*)value;

///获取用户密码
+(NSString*)getUserPassword;
///设置用户密码
+(void)setUserPassword:(NSString*)value;

///设置用户对象
+(void)setUserLogin:(ModelUser*)model;
///获取用户对象
+(ModelUser*)getUserLogin;

///获取设备名称
+(NSString*)getDeviceName;
///设置设备名称
+(void)setDeviceName:(NSString*)value;

///获取字体大小
+(NSString*)getFontSize;
///设置字体大小
+(void)setFontSize:(NSString*)value;

///获取推送开关
+(NSString*)getNoticeSwitch;
///设置推送开关
+(void)setNoticeSwitch:(NSString*)value;

///获取用户UDID
+(NSString*)getUserUDID;
///设置用户UDID
+(void)setUserUDID:(NSString*)value;

///获取设备TOKEN
+(NSString*)getDeviceToken;
///设置设备TOKEN
+(void)setDeviceToken:(NSString*)value;

///获取播放倍率 1-1 2-1.25 3-1.5
+(int)getRate;
///设置播放倍率 1-1 2-1.25 3-1.5
+(void)setRate:(int)value;

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
///获取WebKit缓存文件夹地址
+(NSString*) getWebKitFilePath;
///图片文件地址
+(NSString*)getPictureFilePath;

///创建用户文件夹
+(void) createFileDir;
///删除所用缓存文件夹
+(void) removeFileDir;

@end
