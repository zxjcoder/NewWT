//
//  ZNewLawFirmHeaderView.m
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewLawFirmHeaderView.h"

@interface ZNewLawFirmHeaderView()

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///查看全部
@property (strong, nonatomic) UIButton *btnMore;

@end

@implementation ZNewLawFirmHeaderView

///初始化
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title isMore:(BOOL)isMore;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit:title isMore:isMore];
    }
    return self;
}
-(void)innerInit:(NSString *)title isMore:(BOOL)isMore
{
    [self setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [self createTitleLabel];
    [self.lbTitle setText:title];
    CGFloat titleW = [self.lbTitle getLabelWidthWithMinWidth:10];
    CGRect titleFrame = self.lbTitle.frame;
    titleFrame.size.width = titleW;
    self.lbTitle.frame = titleFrame;
    [self addSubview:self.lbTitle];
    
    CGFloat btnW = 53;
    self.btnMore.hidden = isMore;
    self.btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMore setTitle:kMore forState:(UIControlStateNormal)];
    [self.btnMore setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [self.btnMore setFrame:CGRectMake(self.width-btnW-20, self.height-33, btnW, 33)];
    [[self.btnMore titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnMore setContentVerticalAlignment:(UIControlContentVerticalAlignmentBottom)];
    [self.btnMore addTarget:self action:@selector(btnMoreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnMore];
    
    UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.btnMore.width-10, self.btnMore.height-16, 10, 16)];
    imageIcon.image = [SkinManager getImageWithName:@"arrow_right"];
    [imageIcon setUserInteractionEnabled:false];
    [self.btnMore addSubview:imageIcon];
}
-(UILabel*)createTitleLabel
{
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(20, self.height-22, 10, 20))];
    [lbTitle setTextColor:COLORTEXT1];
    [lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Small_Size]];
    return lbTitle;
}
-(void)btnMoreClick
{
    if (self.onMoreClick) {
        self.onMoreClick();
    }
}
///标题设置
-(void)setTitleText:(NSString *)text
{
    [self.lbTitle setText:text];
}
///隐藏更多按钮
-(void)setMoreHidden:(BOOL)hidden
{
    [self.btnMore setHidden:hidden];
}
+(CGFloat)getH
{
    return 40;
}

@end
