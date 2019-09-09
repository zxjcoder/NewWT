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

@interface ZMyAttentionView()<UIScrollViewDelegate>
{
    NSInteger _offsetIndex;
}
@property (strong, nonatomic) UIButton *btnTopic;
@property (strong, nonatomic) UIButton *btnUser;
@property (strong, nonatomic) UIView *viewLine;
@property (strong, nonatomic) UIView *viewLine1;

@property (strong, nonatomic) UIScrollView *scrollView;

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
    
    self.btnTopic = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnTopic setTitle:@"话题" forState:(UIControlStateNormal)];
    [self.btnTopic setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnTopic setTag:1];
    [[self.btnTopic titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnTopic addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnTopic];
    
    self.btnUser = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnUser setTitle:@"用户" forState:(UIControlStateNormal)];
    [self.btnUser setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnUser setTag:2];
    [[self.btnUser titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnUser addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnUser];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:MAINCOLOR];
    [self addSubview:self.viewLine];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewLine1];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self addSubview:self.scrollView];
    
    __weak typeof(self) weakSelf = self;
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
    [self.tvAttUser setOnRowSelected:^(ModelUserBase *model) {
        if (weakSelf.onUserRowClick) {
            weakSelf.onUserRowClick(model);
        }
    }];
    [self.tvAttUser setOnDeleteClick:^(ModelUserBase *model) {
        if (weakSelf.onDeleteUserClick) {
            weakSelf.onDeleteUserClick(model);
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

-(void)setTopicBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvAttTopic setBackgroundViewWithState:backState];
}

-(void)setUserBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvAttUser setBackgroundViewWithState:backState];
}

-(void)btnItemClick:(UIButton *)sender
{
    _offsetIndex = sender.tag - 1;
    [self setViewSelectItemWithType:_offsetIndex];
    [self.scrollView setContentOffset:CGPointMake(_offsetIndex*self.scrollView.width, 0) animated:YES];
}

-(void)setViewSelectItemWithType:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.btnTopic setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                [self.btnUser setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }];
            break;
        }
        case 1:
        {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.btnTopic setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [self.btnUser setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
            }];
            break;
        }
        default: break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnH = 38;
    [self.btnTopic setFrame:CGRectMake(0, 0, self.width/2, btnH)];
    [self.btnUser setFrame:CGRectMake(self.width/2, 0, self.width/2, btnH)];
    [self.viewLine setFrame:CGRectMake(self.width/2*_offsetIndex, 38, self.width/2, 2)];
    [self.viewLine1 setFrame:CGRectMake(0, 39.5, self.width, 0.8)];
    [self.scrollView setFrame:CGRectMake(0, 40, self.width, self.height-40)];
    [self.scrollView setContentSize:CGSizeMake(self.width*2, self.scrollView.height)];
    
    [self.tvAttTopic setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvAttUser setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self.tvAttTopic setViewIsDelete:isDel];
    [self.tvAttUser setViewIsDelete:isDel];
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
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_btnUser);
    OBJC_RELEASE(_btnTopic);
    OBJC_RELEASE(_tvAttUser);
    OBJC_RELEASE(_tvAttTopic);
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
}
#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self setViewSelectItemWithType:_offsetIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect lineFrame = self.viewLine.frame;
    lineFrame.origin.x = scrollView.contentOffset.x/2;
    [self.viewLine setFrame:lineFrame];
}

@end
