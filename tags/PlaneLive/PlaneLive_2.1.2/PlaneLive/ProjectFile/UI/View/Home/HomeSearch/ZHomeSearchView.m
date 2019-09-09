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

@interface ZHomeSearchView()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
}

@property (strong, nonatomic) ZSwitchToolView *viewSwitchTool;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ZPracticeTableView *tvPractice;
@property (strong, nonatomic) ZSubscribeTableView *tvSubscribe;

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
        _offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*weakSelf.width, 0) animated:YES];
    }];
    [self addSubview:self.viewSwitchTool];
    
    CGFloat scViewY = self.viewSwitchTool.y+self.viewSwitchTool.height;
    CGFloat scViewH = APP_FRAME_HEIGHT-APP_TOP_HEIGHT-scViewY;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scViewY, self.width, scViewH)];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*2, self.scrollView.height)];
    [self addSubview:self.scrollView];
    
    self.tvPractice = [[ZPracticeTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.scrollView.height)];
    [self.scrollView addSubview:self.tvPractice];
    
    self.tvSubscribe = [[ZSubscribeTableView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.scrollView.height)];
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
}
///订阅结束底部刷新
-(void)endRefreshSubscribeFooter
{
    [self.tvSubscribe endRefreshFooter];
}
///实务结束底部刷新
-(void)endRefreshPracticeFooter
{
    [self.tvPractice endRefreshFooter];
}
///设置实务背景状态
-(void)setPracticeBackgroundFail
{
    [self.tvPractice setViewDataBackNoneWithArray:nil isHeader:YES];
}
///设置订阅背景状态
-(void)setSubscribeBackgroundFail
{
    [self.tvSubscribe setViewDataBackNoneWithArray:nil isHeader:YES];
}
///设置订阅数据
-(void)setViewDataSubscribeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self.tvSubscribe setViewDataBackNoneWithArray:arrResult isHeader:isHeader];
}
///设置实务数据
-(void)setViewDataPracticeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self.tvPractice setViewDataBackNoneWithArray:arrResult isHeader:isHeader];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self.viewSwitchTool setViewSelectItemWithType:(_offsetIndex+1)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewSwitchTool setOffsetChange:scrollView.contentOffset.x];
}

@end
