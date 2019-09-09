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

@property (strong, nonatomic) UIImageView *imgAccount;

@property (strong, nonatomic) ZTextField *textAccount;

@property (strong, nonatomic) UIView *viewLine1;

@property (strong, nonatomic) UIImageView *imgCode;

@property (strong, nonatomic) ZTextField *textCode;

@property (strong, nonatomic) UIButton *btnSend;

@property (strong, nonatomic) UIView *viewLine2;

@property (strong, nonatomic) UIView *viewLine3;

@property (strong, nonatomic) UIImageView *imgPassword;

@property (strong, nonatomic) ZTextField *textPassword;

@property (strong, nonatomic) UIButton *btnShowPwd;

@end

@implementation ZRegisterAccountTVC

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
    
    self.cellH = self.getH;
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRoundWithNoBorder];
    [self.viewContent setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewContent];
    
    /**帐号**/
    
    self.imgAccount = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_account"]];
    [self.viewContent addSubview:self.imgAccount];
    
    self.textAccount = [[ZTextField alloc] init];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexRegisterAccount];
    [self.textAccount setKeyboardType:(UIKeyboardTypeEmailAddress)];
    [self.textAccount setReturnKeyType:(UIReturnKeyDone)];
    [self.textAccount setPlaceholder:kPleaseEnterPhoneOrEmail];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textAccount setMaxLength:kNumberAccountMaxLength];
    [self.viewContent addSubview:self.textAccount];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine1];
    
    /**验证码**/
    
    self.imgCode = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"login_code_icon"]];
    [self.viewContent addSubview:self.imgCode];
    
    self.textCode = [[ZTextField alloc] init];
    [self.textCode setTextFieldIndex:ZTextFieldIndexRegisterCode];
    [self.textCode setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textCode setReturnKeyType:(UIReturnKeyDone)];
    [self.textCode setPlaceholder:kPleaseEnterCode];
    [self.textCode setBorderStyle:(UITextBorderStyleNone)];
    [self.textCode setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textCode setMaxLength:kNumberCodeMaxLength];
    [self.viewContent addSubview:self.textCode];
    
    __weak typeof(self) vc = self;
    ZToolbar *toolBar = [[ZToolbar alloc] init];
    [toolBar setOnDoneClick:^{
        [vc.textCode resignFirstResponder];
    }];
    [self.textCode setInputAccessoryView:toolBar];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine2];
    
    self.btnSend = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSend setTitle:kGetCode forState:(UIControlStateNormal)];
    [self.btnSend setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnSend setTag:10];
    [self.btnSend setUserInteractionEnabled:YES];
    [[self.btnSend titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnSend addTarget:self action:@selector(btnSendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSend];
    
    self.viewLine3 = [[UIView alloc] init];
    [self.viewLine3 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine3];
    
    /**密码**/
    
    self.imgPassword = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_password"]];
    [self.viewContent addSubview:self.imgPassword];
    
    self.textPassword = [[ZTextField alloc] init];
    [self.textPassword setTextFieldIndex:ZTextFieldIndexRegisterPwd];
    [self.textPassword setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textPassword setReturnKeyType:(UIReturnKeyDone)];
    [self.textPassword setPlaceholder:kPleaseEnterNewPasswordLengthLimitCharacter];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setMaxLength:kNumberPasswordMaxLength];
    [self.viewContent addSubview:self.textPassword];
    
    self.btnShowPwd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnShowPwd setTag:10];
    [self.btnShowPwd setImage:[SkinManager getImageWithName:@"login_password_icon1"] forState:(UIControlStateNormal)];
    [self.btnShowPwd setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnShowPwd addTarget:self action:@selector(btnShowPwdClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnShowPwd];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int iCount = 3;
    [self.viewContent setFrame:CGRectMake(self.space, self.space*2, self.cellW-self.space*2, 45*iCount)];
    
    CGFloat spaceX = 10;
    CGFloat imgSize = 13;
    CGFloat imgaY = self.viewContent.height/iCount/2-imgSize/2;
    [self.imgAccount setFrame:CGRectMake(spaceX, imgaY, imgSize, imgSize)];
    CGFloat textH = 35;
    CGFloat textX = self.imgAccount.x+self.imgAccount.width+10;
    CGFloat textW = self.viewContent.width-textX-spaceX;
    CGFloat textY = self.viewContent.height/iCount/2-textH/2;
    [self.textAccount setViewFrame:CGRectMake(textX, textY, textW, textH)];
    
    [self.viewLine1 setFrame:CGRectMake(0, self.viewContent.height/iCount-1, self.viewContent.width, 0.7)];
    
    CGFloat btnW = 80;
    CGFloat imgcY = self.viewContent.height/iCount+1+imgaY;
    [self.imgCode setFrame:CGRectMake(spaceX, imgcY, imgSize, imgSize)];
    CGFloat textcY = self.viewContent.height/iCount+1+textY;
    [self.textCode setViewFrame:CGRectMake(textX, textcY, textW-btnW, textH)];
    
    [self.viewLine2 setFrame:CGRectMake(self.textCode.x+self.textCode.width, textcY, 1, textH)];
    [self.btnSend setFrame:CGRectMake(self.viewLine2.x+self.viewLine2.width+5, textcY, btnW, textH)];
    
    [self.viewLine3 setFrame:CGRectMake(0, self.viewContent.height/iCount*2-1, self.viewContent.width, 0.7)];
    
    CGFloat imgpY = self.viewContent.height/iCount*2+imgaY;
    [self.imgPassword setFrame:CGRectMake(spaceX, imgpY, imgSize, imgSize)];
    CGFloat textpY = self.viewContent.height/iCount*2+textY;
    [self.textPassword setViewFrame:CGRectMake(textX, textpY, textW-40, textH)];
    [self.btnShowPwd setFrame:CGRectMake(self.textPassword.x+self.textPassword.width, textpY, 40, textH)];
}

-(void)btnSendClick:(UIButton *)sender
{
    if (sender.tag == 10) {
        if (self.onSendCodeClick) {
            self.onSendCodeClick();
        }
    }
}

-(void)btnShowPwdClick:(UIButton *)sender
{
    if (self.btnShowPwd.tag == 10) {
        self.btnShowPwd.tag = 11;
        [self.textPassword setSecureTextEntry:NO];
        [self.textPassword setReplaceRange];
        [self.btnShowPwd setImage:[SkinManager getImageWithName:@"login_password_icon2"] forState:(UIControlStateNormal)];
    } else {
        self.btnShowPwd.tag = 10;
        [self.textPassword setSecureTextEntry:YES];
        [self.textPassword setReplaceRange];
        [self.btnShowPwd setImage:[SkinManager getImageWithName:@"login_password_icon1"] forState:(UIControlStateNormal)];
    }
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
    OBJC_RELEASE(_imgCode);
    OBJC_RELEASE(_imgAccount);
    OBJC_RELEASE(_imgPassword);
    OBJC_RELEASE(_btnSend);
    OBJC_RELEASE(_btnShowPwd);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_viewLine3);
    OBJC_RELEASE(_viewContent);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 45*3+40;
}
+(CGFloat)getH
{
    return 45*3+40;
}

@end
