//
//  ZCircleSearchTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchTableView.h"
#import "ClassCategory.h"
#import "ZCircleSearchContentTableView.h"
#import "ZCircleSearchUserTableView.h"

#import "ZSwitchToolView.h"

@interface ZCircleSearchTableView()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
}
@property (strong, nonatomic) ZSwitchToolView *viewTool;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ZCircleSearchContentTableView *tvSearchContent;

@property (strong, nonatomic) ZCircleSearchUserTableView *tvSearchUser;

@end

@implementation ZCircleSearchTableView

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
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemCircleSearch)];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        _offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*self.scrollView.width, 0) animated:YES];
    }];
    [self addSubview:self.viewTool];
    
    self.tvSearchContent = [[ZCircleSearchContentTableView alloc] init];
    [self.tvSearchContent setScrollsToTop:NO];
    [self.tvSearchContent setOnRowSelected:^(ModelQuestionBase *model) {
        if (weakSelf.onContentItemClick) {
            weakSelf.onContentItemClick(model);
        }
    }];
    [self.tvSearchContent setOnOffsetChange:^(CGFloat y) {
        if (weakSelf.onOffsetChange) {
            weakSelf.onOffsetChange(y);
        }
    }];
    [self.tvSearchContent setOnTagSelected:^(ModelTag *model) {
        if (weakSelf.onTagClick) {
            weakSelf.onTagClick(model);
        }
    }];
    [self.tvSearchContent setOnRefreshFooter:^{
        if (weakSelf.onRefreshContentFooter) {
            weakSelf.onRefreshContentFooter();
        }
    }];
    [self.tvSearchContent setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onContentBackgoundClick) {
            weakSelf.onContentBackgoundClick();
        }
    }];
    [self.scrollView addSubview:self.tvSearchContent];
    
    self.tvSearchUser = [[ZCircleSearchUserTableView alloc] init];
    [self.tvSearchUser setScrollsToTop:NO];
    [self.tvSearchUser setOnRowSelected:^(ModelUserBase *model) {
        if (weakSelf.onUserItemClick) {
            weakSelf.onUserItemClick(model);
        }
    }];
    [self.tvSearchUser setOnOffsetChange:^(CGFloat y) {
        if (weakSelf.onOffsetChange) {
            weakSelf.onOffsetChange(y);
        }
    }];
    [self.tvSearchUser setOnRefreshFooter:^{
        if (weakSelf.onRefreshUserFooter) {
            weakSelf.onRefreshUserFooter();
        }
    }];
    [self.tvSearchUser setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onUserBackgoundClick) {
            weakSelf.onUserBackgoundClick();
        }
    }];
    [self.scrollView addSubview:self.tvSearchUser];
}

-(void)setViewCircleKeyword:(NSString *)key
{
    [self.tvSearchContent setViewKeyword:key];
    [self.tvSearchUser setViewKeyword:key];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewTool setFrame:CGRectMake(0, 0, self.width, [ZSwitchToolView getViewH])];
    
    [self.scrollView setFrame:CGRectMake(0, 40, self.width, self.height-self.viewTool.height)];
    [self.scrollView setContentSize:CGSizeMake(self.width*2, self.scrollView.height)];
    
    [self.tvSearchContent setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    [self.tvSearchUser setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
}
-(void)dealloc
{
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_onTagClick);
    OBJC_RELEASE(_onOffsetChange);
    OBJC_RELEASE(_onUserItemClick);
    OBJC_RELEASE(_onContentItemClick);
    OBJC_RELEASE(_onRefreshUserFooter);
    OBJC_RELEASE(_onRefreshContentFooter);
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvSearchUser);
    OBJC_RELEASE(_tvSearchContent);
}
///设置搜索内容
-(void)setViewCircleContentWithDictionary:(NSDictionary *)dic
{
   [self.tvSearchContent setViewDataWithDictionary:dic];
}
///设置搜索用户
-(void)setViewCircleUserWithDictionary:(NSDictionary *)dic
{
    [self.tvSearchUser setViewDataWithDictionary:dic];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self.viewTool setViewSelectItemWithType:(_offsetIndex+1)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onOffsetChange) {
        self.onOffsetChange(scrollView.contentOffset.x);
    }
    [self.viewTool setOffsetChange:scrollView.contentOffset.x];
}

@end
