//
//  ZView.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZView()

@end

@implementation ZView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    
}
    
@end


