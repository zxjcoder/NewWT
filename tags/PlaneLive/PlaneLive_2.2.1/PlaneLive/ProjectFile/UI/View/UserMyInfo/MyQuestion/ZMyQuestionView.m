//
//  ZMyQuestionView.m
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyQuestionView.h"
#import "ClassCategory.h"
#import "ZMyQuestionAllTableView.h"
#import "ZMyQuestionNewTableView.h"
#import "ZScrollView.h"
#import "ZSwitchToolView.h"

@interface ZMyQuestionView()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
    BOOL _isSetContentOffset;
}
@property (strong, nonatomic) ZSwitchToolView *viewTool;

@property (strong, nonatomic) ZScrollView *scrollView;

@property (strong, nonatomic) ZMyQuestionAllTableView *tvQuestionAll;
@property (strong, nonatomic) ZMyQuestionNewTableView *tvQuestionNew;

@end

@implementation ZMyQuestionView

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
    self.scrollView = [[ZScrollView alloc] init];
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
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemMyQuestion)];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        switch (index) {
            case 2:
                [weakSelf.tvQuestionAll setScrollsToTop:NO];
                [weakSelf.tvQuestionNew setScrollsToTop:YES];
                break;
            default:
                [weakSelf.tvQuestionAll setScrollsToTop:YES];
                [weakSelf.tvQuestionNew setScrollsToTop:NO];
                break;
        }
        _offsetIndex = index - 1;
        if (weakSelf.onSwitchToolChange) {
            weakSelf.onSwitchToolChange(index-1);
        }
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*weakSelf.scrollView.width, 0) animated:YES];
    }];
    [self addSubview:self.viewTool];
    
    self.tvQuestionAll = [[ZMyQuestionAllTableView alloc] init];
    [self.tvQuestionAll setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvQuestionAll setScrollsToTop:YES];
    [self.tvQuestionAll setOnRowSelected:^(ModelMyAllQuestion *model) {
        if (weakSelf.onAllRowClick) {
            weakSelf.onAllRowClick(model);
        }
    }];
    [self.tvQuestionAll setOnDeleteClick:^(ModelMyAllQuestion *model) {
        if (weakSelf.onDeleteAllClick) {
            weakSelf.onDeleteAllClick(model);
        }
    }];
    [self.tvQuestionAll setOnRefreshHeader:^{
        if (weakSelf.onRefreshAllHeader) {
            weakSelf.onRefreshAllHeader();
        }
    }];
    [self.tvQuestionAll setOnRefreshFooter:^{
        if (weakSelf.onRefreshAllFooter) {
            weakSelf.onRefreshAllFooter();
        }
    }];
    [self.tvQuestionAll setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onAllPageNumChange) {
            weakSelf.onAllPageNumChange(pageNum);
        }
    }];
    [self.tvQuestionAll setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundAllClick) {
            weakSelf.onBackgroundAllClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvQuestionAll];
    
    self.tvQuestionNew = [[ZMyQuestionNewTableView alloc] init];
    [self.tvQuestionNew setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvQuestionNew setScrollsToTop:NO];
    [self.tvQuestionNew setOnQuestionClick:^(ModelQuestionBase *model) {
        if (weakSelf.onNewRowClick) {
            weakSelf.onNewRowClick(model);
        }
    }];
    [self.tvQuestionNew setOnImagePhotoClick:^(ModelUserBase *model) {
        if (weakSelf.onNewPhotoClick) {
            weakSelf.onNewPhotoClick(model);
        }
    }];
    [self.tvQuestionNew setOnAnswerClick:^(ModelAnswerBase *model) {
        if (weakSelf.onNewAnswerClick) {
            weakSelf.onNewAnswerClick(model);
        }
    }];
    [self.tvQuestionNew setOnDeleteClick:^(ModelMyNewQuestion *model) {
        if (weakSelf.onDeleteNewClick) {
            weakSelf.onDeleteNewClick(model);
        }
    }];
    [self.tvQuestionNew setOnRefreshHeader:^{
        if (weakSelf.onRefreshNewHeader) {
            weakSelf.onRefreshNewHeader();
        }
    }];
    [self.tvQuestionNew setOnRefreshFooter:^{
        if (weakSelf.onRefreshNewFooter) {
            weakSelf.onRefreshNewFooter();
        }
    }];
    [self.tvQuestionNew setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onNewPageNumChange) {
            weakSelf.onNewPageNumChange(pageNum);
        }
    }];
    [self.tvQuestionNew setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundNewClick) {
            weakSelf.onBackgroundNewClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvQuestionNew];
    
    [self setViewFrame];
}
-(void)dealloc
{
    OBJC_RELEASE(_viewTool);
    [_scrollView setDelegate:nil];
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_onAllRowClick);
    OBJC_RELEASE(_onNewRowClick);
    OBJC_RELEASE(_onDeleteAllClick);
    OBJC_RELEASE(_onDeleteNewClick);
    OBJC_RELEASE(_onRefreshAllFooter);
    OBJC_RELEASE(_onRefreshAllHeader);
    OBJC_RELEASE(_onRefreshNewFooter);
    OBJC_RELEASE(_onRefreshNewHeader);
    OBJC_RELEASE(_onAllAnswerClick);
    OBJC_RELEASE(_onAllPageNumChange);
    OBJC_RELEASE(_onNewPageNumChange);
    OBJC_RELEASE(_onBackgroundAllClick);
    OBJC_RELEASE(_onBackgroundNewClick);
}
-(void)setViewFrame
{
    [self.viewTool setFrame:CGRectMake(0, 0, self.width, [ZSwitchToolView getViewH])];
    
    [self.scrollView setFrame:CGRectMake(0, self.viewTool.height, self.width, self.height-self.viewTool.height)];
    [self.scrollView setContentSize:CGSizeMake(self.width*2, self.scrollView.height)];
    
    [self.tvQuestionAll setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvQuestionNew setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    
}

-(void)setViewIsDelete:(BOOL)isDel
{
    [self.tvQuestionAll setViewIsDelete:isDel];
    [self.tvQuestionNew setViewIsDelete:isDel];
}

///设置昵称描述内容类型 0 你 1 他  2 她
-(void)setViewNickNameDescType:(int)nickNameDescType;
{
    [self.tvQuestionNew setViewNickNameDescType:nickNameDescType];
}

-(void)setNewQuestionCount:(int)count
{
    [self.viewTool setItemCount:count index:2];
}

-(void)setViewAllWithDictionary:(NSDictionary *)dic
{
    [self.tvQuestionAll setViewDataWithDictionary:dic];
}

-(void)setViewNewWithDictionary:(NSDictionary *)dic
{
    [self.tvQuestionNew setViewDataWithDictionary:dic];
}
-(void)setAllBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvQuestionAll setBackgroundViewWithState:backState];
}
-(void)setNewBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvQuestionNew setBackgroundViewWithState:backState];
}
-(void)endRefreshAllHeader
{
    [self.tvQuestionAll endRefreshHeader];
}
-(void)endRefreshAllFooter
{
    [self.tvQuestionAll endRefreshFooter];
}
-(void)endRefreshNewHeader
{
    [self.tvQuestionNew endRefreshHeader];
}
-(void)endRefreshNewFooter
{
    [self.tvQuestionNew endRefreshFooter];
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
