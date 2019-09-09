//
//  ZUserItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserItemTVC.h"

@interface ZUserItemTVC()

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIView *viewL;

@end

@implementation ZUserItemTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellType:(ZUserItemTVCType)cellType
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
    [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
 
    self.imgIcon = [[UIImageView alloc] init];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)innerData
{
    switch (self.type) {
        case ZUserItemTVCTypeCollection:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_shoucang"]];
            [self.lbTitle setText:@"我的收藏"];
            break;
        case ZUserItemTVCTypeAnswer:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_answer"]];
            [self.lbTitle setText:@"我的回答"];
            break;
        case ZUserItemTVCTypeAttention:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_guanzhu"]];
            [self.lbTitle setText:@"我的关注"];
            break;
        case ZUserItemTVCTypeFeedback:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_yijianfankui"]];
            [self.lbTitle setText:@"意见反馈"];
            break;
        case ZUserItemTVCTypeSetting:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_settings"]];
            [self.lbTitle setText:@"设置"];
            break;
        case ZUserItemTVCTypeAgreement:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_xieyi"]];
            [self.lbTitle setText:@"梧桐圈协议"];
            break;
        default:break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgIcon setFrame:CGRectMake(self.space, self.space+3.5, 18, 18)];
    [self.lbTitle setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width+self.space, self.space+1, self.cellW, self.lbH)];
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewL);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

@end
