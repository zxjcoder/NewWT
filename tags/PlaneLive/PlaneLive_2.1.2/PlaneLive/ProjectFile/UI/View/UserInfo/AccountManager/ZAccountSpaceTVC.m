//
//  ZAccountSpaceTVC.m
//  PlaneLive
//
//  Created by Daniel on 30/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountSpaceTVC.h"

@implementation ZAccountSpaceTVC

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
    
    self.cellH = [ZAccountSpaceTVC getH];
    
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR2];
}

-(void)setViewBackgroundColor:(UIColor *)color
{
    [self setBackgroundColor:color];
    [self.viewMain setBackgroundColor:color];
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
