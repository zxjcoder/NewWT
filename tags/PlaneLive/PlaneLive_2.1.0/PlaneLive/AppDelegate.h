//
//  AppDelegate.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClassCategory.h"
#import "Utils.h"

#import "AppSetting.h"
#import "DataOper.h"
#import "SQLiteOper.h"

#import "PushManager.h"
#import "ShareManager.h"

#import "ZProgressHUD.h"
#import "ZAlertView.h"
#import "ZActionSheet.h"

#import "ZTabBarViewController.h"
#import "ZRootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyBoard;
/// 是否进入后台
@property (assign, nonatomic) BOOL appEnterBackground;
/// 设备Token
@property (strong, nonatomic) NSString *devTokenStr;
/// 更新Key
@property (strong, nonatomic) NSString *appUpdateKey;
/// 更新内容
@property (strong, nonatomic) NSString *appUpdateValue;
/// 是否播放过
@property (assign, nonatomic) BOOL isPlay;
/// 是否WiFi网络
@property (assign, nonatomic) BOOL isWiFi;

+(AppDelegate *)app;

+(ZTabBarViewController *)getTabBarVC;

+(id)getViewControllerWithIdentifier:(NSString*)identifier;

///关闭通知
+(void)setAppUnregisterForRemoteNotifications;

///注册通知
+(void)setAppRegisterForRemoteNotifications;

///清除App数量
- (void)clearApplicationIcon;

///设置推送账号
-(void)setPushAccount;

///退出登录
-(void)logout;
///登录成功
-(void)login;

///去为APP评分
-(void)gotoAppStoreScore;

//添加检测错误日志
-(void)setUncaughtException;

///刷新配置信息
-(void)setRefreshAppConfig;

///显示引导页
-(void)setShowBootVC;

@end

