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
@property (strong, nonatomic) UIImageView *imgIcon;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///描述
@property (strong, nonatomic) UILabel *lbDesc;
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
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)desc alignment:(NSTextAlignment)alignment
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit:title desc:desc alignment:alignment];
    }
    return self;
}
-(void)innerInit:(NSString *)title desc:(NSString *)desc alignment:(NSTextAlignment)alignment
{
    CGFloat imgY = 18;
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeSpace, imgY, 10, 13)];
    [self.imgIcon setImage:[SkinManager getImageWithName:@"item_nav_icon"]];
    [self addSubview:self.imgIcon];
    
    CGFloat titleY = 15;
    CGFloat btnW = 55;
    CGFloat titleX = self.imgIcon.x+self.imgIcon.width+8;
    CGFloat titleW = 10;
    CGRect titleFrame = CGRectMake(titleX, titleY, titleW, 20);
    self.lbTitle = [[UILabel alloc] initWithFrame:titleFrame];
    [self.lbTitle setTextColor:RGBCOLOR(70, 70, 70)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setText:title];
    [self addSubview:self.lbTitle];
    CGFloat titleNewW = [self.lbTitle getLabelWidthWithMinWidth:titleW];
    titleFrame.size.width = titleNewW;
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat descX = self.lbTitle.x+self.lbTitle.width+10;
    CGFloat descY = titleY;
    CGFloat descW = 10;
    CGRect descFrame = CGRectMake(descX, descY, descW, 20);
    self.lbDesc = [[UILabel alloc] initWithFrame:descFrame];
    [self.lbDesc setTextColor:RGBCOLOR(158, 158, 158)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setText:desc];
    [self.lbDesc setTextAlignment:(alignment)];
    [self.lbDesc setUserInteractionEnabled:YES];
    [self addSubview:self.lbDesc];
    CGFloat descNewW = [self.lbDesc getLabelWidthWithMinWidth:descW];
    descFrame.size.width = descNewW;
    [self.lbDesc setFrame:descFrame];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(descTapGesture:)];
    [self.lbDesc addGestureRecognizer:tapGesture];
    
    self.btnAll = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAll setImage:[SkinManager getImageWithName:@"wode_btn_enter_s"] forState:(UIControlStateNormal)];
    [self.btnAll setImageEdgeInsets:(UIEdgeInsetsMake(3, 40, 3, 3))];
    [self.btnAll setTitle:kMore forState:(UIControlStateNormal)];
    [self.btnAll setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [self.btnAll setTitleEdgeInsets:(UIEdgeInsetsMake(5, 0, 3, 15))];
    [[self.btnAll titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnAll setFrame:CGRectMake(self.width-btnW, 0, btnW, self.height)];
    [self.btnAll addTarget:self action:@selector(btnAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnAll];
}
-(void)innerInit:(NSString *)title
{
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeSpace, self.height/2-13/2, 10, 13)];
    [self.imgIcon setImage:[SkinManager getImageWithName:@"item_nav_icon"]];
    [self addSubview:self.imgIcon];
    
    CGFloat btnW = 55;
    CGFloat titleX = self.imgIcon.x+self.imgIcon.width+8;
    CGFloat titleW = self.width-titleX-btnW-kSizeSpace;
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, self.height/2-20/2, titleW, 20)];
    [self.lbTitle setTextColor:RGBCOLOR(70, 70, 70)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setText:title];
    [self addSubview:self.lbTitle];
    
    self.btnAll = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAll setImage:[SkinManager getImageWithName:@"wode_btn_enter_s"] forState:(UIControlStateNormal)];
    [self.btnAll setTitle:kMore forState:(UIControlStateNormal)];
    [self.btnAll setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [self.btnAll setTitleEdgeInsets:(UIEdgeInsetsMake(3, 0, 3, 15))];
    [self.btnAll setImageEdgeInsets:(UIEdgeInsetsMake(3, 40, 3, 3))];
    [[self.btnAll titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnAll setFrame:CGRectMake(self.width-btnW, 0, btnW, self.height)];
    [self.btnAll addTarget:self action:@selector(btnAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnAll];
}
///设置问答更多按钮
-(void)setAllTitleWithQuestionByMore
{
    [self.btnAll setTitle:kWeeklyPushN forState:(UIControlStateNormal)];
    [self.btnAll setImageEdgeInsets:(UIEdgeInsetsMake(3, 105, 3, 3))];
    [self.btnAll setTitleEdgeInsets:(UIEdgeInsetsMake(3, 0, 3, 6))];
    CGFloat btnW = 120;
    [self.btnAll setFrame:CGRectMake(self.width-btnW, 0, btnW, self.height)];
}
-(void)descTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onDescClick) {
            self.onDescClick();
        }
    }
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
///隐藏描述内容
-(void)setDescLabelHidden:(BOOL)hidden
{
    [self.lbDesc setHidden:hidden];
}
-(void)setViewTitle:(NSString *)title
{
    [self.lbTitle setText:title];
}
-(void)setViewDesc:(NSString *)desc
{
    [self.lbDesc setText:desc];
}
-(void)dealloc
{
    OBJC_RELEASE(_btnAll);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_onAllClick);
}

@end
