//
//  ZLoginButtonTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginButtonTVC.h"

@interface ZLoginButtonTVC()

@property (strong, nonatomic) UIButton *btnForgotPwd;

@property (strong, nonatomic) UIButton *btnRegister;

@property (strong, nonatomic) UIButton *btnLogin;

@end

@implementation ZLoginButtonTVC

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
    
    self.btnForgotPwd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnForgotPwd setTitle:[NSString stringWithFormat:@"%@?", kForgetPassword] forState:(UIControlStateNormal)];
    [self.btnForgotPwd setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnForgotPwd titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.btnForgotPwd setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [self.btnForgotPwd addTarget:self action:@selector(btnForgotPwdClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnForgotPwd];
    
    self.btnRegister = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnRegister setTitle:kRefisterSpace forState:(UIControlStateNormal)];
    [self.btnRegister setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnRegister titleLabel] setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [self.btnRegister setViewRoundWithRound];
    [self.btnRegister addTarget:self action:@selector(btnRegisterClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnRegister];
    
    self.btnLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnLogin setTitle:kLoginSpace forState:(UIControlStateNormal)];
    [self.btnLogin setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnLogin setBackgroundColor:MAINCOLOR];
    [self.btnLogin setViewRoundWithRound];
    [[self.btnLogin titleLabel] setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [self.btnLogin addTarget:self action:@selector(btnLoginClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnLogin];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat spaceX = 40;
    CGFloat btnFPW = 70;
    
    [self.btnForgotPwd setFrame:CGRectMake(self.cellW-spaceX-btnFPW, kSize10, btnFPW, 30)];
    CGFloat btnIW = (self.cellW-spaceX*2)/2-self.space/2;
    [self.btnRegister setFrame:CGRectMake(spaceX, 50, btnIW, 35)];
    [self.btnLogin setFrame:CGRectMake(spaceX+self.space+btnIW, 50, btnIW, 35)];
}

-(void)btnForgotPwdClick
{
    if (self.onForgotPwdClick) {
        self.onForgotPwdClick();
    }
}

-(void)btnRegisterClick
{
    if (self.onRegisterClick) {
        self.onRegisterClick();
    }
}

-(void)btnLoginClick
{
    if (self.onLoginClick) {
        self.onLoginClick();
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnForgotPwd);
    OBJC_RELEASE(_btnRegister);
    OBJC_RELEASE(_btnLogin);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 120;
}
+(CGFloat)getH
{
    return 120;
}

@end
