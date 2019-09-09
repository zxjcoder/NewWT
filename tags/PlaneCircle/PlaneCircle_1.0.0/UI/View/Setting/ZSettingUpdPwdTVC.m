//
//  ZSettingUpdPwdTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSettingUpdPwdTVC.h"

@interface ZSettingUpdPwdTVC()<UITextFieldDelegate>

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UITextField *textPwd;

@property (strong, nonatomic) UIView *viewL;

@end

@implementation ZSettingUpdPwdTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellType:(ZSettingUpdPwdTVCType)cellType
{
    self = [self initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setType:cellType];
        [self innerData];
    }
    return self;
}

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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.textPwd = [[UITextField alloc] init];
    [self.textPwd setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPwd setReturnKeyType:(UIReturnKeyDone)];
    [self.textPwd setDelegate:self];
    [self.textPwd setSecureTextEntry:YES];
    [self.textPwd setKeyboardType:(UIKeyboardTypeEmailAddress)];
    [self.viewMain addSubview:self.textPwd];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)innerData
{
    switch (self.type) {
        case ZSettingUpdPwdTVCTypeOldPwd:
        {
            [self.lbTitle setText:@"原密码: "];
            [self.textPwd setPlaceholder:@"请输入原密码"];
            break;
        }
        case ZSettingUpdPwdTVCTypeNewPwd:
        {
            [self.lbTitle setText:@"新密码: "];
            [self.textPwd setPlaceholder:@"请输入新密码"];
            break;
        }
        default:break;
    }
}

-(NSString *)getText
{
    return self.textPwd.text;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.space+1, self.leftW, self.lbH)];
    
    [self.textPwd setFrame:CGRectMake(self.rightX, 2, self.cellW-self.rightX-self.space, 40)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_textPwd);
    OBJC_RELEASE(_viewL);
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
