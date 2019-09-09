//
//  ZTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTableView.h"
#import "ZScrollView.h"

@interface ZTableView()

///背景
@property (strong, nonatomic) ZBackgroundView *viewBG;
///背景状态
@property (assign, nonatomic) ZBackgroundState viewBGState;

@end

@implementation ZTableView

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
    __weak typeof(self) weakSelf = self;
    self.viewBG = [[ZBackgroundView alloc] initWithFrame:self.bounds];
    [self.viewBG setOnButtonClick:^{
        if (weakSelf.onBackgroundClick) {
            weakSelf.onBackgroundClick(weakSelf.viewBGState);
        }
    }];
    [self setBackgroundView:self.viewBG];
}

-(void)setFontSizeChange
{
    
}

-(void)setBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.viewBG setFrame:self.bounds];
    [self setViewBGState:backState];
    [self.viewBG setViewStateWithState:(self.viewBGState)];
}

-(void)addRefreshHeaderWithEndBlock:(void (^)(void))refreshBlock
{
    [self setRefreshHeaderWithRefreshBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
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

-(void)dealloc
{
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_onRefreshFooter);
    OBJC_RELEASE(_onRefreshHeader);
    OBJC_RELEASE(_onBackgroundClick);
}

@end
