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
#import "ZMyCollectionSubscribeTableView.h"
#import "ZScrollView.h"
#import "ZSwitchToolView.h"

@interface ZMyCollectionView()<UIScrollViewDelegate>

@property (assign, nonatomic) NSInteger offsetIndex;
@property (strong, nonatomic) ZSwitchToolView *viewTool;
@property (strong, nonatomic) ZScrollView *scrollView;

@property (strong, nonatomic) ZMyCollectionPracticeTableView *tvCollectionPractice;
@property (strong, nonatomic) ZMyCollectionSubscribeTableView *tvCollectionSubscribe;
///@property (strong, nonatomic) ZMyCollectionAnswerTableView *tvCollectionAnswer;

@end

@implementation ZMyCollectionView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    if (!self.scrollView) {
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
    }
    ZWEAKSELF
    if (!self.viewTool) {
        self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemMyCollection)];
        [self.viewTool setOnItemClick:^(NSInteger index) {
            switch (index) {
                case 2:
                    [weakSelf.tvCollectionPractice setScrollsToTop:NO];
                    [weakSelf.tvCollectionSubscribe setScrollsToTop:YES];
                    //[weakSelf.tvCollectionAnswer setScrollsToTop:NO];
                    break;
                    //case 3:
                    //[weakSelf.tvCollectionPractice setScrollsToTop:NO];
                    //[weakSelf.tvCollectionSubscribe setScrollsToTop:NO];
                    //[weakSelf.tvCollectionAnswer setScrollsToTop:YES];
                    //  break;
                default:
                    [weakSelf.tvCollectionPractice setScrollsToTop:YES];
                    [weakSelf.tvCollectionSubscribe setScrollsToTop:NO];
                    //[weakSelf.tvCollectionAnswer setScrollsToTop:NO];
                    break;
            }
            weakSelf.offsetIndex = index - 1;
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.offsetIndex*weakSelf.scrollView.width, 0) animated:YES];
        }];
        [self addSubview:self.viewTool];
    }
    if (!self.tvCollectionPractice) {
        self.tvCollectionPractice = [[ZMyCollectionPracticeTableView alloc] init];
        [self.tvCollectionPractice setBackgroundColor:VIEW_BACKCOLOR1];
        [self.tvCollectionPractice setScrollsToTop:YES];
        [self.tvCollectionPractice setOnRowSelected:^(NSArray *array, NSInteger row) {
            if (weakSelf.onPracticeRowClick) {
                weakSelf.onPracticeRowClick(array, row);
            }
        }];
        [self.tvCollectionPractice setOnDeleteClick:^(ModelPractice *model) {
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
    }
    if (!self.tvCollectionSubscribe) {
        self.tvCollectionSubscribe = [[ZMyCollectionSubscribeTableView alloc] init];
        [self.tvCollectionSubscribe setOnRowSelected:^(ModelCollection *model) {
            if (weakSelf.onSubscribeRowClick) {
                weakSelf.onSubscribeRowClick(model);
            }
        }];
        [self.tvCollectionSubscribe setOnDeleteClick:^(ModelCollection *model) {
            if (weakSelf.onDeleteSubscribeClick) {
                weakSelf.onDeleteSubscribeClick(model);
            }
        }];
        [self.tvCollectionSubscribe setOnPageNumChange:^(int pageNum) {
            if (weakSelf.onPageNumChangeSubscribe) {
                weakSelf.onPageNumChangeSubscribe();
            }
        }];
        [self.tvCollectionSubscribe setOnRefreshHeader:^{
            if (weakSelf.onRefreshSubscribeHeader) {
                weakSelf.onRefreshSubscribeHeader();
            }
        }];
        [self.tvCollectionSubscribe setOnRefreshFooter:^{
            if (weakSelf.onRefreshSubscribeFooter) {
                weakSelf.onRefreshSubscribeFooter();
            }
        }];
        [self.tvCollectionSubscribe setOnBackgroundClick:^(ZBackgroundState state) {
            if (weakSelf.onBackgroundSubscribeClick) {
                weakSelf.onBackgroundSubscribeClick(state);
            }
        }];
        [self.scrollView addSubview:self.tvCollectionSubscribe];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewTool setFrame:CGRectMake(0, 10, self.width, [ZSwitchToolView getViewH])];
    
    [self.scrollView setFrame:CGRectMake(0, self.viewTool.y+self.viewTool.height, self.width, self.height-self.viewTool.height-self.viewTool.y)];
    [self.scrollView setContentSize:CGSizeMake(self.width*2, self.scrollView.height)];
    
    [self.tvCollectionPractice setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvCollectionSubscribe setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    //[self.tvCollectionAnswer setFrame:CGRectMake(self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height)];
}
///设置实务背景状态
-(void)setPracticeBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvCollectionPractice setBackgroundViewWithState:backState];
}
///设置答案背景状态
-(void)setAnswerBackgroundViewWithState:(ZBackgroundState)backState
{
    //[self.tvCollectionAnswer setBackgroundViewWithState:backState];
}
///设置订阅背景状态
-(void)setSubscribeBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvCollectionSubscribe setBackgroundViewWithState:backState];
}
///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel
{
    //[self.tvCollectionAnswer setViewIsDelete:isDel];
    [self.tvCollectionSubscribe setViewIsDelete:isDel];
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
    //[self.tvCollectionAnswer setViewDataWithDictionary:dic];
}
///设置订阅
-(void)setViewSubscribeWithDictionary:(NSDictionary *)dic
{
    [self.tvCollectionSubscribe setViewDataWithDictionary:dic];
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
    //[self.tvCollectionAnswer endRefreshHeader];
}
///结束底部刷新
-(void)endRefreshAnswerFooter
{
    //[self.tvCollectionAnswer endRefreshFooter];
}
///结束顶部刷新
-(void)endRefreshSubscribeHeader
{
    [self.tvCollectionSubscribe endRefreshHeader];
}
///结束底部刷新
-(void)endRefreshSubscribeFooter
{
    [self.tvCollectionSubscribe endRefreshFooter];
}
-(void)dealloc
{
    OBJC_RELEASE(_viewTool);
//    OBJC_RELEASE(_tvCollectionSubscribe);
    //OBJC_RELEASE(_tvCollectionAnswer);
//    OBJC_RELEASE(_tvCollectionPractice);
//    OBJC_RELEASE(_onSubscribeRowClick);
//    OBJC_RELEASE(_onAnswerRowClick);
//    OBJC_RELEASE(_onDeleteSubscribeClick);
//    OBJC_RELEASE(_onPracticeRowClick);
//    OBJC_RELEASE(_onQuestionRowClick);
//    OBJC_RELEASE(_onDeleteAnswerClick);
//    OBJC_RELEASE(_onPageNumChangeSubscribe);
//    OBJC_RELEASE(_onRefreshSubscribeFooter);
//    OBJC_RELEASE(_onRefreshSubscribeHeader);
//    OBJC_RELEASE(_onBackgroundSubscribeClick);
//    OBJC_RELEASE(_onDeletePracticeClick);
//    OBJC_RELEASE(_onPageNumChangeAnswer);
//    OBJC_RELEASE(_onRefreshAnswerFooter);
//    OBJC_RELEASE(_onRefreshAnswerHeader);
//    OBJC_RELEASE(_onBackgroundAnswerClick);
//    OBJC_RELEASE(_onPageNumChangePractice);
//    OBJC_RELEASE(_onRefreshPracticeFooter);
//    OBJC_RELEASE(_onRefreshPracticeHeader);
//    OBJC_RELEASE(_onBackgroundPracticeClick);
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
