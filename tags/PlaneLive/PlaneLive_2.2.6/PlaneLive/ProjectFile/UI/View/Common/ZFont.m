//
//  ZFont.m
//  PlaneCircle
//
//  Created by Daniel on 8/4/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZFont.h"

@implementation ZFont

+(UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale==3) {
        fontSize = fontSize*1.1;
    }
    return [super systemFontOfSize:fontSize];
}

+(UIFont *)boldSystemFontOfSize:(CGFloat)fontSize
{
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale==3) {
        fontSize = fontSize*1.1;
    }
    return [super boldSystemFontOfSize:fontSize];
}

@end
