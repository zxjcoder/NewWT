//
//  Base.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//


#if ! __has_feature(objc_arc)
#define OBJC_RELEASE(x) if (x != nil) [x release]; x = nil;
#else
#define OBJC_RELEASE(x) x = nil;
#endif

#define OBJC_RELEASE_TIMER(tmr) [tmr invalidate]; OBJC_RELEASE(tmr)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBCOLORA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#ifdef DEBUG  // 调试状态
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#define NSLogFrame(frame) NSLog(@"frame[X=%.2f,Y=%.2f,W=%.2f,H=%.2f]", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
#define NSLogPoint(point) NSLog(@"Point[X=%.2f,Y=%.2f]", point.x, point.y)
#define NSLogSize(size) NSLog(@"Size[W=%.2f,H=%.2f]", size.width, size.height)
// 打开LOG功能
#define GBLog(...) NSLog(__VA_ARGS__)
#else // 发布状态
// 关闭LOG功能
#define NSLogFrame(frame)
#define NSLogPoint(point)
#define NSLogSize(size)
#define GBLog(...)
#endif

#define ZWEAKSELF __weak typeof(self) weakSelf = self;

//是否模拟器
#define IsSimulatorDevice (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
//是否IPad
#define IsIPadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//是否IPhone
#define IsIPhoneDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//是否默认宽度
#define IsIPhoneDefaultW ([[UIScreen mainScreen] bounds].size.width == 320)
//是否IPhone4
#define IsIPhone4 ([[UIScreen mainScreen] bounds].size.width == 320 && [[UIScreen mainScreen] bounds].size.height == 480)
//是否IPhoneX
#define IsIPhoneX ([[UIScreen mainScreen] bounds].size.width == 375 && [[UIScreen mainScreen] bounds].size.height == 812)

//弹出框背景透明度值
#define kBackgroundOpacity 0.7
//动画时间
#define kANIMATION_TIME 0.25f
//广告滚动时间
#define kANIMATION_BANNER_TIME 5.0f
//等待超时时间
#define kTIMEOUT_INTERVAL_TIME 15.0

//View边框Round
#define kVIEW_ROUND_SIZE 3.0f
//View边框宽度
#define kVIEW_BORDER_SIZE 1.0f
//View边框Round
#define kIMAGE_ROUND_SIZE 6.0f

//TABBAR高度
#define APP_TABBAR_HEIGHT 49//(IsIPhoneX ? 83 : 49)
//输入框高度
#define APP_INPUT_HEIGHT 50
//播放器高度
#define APP_PLAY_HEIGHT 60
//底部操作栏高度
#define APP_BOTTOM_HEIGHT 50

//状态栏高度
#define APP_STATUS_HEIGHT (IsIPhoneX ? 44 : 20)
//导航栏高度
#define APP_NAVIGATION_HEIGHT 44
//顶部高度
#define APP_TOP_HEIGHT (APP_NAVIGATION_HEIGHT + APP_STATUS_HEIGHT)

//View宽度-不包括状态栏
#define APP_FRAME_WIDTH [[UIScreen mainScreen] bounds].size.width
//View高度-不包括状态栏
#define APP_FRAME_HEIGHT (IsIPhoneX ? 778 : [[UIScreen mainScreen] bounds].size.height)

///VIEW视图铺满屏幕[包括导航栏高度]
#define VIEW_MAIN_FRAME CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)
///VIEW视图铺满屏幕[不包括导航栏高度&不包括TABBAR]
#define VIEW_TABB_FRAME CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TABBAR_HEIGHT-APP_TOP_HEIGHT)
///VIEW视图铺满屏幕[不包括导航栏高度]
#define VIEW_ITEM_FRAME CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT)
///VIEW视图导航屏幕[包括导航栏高度]
#define VIEW_NAVV_FRAME CGRectMake(0, 0, APP_FRAME_WIDTH, APP_TOP_HEIGHT)

//手机操作系统版本
#define APP_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//应用项目版本
#define APP_PROJECT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_PROJECT_BUNDID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//应用ID
#define APP_PROJECT_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey]
//应用名称
#define APP_PROJECT_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]

//系统功能
#define MailSend(email) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",email]]])
#define PhoneCall(phone) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]])
#define PhoneCallAuto(phone) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phone]]])
#define SMSSend(phone) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phone]]])
#define SafariOpen(url) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]])

//GCD-BLOCK
#define GCDGlobalBlock(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCDMainBlock(block) \
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#define GCDPopTime(delayInSeconds) dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC))
#define GCDAfterBlock(delayInSeconds,block) dispatch_after(GCDPopTime(delayInSeconds), dispatch_get_main_queue(), block)


#import "DataOperManager.h"
#import "MessageManager.h"
#import "EnumManager.h"
#import "AppKeyManager.h"
#import "SQLiteKeyManager.h"
#import "RegexKeyManager.h"
#import "FormatKeyManager.h"
#import "NumberKeyManager.h"
#import "FontKeyManager.h"
#import "PushKeyManager.h"
#import "EventKeyManager.h"
#import "ColorManager.h"
#import "SizeManager.h"
#import "ZFont.h"
//#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>




