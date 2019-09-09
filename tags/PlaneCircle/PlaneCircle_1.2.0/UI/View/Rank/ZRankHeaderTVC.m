//
//  ZRankHeaderTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankHeaderTVC.h"

@interface ZRankHeaderTVC()

///分割线
@property (strong, nonatomic) UIView *viewLine;
///图标
@property (strong, nonatomic) UIView *viewIcon;
///标题
@property (strong, nonatomic) UILabel *lbTitle;

@end

@implementation ZRankHeaderTVC

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
    
    self.viewIcon = [[UIView alloc] init];
    [self.viewIcon setBackgroundColor:MAINCOLOR];
    [self.viewMain addSubview:self.viewIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:RGBCOLOR(0, 0, 0)];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewIcon setFrame:CGRectMake(self.space, self.cellH/2-15/2, self.lineMaxH, 15)];
    
    CGFloat allW = 70;
    CGFloat titleX = self.viewIcon.x+self.viewIcon.width+kSize8;
    CGFloat titleW = self.cellW-titleX-allW;
    [self.lbTitle setFrame:CGRectMake(titleX, self.cellH/2-self.lbH/2, titleW, self.lbH)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithString:(NSString *)title
{
    [self.lbTitle setText:title];
}

-(void)setViewNil
{
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 35;
}
+(CGFloat)getH
{
    return 35;
}

@end
