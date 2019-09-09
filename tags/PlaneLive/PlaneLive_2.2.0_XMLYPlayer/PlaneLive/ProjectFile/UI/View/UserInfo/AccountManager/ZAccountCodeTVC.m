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

@property (strong, nonatomic) UIView *viewLine;

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
    
    self.imgCode = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"login_code_icon"]];
    [self.viewMain addSubview:self.imgCode];
    
    self.textCode = [[ZTextField alloc] init];
    [self.textCode setTextFieldIndex:ZTextFieldIndexBindCode];
    [self.textCode setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textCode setReturnKeyType:(UIReturnKeyDone)];
    [self.textCode setPlaceholder:kPleaseEnterCode];
    [self.textCode setBorderStyle:(UITextBorderStyleNone)];
    [self.textCode setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textCode setMaxLength:kNumberCodeMaxLength];
    [self.viewMain addSubview:self.textCode];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    self.btnSend = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSend setTitle:kGetCode forState:(UIControlStateNormal)];
    [self.btnSend setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnSend setTag:10];
    [self.btnSend setUserInteractionEnabled:YES];
    [[self.btnSend titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnSend addTarget:self action:@selector(btnSendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnSend];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = 80;
    CGFloat spaceX = 10;
    CGFloat imgSize = 13;
    CGFloat imgaY = self.cellH/2-imgSize/2;
    [self.imgCode setFrame:CGRectMake(self.space, imgaY, imgSize, imgSize)];
    
    CGFloat textH = 35;
    CGFloat textX = self.imgCode.x+self.imgCode.width+10;
    CGFloat textW = self.cellW-textX-spaceX;
    CGFloat textY = self.cellH/2-textH/2;
    [self.textCode setViewFrame:CGRectMake(textX, textY, textW-btnW, textH)];
    
    [self.viewLine setFrame:CGRectMake(self.textCode.x+self.textCode.width, textY, 1, textH)];
    [self.btnSend setFrame:CGRectMake(self.viewLine.x+self.viewLine.width+5, textY, btnW, textH)];
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
