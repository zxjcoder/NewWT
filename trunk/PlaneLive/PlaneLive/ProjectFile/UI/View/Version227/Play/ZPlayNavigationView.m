//
//  ZPlayNavigationView.m
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZPlayNavigationView.h"
#import "ZCalculateLabel.h"

@interface ZPlayNavigationView()

@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UILabel *lbPage;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnShare;

@end

@implementation ZPlayNavigationView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    CGFloat btnW = 40;
    self.btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.btnClose.frame = CGRectMake(15, 0, btnW, btnW);
    [self.btnClose setImage:[UIImage imageNamed:@"arrow_down"] forState:(UIControlStateNormal)];
    [self.btnClose setImage:[UIImage imageNamed:@"arrow_down"] forState:(UIControlStateHighlighted)];
    [self.btnClose setImageEdgeInsets:(UIEdgeInsetsMake(10, 0, 0, 0))];
    [self.btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnClose];
    
    self.btnShare = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.btnShare.frame = CGRectMake(self.width-10-btnW, 0, btnW, btnW);
    [self.btnShare setImage:[UIImage imageNamed:@"share"] forState:(UIControlStateNormal)];
    [self.btnShare setImage:[UIImage imageNamed:@"share"] forState:(UIControlStateHighlighted)];
    [self.btnShare setImageEdgeInsets:(UIEdgeInsetsMake(10, 0, 0, 0))];
    [self.btnShare addTarget:self action:@selector(btnShareEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnShare];
    
    [self.btnClose setHidden:true];
    [self.btnShare setHidden:true];
 
    UIFont *titleFont = [ZFont systemFontOfSize:21];
    CGFloat titleX = 20;
    CGFloat titleY =  self.btnClose.y+self.btnClose.height+15;
    NSString *title = @"正在播放";
    CGFloat titleH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:titleFont width:100];
    CGFloat titleW = [[ZCalculateLabel shareCalculateLabel] getALineWidthWithFont:titleFont height:titleH text:title];
    self.lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(20, titleY, titleW, titleH))];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:titleFont];
    [self.lbTitle setText:@"正在播放"];
    [self addSubview:self.lbTitle];
    
    UIFont *pageFont = [ZFont systemFontOfSize:kFont_Small_Size];
    CGFloat pageW = 100;
    CGFloat pageH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:pageFont width:pageW];
    CGFloat pageY = self.lbTitle.y+self.lbTitle.height-pageH;
    CGFloat pageX = self.lbTitle.x+self.lbTitle.width+8;
    self.lbPage = [[UILabel alloc] initWithFrame:(CGRectMake(pageX, pageY, pageW, pageH))];
    [self.lbPage setText:@"0/0"];
    [self.lbPage setTextColor:COLORTEXT3];
    [self.lbPage setFont:pageFont];
    [self addSubview:self.lbPage];
}
-(void)btnShareEvent
{
    if (self.onShareViewEvent) {
        self.onShareViewEvent();
    }
}
-(void)btnCloseEvent
{
    if (self.onCloseViewEvent) {
        self.onCloseViewEvent();
    }
}
-(void)setPageChange:(NSInteger)index total:(NSInteger)total
{
    [self.lbPage setText:[NSString stringWithFormat:@"%d/%d", (index+1), total]];
}
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled
{
    [self.btnClose setEnabled:isEnabled];
    [self.btnShare setEnabled:isEnabled];
}
+(CGFloat)getH
{
    return 87;
}

@end
