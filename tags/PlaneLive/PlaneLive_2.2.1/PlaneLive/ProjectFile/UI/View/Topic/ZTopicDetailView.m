//
//  ZTopicDetailView.m
//  PlaneCircle
//
//  Created by Daniel on 9/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicDetailView.h"
#import "ZTopicPracticeTableView.h"
#import "ZTopicQuestionTableView.h"
#import "ZSwitchToolView.h"
#import "ZTopicHeaderView.h"
#import "ZScrollView.h"

@interface ZTopicDetailView()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
}

@property (strong, nonatomic) ZSwitchToolView *viewTool;

@property (strong, nonatomic) ZScrollView *scrollView;

@property (strong, nonatomic) ZTopicHeaderView *viewHeader;

@property (strong, nonatomic) ZTopicQuestionTableView *tvTopicQuestion;
@property (strong, nonatomic) ZTopicPracticeTableView *tvTopicPractice;

@property (strong, nonatomic) ModelTag *modelTag;

@end

@implementation ZTopicDetailView

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
    
    __weak typeof(self) weakSelf = self;
    self.viewHeader = [[ZTopicHeaderView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZTopicHeaderView getViewH])];
    [self.viewHeader setOnAttentionClick:^(ModelTag *model) {
        if (weakSelf.onAttentionClick) {
            weakSelf.onAttentionClick(model);
        }
    }];
    [self addSubview:self.viewHeader];
    
    CGFloat toolViewY = self.viewHeader.y+self.viewHeader.height;
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemTopicList)];
    [self.viewTool setFrame:CGRectMake(0, toolViewY, APP_FRAME_WIDTH, [ZSwitchToolView getViewH])];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        switch (index) {
            case 2:
                [weakSelf.tvTopicQuestion setScrollsToTop:NO];
                [weakSelf.tvTopicPractice setScrollsToTop:YES];
                break;
            default:
                [weakSelf.tvTopicQuestion setScrollsToTop:YES];
                [weakSelf.tvTopicPractice setScrollsToTop:NO];
                break;
        }
        _offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*weakSelf.scrollView.width, 0) animated:YES];
    }];
    [self addSubview:self.viewTool];
    
    CGFloat scViewY = self.viewTool.y+self.viewTool.height;
    CGFloat scViewH = APP_FRAME_HEIGHT-APP_TOP_HEIGHT-scViewY;
    self.scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, scViewY, APP_FRAME_WIDTH, scViewH)];
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
    
    self.tvTopicQuestion = [[ZTopicQuestionTableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvTopicQuestion setScrollsToTop:YES];
    [self.scrollView addSubview:self.tvTopicQuestion];
    
    self.tvTopicPractice = [[ZTopicPracticeTableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvTopicPractice setScrollsToTop:NO];
    [self.scrollView addSubview:self.tvTopicPractice];
    
    ///问题注册事件
    [self.tvTopicQuestion setOnRefreshHeader:^{
        if (weakSelf.onQuestionRefreshHeader) {
            weakSelf.onQuestionRefreshHeader();
        }
    }];
    [self.tvTopicQuestion setOnRefreshFooter:^{
        if (weakSelf.onQuestionRefreshFooter) {
            weakSelf.onQuestionRefreshFooter();
        }
    }];
    [self.tvTopicQuestion setOnRowSelected:^(ModelQuestionBase *model) {
        if (weakSelf.onQuestionClick) {
            weakSelf.onQuestionClick(model);
        }
    }];
    [self.tvTopicQuestion setOnAnswerClick:^(ModelAnswerBase *model) {
        if (weakSelf.onAnswerClick) {
            weakSelf.onAnswerClick(model);
        }
    }];
    [self.tvTopicQuestion setOnImagePhotoClick:^(ModelUserBase *model) {
        if (weakSelf.onImagePhotoClick) {
            weakSelf.onImagePhotoClick(model);
        }
    }];
    [self.tvTopicQuestion setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onQuestionBackgroundClick) {
            weakSelf.onQuestionBackgroundClick();
        }
    }];
    ///实务注册事件
    [self.tvTopicPractice setOnRefreshHeader:^{
        if (weakSelf.onPracticeRefreshHeader) {
            weakSelf.onPracticeRefreshHeader();
        }
    }];
    [self.tvTopicPractice setOnRefreshFooter:^{
        if (weakSelf.onPracticeRefreshFooter) {
            weakSelf.onPracticeRefreshFooter();
        }
    }];
    [self.tvTopicPractice setOnRowSelected:^(NSArray *arrPractice, NSInteger rowIndex) {
        if (weakSelf.onPracticeClick) {
            weakSelf.onPracticeClick(arrPractice, rowIndex);
        }
    }];
    [self.tvTopicPractice setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onPracticeBackgroundClick) {
            weakSelf.onPracticeBackgroundClick();
        }
    }];
}
///问题结束顶部刷新
-(void)endRefreshQuestionHeader
{
    [self.tvTopicQuestion endRefreshHeader];
}
///问题结束底部刷新
-(void)endRefreshQuestionFooter
{
    [self.tvTopicQuestion endRefreshFooter];
}
///实务结束顶部刷新
-(void)endRefreshPracticeHeader
{
    [self.tvTopicPractice endRefreshHeader];
}
///实务结束底部刷新
-(void)endRefreshPracticeFooter
{
    [self.tvTopicPractice endRefreshFooter];
}
///设置问题背景
-(void)setQuestionBackgroundViewWithState:(ZBackgroundState)state
{
    [self.tvTopicQuestion setBackgroundViewWithState:state];
}
///设置实务背景
-(void)setPracticeBackgroundViewWithState:(ZBackgroundState)state
{
    [self.tvTopicPractice setBackgroundViewWithState:state];
}
///设置问题数据
-(void)setViewDataQuestionWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self.tvTopicQuestion setViewDataWithArray:arrResult isHeader:isHeader];
}
///设置实务数据
-(void)setViewDataPracticeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self.tvTopicPractice setViewDataWithArray:arrResult isHeader:isHeader];
}
///设置话题对象
-(void)setViewDataWithModel:(ModelTag *)model
{
    [self.viewHeader setViewDataWithModel:model];
}
///获取实务数据集合
-(NSArray *)getPracticeArray
{
    return [self.tvTopicPractice getPracticeArray];
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
