//
//  ZAlertView.h
//  Product
//
//  Created by Daniel on 15/8/3.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//


#import <UIKit/UIKit.h>

@class ZAlertView;

@protocol ZAlertViewDelegate <NSObject>

@required
- (void)alertView:(ZAlertView *)alertView didButtonClickWithIndex:(NSInteger)buttonIndex;

@end

@interface ZAlertView : UIView

///回调协议
@property (nonatomic,assign) id<ZAlertViewDelegate>delegate;
///按钮点击回调事件
@property (nonatomic, copy) void(^onDialogViewCompleteHandle)(ZAlertView *view, NSInteger index);

///两个按钮纯文本显示（block回调方式）
-(id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

///一个按钮调用显示方法
-(void)show;
///多个按钮调用显示方法
-(void)showWithCompletion:(void (^)(ZAlertView *alertView ,NSInteger selectIndex))completeBlock;
///多个按钮调用显示方法
-(void)showInView:(UIView *)baseView completion:(void (^)(ZAlertView *alertView ,NSInteger selectIndex))completeBlock;

///关闭View
-(void)closeView;

///设置内容位置
-(void)setMessageTextAlignment:(NSTextAlignment)textAlignment;

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

