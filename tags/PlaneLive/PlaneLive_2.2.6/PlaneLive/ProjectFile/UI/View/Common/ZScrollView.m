//
//  ZScrollView.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZScrollView.h"
#import <SDWebImage/UIImage+GIF.h>
#import "GifManager.h"

@implementation UIScrollView (MJRefreshHeaderGIF)

-(void)setRefreshHeaderWithRefreshBlock:(void (^)(void))refreshBlock
{
    if (!self.mj_header) {
        self.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            if (refreshBlock) {
                refreshBlock();
            }
        }];
        NSArray *arrGif = [GifManager getRefreshImagesGif];
        // 刷新过程中
        NSMutableArray *arrWillImage = [NSMutableArray array];
        // 闲置状态
        NSMutableArray *arrIdleImage = [NSMutableArray array];
        for (int i = 0; i < arrGif.count; i++) {
            [arrWillImage addObject:[arrGif objectAtIndex:i]];
            [arrIdleImage addObject:[arrGif objectAtIndex:i]];
        }
        [arrIdleImage addObject:arrGif.firstObject];
        [arrWillImage addObject:arrGif.firstObject];
        [(MJRefreshGifHeader*)self.mj_header setImages:arrIdleImage forState:(MJRefreshStateIdle)];
        [(MJRefreshGifHeader*)self.mj_header setImages:arrWillImage duration:1.5f forState:(MJRefreshStateRefreshing)];
        
        [[(MJRefreshGifHeader*)self.mj_header stateLabel] setHidden:YES];
        [[(MJRefreshGifHeader*)self.mj_header lastUpdatedTimeLabel] setHidden:YES];
    }
}

-(void)removeRefreshHeader
{
    if (self.mj_header) {
        self.mj_header = nil;
//        [self.mj_header removeFromSuperview];
    }
}

-(void)endRefreshHeader
{
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
}

-(void)setRefreshFooterWithEndBlock:(void (^)(void))refreshBlock
{
    if (!self.mj_footer) {
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (refreshBlock) {
                refreshBlock();
            }
        }];
    }
}

-(void)removeRefreshFooter
{
    if (self.mj_footer) {
        self.mj_footer = nil;
//        [self.mj_footer removeFromSuperview];
    }
}

-(void)endRefreshFooter
{
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
}


@end

@interface ZScrollView()<UIScrollViewDelegate>

@end

@implementation ZScrollView

#pragma mark - SuperMethod

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self setDelegate:self];
}

#pragma mark - UIScrollViewDelegate

/// 滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.oldOffsetY >= scrollView.contentOffset.y) {///下滑动
        [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(2)];
    } else {///上滑动
        [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(1)];
    }
}
/// 开始滑动时调用，只调用一次，手指不松开只算一次
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.oldOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(2)];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(2)];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(2)];
    }
}

#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
