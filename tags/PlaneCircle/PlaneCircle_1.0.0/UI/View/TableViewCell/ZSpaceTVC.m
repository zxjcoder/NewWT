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
    
    self.cellH = self.getH;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
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
    return 10;
}
+(CGFloat)getH
{
    return 10;
}

@end
