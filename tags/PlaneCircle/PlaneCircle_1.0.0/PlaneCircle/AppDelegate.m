//
//  AppDelegate.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AppDelegate.h"

#import "WXApi.h"
#import "XGPush.h"

#import <UMMobClick/MobClick.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import <StoreKit/SKStoreProductViewController.h>

#define kCHECK_HUHUSERVER_URL @"http://www.apple.com"

@interface AppDelegate ()<SKStoreProductViewControllerDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //配置基本属性
    [self setAppEnterBackground:NO];
    [self setOpenUrlType:(WTOpenURLTypeNone)];
    [self setStoryBoard:[UIStoryboard storyboardWithName:@"Main" bundle:nil]];
    
    //配置本地登录用户
    [AppSetting load:kMOne];
    NSMutableArray *arrHisLoginAcc = [AppSetting getHisLoginAccount];
    if (arrHisLoginAcc.count > 0) {[AppSetting load:arrHisLoginAcc.firstObject];}
    [AppSetting createCommonFileDir];
    [AppSetting createPersonalFileDir];
    
    //注册Share分享
    [self registerShare];
    
    //友盟统计
    UMAnalyticsConfig *umConfig = [[UMAnalyticsConfig alloc] init];
    [umConfig setAppKey:kUMeng_Appkey];
    [umConfig setEPolicy:BATCH];
    [MobClick startWithConfigure:umConfig];
    
    //注册通知
    [self registerRemoteNotification];
    
    //注册推送通知
    [XGPush startApp:kXGPush_AppId appKey:kXGPush_AppKey];
    [XGPush handleLaunching:launchOptions];
    
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [application setStatusBarStyle:(UIStatusBarStyleLightContent)];
    
    return YES;
}
///已经进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self clearApplicationIcon];
    [self setAppEnterBackground:NO];
    
    [self setRefreshAppConfig];
    
    [application endReceivingRemoteControlEvents];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
///已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self setAppEnterBackground:YES];
    
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
//    if ([url.host isEqualToString:kALI_Auth_URLHost_Key]) {
//        [AlipayManager processOrderWithPaymentResult:url standbyCallback:^(ModelOrderALIResult *result) {
//            dispatch_async(dispatch_get_main_queue(),^{
//                [[AppDelegate app] setOpenUrlType:(WTOpenURLTypeNone)];
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
//        return YES;
//    }
    if ([url.host isEqualToString:kMy_AppScheme_Host]) {
        [PushManager setPushViewControllerWithUrl:url];
        return YES;
    }
    if (self.openUrlType==WTOpenURLTypeWechat) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

#pragma mark - Application Local And Push Notification

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState != UIApplicationStateActive) {
        [PushManager setPushContentWithUserInfo:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [XGPush handleReceiveNotification:userInfo];
    if (application.applicationState != UIApplicationStateActive) {
        [PushManager setPushContentWithUserInfo:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

#pragma mark - Application Registration Push Notification Service

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.devTokenStr = [XGPush registerDevice:deviceToken];
    if (self.devTokenStr) {
        [sqlite setSysParam:kSQLITE_DEVICE_TOKEN value:self.devTokenStr];
        
        [XGPush setAccount:[Utils stringMD5:[AppSetting getUserDetauleId]]];
        
        GBLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", self.devTokenStr);
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    GBLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

#pragma mark - Application BackgroundFetchResult

//- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//
//}

#pragma mark - PrivateMethod

- (void)clearApplicationIcon
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
///注册通知
- (void)registerRemoteNotification
{
    if (APP_SYSTEM_VERSION >= 8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
///注册分享SDK
- (void)registerShare
{
    [ShareSDK registerApp:kShare_AppKey
           activePlatforms:@[@(SSDKPlatformTypeWechat),
                             @(SSDKPlatformTypeQQ)
//                             @(SSDKPlatformTypeYinXiang),
//                             @(SSDKPlatformTypeYouDaoNote)
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
//                         case SSDKPlatformTypeYouDaoNote:
//                             [appInfo SSDKSetupYouDaoNoteByConsumerKey:kYouDaoNote_AppKey
//                                                        consumerSecret:kYouDaoNote_AppSecret
//                                                         oauthCallback:kYouDaoNote_RedirectUri];
//                             break;
//                         case SSDKPlatformTypeYinXiang:
//                             [appInfo SSDKSetupEvernoteByConsumerKey:kYinXiang_AppKey
//                                                      consumerSecret:kYinXiang_AppSecret
//                                                             sandbox:YES];
//                             break;
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

-(void)setRefreshAppConfig
{
    NSString *appVsersion = APP_PROJECT_VERSION;
    [sns getAppConfigWithAppVersion:appVsersion resultBlock:^(ModelAppConfig *result) {
        GCDMainBlock(^{
            [sqlite setLocalAppConfigWithModel:result];
        });
    } errorBlock:nil];
}

#pragma mark - PublicMethod

+(AppDelegate *)app
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(id)getViewControllerWithIdentifier:(NSString*)identifier
{
    return [[[AppDelegate app] storyBoard] instantiateViewControllerWithIdentifier:identifier];
}

///退出登录
-(void)logout
{
    GCDAfterBlock(0.1f,^(void){
        [AppSetting setAutoLogin:NO];
        [AppSetting save];
        [AppSetting load:kMOne];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZLoginChangeNotification object:nil];
    });
}

///去为APP评分
-(void)gotoAppStoreScore
{
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    [storeProductVC setDelegate:self];
    [storeProductVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:kApp_AppId} completionBlock:nil];
    [[[AppDelegate app] window].rootViewController presentViewController:storeProductVC animated:YES completion:nil];
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
        [[AppDelegate app] setOpenUrlType:(WTOpenURLTypeNone)];
        switch (resp.errCode) {
            case WXSuccess:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPaySuccessNotification object:nil];
                break;
            }
            case WXErrCodeUserCancel:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayCancelNotification object:nil];
                [ZProgressHUD showError:@"取消支付"];
                break;
            }
            case WXErrCodeAuthDeny:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
                [ZProgressHUD showError:@"授权失败"];
                break;
            }
            case WXErrCodeCommon:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
                [ZProgressHUD showError:@"支付错误"];
                break;
            }
            case WXErrCodeSentFail:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
                [ZProgressHUD showError:@"发送失败"];
                break;
            }
            case WXErrCodeUnsupport:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:nil];
                [ZProgressHUD showError:@"微信不支持"];
                break;
            }
        }
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 10:
        {
            switch (buttonIndex)
            {
                case 1:
                {
                    [self gotoAppStoreScore];
                    break;
                }
                default:break;
            }
            break;
        }
        case 11:
        {
            switch (buttonIndex)
            {
                case 1:
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id%@?mt=8",kApp_AppId]]];
                    break;
                }
                default:break;
            }
            break;
        }
        default:break;
    }
}

@end