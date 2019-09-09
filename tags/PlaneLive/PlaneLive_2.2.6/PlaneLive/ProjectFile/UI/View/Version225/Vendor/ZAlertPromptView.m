//
//  ZAlertPromptView.m
//  PlaneLive
//
//  Created by Daniel on 08/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertPromptView.h"

@interface ZAlertPromptView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;

@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UILabel *lbContent;
@property (strong, nonatomic) UIButton *btnConfirm;
@property (strong, nonatomic) UIButton *btnClose;

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
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    self.contentW = 300;
    self.contentH = 180;
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setUserInteractionEnabled:true];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.viewBack setAlpha:kBackgroundOpacity];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(self.width/2-self.contentW/2, self.height/2-self.contentH/2, self.contentW, self.contentH);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [self.viewContent setUserInteractionEnabled:true];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:self.title];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setNumberOfLines:0];
    [self.lbContent setTextColor:COLORTEXT3];
    [self.lbContent setText:self.content];
    [self.lbContent setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbContent];
    
    self.btnConfirm = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnConfirm setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnConfirm setTitle:self.buttonText forState:(UIControlStateNormal)];
    [[self.btnConfirm titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnConfirm addTarget:self action:@selector(btnConfirmClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnConfirm.layer setMasksToBounds:YES];
    [self.btnConfirm setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1"] forState:(UIControlStateNormal)];
    [self.btnConfirm setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1_c"] forState:(UIControlStateHighlighted)];
    [self.viewContent addSubview:self.btnConfirm];
    
    self.btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnClose setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnClose setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateNormal)];
    [self.btnClose setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateHighlighted)];
    [self.btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnClose];
    [self bringSubviewToFront:self.btnClose];
    //[self setViewFrame];
}
-(void)setViewFrame
{
    [self.viewBack setFrame:self.bounds];
    [self.viewContent setFrame:self.contentFrame];
    
    CGFloat lbW = self.viewContent.width-50;
    [self.lbTitle setFrame:(CGRectMake(25, 30, lbW, 20))];
    
    CGRect contentFrame = CGRectMake(25, self.lbTitle.y+self.lbTitle.height+30, lbW, 20);
    [self.lbContent setFrame:contentFrame];
    contentFrame.size.height = [self.lbContent getLabelHeightWithMinHeight:20];
    [self.lbContent setFrame:contentFrame];
    
    CGFloat btnY = self.lbContent.y+self.lbContent.height+30;
    CGFloat btnW = 110;
    CGFloat btnH = 32;
    [self.btnConfirm setFrame:(CGRectMake(self.viewContent.width/2-btnW/2, btnY, btnW, btnH))];
    [self.btnConfirm setViewRound:btnH/2 borderWidth:0 borderColor:CLEARCOLOR];
    
    CGRect contentViewFrame = self.contentFrame;
    contentViewFrame.size.height = self.btnConfirm.y+self.btnConfirm.height+25;
    contentViewFrame.origin.y = self.height/2-contentViewFrame.size.height/2;
    self.contentFrame = contentViewFrame;
    [self.viewContent setFrame:contentViewFrame];
    
    CGFloat offSize = 45;
    [self.btnClose setFrame:(CGRectMake(self.width/2-offSize/2, self.viewContent.y+self.viewContent.height, offSize, offSize))];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
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
