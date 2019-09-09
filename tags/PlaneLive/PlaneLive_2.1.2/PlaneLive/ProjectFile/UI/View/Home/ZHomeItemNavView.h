//
//  ZHomeItemNavView.h
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kZHomeItemNavViewHeight 44

@interface ZHomeItemNavView : UIView

///初始化
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

///初始化
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)desc alignment:(NSTextAlignment)alignment;

///隐藏全部按钮
-(void)setAllButtonHidden;

///设置标题
-(void)setViewTitle:(NSString *)title;

///查看全部点击事件
@property (copy, nonatomic) void(^onAllClick)();
///描述文本点击事件
@property (copy, nonatomic) void(^onDescClick)();

@end
