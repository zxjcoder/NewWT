//
//  ZUserProfileTradeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserProfileTradeTVC.h"

@interface ZUserProfileTradeTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbValue;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserProfileTradeTVC

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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:DESCCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTitle setText:kIndustry];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbValue = [[UILabel alloc] init];
    [self.lbValue setTextColor:BLACKCOLOR1];
    [self.lbValue setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbValue];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.lbTitle setFrame:CGRectMake(self.space, 8, self.cellW, self.lbMinH)];
    
    CGFloat valueH = [self.lbValue getLabelHeightWithMinHeight:self.lbMinH];
    [self.lbValue setFrame:CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+3, self.cellW-self.space*2, valueH)];
    
    self.cellH = self.lbValue.y+valueH+8;
    
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [super setCellDataWithModel:model];
    if (model) {
        [self.lbValue setText:model.trade];
    }
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbValue);
    OBJC_RELEASE(_imgLine);
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

@end
