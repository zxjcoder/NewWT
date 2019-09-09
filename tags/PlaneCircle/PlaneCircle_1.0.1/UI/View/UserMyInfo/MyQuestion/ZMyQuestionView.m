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

#import <UMMobClick/MobClick.h>

@interface ZMyQuestionView()<UIScrollViewDelegate>
{
    NSInteger _offsetIndex;
}
@property (strong, nonatomic) UIButton *btnAll;
@property (strong, nonatomic) UIButton *btnNew;

@property (strong, nonatomic) UIView *viewLine;
@property (strong, nonatomic) UIView *viewLine1;

@property (strong, nonatomic) UIScrollView *scrollView;

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

-(void)innerInit
{
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    
    self.btnAll = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAll setTitle:@"所有问题" forState:(UIControlStateNormal)];
    [self.btnAll setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnAll setTag:1];
    [self.btnAll setBackgroundColor:WHITECOLOR];
    [[self.btnAll titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnAll addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnAll];
    
    self.btnNew = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnNew setTitle:@"新答案" forState:(UIControlStateNormal)];
    [self.btnNew setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnNew setTag:2];
    [self.btnNew setBackgroundColor:WHITECOLOR];
    [[self.btnNew titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnNew addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnNew];
    
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
    [self.scrollView setBackgroundColor:VIEW_BACKCOLOR2];
    [self addSubview:self.scrollView];
    
    __weak typeof(self) weakSelf = self;
    self.tvQuestionAll = [[ZMyQuestionAllTableView alloc] init];
    [self.tvQuestionAll setOnRowSelected:^(ModelQuestionDetail *model) {
        if (weakSelf.onAllRowClick) {
            weakSelf.onAllRowClick(model);
        }
    }];
    [self.tvQuestionAll setOnDeleteClick:^(ModelQuestionDetail *model) {
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
    [self.tvQuestionAll setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundAllClick) {
            weakSelf.onBackgroundAllClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvQuestionAll];
    
    self.tvQuestionNew = [[ZMyQuestionNewTableView alloc] init];
    [self.tvQuestionNew setOnRowSelected:^(ModelQuestionDetail *model) {
        if (weakSelf.onNewRowClick) {
            weakSelf.onNewRowClick(model);
        }
    }];
    [self.tvQuestionNew setOnDeleteClick:^(ModelQuestionDetail *model) {
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
    [self.tvQuestionNew setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundNewClick) {
            weakSelf.onBackgroundNewClick(state);
        }
    }];
    [self.scrollView addSubview:self.tvQuestionNew];
}
-(void)dealloc
{
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewLine1);
    [_scrollView setDelegate:nil];
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_btnAll);
    OBJC_RELEASE(_btnNew);
    OBJC_RELEASE(_onAllRowClick);
    OBJC_RELEASE(_onNewRowClick);
    OBJC_RELEASE(_onDeleteAllClick);
    OBJC_RELEASE(_onDeleteNewClick);
    OBJC_RELEASE(_onRefreshAllFooter);
    OBJC_RELEASE(_onRefreshAllHeader);
    OBJC_RELEASE(_onRefreshNewFooter);
    OBJC_RELEASE(_onRefreshNewHeader);
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
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_User_MYQuestion_All];
            
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.btnAll setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                [self.btnNew setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }];
            break;
        }
        case 1:
        {
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_User_MYQuestion_New];
            
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.btnAll setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [self.btnNew setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
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
    [self.btnAll setFrame:CGRectMake(0, 0, self.width/2, btnH)];
    [self.btnNew setFrame:CGRectMake(self.width/2, 0, self.width/2, btnH)];
    [self.viewLine setFrame:CGRectMake(self.width/2*_offsetIndex, 38, self.width/2, 2)];
    [self.viewLine1 setFrame:CGRectMake(0, 39.5, self.width, 0.7)];
    [self.scrollView setFrame:CGRectMake(0, 40, self.width, self.height-40)];
    [self.scrollView setContentSize:CGSizeMake(self.width*2, self.scrollView.height)];
    
    [self.tvQuestionAll setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvQuestionNew setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self.tvQuestionAll setViewIsDelete:isDel];
    [self.tvQuestionNew setViewIsDelete:isDel];
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
    [self setViewSelectItemWithType:_offsetIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect lineFrame = self.viewLine.frame;
    lineFrame.origin.x = scrollView.contentOffset.x/2;
    [self.viewLine setFrame:lineFrame];
}

@end
