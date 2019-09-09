//
//  ZAccountCodeTVC.m
//  PlaneLive
//
//  Created by Daniel on 30/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountCodeTVC.h"
#import "Utils.h"
#import "ZTextField.h"

@interface ZAccountCodeTVC()
{
    NSTimer *_timer;
    int _time;
}
@property (strong, nonatomic) ZTextField *textCode;
@property (strong, nonatomic) UIButton *btnSend;

@end

@implementation ZAccountCodeTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.cellH = [ZAccountCodeTVC getH];
    self.space = 40*kViewSace;
    if (IsIPhone4 || IsIPhone5) {
        self.space = 20;
    }
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat textHeight = 38;
    CGFloat textWidth = self.cellW-self.space*2;
    self.textCode = [[ZTextField alloc] initWithFrame:(CGRectMake(self.space, 6, textWidth, textHeight))];
    [self.textCode setTextFieldIndex:ZTextFieldIndexBindCode];
    [self.textCode setTextInputType:(ZTextFieldInputTypeCode)];
    [self.textCode setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textCode setReturnKeyType:(UIReturnKeyDone)];
    [self.textCode setBorderStyle:(UITextBorderStyleNone)];
    [self.textCode setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textCode setMaxLength:kNumberCodeMaxLength];
    [self.textCode setPlaceholder:kPleaseEnterCode];
    [self.viewMain addSubview:self.textCode];
    
    self.btnSend = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSend setTitle:kGetCode forState:(UIControlStateNormal)];
    [self.btnSend setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
    [self.btnSend setTag:10];
    [self.btnSend setUserInteractionEnabled:YES];
    [self.btnSend setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [[self.btnSend titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnSend addTarget:self action:@selector(btnSendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    CGFloat btnW = 90;
    CGFloat btnH = 38;
    CGFloat btnX = self.textCode.x+self.textCode.width-btnW;
    self.btnSend.frame = CGRectMake(btnX, self.textCode.y, btnW, btnH);
    [self.viewMain addSubview:self.btnSend];
    [self.viewMain bringSubviewToFront:self.btnSend];
}
-(void)btnSendClick:(UIButton *)sender
{
    if (sender.tag == 10) {
        if (self.onSendCodeClick) {
            self.onSendCodeClick();
        }
    }
}
///获取验证码
-(NSString *)getCodeText
{
    return self.textCode.text;
}
-(void)setSendSuccess
{
    _time = 60;
    _btnSend.tag = 11;
    _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _timer.fireDate = [NSDate new];
}
-(void)setSendError
{
    [self.btnSend setTag:10];
    [self.btnSend setTitle:kGetCode forState:(UIControlStateNormal)];
    [self.btnSend setTitleColor:COLORCONTENT1 forState:UIControlStateNormal];
}
-(void)timerCallback
{
    if (_time<=0) {
        _time=0;
        OBJC_RELEASE_TIMER(_timer);
        [self.btnSend setTag:10];
        [self.btnSend setTitle:kGetCode forState:(UIControlStateNormal)];
        [self.btnSend setTitleColor:COLORCONTENT1 forState:UIControlStateNormal];
    } else {
        _time--;
        [self.btnSend setTitle:[NSString stringWithFormat:@"%@(%d)", kReSendCode, _time] forState:(UIControlStateNormal)];
        [self.btnSend setTitleColor:COLORTEXT3 forState:UIControlStateNormal];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE_TIMER(_timer);
    OBJC_RELEASE(_btnSend);
    OBJC_RELEASE(_textCode);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 55;
}

@end
