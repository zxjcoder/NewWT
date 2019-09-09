//
//  ZLabelLine.h
//  PlaneLive
//
//  Created by Daniel on 04/05/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZLineAlignment)
{
    ZLineAlignmentAll = 0,
    ZLineAlignmentLeft = 1,
    ZLineAlignmentRight = 2,
};

@interface ZLabelLine : UILabel

@property (assign, nonatomic) ZLineAlignment lineAlignment;

@end
