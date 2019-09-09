//
//  ZScrollView.h
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface UIScrollView (MJRefreshHeaderGIF)

///设置刷新顶部事件
-(void)setRefreshHeaderWithRefreshBlock:(void (^)(void))refreshBlock;
///设置刷新底部事件
-(void)setRefreshFooterWithEndBlock:(void (^)(void))refreshBlock;

///移除顶部刷新
-(void)removeRefreshHeader;
///结束刷新顶部
-(void)endRefreshHeader;
///移除底部刷新
-(void)removeRefreshFooter;
///结束刷新底部
-(void)endRefreshFooter;

@end


@interface ZScrollView : UIScrollView

@property (assign, nonatomic) int oldOffsetY;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
