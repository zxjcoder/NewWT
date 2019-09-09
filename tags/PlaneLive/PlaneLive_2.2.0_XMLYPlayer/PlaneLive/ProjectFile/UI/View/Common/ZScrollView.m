//
//  ZScrollView.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZScrollView.h"

@implementation UIScrollView (MJRefreshHeader)

-(void)setRefreshHeaderWithRefreshBlock:(void (^)(void))refreshBlock
{
    self.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    NSMutableArray *arrWillImage = [NSMutableArray array];
    for (int i = 51; i < 77; i++) {
        [arrWillImage addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_header%d",i]]];
    }
    NSMutableArray *arrIdleImage = [NSMutableArray array];
    [arrIdleImage addObject:[UIImage imageNamed:@"refresh_header76"]];
    for (int i = 1; i < 20; i++) {
        [arrIdleImage addObject:[UIImage imageNamed:@"refresh_header1"]];
    }
    for (int i = 1; i < 52; i++) {
        [arrIdleImage addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_header%d",i]]];
    }
    [(MJRefreshGifHeader*)self.mj_header setImages:arrIdleImage forState:(MJRefreshStateIdle)];
    [(MJRefreshGifHeader*)self.mj_header setImages:arrWillImage duration:2.5f forState:(MJRefreshStateRefreshing)];
    
    [[(MJRefreshGifHeader*)self.mj_header stateLabel] setHidden:YES];
    [[(MJRefreshGifHeader*)self.mj_header lastUpdatedTimeLabel] setHidden:YES];
}

-(void)removeRefreshHeader
{
    if (self.mj_header) {
        [self.mj_header removeFromSuperview];
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
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
}

-(void)removeRefreshFooter
{
    if (self.mj_footer) {
        [self.mj_footer removeFromSuperview];
    }
}

-(void)endRefreshFooter
{
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
}


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
