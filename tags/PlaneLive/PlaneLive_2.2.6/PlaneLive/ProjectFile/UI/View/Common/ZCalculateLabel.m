//
//  ZCalculateLabel.m
//  PlaneCircle
//
//  Created by Daniel on 7/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCalculateLabel.h"
#import "ClassCategory.h"

@interface ZCalculateLabel()

@end

static ZCalculateLabel *calculateLabel;

@implementation ZCalculateLabel

+(ZCalculateLabel *)shareCalculateLabel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calculateLabel = [[ZCalculateLabel alloc] init];
        [calculateLabel setText:kOne];
    });
    return calculateLabel;
}

-(CGFloat)getALineHeightWithFont:(UIFont *)font width:(CGFloat)width
{
    [self setFont:font];
    [self setFrame:CGRectMake(0, 0, width, 10)];
    CGFloat newH = [self getLabelHeightWithMinHeight:10];
    return newH;
}

-(CGFloat)getMaxLineHeightWithLabel:(UILabel *)label
{
    [self setFont:label.font];
    [self setFrame:CGRectMake(0, 0, label.width, 10)];
    CGFloat newH = [self getLabelHeightWithMinHeight:10]*label.numberOfLines;
    return newH;
}

-(CGFloat)getMaxLineHeightWithLabel:(UILabel *)label line:(NSInteger)line
{
    [self setTextColor:label.textColor];
    [self setFont:label.font];
    [self setFrame:CGRectMake(0, 0, label.width, 10)];
    CGFloat newH = [self getLabelHeightWithMinHeight:10]*line;
    return newH;
}

-(void)dealloc
{
    
}

@end
