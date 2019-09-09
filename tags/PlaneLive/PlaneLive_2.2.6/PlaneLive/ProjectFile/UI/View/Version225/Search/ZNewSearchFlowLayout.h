//
//  ZNewSearchFlowLayout.h
//  PlaneLive
//
//  Created by Daniel on 01/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZNewSearchFlowAlignment) {
    ZNewSearchFlowAlignmentJustyfied,
    ZNewSearchFlowAlignmentLeft,
    ZNewSearchFlowAlignmentCenter,
    ZNewSearchFlowAlignmentRight
};

@interface ZNewSearchFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) ZNewSearchFlowAlignment alignment;

@end
