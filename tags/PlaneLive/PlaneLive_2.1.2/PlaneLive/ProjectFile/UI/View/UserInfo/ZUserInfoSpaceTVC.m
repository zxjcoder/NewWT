//
//  ZUserInfoSpaceTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZUserInfoSpaceTVC.h"

@implementation ZUserInfoSpaceTVC

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
    
    self.cellH = [ZUserInfoSpaceTVC getH];
    
    [self.viewMain setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
}
-(void)setCellBackColor:(UIColor *)color
{
    [self.viewMain setBackgroundColor:color];
}
-(void)setCellRowH:(CGFloat)height
{
    self.cellH = height;
}
-(void)setViewNil
{
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 10;
}

@end
