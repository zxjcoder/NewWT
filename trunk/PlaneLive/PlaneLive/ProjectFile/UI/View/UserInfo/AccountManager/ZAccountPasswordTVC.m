//
//  ZAccountPasswordTVC.m
//  PlaneLive
//
//  Created by Daniel on 01/12/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountPasswordTVC.h"
#import "Utils.h"
#import "ZTextField.h"

@interface ZAccountPasswordTVC()

@property (strong, nonatomic) ZTextField *textPassword;

@end

@implementation ZAccountPasswordTVC

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
    
    self.cellH = [ZAccountPasswordTVC getH];
    self.space = 40*kViewSace;
    if (IsIPhone4 || IsIPhone5) {
        self.space = 20;
    }
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat textHeight = 38;
    self.textPassword = [[ZTextField alloc] initWithFrame:(CGRectMake(self.space, 6, self.cellW-self.space*2, textHeight))];
    [self.textPassword setTextFieldIndex:ZTextFieldIndexBindPassword];
    [self.textPassword setTextInputType:(ZTextFieldInputTypePassword)];
    [self.textPassword setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textPassword setReturnKeyType:(UIReturnKeyDone)];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setMaxLength:kNumberPasswordMaxLength];
    [self.textPassword setPlaceholder:kPleaseEnterNewPasswordLengthLimitCharacter];
    [self.viewMain addSubview:self.textPassword];
}
///设置帐号
-(void)setPasswordText:(NSString *)text
{
    [self.textPassword setText:text];
}
///获取帐号
-(NSString *)getPasswordText
{
    return self.textPassword.text;
}
-(void)setViewNil
{
    OBJC_RELEASE(_textPassword);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 50;
}

@end
