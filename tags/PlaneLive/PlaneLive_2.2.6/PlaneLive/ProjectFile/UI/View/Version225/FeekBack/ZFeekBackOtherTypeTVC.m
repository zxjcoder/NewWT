//
//  ZFeekBackOtherTypeTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackOtherTypeTVC.h"

@interface ZFeekBackOtherTypeTVC()

@end

@implementation ZFeekBackOtherTypeTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    self.cellH = [ZFeekBackOtherTypeTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    ZLabel *lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(self.space, 13, 200, self.lbH))];
    [lbTitle setTextColor:COLORTEXT3];
    [lbTitle setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [lbTitle setText:@"其他反馈方式"];
    [self.viewMain addSubview:lbTitle];
    
    ZButton *btnWechat = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnWechat setUserInteractionEnabled:true];
    [btnWechat addTarget:self action:@selector(btnWechatEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:btnWechat];
    [btnWechat setFrame:(CGRectMake(self.space, lbTitle.y+lbTitle.height+3, 90, 34))];
    
    ZImageView *imageWechat = [[ZImageView alloc] initWithFrame:(CGRectMake(0, 5, 24, 24))];
    imageWechat.image = [SkinManager getImageWithName:@"weixin_a"];
    imageWechat.userInteractionEnabled = false;
    [btnWechat addSubview:imageWechat];
    CGFloat lbwechatX = imageWechat.x+imageWechat.width+6;
    CGFloat lbwechatW = btnWechat.width-lbwechatX;
    ZLabel *lbWechat = [[ZLabel alloc] initWithFrame:(CGRectMake(lbwechatX, 7, lbwechatW+10, 20))];
    [lbWechat setTextColor:COLORTEXT2];
    [lbWechat setUserInteractionEnabled:false];
    [lbWechat setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [lbWechat setText:@"微信客服"];
    [btnWechat addSubview:lbWechat];
    
    ZButton *btnShark = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnShark setUserInteractionEnabled:true];
    [btnShark addTarget:self action:@selector(btnSharkEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:btnShark];
    [btnShark setFrame:(CGRectMake(self.cellW-105-self.space, lbTitle.y+lbTitle.height+3, 105, 34))];
    
    ZImageView *imageShark = [[ZImageView alloc] initWithFrame:(CGRectMake(0, 5, 24, 24))];
    imageShark.image = [SkinManager getImageWithName:@"shake"];
    imageShark.userInteractionEnabled = false;
    [btnShark addSubview:imageShark];
    CGFloat lbSharkX = imageShark.x+imageShark.width+6;
    CGFloat lbSharkW = btnShark.width-lbSharkX;
    ZLabel *lbShark = [[ZLabel alloc] initWithFrame:(CGRectMake(lbSharkX, 7, lbSharkW+10, 20))];
    [lbShark setTextColor:COLORTEXT2];
    [lbShark setUserInteractionEnabled:false];
    [lbShark setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [lbShark setText:@"摇一摇反馈"];
    [btnShark addSubview:lbShark];
    
    UIImageView *imageline = [UIImageView getDLineView];
    imageline.frame = CGRectMake(0, self.cellH-kLineHeight, self.cellW, kLineHeight);
    [self.viewMain addSubview:imageline];
    
    [self.viewMain setFrame:[self getMainFrame]];
}
-(void)btnWechatEvent
{
    if (self.onWeChatClick) {
        self.onWeChatClick();
    }
}
-(void)btnSharkEvent
{
    if (self.onShakeClick) {
        self.onShakeClick();
    }
}
+(CGFloat)getH
{
    return 90;
}

@end
