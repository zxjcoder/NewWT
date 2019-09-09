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

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) UIView *viewPassword;
@property (strong, nonatomic) UIImageView *imgPassword;
@property (strong, nonatomic) ZTextField *textPassword;

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
    
    CGFloat spaceX = kSizeSpace;
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(spaceX, 15, self.cellW-spaceX*2, 90)];
    [self.viewContent setViewRound:5 borderWidth:1 borderColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    self.viewAccount = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewContent.width, self.viewContent.height/2)];
    [self.viewContent addSubview:self.viewAccount];
    
    CGFloat imgSize = 13;
    self.imgAccount = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_account"]];
    [self.imgAccount setFrame:CGRectMake(10, self.viewAccount.height/2-imgSize/2, imgSize, imgSize)];
    [self.viewAccount addSubview:self.imgAccount];
    
    CGFloat textH = 35;
    CGFloat textX = self.imgAccount.x+self.imgAccount.width+10;
    CGFloat textW = self.viewAccount.width-textX-5;
    self.textAccount = [[ZTextField alloc] init];
    [self.textAccount setViewFrame:CGRectMake(textX, self.viewAccount.height/2-textH/2, textW, textH)];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexLoginAccount];
    [self.textAccount setKeyboardType:(UIKeyboardTypePhonePad)];
    [self.textAccount setPlaceholder:kPleaseEnterPhone];
    ZWEAKSELF
    [self.textAccount setOnEndEditText:^(NSString *text) {
        if (weakSelf.onAccountBeginEditText) {
            weakSelf.onAccountBeginEditText();
        }
    }];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textAccount setMaxLength:kNumberPhomeMaxLength];
    [self.viewAccount addSubview:self.textAccount];
    
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, self.viewContent.height/2, self.viewContent.width, self.lineH)];
    [self.viewContent addSubview:self.imgLine];
    
    self.viewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewContent.height/2, self.viewContent.width, self.viewContent.height/2)];
    [self.viewContent addSubview:self.viewPassword];
    
    self.imgPassword = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_password"]];
    [self.imgPassword setFrame:CGRectMake(10, self.viewPassword.height/2-imgSize/2, imgSize, imgSize)];
    [self.viewPassword addSubview:self.imgPassword];
    
    self.textPassword = [[ZTextField alloc] init];
    [self.textPassword setViewFrame:CGRectMake(textX, self.viewAccount.height/2-textH/2, textW, textH)];
    [self.textPassword setTextFieldIndex:ZTextFieldIndexLoginPwd];
    [self.textPassword setKeyboardType:(UIKeyboardTypeEmailAddress)];
    [self.textPassword setPlaceholder:kPleaseEnterPasswordLengthLimitCharacter];
    [self.textPassword setBorderStyle:(UITextBorderStyleNone)];
    [self.textPassword setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setOnEndEditText:^(NSString *text) {
        if (weakSelf.onPasswordBeginEditText) {
            weakSelf.onPasswordBeginEditText();
        }
    }];
    [self.textPassword setMaxLength:kNumberPasswordMaxLength];
    [self.viewPassword addSubview:self.textPassword];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
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
    return 105;
}

@end
