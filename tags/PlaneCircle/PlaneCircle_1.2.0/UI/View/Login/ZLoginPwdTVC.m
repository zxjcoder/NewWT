//
//  ZLoginPwdTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginPwdTVC.h"
#import "Utils.h"

@interface ZLoginPwdTVC()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UITextField *textPassword;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) UIButton *btnShowPwd;

@end

@implementation ZLoginPwdTVC

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
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_password"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.textPassword = [[UITextField alloc] init];
    [self.textPassword setKeyboardType:(UIKeyboardTypeEmailAddress)];
    [self.textPassword setReturnKeyType:(UIReturnKeyDone)];
    [self.textPassword setPlaceholder:@"请输入6-16位的密码"];
    [self.textPassword setDelegate:self];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.viewMain addSubview:self.textPassword];
    
    self.btnShowPwd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnShowPwd setTag:10];
    [self.btnShowPwd setImage:[SkinManager getImageWithName:@"login_password_icon1"] forState:(UIControlStateNormal)];
    [self.btnShowPwd setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnShowPwd addTarget:self action:@selector(btnShowPwdClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnShowPwd];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:RGBCOLOR(151, 151, 151)];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat spaceX = 40;
    CGFloat imgSize = 13;
    [self.imgIcon setFrame:CGRectMake(spaceX, self.cellH/2-imgSize/2, imgSize, imgSize)];
    CGFloat textH = 35;
    CGFloat textX = self.imgIcon.x+self.imgIcon.width+10;
    CGFloat textW = self.cellW-textX-spaceX;
    [self.textPassword setFrame:CGRectMake(textX, self.cellH/2-textH/2, textW-40, textH)];
    
    [self.btnShowPwd setFrame:CGRectMake(self.textPassword.x+self.textPassword.width, self.textPassword.y, 40, textH)];
    
    [self.viewLine setFrame:CGRectMake(spaceX, self.cellH-1, self.cellW-spaceX*2, 1)];
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

-(void)setText:(NSString *)text
{
    [self.textPassword setText:text];
}
-(NSString *)getText
{
    return [self.textPassword text];
}

-(void)setViewNil
{
    [self.textPassword setDelegate:nil];
    OBJC_RELEASE(_textPassword);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_btnShowPwd);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 45;
}
+(CGFloat)getH
{
    return 45;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([Utils isContainsEmoji:string]) {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.onBeginEditText) {
        self.onBeginEditText();
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
