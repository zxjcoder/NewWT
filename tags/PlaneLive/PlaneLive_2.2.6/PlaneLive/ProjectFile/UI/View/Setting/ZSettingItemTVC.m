//
//  ZSettingItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSettingItemTVC.h"
#import "AppSetting.h"

@interface ZSettingItemTVC()

@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UILabel *lbDesc;
@property (strong, nonatomic) UISwitch *switchBugout;
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZSettingItemTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellType:(ZSettingItemTVCType)cellType
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
    
    self.cellH = [ZSettingItemTVC getH];
    self.space = 20;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setTextAlignment:(NSTextAlignmentRight)];
    [self.lbDesc setTextColor:COLORTEXT3];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbDesc];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
}

-(void)innerData
{
    switch (self.type) {
        case ZSettingItemTVCTypeUpdatePwd:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kUpdatePassword];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeBlackListManager:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kBlacklistManager];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeExitUser:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
            [self.lbTitle setText:kExitAccount];
            [self.lbDesc setHidden:YES];
            [self.imgLine setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeClearCache:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kClearCache];
            [self.lbDesc setHidden:NO];
            [self.lbDesc setText:@"0MB"];
            break;
        }
        case ZSettingItemTVCTypeAgreement:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kMyAgreement];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeFontSize:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kFontSize];
            [self.lbDesc setHidden:NO];
            NSString *fontSize = [AppSetting getFontSize];
            switch ([fontSize intValue]) {
                case kFont_Set_Min_Size:
                    [self.lbDesc setText:kSmall];
                    break;
                case kFont_Set_Default_Size:
                    [self.lbDesc setText:kStandard];
                    break;
                case kFont_Set_Middle_Size:
                    [self.lbDesc setText:kSecondary];
                    break;
                case kFont_Set_Big_Size:
                    [self.lbDesc setText:kLarge];
                    break;
                case kFont_Set_Large_Size:
                    [self.lbDesc setText:kExtremely];
                    break;
                default:
                    [self.lbDesc setText:kStandard];
                    break;
            }
            break;
        }
        case ZSettingItemTVCTypeAbout:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kAbout];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeScore:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kGoScore];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeNotice:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kPushSetting];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeWelcomePage:
        {
            [self setImageAccessoryView];
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self.lbTitle setText:kWelComePage];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeBugout:
        {
            [self.lbDesc setHidden:YES];
            [self.lbTitle setText:kShakeSetting];
            self.switchBugout = [[UISwitch alloc] initWithFrame:CGRectMake(self.cellW-70, self.cellH/2-30/2, 30, 30)];
            [self.switchBugout setOnTintColor:MAINCOLOR];
            [self.switchBugout setOnImage:[SkinManager getImageWithName:@"btn_gra1"]];
            [self.switchBugout setButtonShadowColor];
            [self.switchBugout addTarget:self action:@selector(switchBugoutChange:) forControlEvents:(UIControlEventValueChanged)];
            NSLogFrame(self.switchBugout.frame);
            [self.viewMain addSubview:self.switchBugout];
            break;
        }
        default:break;
    }
}
-(void)switchBugoutChange:(UISwitch *)sender
{
    if (self.onBugoutValueChange) {
        self.onBugoutValueChange(sender.on);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    switch (self.type) {
        case ZSettingItemTVCTypeExitUser:
        {
            [self.lbTitle setShadowColorWithRadius:20];
            [self.lbTitle setFrame:CGRectMake(self.space, self.cellH/2-40/2, self.cellW-self.space*2, 40)];
            break;
        }
        default:
        {
            [self.lbTitle setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, self.cellW-self.space*2, self.lbH)];
            [self.lbDesc setFrame:CGRectMake(self.arrowX-95, self.cellH/2-self.lbH/2, 100, self.lbH)];
            break;
        }
    }
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-self.lineH, self.cellW-self.space*2, self.lineH)];
}
///设置Bugout开关
-(void)setBugoutOn:(BOOL)on
{
    self.switchBugout.on = on;
}
-(void)setViewFileSize:(float)size
{
    [self.lbDesc setText:[NSString stringWithFormat:@"%.2fMB",size]];
}

-(void)setViewFontSize:(int)size
{
    switch (size) {
        case kFont_Set_Min_Size:
            [self.lbDesc setText:kSmall];
            break;
        case kFont_Set_Default_Size:
            [self.lbDesc setText:kStandard];
            break;
        case kFont_Set_Middle_Size:
            [self.lbDesc setText:kSecondary];
            break;
        case kFont_Set_Big_Size:
            [self.lbDesc setText:kLarge];
            break;
        case kFont_Set_Large_Size:
            [self.lbDesc setText:kExtremely];
            break;
        default:
            [self.lbDesc setText:kStandard];
            break;
    }
}
-(void)setHiddenLine
{
    [self.imgLine setHidden:YES];
}

-(void)setViewNil
{
    OBJC_RELEASE(_switchBugout);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTitle);
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
