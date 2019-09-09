//
//  ZCollectionView.h
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZScrollView.h"

@interface ZCollectionView : UICollectionView

///背景按钮事件
@property (copy, nonatomic) void(^onBackgroundClick)(ZBackgroundState viewBGState);

///设置背景状态
-(void)setBackgroundViewWithState:(ZBackgroundState)backState;

@end
