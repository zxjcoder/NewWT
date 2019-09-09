//
//  ZHomeSearchView.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeSearchView.h"
#import "ZSwitchToolView.h"
#import "ZPracticeTableView.h"
#import "ZSubscribeTableView.h"
#import "ZScrollView.h"
#import "StatisticsManager.h"

@interface ZHomeSearchView()<UIScrollViewDelegate>

@property (assign, nonatomic) NSInteger offsetIndex;

@property (strong, nonatomic) ZSwitchToolView *viewSwitchTool;
@property (strong, nonatomic) ZScrollView *scrollView;
@property (strong, nonatomic) ZPracticeTableView *tvPractice;
@property (strong, nonatomic) ZSubscribeTableView *tvSubscribe;
@property (strong, nonatomic) ZSubscribeTableView *tvSeriesCourse;

@end

@implementation ZHomeSearchView

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
    [self setBackgroundColor:WHITECOLOR];
    
    ZWEAKSELF
    self.viewSwitchTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemHomeSearch)];
    [self.viewSwitchTool setFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZSwitchToolView getViewH])];
    [self.viewSwitchTool setOnItemClick:^(NSInteger index) {
        switch (index) {
            case 2:
                [StatisticsManager event:kHomepage_Search_EriesCourse];
                break;
            case 3:
                [StatisticsManager event:kHomepage_Search_Training];
                break;
            default:
                break;
        }
        weakSelf.offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.offsetIndex*weakSelf.width, 0) animated:YES];
    }];
    [self addSubview:self.viewSwitchTool];
    
    CGFloat scViewY = self.viewSwitchTool.y+self.viewSwitchTool.height;
    CGFloat scViewH = self.height-scViewY;
    self.scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, scViewY, self.width, scViewH)];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*self.viewSwitchTool.getNItemCount, self.scrollView.height)];
    [self addSubview:self.scrollView];
    
    self.tvPractice = [[ZPracticeTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.scrollView.height)];
    self.tvPractice.scrollsToTop = NO;
    [self.scrollView addSubview:self.tvPractice];
    
    self.tvSeriesCourse = [[ZSubscribeTableView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.scrollView.height)];
    self.tvSeriesCourse.scrollsToTop = NO;
    [self.scrollView addSubview:self.tvSeriesCourse];
    
    self.tvSubscribe = [[ZSubscribeTableView alloc] initWithFrame:CGRectMake(self.width*2, 0, self.width, self.scrollView.height)];
    self.tvSubscribe.scrollsToTop = NO;
    [self.scrollView addSubview:self.tvSubscribe];
    
    [self.tvPractice setOnContentOffsetChange:^(CGFloat contentOffsetY) {
        if (weakSelf.onContentOffsetChange) {
            weakSelf.onContentOffsetChange(contentOffsetY);
        }
    }];
    [self.tvSubscribe setOnContentOffsetChange:^(CGFloat contentOffsetY) {
        if (weakSelf.onContentOffsetChange) {
            weakSelf.onContentOffsetChange(contentOffsetY);
        }
    }];
    [self.tvPractice setOnRefreshFooter:^{
        if (weakSelf.onPracticeRefreshFooter) {
            weakSelf.onPracticeRefreshFooter();
        }
    }];
    [self.tvPractice setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onPracticeBackgroundClick) {
            weakSelf.onPracticeBackgroundClick();
        }
    }];
    [self.tvPractice setOnRowSelected:^(NSArray *array, NSInteger row) {
        if (weakSelf.onPracticeClick) {
            weakSelf.onPracticeClick(array, row);
        }
    }];
    
    [self.tvSubscribe setOnRefreshFooter:^{
        if (weakSelf.onSubscribeRefreshFooter) {
            weakSelf.onSubscribeRefreshFooter();
        }
    }];
    [self.tvSubscribe setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onSubscribeBackgroundClick) {
            weakSelf.onSubscribeBackgroundClick();
        }
    }];
    [self.tvSubscribe setOnRowSelected:^(ModelSubscribe *model) {
        if (weakSelf.onSubscribeClick) {
            weakSelf.onSubscribeClick(model);
        }
    }];
    
    [self.tvSeriesCourse setOnRefreshFooter:^{
        if (weakSelf.onSeriesCourseRefreshFooter) {
            weakSelf.onSeriesCourseRefreshFooter();
        }
    }];
    [self.tvSeriesCourse setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onSeriesCourseBackgroundClick) {
            weakSelf.onSeriesCourseBackgroundClick();
        }
    }];
    [self.tvSeriesCourse setOnRowSelected:^(ModelSubscribe *model) {
        if (weakSelf.onSeriesCourseClick) {
            weakSelf.onSeriesCourseClick(model);
        }
    }];
}
-(void)dealloc
{
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_viewSwitchTool);
    OBJC_RELEASE(_tvPractice);
    OBJC_RELEASE(_tvSubscribe);
    OBJC_RELEASE(_tvSeriesCourse);
}
///设置View坐标
-(void)setViewFrame:(CGRect)frame
{
    [self setFrame:frame];
    
    CGRect svFrame = self.scrollView.frame;
    svFrame.size.height = frame.size.height-self.viewSwitchTool.height;
    [self.scrollView setFrame:svFrame];
    
    CGRect tvPracticeFrame = self.tvPractice.frame;
    tvPracticeFrame.size.height = svFrame.size.height;
    [self.tvPractice setFrame:tvPracticeFrame];
    
    CGRect tvSubscribeFrame = self.tvSubscribe.frame;
    tvSubscribeFrame.size.height = svFrame.size.height;
    [self.tvSubscribe setFrame:tvSubscribeFrame];
    
    CGRect tvSeriesCourseFrame = self.tvSeriesCourse.frame;
    tvSeriesCourseFrame.size.height = svFrame.size.height;
    [self.tvSeriesCourse setFrame:tvSeriesCourseFrame];
}
///系列课结束底部刷新
-(void)endRefreshSeriesCourseFooter
{
    [self.tvSeriesCourse endRefreshFooter];
}
///订阅结束底部刷新
-(void)endRefreshSubscribeFooter
{
    [self.tvSubscribe endRefreshFooter];
}
///微课结束底部刷新
-(void)endRefreshPracticeFooter
{
    [self.tvPractice endRefreshFooter];
}
///设置微课加载中
-(void)setPracticeBackgroundLoading
{
    [self.tvPractice setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateLoading)];
}
///设置系列课加载中
-(void)setSeriesCourseBackgroundLoading
{
    [self.tvSeriesCourse setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateLoading)];
}
///设置订阅加载中
-(void)setSubscribeBackgroundLoading
{
    [self.tvSubscribe setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateLoading)];
}
///设置微课背景状态
-(void)setPracticeBackgroundFail
{
    [self.tvPractice setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateFail)];
}
///设置系列课背景状态
-(void)setSeriesCourseBackgroundFail
{
    [self.tvSeriesCourse setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateFail)];
}
///设置订阅背景状态
-(void)setSubscribeBackgroundFail
{
    [self.tvSubscribe setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateFail)];
}
///设置系列课数据
-(void)setViewDataSeriesCourseWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    ZBackgroundState state = ZBackgroundStateNone;
    if (isHeader && arrResult.count == 0) {
        state = ZBackgroundStateNull;
    }
    [self.tvSeriesCourse setViewDataWithArray:arrResult isHeader:isHeader backState:state];
}
///设置订阅数据
-(void)setViewDataSubscribeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    ZBackgroundState state = ZBackgroundStateNone;
    if (isHeader && arrResult.count == 0) {
        state = ZBackgroundStateNull;
    }
    [self.tvSubscribe setViewDataWithArray:arrResult isHeader:isHeader backState:state];
}
///设置微课数据
-(void)setViewDataPracticeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    ZBackgroundState state = ZBackgroundStateNone;
    if (isHeader && arrResult.count == 0) {
        state = ZBackgroundStateNull;
    }
    [self.tvPractice setViewDataWithArray:arrResult isHeader:isHeader backState:state];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewSwitchTool setOffsetChange:scrollView.contentOffset.x];
    
    if (self.onContentOffsetChange) {
        self.onContentOffsetChange(scrollView.contentOffset.y);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self.viewSwitchTool setViewSelectItemWithType:(_offsetIndex+1)];
}

@end
