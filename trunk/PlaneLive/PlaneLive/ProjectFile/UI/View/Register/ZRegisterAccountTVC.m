//
//  ZRegisterAccountTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRegisterAccountTVC.h"
#import "ZToolbar.h"
#import "Utils.h"
#import "ZTextField.h"

@interface ZRegisterAccountTVC()
{
    NSTimer *_timer;
    int _time;
}
@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) ZTextField *textAccount;
@property (strong, nonatomic) ZTextField *textCode;
@property (strong, nonatomic) UIButton *btnSend;
@property (strong, nonatomic) ZTextField *textPassword;

@end

@implementation ZRegisterAccountTVC

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
    
    self.cellH = [ZRegisterAccountTVC getH];
    
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR1];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    int iCount = 3;
    CGFloat itemH = 50;
    CGFloat spaceX = 40 * kViewSace;
    if (IsIPhone5 || IsIPhone4) {
        spaceX = 20;
    }
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(spaceX, 10, self.cellW - spaceX*2, itemH*iCount)];
    [self.viewContent setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewContent];
    
    CGFloat textHeight = 38;
    CGFloat textWidth = self.viewContent.width;
    /**帐号**/
    self.textAccount = [[ZTextField alloc] initWithFrame:(CGRectMake(0, 6, textWidth, textHeight))];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexRegisterAccount];
    [self.textAccount setTextInputType:(ZTextFieldInputTypeAccount)];
    [self.textAccount setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textAccount setReturnKeyType:(UIReturnKeyDone)];
    [self.textAccount setTextColor:COLORTEXT3];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textAccount setMaxLength:kNumberPhomeMaxLength];
    [self.viewContent addSubview:self.textAccount];
    
    /**验证码**/
    self.textCode = [[ZTextField alloc] initWithFrame:(CGRectMake(0, itemH+6, textWidth, textHeight))];
    [self.textCode setTextFieldIndex:ZTextFieldIndexRegisterCode];
    [self.textCode setTextInputType:ZTextFieldInputTypeCode];
    [self.textCode setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textCode setReturnKeyType:(UIReturnKeyDone)];
    [self.textCode setTextColor:COLORTEXT3];
    [self.textCode setBorderStyle:(UITextBorderStyleNone)];
    [self.textCode setClearButtonMode:(UITextFieldViewModeNever)];
    [self.textCode setMaxLength:kNumberCodeMaxLength];
    [self.viewContent addSubview:self.textCode];
    
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
    
    [self.viewContent addSubview:self.btnSend];
    [self.viewContent bringSubviewToFront:self.btnSend];
    
    /**密码**/
    self.textPassword = [[ZTextField alloc] initWithFrame:(CGRectMake(0, itemH*2+6, textWidth, textHeight))];
    [self.textPassword setTextFieldIndex:ZTextFieldIndexRegisterPwd];
    [self.textPassword setTextInputType:ZTextFieldInputTypePassword];
    [self.textPassword setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textPassword setReturnKeyType:(UIReturnKeyDone)];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setTextColor:COLORTEXT3];
    [self.textPassword setMaxLength:kNumberPasswordMaxLength];
    [self.viewContent addSubview:self.textPassword];
    
    [self.textAccount setPlaceholder:kPleaseEnterPhone];
    [self.textCode setPlaceholder:kPleaseEnterCode];
    [self.textPassword setPlaceholder:kPleaseEnterNewPasswordLengthLimitCharacter];
}
-(void)setCellBackGroundColor:(UIColor *)color
{
    [self.viewMain setBackgroundColor:color];
}
-(void)btnSendClick:(UIButton *)sender
{
    if (sender.tag == 10) {
        if (self.onSendCodeClick) {
            self.onSendCodeClick();
        }
    }
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
-(void)setAccountText:(NSString *)text
{
    [self.textAccount setText:text];
}
-(NSString *)getAccountText
{
    return [self.textAccount text];
}

-(NSString *)getCodeText
{
    return [self.textCode text];
}

-(void)setPasswordText:(NSString *)text
{
    [self.textPassword setText:text];
}
-(NSString *)getPasswordText
{
    return [self.textPassword text];
}

-(void)setViewNil
{
    OBJC_RELEASE(_textCode);
    OBJC_RELEASE(_textPassword);
    OBJC_RELEASE(_textAccount);
    OBJC_RELEASE(_btnSend);
    OBJC_RELEASE(_viewContent);
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 180;
}

@end
