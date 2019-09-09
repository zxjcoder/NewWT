//
//  CFCoverFlowView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/10.
//  Copyright © 2017年 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFoundCardView.h"

@class CFCoverFlowView;
@protocol CFCoverFlowViewDelegate <NSObject>

@optional
- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didScrollPageItemToIndex:(NSInteger)index;
- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didSelectPageItemAtIndex:(NSInteger)index;

@end

@interface CFCoverFlowView : UIControl

@property (nonatomic, weak) id <CFCoverFlowViewDelegate> delegate;

@property (nonatomic, assign) CFTimeInterval animationDuration;
@property (nonatomic, getter = isAutoAnimation) BOOL autoAnimation;
@property (copy, nonatomic) void(^onPracticeTypeClick)(ModelPracticeType *model);

/**
 *  default width is half of cover flow view's width
 */
@property (nonatomic, assign) CGFloat pageItemWidth;
/**
 *  default height is cover flow view's height
 */
@property (nonatomic, assign) CGFloat pageItemHeight;
/**
 *  default corner radius is 0.0
 */
@property (nonatomic, assign) CGFloat pageItemCornerRadius;
/**
 *  adjust pageItemCoverWidth and pageItemWidth to change the space between page items
 */
@property (nonatomic, assign) CGFloat pageItemCoverWidth;

- (void)setPageItemsWithImageNames:(NSArray *)imageNames;
- (void)setCoverFlowViewDataWithArray:(NSArray *)array;

@end
