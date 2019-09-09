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
@property (strong, nonatomic) UIButton *btnRegister;
@property (strong, nonatomic) UIView *viewLogin;

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
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
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
    [self.btnRegister setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [self.btnRegister addTarget:self action:@selector(btnRegisterClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnRegister];
    
    self.btnLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnLogin setTitle:kLoginSpace forState:(UIControlStateNormal)];
    [self.btnLogin setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[self.btnLogin titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.btnLogin addTarget:self action:@selector(btnLoginClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    CGFloat spaceX = 40 * kViewSace;
    CGFloat btnFPW = 70;
    [self.btnForgotPwd setFrame:CGRectMake(self.cellW-spaceX-btnFPW, self.cellH - 30, btnFPW, 25)];
    [self.btnRegister setFrame:CGRectMake(spaceX, self.cellH - 30, btnFPW, 25)];
    
    self.viewLogin = [[UIView alloc] initWithFrame:(CGRectMake(spaceX, 5, self.cellW-spaceX*2, 40))];
    [self.viewLogin setButtonShadowColorWithRadius:20];
    [self.viewMain addSubview:self.viewLogin];
    
    [self.btnLogin setFrame:self.viewLogin.bounds];
    [self.btnLogin setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1"] forState:(UIControlStateNormal)];
    [self.btnLogin setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1_c"] forState:(UIControlStateHighlighted)];
    
    //UIImage *imageS = [Utils resizedTransformtoSize:(CGSizeMake(self.btnLogin.width, self.btnLogin.height)) image:[UIImage imageNamed:@"btn_gra1_c"]];
    //UIImage *image = [Utils resizedTransformtoSize:(CGSizeMake(self.btnLogin.width, self.btnLogin.height)) image:[UIImage imageNamed:@"btn_gra1"]];
    //[self.btnLogin setBackgroundImage:image forState:(UIControlStateNormal)];
    //[self.btnLogin setBackgroundImage:imageS forState:(UIControlStateHighlighted)];
    [self.btnLogin.layer setMasksToBounds:true];
    [self.btnLogin setViewRound:20 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewLogin addSubview:self.btnLogin];
    
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
