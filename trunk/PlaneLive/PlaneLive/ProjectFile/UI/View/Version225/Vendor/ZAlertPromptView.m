//
//  ZAlertPromptView.m
//  PlaneLive
//
//  Created by Daniel on 08/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertPromptView.h"
#import "ZShadowButtonView.h"
#import "ZButton.h"
#import "ZLabel.h"

@interface ZAlertPromptView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbContent;
@property (strong, nonatomic) ZShadowButtonView *btnConfirm;
@property (strong, nonatomic) ZButton *btnClose;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *buttonText;

@end

@implementation ZAlertPromptView

///初始化
-(id)initWithTitle:(NSString *)title content:(NSString *)content buttonText:(NSString *)buttonText
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self setTitle:title];
        [self setContent:content];
        [self setButtonText:buttonText];
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.contentW = 300;
    self.contentH = 180;
    
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setUserInteractionEnabled:true];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR5];
    [self.viewBack setAlpha:kBackgroundOpacity];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(self.width/2-self.contentW/2, self.height/2-self.contentH/2, self.contentW, self.contentH);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [self.viewContent setUserInteractionEnabled:true];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:16 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(0, 25, self.viewContent.width, 26))];
    [self.lbTitle setText:self.title];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbContent = [[ZLabel alloc] init];
    [self.lbContent setNumberOfLines:0];
    [self.lbContent setTextColor:COLORTEXT2];
    [self.lbContent setText:self.content];
    [self.lbContent setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbContent];
    
    CGFloat btnW = 108;
    CGFloat btnH = 33;
    self.btnConfirm = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(self.viewContent.width/2-btnW/2, self.viewContent.height-btnH-27, btnW, btnH))];
    [self.btnConfirm setButtonTitle:self.buttonText];
    ZWEAKSELF
    [self.btnConfirm setOnButtonClick:^{
        [weakSelf btnConfirmClick];
    }];
    [self.viewContent addSubview:self.btnConfirm];
    
    CGFloat btnSize = 42;
    self.btnClose = [ZButton buttonWithType:(UIButtonTypeCustom)];
    self.btnClose.frame = CGRectMake(self.width/2-btnSize/2, self.viewContent.y+self.viewContent.height+15, btnSize, btnSize);
    [self.btnClose setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateNormal)];
    [self.btnClose setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateHighlighted)];
    [self.btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnClose setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self addSubview:self.btnClose];
    [self bringSubviewToFront:self.btnClose];
    
    [self setViewFrame];
}
-(void)setViewFrame
{
    CGRect contentFrame = CGRectMake(20, self.lbTitle.y+self.lbTitle.height+21, self.viewContent.width-40, 20);
    [self.lbContent setFrame:contentFrame];
    contentFrame.size.height = [self.lbContent getLabelHeightWithMinHeight:20];
    [self.lbContent setFrame:contentFrame];
    
    CGFloat btnH = 33;
    CGFloat btnBottonSpace = 27;
    CGRect contentViewFrame = self.contentFrame;
    contentViewFrame.size.height = self.lbContent.y+self.lbContent.height+btnH+btnBottonSpace*2;
    contentViewFrame.origin.y = self.height/2-contentViewFrame.size.height/2;
    self.contentFrame = contentViewFrame;
    [self.viewContent setFrame:contentViewFrame];
    
    self.contentH = contentViewFrame.size.height;
    
    CGFloat btnW = 108;
    CGFloat btnY = self.viewContent.height-btnH-btnBottonSpace;
    [self.btnConfirm setFrame:(CGRectMake(self.viewContent.width/2-btnW/2, btnY, btnW, btnH))];
    
    CGFloat btnSize = 42;
    self.btnClose.frame = CGRectMake(self.width/2-btnSize/2, self.viewContent.y+self.viewContent.height+15, btnSize, btnSize);
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
    [self showInView:[[UIApplication sharedApplication] keyWindow]];
}
///显示
-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    [view bringSubviewToFront:self];
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
///显示两个按钮
+(void)showInView:(UIView *)view title:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText completionBlock:(void (^)(void))completionBlock closeBlock:(void (^)(void))closeBlock
{
    ZWEAKSELF
    ZAlertPromptView *alertView = [[ZAlertPromptView alloc] initWithTitle:title content:message buttonText:buttonText];
    [alertView setOnConfirmationClick:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
    [alertView setOnCloseClick:^{
        if (closeBlock) {
            closeBlock();
        }
    }];
    [alertView showInView:view];
}
///显示两个按钮
+(void)showWithTitle:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText completionBlock:(void (^)(void))completionBlock closeBlock:(void (^)(void))closeBlock
{
    [ZAlertPromptView showInView:[[UIApplication sharedApplication] keyWindow] title:title message:message buttonText:buttonText completionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    } closeBlock:^{
        if (closeBlock) {
            closeBlock();
        }
    }];
}
///显示两个按钮 - 提示,自定义内容,按钮
+(void)showWithMessage:(NSString *)message buttonText:(NSString *)buttonText completionBlock:(void (^)(void))completionBlock closeBlock:(void (^)(void))closeBlock
{
    [ZAlertPromptView showInView:[[UIApplication sharedApplication] keyWindow] title:kPrompt message:message buttonText:buttonText completionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    } closeBlock:^{
        if (closeBlock) {
            closeBlock();
        }
    }];
}
///显示两个按钮 - 提示,确定,自定义内容
+(void)showWithMessage:(NSString *)message completionBlock:(void (^)(void))completionBlock closeBlock:(void (^)(void))closeBlock
{
    [ZAlertPromptView showInView:[[UIApplication sharedApplication] keyWindow] title:kPrompt message:message buttonText:kDetermine completionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    } closeBlock:^{
        if (closeBlock) {
            closeBlock();
        }
    }];
}
///显示两个按钮 - 提示,确定,自定义内容
+(void)showWithMessage:(NSString *)message
{
    [ZAlertPromptView showInView:[[UIApplication sharedApplication] keyWindow] title:kPrompt message:message buttonText:kDetermine completionBlock:^{
        
    } closeBlock:^{
        
    }];
}

@end
