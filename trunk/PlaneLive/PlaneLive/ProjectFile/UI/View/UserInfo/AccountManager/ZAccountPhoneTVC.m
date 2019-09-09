//
//  ZAccountPhoneTVC.m
//  PlaneLive
//
//  Created by Daniel on 30/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountPhoneTVC.h"
#import "Utils.h"
#import "ZTextField.h"

@interface ZAccountPhoneTVC()

@property (strong, nonatomic) ZTextField *textAccount;

@end

@implementation ZAccountPhoneTVC

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
    
    self.cellH = [ZAccountPhoneTVC getH];
    self.space = 40*kViewSace;
    if (IsIPhone4 || IsIPhone5) {
        self.space = 20;
    }
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat textHeight = 38;
    self.textAccount = [[ZTextField alloc] initWithFrame:(CGRectMake(self.space, 6, self.cellW-self.space*2, textHeight))];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexBindAccount];
    [self.textAccount setTextInputType:(ZTextFieldInputTypeAccount)];
    [self.textAccount setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textAccount setReturnKeyType:(UIReturnKeyDone)];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textAccount setMaxLength:kNumberPhomeMaxLength];
    [self.textAccount setPlaceholder:kPleaseEnterPhone];
    [self.viewMain addSubview:self.textAccount];
}
///设置帐号
-(void)setAccountText:(NSString *)text
{
    [self.textAccount setText:text];
}
///获取帐号
-(NSString *)getAccountText
{
    return self.textAccount.text;
}
-(void)setTextFieldEnabled:(BOOL)isEnabled
{
    [self.textAccount setEnabled:isEnabled];
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textAccount setText:model.phone];
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_textAccount);
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
