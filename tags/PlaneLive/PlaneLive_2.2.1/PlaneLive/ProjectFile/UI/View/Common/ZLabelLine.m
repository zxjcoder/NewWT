//
//  ZLabelLine.m
//  PlaneLive
//
//  Created by Daniel on 04/05/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLabelLine.h"

@interface ZLabelLine()

@end

@implementation ZLabelLine

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineAlignment = ZLineAlignmentAll;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [TABLEVIEWCELL_LINECOLOR setStroke];
    
    CGFloat y = self.height/2;
    CGFloat lbW = self.width;
    CGFloat space = 10;
    CGFloat textW = [self getLabelWidthWithMinWidth:10];
    
    switch (self.lineAlignment) {
        case ZLineAlignmentAll:
        {
            CGContextMoveToPoint(context, space, y);
            CGContextAddLineToPoint(context, lbW/2-textW/2-10, y);
            
            CGContextMoveToPoint(context, lbW/2+textW/2+10, y);
            CGContextAddLineToPoint(context, lbW-space, y);
            break;
        }
        case ZLineAlignmentLeft:
        {
            CGContextMoveToPoint(context, space, y);
            CGContextAddLineToPoint(context, lbW-textW-space, y);
            break;
        }
        case ZLineAlignmentRight:
        {
            CGContextMoveToPoint(context, textW+space, y);
            CGContextAddLineToPoint(context, lbW-space, y);
            break;
        }
        default: break;
    }
    CGContextStrokePath(context);
    //CGContextRelease(context);
}


@end
