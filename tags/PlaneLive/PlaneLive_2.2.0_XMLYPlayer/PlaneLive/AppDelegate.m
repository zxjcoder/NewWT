//
//  AppDelegate.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AppDelegate.h"
#ifdef __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <StoreKit/SKStoreProductViewController.h>
#import <Bugly/Bugly.h>
#import <UMMobClick/MobClick.h>
#import "XMSDKPlayer.h"
#import "XMSDKDownloadManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ZNetworkPromptView.h"
#import "ZCatchCrash.h"
#import "ZAlertView.h"
#import "WXApi.h"
#import "MiPushSDK.h"
#import "ZBootViewController.h"
#import "ZPlayerViewController.h"
#import "ApplePayManager.h"

@interface AppDelegate ()<SKStoreProductViewControllerDelegate,WXApiDelegate,ZAlertViewDelegate,MiPushSDKDelegate,UNUserNotificationCenterDelegate>

@property (assign, nonatomic) BOOL isUploadError;
@property (assign, nonatomic) BOOL isCheckVersion;

@end

@implementation AppDelegate

///APP启动页面加载完成
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //配置基本属性
    [self setAppEnterBackground:NO];
    [self setStoryBoard:[UIStoryboard storyboardWithName:@"Main" bundle:nil]];
    //配置网络请求状态栏显示转圈状态
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //配置本地登录用户
    [self setConfigUserInfo];
    //监听网络状态改变
    [self setMonitorNetworkStatusChanges];
    //添加3D Touch
    [self createTouchItemsWithIcons];
    //更新配置信息
    [self setRefreshAppConfig];
    //注册通知
    [self registerRemoteNotification];
    //启用推送
    [MiPushSDK registerMiPush:self];
    //注册Share分享
    [self registerShare];
    //UMeng统计
    UMConfigInstance.appKey = kUMeng_Appkey;
    UMConfigInstance.ePolicy = SEND_INTERVAL;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:APP_PROJECT_VERSION];
    [MobClick setCrashReportEnabled:NO];
    [MobClick setEncryptEnabled:YES];
    //腾讯Bug收集
    [Bugly startWithAppId:kTencentBugly_AppId];
    [Bugly setUserIdentifier:[AppSetting getUserDetauleId]];
    ///设置Window属性
    [self.window setBackgroundColor:WHITECOLOR];
    [self.window makeKeyAndVisible];
    ///设置状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    [self becomeFirstResponder];
    return YES;
}
///已经进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self setAppEnterBackground:NO];
    
    [[AppDelegate getTabBarVC] setRefreshUserInfo];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
///已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self setAppEnterBackground:YES];
}
///关闭时执行的事件
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ApplePayManager sharedHelper] dismiss];
    [[XMReqMgr sharedInstance] closeXMReqMgr];
    [[XMSDKDownloadManager sharedSDKDownloadManager] pauseAllDownloads];
    [XMSDKDownloadManager sharedSDKDownloadManager].sdkDownloadMgrDelegate = nil;
}
///远程控制播放器
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay: [[ZPlayerViewController sharedSingleton] setStartPlay]; break;
            case UIEventSubtypeRemoteControlPause: [[ZPlayerViewController sharedSingleton] setPausePlay]; break;
            case UIEventSubtypeRemoteControlTogglePlayPause: [[ZPlayerViewController sharedSingleton] setPausePlay]; break;
            case UIEventSubtypeRemoteControlPreviousTrack: [[ZPlayerViewController sharedSingleton] btnPreClick]; break;
            case UIEventSubtypeRemoteControlNextTrack: [[ZPlayerViewController sharedSingleton] btnNextClick]; break;
            default: break;
        }
    }
}
///屏幕支持方向设置
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Application OpenURL

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self getHandleOpenURL:url sourceApplication:nil annotation:nil isHttps:NO];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self getHandleOpenURL:url sourceApplication:sourceApplication annotation:annotation isHttps:YES];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [self getHandleOpenURL:url sourceApplication:nil annotation:nil isHttps:NO];
}
-(BOOL)getHandleOpenURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation isHttps:(BOOL)isHttps
{
    if ([url.host isEqualToString:kALI_Auth_URLHost_Key]) {
        return YES;
    }
    if ([url.host isEqualToString:kWechat_Auth_URLHost_Key]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if ([url.host isEqualToString:kTencentQQ_Auth_URLHost_Key]) {
        return [QQApiInterface handleOpenURL:url delegate:nil];
    }
    if ([url.host isEqualToString:kMy_AppScheme_Host]) {
        [PushManager setPushViewControllerWithUrl:url];
        return YES;
    }
    return YES;
}

#pragma mark - Application Local And Push Notification

///iOS7+收到推送通知回调执行方法
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
}
/// iOS3+收到推送通知回调执行方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
    [self addLocationNotification:userInfo];
}
/// iOS4+本地通知执行方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [MiPushSDK handleReceiveRemoteNotification:notification.userInfo];
    [PushManager setPushContentWithUserInfo:notification.userInfo];
}

#pragma mark - UNUserNotificationCenterDelegate
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// iOS10+收到推送通知回调执行方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    if (APP_SYSTEM_VERSION >= 10) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            NSDictionary *userInfo = notification.request.content.userInfo;
            [MiPushSDK handleReceiveRemoteNotification:userInfo];
            [self addLocationNotification:userInfo];
        }
        completionHandler(UNNotificationPresentationOptionBadge);
    }
}
/**
 *  iOS10+通知快捷按钮点击后会回调该方法--暂时没有功能按钮
 *  在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (APP_SYSTEM_VERSION >= 10) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            NSDictionary *userInfo = response.notification.request.content.userInfo;
            [MiPushSDK handleReceiveRemoteNotification:userInfo];
            [PushManager setPushContentWithUserInfo:userInfo];
        }
        completionHandler();
    }
}
#endif

#pragma mark - Application Registration Push Notification Service
/// 获取到用户设备TOKEN
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [MiPushSDK bindDeviceToken:deviceToken];
    self.devTokenStr = [[[[deviceToken description]
                          stringByReplacingOccurrencesOfString:@"<" withString:kEmpty]
                         stringByReplacingOccurrencesOfString:@">" withString:kEmpty]
                        stringByReplacingOccurrencesOfString:@" " withString:kEmpty];
    if (self.devTokenStr.length > 0) {
        [sqlite setSysParam:kSQLITE_DEVICE_TOKEN value:self.devTokenStr];
    }
    [self setPushAccount];
}
/// 注册用户通知设置失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}
/// 注册用户通知设置回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

#pragma mark - Application 3D Touch Event

#define k3DTouch_PublishQuestion_Key @"com.wutongsx.publishquestion"
#define k3DTouch_PlayPractice_Key @"com.wutongsx.playpractice"
#define k3DTouch_SearchQuestionAnswer_Key @"com.wutongsx.searchquestionanswer"
#define k3DTouch_SearchPractice_Key @"com.wutongsx.searchpractice"

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (APP_SYSTEM_VERSION >= 9) {
        if (shortcutItem) {
            if ([shortcutItem.type isEqualToString:k3DTouch_PublishQuestion_Key]) {
                [self setShowQuestionVC];
            } else if ([shortcutItem.type isEqualToString:k3DTouch_PlayPractice_Key]) {
                [self setShowPracticeVC];
            } else if ([shortcutItem.type isEqualToString:k3DTouch_SearchQuestionAnswer_Key]) {
                [self setShowSearchQuestionAnswerVC];
            } else if ([shortcutItem.type isEqualToString:k3DTouch_SearchPractice_Key]) {
                [self setShowSearchPractice];
            }
        }
    }
#endif
}
///添加3D Touch
-(void)createTouchItemsWithIcons
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (APP_SYSTEM_VERSION >= 9) {
        UIApplicationShortcutIcon *iconPlay = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_play"];
        UIApplicationShortcutIcon *iconQuestion = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_question"];
        UIApplicationShortcutIcon *iconSearchQ = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_search"];
        UIApplicationShortcutIcon *iconSearchP = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_search"];
        
        UIMutableApplicationShortcutItem *itemPlay = [[UIMutableApplicationShortcutItem alloc]initWithType:k3DTouch_PlayPractice_Key localizedTitle:kPlayCurrent localizedSubtitle:nil icon:iconPlay userInfo:nil];
        
        UIMutableApplicationShortcutItem *itemSearchQuestion = [[UIMutableApplicationShortcutItem alloc] initWithType:k3DTouch_SearchQuestionAnswer_Key localizedTitle:kSearchQuestion localizedSubtitle:nil icon:iconSearchQ userInfo:nil];
        
        UIMutableApplicationShortcutItem *itemSearchPractice = [[UIMutableApplicationShortcutItem alloc] initWithType:k3DTouch_SearchPractice_Key localizedTitle:kSearchPractice localizedSubtitle:nil icon:iconSearchP userInfo:nil];
        
        UIMutableApplicationShortcutItem *itemQuickQuestion = [[UIMutableApplicationShortcutItem alloc] initWithType:k3DTouch_PublishQuestion_Key localizedTitle:kQuickQuestion localizedSubtitle:nil icon:iconQuestion userInfo:nil];
        
        [UIApplication sharedApplication].shortcutItems = @[itemPlay, itemSearchPractice, itemQuickQuestion, itemSearchQuestion];
    }
#endif
}
///显示提问界面
-(void)setShowQuestionVC
{
    [[AppDelegate getTabBarVC] setShowQuestionVC];
}
///搜索问答界面
-(void)setShowSearchQuestionAnswerVC
{
    [[AppDelegate getTabBarVC] setShowSearchQuestionAnswerVC];
}
///搜索实务界面
-(void)setShowSearchPractice
{
    [[AppDelegate getTabBarVC] setShowSearchPractice];
}
///播放实务界面
-(void)setShowPracticeVC
{
    [[AppDelegate getTabBarVC] setShowPracticeVC];
}

#pragma mark - PrivateMethod

///清除App数量
- (void)clearApplicationIcon
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
///注册通知
- (void)registerRemoteNotification
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (APP_SYSTEM_VERSION >= 10) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                GBLog(@"UNUserNotificationCenter completionHandler 授权");
            } else {
                GBLog(@"UNUserNotificationCenter completionHandler 拒绝");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
#else
    if (APP_SYSTEM_VERSION < 10) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
#endif
}
///注册分享SDK
- (void)registerShare
{
    [ShareSDK registerApp:kShare_AppKey
           activePlatforms:@[@(SSDKPlatformTypeWechat),
                             @(SSDKPlatformTypeQQ),
                             @(SSDKPlatformTypeYinXiang),
                             @(SSDKPlatformTypeYouDaoNote),
                             ]
                  onImport:^(SSDKPlatformType platformType) {
                      switch (platformType)
                      {
                          case SSDKPlatformTypeWechat:
                              [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                              break;
                          case SSDKPlatformTypeQQ:
                              [ShareSDKConnector connectQQ:[QQApiInterface class]
                                         tencentOAuthClass:[TencentOAuth class]];
                              break;
                          default: break;
                      }
                  }
           onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:kWeChat_AppId
                                                   appSecret:kWeChat_AppSecret];
                             break;
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:kTencentQQ_AppId
                                                  appKey:kTencentQQ_AppKey
                                                authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeYouDaoNote:
                             [appInfo SSDKSetupYouDaoNoteByConsumerKey:kYouDaoNote_AppKey
                                                        consumerSecret:kYouDaoNote_AppSecret
                                                         oauthCallback:kYouDaoNote_RedirectUri];
                             break;
                         case SSDKPlatformTypeYinXiang:
                             [appInfo SSDKSetupEvernoteByConsumerKey:kYinXiang_AppKey
                                                      consumerSecret:kYinXiang_AppSecret
                                                             sandbox:NO];
                             break;
                         default: break;
                     }
                 }];
}
-(void)dealloc
{
    [self setAppNil];
}
-(void)setAppNil
{
    OBJC_RELEASE(_devTokenStr);
    OBJC_RELEASE(_appUpdateKey);
    OBJC_RELEASE(_appUpdateValue);
}
///添加本地通知
- (void)addLocationNotification:(NSDictionary *)userInfo
{
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        //创建一个本地通知的对象
        UILocalNotification *location = [[UILocalNotification alloc] init];
        //设置触发时间
        location.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        //设置重复的次数
        location.repeatInterval = kCFCalendarUnitSecond;
        //设置本地通知的属性
        location.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        location.userInfo = userInfo;
        //调用发送本地通知的方法
        [[UIApplication sharedApplication] scheduleLocalNotification:location];
    }
}
///添加检测错误日志
-(void)setUncaughtException
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *errorData = [ZCatchCrash getCatchCrashErrorData];
        if (errorData && errorData.length > 0) {
            [snsV1 postErrorReportWithContent:errorData resultBlock:^{
                [ZCatchCrash delCatchCrashErrorData];
            } errorBlock:nil];
        }
    });
}
///显示引导页
-(void)setShowBootVC
{
    BOOL isBoot = [[sqlite getSysParamWithKey:kSQLITE_FRIST_START] boolValue];
    if (!isBoot) {
        ZBootViewController *itemVC = [[ZBootViewController alloc] init];
        [[AppDelegate getTabBarVC] presentViewController:itemVC animated:NO completion:nil];
    }
}
///配置用户信息
-(void)setConfigUserInfo
{
    [AppSetting load:kMOne];
    NSMutableArray *arrHisLoginAcc = [AppSetting getHisLoginAccount];
    if (arrHisLoginAcc.count > 0) {[AppSetting load:arrHisLoginAcc.firstObject];}
    [AppSetting createFileDir];
}
///刷新配置信息
-(void)setRefreshAppConfig
{
    if (self.isCheckVersion) {
        return;
    }
    [self setCheckPlayList];
    self.isCheckVersion = YES;
    ZWEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [snsV1 getAppConfigWithAppVersion:APP_PROJECT_VERSION resultBlock:^(ModelAppConfig *result) {
            ///保存最新的状态
            [sqlite setLocalAppConfigWithModel:result];
            if (result.appStatus == 1) {
                if (![result.appVersion isEqualToString:APP_PROJECT_VERSION]) {
                    NSString *updKey = [NSString stringWithFormat:@"appVersion%@",result.appVersion];
                    [weakSelf setAppUpdateKey:updKey];
                    [weakSelf setAppUpdateValue:result.appVersion];
                    NSString *isUpd = [sqlite getSysParamWithKey:updKey];
                    if (isUpd.length == 0) {
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:result.title message:result.content preferredStyle:(UIAlertControllerStyleAlert)];
                        ///稍后更新
                        UIAlertAction *actionLater = [UIAlertAction actionWithTitle:kLaterUpdating style:(UIAlertActionStyleDefault) handler:nil];
                        ///不再提示
                        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:kNoLongerUpdating style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            [sqlite setSysParam:updKey value:result.appVersion];
                        }];
                        ///马上更新
                        UIAlertAction *actionNow = [UIAlertAction actionWithTitle:kRightNowUpdating style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                            [weakSelf gotoAppUpdate];
                        }];
                        [alertVC addAction:actionLater];
                        [alertVC addAction:actionCancel];
                        [alertVC addAction:actionNow];
                        GCDMainBlock(^{
                            [[weakSelf getTabBarVC] presentViewController:alertVC animated:NO completion:nil];
                        });
                    }
                }
            }
        } errorBlock:nil];
    });
}
#pragma mark - PublicMethod

+(AppDelegate *)app
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
+(ZTabBarViewController *)getTabBarVC
{
    return (ZTabBarViewController*)[(ZRootViewController*)[AppDelegate app].window.rootViewController topViewController];
}
-(ZTabBarViewController *)getTabBarVC
{
    return [AppDelegate getTabBarVC];
}
+(id)getViewControllerWithIdentifier:(NSString*)identifier
{
    return [[[AppDelegate app] storyBoard] instantiateViewControllerWithIdentifier:identifier];
}
///调用微信公众号
-(void)showJumpToBizProfile
{
    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc] init];
    req.profileType =WXBizProfileType_Normal;
    req.username = kWeChatCustomerServiceNumber;
    [WXApi sendReq:req];
}
///设置推送账号
-(void)setPushAccount
{
    NSString *userId = [AppSetting getUserDetauleId];
    NSString *md5UserId = [Utils stringMD5:userId];
    if ([AppSetting getAutoLogin]) {
        [MiPushSDK unsetAlias:kOne];
        [MiPushSDK setAccount:md5UserId];
    } else {
        [MiPushSDK setAlias:kOne];
        [MiPushSDK unsetAccount:md5UserId];
    }
    GBLog(@"setPushAccount userId: %@, md5UserId: %@", userId, md5UserId);
}
///重置选中项目
-(void)setSelectTabbarFirstOne
{
    [[[AppDelegate app] getTabBarVC] logout];
}
///注销登录
-(void)logout
{
    //退出登录
    [AppSetting setAutoLogin:NO];
    NSMutableArray *arrX = [AppSetting getHisLoginAccount];
    [arrX removeObject:kMOne];
    [arrX insertObject:kMOne atIndex:0];
    [AppSetting save];
    [AppSetting load:kMOne];
    [self setCheckPlayList];
    
    [[XMSDKPlayer sharedPlayer] stopTrackPlay];
    [[ZPlayerViewController sharedSingleton] setModelTrack:nil];
    [[ZPlayerViewController sharedSingleton] setModelPractice:nil];
    [[ZPlayerViewController sharedSingleton] setModelCurriculum:nil];
    [[ZPlayerViewController sharedSingleton] setArrayTrack:nil];
    [[ZPlayerViewController sharedSingleton] setArrayRawdata:nil];
    ///设置推送账号
    [self setPushAccount];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLoginChangeNotification object:nil];
}
///登录成功
-(void)login
{
    ///设置推送账号
    [self setPushAccount];
    [self setCheckPlayList];
    [Bugly setUserIdentifier:[AppSetting getUserDetauleId]];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLoginChangeNotification object:nil];
}
///检查是否播放过
-(void)setCheckPlayList
{
    NSArray *arrP = [sqlite getLocalPlayListPracticeWithUserId:[AppSetting getUserDetauleId]];
    if (arrP && arrP.count > 0) {
        self.isPlay = YES;
    } else {
        NSArray *arrC = [sqlite getLocalPlayListSubscribeCurriculumWithUserId:[AppSetting getUserDetauleId]];
        if (arrC && arrC.count > 0) {
            self.isPlay = YES;
        } else {
            self.isPlay = NO;
        }
    }
}
///去APP跟新
-(void)gotoAppUpdate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kApp_AppUrl]];
}
///去APP评分
-(void)gotoAppStoreScore
{
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    [storeProductVC setDelegate:self];
    [storeProductVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:kApp_AppId} completionBlock:nil];
    [[AppDelegate getTabBarVC] presentViewController:storeProductVC animated:YES completion:nil];

}
///监听网络状态改变
-(void)setMonitorNetworkStatusChanges
{
    ZWEAKSELF
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown://未识别的网络
                weakSelf.isWiFi = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable://不可达的网络(未连接)
                weakSelf.isWiFi = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://2G,3G,4G...的网络
                weakSelf.isWiFi = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://WiFi的网络
                weakSelf.isWiFi = YES;
                break;
        }
    }];
    [manager startMonitoring];
}

#pragma mark - SKStoreProductViewControllerDelegate

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WXApiDelegate

-(void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *payResp = (PayResp*)resp;
        switch (payResp.errCode) {
            case WXSuccess:
            {
                [ZProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPaySuccessNotification object:payResp];
                break;
            }
            case WXErrCodeUserCancel:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayCancelNotification object:payResp];
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgPayCancel];
                break;
            }
            case WXErrCodeAuthDeny:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:payResp];
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgPayAuthDeny];
                break;
            }
            case WXErrCodeCommon:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:payResp];
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgPayCommon];
                break;
            }
            case WXErrCodeSentFail:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:payResp];
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgSendFail];
                break;
            }
            case WXErrCodeUnsupport:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:payResp];
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgPayNotSupported];
                break;
            }
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *sendAuthResp = (SendAuthResp*)resp;
        switch (sendAuthResp.errCode) {
            case WXSuccess:
                break;
            case WXErrCodeUserCancel:
            {
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgAuthCancel];
                break;
            }
            case WXErrCodeAuthDeny:
            {
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgPayAuthDeny];
                break;
            }
            case WXErrCodeCommon:
            {
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgPayAuthDeny];
                break;
            }
            case WXErrCodeSentFail:
            {
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgSendFail];
                break;
            }
            case WXErrCodeUnsupport:
            {
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:kCMsgPayNotSupported];
                break;
            }
        }
    }
}

#pragma mark - ZAlertViewDelegate

-(void)alertView:(ZAlertView *)alertView didButtonClickWithIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: break;
        case 1: [sqlite setSysParam:self.appUpdateKey value:self.appUpdateValue]; break;
        case 2: [[AppDelegate app] gotoAppStoreScore]; break;
        default:break;
    }
}

#pragma mark - MiPushSDKDelegate

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
#ifdef DEBUG
        NSLog(@"miPushRequestSuccWithSelector-bindDeviceToken: %@", data);
#endif
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    // 请求失败
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
#ifdef DEBUG
        NSLog(@"miPushRequestErrWithSelector-bindDeviceToken: %@", data);
#endif
    }
}


@end
