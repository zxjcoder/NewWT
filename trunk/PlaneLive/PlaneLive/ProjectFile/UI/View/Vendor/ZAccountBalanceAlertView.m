//
//  ZAccountBalanceAlertView.m
//  PlaneLive
//
//  Created by Daniel on 13/06/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAccountBalanceAlertView.h"
#import <TYAttributedLabel/TYAttributedLabel.h>

@interface ZAccountBalanceAlertView()

///背景
@property (strong, nonatomic) UIView *viewBG;
///内容
@property (strong, nonatomic) UIView *viewContent;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///描述
@property (strong, nonatomic) TYAttributedLabel *lbDesc;
///先去登录
@property (strong, nonatomic) UIButton *btnLogin;
///仅在本设备充值
@property (strong, nonatomic) UIButton *btnSubmit;
///关闭按钮
@property (strong, nonatomic) UIButton *btnClose;
///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;
///内容坐标
@property (assign, nonatomic) CGRect contentFrame;

@end

@implementation ZAccountBalanceAlertView

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self getBgView];
    [self getContentView];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:kYouAreNotLoggedInYet];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbDesc = [[TYAttributedLabel alloc] init];
    [self.lbDesc setText:kYouAreNotLoggedInYetDesc];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    // 文字间隙
    self.lbDesc.characterSpacing = 1;
    // 文本行间隙
    self.lbDesc.linesSpacing = 2;
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbDesc];
    
    self.btnLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnLogin setTitle:kGoToLoginFirst forState:(UIControlStateNormal)];
    [[self.btnLogin titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnLogin setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnLogin setViewRoundWithRound];
    [self.btnLogin setBackgroundColor:MAINCOLOR];
    [self.btnLogin addTarget:self action:@selector(btnLoginClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnLogin];
    
    self.btnSubmit = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSubmit setTitle:kRechargeOnlyOnThisDevice forState:(UIControlStateNormal)];
    [[self.btnSubmit titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnSubmit setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSubmit];
    
    self.btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnClose setImage:[SkinManager getImageWithName:@"alert_prompt_close"] forState:(UIControlStateNormal)];
    [self.btnClose setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnClose];
    [self bringSubviewToFront:self.btnClose];
    
    [self.viewBG setFrame:self.bounds];
    
    CGFloat viewW = self.viewBG.width;
    CGFloat viewH = self.viewBG.height;
    CGFloat contentW = 260;
    CGFloat contentH = 280;
    [self.viewContent setFrame:CGRectMake(viewW/2-contentW/2, viewH/2-contentH/2, contentW, contentH)];
    
    CGFloat space = 20;
    CGFloat itemW = contentW-space*2;
    [self.lbTitle setFrame:CGRectMake(space, space, itemW, 20)];
    CGFloat descY = self.lbTitle.y+self.lbTitle.height+space;
    CGRect descFrame = CGRectMake(space, descY, itemW, 0);
    [self.lbDesc setFrame:descFrame];
    [self.lbDesc sizeToFit];
    
    CGFloat btnLoginY = self.lbDesc.y+self.lbDesc.height+18;
    [self.btnLogin setFrame:CGRectMake(space*2, btnLoginY, contentW-space*4, 40)];
    CGFloat btnDeviceY = self.btnLogin.y+self.btnLogin.height+5;
    [self.btnSubmit setFrame:CGRectMake(space*2, btnDeviceY, contentW-space*4, 35)];
    
    CGFloat btnCloseY = self.viewContent.y-20;
    CGFloat btnCloseS = 40;
    CGFloat btnCloseX = self.viewContent.x+self.viewContent.width-30;
    [self.btnClose setFrame:CGRectMake(btnCloseX, btnCloseY, btnCloseS, btnCloseS)];
}

-(void)getBgView
{
    self.viewBG = [[UIView alloc] init];
    [self.viewBG setBackgroundColor:BLACKCOLOR];
    [self.viewBG setAlpha:0.4f];
    [self addSubview:self.viewBG];
}

-(void)getContentView
{
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setHidden:YES];
    [[self.viewContent layer] setMasksToBounds:YES];
    [self.viewContent setViewRoundWithNoBorder];
    [self.viewContent setAlpha:1.0f];
    [self addSubview:self.viewContent];
    
    [self sendSubviewToBack:self.viewBG];
}
-(void)btnCloseClick
{
    [self dismiss];
}
-(void)btnSubmitClick
{
    if (self.onSubmitClick) {
        self.onSubmitClick();
    }
    [self dismiss];
}
-(void)btnLoginClick
{
    if (self.onLoginClick) {
        self.onLoginClick();
    }
    [self dismiss];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_btnClose);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_onLoginClick);
    OBJC_RELEASE(_onSubmitClick);
}
-(void)dealloc
{
    [self setViewNil];
}
///显示
-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.viewBG setAlpha:0];
    [self.viewContent setHidden:NO];
    [self.viewContent setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.viewBG setAlpha:0.4f];
        [self.viewContent setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}
///隐藏
-(void)dismiss
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.viewBG setAlpha:0.0f];
        [self.viewContent setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
        [self.viewContent setHidden:YES];
        [self setViewNil];
        [self removeFromSuperview];
    }];
}

@end
