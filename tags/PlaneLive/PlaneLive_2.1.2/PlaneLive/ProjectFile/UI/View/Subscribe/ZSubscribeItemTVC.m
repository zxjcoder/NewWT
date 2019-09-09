//
//  ZSubscribeItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeItemTVC.h"
#import "ZCalculateLabel.h"

@interface ZSubscribeItemTVC()

@property (strong, nonatomic) ZImageView *imgIcon;
///标题
@property (strong, nonatomic) ZLabel *lbTitle;
///团队
@property (strong, nonatomic) ZLabel *lbTeam;
///描述
@property (strong, nonatomic) ZLabel *lbDesc;
///时间
@property (strong, nonatomic) ZLabel *lbTime;
///价格
@property (strong, nonatomic) ZLabel *lbPrice;
@property (strong, nonatomic) UIImageView *imgLine;
@property (strong, nonatomic) ModelSubscribe *model;

@end

@implementation ZSubscribeItemTVC

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
    
    self.cellH = [ZSubscribeItemTVC getH];
    
    self.imgIcon = [[ZImageView alloc] initWithImage:[SkinManager getDefaultImage]];
    [self.imgIcon setUserInteractionEnabled:YES];
    [self.imgIcon.layer setMasksToBounds:YES];
    [self.imgIcon setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[ZLabel alloc] init];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbDesc setNumberOfLines:2];
    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbDesc];
    
    self.lbTeam = [[ZLabel alloc] init];
    [self.lbTeam setTextColor:DESCCOLOR];
    [self.lbTeam setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTeam setNumberOfLines:1];
    [self.lbTeam setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbTeam];
    
    self.lbTime = [[ZLabel alloc] init];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbTime];
    
    self.lbPrice = [[ZLabel alloc] init];
    [self.lbPrice setTextColor:PRICECOLOR];
    [self.lbPrice setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.cellH-kLineMaxHeight, self.cellW, kLineMaxHeight)];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.imgIcon setFrame:CGRectMake(kSizeSpace, kSizeSpace, 105, self.cellH-kSizeSpace*2)];
    
    CGFloat lbX = self.imgIcon.x+self.imgIcon.width+10;
    CGFloat lbW = self.cellW-lbX-kSizeSpace;
    CGRect titleFrame = CGRectMake(lbX, 14, lbW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (titleH > titleMaxH) { titleH = titleMaxH; }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    CGRect descFrame = CGRectMake(lbX, titleFrame.origin.y+titleH+8, lbW, self.lbMinH);
    [self.lbDesc setFrame:descFrame];
    CGFloat descMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbDesc];
    CGFloat descH = [self.lbDesc getLabelHeightWithMinHeight:self.lbMinH];
    if (descH > descMaxH) { descH = descMaxH; }
    descFrame.size.height = descH;
    [self.lbDesc setFrame:descFrame];
    
    CGRect teamFrame = CGRectMake(lbX, descFrame.origin.y+descH+8, lbW, self.lbMinH);
    [self.lbTeam setFrame:teamFrame];
    
    CGRect timeFrame = CGRectMake(lbX, teamFrame.origin.y+teamFrame.size.height+8, lbW, self.lbMinH);
    [self.lbTime setFrame:timeFrame];
    
    CGRect priceFrame = CGRectMake(lbX, self.cellH-35, lbW, self.lbH);
    [self.lbPrice setFrame:priceFrame];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
    
    [self.imgIcon setImageURLStr:model.illustration];
    
    [self.lbTitle setText:model.title];
    
    [self.lbDesc setText:model.theme_intro];
    
    [self.lbTeam setText:model.team_name];
    
    [self.lbTime setText:model.time];
    
    if (model.units && model.units.length > 0) {
        [self.lbPrice setText:[NSString stringWithFormat:@"¥%@/%@", model.price, model.units]];
    } else {
        [self.lbPrice setText:[NSString stringWithFormat:@"¥%@", model.price]];
    }
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbTeam);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbPrice);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 155;
}

@end
