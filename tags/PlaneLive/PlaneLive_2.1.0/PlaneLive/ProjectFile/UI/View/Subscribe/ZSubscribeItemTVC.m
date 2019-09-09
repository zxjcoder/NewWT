//
//  ZSubscribeItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeItemTVC.h"

@interface ZSubscribeItemTVC()

@property (strong, nonatomic) ZImageView *imgIcon;
///课程名称
@property (strong, nonatomic) ZLabel *lbTitle;
///课程描述
@property (strong, nonatomic) ZLabel *lbDesc;
///课程价格
@property (strong, nonatomic) ZLabel *lbPrice;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) ModelSubscribe *model;

@end

@implementation ZSubscribeItemTVC

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    [self.imgIcon.layer setMasksToBounds:YES];
    [self.imgIcon setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[ZLabel alloc] init];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbDesc setNumberOfLines:2];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.viewMain addSubview:self.lbDesc];
    
    self.lbPrice = [[ZLabel alloc] init];
    [self.lbPrice setTextColor:MAINCOLOR];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat space = kSize11;
    CGFloat imgHeight = 95;
    CGFloat imgWidth = 107;
    [self.imgIcon setFrame:CGRectMake(space, space, imgWidth, imgHeight)];
    
    CGFloat lbX = self.imgIcon.x+self.imgIcon.width+kSize8;
    CGFloat lbW = self.cellW-lbX-space;
    CGRect titleFrame = CGRectMake(lbX, space, lbW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {
        titleH = titleMaxH;
    }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat descY = self.lbTitle.y+self.lbTitle.height+kSize3;
    CGRect descFrame = CGRectMake(lbX, descY, lbW, self.lbMinH);
    [self.lbDesc setFrame:descFrame];
    CGFloat descH = [self.lbDesc getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat descMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbDesc];
    if (descH > descMaxH) {
        descH = descMaxH;
    }
    descFrame.size.height = descH;
    [self.lbDesc setFrame:descFrame];
    
    CGFloat buttomY = self.imgIcon.y+self.imgIcon.height-self.lbH;
    [self.lbPrice setFrame:CGRectMake(lbX, buttomY, lbW, self.lbH)];
    
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
    
    [self.imgIcon setImageURLStr:model.illustration];
    
    [self.lbTitle setText:model.title];
    
    [self.lbDesc setText:model.theme_intro];
    
    if (model && model.units.length > 0) {
        [self.lbPrice setText:[NSString stringWithFormat:@"¥%.2f/%@", [model.price floatValue], model.units]];
    } else {
        [self.lbPrice setText:[NSString stringWithFormat:@"¥%.2f", [model.price floatValue]]];
    }
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbPrice);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLine);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 122;
}

@end
