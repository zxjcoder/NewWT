//
//  ZBackgroundView.h
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBackgroundView : UIView

@property (copy, nonatomic) void(^onButtonClick)();

-(void)setViewStateWithState:(ZBackgroundState)state;

@end
