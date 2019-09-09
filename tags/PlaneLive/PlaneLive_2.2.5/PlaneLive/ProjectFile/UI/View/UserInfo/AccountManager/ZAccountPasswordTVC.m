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

@property (strong, nonatomic) UIImageView *imgPassword;
@property (strong, nonatomic) ZTextField *textPassword;
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZAccountPasswordTVC

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
    
    self.cellH = [ZAccountPasswordTVC getH];
    self.space = 40*kViewSace;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgPassword = [[UIImageView alloc] init];
    [self.viewMain addSubview:self.imgPassword];
    
    self.textPassword = [[ZTextField alloc] init];
    [self.textPassword setTextFieldIndex:ZTextFieldIndexBindPassword];
    [self.textPassword setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textPassword setReturnKeyType:(UIReturnKeyDone)];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setMaxLength:kNumberPasswordMaxLength];
    [self.viewMain addSubview:self.textPassword];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 24;
    CGFloat imgaY = self.cellH/2-imgSize/2;
    [self.imgPassword setFrame:CGRectMake(self.space, imgaY, imgSize, imgSize)];
    CGFloat textH = 35;
    CGFloat textX = self.imgPassword.x+self.imgPassword.width+10;
    CGFloat textW = self.cellW-textX-self.space;
    CGFloat textY = self.cellH/2-textH/2+3;
    [self.textPassword setViewFrame:CGRectMake(textX, textY, textW, textH)];
    
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-self.lineH, self.cellW-self.space*2, self.lineH)];
    
    self.imgPassword.image = [SkinManager getImageWithName:@"password"];
    [self.textPassword setPlaceholder:kPleaseEnterNewPasswordLengthLimitCharacter];
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
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_textPassword);
    OBJC_RELEASE(_imgPassword);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 55;
}

@end
