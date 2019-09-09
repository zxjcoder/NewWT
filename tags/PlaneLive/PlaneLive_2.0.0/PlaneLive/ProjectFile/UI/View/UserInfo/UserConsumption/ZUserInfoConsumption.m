//
//  ZUserInfoConsumption.m
//  PlaneLive
//
//  Created by Daniel on 13/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoConsumption.h"
#import "ZSwitchToolView.h"
#import "ZUserInfoConsumptionItemTableView.h"

@interface ZUserInfoConsumption()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
}
///工具栏
@property (strong, nonatomic) ZSwitchToolView *viewTool;
///主面板
@property (strong, nonatomic) UIScrollView *scrollView;
///已购买
@property (strong, nonatomic) ZUserInfoConsumptionItemTableView *tvPay;
///已充值
@property (strong, nonatomic) ZUserInfoConsumptionItemTableView *tvRecharge;

@end

@implementation ZUserInfoConsumption

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

-(void)innerInit
{
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setBackgroundColor:VIEW_BACKCOLOR1];
    [self addSubview:self.scrollView];
    
    ZWEAKSELF
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemMyConsumption)];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        switch (index) {
            case 2:
                [weakSelf.tvPay setScrollsToTop:NO];
                [weakSelf.tvRecharge setScrollsToTop:YES];
                break;
            default:
                [weakSelf.tvPay setScrollsToTop:YES];
                [weakSelf.tvRecharge setScrollsToTop:NO];
                break;
        }
        _offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*self.scrollView.width, 0) animated:YES];
    }];
    [self addSubview:self.viewTool];
    
    self.tvPay = [[ZUserInfoConsumptionItemTableView alloc] init];
    [self.tvPay setScrollsToTop:YES];
    [self.tvPay setOnRefreshHeader:^{
        if (weakSelf.onRefreshPayHeader) {
            weakSelf.onRefreshPayHeader();
        }
    }];
    [self.tvPay setOnRefreshFooter:^{
        if (weakSelf.onRefreshPayFooter) {
            weakSelf.onRefreshPayFooter();
        }
    }];
    [self.tvPay setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundPayClick) {
            [weakSelf.tvPay setBackgroundViewWithState:(ZBackgroundStateLoading)];
            weakSelf.onBackgroundPayClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvPay];
    
    self.tvRecharge = [[ZUserInfoConsumptionItemTableView alloc] init];
    [self.tvRecharge setScrollsToTop:NO];
    [self.tvRecharge setOnRefreshHeader:^{
        if (weakSelf.onRefreshRechargeHeader) {
            weakSelf.onRefreshRechargeHeader();
        }
    }];
    [self.tvRecharge setOnRefreshFooter:^{
        if (weakSelf.onRefreshRechargeFooter) {
            weakSelf.onRefreshRechargeFooter();
        }
    }];
    [self.tvRecharge setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundRechargeClick) {
            [weakSelf.tvRecharge setBackgroundViewWithState:(ZBackgroundStateLoading)];
            weakSelf.onBackgroundRechargeClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvRecharge];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.viewTool setFrame:CGRectMake(0, 0, self.width, [ZSwitchToolView getViewH])];
    
    [self.scrollView setFrame:CGRectMake(0, self.viewTool.height, self.width, self.height-self.viewTool.height)];
    [self.scrollView setContentSize:CGSizeMake(self.width*2, self.scrollView.height)];
    
    [self.tvPay setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvRecharge setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
}
///设置已购买背景状态
-(void)setPayBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvPay setBackgroundViewWithState:backState];
}
///设置已充值背景状态
-(void)setRechargeBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvRecharge setBackgroundViewWithState:backState];
}
///设置已购买
-(void)setPayViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self.tvPay setViewDataWithArray:arrResult isHeader:isHeader];
}
///设置已充值
-(void)setRechargeViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self.tvRecharge setViewDataWithArray:arrResult isHeader:isHeader];
}
///结束已购买顶部刷新
-(void)endRefreshPayHeader
{
    [self.tvPay endRefreshHeader];
}
///结束已购买底部刷新
-(void)endRefreshPayFooter
{
    [self.tvPay endRefreshFooter];
}
///结束顶部刷新
-(void)endRefreshRechargeHeader
{
    [self.tvRecharge endRefreshHeader];
}
///结束底部刷新
-(void)endRefreshRechargeFooter
{
    [self.tvRecharge endRefreshFooter];
}
-(void)dealloc
{
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvRecharge);
    OBJC_RELEASE(_tvPay);
    
    OBJC_RELEASE(_onRefreshRechargeFooter);
    OBJC_RELEASE(_onRefreshRechargeHeader);
    OBJC_RELEASE(_onBackgroundRechargeClick);
    
    OBJC_RELEASE(_onRefreshPayFooter);
    OBJC_RELEASE(_onRefreshPayHeader);
    OBJC_RELEASE(_onBackgroundPayClick);
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
}
#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self.viewTool setViewSelectItemWithType:(_offsetIndex+1)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewTool setOffsetChange:scrollView.contentOffset.x];
}

@end
