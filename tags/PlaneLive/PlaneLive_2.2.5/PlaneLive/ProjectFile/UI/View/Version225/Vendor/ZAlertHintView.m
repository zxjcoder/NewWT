//
//  ZAlertHintView.m
//  PlaneLive
//
//  Created by Daniel on 30/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertHintView.h"

@interface ZAlertHintView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;

@property (strong, nonatomic) ZImageView *imageIcon;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) ZView *viewConfirm;
@property (strong, nonatomic) UIButton *btnConfirm;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnOff;

@property (assign, nonatomic) ZAlertHintViewType viewType;

@end

@implementation ZAlertHintView

///初始化
-(id)initWithType:(ZAlertHintViewType )type
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self setViewType:type];
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    self.contentW = 300;
    self.contentH = 320;
    if (!self.viewBack) {
        self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
        [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR3];
        [self.viewBack setAlpha:kBackgroundOpacity];
        [self addSubview:self.viewBack];
    }
    self.contentFrame = CGRectMake(self.width/2-self.contentW/2, self.height/2-self.contentH/2, self.contentW, self.contentH);
    if (!self.viewContent) {
        self.viewContent = [[ZView alloc] init];
        [[self.viewContent layer] setMasksToBounds:true];
        [self.viewContent setBackgroundColor:WHITECOLOR];
        [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
        [self addSubview:self.viewContent];
    }
    [self sendSubviewToBack:self.viewBack];
    if (!self.lbTitle) {
        self.lbTitle = [[UILabel alloc] init];
        [self.lbTitle setTextColor:COLORTEXT2];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.viewContent addSubview:self.lbTitle];
    }
    if (!self.imageIcon) {
        self.imageIcon = [[ZImageView alloc] init];
        [self.viewContent addSubview:self.imageIcon];
    }
    if (!self.viewConfirm) {
        self.viewConfirm = [[ZView alloc] init];
        [self.viewConfirm setAllShadowColorWithRadius:16];
        [self.viewContent addSubview:self.viewConfirm];
    }
    if (!self.btnConfirm) {
        self.btnConfirm = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnConfirm setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
        [[self.btnConfirm titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnConfirm addTarget:self action:@selector(btnConfirmClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:self.btnConfirm];
    }
    if (!self.btnClose) {
        self.btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
        [[self.btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:self.btnClose];
    }
    [self sendSubviewToBack:self.viewBack];
    [self.viewContent sendSubviewToBack:self.viewConfirm];
    if (!self.btnOff) {
        self.btnOff = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnOff setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
        [self.btnOff setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateNormal)];
        [self.btnOff setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateHighlighted)];
        [self.btnOff addTarget:self action:@selector(btnOffEvent) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnOff];
    }
    switch (self.viewType) {
        case ZAlertHintViewTypeNickName:
            [self.lbTitle setText:@"好听的昵称,能提高您的知名度"];
            [self.btnConfirm setTitle:@"编辑昵称" forState:(UIControlStateNormal)];
            break;
        case ZAlertHintViewTypeBindPhone:
            [self.lbTitle setText:@"绑定手机号,才能看到自己有的课程哦~"];
            [self.btnConfirm setTitle:@"绑定手机号" forState:(UIControlStateNormal)];
        default: break;
    }
    [self.btnClose setTitle:@"以后再说" forState:(UIControlStateNormal)];
    /// TODO: ZWW - 缺省图
    self.imageIcon.image = [SkinManager getImageWithName:@"default_bind"];
    
    [self.btnConfirm setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1"] forState:(UIControlStateNormal)];
    [self.btnConfirm setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1_c"] forState:(UIControlStateHighlighted)];
    [self.btnConfirm.layer setMasksToBounds:YES];
    
    CGFloat btnH = 32;
    [self.btnConfirm setViewRound:btnH/2 borderWidth:0 borderColor:CLEARCOLOR];
    
    [self bringSubviewToFront:self.btnOff];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewBack setFrame:self.bounds];
    [self.viewContent setFrame:self.contentFrame];
    CGFloat imageIcon = 130;
    [self.imageIcon setFrame:(CGRectMake(self.contentW/2-imageIcon/2, 40, imageIcon, imageIcon))];
    
    [self.lbTitle setFrame:(CGRectMake(0, self.imageIcon.y+self.imageIcon.height+20, self.contentW, 20))];
    CGFloat btnW = 110;
    CGFloat btnH = 32;
    [self.viewConfirm setFrame:(CGRectMake(self.contentW/2-btnW/2, self.lbTitle.y+self.lbTitle.height+25, btnW, btnH))];
    [self.btnConfirm setFrame:(self.viewConfirm.frame)];
    [self.btnClose setFrame:(CGRectMake(self.contentW/2-btnW/2, self.btnConfirm.y+self.btnConfirm.height+15, btnW, btnH))];
    CGFloat offSize = 45;
    [self.btnOff setFrame:(CGRectMake(self.width/2-offSize/2, self.viewContent.y+self.viewContent.height, offSize, offSize))];
}
-(void)btnConfirmClick
{
    if (self.onConfirmationClick) {
        self.onConfirmationClick();
    }
    [self dismiss];
}
-(void)btnOffEvent
{
   [self dismiss];
}
-(void)btnCloseEvent
{
    if (self.onCloseClick) {
        self.onCloseClick();
    }
    [self dismiss];
}
-(void)viewBGTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
///显示
-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.viewBack.alpha = 0;
    self.viewContent.alpha = 0;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewBack.alpha = kBackgroundOpacity;
        self.viewContent.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
///隐藏
-(void)dismiss
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContent.alpha = 0;
        self.viewBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
