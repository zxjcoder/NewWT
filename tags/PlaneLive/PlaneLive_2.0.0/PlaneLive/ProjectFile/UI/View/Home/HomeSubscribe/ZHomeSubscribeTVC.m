//
//  ZHomeSubscribeTVC.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeSubscribeTVC.h"

@interface ZHomeSubscribeTVC()

@property (strong, nonatomic) ZImageView *imgIcon;
///标题
@property (strong, nonatomic) ZLabel *lbTitle;
///团队
@property (strong, nonatomic) ZLabel *lbTeamName;
///描述
@property (strong, nonatomic) ZLabel *lbDesc;

@property (strong, nonatomic) ModelSubscribe *model;

@end

@implementation ZHomeSubscribeTVC

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
    
    self.cellH = [ZHomeSubscribeTVC getH];
    
    self.imgIcon = [[ZImageView alloc] initWithImage:[SkinManager getDefaultImage]];
    [self.imgIcon setUserInteractionEnabled:YES];
    [self.imgIcon.layer setMasksToBounds:YES];
    [self.imgIcon setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbTeamName = [[ZLabel alloc] init];
    [self.lbTeamName setTextColor:BLACKCOLOR1];
    [self.lbTeamName setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTeamName setNumberOfLines:1];
    [self.lbTeamName setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbTeamName];
    
    self.lbDesc = [[ZLabel alloc] init];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbDesc setNumberOfLines:1];
    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.viewMain addSubview:self.lbDesc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgWidth = self.cellH;
    CGFloat imgHeight = imgWidth-kSize8*2;
    [self.imgIcon setFrame:CGRectMake(kSizeSpace, kSize10, imgWidth, imgHeight)];
    
    CGFloat lbX = self.imgIcon.x+self.imgIcon.width+kSize10;
    CGFloat lbWidth = self.cellW-lbX-kSize10;
    [self.lbTitle setFrame:CGRectMake(lbX, kSize13, lbWidth, self.lbH)];
    
    CGFloat nameY = self.lbTitle.y+self.lbTitle.height+kSize3;
    [self.lbTeamName setFrame:CGRectMake(lbX, nameY, lbWidth, self.lbH)];
    
    CGFloat descY = self.lbTeamName.y+self.lbTeamName.height+kSize3;
    [self.lbDesc setFrame:CGRectMake(lbX, descY, lbWidth, self.lbH)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
    
    [self.imgIcon setImageURLStr:model.illustration];
    
    [self.lbTitle setText:model.title];
    
    [self.lbTeamName setText:model.team_name];
    
    [self.lbDesc setText:model.team_info];
    
    [self setNeedsDisplay];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbTeamName);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_model);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return 90;
}

@end
