//
//  ZLoginAccountTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginAccountTVC.h"
#import "Utils.h"

@interface ZLoginAccountTVC()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UITextField *textAccount;

@property (strong, nonatomic) UIView *viewLine;

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
    
    self.cellH = self.getH;
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_account"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.textAccount = [[UITextField alloc] init];
    [self.textAccount setKeyboardType:(UIKeyboardTypeEmailAddress)];
    [self.textAccount setReturnKeyType:(UIReturnKeyDone)];
    [self.textAccount setPlaceholder:@"请输入手机号/邮箱"];
    [self.textAccount setDelegate:self];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.viewMain addSubview:self.textAccount];
    
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
    [self.textAccount setFrame:CGRectMake(textX, self.cellH/2-textH/2, textW, textH)];
    
    [self.viewLine setFrame:CGRectMake(spaceX, self.cellH-1, self.cellW-spaceX*2, 1)];
}

-(void)setText:(NSString *)text
{
    [self.textAccount setText:text];
}
-(NSString *)getText
{
    return [self.textAccount text];
}

-(void)setViewNil
{
    [self.textAccount setDelegate:nil];
    OBJC_RELEASE(_textAccount);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_viewLine);
    
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
