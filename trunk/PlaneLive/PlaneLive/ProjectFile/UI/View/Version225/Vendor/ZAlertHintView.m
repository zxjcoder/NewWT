//
//  ZAlertHintView.m
//  PlaneLive
//
//  Created by Daniel on 30/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertHintView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZShadowButtonView.h"

@interface ZAlertHintView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;

@property (strong, nonatomic) ZImageView *imageIcon;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbInfo;
@property (strong, nonatomic) ZShadowButtonView *btnBind;
@property (strong, nonatomic) ZButton *btnClose;

@property (assign, nonatomic) ZAlertHintViewType viewType;

@end

@implementation ZAlertHintView

///初始化
-(id)initWithType:(ZAlertHintViewType )type
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self setViewType:type];
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.contentW = 300;
    self.contentH = 295;
    if (!self.viewBack) {
        self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
        [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR5];
        [self.viewBack setAlpha:kBackgroundOpacity];
        [self addSubview:self.viewBack];
    }
    self.contentFrame = CGRectMake(self.width/2-self.contentW/2, self.height/2-self.contentH/2, self.contentW, self.contentH);
    if (!self.viewContent) {
        self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
        [[self.viewContent layer] setMasksToBounds:true];
        [self.viewContent setBackgroundColor:WHITECOLOR];
        [self.viewContent setViewRound:16 borderWidth:0 borderColor:CLEARCOLOR];
        [self addSubview:self.viewContent];
    }
    [self sendSubviewToBack:self.viewBack];
    if (!self.imageIcon) {
        CGFloat imageW = 78;
        CGFloat imageH = 118;
        self.imageIcon = [[ZImageView alloc] initWithFrame:(CGRectMake(self.viewContent.width/2-imageW/2, 29, imageW, imageH))];
        self.imageIcon.image = [SkinManager getImageWithName:@"default_bind"];
        [self.viewContent addSubview:self.imageIcon];
    }
    if (!self.lbTitle) {
        CGFloat titleY = self.imageIcon.y+self.imageIcon.height+5;
        self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(0, titleY, self.viewContent.width, 26))];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
        [self.viewContent addSubview:self.lbTitle];
    }
    if (!self.lbInfo) {
        CGFloat infoY = self.lbTitle.y+self.lbTitle.height+11;
        self.lbInfo = [[ZLabel alloc] initWithFrame:(CGRectMake(0, infoY, self.viewContent.width, 20))];
        [self.lbInfo setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbInfo setTextColor:COLORTEXT2];
        [self.lbInfo setTextAlignment:(NSTextAlignmentCenter)];
        [self.viewContent addSubview:self.lbInfo];
    }
    if (!self.btnBind) {
        CGFloat btnW = 108;
        CGFloat btnH = 33;
        CGFloat bindX = self.viewContent.width/2-btnW/2;
        CGFloat bindY = self.lbInfo.y+self.lbInfo.height+23;
        self.btnBind = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(bindX, bindY, btnW, btnH))];
        ZWEAKSELF
        [self.btnBind setOnButtonClick:^{
            [weakSelf btnConfirmClick];
        }];
        
        [self.viewContent addSubview:self.btnBind];
    }
    if (!self.btnClose) {
        CGFloat btnSize = 42;
        self.btnClose = [ZButton buttonWithType:(UIButtonTypeCustom)];
        self.btnClose.frame = CGRectMake(self.width/2-btnSize/2, self.viewContent.y+self.viewContent.height+15, btnSize, btnSize);
        [self.btnClose setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateNormal)];
        [self.btnClose setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateHighlighted)];
        [self.btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnClose setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self addSubview:self.btnClose];
        [self bringSubviewToFront:self.btnClose];
    }
    switch (self.viewType) {
        case ZAlertHintViewTypeNickName:
            [self.lbTitle setText:@"编辑昵称"];
            [self.lbInfo setText:@"编辑个好听的昵称哦~"];
            [self.btnBind setButtonTitle:@"编辑昵称"];
            break;
        case ZAlertHintViewTypeBindPhone:
            [self.lbTitle setText:@"绑定手机号"];
            [self.lbInfo setText:@"合并账号课程余额~"];
            [self.btnBind setButtonTitle:@"绑定手机号"];
        default: break;
    }
}
-(void)btnConfirmClick
{
    if (self.onConfirmationClick) {
        self.onConfirmationClick();
    }
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
    self.btnClose.alpha = 0;
    CGRect contentFrame = self.contentFrame;
    contentFrame.origin.y = self.height;
    self.viewContent.frame = contentFrame;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewBack.alpha = kBackgroundOpacity;
        self.viewContent.frame = self.contentFrame;
    } completion:^(BOOL finished) {
        self.btnClose.alpha = 1;
    }];
}
///隐藏
-(void)dismiss
{
    self.btnClose.alpha = 0;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        CGRect contentFrame = self.contentFrame;
        contentFrame.origin.y = self.height;
        self.viewContent.frame = contentFrame;
        self.viewBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
