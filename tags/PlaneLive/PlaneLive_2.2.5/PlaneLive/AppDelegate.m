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
#import <Zhugeio/Zhuge.h>
#import "WXApi.h"
#import "Bugout/Bugout.h"
#import "PlayerManager.h"
#import "DownloadManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ZNetworkPromptView.h"
#import "ZCatchCrash.h"
#import "ZAlertPromptView.h"
#import "ZBootViewController.h"
#import "ZPlayerViewController.h"
#import "ApplePayManager.h"
#import "PlayerTimeManager.h"
#import "GifManager.h"

@interface AppDelegate ()<SKStoreProductViewControllerDelegate,WXApiDelegate,UNUserNotificationCenterDelegate>

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
    //检测播放记录
    [self setCheckPlayList];
    //更新配置信息
    [self setRefreshAppConfig];
    //检测AppStore版本号
    [self checkAppStoreVersion];
    //启用推送
    [self registerPush:launchOptions];
    //注册Share分享
    [self registerShare];
    //UMeng统计
    [self registerStatistics];
    //TestinBugout
    [self setBugoutConfig];
    //诸葛IO
    [[Zhuge sharedInstance] startWithAppKey:kZhugeIO_AppKey launchOptions:launchOptions];
    //诸葛追踪用户
    [StatisticsManager eventIOUserInfo];
    //腾讯Bug收集
    [Bugly startWithAppId:kTencentBugly_AppId];
    ///设置Window属性
    [self.window setBackgroundColor:WHITECOLOR];
    [self.window makeKeyAndVisible];
    [self becomeFirstResponder];
    ///设置状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    //[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}
///已经进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self setAppEnterBackground:NO];
    
    [[AppDelegate getTabBarVC] setRefreshUserInfo];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}
///已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self setAppEnterBackground:YES];
    [[ZPlayerViewController sharedSingleton] setNowPlayingInfo];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
///远程控制播放器
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay: [[ZPlayerViewController sharedSingleton] setStartPlay]; break;
            case UIEventSubtypeRemoteControlPause: [[ZPlayerViewController sharedSingleton] setPausePlay]; break;
            case UIEventSubtypeRemoteControlTogglePlayPause: [[ZPlayerViewController sharedSingleton] setPausePlay]; break;
            case UIEventSubtypeRemoteControlPreviousTrack: [[ZPlayerViewController sharedSingleton] playPrevTrack]; break;
            case UIEventSubtypeRemoteControlNextTrack: [[ZPlayerViewController sharedSingleton] playNextTrack]; break;
            default: break;
        }
    }
}
///关闭时执行的事件
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[PlayerTimeManager shared] save];
    [[ApplePayManager sharedHelper] dismiss];
    [[XMReqMgr sharedInstance] closeXMReqMgr];
    [[DownloadManager sharedManager] pauseAllDownloads];
    [[DownloadManager sharedManager] setDownloadDelegate:nil];
    [AppSetting cancelMemory];
    [GifManager cancelMemory];
}
///屏幕支持方向设置
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}
///后台请求
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
}
///后台下载
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    completionHandler();
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

//iOS10-使用这个方法处理通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    //必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];
    //处理前后台业务逻辑
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self addLocationNotification:userInfo];
    } else {
        [PushManager setPushContentWithUserInfo:userInfo];
    }
}
//iOS7-10使用这个方法处理通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self application:application didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
//iOS10-本地通知处理回调方法
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState != UIApplicationStateActive) {
        [PushManager setPushContentWithUserInfo:notification.userInfo];
    }
}
//iOS10+处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10+处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //这个方法用来做action点击的统计
        [UMessage sendClickReportForRemoteNotification:userInfo];
        //下面写response.notification.request.identifier对各个交互式的按钮进行业务处理
        [PushManager setPushContentWithUserInfo:userInfo];
    }
    completionHandler();
}

#pragma mark - Application Registration Push Notification Service
/// 获取到用户设备TOKEN
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
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
    GBLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

#pragma mark - Application 3D Touch Event

#define k3DTouch_PublishQuestion_Key @"com.wutongsx.publishquestion"
#define k3DTouch_PlayPractice_Key @"com.wutongsx.playpractice"
#define k3DTouch_SearchQuestionAnswer_Key @"com.wutongsx.searchquestionanswer"
#define k3DTouch_SearchPractice_Key @"com.wutongsx.searchpractice"

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if (@available(iOS 9.0, *)) {
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
}
///添加3D Touch
-(void)createTouchItemsWithIcons
{
    if (@available(iOS 9.0, *)) {
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
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                GBLog(@"UNUserNotificationCenter completionHandler 授权");
            } else {
                GBLog(@"UNUserNotificationCenter completionHandler 拒绝 %@", error);
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    } /*else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }*/
}
///注册统计
- (void)registerStatistics
{
    UMConfigInstance.appKey = kUMeng_Appkey;
#ifdef DEBUG
    UMConfigInstance.ePolicy = REALTIME;
#else
    UMConfigInstance.ePolicy = SEND_INTERVAL;
#endif
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:APP_PROJECT_VERSION];
    [MobClick setCrashReportEnabled:NO];
    [MobClick setEncryptEnabled:YES];
}
///注册推送
- (void)registerPush:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:kUMeng_Appkey launchOptions:launchOptions httpsEnable:YES];
#ifdef DEBUG
    [UMessage setLogEnabled:YES];
    [UMessage openDebugMode:YES];
#endif
    [UMessage registerForRemoteNotifications];
    // 注册通知
    [self registerRemoteNotification];
}
///注册分享SDK
- (void)registerShare
{
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeYinXiang),
                                        @(SSDKPlatformTypeYouDaoNote)]
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
/// 添加本地通知
- (void)addLocationNotification:(NSDictionary *)userInfo
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (@available(iOS 10.0, *)) {
            NSString *requestIdentifer = @"kNotificationRequestIdentifer";
             [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[requestIdentifer]];
            NSDictionary *dicAPS =[userInfo objectForKey:@"aps"];
            if (dicAPS && [dicAPS isKindOfClass:[NSDictionary class]]) {
                // 创建通知内容
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                id alert = [dicAPS objectForKey:@"alert"];
                // 设置本地通知的属性
                if (alert && [alert isKindOfClass:[NSDictionary class]]) {
                    NSString *title = [(NSDictionary *)alert objectForKey:@"title"];
                    NSString *subtitle = [(NSDictionary *)alert objectForKey:@"subtitle"];
                    NSString *body = [(NSDictionary *)alert objectForKey:@"body"];
                    content.title = title == nil ? kEmpty : title;
                    content.subtitle = subtitle == nil ? kEmpty : subtitle;
                    content.body = body == nil ? kEmpty : body;
                } else if (alert && [alert isKindOfClass:[NSString class]]) {
                    content.body = alert;
                }
                content.userInfo = userInfo;
                //content.badge = @([UIApplication sharedApplication].applicationIconBadgeNumber+1);
                //content.sound = [UNNotificationSound defaultSound];
                // 触发模式
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:false];
                // 设置UNNotificationRequest
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                // 把通知加到UNUserNotificationCenter
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    GBLog(@"addNotificationRequest withCompletionHandler: %@", error);
                }];
            }
        } else {
            [[UIApplication sharedApplication] cancelLocalNotification:userInfo];
            NSDictionary *dicAPS =[userInfo objectForKey:@"aps"];
            if (dicAPS && [dicAPS isKindOfClass:[NSDictionary class]]) {
                // 创建一个本地通知的对象
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                id alert = [dicAPS objectForKey:@"alert"];
                // 设置本地通知的属性
                if (alert && [alert isKindOfClass:[NSDictionary class]]) {
                    NSString *title = [(NSDictionary *)alert objectForKey:@"title"];
                    NSString *body = [(NSDictionary *)alert objectForKey:@"body"];
                    localNotification.alertTitle = title;
                    localNotification.alertBody = body;
                } else if (alert && [alert isKindOfClass:[NSString class]]) {
                    localNotification.alertBody = alert;
                }
                localNotification.userInfo = userInfo;
                // 每隔2秒发送一个通知
                localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
                // 设置重复的次数
                localNotification.repeatInterval = 0;
                // 收到通知时播放的声音，默认消息声音
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                // 调用发送本地通知的方法
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
        }
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
        ZBootView *bootView = [[ZBootView alloc] init];
        ZWEAKSELF
        [bootView setOnStartClick:^{
            [sqlite setSysParam:kSQLITE_FRIST_START value:@"true"];
        }];
        [bootView setOnSkipClick:^{
            [sqlite setSysParam:kSQLITE_FRIST_START value:@"true"];
        }];
        [bootView show];
    }
}
///配置用户信息
-(void)setConfigUserInfo
{
    ///配置用户本地对象
    [AppSetting load];
    [AppSetting createFileDir];
    ///设置播放器
    [[ZPlayerViewController sharedSingleton] innerInit];
    ///配置下载路径
    [[DownloadManager sharedManager] settingDownloadAudioSaveDir:[AppSetting getDownloadFilePath]];
}
///刷新配置信息
-(void)setRefreshAppConfig
{
    if (!self.isCheckVersion) {
        ZWEAKSELF
        [sqlite delLocalAppConfig];
        [snsV1 getAppConfigWithAppVersion:APP_PROJECT_VERSION resultBlock:^(ModelAppConfig *currentVersion, ModelAppConfig *newVersion, ModelUser *userInfo) {
            [[AppDelegate app] setIsCheckVersion:YES];
            if (currentVersion) {
                if (currentVersion.appStatus == 0 && userInfo && !userInfo.userId.isEmpty) {
                    if (![AppSetting getAutoLogin]) {
                        [AppSetting setAutoLogin:YES];
                        [AppSetting setUserId:kUserAuditId];
                        [AppSetting setUserLogin:userInfo];
                        [AppSetting save];
                        
                        [AppSetting createFileDir];
                        [[AppDelegate app] login];
                    }
                }
                ///设置是否审核状态
                [[AppDelegate app] setIsAppAudit:currentVersion.appStatus==0];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZAppAuditStatusChangeNotification object:nil];
            }
            if (newVersion) {
                ///保存最新的状态
                [sqlite setLocalAppConfigWithModel:newVersion];
            }
        } errorBlock:nil];
    }
}
///检测AppStore版本
-(void)checkAppStoreVersion
{
    NSURL *url = [NSURL URLWithString:kApp_CheckVersionUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    ZWEAKSELF
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil || error) {
            return;
        }
        NSError *err;
        NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        if (err) {
            return;
        }
        NSArray *resultArray = [appInfoDict objectForKey:@"results"];
        if (resultArray == nil || ![resultArray count]) {
            return;
        }
        NSDictionary *infoDict = resultArray.firstObject;
        if (infoDict == nil || ![infoDict isKindOfClass:[NSDictionary class]]) {
            return;
        }
        //获取苹果服务器上应用的最新版本号
        NSString *updateVersion = infoDict[@"version"];
        ModelAppConfig *appConfig = [sqlite getLocalAppConfigModelWithId:updateVersion];
        if (appConfig == nil || appConfig.appVersion == nil) {
            return;
        }
        //更新的时候用到的地址
        NSString *trackViewUrl = infoDict[@"trackViewUrl"];
        trackViewUrl = trackViewUrl == nil ? kApp_AppUrl : trackViewUrl;
        NSString *updKey = [NSString stringWithFormat:@"appVersion%@", appConfig.appVersion];
        [weakSelf setAppUpdateKey:updKey];
        [weakSelf setAppUpdateValue:appConfig.appVersion];
        NSString *isUpd = [sqlite getSysParamWithKey:updKey];
        NSString *appVersion = APP_PROJECT_VERSION;
        //判断两个版本是否相同-不相同
        if (appVersion.doubleValue < updateVersion.doubleValue && isUpd.length == 0) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:appConfig.title message:appConfig.content preferredStyle:(UIAlertControllerStyleAlert)];
            ///稍后更新
            UIAlertAction *actionLater = [UIAlertAction actionWithTitle:kLaterUpdating style:(UIAlertActionStyleDefault) handler:nil];
            ///不再提示
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:kNoLongerUpdating style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [sqlite setSysParam:updKey value:appConfig.appVersion];
            }];
            ///马上更新
            UIAlertAction *actionNow = [UIAlertAction actionWithTitle:kRightNowUpdating style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
            }];
            [alertVC addAction:actionLater];
            [alertVC addAction:actionCancel];
            [alertVC addAction:actionNow];
            GCDMainBlock(^{
                [[weakSelf getTabBarVC] presentViewController:alertVC animated:NO completion:nil];
            });
        }
    }];
    [task resume];
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
///设置Bugout开关
-(void)setBugoutOn:(BOOL)on
{
    [Bugout enabledShakeFeedback:on];
}
///设置Bugout功能
-(void)setBugoutConfig
{
    BugoutConfig *config = [BugoutConfig defaultConfig];
    config.enabledShakeFeedback = [AppSetting getBugoutOn];
    [Bugout init:kBugout_AppKey channel:@"channel" config:config];
}
///调用微信公众号
-(void)showJumpToBizProfile
{
    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc] init];
    req.profileType =WXBizProfileType_Normal;
    req.username = kWeChatCustomerServiceNumber;
    [WXApi sendReq:req];
}
///设置umeng别名
- (void)setUMengAlias
{
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        NSString *userId = kLoginUserId;
        NSString *md5UserId = [Utils stringMD5:userId];
        GBLog(@"setUMengAlias userId: %@, md5UserId: %@", userId, md5UserId);
        [UMessage setAlias:md5UserId type:kUMeng_Type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            GBLog(@"setAlias responseObject: %@, error: %@", responseObject, error);
        }];
    } else {
        [self removeUMengAlias];
    }
    GBLog(@"DeviceToken: %@", self.devTokenStr);
}
///删除umeng别名
- (void)removeUMengAlias
{
    NSString *userId = kLoginUserId;
    NSString *md5UserId = [Utils stringMD5:userId];
    GBLog(@"removePushAccount userId: %@, md5UserId: %@", userId, md5UserId);
    [UMessage removeAlias:md5UserId type:kUMeng_Type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        GBLog(@"removeAlias responseObject: %@, error: %@", responseObject, error);
    }];
}
///设置推送账号
-(void)setPushAccount
{
    if (self.devTokenStr.length > 0) {
        [self setUMengAlias];
    }
}
///重置选中项目
-(void)setSelectTabbarFirstOne
{
    [[[AppDelegate app] getTabBarVC] logout];
}
///注销登录
-(void)logout
{
    ///设置推送账号
    [self removeUMengAlias];
    [AppSetting del];
    if (self.isAppAudit) {
        [AppSetting loadAuditUser];
    }
    if ([ShareSDK hasAuthorized:(SSDKPlatformTypeWechat)]) {
        [ShareSDK cancelAuthorize:(SSDKPlatformTypeWechat)];
    }
    [self loginChange];
}
///登录成功
-(void)login
{
    ///设置推送账号
    [self setPushAccount];
    [self loginChange];
}
-(void)loginChange
{
    [[PlayerManager sharedPlayer] stopTrackPlay];
    [self setCheckPlayList];
    [[ZPlayerViewController sharedSingleton] setModelTrack:nil];
    [[ZPlayerViewController sharedSingleton] setModelPractice:nil];
    [[ZPlayerViewController sharedSingleton] setModelCurriculum:nil];
    [[ZPlayerViewController sharedSingleton] setArrayTrack:nil];
    [[ZPlayerViewController sharedSingleton] setArrayRawdata:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLoginChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
}
///检查是否播放过
-(void)setCheckPlayList
{
    NSArray *arrP = [sqlite getLocalPlayListPracticeWithUserId:kLoginUserId];
    if (arrP && arrP.count > 0) {
        self.isPlay = YES;
    } else {
        NSArray *arrC = [sqlite getLocalPlayListSubscribeCurriculumWithUserId:kLoginUserId];
        if (arrC && arrC.count > 0) {
            self.isPlay = YES;
        } else {
            self.isPlay = NO;
        }
    }
}
///去APP更新
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
//    if ([resp isKindOfClass:[PayResp class]]) {
//        PayResp *payResp = (PayResp*)resp;
//        switch (payResp.errCode) {
//            case WXSuccess:
//            {
//                [ZProgressHUD dismiss];
//                [[NSNotificationCenter defaultCenter] postNotificationName:ZPaySuccessNotification object:payResp];
//                break;
//            }
//            case WXErrCodeUserCancel:
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayCancelNotification object:payResp];
//                [ZProgressHUD dismiss];
//                [ZProgressHUD showError:kCMsgPayCancel];
//                break;
//            }
//            case WXErrCodeAuthDeny:
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:payResp];
//                [ZProgressHUD dismiss];
//                [ZProgressHUD showError:kCMsgPayAuthDeny];
//                break;
//            }
//            case WXErrCodeCommon:
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:payResp];
//                [ZProgressHUD dismiss];
//                [ZProgressHUD showError:kCMsgPayCommon];
//                break;
//            }
//            case WXErrCodeSentFail:
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:payResp];
//                [ZProgressHUD dismiss];
//                [ZProgressHUD showError:kCMsgSendFail];
//                break;
//            }
//            case WXErrCodeUnsupport:
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:ZPayFailNotification object:payResp];
//                [ZProgressHUD dismiss];
//                [ZProgressHUD showError:kCMsgPayNotSupported];
//                break;
//            }
//        }
//    } else
    if ([resp isKindOfClass:[SendAuthResp class]]) {
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

//#pragma mark - ZAlertViewDelegate
//
//-(void)alertView:(ZAlertView *)alertView didButtonClickWithIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0: break;
//        case 1: [sqlite setSysParam:self.appUpdateKey value:self.appUpdateValue]; break;
//        case 2: [[AppDelegate app] gotoAppStoreScore]; break;
//        default:break;
//    }
//}


@end
