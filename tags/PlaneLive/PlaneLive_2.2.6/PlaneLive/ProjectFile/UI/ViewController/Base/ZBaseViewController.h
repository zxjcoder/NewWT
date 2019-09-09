//
//  ZBaseViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZBaseTVC.h"
#import "ZAlertShareView.h"
#import "ZSpaceTVC.h"
#import "ZBaseTableView.h"
#import "ModelImage.h"
#import "StatisticsManager.h"
#import "ZScrollView.h"
#import "ZGlobalPlayView.h"

#define kNavPlayButtonTag 1000100010
#define kNavPlayButtonWidth 55

@interface ZBaseViewController : UIViewController

#pragma mark - PublicProperty

/// 记录ViewController是否消失 YES消失,NO未消失
@property (assign, nonatomic) BOOL isDisappear;
/// 记录ViewController是否已经加载 YES加载,NO未加载
@property (assign, nonatomic) BOOL isLoaded;
/// 是否弹出登录窗口 YES弹出过,NO未弹出
@property (assign, nonatomic) BOOL isShowLogin;
/// 是否需要重新刷新数据 YES需要,NO不需要
@property (assign, nonatomic) BOOL isRefreshData;
/// 隐藏播放按钮
@property (assign, nonatomic) BOOL isDismissPlay;
/// 处理重复点击选择图片完成按钮
@property (assign, nonatomic) BOOL isSelectPhotoStart;
/// 导航条View
@property (nonatomic, weak) UIView *navBarView;
/// 播放视图
@property (nonatomic, strong) ZGlobalPlayView *viewPlay;

#pragma mark - PublicMethod

///初始化基类
-(void)innerInit;
///初始化播放视图
-(void)innerPlayInit;
///导航栏设置透明
-(void)setNavBarAlpha:(CGFloat)alpha;
///导航栏分割线设置透明
-(void)setNavBarLineAlpha:(CGFloat)alpha;

///回收内存
-(void)setViewNil;

///设置数据模型
-(void)setViewDataWithModel:(ModelEntity *)model;

///显示登录界面
-(void)showLoginVC;

///显示图片浏览
-(void)showPhotoBrowserWithArray:(NSArray *)array index:(NSInteger)index;

///设置历史播放列表
-(void)setHistoryPlay;
///显示播放界面
-(void)setShowPlayVC;
///显示播放界面
-(void)setShowPlayVC:(BOOL)animated;

///显示播放界面-实务
-(void)showPlayVCWithPracticeArray:(NSArray *)array index:(NSInteger)index;

///显示播放界面-发现
//-(void)showPlayVCWithFoundArray:(NSArray *)array index:(NSInteger)index;

///显示播放界面-订阅
-(void)showPlayVCWithCurriculumArray:(NSArray *)array index:(NSInteger)index;

///显示新闻界面
-(void)showWebVCWithUrl:(NSString *)url title:(NSString *)title;
///显示网页界面
-(void)showWebVCWithModel:(ModelBanner *)model;

///显示他人用户界面
-(void)showUserProfileVC:(ModelUserBase *)model;
///显示用户详情界面
-(void)showUserProfileVC:(ModelUserBase *)model preVC:(id)preVC;

///显示问题详情界面
-(void)showQuestionDetailVC:(ModelQuestionBase *)model;

///删除问题回调方法
-(void)setDeleteQuestion:(ModelQuestionBase *)model;

///显示答案详情界面
-(void)showAnswerDetailVC:(ModelAnswerBase *)model;

///删除问题回调
-(void)setDeleteAnswer:(ModelAnswerBase *)model;

///显示答案详情界面
-(void)showAnswerDetailVC:(ModelAnswerBase *)model defaultCommentModel:(ModelAnswerComment *)modelAC;

#pragma mark - NavigationButtonMethod

///设置返回按钮->触发事件BackClick
-(void)setBackButtonWithLeft;
///设置返回按钮->触发事件LeftClick
-(void)setBackButtonWithClose;
///设置右边分享按钮
-(void)setRightShareButton;
///设置右边分享购物车按钮
-(void)setRightShareCartButton;
///设置右边搜索按钮
-(void)setRightButtonWithSearch;
///设置右边按钮->图片名称
-(void)setRightButtonWithImage:(NSString*)image;
///设置右边按钮->文字内容
-(void)setRightButtonWithText:(NSString*)text;
///设置左边按钮->图片名称
-(void)setLeftButtonWithImage:(NSString*)image;
///设置左边按钮->文字名称
-(void)setLeftButtonWithText:(NSString*)text;

///右边按钮点击事件
-(void)btnRightClick;
///购物车按钮点击事件
-(void)btnCartClick;
///分享按钮点击事件
-(void)btnShareClick;
///左边按钮点击事件
-(void)btnLeftClick;
///返回按钮点击事件
-(void)btnBackClick;
///搜索按钮点击事件
-(void)btnSearchClick;

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
///有道云笔记
-(void)btnYouDaoClick;
///印象笔记
-(void)btnYinXiangClick;
///举报
-(void)btnReportClickWithId:(NSString *)ids type:(ZReportType)type;

#pragma mark - KeyboardNotification

///注册键盘通知
-(void)registerKeyboardNotification;

///移除键盘通知
-(void)removeKeyboardNotification;

#pragma mark - KeyboardNotificationMethod

///键盘高度改变事件
-(void)keyboardFrameChange:(CGFloat)height;

#pragma mark - TextFieldTextDidChangeNotification

///注册文本输入框内容改变事件
-(void)registerTextFieldTextDidChangeNotification;

///移出文本输入框内容改变事件
-(void)removeTextFieldTextDidChangeNotification;

#pragma mark - TextFieldTextDidChangeNotificationMethod

///输入框内容改变事件回调
-(void)textFieldDidChange:(NSNotification *)sender;
///输入框内容改变事件回调
-(void)textFieldTextDidChange:(UITextField *)textField;

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

#pragma mark - FontSizeChangeNotification

///注册字体大小改变通知
-(void)registerFontSizeChangeNotification;
///移除字体大小改变通知
-(void)removeFontSizeChangeNotification;
///发送字体大小改变通知
-(void)postFontSizeChangeNotification;

#pragma mark - PublishQuestionNotificationMethod
///TODO:ZWW备注-设置字体大小改变
-(void)setFontSizeChange;

#pragma mark - PublishQuestionNotification
///注册问题信息改变通知
-(void)registerPublishQuestionNotification;
///移除问题信息改变通知
-(void)removePublishQuestionNotification;
///发送问题信息改变通知
-(void)postPublishQuestionNotification;
///发送问题信息改变通知->新问题对象
-(void)postPublishQuestionNotificationWithModel:(ModelQuestion *)model;

#pragma mark - PublishQuestionNotificationMethod
///问题信息改变通知回调
-(void)setPublishQuestion:(NSNotification *)sender;
///问题信息改变通知回调
-(void)setPublishQuestion;

@end
