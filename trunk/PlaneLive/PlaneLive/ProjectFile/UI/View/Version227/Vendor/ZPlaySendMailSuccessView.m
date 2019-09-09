//
//  ZPlaySendMailSuccessView.m
//  PlaneLive
//
//  Created by WT on 20/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZPlaySendMailSuccessView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZImageView.h"
#import "ZShadowButtonView.h"

@interface ZPlaySendMailSuccessView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;

@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;

@end

@implementation ZPlaySendMailSuccessView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.contentH = 350;
    
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR5];
    [self.viewBack setAlpha:kBackgroundOpacity];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(self.width/2-300/2, self.height/2-self.contentH/2, 300, self.contentH);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
    
    CGFloat imageW = 74;
    CGFloat imageH = 115;
    ZImageView *imageIcon = [[ZImageView alloc] initWithFrame:(CGRectMake(self.viewContent.width/2-imageW/2, 26, imageW, imageH))];
    imageIcon.image = [SkinManager getImageWithName:@"default_feedback"];
    [self.viewContent addSubview:imageIcon];
    
    CGFloat titleY = imageIcon.y+imageIcon.height+14;
    ZLabel *lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(0, titleY, self.viewContent.width, 26))];
    [lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
    [lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [lbTitle setTextColor:COLORTEXT1];
    [lbTitle setText:@"发送成功"];
    [lbTitle setNumberOfLines:1];
    [self.viewContent addSubview:lbTitle];
    
    CGFloat contentY = lbTitle.y+lbTitle.height+11;
    CGFloat contentX = 22;
    CGFloat contentW = self.viewContent.width-contentX*2;
    ZLabel *lbContent = [[ZLabel alloc] initWithFrame:(CGRectMake(22, contentY, contentW, 80))];
    [lbContent setText:@"邮件可能因网络延迟不能即时接收，请耐心等待。\n等待后仍未收到请联系我的微信：梧桐堂主（微信号:wutongmaster）"];
    [lbContent setNumberOfLines:0];
    [lbContent setTextColor:COLORTEXT2];
    [lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:lbContent];
    
    CGFloat btnW = 108;
    CGFloat btnH = 33;
    CGFloat btnX = self.viewContent.width/2-btnW/2;
    CGFloat btnY = lbContent.y+lbContent.height+14;
    ZShadowButtonView *btnOK = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(btnX, btnY, btnW, btnH))];
    [btnOK setButtonTitle:@"好的"];
    ZWEAKSELF
    [btnOK setOnButtonClick:^{
        [weakSelf dismiss];
    }];
    [self.viewContent addSubview:btnOK];
}
///显示
-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.viewBack.alpha = 0;
    CGRect contentFrame = self.contentFrame;
    contentFrame.origin.y = self.height;
    self.viewContent.frame = contentFrame;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewBack.alpha = kBackgroundOpacity;
        self.viewContent.frame = self.contentFrame;
    } completion:^(BOOL finished) {
    }];
}
///隐藏
-(void)dismiss
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        CGRect contentFrame = self.contentFrame;
        contentFrame.origin.y = self.height;
        self.viewContent.frame = contentFrame;
        self.viewBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)btnCloseEvent:(ZButton *)sender
{
    [self dismiss];
}

@end
