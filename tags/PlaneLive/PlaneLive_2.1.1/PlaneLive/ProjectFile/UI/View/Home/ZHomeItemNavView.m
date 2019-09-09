//
//  ZHomeItemNavView.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeItemNavView.h"

@interface ZHomeItemNavView()

///颜色
@property (strong, nonatomic) UIView *viewIcon;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///查看全部
@property (strong, nonatomic) UIButton *btnAll;

@end

@implementation ZHomeItemNavView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit:kEmpty];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit:title];
    }
    return self;
}

-(void)innerInit:(NSString *)title
{
    self.viewIcon = [[UIView alloc] initWithFrame:CGRectMake(kSizeSpace, self.height/2-15/2, kSize5, 15)];
    [self.viewIcon setBackgroundColor:MAINCOLOR];
    [self addSubview:self.viewIcon];
    
    CGFloat btnW = 60;
    CGFloat titleX = self.viewIcon.x+self.viewIcon.width+kSize5;
    CGFloat titleW = self.width-titleX-btnW-kSizeSpace;
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, self.height/2-20/2, titleW, 20)];
    [self.lbTitle setTextColor:RGBCOLOR(58, 58, 58)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setText:title];
    [self addSubview:self.lbTitle];
    
    self.btnAll = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAll setTitle:kSayAll forState:(UIControlStateNormal)];
    [self.btnAll setTitleColor:RGBCOLOR(58, 58, 58) forState:(UIControlStateNormal)];
    [[self.btnAll titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnAll setFrame:CGRectMake(self.width-btnW-kSizeSpace, 0, btnW, self.height)];
    [self.btnAll addTarget:self action:@selector(btnAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnAll];
}

-(void)btnAllClick
{
    if (self.onAllClick) {
        self.onAllClick();
    }
}

///隐藏全部按钮
-(void)setAllButtonHidden
{
    [self.btnAll setHidden:YES];
}

-(void)setViewTitle:(NSString *)title
{
    [self.lbTitle setText:title];
}

-(void)dealloc
{
    OBJC_RELEASE(_btnAll);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewIcon);
    OBJC_RELEASE(_onAllClick);
}

@end
