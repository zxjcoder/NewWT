//
//  ZNewHomeButtonView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeButtonView.h"

@interface ZNewHomeButtonView()

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///描述
@property (strong, nonatomic) UIButton *btnDesc;
///查看全部
@property (strong, nonatomic) UIButton *btnAll;

@end

@implementation ZNewHomeButtonView

///初始化
-(instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc isMore:(BOOL)isMore
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, ZNewHomeButtonView.getH)];
    if (self) {
        [self innerInit:title desc:desc isMore:isMore];
    }
    return self;
}
-(void)innerInit:(NSString *)title desc:(NSString *)desc isMore:(BOOL)isMore
{
    if (!self.lbTitle) {
        self.lbTitle = [self createTitleLabel];
        [self addSubview:self.lbTitle];
    }
    [self.lbTitle setText:title];
    CGFloat titleW = [self.lbTitle getLabelWidthWithMinWidth:10];
    CGRect titleFrame = self.lbTitle.frame;
    titleFrame.size.width = titleW;
    self.lbTitle.frame = titleFrame;
    
    if (!self.btnDesc) {
        self.btnDesc = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnDesc setTitle:desc forState:(UIControlStateNormal)];
        [self.btnDesc setUserInteractionEnabled:true];
        [[self.btnDesc titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.btnDesc setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
        [self.btnDesc setTitleColor:COLORTEXT3 forState:(UIControlStateHighlighted)];
        [self.btnDesc setContentVerticalAlignment:(UIControlContentVerticalAlignmentBottom)];
        [self.btnDesc setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
        [self.btnDesc setFrame:(CGRectMake(self.lbTitle.x+self.lbTitle.width+10, 0, 100, 33))];
        [self.btnDesc addTarget:self action:@selector(btnDescEvent) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnDesc];
    }
    if (isMore) {
        CGFloat btnW = 53;
        if (!self.btnAll) {
            self.btnAll = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [self.btnAll setUserInteractionEnabled:true];
            [self.btnAll setTitle:kMore forState:(UIControlStateNormal)];
            [self.btnAll setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
            [self.btnAll setFrame:CGRectMake(self.width-btnW-20, 0, btnW, 33)];
            [[self.btnAll titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [self.btnAll setContentVerticalAlignment:(UIControlContentVerticalAlignmentBottom)];
            [self.btnAll addTarget:self action:@selector(btnAllClick) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:self.btnAll];
            
            UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.btnAll.width-10, self.btnAll.height-16, 10, 16)];
            imageIcon.image = [SkinManager getImageWithName:@"arrow_right"];
            [imageIcon setUserInteractionEnabled:false];
            [self.btnAll addSubview:imageIcon];
        }
    }
}
-(UILabel*)createTitleLabel
{
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(20, 10, 10, 26))];
    [lbTitle setTextColor:COLORTEXT1];
    [lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
    return lbTitle;
}
-(void)btnAllClick
{
    if (self.onAllClick) {
        self.onAllClick();
    }
}
-(void)btnDescEvent
{
    if (self.onDescClick) {
        self.onDescClick();
    }
}
+(CGFloat)getH
{
    return 33;
}

@end
