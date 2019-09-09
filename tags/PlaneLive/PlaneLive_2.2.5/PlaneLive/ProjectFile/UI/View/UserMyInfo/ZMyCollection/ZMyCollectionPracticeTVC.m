//
//  ZMyCollectionPracticeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionPracticeTVC.h"

@interface ZMyCollectionPracticeTVC()

@property (strong, nonatomic) ZImageView *imgLogo;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelCollection *model;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyCollectionPracticeTVC

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
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewMain addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgS = 50;
    [self.imgLogo setFrame:CGRectMake(self.space, kSize10, imgS, imgS)];
    [self.imgLogo setViewRound];
    
    CGFloat lbX = self.imgLogo.x+imgS+self.space;
    CGFloat lbW = self.cellW-lbX-self.space;
    [self.lbTitle setFrame:CGRectMake(lbX, self.cellH/2-self.lbH/2, lbW, self.lbH)];
    CGFloat lbH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (lbH > maxH) {
        lbH = maxH;
    }
    [self.lbTitle setFrame:CGRectMake(lbX, self.cellH/2-lbH/2, lbW, lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(CGFloat)setCellDataWithModel:(ModelCollection *)model
{
    [self setModel:model];
    if (model) {
        [self.lbTitle setText:model.title];
        
        [self.imgLogo setImageURLStr:model.img placeImage:[SkinManager getDefaultImage]];
    }
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_model);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
-(CGFloat)getH
{
    return 70;
}
+(CGFloat)getH
{
    return 70;
}

@end
