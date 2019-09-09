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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setTextAlignment:(NSTextAlignmentRight)];
    [self.lbDesc setTextColor:DESCCOLOR];
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
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:kUpdatePassword];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeBlackListManager:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:kBlacklistManager];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeExitUser:
        {
            [self setAccessoryType:(UITableViewCellAccessoryNone)];
            [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
            [self.lbTitle setText:kExitAccount];
            [self.lbDesc setHidden:YES];
            [self.imgLine setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeClearCache:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryNone)];
            [self.lbTitle setText:kClearCache];
            [self.lbDesc setHidden:NO];
            [self.lbDesc setText:@"0MB"];
            break;
        }
        case ZSettingItemTVCTypeAgreement:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:kMyAgreement];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeFontSize:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryNone)];
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
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:kAbout];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeScore:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:kGoScore];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeNotice:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:kPushSetting];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeWelcomePage:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:kWelComePage];
            [self.lbDesc setHidden:YES];
            break;
        }
        default:break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, self.cellW-self.space*2, self.lbH)];
    
    [self.lbDesc setFrame:CGRectMake(self.cellW-100, self.cellH/2-self.lbH/2, 90, self.lbH)];
    
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
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
