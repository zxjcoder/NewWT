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

@property (strong, nonatomic) UIImageView *imgAccount;

@property (strong, nonatomic) ZTextField *textAccount;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZAccountPhoneTVC

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
    
    self.cellH = [ZAccountPhoneTVC getH];
    self.space = 40*kViewSace;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgAccount = [[UIImageView alloc] init];
    [self.viewMain addSubview:self.imgAccount];
    
    self.textAccount = [[ZTextField alloc] init];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexBindAccount];
    [self.textAccount setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textAccount setReturnKeyType:(UIReturnKeyDone)];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textAccount setMaxLength:kNumberPhomeMaxLength];
    [self.viewMain addSubview:self.textAccount];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 24;
    CGFloat imgaY = self.cellH/2-imgSize/2;
    [self.imgAccount setFrame:CGRectMake(self.space, imgaY, imgSize, imgSize)];
    CGFloat textH = 35;
    CGFloat textX = self.imgAccount.x+self.imgAccount.width+10;
    CGFloat textW = self.cellW-textX-self.space;
    CGFloat textY = self.cellH/2-textH/2+3;
    [self.textAccount setViewFrame:CGRectMake(textX, textY, textW, textH)];
    
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-self.lineH, self.cellW-self.space*2, self.lineH)];
    
    self.imgAccount.image = [SkinManager getImageWithName:@"user"];
    [self.textAccount setPlaceholder:kPleaseEnterPhone];
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
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_textAccount);
    OBJC_RELEASE(_imgAccount);
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
