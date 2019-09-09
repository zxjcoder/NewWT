//
//  ZCollectionViewLayout.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCollectionViewLayout.h"

@implementation ZCollectionViewLayout

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = 0.0f;
    self.minimumLineSpacing = 0.0f;
}

@end
