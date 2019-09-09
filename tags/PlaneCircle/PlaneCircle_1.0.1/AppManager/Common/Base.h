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
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#ifdef DEBUG  // 调试状态
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

//透明色
#define CLEARCOLOR [UIColor clearColor]
//黑色
#define BLACKCOLOR RGBCOLOR(0, 0, 0)
#define BLACKCOLOR1 RGBCOLOR(60, 60, 60)
#define BLACKCOLOR2 RGBCOLOR(89, 89, 89)
//橙色
#define ORANGECOLOR RGBCOLOR(231, 181, 136)
//白色
#define WHITECOLOR RGBCOLOR(255, 255, 255)
//灰色
#define GRAYCOLOR  RGBCOLOR(165, 165, 165)

//主色调
#define MAINCOLOR RGBCOLOR(253, 107, 0)
//描述文字颜色
#define DESCCOLOR RGBCOLOR(143, 143, 143)
//删除
#define DELECOLOR RGBCOLOR(243, 184, 141)

//视图背景颜色->白色
#define VIEW_BACKCOLOR1 RGBCOLOR(255, 255, 255)
//视图背景颜色->灰色
#define VIEW_BACKCOLOR2 RGBCOLOR(242, 242, 242)

//表格CELL背景色
#define TABLEVIEWCELL_BACKCOLOR [UIColor clearColor]
//表格分割线颜色->细线
#define TABLEVIEWCELL_LINECOLOR RGBCOLOR(222, 222, 222)
//表格分割线颜色->粗线
#define TABLEVIEWCELL_TLINECOLOR RGBCOLOR(242, 242, 242)

//导航栏背景颜色
#define NAVIGATION_BACKCOLOR1 MAINCOLOR
//导航栏文字颜色
#define NAVIGATION_BACKCOLOR2 RGBCOLOR(255, 255, 255)

//Tabbar背景颜色
#define TABBARTINT_BACKCOLOR1 RGBCOLOR(255, 255, 255)
//Tabbar文字颜色
#define TABBARTINT_BACKCOLOR2 MAINCOLOR

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

//TABBAR高度
#define APP_TABBAR_HEIGHT 49

//输入框高度
#define APP_INPUT_HEIGHT 50
//播放器高度
#define APP_PLAY_HEIGHT 60

//顶部高度
#define APP_TOP_HEIGHT 64
//导航栏高度
#define APP_NAVIGATION_HEIGHT 44

//View宽度-不包括状态栏
#define APP_FRAME_WIDTH [[UIScreen mainScreen] applicationFrame].size.width
//View高度-不包括状态栏
#define APP_FRAME_HEIGHT [[UIScreen mainScreen] bounds].size.height

///VIEW视图铺满屏幕[包括导航栏高度]
#define VIEW_MAIN_FRAME CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)
///VIEW视图铺满屏幕[不包括导航栏高度&不包括TABBAR]
#define VIEW_TABB_FRAME CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_TABBAR_HEIGHT)
///VIEW视图铺满屏幕[不包括导航栏高度]
#define VIEW_ITEM_FRAME CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT)
///VIEW视图导航屏幕[包括导航栏高度]
#define VIEW_NAVV_FRAME CGRectMake(0, 0, APP_FRAME_WIDTH, APP_TOP_HEIGHT)

//手机操作系统版本
#define APP_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//应用项目版本
#define APP_PROJECT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_PROJECT_BUNDID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//应用项目
#define APP_PROJECT_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey]

//是否模拟器
#define IsSimulatorDevice (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
//是否IPad
#define IsIPadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//是否IPhone
#define IsIPhoneDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

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

