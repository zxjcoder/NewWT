//
//  ZBackgroundView.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBackgroundView.h"
#import "ClassCategory.h"

@interface ZBackgroundView()
{
    ///图片宽度
    CGFloat _imgW;
    ///图片高度
    CGFloat _imgH;
}
///背景状态
@property (assign, nonatomic) ZBackgroundState viewState;
///内容区域
@property (strong, nonatomic) UIView *viewMain;
///等待过程
@property (strong, nonatomic) UIActivityIndicatorView *aiView;
///提示图标
@property (strong, nonatomic) UIImageView *imgLogo;
///功能按钮
@property (strong, nonatomic) UIButton *btnOper;

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

-(void)innerInit
{
    [self setBackgroundColor:CLEARCOLOR];
    
    self.viewMain = [[UIView alloc] init];
    [self.viewMain setUserInteractionEnabled:YES];
    [self addSubview:self.viewMain];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.viewMain setFrame:self.bounds];
    
    CGFloat imgX = self.width/2-_imgW/2;
    CGFloat imgY = self.height/2-_imgH/2-(_imgH/5);
    if (self.imgLogo) {
        [self.imgLogo setFrame:CGRectMake(imgX, imgY, _imgW, _imgH)];
    }
    if (self.btnOper) {
        CGFloat btnH = 40;
        CGFloat btnW = 160;
        CGFloat btnX = self.width/2-btnW/2;
        CGFloat btnY = imgY+_imgH+40;
        [self.btnOper setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    }
    if (self.aiView) {
        [self.aiView setFrame:CGRectMake(self.width/2-15, self.height/2, 30, 30)];
    }
}

-(void)initImageView
{
    [_imgLogo removeFromSuperview];
    OBJC_RELEASE(_imgLogo);
    self.imgLogo = [[UIImageView alloc] init];
    [self.imgLogo setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgLogo];
}

-(void)initActivityIndicatorView
{
    if (_aiView) {[_aiView stopAnimating];}
    [_aiView removeFromSuperview];
    OBJC_RELEASE(_aiView);
    self.aiView = [[UIActivityIndicatorView alloc] init];
    [self.aiView setColor:MAINCOLOR];
    [self.aiView setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.aiView];
}

-(void)initButton
{
    [_btnOper removeFromSuperview];
    OBJC_RELEASE(_btnOper);
    self.btnOper = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnOper setBackgroundColor:WHITECOLOR];
    [self.btnOper setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnOper setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnOper titleLabel] setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.btnOper addTarget:self action:@selector(btnOperClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnOper];
}

-(void)dealloc
{
    OBJC_RELEASE(_btnOper);
    OBJC_RELEASE(_imgLogo);
    [_aiView stopAnimating];
    OBJC_RELEASE(_aiView);
    OBJC_RELEASE(_viewMain);
}

-(void)btnOperClick
{
    if (self.onButtonClick) {
        self.onButtonClick();
    }
}

-(void)removeViewMainSubviews
{
    for (UIView *view in self.viewMain.subviews) {
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            [(UIActivityIndicatorView*)view stopAnimating];
        }
        [view removeFromSuperview];
    }
}

-(void)setViewStateWithState:(ZBackgroundState)state
{
    [self setViewState:state];
    [self removeViewMainSubviews];
    switch (state) {
        case ZBackgroundStateNone:
        {
            break;
        }
        case ZBackgroundStateFail:
        {
            [self initImageView];
            [self initButton];
            _imgW = 290/2;
            _imgH = 327/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"404"]];
            [self.btnOper setTitle:@"刷新" forState:(UIControlStateNormal)];
            break;
        }
        case ZBackgroundStateNull:
        {
            [self initImageView];
            [self initButton];
            _imgW = 231/2;
            _imgH = 322/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"icon_nodata_bg"]];
            [self.btnOper setTitle:@"刷新" forState:(UIControlStateNormal)];
            break;
        }
        case ZBackgroundStateLoading:
        {
            [self initActivityIndicatorView];
            [self.aiView startAnimating];
            break;
        }
        case ZBackgroundStateWAQNull:
        {
            [self initImageView];
            [self initButton];
            _imgW = 289/2;
            _imgH = 298/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"dengwohuida"]];
            [self.btnOper setTitle:@"看看问题" forState:(UIControlStateNormal)];
            break;
        }
        case ZBackgroundStateLoginNull:
        {
            [self initImageView];
            [self initButton];
            _imgW = 250/2;
            _imgH = 303/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"icon_login_back"]];
            [self.btnOper setTitle:@"立即登录" forState:(UIControlStateNormal)];
        }
        default:
            break;
    }
    [self setViewFrame];
}

@end
