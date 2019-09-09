//
//  AppDelegate.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMessage.h"
#import "ClassCategory.h"
#import "Utils.h"
#import "AppSetting.h"
#import "DataOper.h"
#import "SQLiteOper.h"
#import "PushManager.h"
#import "ShareManager.h"
#import "ZProgressHUD.h"
#import "ZAlertPromptView.h"
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
/// 是否审核状态
@property (assign, nonatomic) BOOL isAppAudit;

+(AppDelegate *)app;
///获取主界面
+(ZTabBarViewController *)getTabBarVC;
///获取页面
+(id)getViewControllerWithIdentifier:(NSString*)identifier;
///设置Bugout开关
-(void)setBugoutOn:(BOOL)on;
///调用微信公众号
-(void)showJumpToBizProfile;
///清除App数量
- (void)clearApplicationIcon;
///设置推送账号
-(void)setPushAccount;
///重置选中项目
-(void)setSelectTabbarFirstOne;
///退出登录
-(void)logout;
///登录成功
-(void)login;
///检查是否播放过
-(void)setCheckPlayList;
///去APP更新
-(void)gotoAppUpdate;
///去APP评分
-(void)gotoAppStoreScore;
//添加检测错误日志
-(void)setUncaughtException;
///刷新配置信息
-(void)setRefreshAppConfig;
///显示引导页
-(void)setShowBootVC;
///刷新配置信息
-(void)setRefreshAppConfig;

@end

