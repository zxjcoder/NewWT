//
//  ZLoginButtonTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginButtonTVC.h"
#import "ZShadowButtonView.h"

@interface ZLoginButtonTVC()

@property (strong, nonatomic) UIButton *btnForgotPwd;
@property (strong, nonatomic) ZShadowButtonView *btnLogin;
@property (strong, nonatomic) UIButton *btnRegister;
//@property (strong, nonatomic) UIView *viewLogin;

@end

@implementation ZLoginButtonTVC

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
    
    self.cellH = [ZLoginButtonTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat spaceX = 40 * kViewSace;
    if (IsIPhone5 || IsIPhone4) {
        spaceX = 20;
    }
    ZWEAKSELF
    self.btnLogin = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(spaceX, 5, self.cellW-spaceX*2, 40))];
    [self.btnLogin setOnButtonClick:^{
        [weakSelf btnLoginClick];
    }];
    [self.btnLogin setButtonTitle:kLoginSpace];
    [self.viewMain addSubview:self.btnLogin];
    
    self.btnForgotPwd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnForgotPwd setTitle:kForgetPassword forState:(UIControlStateNormal)];
    [self.btnForgotPwd setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [[self.btnForgotPwd titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnForgotPwd setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [self.btnForgotPwd addTarget:self action:@selector(btnForgotPwdClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnForgotPwd];
    
    self.btnRegister = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnRegister setTitle:@"手机注册" forState:(UIControlStateNormal)];
    [self.btnRegister setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
    [[self.btnRegister titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnRegister setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [self.btnRegister addTarget:self action:@selector(btnRegisterClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnRegister];
    
    CGFloat btnFPW = 70;
    [self.btnForgotPwd setFrame:CGRectMake(self.cellW-spaceX-btnFPW, self.cellH - 30, btnFPW, 25)];
    [self.btnRegister setFrame:CGRectMake(spaceX, self.cellH - 30, btnFPW, 25)];
}
-(void)btnRegisterClick
{
    if (self.onRegisterClick) {
        self.onRegisterClick();
    }
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
    return 82;
}

@end
