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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (assign, nonatomic) BOOL appEnterBackground;
@property (strong, nonatomic) NSString *devTokenStr;
@property (strong, nonatomic) NSString *appUpdateKey;
@property (strong, nonatomic) NSString *appUpdateValue;
@property (assign, nonatomic) BOOL isPaying;

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

///去为APP评分
-(void)gotoAppStoreScore;

//添加检测错误日志
-(void)setUncaughtException;

///刷新配置信息
-(void)setRefreshAppConfig;

@end

