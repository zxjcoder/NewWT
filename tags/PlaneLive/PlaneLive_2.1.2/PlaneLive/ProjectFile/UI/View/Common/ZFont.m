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
    return [super systemFontOfSize:fontSize];
//    return [UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:fontSize];
}

+(UIFont *)boldSystemFontOfSize:(CGFloat)fontSize
{
    return [super boldSystemFontOfSize:fontSize];
//    return [UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:fontSize];
}

@end
