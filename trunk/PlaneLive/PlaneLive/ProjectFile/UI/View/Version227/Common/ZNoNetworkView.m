//
//  ZNoNetworkView.m
//  PlaneLive
//
//  Created by WT on 13/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNoNetworkView.h"
#import "ZCalculateLabel.h"

@implementation ZNoNetworkView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZNoNetworkView getViewH])];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat iconH = 40;
    UIImageView *imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake"]];
    imgIcon.frame = CGRectMake(20, self.height/2-iconH/2, iconH, iconH);
    [self addSubview:imgIcon];
    
    UIFont *textFont = [ZFont systemFontOfSize:kFont_Small_Size];
    CGFloat textH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:textFont width:150];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(imgIcon.x+imgIcon.width+10, 25, 150, textH))];
    [lbTitle setText:@"无网络"];
    [lbTitle setTextColor:COLORTEXT2];
    [lbTitle setFont:textFont];
    [self addSubview:lbTitle];
    
    UILabel *lbDesc = [[UILabel alloc] initWithFrame:(CGRectMake(lbTitle.x, lbTitle.y+lbTitle.height+5, 150, textH))];
    [lbDesc setText:@"请检查网络设置"];
    [lbDesc setTextColor:COLORTEXT2];
    [lbDesc setFont:textFont];
    [self addSubview:lbDesc];
    
    UIButton *btnSetting = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSetting setTitle:@"去设置" forState:(UIControlStateNormal)];
    [btnSetting setTitle:@"去设置" forState:(UIControlStateHighlighted)];
    [btnSetting.titleLabel setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnSetting setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
    [btnSetting setTitleColor:COLORCONTENT1 forState:(UIControlStateHighlighted)];
    UIImage *imageN = [[UIImage imageNamed:@"btn_gra3"] setImageAlpha:0.2];
    UIImage *imageH = [[UIImage imageNamed:@"btn_gra3"] setImageAlpha:0.2];
    [btnSetting setBackgroundImage:imageN forState:(UIControlStateNormal)];
    [btnSetting setBackgroundImage:imageH forState:(UIControlStateHighlighted)];
    btnSetting.frame = CGRectMake(self.width-20-90, self.height/2-32/2, 90, 32);
    [btnSetting setViewRound:16];
    [btnSetting addTarget:self action:@selector(btnSettingEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnSetting];
}
-(void)btnSettingEvent:(UIButton *)sender
{
    if (self.onSettingClick) {
        self.onSettingClick();
    }
}
/// 获取View高度
+(CGFloat)getViewH
{
    return 90;
}

@end
