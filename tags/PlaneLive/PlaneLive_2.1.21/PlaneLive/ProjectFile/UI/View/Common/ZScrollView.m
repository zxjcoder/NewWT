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
    
    UILabel *labelState = [(MJRefreshGifHeader*)self.mj_header stateLabel];
    if (labelState && [labelState isKindOfClass:[UILabel class]]) {
        [labelState setHidden:YES];
    }
    UILabel *lableTime = [(MJRefreshGifHeader*)self.mj_header lastUpdatedTimeLabel];
    if (lableTime && [lableTime isKindOfClass:[UILabel class]]) {
        [lableTime setHidden:YES];
    }
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
