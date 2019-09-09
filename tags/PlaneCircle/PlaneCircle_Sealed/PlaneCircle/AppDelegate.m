//
//  AppDelegate.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AppDelegate.h"
#import "ZCatchCrash.h"
#import "ZAlertView.h"

#import "WXApi.h"
#import "MiPushSDK.h"
#import <UMMobClick/MobClick.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import <StoreKit/SKStoreProductViewController.h>

#import "AFNetworkReachabilityManager.h"
#import "ZNetworkPromptView.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "ZCircleQuestionViewController.h"

#import "ZTabBarViewController.h"

#define kCHECK_HUHUSERVER_URL @"http://www.apple.com"

@interface AppDelegate ()<SKStoreProductViewControllerDelegate,WXApiDelegate,ZAlertViewDelegate,MiPushSDKDelegate>

@property (assign, nonatomic) BOOL isUploadError;
@property (assign, nonatomic) BOOL isCheckVersion;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //配置基本属性
    [self setAppEnterBackground:NO];
    [self setStoryBoard:[UIStoryboard storyboardWithName:@"Main" bundle:nil]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //配置本地登录用户
    [AppSetting load:kMOne];
    NSMutableArray *arrHisLoginAcc = [AppSetting getHisLoginAccount];
    if (arrHisLoginAcc.count > 0) {[AppSetting load:arrHisLoginAcc.firstObject];}
    [AppSetting createFileDir];
    
    if ([[AppSetting getNoticeSwitch] boolValue]) {
        //注册通知
        [self registerRemoteNotification];
    }
    //启用推送
    [MiPushSDK registerMiPush:self];
    
    //注册Share分享
    [self registerShare];
    
    //注册统计
    UMConfigInstance.appKey = kUMeng_Appkey;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:APP_PROJECT_VERSION];
    [MobClick setEncryptEnabled:YES];
    [MobClick setBackgroundTaskEnabled:NO];
    [MobClick setCrashReportEnabled:NO];
    
    //监听网络状态改变
    //[self setMonitorNetworkStatusChanges];
    
    //添加3D Touch
    [self createTouchItemsWithIcons];
    
    //更新配置信息
    [self setRefreshAppConfig];
    
    ///设置Window属性
    [self.window makeKeyAndVisible];
    ///设置状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [application setStatusBarStyle:(UIStatusBarStyleLightContent)];
    
    return YES;
}
///已经进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self setAppEnterBackground:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZApplicationDidBecomeActiveNotification object:nil];
    
    [application endReceivingRemoteControlEvents];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[AppDelegate getTabBarVC] setRefreshUserInfo];
}
///已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self setAppEnterBackground:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZApplicationDidEnterBackgroundNotification object:nil];
    
    [application beginReceivingRemoteControlEvents];
}
///远程控制播放器
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type == UIEventTypeRemoteControl) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayRemoteNotification object:event];
    }
}
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
//        [AlipayManager processOrderWithPaymentResult:url standbyCallback:^(ModelOrderALIResult *result) {
//            dispatch_async(dispatch_get_main_queue(),^{
//                [[AppDelegate app] setOpenUrlType:(SNSOpenURLTypeNone)];
//                switch (result.resultStatus) {
//                    case AlipayOrderStatusSuccess:
//                    {
//                        [ZAlertView showWithMessage:kCMsgPaySuccess];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:ZPaySuccessNotification object:nil];
//                        break;
//                    }
//                    case AlipayOrderStatusHandling:break;
//                    case AlipayOrderStatusConnect:
//                    {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
//                        [ZAlertView showWithMessage:kCMsgPayContentError];
//                        break;
//                    }
//                    case AlipayOrderStatusFailure:
//                    {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
//                        [ZAlertView showWithMessage:kCMsgPayCommon];
//                        break;
//                    }
//                    case AlipayOrderStatusCancel:
//                    {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:ZPayCancelNotification object:nil];
//                        [ZAlertView showWithMessage:kCMsgPayCancel];
//                        break;
//                    }
//                }
//            });
//        }];
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

///iOS7+
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    [self application:application didReceiveRemoteNotification:userInfo];
}
///iOS3+
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
    
    if (application.applicationState != UIApplicationStateActive) {
        [PushManager setPushContentWithUserInfo:userInfo];
    }
}
///iOS4+
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [MiPushSDK handleReceiveRemoteNotification:notification.userInfo];
    
    if (application.applicationState != UIApplicationStateActive) {
        [PushManager setPushContentWithUserInfo:notification.userInfo];
    }
}

#pragma mark - Application Registration Push Notification Service

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [MiPushSDK bindDeviceToken:deviceToken];
    
    const Byte *devTokenBytes = [deviceToken bytes];
    NSMutableString *deviceTokenStr = [[NSMutableString alloc] initWithCapacity:64];
    for (int i=0; i<deviceToken.length; i++) {
        [deviceTokenStr appendFormat:@"%02X", devTokenBytes[i]];
    }
    if (deviceTokenStr.length > 0) {
        self.devTokenStr = [NSString stringWithString:deviceTokenStr];
        
        [sqlite setSysParam:kSQLITE_DEVICE_TOKEN value:deviceTokenStr];
#ifdef DEBUG
        NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", self.devTokenStr);
#endif
    }
    [self setPushAccount];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

#pragma mark - Application 3D Touch Event

#define k3DTouch_PublishQuestion_Key @"com.wutongsx.publishquestion"
#define k3DTouch_PlayPractice_Key @"com.wutongsx.playpractice"
#define k3DTouch_SearchQuestionAnswer_Key @"com.wutongsx.searchquestionanswer"

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    if (APP_SYSTEM_VERSION >= 9) {
        if (shortcutItem) {
            if ([shortcutItem.type isEqualToString:k3DTouch_PublishQuestion_Key]) {
                [self setShowQuestionVC];
            } else if ([shortcutItem.type isEqualToString:k3DTouch_PlayPractice_Key]) {
                [self setShowPracticeVC];
            } else if ([shortcutItem.type isEqualToString:k3DTouch_SearchQuestionAnswer_Key]) {
                [self setShowSearchQuestionAnswerVC];
            }
        }
    }
#endif
}

///添加3D Touch
-(void)createTouchItemsWithIcons
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    if (APP_SYSTEM_VERSION >= 9) {
        UIApplicationShortcutIcon *iconPlay = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_play"];
        UIApplicationShortcutIcon *iconQuestion = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_question"];
        UIApplicationShortcutIcon *iconSearch = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_search"];
        
        UIMutableApplicationShortcutItem *itemPlay = [[UIMutableApplicationShortcutItem alloc]initWithType:k3DTouch_PlayPractice_Key localizedTitle:kPlayPractice localizedSubtitle:nil icon:iconPlay userInfo:nil];
        
        UIMutableApplicationShortcutItem *itemSearchQuestion = [[UIMutableApplicationShortcutItem alloc]initWithType:k3DTouch_SearchQuestionAnswer_Key localizedTitle:kSearchQuestion localizedSubtitle:nil icon:iconSearch userInfo:nil];
        
        UIMutableApplicationShortcutItem *itemQuickQuestion = [[UIMutableApplicationShortcutItem alloc]initWithType:k3DTouch_PublishQuestion_Key localizedTitle:kQuickQuestion localizedSubtitle:nil icon:iconQuestion userInfo:nil];
        
        [UIApplication sharedApplication].shortcutItems = @[itemPlay, itemSearchQuestion, itemQuickQuestion];
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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
     if (APP_SYSTEM_VERSION >= 8) {
         UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
         [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
     }
#else
    if (APP_SYSTEM_VERSION < 8) {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
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
}
///添加本地通知
- (void)addLocationNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //创建一个本地通知的对象
    UILocalNotification *location = [[UILocalNotification alloc]init];
    //设置触发时间
    location.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    //设置重复的次数
    location.repeatInterval =kCFCalendarUnitSecond;
    //设置本地通知的属性
    location.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    location.userInfo = userInfo;
    //调用
    [[UIApplication sharedApplication] scheduleLocalNotification:location];
}
///添加检测错误日志
-(void)setUncaughtException
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *errorData = [ZCatchCrash getCatchCrashErrorData];
        if (errorData && errorData.length > 0) {
            [sns postErrorReportWithContent:errorData resultBlock:^{
                [ZCatchCrash delCatchCrashErrorData];
            } errorBlock:nil];
        }
    });
}
///刷新配置信息
-(void)setRefreshAppConfig
{
    if (self.isCheckVersion) {
        return;
    }
    self.isCheckVersion = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [sns getAppConfigWithAppVersion:APP_PROJECT_VERSION resultBlock:^(ModelAppConfig *result) {
            ///保存最新的状态
            [sqlite setLocalAppConfigWithModel:result];
            ///榜单状态不相同
            //[[NSNotificationCenter defaultCenter] postNotificationName:ZAppRankStateChangeNotification object:result];
            
            if (result.appStatus == 1) {
                if (![result.appVersion isEqualToString:APP_PROJECT_VERSION]) {
                    NSString *updKey = [NSString stringWithFormat:@"appVersion%@",result.appVersion];
                    [[AppDelegate app] setAppUpdateKey:updKey];
                    [[AppDelegate app] setAppUpdateValue:result.appVersion];
                    NSString *isUpd = [sqlite getSysParamWithKey:updKey];
                    if (isUpd.length == 0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
                        if (APP_SYSTEM_VERSION >= 8) {
                            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:result.title message:result.content preferredStyle:(UIAlertControllerStyleAlert)];
                            ///稍后更新
                            UIAlertAction *actionLater = [UIAlertAction actionWithTitle:kLaterUpdating style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            ///不再提示
                            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:kNoLongerUpdating style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                                [sqlite setSysParam:updKey value:result.appVersion];
                            }];
                            ///马上更新
                            UIAlertAction *actionNow = [UIAlertAction actionWithTitle:kRightNowUpdating style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                                [[AppDelegate app] gotoAppStoreScore];
                            }];
                            [alertVC addAction:actionLater];
                            [alertVC addAction:actionCancel];
                            [alertVC addAction:actionNow];
                            [[[[AppDelegate app] window] rootViewController] presentViewController:alertVC animated:NO completion:nil];
                        }
#else
                        if (APP_SYSTEM_VERSION < 8) {
                            ZAlertView *alertView = [[ZAlertView alloc] initWithTitle:result.title message:result.content buttonTitles:kLaterUpdating, kNoLongerUpdating, kRightNowUpdating, nil];
                            [alertView setMessageTextAlignment:(NSTextAlignmentLeft)];
                            [alertView setDelegate:[AppDelegate app]];
                            [alertView show];
                        }
#endif
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
    return (ZTabBarViewController*)[(ZNavigationViewController*)[AppDelegate app].window.rootViewController topViewController];
//    return [[[AppDelegate app] storyBoard] instantiateViewControllerWithIdentifier:@"VC_TabBar_ID"];
}
+(id)getViewControllerWithIdentifier:(NSString*)identifier
{
    return [[[AppDelegate app] storyBoard] instantiateViewControllerWithIdentifier:identifier];
}
///关闭通知
+(void)setAppUnregisterForRemoteNotifications
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}
///注册通知
+(void)setAppRegisterForRemoteNotifications
{
    [[AppDelegate app] registerRemoteNotification];
}
///设置推送账号
-(void)setPushAccount
{
    NSString *userId = [AppSetting getUserDetauleId];
    NSString *md5UserId = [Utils stringMD5:userId];
    if ([AppSetting getAutoLogin]) {
        //取消别名
        [MiPushSDK unsetAlias:kOne];
        //设置账号
        [MiPushSDK setAccount:md5UserId];
    } else {
        //设置别名
        [MiPushSDK setAlias:kOne];
        //取消账号
        [MiPushSDK unsetAccount:md5UserId];
    }
#ifdef DEBUG
    NSLog(@"setPushAccount userId: %@, md5UserId: %@", userId, md5UserId);
#endif
}
///注销
-(void)logout
{
    GCDMainBlock(^{
        //退出登录
        [AppSetting setAutoLogin:NO];
        
        NSMutableArray *arrX = [AppSetting getHisLoginAccount];
        [arrX removeObject:kMOne];
        [arrX insertObject:kMOne atIndex:0];
        
        [AppSetting save];
        
        [AppSetting load:kMOne];
        
        ///处理实务-播放中判断
        [[AudioPlayerView shareAudioPlayerView] dismiss];
        [[AudioPlayerView shareAudioPlayerView] pause];
        
        [[ZDragButton shareDragButton] dismiss];
        
        ///设置推送账号
        [self setPushAccount];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZLoginChangeNotification object:nil];
    });
}
///去为APP评分
-(void)gotoAppStoreScore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:kApp_AppUrl]]];
}
///监听网络状态改变
-(void)setMonitorNetworkStatusChanges
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown://未识别的网络
            {
                break;
            }
            case AFNetworkReachabilityStatusNotReachable://不可达的网络(未连接)
            {
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN://2G,3G,4G...的网络
            {
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi://WiFi的网络
            {
                break;
            }
            default: break;
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
        switch (resp.errCode) {
            case WXSuccess:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPaySuccessNotification object:nil];
                break;
            }
            case WXErrCodeUserCancel:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayCancelNotification object:nil];
                [ZProgressHUD showError:kCMsgPayCancel];
                break;
            }
            case WXErrCodeAuthDeny:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
                [ZProgressHUD showError:kCMsgPayAuthDeny];
                break;
            }
            case WXErrCodeCommon:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
                [ZProgressHUD showError:kCMsgPayCommon];
                break;
            }
            case WXErrCodeSentFail:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
                [ZProgressHUD showError:kCMsgSendFail];
                break;
            }
            case WXErrCodeUnsupport:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
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
