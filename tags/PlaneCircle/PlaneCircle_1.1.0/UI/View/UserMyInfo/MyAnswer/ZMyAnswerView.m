//
//  ZMyAnswerView.m
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAnswerView.h"
#import "ClassCategory.h"

#import "ZMyAnswerCommentTableView.h"
#import "ZMyAnswerTableView.h"

#import "ZSwitchToolView.h"

@interface ZMyAnswerView()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
}
@property (strong, nonatomic) ZSwitchToolView *viewTool;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ZMyAnswerTableView *tvAnswer;
@property (strong, nonatomic) ZMyAnswerCommentTableView *tvComment;

@end

@implementation ZMyAnswerView

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
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setBackgroundColor:VIEW_BACKCOLOR2];
    [self addSubview:self.scrollView];
    
    __weak typeof(self) weakSelf = self;
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemMyAnswer)];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        _offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*self.scrollView.width, 0) animated:YES];
    }];
    [self addSubview:self.viewTool];
    
    self.tvAnswer = [[ZMyAnswerTableView alloc] init];
    [self.tvAnswer setOnRowSelected:^(ModelQuestionMyAnswer *model) {
        if (weakSelf.onAnswerRowClick) {
            weakSelf.onAnswerRowClick(model);
        }
    }];
    [self.tvAnswer setOnDeleteClick:^(ModelQuestionMyAnswer *model) {
        if (weakSelf.onDeleteAnswerClick) {
            weakSelf.onDeleteAnswerClick(model);
        }
    }];
    [self.tvAnswer setOnQuestionClick:^(ModelQuestionMyAnswer *model) {
        if (weakSelf.onQuestionRowClick) {
            weakSelf.onQuestionRowClick(model);
        }
    }];
    [self.tvAnswer setOnRefreshHeader:^{
        if (weakSelf.onRefreshAnswerHeader) {
            weakSelf.onRefreshAnswerHeader();
        }
    }];
    [self.tvAnswer setOnRefreshFooter:^{
        if (weakSelf.onRefreshAnswerFooter) {
            weakSelf.onRefreshAnswerFooter();
        }
    }];
    [self.tvAnswer setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onAnswerPageNumChange) {
            weakSelf.onAnswerPageNumChange(pageNum);
        }
    }];
    [self.tvAnswer setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundAnswerClick) {
            weakSelf.onBackgroundAnswerClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvAnswer];
    
    self.tvComment = [[ZMyAnswerCommentTableView alloc] init];
    [self.tvComment setOnRowSelected:^(ModelQuestionMyAnswerComment *model) {
        if (weakSelf.onCommentRowClick) {
            weakSelf.onCommentRowClick(model);
        }
    }];
    [self.tvComment setOnDeleteClick:^(ModelQuestionMyAnswerComment *model) {
        if (weakSelf.onDeleteCommentClick) {
            weakSelf.onDeleteCommentClick(model);
        }
    }];
    [self.tvComment setOnRefreshHeader:^{
        if (weakSelf.onRefreshCommentHeader) {
            weakSelf.onRefreshCommentHeader();
        }
    }];
    [self.tvComment setOnRefreshFooter:^{
        if (weakSelf.onRefreshCommentFooter) {
            weakSelf.onRefreshCommentFooter();
        }
    }];
    [self.tvComment setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onCommentPageNumChange) {
            weakSelf.onCommentPageNumChange(pageNum);
        }
    }];
    [self.tvComment setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundCommentClick) {
            weakSelf.onBackgroundCommentClick(state);
        }
    }];
    [self.tvComment setOnImagePhotoClick:^(ModelQuestionMyAnswerComment *model) {
        if (weakSelf.onPhotoClick) {
            weakSelf.onPhotoClick(model);
        }
    }];
    [self.scrollView addSubview:self.tvComment];
}
-(void)dealloc
{
    OBJC_RELEASE(_viewTool);
    [_scrollView setDelegate:nil];
    OBJC_RELEASE(_scrollView);
    
    OBJC_RELEASE(_onAnswerRowClick);
    OBJC_RELEASE(_onDeleteAnswerClick);
    OBJC_RELEASE(_onRefreshAnswerFooter);
    OBJC_RELEASE(_onRefreshAnswerHeader);
    
    OBJC_RELEASE(_onCommentRowClick);
    OBJC_RELEASE(_onDeleteCommentClick);
    OBJC_RELEASE(_onRefreshCommentFooter);
    OBJC_RELEASE(_onRefreshCommentHeader);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewTool setFrame:CGRectMake(0, 0, self.width, [ZSwitchToolView getViewH])];
    
    [self.scrollView setFrame:CGRectMake(0, self.viewTool.height, self.width, self.height-self.viewTool.height)];
    [self.scrollView setContentSize:CGSizeMake(self.width*2, self.scrollView.height)];
    
    [self.tvAnswer setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvComment setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self.tvAnswer setViewIsDelete:isDel];
    [self.tvComment setViewIsDelete:isDel];
}

-(void)setCommentCount:(int)count
{
    [self.viewTool setItemCount:count index:2];
}

-(void)setViewAnswerWithDictionary:(NSDictionary *)dic
{
    [self.tvAnswer setViewDataWithDictionary:dic];
}

-(void)setViewCommentWithDictionary:(NSDictionary *)dic
{
    [self.tvComment setViewDataWithDictionary:dic];
}
-(void)setAnswerBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvAnswer setBackgroundViewWithState:backState];
}
-(void)setCommentBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvComment setBackgroundViewWithState:backState];
}
-(void)endRefreshAnswerHeader
{
    [self.tvAnswer endRefreshHeader];
}
-(void)endRefreshAnswerFooter
{
    [self.tvAnswer endRefreshFooter];
}
-(void)endRefreshCommentHeader
{
    [self.tvComment endRefreshHeader];
}
-(void)endRefreshCommentFooter
{
    [self.tvComment endRefreshFooter];
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
