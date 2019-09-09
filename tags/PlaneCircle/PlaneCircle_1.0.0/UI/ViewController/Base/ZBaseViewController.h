//
//  ZBaseViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZNavigationViewController.h"
#import "ZBaseTVC.h"
#import "ZShareView.h"
#import "ZSpaceTVC.h"
#import "ZBaseTableView.h"

#import "ModelImage.h"

#define ZWEAKSELF typeof(self) __weak weakSelf = self;

@interface ZBaseViewController : UIViewController

#pragma mark - PublicVariable

///记录ViewController是否消失 YES未消失,NO消失
@property (assign, nonatomic) BOOL isDisappear;
///记录ViewController是否已经加载 YES加载,NO未加载
@property (assign, nonatomic) BOOL isLoaded;

#pragma mark - PublicMethod

///设置View标题
-(void)setViewTitle:(NSString *)title;

///回收内存
-(void)setViewNil;

///设置数据模型
-(void)setViewDataWithModel:(ModelEntity *)model;

///显示问题详情界面
-(void)showQuestionDetailVC:(ModelQuestionBase *)model;

///显示答案详情界面
-(void)showAnswerDetailVC:(ModelAnswerBase *)model;

///显示用户详情界面
-(void)showUserProfileVC:(ModelUserBase *)model;

///显示登录界面
-(void)showLoginVC;

#pragma mark - NavigationButtonMethod

///设置取消按钮
-(void)setCancelButton;
///取消按钮点击事件
-(void)btnCancelClick;
///设置右边按钮->分享按钮
-(void)setRightButtonWithShare;
///设置右边按钮->播放按钮
-(void)setRightButtonWithPlay;
///设置右边按钮->图片名称
-(void)setRightButtonWithImage:(NSString*)image;
///设置右边按钮->文字内容
-(void)setRightButtonWithText:(NSString*)text;
///右边按钮点击事件
-(void)btnRightClick;

#pragma mark - ShareEvent

///微信分享
-(void)btnWeChatClick;
///微信朋友圈分享
-(void)btnWeChatCircleClick;
///QQ好友分享
-(void)btnQQClick;
///QQ空间分享
-(void)btnQZoneClick;
///通用分享内容
-(void)shareWithType:(WTPlatformType)type;

#pragma mark - KeyboardNotification

///注册键盘通知
-(void)registerKeyboardNotification;

///移除键盘通知
-(void)removeKeyboardNotification;

#pragma mark - KeyboardNotificationMethod

///键盘高度改变事件
-(void)keyboardFrameChange:(CGFloat)height;

#pragma mark - LoginChangeNotification

///注册登录改变通知
-(void)registerLoginChangeNotification;
///移除登录改变通知
-(void)removeLoginChangeNotification;
///发送登录改变通知
-(void)postLoginChangeNotification;

#pragma mark - LoginChangeNotificationMethod

///登录改变应该做的事情
-(void)setLoginChange;

#pragma mark - UserInfoChangeNotification

///注册用户信息改变通知
-(void)registerUserInfoChangeNotification;
///移除用户信息改变通知
-(void)removeUserInfoChangeNotification;
///发送用户信息改变通知
-(void)postUserInfoChangeNotification;

#pragma mark - UserInfoChangeNotificationMethod

///用户信息改变应该做的事情
-(void)setUserInfoChange;

#pragma mark - PublishQuestionNotification

-(void)registerPublishQuestionNotification;

-(void)removePublishQuestionNotification;

-(void)postPublishQuestionNotification;
///首页切换到对应模块 0推荐,1动态,2最新,3关注
-(void)postPublishQuestionNotificationWithIndex:(int)index;

#pragma mark - PublishQuestionNotificationMethod

-(void)setPublishQuestion:(NSNotification *)sender;
-(void)setPublishQuestion;

@end
