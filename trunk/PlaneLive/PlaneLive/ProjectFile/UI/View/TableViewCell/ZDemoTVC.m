//
//  ZDemoTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDemoTVC.h"

@interface ZDemoTVC()

@end

@implementation ZDemoTVC

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
}
+(CGFloat)getH
{
    return 45;
}

@end
