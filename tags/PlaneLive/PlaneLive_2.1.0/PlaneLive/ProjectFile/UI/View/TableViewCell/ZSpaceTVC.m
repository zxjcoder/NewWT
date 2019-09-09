//
//  ZSpaceTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSpaceTVC.h"

@implementation ZSpaceTVC

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
    
    self.cellH = [ZSpaceTVC getH];
    
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
    return 45;
}

@end
