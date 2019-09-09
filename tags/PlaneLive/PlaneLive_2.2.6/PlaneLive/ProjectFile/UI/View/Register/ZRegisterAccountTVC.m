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

@property (strong, nonatomic) UIView *viewAccount;
@property (strong, nonatomic) UIImageView *imgAccount;
@property (strong, nonatomic) ZTextField *textAccount;
@property (strong, nonatomic) UIImageView *viewLine1;

@property (strong, nonatomic) UIView *viewCode;
@property (strong, nonatomic) UIImageView *imgCode;
@property (strong, nonatomic) ZTextField *textCode;
@property (strong, nonatomic) UIButton *btnSend;
@property (strong, nonatomic) UIImageView *viewLine2;

@property (strong, nonatomic) UIView *viewPassword;
@property (strong, nonatomic) UIImageView *imgPassword;
@property (strong, nonatomic) ZTextField *textPassword;
@property (strong, nonatomic) UIImageView *viewLine3;

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
    
    self.cellH = [ZRegisterAccountTVC getH];
    
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR1];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewContent];
    
    /**帐号**/
    self.viewAccount = [[UIView alloc] init];
    [self.viewContent addSubview:self.viewAccount];
    
    self.imgAccount = [[UIImageView alloc] init];
    [self.viewAccount addSubview:self.imgAccount];
    
    self.textAccount = [[ZTextField alloc] init];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexRegisterAccount];
    [self.textAccount setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textAccount setReturnKeyType:(UIReturnKeyDone)];
    [self.textAccount setTextColor:COLORTEXT3];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textAccount setMaxLength:kNumberPhomeMaxLength];
    [self.viewAccount addSubview:self.textAccount];
    
    self.viewLine1 = [UIImageView getDLineView];
    [self.viewAccount addSubview:self.viewLine1];
    
    /**验证码**/
    
    self.viewCode = [[UIView alloc] init];
    [self.viewContent addSubview:self.viewCode];
    
    self.imgCode = [[UIImageView alloc] init];
    [self.viewCode addSubview:self.imgCode];
    
    self.textCode = [[ZTextField alloc] init];
    [self.textCode setTextFieldIndex:ZTextFieldIndexRegisterCode];
    [self.textCode setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textCode setReturnKeyType:(UIReturnKeyDone)];
    [self.textCode setTextColor:COLORTEXT3];
    [self.textCode setBorderStyle:(UITextBorderStyleNone)];
    [self.textCode setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textCode setMaxLength:kNumberCodeMaxLength];
    [self.viewCode addSubview:self.textCode];
    
    self.viewLine2 = [UIImageView getDLineView];
    [self.viewCode addSubview:self.viewLine2];
    
    self.btnSend = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSend setTitle:kGetCode forState:(UIControlStateNormal)];
    [self.btnSend setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
    [self.btnSend setTag:10];
    [self.btnSend setUserInteractionEnabled:YES];
    [[self.btnSend titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.btnSend addTarget:self action:@selector(btnSendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewCode addSubview:self.btnSend];
    
    /**密码**/
    
    self.viewPassword = [[UIView alloc] init];
    [self.viewContent addSubview:self.viewPassword];
    
    self.viewLine3 = [UIImageView getDLineView];
    [self.viewPassword addSubview:self.viewLine3];
    
    self.imgPassword = [[UIImageView alloc] init];
    [self.viewPassword addSubview:self.imgPassword];
    
    self.textPassword = [[ZTextField alloc] init];
    [self.textPassword setTextFieldIndex:ZTextFieldIndexRegisterPwd];
    [self.textPassword setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textPassword setReturnKeyType:(UIReturnKeyDone)];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setTextColor:COLORTEXT3];
    [self.textPassword setMaxLength:kNumberPasswordMaxLength];
    [self.viewPassword addSubview:self.textPassword];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int iCount = 3;
    CGFloat itemH = 50;
    CGFloat spaceX = 40 * kViewSace;
    [self.viewContent setFrame:CGRectMake(spaceX, 30, self.cellW - spaceX*2, itemH*iCount)];
    
    [self.viewAccount setFrame:(CGRectMake(0, 0, self.viewContent.width, itemH))];
    [self.viewCode setFrame:(CGRectMake(0, self.viewAccount.y + self.viewAccount.height, self.viewContent.width, itemH))];
    [self.viewPassword setFrame:(CGRectMake(0, self.viewCode.y + self.viewCode.height, self.viewContent.width, itemH))];
    
    CGFloat imgSize = 24;
    CGFloat imgaY = self.viewAccount.height / 2 - imgSize/2;
    [self.imgAccount setFrame:CGRectMake(0, imgaY, imgSize, imgSize)];
    CGFloat textH = 35;
    CGFloat textX = self.imgAccount.x+self.imgAccount.width+10;
    CGFloat textW = self.viewContent.width-textX;
    CGFloat textY = self.viewAccount.height / 2 - textH/2;
    [self.textAccount setViewFrame:CGRectMake(textX, textY, textW, textH)];
    
    [self.viewLine1 setFrame:CGRectMake(0, self.viewAccount.height-kLineHeight, self.viewAccount.width, kLineHeight)];
    
    CGFloat btnW = 85;
    [self.imgCode setFrame:CGRectMake(0, imgaY, imgSize, imgSize)];
    [self.textCode setViewFrame:CGRectMake(textX, textY, textW-btnW-3, textH)];
    
    [self.viewLine2 setFrame:CGRectMake(0, self.viewPassword.height-kLineHeight, self.viewPassword.width, kLineHeight)];
    [self.btnSend setFrame:CGRectMake(self.textCode.x + self.textCode.width + 3, textY, btnW, textH)];
    
    [self.imgPassword setFrame:CGRectMake(0, imgaY, imgSize, imgSize)];
    [self.textPassword setViewFrame:CGRectMake(textX, textY, textW, textH)];
    
    [self.viewLine3 setFrame:CGRectMake(0, self.viewPassword.height-kLineHeight, self.viewPassword.width, kLineHeight)];
    
    self.imgAccount.image = [SkinManager getImageWithName:@"user"];
    self.imgCode.image = [SkinManager getImageWithName:@"verify_code"];
    self.imgPassword.image = [SkinManager getImageWithName:@"password"];
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
    [self.btnSend setTitle:kSendCode forState:(UIControlStateNormal)];
    [self.btnSend setTitleColor:COLORCONTENT1 forState:UIControlStateNormal];
}
-(void)timerCallback
{
    if (_time<=0) {
        _time=0;
        OBJC_RELEASE_TIMER(_timer);
        [self.btnSend setTag:10];
        [self.btnSend setTitle:kSendCode forState:(UIControlStateNormal)];
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
    OBJC_RELEASE(_imgCode);
    OBJC_RELEASE(_imgAccount);
    OBJC_RELEASE(_imgPassword);
    OBJC_RELEASE(_btnSend);
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
+(CGFloat)getH
{
    return 205;
}

@end
