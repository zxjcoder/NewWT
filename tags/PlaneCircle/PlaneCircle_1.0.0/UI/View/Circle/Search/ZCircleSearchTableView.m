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

@interface ZCircleSearchTableView()<UIScrollViewDelegate>
{
    NSInteger _offsetIndex;
}
@property (strong, nonatomic) UIButton *btnContent;
@property (strong, nonatomic) UIButton *btnUser;
@property (strong, nonatomic) UIView *viewLine;
@property (strong, nonatomic) UIView *viewLine1;

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

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.btnContent = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnContent setTitle:@"问答" forState:(UIControlStateNormal)];
    [self.btnContent setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnContent setTag:1];
    [[self.btnContent titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnContent addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnContent];
    
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
    self.tvSearchContent = [[ZCircleSearchContentTableView alloc] init];
    [self.tvSearchContent setOnRowSelected:^(ModelCircleSearchContent *model) {
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
    [self.scrollView addSubview:self.tvSearchContent];
    
    self.tvSearchUser = [[ZCircleSearchUserTableView alloc] init];
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
    [self.scrollView addSubview:self.tvSearchUser];
}

-(void)setViewKeyword:(NSString *)key
{
    [self.tvSearchContent setViewKeyword:key];
    [self.tvSearchUser setViewKeyword:key];
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
            __weak typeof(self) ws = self;
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [ws.btnContent setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                [ws.btnUser setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }];
            break;
        }
        case 1:
        {
            __weak typeof(self) ws = self;
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [ws.btnContent setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnUser setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
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
    [self.btnContent setFrame:CGRectMake(0, 0, self.width/2, btnH)];
    [self.btnUser setFrame:CGRectMake(self.width/2, 0, self.width/2, btnH)];
    [self.viewLine setFrame:CGRectMake(self.width/2*_offsetIndex, 38, self.width/2, 2)];
    [self.viewLine1 setFrame:CGRectMake(0, 39.5, self.width, 0.8)];
    [self.scrollView setFrame:CGRectMake(0, 40, self.width, self.height-40)];
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
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_tvSearchUser);
    OBJC_RELEASE(_tvSearchContent);
    OBJC_RELEASE(_btnUser);
    OBJC_RELEASE(_btnContent);
}
///设置搜索内容
-(void)setViewContentWithDictionary:(NSDictionary *)dic
{
   [self.tvSearchContent setViewDataWithDictionary:dic];
}
///设置搜索用户
-(void)setViewUserWithDictionary:(NSDictionary *)dic
{
    [self.tvSearchUser setViewDataWithDictionary:dic];
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
