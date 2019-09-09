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

@property (strong, nonatomic) ZTextField *textAccount;
@property (strong, nonatomic) ZTextField *textPassword;

@end

@implementation ZLoginAccountTVC

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
    
    self.cellH = [ZLoginAccountTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat spaceX = 40 * kViewSace;
    if (IsIPhone5 || IsIPhone4) {
        spaceX = 20;
    }
    CGFloat spaceY = 20;
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(spaceX, spaceY, self.cellW-spaceX*2, 120)];
    self.viewContent.backgroundColor = CLEARCOLOR;
    [self.viewMain addSubview:self.viewContent];
    
    CGFloat textHeight = 38;
    self.textAccount = [[ZTextField alloc] initWithFrame:(CGRectMake(0, 11, self.viewContent.width, textHeight))];
    [self.textAccount setPlaceholder:kPleaseEnterPhone];
    [self.textAccount setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexLoginAccount];
    [self.textAccount setTextInputType:(ZTextFieldInputTypeAccount)];
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
    [self.viewContent addSubview:self.textAccount];

    self.textPassword = [[ZTextField alloc] initWithFrame:CGRectMake(0, 66, self.viewContent.width, textHeight)];
    [self.textPassword setTextFieldIndex:ZTextFieldIndexLoginPwd];
    [self.textPassword setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textPassword setTextColor:COLORTEXT3];
    [self.textPassword setTextInputType:(ZTextFieldInputTypePassword)];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setPlaceholder:kPleaseEnterPasswordLengthLimitCharacter];
    [self.textPassword setMaxLength:kNumberPasswordMaxLength];
    [self.textPassword setOnBeginEditText:^{
        if (weakSelf.onPasswordBeginEditText) {
            weakSelf.onPasswordBeginEditText();
        }
    }];
    [self.viewContent addSubview:self.textPassword];
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
    return 140;
}

@end
