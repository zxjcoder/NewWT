//
//  ZTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTableView.h"
#import "MJRefresh.h"

@implementation ZTableView

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

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
}

-(void)addRefreshHeaderWithEndBlock:(void (^)(void))refreshBlock
{
    if (!self.mj_header) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (refreshBlock) {
                refreshBlock();
            }
        }];
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

-(void)addRefreshFooterWithEndBlock:(void (^)(void))refreshBlock
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
