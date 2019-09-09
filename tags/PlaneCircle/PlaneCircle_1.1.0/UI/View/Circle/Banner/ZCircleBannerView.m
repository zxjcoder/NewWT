//
//  ZCircleBannerView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleBannerView.h"
#import "ZImageView.h"
#import "ClassCategory.h"

#define kZBannerViewImageStartTag 100

@interface ZCircleBannerView()<UIScrollViewDelegate>
{
    ///计时器
    NSTimer *_timer;
    ///当前索引
    NSInteger _timerIndex;
    ///分页索引
    NSInteger _currentPage;
}

///滚动视图
@property (strong, nonatomic) UIScrollView *scrollView;
///分页显示
@property (strong, nonatomic) UIPageControl *pageControl;
///数据源
@property (strong, nonatomic) NSMutableArray *svArray;

@end

@implementation ZCircleBannerView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)dealloc
{
    OBJC_RELEASE_TIMER(_timer);
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_pageControl);
    OBJC_RELEASE(_svArray);
    OBJC_RELEASE(_onBannerClick);
}

-(void)innerInit
{
    self.svArray = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setBounces:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setBackgroundColor:WHITECOLOR];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] init];
    [self.pageControl setUserInteractionEnabled:NO];
    [self.pageControl setCurrentPageIndicatorTintColor:WHITECOLOR];
    [self.pageControl setPageIndicatorTintColor:DESCCOLOR];
    [self addSubview:self.pageControl];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
    
    [self setViewContent];
}

-(void)setViewDataWithArray:(NSArray*)array
{
    @synchronized (self) {
        [self.svArray removeAllObjects];
        if (array && [array isKindOfClass:[NSArray class]]) {
            if (array.count > 1) {
                [self.svArray addObject:[array lastObject]];
            }
            [self.svArray addObjectsFromArray:array];
            if (array.count > 1) {
                [self.svArray addObject:[array firstObject]];
            }
        }
        [self setViewContent];
    }
}

-(void)setViewFrame
{
    [self.scrollView setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*self.svArray.count, self.scrollView.height)];
    [self.pageControl setFrame:CGRectMake(0, self.height-25, self.scrollView.width, 20)];
}

-(void)setViewContent
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    if (self.svArray.count>0) {
        CGFloat imageX = 0;
        CGFloat imageY = 0;
        NSInteger index = 0;
        for (ModelBanner *model in self.svArray) {
            ZImageView *imgBanner = [[ZImageView alloc] initWithFrame:CGRectMake(imageX, imageY, self.scrollView.width, self.scrollView.height)];
            [imgBanner setUserInteractionEnabled:YES];
            [imgBanner setTag:(kZBannerViewImageStartTag+index)];
            [imgBanner setMaxImageURLStr:model.imageUrl];
            [self.scrollView addSubview:imgBanner];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [imgBanner addGestureRecognizer:tapGesture];
            index++;
            imageX += APP_FRAME_WIDTH;
        }
    }
    [self setContentOffsetFrist];
    
    OBJC_RELEASE_TIMER(_timer);
    if (self.svArray.count > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kANIMATION_BANNER_TIME target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    }
}

-(void)setContentOffsetFrist
{
    _timerIndex = 1;
    _currentPage = 0;
    [self.pageControl setCurrentPage:_currentPage];
    [self.pageControl setNumberOfPages:self.svArray.count-2];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*_timerIndex, 0) animated:NO];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*self.svArray.count, self.scrollView.height)];
}

-(void)timerCallback
{
    if (_timerIndex == (self.svArray.count-2)) {//最后一条
        _currentPage = 0;
        _timerIndex = 0;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*_timerIndex, 0) animated:NO];
    } else {
        _currentPage++;
    }
    _timerIndex++;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*_timerIndex, 0) animated:YES];
    [self.pageControl setCurrentPage:_currentPage];
}

-(void)imageClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        ModelBanner *model = [self.svArray objectAtIndex:(sender.view.tag-kZBannerViewImageStartTag)];
        if (self.onBannerClick) {
            self.onBannerClick(model);
        }
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _timerIndex = (NSInteger)ceilf(scrollView.contentOffset.x / scrollView.width);
    _currentPage = _timerIndex-1;
    if (scrollView.contentOffset.x == 0) {///翻页到第一页
        _currentPage = (self.svArray.count-2);
        _timerIndex = (self.svArray.count-2);
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*_timerIndex, 0) animated:NO];
    } else if (_timerIndex == (self.svArray.count-1)) {///翻页到最后一页
        _currentPage = 0;
        _timerIndex = 1;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*_timerIndex, 0) animated:NO];
    }
    [self.pageControl setCurrentPage:_currentPage];
}

@end
