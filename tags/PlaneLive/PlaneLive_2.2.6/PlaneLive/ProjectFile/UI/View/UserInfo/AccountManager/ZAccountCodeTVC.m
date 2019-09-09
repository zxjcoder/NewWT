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
@property (strong, nonatomic) UIImageView *imgCode;
@property (strong, nonatomic) ZTextField *textCode;
@property (strong, nonatomic) UIButton *btnSend;
@property (strong, nonatomic) UIImageView *imageLine;

@end

@implementation ZAccountCodeTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZAccountCodeTVC getH];
    self.space = 40*kViewSace;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgCode = [[UIImageView alloc] init];
    [self.viewMain addSubview:self.imgCode];
    
    self.textCode = [[ZTextField alloc] init];
    [self.textCode setTextFieldIndex:ZTextFieldIndexBindCode];
    [self.textCode setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textCode setReturnKeyType:(UIReturnKeyDone)];
    [self.textCode setBorderStyle:(UITextBorderStyleNone)];
    [self.textCode setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textCode setMaxLength:kNumberCodeMaxLength];
    [self.viewMain addSubview:self.textCode];
    
    self.btnSend = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSend setTitle:kGetCode forState:(UIControlStateNormal)];
    [self.btnSend setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
    [self.btnSend setTag:10];
    [self.btnSend setUserInteractionEnabled:YES];
    [[self.btnSend titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.btnSend addTarget:self action:@selector(btnSendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnSend];
    
    self.imageLine = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imageLine];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = 80;
    CGFloat imgSize = 24;
    CGFloat imgaY = self.cellH/2-imgSize/2;
    [self.imgCode setFrame:CGRectMake(self.space, imgaY, imgSize, imgSize)];
    
    CGFloat textH = 35;
    CGFloat textX = self.imgCode.x+self.imgCode.width+10;
    CGFloat textW = self.cellW-textX-self.space-btnW;
    CGFloat textY = self.cellH/2-textH/2+3;
    [self.textCode setViewFrame:CGRectMake(textX, textY, textW, textH)];
    
    [self.btnSend setFrame:CGRectMake(self.cellW-btnW-self.space, textY, btnW, textH)];
    [self.imageLine setFrame:CGRectMake(self.space, self.cellH-self.lineH, self.cellW-self.space*2, self.lineH)];
    
    self.imgCode.image = [SkinManager getImageWithName:@"verify_code"];
    [self.textCode setPlaceholder:kPleaseEnterCode];
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
}
-(void)setSendError
{
    [self.btnSend setTag:10];
    [self.btnSend setTitle:kSendCode forState:(UIControlStateNormal)];
    [self.btnSend setTitleColor:MAINCOLOR forState:UIControlStateNormal];
}
-(void)timerCallback
{
    if (_time<=0) {
        _time=0;
        OBJC_RELEASE_TIMER(_timer);
        [self.btnSend setTag:10];
        [self.btnSend setTitle:kSendCode forState:(UIControlStateNormal)];
        [self.btnSend setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    } else {
        _time--;
        [self.btnSend setTitle:[NSString stringWithFormat:@"%@(%d)", kReSendCode, _time] forState:(UIControlStateNormal)];
        [self.btnSend setTitleColor:DESCCOLOR forState:UIControlStateNormal];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE_TIMER(_timer);
    OBJC_RELEASE(_imgCode);
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
