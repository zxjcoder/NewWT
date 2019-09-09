//
//  ZLoginAccountTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginAccountTVC.h"
#import "Utils.h"
#import "ZTextField.h"

@interface ZLoginAccountTVC()

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UIView *viewAccount;
@property (strong, nonatomic) UIImageView *imgAccount;
@property (strong, nonatomic) ZTextField *textAccount;
@property (strong, nonatomic) UIImageView *imgLineAccount;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) UIView *viewPassword;
@property (strong, nonatomic) UIImageView *imgPassword;
@property (strong, nonatomic) ZTextField *textPassword;
@property (strong, nonatomic) UIImageView *imgLinePassword;

@end

@implementation ZLoginAccountTVC

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
    
    self.cellH = [ZLoginAccountTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat spaceX = 40 * kViewSace;
    CGFloat spaceY = 15;
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(spaceX, spaceY, self.cellW-spaceX*2, 100)];
    self.viewContent.backgroundColor = CLEARCOLOR;
    [self.viewMain addSubview:self.viewContent];
    
    self.viewAccount = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewContent.width, self.viewContent.height/2)];
    [self.viewContent addSubview:self.viewAccount];
    
    CGFloat imgSize = 24;
    self.imgAccount = [[UIImageView alloc] init];
    [self.imgAccount setFrame:CGRectMake(0, (self.viewAccount.height - spaceY)/2-imgSize/2, imgSize, imgSize)];
    [self.viewAccount addSubview:self.imgAccount];
    
    CGFloat textH = 35;
    CGFloat textX = self.imgAccount.x+self.imgAccount.width+10;
    CGFloat textW = self.viewAccount.width-textX-5;
    self.textAccount = [[ZTextField alloc] initWithFrame:CGRectMake(textX, (self.viewAccount.height - spaceY)/2-textH/2+2, textW, textH)];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexLoginAccount];
    [self.textAccount setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textAccount setTextColor:COLORTEXT3];
    ZWEAKSELF
    [self.textAccount setOnBeginEditText:^{
        if (weakSelf.onAccountBeginEditText) {
            weakSelf.onAccountBeginEditText();
        }
    }];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textAccount setMaxLength:kNumberPhomeMaxLength];
    [self.viewAccount addSubview:self.textAccount];
    
    self.imgLineAccount = [UIImageView getDLineView];
    self.imgLineAccount.frame = CGRectMake(0, self.viewAccount.height - spaceY + 5, self.viewAccount.width, kLineHeight);
    [self.viewAccount addSubview:self.imgLineAccount];
    
    self.viewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewContent.height/2, self.viewContent.width, self.viewContent.height/2)];
    [self.viewContent addSubview:self.viewPassword];
    
    self.imgPassword = [[UIImageView alloc] init];
    [self.imgPassword setFrame:CGRectMake(0, spaceY + (self.viewPassword.height - spaceY)/2-imgSize/2, imgSize, imgSize)];
    [self.viewPassword addSubview:self.imgPassword];
    
    self.textPassword = [[ZTextField alloc] initWithFrame:CGRectMake(textX, spaceY + (self.viewAccount.height - spaceY)/2-textH/2+2, textW, textH)];
    [self.textPassword setTextFieldIndex:ZTextFieldIndexLoginPwd];
    [self.textPassword setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textPassword setTextColor:COLORTEXT3];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setMaxLength:kNumberPasswordMaxLength];
    [self.textPassword setOnBeginEditText:^{
        if (weakSelf.onPasswordBeginEditText) {
            weakSelf.onPasswordBeginEditText();
        }
    }];
    [self.viewPassword addSubview:self.textPassword];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    self.imgLinePassword = [UIImageView getDLineView];
    self.imgLinePassword.frame = CGRectMake(self.viewContent.x, self.viewMain.height - 12, self.viewContent.width, kLineHeight);
    [self.viewMain addSubview:self.imgLinePassword];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgAccount.image = [SkinManager getImageWithName:@"user"];
    [self.textAccount setPlaceholder:kPleaseEnterPhone];
    
    self.imgPassword.image = [SkinManager getImageWithName:@"password"];
    [self.textPassword setPlaceholder:kPleaseEnterPasswordLengthLimitCharacter];
}
-(void)setAccountText:(NSString *)text
{
    [self.textAccount setText:text];
}
-(NSString *)getAccountText
{
    return [self.textAccount text];
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
    OBJC_RELEASE(_textAccount);
    OBJC_RELEASE(_textPassword);
    OBJC_RELEASE(_viewAccount);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewPassword);
    OBJC_RELEASE(_imgAccount);
    OBJC_RELEASE(_imgPassword);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_onAccountBeginEditText);
    OBJC_RELEASE(_onPasswordBeginEditText);
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 132;
}

@end
