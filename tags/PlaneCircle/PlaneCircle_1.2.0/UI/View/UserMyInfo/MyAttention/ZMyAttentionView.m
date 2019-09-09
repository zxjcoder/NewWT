//
//  ZMyAttentionView.m
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAttentionView.h"
#import "ClassCategory.h"
#import "ZMyAttentionTopicTableView.h"
#import "ZMyAttentionUserTableView.h"
#import "ZMyAttentionQuestionTableView.h"

#import "ZSwitchToolView.h"

@interface ZMyAttentionView()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
}

@property (strong, nonatomic) ZSwitchToolView *viewTool;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ZMyAttentionQuestionTableView *tvAttQuestion;
@property (strong, nonatomic) ZMyAttentionTopicTableView *tvAttTopic;
@property (strong, nonatomic) ZMyAttentionUserTableView *tvAttUser;

@end

@implementation ZMyAttentionView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self addSubview:self.scrollView];
    
    __weak typeof(self) weakSelf = self;
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemMyAttention)];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        _offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*self.scrollView.width, 0) animated:YES];
    }];
    [self addSubview:self.viewTool];
    
    self.tvAttQuestion = [[ZMyAttentionQuestionTableView alloc] init];
    [self.tvAttQuestion setOnRowSelected:^(ModelAttentionQuestion *model) {
        if (weakSelf.onQuestionRowClick) {
            weakSelf.onQuestionRowClick(model);
        }
    }];
    [self.tvAttQuestion setOnAnswerClick:^(ModelAttentionQuestion *model) {
        if (weakSelf.onAnswerRowClick) {
            weakSelf.onAnswerRowClick(model);
        }
    }];
    [self.tvAttQuestion setOnImagePhotoClick:^(ModelAttentionQuestion *model) {
        if (weakSelf.onPhotoClick) {
            weakSelf.onPhotoClick(model);
        }
    }];
    [self.tvAttQuestion setOnDeleteClick:^(ModelAttentionQuestion *model) {
        if (weakSelf.onDeleteQuestionClick) {
            weakSelf.onDeleteQuestionClick(model);
        }
    }];
    [self.tvAttQuestion setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onPageNumChangeQuestion) {
            weakSelf.onPageNumChangeQuestion();
        }
    }];
    [self.tvAttQuestion setOnRefreshHeader:^{
        if (weakSelf.onRefreshQuestionHeader) {
            weakSelf.onRefreshQuestionHeader();
        }
    }];
    [self.tvAttQuestion setOnRefreshFooter:^{
        if (weakSelf.onRefreshQuestionFooter) {
            weakSelf.onRefreshQuestionFooter();
        }
    }];
    [self.tvAttQuestion setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundQuestionClick) {
            weakSelf.onBackgroundQuestionClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvAttQuestion];
    
    self.tvAttTopic = [[ZMyAttentionTopicTableView alloc] init];
    [self.tvAttTopic setOnRowSelected:^(ModelTag *model) {
        if (weakSelf.onTagRowClick) {
            weakSelf.onTagRowClick(model);
        }
    }];
    [self.tvAttTopic setOnDeleteClick:^(ModelTag *model) {
        if (weakSelf.onDeleteTopicClick) {
            weakSelf.onDeleteTopicClick(model);
        }
    }];
    [self.tvAttTopic setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onPageNumChangeTopic) {
            weakSelf.onPageNumChangeTopic();
        }
    }];
    [self.tvAttTopic setOnRefreshHeader:^{
        if (weakSelf.onRefreshTopicHeader) {
            weakSelf.onRefreshTopicHeader();
        }
    }];
    [self.tvAttTopic setOnRefreshFooter:^{
        if (weakSelf.onRefreshTopicFooter) {
            weakSelf.onRefreshTopicFooter();
        }
    }];
    [self.tvAttTopic setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundTopicClick) {
            weakSelf.onBackgroundTopicClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvAttTopic];
    
    self.tvAttUser = [[ZMyAttentionUserTableView alloc] init];
    [self.tvAttUser setOnRowSelected:^(ModelUserBase *model, NSInteger row) {
        if (weakSelf.onUserRowClick) {
            weakSelf.onUserRowClick(model, row);
        }
    }];
    [self.tvAttUser setOnDeleteClick:^(ModelUserBase *model) {
        if (weakSelf.onDeleteUserClick) {
            weakSelf.onDeleteUserClick(model);
        }
    }];
    [self.tvAttUser setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onPageNumChangeUser) {
            weakSelf.onPageNumChangeUser();
        }
    }];
    [self.tvAttUser setOnRefreshHeader:^{
        if (weakSelf.onRefreshUserHeader) {
            weakSelf.onRefreshUserHeader();
        }
    }];
    [self.tvAttUser setOnRefreshFooter:^{
        if (weakSelf.onRefreshUserFooter) {
            weakSelf.onRefreshUserFooter();
        }
    }];
    [self.tvAttUser setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundUserClick) {
            weakSelf.onBackgroundUserClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvAttUser];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewTool setFrame:CGRectMake(0, 0, self.width, [ZSwitchToolView getViewH])];
    
    [self.scrollView setFrame:CGRectMake(0, self.viewTool.height, self.width, self.height-self.viewTool.height)];
    [self.scrollView setContentSize:CGSizeMake(self.width*3, self.scrollView.height)];
    
    [self.tvAttQuestion setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvAttTopic setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvAttUser setFrame:CGRectMake(self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height)];
}
///设置问题背景状态
-(void)setQuestionBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvAttQuestion setBackgroundViewWithState:backState];
}
///设置话题背景状态
-(void)setTopicBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvAttTopic setBackgroundViewWithState:backState];
}
///设置用户背景状态
-(void)setUserBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvAttUser setBackgroundViewWithState:backState];
}
///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel
{
    [self.tvAttTopic setViewIsDelete:isDel];
    [self.tvAttUser setViewIsDelete:isDel];
    [self.tvAttQuestion setViewIsDelete:isDel];
}
///删除用户的行
-(void)setDeleteUserWithRow:(NSInteger)row
{
    [self.tvAttUser setDeleteUserWithRow:row];
}
///设置问题
-(void)setViewQuestionWithDictionary:(NSDictionary *)dic
{
    [self.tvAttQuestion setViewDataWithDictionary:dic];
}
///设置话题
-(void)setViewTopicWithDictionary:(NSDictionary *)dic
{
    [self.tvAttTopic setViewDataWithDictionary:dic];
}
///设置用户
-(void)setViewUserWithDictionary:(NSDictionary *)dic
{
    [self.tvAttUser setViewDataWithDictionary:dic];
}
///结束问题顶部刷新
-(void)endRefreshQuestionHeader
{
    [self.tvAttQuestion endRefreshHeader];
}
///结束问题底部刷新
-(void)endRefreshQuestionFooter
{
    [self.tvAttQuestion endRefreshFooter];
}
///结束顶部刷新
-(void)endRefreshTopicHeader
{
    [self.tvAttTopic endRefreshHeader];
}
///结束底部刷新
-(void)endRefreshTopicFooter
{
    [self.tvAttTopic endRefreshFooter];
}
///结束顶部刷新
-(void)endRefreshUserHeader
{
    [self.tvAttUser endRefreshHeader];
}
///结束底部刷新
-(void)endRefreshUserFooter
{
    [self.tvAttUser endRefreshFooter];
}
-(void)dealloc
{
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvAttUser);
    OBJC_RELEASE(_tvAttTopic);
    OBJC_RELEASE(_tvAttQuestion);
    OBJC_RELEASE(_onQuestionRowClick);
    OBJC_RELEASE(_onAnswerRowClick);
    OBJC_RELEASE(_onPhotoClick);
    OBJC_RELEASE(_onTagRowClick);
    OBJC_RELEASE(_onUserRowClick);
    OBJC_RELEASE(_onDeleteUserClick);
    OBJC_RELEASE(_onDeleteTopicClick);
    OBJC_RELEASE(_onPageNumChangeUser);
    OBJC_RELEASE(_onPageNumChangeTopic);
    OBJC_RELEASE(_onRefreshUserFooter);
    OBJC_RELEASE(_onRefreshUserHeader);
    OBJC_RELEASE(_onRefreshTopicFooter);
    OBJC_RELEASE(_onRefreshTopicHeader);
    OBJC_RELEASE(_onRefreshQuestionFooter);
    OBJC_RELEASE(_onRefreshQuestionHeader);
    OBJC_RELEASE(_onBackgroundUserClick);
    OBJC_RELEASE(_onBackgroundTopicClick);
    OBJC_RELEASE(_onBackgroundQuestionClick);
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
