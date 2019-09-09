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
    self.imgLogo = [[UIImageView alloc] init];
    [self.imgLogo setUserInteractionEnabled:NO];
    [self addSubview:self.imgLogo];
}

-(void)initActivityIndicatorView
{
    if (_aiView) {[_aiView stopAnimating];}
    self.aiView = [[UIActivityIndicatorView alloc] init];
    [self.aiView setColor:MAINCOLOR];
    [self.aiView setUserInteractionEnabled:NO];
    [self addSubview:self.aiView];
}

-(void)initButton
{
    self.btnOper = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnOper setBackgroundColor:CLEARCOLOR];
    [self.btnOper setUserInteractionEnabled:YES];
    [self.btnOper setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnOper setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnOper titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnOper addTarget:self action:@selector(btnBGOperClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnOper];
}

-(void)dealloc
{
    [self removeViewMainSubviews];
}

-(void)btnBGOperClick
{
    if (self.onButtonClick) {
        self.onButtonClick();
    }
}

-(void)removeViewMainSubviews
{
    [_aiView stopAnimating];
    [_aiView removeFromSuperview];
    OBJC_RELEASE(_aiView);
    [_imgLogo removeFromSuperview];
    OBJC_RELEASE(_imgLogo);
    [_btnOper removeFromSuperview];
    OBJC_RELEASE(_btnOper);
}

-(void)setViewStateWithState:(ZBackgroundState)state
{
    [self setViewState:state];
    [self removeViewMainSubviews];
    [self setUserInteractionEnabled:YES];
    switch (state) {
        case ZBackgroundStateNone:
        {
            [self setUserInteractionEnabled:NO];
            break;
        }
        case ZBackgroundStateFail:
        {
            [self initImageView];
            [self initButton];
            _imgW = 290/2;
            _imgH = 327/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"404"]];
            [self.btnOper setTitle:kRefresh forState:(UIControlStateNormal)];
            break;
        }
        case ZBackgroundStateNull:
        {
            [self initImageView];
            [self initButton];
            _imgW = 296/2;
            _imgH = 408/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"icon_nodata_bg"]];
            [self.btnOper setTitle:kRefresh forState:(UIControlStateNormal)];
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
            [self initButton];
            _imgW = 230/2;
            _imgH = 303/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"icon_login_back"]];
            [self.btnOper setTitle:kNowLogin forState:(UIControlStateNormal)];
            break;
        }
        case ZBackgroundStateSubscribeRecommendNoData:
        {
            [self initImageView];
            _imgW = 274/2;
            _imgH = 391/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"icon_subscribe_back"]];
            break;
        }
        case ZBackgroundStateSubscribeSetNoData:
        {
            [self initImageView];
            _imgW = 274/2;
            _imgH = 380/2;
            [self.imgLogo setImage:[SkinManager getImageWithName:@"icon_subscribe_set_back"]];
            break;
        }
        default: break;
    }
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat imgX = self.width/2-_imgW/2;
    CGFloat imgY = self.height/2-_imgH/2-(_imgH/5);
    if (self.viewState == (ZBackgroundStateSubscribeRecommendNoData) ||
        self.viewState == ZBackgroundStateSubscribeSetNoData) {
        imgY = 80;
    }
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
        [self.aiView setFrame:CGRectMake(self.width/2-15, self.height/2-30, 30, 30)];
    }
}

@end
