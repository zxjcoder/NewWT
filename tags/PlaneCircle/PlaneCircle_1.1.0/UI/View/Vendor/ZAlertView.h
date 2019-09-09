//
//  ZAlertView.h
//  Product
//
//  Created by Daniel on 15/8/3.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZAlertViewStyle)
{
    ///默认提示框
    ZAlertViewStyleDefault = 0,
    ///可输入密码提示框
    ZAlertViewStyleSecureTextInput,
    ///可输入文本提示框
    ZAlertViewStylePlainTextInput,
    ///可输入登录信息提示框
    ZAlertViewStyleLoginAndPasswordInput
};

@interface ZAlertView : UIView

///允许连续提示
@property (nonatomic, assign) BOOL seriesAlert;
///提示框样式
@property (nonatomic, assign) ZAlertViewStyle alertViewStyle;

///两个按钮纯文本显示（block回调方式）
-(id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

///一个按钮调用显示方法
-(void)show;
///多个按钮调用显示方法
-(void)showWithCompletion:(void (^)(ZAlertView *alertView ,NSInteger selectIndex))completeBlock;
///多个按钮调用显示方法
-(void)showInView:(UIView *)baseView completion:(void (^)(ZAlertView *alertView ,NSInteger selectIndex))completeBlock;

///获取指定的textField的内容
-(NSString *)textWithTextFieldIndex:(NSInteger)textFieldIndex;

///显示一个按钮
+(void)showWithMessage:(NSString*)message;
///显示一个按钮
+(void)showWithMessage:(NSString*)message completion:(void (^)(void))completion;
///显示两个按钮
+(void)showWithMessage:(NSString*)message doneCompletion:(void (^)(void))doneCompletion;
///显示多个按钮
+(void)showWithMessage:(NSString *)message completion:(void (^)(ZAlertView *alertView, NSInteger selectIndex))completion cancelTitle:(NSString*)cancelTitle doneTitle:(NSString*)doneTitle;

///显示两个按钮
+(void)showWithTitle:(NSString *)title message:(NSString *)message doneCompletion:(void (^)(void))doneCompletion;
///显示多个按钮
+(void)showWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(ZAlertView *alertView, NSInteger selectIndex))completion cancelTitle:(NSString*)cancelTitle doneTitle:(NSString*)doneTitle;

@end

