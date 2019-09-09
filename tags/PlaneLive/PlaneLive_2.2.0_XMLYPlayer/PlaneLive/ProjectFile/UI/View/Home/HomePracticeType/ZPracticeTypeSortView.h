//
//  ZPracticeTypeSortView.h
//  PlaneLive
//
//  Created by Daniel on 10/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPracticeTypeSortView : UIView

///排序点击事件
@property (copy, nonatomic) void(^onSortClick)(int sort);

-(void)setShowSortViewWithAnimate;
-(void)setHiddenSortViewWithAnimate;
-(void)setHiddenSortView;

@end
