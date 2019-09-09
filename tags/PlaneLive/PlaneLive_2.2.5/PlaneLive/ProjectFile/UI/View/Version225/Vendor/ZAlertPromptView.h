//
//  ZAlertPromptView.h
//  PlaneLive
//
//  Created by Daniel on 08/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZAlertPromptView : ZView

///确认按钮点击
@property (copy, nonatomic) void(^onConfirmationClick)();
///取消按钮点击
@property (copy, nonatomic) void(^onCloseClick)();

///显示两个按钮 - 自定义加入层
+(void)showInView:(UIView *)view title:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText completionBlock:(void (^)(void))completionBlock closeBlock:(void (^)(void))closeBlock;
///显示两个按钮 - 自定义标题,内容,按钮
+(void)showWithTitle:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText completionBlock:(void (^)(void))completionBlock closeBlock:(void (^)(void))closeBlock;
///显示两个按钮 - 提示,自定义内容,按钮
+(void)showWithMessage:(NSString *)message buttonText:(NSString *)buttonText completionBlock:(void (^)(void))completionBlock closeBlock:(void (^)(void))closeBlock;
///显示两个按钮 - 提示,确定,自定义内容
+(void)showWithMessage:(NSString *)message completionBlock:(void (^)(void))completionBlock closeBlock:(void (^)(void))closeBlock;
///显示两个按钮 - 提示,确定,自定义内容
+(void)showWithMessage:(NSString *)message;

@end
