//
//  ZSettingItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSettingItemTVC.h"

@interface ZSettingItemTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) UIView *viewL;

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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setTextAlignment:(NSTextAlignmentRight)];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbDesc];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)innerData
{
    switch (self.type) {
        case ZSettingItemTVCTypeUpdatePwd:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:@"修改密码"];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeBlackListManager:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            [self.lbTitle setText:@"黑名单管理"];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeExitUser:
        {
            [self setAccessoryType:(UITableViewCellAccessoryNone)];
            [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
            [self.lbTitle setText:@"退出账号"];
            [self.lbDesc setHidden:YES];
            break;
        }
        case ZSettingItemTVCTypeClearCache:
        {
            [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
            [self setAccessoryType:(UITableViewCellAccessoryNone)];
            [self.lbTitle setText:@"清除缓存"];
            [self.lbDesc setHidden:NO];
            [self.lbDesc setText:@"0MB"];
            break;
        }
        default:break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.space+1, self.cellW-self.space*2, self.lbH)];
    
    [self.lbDesc setFrame:CGRectMake(self.cellW-100, self.space+1, 90, self.lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setViewFileSize:(float)size
{
    [self.lbDesc setText:[NSString stringWithFormat:@"%.2fMB",size]];
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTitle);
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


@end
