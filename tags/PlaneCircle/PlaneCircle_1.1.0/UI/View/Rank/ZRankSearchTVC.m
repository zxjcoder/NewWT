//
//  ZRankSearchTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankSearchTVC.h"

@interface ZRankSearchTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZRankSearchTVC

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
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setNumberOfLines:1];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, self.cellW-self.space*2, self.lbH)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithModel:(ModelEntity *)model
{
    if ([model isKindOfClass:[ModelRankUser class]]) {
        [self setType:2];
        ModelRankUser *modelRU = (ModelRankUser*)model;
        [self.lbTitle setText:modelRU.nickname];
    } else if ([model isKindOfClass:[ModelRankCompany class]]) {
        [self setType:1];
        ModelRankCompany *modelRC = (ModelRankCompany*)model;
        [self.lbTitle setText:modelRC.company_name];
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewLine);
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
