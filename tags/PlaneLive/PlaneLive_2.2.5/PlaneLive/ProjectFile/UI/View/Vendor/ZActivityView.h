//
//  ActivityView.h
//  Product
//
//  Created by Daniel on 15/8/3.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZButtonView;
@class ZActivityView;

typedef void(^ButtonViewHandler)(ZButtonView *buttonView);

///分享按钮
@interface ZButtonView : UIView

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *imageButton;

@property (nonatomic, weak) ZActivityView *activityView;

- (id)initWithText:(NSString *)text image:(UIImage *)image handler:(ButtonViewHandler)handler;

@end

///分享控件
@interface ZActivityView : UIView

//背景颜色, 默认是透明度0.95的白色
@property (nonatomic, strong) UIColor *bgColor;

//标题
@property (nonatomic, strong) UILabel *titleLabel;

//取消按钮
@property (nonatomic, strong) UIButton *cancelButton;

//一行有多少个, 默认是4. iPhone竖屏不会多于4, 横屏不会多于6. ipad没试, 不建议ipad用这个.
@property (nonatomic, assign) int numberOfButtonPerLine;

//是否可以通过下滑手势关闭视图, 默认为YES
@property (nonatomic, assign) BOOL useGesturer;

//是否正在显示
@property (nonatomic, getter = isShowing) BOOL show;

- (id)initWithTitle:(NSString *)title referView:(UIView *)referView;

- (void)addButtonView:(ZButtonView *)buttonView;

- (void)show;

- (void)hide;

@end
