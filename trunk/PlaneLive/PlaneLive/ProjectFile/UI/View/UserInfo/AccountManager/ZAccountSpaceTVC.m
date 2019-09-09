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
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.cellH = [ZAccountSpaceTVC getH];
    
    [self setBackgroundColor:CLEARCOLOR];
    [self.viewMain setBackgroundColor:CLEARCOLOR];
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
