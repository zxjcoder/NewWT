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
    
    self.cellH = [ZLoginButtonTVC getH];
    
    self.btnForgotPwd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnForgotPwd setTitle:kForgetPassword forState:(UIControlStateNormal)];
    [self.btnForgotPwd setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnForgotPwd titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnForgotPwd setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [self.btnForgotPwd addTarget:self action:@selector(btnForgotPwdClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnForgotPwd];
    
    self.btnLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnLogin setTitle:kLoginSpace forState:(UIControlStateNormal)];
    [self.btnLogin setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnLogin setBackgroundColor:MAINCOLOR];
    [self.btnLogin setViewRoundWithRound];
    [[self.btnLogin titleLabel] setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [self.btnLogin addTarget:self action:@selector(btnLoginClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnLogin];
    
    CGFloat spaceX = kSizeSpace;
    CGFloat btnFPW = 70;
    [self.btnForgotPwd setFrame:CGRectMake(self.cellW-spaceX-btnFPW, 5, btnFPW, 30)];
    [self.btnLogin setFrame:CGRectMake(spaceX, self.btnForgotPwd.y+self.btnForgotPwd.height+5, self.cellW-spaceX*2, 40)];
}
-(void)btnForgotPwdClick
{
    if (self.onForgotPwdClick) {
        self.onForgotPwdClick();
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
    OBJC_RELEASE(_btnLogin);
    OBJC_RELEASE(_onLoginClick);
    OBJC_RELEASE(_onForgotPwdClick);
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 120;
}

@end
