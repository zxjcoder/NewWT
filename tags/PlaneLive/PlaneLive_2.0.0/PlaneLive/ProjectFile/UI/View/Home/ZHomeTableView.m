//
//  ZHomeTableView.m
//  PlaneLive
//
//  Created by Daniel on 28/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeTableView.h"
#import "ZHomeBannerView.h"
#import "ZHomePracticeView.h"
#import "ZHomeQuestionView.h"
#import "ZHomeSubscribeView.h"

#import "ZScrollView.h"

@interface ZHomeTableView()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollMainView;
///顶部区域
@property (strong, nonatomic) ZHomeBannerView *viewBanner;
///实务模块
@property (strong, nonatomic) ZHomePracticeView *viewPractice;
///问答模块
@property (strong, nonatomic) ZHomeQuestionView *viewQuestion;
///订阅模块
@property (strong, nonatomic) ZHomeSubscribeView *viewSubscribe;
///广告数据
@property (weak, nonatomic) NSArray *arrBanner;

@end

@implementation ZHomeTableView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:CLEARCOLOR];
    
    self.scrollMainView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self.scrollMainView setBounces:YES];
    [self.scrollMainView setDelegate:self];
    [self.scrollMainView setScrollEnabled:YES];
    [self.scrollMainView setClipsToBounds:NO];
    [self.scrollMainView setUserInteractionEnabled:YES];
    [self.scrollMainView setBackgroundColor:CLEARCOLOR];
    [self.scrollMainView setShowsHorizontalScrollIndicator:NO];
    [self.scrollMainView setShowsVerticalScrollIndicator:NO];
    [self.scrollMainView setScrollsToTop:YES];
    [self addSubview:self.scrollMainView];
    
    self.viewBanner = [[ZHomeBannerView alloc] init];
    [self.scrollMainView addSubview:self.viewBanner];
    
    self.viewPractice = [[ZHomePracticeView alloc] initWithFrame:CGRectMake(0, self.viewBanner.y+self.viewBanner.height, self.width, kHomePracticeViewHeight)];
    [self.scrollMainView addSubview:self.viewPractice];
    
    self.viewQuestion = [[ZHomeQuestionView alloc] initWithFrame:CGRectMake(0, self.viewPractice.y+self.viewPractice.height, self.width, kHomeQuestionViewHeight)];
    [self.scrollMainView addSubview:self.viewQuestion];
    
    self.viewSubscribe = [[ZHomeSubscribeView alloc] initWithFrame:CGRectMake(0, self.viewQuestion.y+self.viewQuestion.height, self.width, 50)];
    [self.scrollMainView addSubview:self.viewSubscribe];
    
    ZWEAKSELF
    [self.scrollMainView setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
    [self.viewBanner setOnBannerClick:^(ModelBanner *model) {
        if (weakSelf.onBannerClick) {
            weakSelf.onBannerClick(model);
        }
    }];
    [self.viewPractice setOnAllClick:^{
        if (weakSelf.onAllPracticeClick) {
            weakSelf.onAllPracticeClick();
        }
    }];
    [self.viewPractice setOnPracticeClick:^(NSArray *array, NSInteger row) {
        if (weakSelf.onPracticeClick) {
            weakSelf.onPracticeClick(array, row);
        }
    }];
    [self.viewQuestion setOnQuestionClick:^(ModelQuestionBoutique *model) {
        if (weakSelf.onQuestionClick) {
            weakSelf.onQuestionClick(model);
        }
    }];
    [self.viewSubscribe setOnAllClick:^{
        if (weakSelf.onAllSubscribeClick) {
            weakSelf.onAllSubscribeClick();
        }
    }];
    [self.viewSubscribe setOnSubscribeClick:^(ModelSubscribe *model) {
        if (weakSelf.onSubscribeClick) {
            weakSelf.onSubscribeClick(model);
        }
    }];
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGRect subscribeFrame = self.viewSubscribe.frame;
    subscribeFrame.size.height = self.viewSubscribe.getViewHeight;
    [self.viewSubscribe setFrame:subscribeFrame];
    
    CGFloat contentHeight = self.viewSubscribe.y+self.viewSubscribe.height;
    [self.scrollMainView setContentSize:CGSizeMake(self.width, contentHeight)];
}

-(void)dealloc
{
    OBJC_RELEASE(_viewBanner);
    OBJC_RELEASE(_viewPractice);
    OBJC_RELEASE(_viewQuestion);
    OBJC_RELEASE(_viewSubscribe);
    
    OBJC_RELEASE(_arrBanner);
    
    OBJC_RELEASE(_onRefreshHeader);
    OBJC_RELEASE(_onBannerClick);
    OBJC_RELEASE(_onPracticeClick);
    OBJC_RELEASE(_onSubscribeClick);
    OBJC_RELEASE(_onAllPracticeClick);
    OBJC_RELEASE(_onAllQuestionClick);
    OBJC_RELEASE(_onAllSubscribeClick);
    OBJC_RELEASE(_onContentOffsetClick);
}

///设置首页数据
-(void)setViewDataWithBannerArray:(NSArray *)arrBanner
                    arrayPractice:(NSArray *)arrayPractice
                      arrQuestion:(NSArray *)arrQuestion
                     arrSubscribe:(NSArray *)arrSubscribe
{
    self.arrBanner = arrBanner;
    
    [self.viewBanner setViewDataWithArray:arrBanner];
    [self.viewPractice setViewDataWithArray:arrayPractice];
    [self.viewQuestion setViewDataWithArray:arrQuestion];
    [self.viewSubscribe setViewDataWithArray:arrSubscribe];
    
    [self setViewFrame];
    
    [self setNeedsDisplay];
}

///从新开始动画
-(void)setAnimateQuestion
{
    [self.viewQuestion setAnimateQuestion];
}

///结束刷新顶部
-(void)endRefreshHeader
{
    [self.scrollMainView endRefreshHeader];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (self.onContentOffsetClick) {
        self.onContentOffsetClick(offsetY, self.viewBanner.height);
    }
}

@end
