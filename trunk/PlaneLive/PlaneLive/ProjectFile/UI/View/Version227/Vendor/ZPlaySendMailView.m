//
//  ZPlaySendMailView.m
//  PlaneLive
//
//  Created by WT on 20/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZPlaySendMailView.h"
#import "ZTextField.h"
#import "ZLabel.h"
#import "ZShadowButtonView.h"
#import "ZScrollView.h"
#import "ZButton.h"

@interface ZPlaySendMailView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;

@property (strong, nonatomic) ZTextField *textField;
@property (strong, nonatomic) ZScrollView *scrollView;
@property (strong, nonatomic) ZLabel *lbContent;
@property (strong, nonatomic) ZButton *btnClose;

@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *email;

@end

@implementation ZPlaySendMailView

-(id)initWithContent:(NSString *)text mail:(NSString *)mail
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        self.content = text;
        self.email = mail;
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
    
    ZLabel *lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(0, 37, self.viewContent.width, 26))];
    [lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
    [lbTitle setTextColor:COLORTEXT1];
    [lbTitle setText:@"发送至邮箱"];
    [lbTitle setNumberOfLines:1];
    [self.viewContent addSubview:lbTitle];
    
    CGFloat itemSpace = 22;
    CGFloat itemWidth = self.viewContent.width-44;
    self.textField = [[ZTextField alloc] initWithFrame:CGRectMake(itemSpace, lbTitle.y+lbTitle.height+18, itemWidth, 36)];
    [self.textField setPlaceholder:@"输入电子邮箱"];
    [self.textField setText:self.email];
    [self.textField setKeyboardType:(UIKeyboardTypeEmailAddress)];
    [self.textField setTextInputType:(ZTextFieldInputTypeEMail)];
    [self.viewContent addSubview:self.textField];
    
    ZLabel *lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(itemSpace, self.textField.y+self.textField.height+11, itemWidth, 34))];
    [lbDesc setText:@"建议使用163、sina、QQ等常见邮箱，公司内部邮箱可能无法接收邮件。"];
    [lbDesc setNumberOfLines:2];
    [lbDesc setTextColor:COLORTEXT3];
    [lbDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewContent addSubview:lbDesc];
    
    ZLabel *lbMaterial = [[ZLabel alloc] initWithFrame:(CGRectMake(itemSpace, lbDesc.y+lbDesc.height+14, itemWidth, 20))];
    [lbMaterial setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [lbMaterial setTextColor:COLORTEXT1];
    [lbMaterial setText:@"资料包含"];
    [self.viewContent addSubview:lbMaterial];
    
    self.scrollView = [[ZScrollView alloc] initWithFrame:(CGRectMake(itemSpace, lbMaterial.y+lbMaterial.height+9, itemWidth, 62))];
    [self.scrollView setScrollsToTop:false];
    [self.scrollView setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.scrollView setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewContent addSubview:self.scrollView];
    
    CGRect contentFrame = (CGRectMake(14, 11, self.scrollView.width-28, 20));
    self.lbContent = [[ZLabel alloc] initWithFrame:contentFrame];
    [self.lbContent setText:self.content];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setTextColor:COLORTEXT2];
    [self.lbContent setNumberOfLines:0];
    [self.scrollView addSubview:self.lbContent];
    
    contentFrame.size.height = [self.lbContent getLabelHeightWithMinHeight:20];
    self.lbContent.frame = contentFrame;
    [self.scrollView setContentSize:(CGSizeMake(self.scrollView.width, self.lbContent.y*2+self.lbContent.height))];
    
    CGFloat btnW = 108;
    CGFloat btnH = 33;
    CGFloat btnY = self.scrollView.y+self.scrollView.height+20;
    CGFloat btnX = self.viewContent.width/2-btnW/2;
    ZShadowButtonView *btnSend = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(btnX, btnY, btnW, btnH))];
    [btnSend setButtonTitle:@"立即发送"];
    ZWEAKSELF
    [btnSend setOnButtonClick:^{
        if (weakSelf.onSendMailClick) {
            weakSelf.onSendMailClick(weakSelf);
        }
    }];
    [self.viewContent addSubview:btnSend];
    
    CGFloat btnSize = 42;
    self.btnClose = [ZButton buttonWithType:(UIButtonTypeCustom)];
    self.btnClose.frame = CGRectMake(self.width/2-btnSize/2, self.viewContent.y+self.viewContent.height+15, btnSize, btnSize);
    [self.btnClose setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateNormal)];
    [self.btnClose setImage:[SkinManager getImageWithName:@"alert_close"] forState:(UIControlStateHighlighted)];
    [self.btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnClose setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self addSubview:self.btnClose];
    [self bringSubviewToFront:self.btnClose];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewContentTapGesutre:)];
    [self.viewContent addGestureRecognizer:tapGesture];
}
-(void)viewContentTapGesutre:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.textField resignFirstResponder];
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
-(void)btnCloseEvent
{
    [self dismiss];
}

@end
