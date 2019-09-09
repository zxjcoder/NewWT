//
//  ZMyCollectionView.m
//  PlaneCircle
//
//  Created by Daniel on 7/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionView.h"
#import "ClassCategory.h"
#import "ZMyCollectionAnswerTableView.h"
#import "ZMyCollectionPracticeTableView.h"
#import "ZMyCollectionRankTableView.h"

#import "ZSwitchToolView.h"

@interface ZMyCollectionView()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
}

@property (strong, nonatomic) ZSwitchToolView *viewTool;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ZMyCollectionPracticeTableView *tvCollectionPractice;
@property (strong, nonatomic) ZMyCollectionAnswerTableView *tvCollectionAnswer;
//@property (strong, nonatomic) ZMyCollectionRankTableView *tvCollectionRank;

@end

@implementation ZMyCollectionView

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
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setBackgroundColor:VIEW_BACKCOLOR1];
    [self addSubview:self.scrollView];
    
    ZWEAKSELF
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemMyCollection)];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        switch (index) {
            case 2:
                [weakSelf.tvCollectionPractice setScrollsToTop:NO];
                [weakSelf.tvCollectionAnswer setScrollsToTop:YES];
                break;
            default:
                [weakSelf.tvCollectionPractice setScrollsToTop:YES];
                [weakSelf.tvCollectionAnswer setScrollsToTop:NO];
                break;
        }
        _offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*self.scrollView.width, 0) animated:YES];
    }];
    [self addSubview:self.viewTool];
    
    self.tvCollectionPractice = [[ZMyCollectionPracticeTableView alloc] init];
    [self.tvCollectionPractice setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvCollectionPractice setScrollsToTop:YES];
    [self.tvCollectionPractice setOnRowSelected:^(ModelCollection *model) {
        if (weakSelf.onPracticeRowClick) {
            weakSelf.onPracticeRowClick(model);
        }
    }];
    [self.tvCollectionPractice setOnDeleteClick:^(ModelCollection *model) {
        if (weakSelf.onDeletePracticeClick) {
            weakSelf.onDeletePracticeClick(model);
        }
    }];
    [self.tvCollectionPractice setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onPageNumChangePractice) {
            weakSelf.onPageNumChangePractice();
        }
    }];
    [self.tvCollectionPractice setOnRefreshHeader:^{
        if (weakSelf.onRefreshPracticeHeader) {
            weakSelf.onRefreshPracticeHeader();
        }
    }];
    [self.tvCollectionPractice setOnRefreshFooter:^{
        if (weakSelf.onRefreshPracticeFooter) {
            weakSelf.onRefreshPracticeFooter();
        }
    }];
    [self.tvCollectionPractice setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundPracticeClick) {
            weakSelf.onBackgroundPracticeClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvCollectionPractice];
    
    self.tvCollectionAnswer = [[ZMyCollectionAnswerTableView alloc] init];
    [self.tvCollectionAnswer setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvCollectionAnswer setScrollsToTop:NO];
    [self.tvCollectionAnswer setOnRowSelected:^(ModelCollectionAnswer *model) {
        if (weakSelf.onQuestionRowClick) {
            weakSelf.onQuestionRowClick(model);
        }
    }];
    [self.tvCollectionAnswer setOnAnswerClick:^(ModelCollectionAnswer *model) {
        if (weakSelf.onAnswerRowClick) {
            weakSelf.onAnswerRowClick(model);
        }
    }];
    [self.tvCollectionAnswer setOnDeleteClick:^(ModelCollectionAnswer *model) {
        if (weakSelf.onDeleteAnswerClick) {
            weakSelf.onDeleteAnswerClick(model);
        }
    }];
    [self.tvCollectionAnswer setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onPageNumChangeAnswer) {
            weakSelf.onPageNumChangeAnswer();
        }
    }];
    [self.tvCollectionAnswer setOnRefreshHeader:^{
        if (weakSelf.onRefreshAnswerHeader) {
            weakSelf.onRefreshAnswerHeader();
        }
    }];
    [self.tvCollectionAnswer setOnRefreshFooter:^{
        if (weakSelf.onRefreshAnswerFooter) {
            weakSelf.onRefreshAnswerFooter();
        }
    }];
    [self.tvCollectionAnswer setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundAnswerClick) {
            weakSelf.onBackgroundAnswerClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvCollectionAnswer];
    
//    self.tvCollectionRank = [[ZMyCollectionRankTableView alloc] init];
//    [self.tvCollectionRank setOnRowSelected:^(ModelCollection *model) {
//        if (weakSelf.onRankRowClick) {
//            weakSelf.onRankRowClick(model);
//        }
//    }];
//    [self.tvCollectionRank setOnDeleteClick:^(ModelCollection *model) {
//        if (weakSelf.onDeleteRankClick) {
//            weakSelf.onDeleteRankClick(model);
//        }
//    }];
//    [self.tvCollectionRank setOnPageNumChange:^(int pageNum) {
//        if (weakSelf.onPageNumChangeRank) {
//            weakSelf.onPageNumChangeRank();
//        }
//    }];
//    [self.tvCollectionRank setOnRefreshHeader:^{
//        if (weakSelf.onRefreshRankHeader) {
//            weakSelf.onRefreshRankHeader();
//        }
//    }];
//    [self.tvCollectionRank setOnRefreshFooter:^{
//        if (weakSelf.onRefreshRankFooter) {
//            weakSelf.onRefreshRankFooter();
//        }
//    }];
//    [self.tvCollectionRank setOnBackgroundClick:^(ZBackgroundState state) {
//        if (weakSelf.onBackgroundRankClick) {
//            weakSelf.onBackgroundRankClick(state);
//        }
//    }];
//    [self.scrollView addSubview:self.tvCollectionRank];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewTool setFrame:CGRectMake(0, 0, self.width, [ZSwitchToolView getViewH])];
    
    [self.scrollView setFrame:CGRectMake(0, self.viewTool.height, self.width, self.height-self.viewTool.height)];
    [self.scrollView setContentSize:CGSizeMake(self.width*2, self.scrollView.height)];
    
    [self.tvCollectionPractice setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvCollectionAnswer setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
//    [self.tvCollectionRank setFrame:CGRectMake(self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height)];
}
///设置实务背景状态
-(void)setPracticeBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvCollectionPractice setBackgroundViewWithState:backState];
}
///设置答案背景状态
-(void)setAnswerBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvCollectionAnswer setBackgroundViewWithState:backState];
}
///设置榜单背景状态
-(void)setRankBackgroundViewWithState:(ZBackgroundState)backState
{
//    [self.tvCollectionRank setBackgroundViewWithState:backState];
}
///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel
{
    [self.tvCollectionAnswer setViewIsDelete:isDel];
//    [self.tvCollectionRank setViewIsDelete:isDel];
    [self.tvCollectionPractice setViewIsDelete:isDel];
}
///设置实务
-(void)setViewPracticeWithDictionary:(NSDictionary *)dic
{
    [self.tvCollectionPractice setViewDataWithDictionary:dic];
}
///设置答案
-(void)setViewAnswerWithDictionary:(NSDictionary *)dic
{
    [self.tvCollectionAnswer setViewDataWithDictionary:dic];
}
///设置榜单
-(void)setViewRankWithDictionary:(NSDictionary *)dic
{
//    [self.tvCollectionRank setViewDataWithDictionary:dic];
}
///结束实务顶部刷新
-(void)endRefreshPracticeHeader
{
    [self.tvCollectionPractice endRefreshHeader];
}
///结束实务底部刷新
-(void)endRefreshPracticeFooter
{
    [self.tvCollectionPractice endRefreshFooter];
}
///结束顶部刷新
-(void)endRefreshAnswerHeader
{
    [self.tvCollectionAnswer endRefreshHeader];
}
///结束底部刷新
-(void)endRefreshAnswerFooter
{
    [self.tvCollectionAnswer endRefreshFooter];
}
///结束顶部刷新
-(void)endRefreshRankHeader
{
//    [self.tvCollectionRank endRefreshHeader];
}
///结束底部刷新
-(void)endRefreshRankFooter
{
//    [self.tvCollectionRank endRefreshFooter];
}
-(void)dealloc
{
    OBJC_RELEASE(_viewTool);
//    OBJC_RELEASE(_tvCollectionRank);
    OBJC_RELEASE(_tvCollectionAnswer);
    OBJC_RELEASE(_tvCollectionPractice);
    OBJC_RELEASE(_onRankRowClick);
    OBJC_RELEASE(_onAnswerRowClick);
    OBJC_RELEASE(_onDeleteRankClick);
    OBJC_RELEASE(_onPracticeRowClick);
    OBJC_RELEASE(_onQuestionRowClick);
    OBJC_RELEASE(_onDeleteAnswerClick);
    OBJC_RELEASE(_onPageNumChangeRank);
    OBJC_RELEASE(_onRefreshRankFooter);
    OBJC_RELEASE(_onRefreshRankHeader);
    OBJC_RELEASE(_onBackgroundRankClick);
    OBJC_RELEASE(_onDeletePracticeClick);
    OBJC_RELEASE(_onPageNumChangeAnswer);
    OBJC_RELEASE(_onRefreshAnswerFooter);
    OBJC_RELEASE(_onRefreshAnswerHeader);
    OBJC_RELEASE(_onBackgroundAnswerClick);
    OBJC_RELEASE(_onPageNumChangePractice);
    OBJC_RELEASE(_onRefreshPracticeFooter);
    OBJC_RELEASE(_onRefreshPracticeHeader);
    OBJC_RELEASE(_onBackgroundPracticeClick);
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
