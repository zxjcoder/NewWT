//
//  ZAlertEditView.h
//  PlaneCircle
//
//  Created by Daniel on 6/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZAlertEditView : UIView

///确定点击
@property (copy, nonatomic) void(^onSubmitClick)(NSString *content);
///取消点击
@property (copy, nonatomic) void(^onCancelClick)();

///键盘高度改变
-(void)setViewContentFrameWithKeyboardH:(CGFloat)keyboardH;

///默认值
-(void)setDefaultText:(NSString *)text;

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
