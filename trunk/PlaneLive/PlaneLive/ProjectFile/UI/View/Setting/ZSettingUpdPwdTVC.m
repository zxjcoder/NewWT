//
//  ZSettingUpdPwdTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSettingUpdPwdTVC.h"
#import "ZTextField.h"

@interface ZSettingUpdPwdTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) ZTextField *textPwd;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZSettingUpdPwdTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellType:(ZSettingUpdPwdTVCType)cellType
{
    self = [self initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setType:cellType];
        //[self innerData];
    }
    return self;
}

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
    
    self.cellH = [ZSettingUpdPwdTVC getH];
    
    [self.viewMain setBackgroundColor:CLEARCOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.textPwd = [[ZTextField alloc] init];
    [self.textPwd setIsShowLine:false];
    [self.textPwd setTextFieldIndex:ZTextFieldIndexUpdatePwd];
    [self.textPwd setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textPwd setReturnKeyType:(UIReturnKeyDone)];
    [self.textPwd setSecureTextEntry:YES];
    [self.textPwd setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textPwd setMaxLength:kNumberPasswordMaxLength];
    [self.viewMain addSubview:self.textPwd];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
}

-(void)innerData
{
    switch (self.type) {
        case ZSettingUpdPwdTVCTypeOldPwd:
        {
            [self.lbTitle setText:[NSString stringWithFormat:@"%@: ", kOldPassword]];
            [self.textPwd setPlaceholder:kPleaseEnterOldPassword];
            break;
        }
        case ZSettingUpdPwdTVCTypeNewPwd:
        {
            [self.lbTitle setText:[NSString stringWithFormat:@"%@: ", kNewPassword]];
            [self.textPwd setPlaceholder:kPleaseEnterNewPassword];
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
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, self.leftW, self.lbH)];
    
    [self.textPwd setViewFrame:CGRectMake(self.rightX, 2, self.cellW-self.rightX-self.space, 40)];
    
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
    
    [self innerData];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_textPwd);
    OBJC_RELEASE(_imgLine);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 45;
}

@end
