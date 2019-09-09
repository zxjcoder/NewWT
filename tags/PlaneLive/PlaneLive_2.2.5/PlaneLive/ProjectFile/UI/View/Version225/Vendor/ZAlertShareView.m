//
//  ZAlertShareView.m
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertShareView.h"
#import "ZButton.h"
#import "ClassCategory.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "Utils.h"

@interface ZAlertShareView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;

@end

@implementation ZAlertShareView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    self.contentH = 148;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.viewBack setAlpha:kBackgroundOpacity];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(10, self.height, self.width-20, self.contentH+20);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
    
    BOOL isWechat = false;
    ///计算按钮数量
    NSInteger itemCount = 0;
    if ([Utils isWXAppInstalled]) {
        isWechat = true;
        itemCount += 2;
    }
    if ([Utils isQQAppInstalled]) {
        itemCount += 2;
    }
    if (itemCount > 0) {
        CGFloat btnSpace = 20;
        CGFloat btnW = 55;
        CGFloat btnH = 67;
        CGFloat btnY = 25;
        CGFloat itemSpace = (self.viewContent.width-btnSpace*2-btnW*4)/(3);
        CGFloat imageSize = 40;
        for (NSInteger i = 0; i < itemCount; i++) {
            CGFloat itemX = btnSpace+itemSpace*i+btnW*i;
            UIButton *btnItem = [[UIButton alloc] initWithFrame:(CGRectMake(itemX, btnY, btnW, btnH))];
            [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.viewContent addSubview:btnItem];
            
            ZImageView *imageView = [[ZImageView alloc] initWithFrame:(CGRectMake(btnW/2-imageSize/2, 5, imageSize, imageSize))];
            imageView.userInteractionEnabled = false;
            [btnItem addSubview:imageView];
            
            UILabel *lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(-5, btnItem.height-20, btnItem.width+10, 20))];
            [lbTitle setTextColor:COLORTEXT2];
            [lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [lbTitle setTextAlignment:(NSTextAlignmentCenter)];
            [lbTitle setUserInteractionEnabled:false];
            [btnItem addSubview:lbTitle];
            
            if (isWechat) {
                switch (i) {
                    case 1:
                        lbTitle.text = kCWeChatTimeline;
                        [btnItem setTag:ZShareTypeWeChatCircle];
                        imageView.image = [SkinManager getImageWithName:@"circle"];
                        break;
                    case 2:
                        lbTitle.text = kCQQFriend;
                        [btnItem setTag:ZShareTypeQQ];
                        imageView.image = [SkinManager getImageWithName:@"qq"];
                        break;
                    case 3:
                        lbTitle.text = kCQZone;
                        [btnItem setTag:ZShareTypeQZone];
                        imageView.image = [SkinManager getImageWithName:@"qq_space"];
                        break;
                    default:
                        lbTitle.text = kCWeChatFriend;
                        [btnItem setTag:ZShareTypeWeChat];
                        imageView.image = [SkinManager getImageWithName:@"weixin"];
                        break;
                }
            } else {
                switch (i) {
                    case 1:
                        lbTitle.text = kCQZone;
                        [btnItem setTag:ZShareTypeQZone];
                        imageView.image = [SkinManager getImageWithName:@"qq_space"];
                        break;
                    default:
                        lbTitle.text = kCQQFriend;
                        [btnItem setTag:ZShareTypeQQ];
                        imageView.image = [SkinManager getImageWithName:@"qq"];
                        break;
                }
            }
        }
    }
    CGFloat btnCloseH = 36;
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setTitle:kCancel forState:(UIControlStateNormal)];
    [btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [[btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btnClose.userInteractionEnabled = true;
    btnClose.backgroundColor = CLEARCOLOR;
    btnClose.frame = CGRectMake(0, self.viewContent.height-20-32, self.viewContent.width, 37);
    [self.viewContent addSubview:btnClose];
    
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(20, btnClose.y, self.viewContent.width-40, kLineHeight);
    [self.viewContent addSubview:imageLine];
    
    UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
    [self.viewBack addGestureRecognizer:viewBGTapGesture];
}
-(void)btnItemClick:(UIButton*)sender
{
    if (self.onItemClick) {
        self.onItemClick(sender.tag);
    }
    [self dismiss];
}
-(void)btnCloseEvent
{
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
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewBack.alpha = kBackgroundOpacity;
        CGRect contentFrame = self.contentFrame;
        contentFrame.origin.y -= self.contentH;
        self.viewContent.frame = contentFrame;
    } completion:^(BOOL finished) {
        
    }];
}
///隐藏
-(void)dismiss
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContent.frame = self.contentFrame;
        self.viewBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
