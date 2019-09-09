//
//  ZBackgroundView.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBackgroundView.h"
#import "ClassCategory.h"
//#import "ZLoadingBGView.h"

@interface ZBackgroundView()
{
    ///图片宽度
    CGFloat _imgW;
    ///图片高度
    CGFloat _imgH;
}
///背景状态
@property (assign, nonatomic) ZBackgroundState viewState;
///等待过程
@property (strong, nonatomic) UIActivityIndicatorView *aiView;
///提示图标
@property (strong, nonatomic) UIImageView *imgLogo;
///提示文本
@property (strong, nonatomic) UILabel *lbTitle;
///登录按钮
@property (strong, nonatomic) UIView *viewLogin;
///登录按钮
@property (strong, nonatomic) UIButton *btnLogin;

@end

@implementation ZBackgroundView

-(id)init
{
    self = [super init];
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
    [self setBackgroundColor:CLEARCOLOR];
    [self setUserInteractionEnabled:NO];
}
-(void)initImageView
{
    if (!self.imgLogo) {
        self.imgLogo = [[UIImageView alloc] init];
        [self.imgLogo setUserInteractionEnabled:NO];
        [self addSubview:self.imgLogo];
    }
}
-(void)initActivityIndicatorView
{
    if (self.aiView) {
        [self.aiView stopAnimating];
        [self.aiView removeFromSuperview];
    }
    self.aiView = [[UIActivityIndicatorView alloc] init];
    [self.aiView setColor:MAINCOLOR];
    [self.aiView setUserInteractionEnabled:NO];
    [self addSubview:self.aiView];
}
-(void)initLabel
{
    if (!self.lbTitle) {
        self.lbTitle = [[UILabel alloc] init];
        [self.lbTitle setTextColor:COLORTEXT2];
        [self.lbTitle setUserInteractionEnabled:false];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self addSubview:self.lbTitle];
    }
}
-(void)initButton
{
    if (!self.viewLogin) {
        self.viewLogin = [[UIView alloc] init];
        [self.viewLogin setButtonShadowColorWithRadius:20];
        [self addSubview:self.viewLogin];
    }
    if (!self.btnLogin) {
        self.btnLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnLogin setTitleColor:WHITECOLOR forState:(UIControlStateHighlighted)];
        [self.btnLogin setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
        [self.btnLogin setTitle:@"立即登录" forState:(UIControlStateHighlighted)];
        [self.btnLogin setTitle:@"立即登录" forState:(UIControlStateNormal)];
        [[self.btnLogin titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnLogin setUserInteractionEnabled:true];
        [self.btnLogin setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1"] forState:(UIControlStateNormal)];
        [self.btnLogin setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1_c"] forState:(UIControlStateHighlighted)];
        [self.btnLogin.layer setMasksToBounds:true];
        [self.btnLogin setViewRound:18 borderWidth:0 borderColor:CLEARCOLOR];
        [self.btnLogin addTarget:self action:@selector(btnLoginClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewLogin addSubview:self.btnLogin];
    }
}
-(void)btnLoginClick
{
    if (self.onButtonClick) {
        self.onButtonClick();
    }
}
-(void)dealloc
{
    [self removeViewMainSubviews];
}
-(void)btnBGOperClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onButtonClick) {
            self.onButtonClick();
        }
    }
}
-(void)removeViewMainSubviews
{
    if (_aiView) {
        [_aiView stopAnimating];
        [_aiView removeFromSuperview];
        OBJC_RELEASE(_aiView);
    }
    if (_imgLogo) {
        [_imgLogo removeFromSuperview];
        OBJC_RELEASE(_imgLogo);
    }
    if (_lbTitle) {
        [_lbTitle removeFromSuperview];
        OBJC_RELEASE(_lbTitle);
    }
    if (_btnLogin) {
        [_btnLogin removeFromSuperview];
        OBJC_RELEASE(_btnLogin);
    }
    if (_viewLogin) {
        [_viewLogin removeFromSuperview];
        OBJC_RELEASE(_viewLogin);
    }
}

-(void)setViewStateWithState:(ZBackgroundState)state
{
    [self setViewState:state];
    [self removeViewMainSubviews];
    [self setUserInteractionEnabled:YES];
    _imgW = 175;
    _imgH = 175;
    /// TODO: ZWW - 修改缺省图片
    switch (state) {
        case ZBackgroundStateNone:
        {
            [self setUserInteractionEnabled:NO];
            break;
        }
        case ZBackgroundStateFail:
        {
            [self initImageView];
            [self initLabel];
            [self.imgLogo setImage:[SkinManager getImageWithName:@"default_internet"]];
            [self.lbTitle setText:@"网络状况有问题，请下拉刷新"];
            break;
        }
        case ZBackgroundStateError:
        {
            [self initImageView];
            [self initLabel];
            [self.imgLogo setImage:[SkinManager getImageWithName:@"default_internet"]];
            [self.lbTitle setText:@"网络状况有问题"];
            break;
        }
        case ZBackgroundStateNull:
        {
            [self initImageView];
            [self initLabel];
            [self.imgLogo setImage:[SkinManager getImageWithName:@"default_nothing"]];
            [self.lbTitle setText:@"这里什么都没有"];
            break;
        }
        case ZBackgroundStateLoading:
        {
            [self setUserInteractionEnabled:NO];
            [self initActivityIndicatorView];
            [self.aiView startAnimating];
            break;
        }
        case ZBackgroundStateLoginNull:
        {
            [self initImageView];
            [self initLabel];
            [self initButton];
            [self.imgLogo setImage:[SkinManager getImageWithName:@"default_login"]];
            [self.lbTitle setText:@"尚未登录"];
            break;
        }
        case ZBackgroundStateSubscribeNoData:
        {
            [self initImageView];
            [self initLabel];
            [self.imgLogo setImage:[SkinManager getImageWithName:@"default_order"]];
            [self.lbTitle setText:@"您还没有购买培训课"];
            break;
        }
        case ZBackgroundStateCurriculumNoData:
        {
            [self initImageView];
            [self initLabel];
            [self.imgLogo setImage:[SkinManager getImageWithName:@"default_order"]];
            [self.lbTitle setText:@"您还没有购买系列课"];
            break;
        }
        case ZBackgroundStatePracticeNoData:
        {
            [self initImageView];
            [self initLabel];
            [self.imgLogo setImage:[SkinManager getImageWithName:@"default_order"]];
            [self.lbTitle setText:@"您还没有购买微课"];
            break;
        }
        case ZBackgroundStateAllNoData:
        {
            [self initImageView];
            [self initLabel];
            [self.imgLogo setImage:[SkinManager getImageWithName:@"default_order"]];
            [self.lbTitle setText:@"您还没有购买课程"];
            break;
        }
        default: break;
    }
    [self setViewFrame];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}
-(void)setViewFrame
{
    CGFloat imgX = self.width/2-_imgW/2;
    CGFloat imgY = 100*kViewSace;//self.height/2-_imgH/2-20;
    if (self.imgLogo) {
        [self.imgLogo setFrame:CGRectMake(imgX, imgY, _imgW, _imgH)];
    }
    if (self.lbTitle) {
        CGFloat btnH = 20;
        CGFloat btnW = 300;
        CGFloat btnX = self.width/2-btnW/2;
        CGFloat btnY = imgY+_imgH+20;
        [self.lbTitle setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    }
    if (self.aiView) {
        [self.aiView setFrame:CGRectMake(self.width/2-15, self.height/2-30, 30, 30)];
    }
    if (self.btnLogin) {
        CGFloat btnW = 120;
        CGFloat btnH = 36;
        [self.viewLogin setFrame:CGRectMake(self.width/2-btnW/2, self.lbTitle.y+self.lbTitle.height+20, btnW, btnH)];
        [self.btnLogin setFrame: self.viewLogin.bounds];
    }
}

@end
