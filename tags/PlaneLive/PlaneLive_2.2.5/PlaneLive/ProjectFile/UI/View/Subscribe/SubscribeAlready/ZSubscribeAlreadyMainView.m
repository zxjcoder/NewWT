//
//  ZSubscribeAlreadyMainView.m
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyMainView.h"
#import "ZScrollView.h"

#import "ZSubscribeEachWatchTableView.h"
#import "ZSubscribeContinuousSowingTableView.h"

#import "ZSubscribeAlreadyImageView.h"
#import "ZSwitchToolView.h"
#import "ZButton.h"
#import "ZSubscribeAlreadyDetailTableView.h"

@interface ZSubscribeAlreadyMainView()<UIScrollViewDelegate>

///主面板
@property (strong, nonatomic) ZScrollView *scrollView;
///订阅图片
@property (strong, nonatomic) ZSubscribeAlreadyImageView *viewImage;
///订阅详情介绍
@property (strong, nonatomic) ZSubscribeAlreadyDetailTableView *tvAlreadyDetail;
///功能按钮切换
@property (strong, nonatomic) ZSwitchToolView *viewTool;
///分割线
@property (strong, nonatomic) UIImageView *imageToolLine;
///每期看
@property (strong, nonatomic) ZSubscribeEachWatchTableView *tvEachWatch;
///连续播
@property (strong, nonatomic) ZSubscribeContinuousSowingTableView *tvContinuousSowing;
///隐藏详情
@property (strong, nonatomic) ZButton *btnDismiss;

///选中的项目 0 每期看 1 连续播
@property (assign, nonatomic) NSInteger itemIndex;
///内容初始化坐标
@property (assign, nonatomic) CGRect tvFrame;
///每期看高度
@property (assign, nonatomic) CGFloat tvEachWatchHeight;
///连续播高度
@property (assign, nonatomic) CGFloat tvContinuousSowingHeight;
///每期看分页
@property (assign, nonatomic) int tvEachWatchPageNum;
///连续播分页
@property (assign, nonatomic) int tvContinuousSowingPageNum;
///订阅详情坐标
@property (assign,  nonatomic) CGRect tvAlreadyDetailFrame;
///记录上次内容高度
@property (assign, nonatomic) CGSize lastContentSize;

@end

@implementation ZSubscribeAlreadyMainView

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
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self.scrollView removeFromSuperview];
    OBJC_RELEASE(_viewImage);
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvEachWatch);
    OBJC_RELEASE(_tvContinuousSowing);
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_tvAlreadyDetail);
    _imageToolLine = nil;
    
    self.scrollView = [[ZScrollView alloc] initWithFrame:self.bounds];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setBackgroundColor:WHITECOLOR];
    [self.scrollView setDelegate:self];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:YES];
    [self.scrollView setScrollsToTop:YES];
    [self addSubview:self.scrollView];
    
    [self setItemIndex:1];
    
    [self setTvEachWatchPageNum:1];
    [self setTvContinuousSowingPageNum:1];
    
    ZWEAKSELF
    self.viewImage = [[ZSubscribeAlreadyImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, [ZSubscribeAlreadyImageView getH])];
    [self.viewImage setOnShowSubscribeDetail:^(BOOL show) {
        [weakSelf btnShowClick];
    }];
    [self.scrollView addSubview:self.viewImage];
    
    self.tvAlreadyDetailFrame = CGRectMake(0, self.viewImage.height, self.width, 0);
    self.tvAlreadyDetail = [[ZSubscribeAlreadyDetailTableView alloc] initWithFrame:self.tvAlreadyDetailFrame];
    [self.scrollView addSubview:self.tvAlreadyDetail];
    
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemSubscribeAlready)];
    [self.viewTool setBackgroundColor:WHITECOLOR];
    [self.viewTool setFrame:CGRectMake(0, self.viewImage.y+self.viewImage.height, self.scrollView.width, [ZSwitchToolView getViewH])];
    [self.viewTool setOnItemClick:^(NSInteger selectIndex) {
        [weakSelf.viewTool setOffsetChange:weakSelf.scrollView.width*(selectIndex-1)];
        if (selectIndex != weakSelf.itemIndex) {
            [weakSelf setItemIndex:selectIndex];
            switch (selectIndex) {
                case 1:///每期看显示
                {
                    [weakSelf.tvEachWatch setHidden:NO];
                    [weakSelf.tvEachWatch setAlpha:0];
                    
                    CGRect tvEachWatchFrame = weakSelf.tvFrame;
                    tvEachWatchFrame.size.height = weakSelf.tvEachWatchHeight;
                    [weakSelf.tvEachWatch setFrame:tvEachWatchFrame];
                    [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.width, tvEachWatchFrame.origin.y+tvEachWatchFrame.size.height)];
                    
                    [UIView animateWithDuration:0.1f animations:^{
                        [weakSelf.tvEachWatch setAlpha:1];
                        [weakSelf.tvContinuousSowing setAlpha:0];
                    } completion:^(BOOL finished) {
                        [weakSelf.tvContinuousSowing setHidden:YES];
                    }];
                    break;
                }
                case 2:///连续播显示
                {
                    [weakSelf.tvContinuousSowing setHidden:NO];
                    [weakSelf.tvContinuousSowing setAlpha:0];
                    
                    CGRect tvContinuousSowingFrame = weakSelf.tvFrame;
                    tvContinuousSowingFrame.size.height = weakSelf.tvContinuousSowingHeight;
                    [weakSelf.tvContinuousSowing setFrame:tvContinuousSowingFrame];
                    [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.width, tvContinuousSowingFrame.origin.y+tvContinuousSowingFrame.size.height)];
                    
                    [UIView animateWithDuration:0.1f animations:^{
                        [weakSelf.tvEachWatch setAlpha:0];
                        [weakSelf.tvContinuousSowing setAlpha:1];
                    } completion:^(BOOL finished) {
                        [weakSelf.tvEachWatch setHidden:YES];
                    }];
                    break;
                }
                default: break;
            }
        }
    }];
    [self.scrollView addSubview:self.viewTool];
    
    self.imageToolLine = [UIImageView getDLineView];
    [self.imageToolLine setFrame:CGRectMake(20, self.viewTool.y+self.viewTool.height, self.scrollView.width-40, kLineHeight)];
    [self.scrollView addSubview:self.imageToolLine];
    
    CGFloat tvY = self.viewTool.y+self.viewTool.height;
    CGFloat tvDefaultH = self.height-tvY;
    self.tvFrame = CGRectMake(0, tvY, self.width, tvDefaultH);
    self.tvEachWatch = [[ZSubscribeEachWatchTableView alloc] initWithFrame:self.tvFrame];
    [self.tvEachWatch setScrollsToTop:NO];
    [self.scrollView addSubview:self.tvEachWatch];
    
    self.tvContinuousSowing = [[ZSubscribeContinuousSowingTableView alloc] initWithFrame:self.tvFrame];
    [self.tvContinuousSowing setScrollsToTop:NO];
    [self.tvContinuousSowing setHidden:YES];
    [self.tvContinuousSowing setAlpha:0];
    [self.scrollView addSubview:self.tvContinuousSowing];
    
    [self.tvEachWatch setOnCurriculumClick:^(ModelCurriculum *model) {
        if (weakSelf.onEachWatchClick) {
            weakSelf.onEachWatchClick(model);
        }
    }];
    [self.tvEachWatch setOnTableViewHeightChange:^(CGFloat height) {
        [weakSelf setTvEachWatchHeight:height];
        CGRect tvEachWatchFrame = weakSelf.tvFrame;
        tvEachWatchFrame.size.height = height;
        [weakSelf.tvEachWatch setFrame:tvEachWatchFrame];
        if (weakSelf.itemIndex == 1) {
            [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.width, tvEachWatchFrame.origin.y+tvEachWatchFrame.size.height)];
        }
    }];
    
    [self.tvContinuousSowing setOnCurriculumClick:^(NSArray *array, NSInteger row) {
        if (weakSelf.onContinuousSowingClick) {
            weakSelf.onContinuousSowingClick(array, row);
        }
    }];
    [self.tvContinuousSowing setOnTableViewHeightChange:^(CGFloat height) {
        [weakSelf setTvContinuousSowingHeight:height];
        CGRect tvContinuousSowingFrame = weakSelf.tvFrame;
        tvContinuousSowingFrame.size.height = height;
        [weakSelf.tvContinuousSowing setFrame:tvContinuousSowingFrame];
        if (weakSelf.itemIndex == 2) {
            [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.scrollView.width, tvContinuousSowingFrame.origin.y+tvContinuousSowingFrame.size.height)];
        }
    }];
    
    [self.scrollView setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.itemIndex == 1) {
            if (weakSelf.onRefreshEachWatchHeader) {
                weakSelf.onRefreshEachWatchHeader();
            }
        } else {
            if (weakSelf.onRefreshContinuousSowingHeader) {
                weakSelf.onRefreshContinuousSowingHeader();
            }
        }
    }];
    [self.scrollView bringSubviewToFront:self.tvAlreadyDetail];
    
    CGFloat btnSize = 40;
    self.btnDismiss = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDismiss setImage:[SkinManager getImageWithName:@"arrow_up"] forState:(UIControlStateNormal)];
    [self.btnDismiss setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnDismiss setFrame:CGRectMake(self.width-btnSize-20, self.height-btnSize-20, btnSize, btnSize)];
    [[self.btnDismiss layer] setMasksToBounds:true];
    [self.btnDismiss setBackgroundColor:COLORVIEWBACKCOLOR1];
    [[self.btnDismiss layer] setMasksToBounds:true];
    [self.btnDismiss setViewRound:btnSize/2 borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnDismiss setTag:1];
    [self.btnDismiss setAlpha:0];
    [self.btnDismiss setHidden:YES];
    [self.btnDismiss setUserInteractionEnabled:YES];
    [self.btnDismiss addTarget:self action:@selector(btnDismissClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnDismiss];
    
    [self bringSubviewToFront:self.btnDismiss];
}
-(void)btnShowClick
{
    if (self.btnDismiss.alpha == 1) {
        return;
    }
    if (self.onDetailInfoShowChange) {
        self.onDetailInfoShowChange(true);
    }
    [self btnShowWithAnimate:YES];
}
-(void)btnShowWithAnimate:(BOOL)animate
{
    [self.scrollView setBounces:NO];
    [self setLastContentSize:self.scrollView.contentSize];
    CGFloat tvAlreadyDetailHeight = [self.tvAlreadyDetail getTableViewHeight];
    CGRect tvAlreadyDetailFrame = self.tvAlreadyDetailFrame;
    tvAlreadyDetailFrame.size.height = tvAlreadyDetailHeight;
    CGFloat scContentH = self.viewImage.height+tvAlreadyDetailHeight;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width, scContentH)];
    if (animate) {
        [self.viewImage setDismissDetailButton];
        [self.btnDismiss setHidden:NO];
        [self.btnDismiss setAlpha:0];
        [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.btnDismiss setAlpha:1];
            [self.tvAlreadyDetail setFrame:tvAlreadyDetailFrame];
        } completion:nil];
    } else {
        [self.btnDismiss setHidden:NO];
        [self.btnDismiss setAlpha:0.8];
        [self.tvAlreadyDetail setFrame:tvAlreadyDetailFrame];
    }
}
-(void)btnDismissClick
{
    if (self.btnDismiss.alpha == 0) {
        return;
    }
    if (self.onDetailInfoShowChange) {
        self.onDetailInfoShowChange(false);
    }
    [self.scrollView setBounces:YES];
    [self.btnDismiss setHidden:NO];
    [self.btnDismiss setAlpha:0.8];
    [self.scrollView setContentSize:self.lastContentSize];
    [self.viewImage setShowDetailButton];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.btnDismiss setAlpha:0];
        [self.tvAlreadyDetail setFrame:self.tvAlreadyDetailFrame];
    } completion:^(BOOL finished) {
        [self.btnDismiss setHidden:YES];
    }];
}
/// 设置数据源
-(void)setViewDataWithModel:(ModelCurriculum *)model
{
    CGFloat imageHeight = [self.viewImage setViewDataWithModel:model];
    
    CGRect imageFrame = self.viewImage.frame;
    imageFrame.size.height = imageHeight;
    self.viewImage.frame = imageFrame;
    
    [self setViewFrame];
}
/// 设置数据源
-(void)setViewDataWithSubscribeModel:(ModelSubscribeDetail *)model
{
    [self.viewImage setShowDetailButton];
    
    [self.tvAlreadyDetail setViewDataWithModel:model];
}
/// 设置坐标
-(void)setViewFrame
{
    CGRect detailFrame = self.tvAlreadyDetailFrame;
    detailFrame.origin.y = self.viewImage.y+self.viewImage.height;
    
    self.tvAlreadyDetail.frame = detailFrame;
    self.tvAlreadyDetailFrame = detailFrame;
    
    CGRect toolFrame = self.viewTool.frame;
    toolFrame.origin.y =  self.viewImage.y+self.viewImage.height;
    self.viewTool.frame = toolFrame;
    
    CGRect toollineFrame = self.imageToolLine.frame;
    toollineFrame.origin.y = self.viewTool.y+self.viewTool.height;
    self.imageToolLine.frame = toollineFrame;
    
    CGRect tvFrame = self.tvFrame;
    tvFrame.origin.y =  self.imageToolLine.y+self.imageToolLine.height;
    tvFrame.size.height = self.height-tvFrame.origin.y;
    
    self.tvFrame = tvFrame;
    self.tvEachWatch.frame = tvFrame;
    self.tvContinuousSowing.frame = tvFrame;
    
    if (self.itemIndex == 1) {
        [self.viewTool setOffsetChange:0];
    } else {
        [self.viewTool setOffsetChange:self.scrollView.width];
    }
}
///设置每期看数据源
-(void)setViewDataWithEachWatchArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (isHeader) {
        [self.scrollView endRefreshHeader];
    } else {
        [self.scrollView endRefreshFooter];
    }
    [self.tvEachWatch setViewDataWithArray:arrResult isHeader:isHeader];
    if (isHeader) {
        self.tvEachWatchPageNum = 1;
    } else {
        self.tvEachWatchPageNum += 1;
    }
    [self.scrollView removeRefreshFooter];
    if (arrResult && arrResult.count >= kPAGE_MAXCOUNT) {
        ZWEAKSELF
        [self.scrollView setRefreshFooterWithEndBlock:^{
            if (weakSelf.itemIndex == 1) {
                if (weakSelf.onRefreshEachWatchFooter) {
                    weakSelf.onRefreshEachWatchFooter();
                }
            } else {
                if (weakSelf.onRefreshContinuousSowingFooter) {
                    weakSelf.onRefreshContinuousSowingFooter();
                }
            }
        }];
    }
}
///获取分页数量
-(int)getPageNum
{
    if (self.itemIndex == 1) {
        return self.tvEachWatchPageNum;
    }
    return self.tvContinuousSowingPageNum;
}
///设置每期看背景
-(void)setEachWatchBackgroundViewWithState:(ZBackgroundState)state
{
    [self.tvEachWatch setBackgroundViewWithState:state];
}
///设置连续播背景
-(void)setContinuousSowingBackgroundViewWithState:(ZBackgroundState)state
{
    [self.tvContinuousSowing setBackgroundViewWithState:state];
}
///设置连续播数据源
-(void)setViewDataWithContinuousSowingArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (isHeader) {
        [self.scrollView endRefreshHeader];
    } else {
        [self.scrollView endRefreshFooter];
    }
    [self.tvContinuousSowing setViewDataWithArray:arrResult isHeader:isHeader];
    if (isHeader) {
        self.tvContinuousSowingPageNum = 1;
    } else {
        self.tvContinuousSowingPageNum += 1;
    }
    [self.scrollView removeRefreshFooter];
    if (arrResult && arrResult.count >= kPAGE_MAXCOUNT) {
        ZWEAKSELF
        [self.scrollView setRefreshFooterWithEndBlock:^{
            if (weakSelf.itemIndex == 1) {
                if (weakSelf.onRefreshEachWatchFooter) {
                    weakSelf.onRefreshEachWatchFooter();
                }
            } else {
                if (weakSelf.onRefreshContinuousSowingFooter) {
                    weakSelf.onRefreshContinuousSowingFooter();
                }
            }
        }];
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_viewImage);
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvEachWatch);
    OBJC_RELEASE(_tvContinuousSowing);
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_tvAlreadyDetail);
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollView scrollViewDidScroll:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.onContentOffsetY) {
        CGFloat alpha = offsetY / (self.viewImage.height);
        if (alpha > 1) { alpha = 1; }
        else if (alpha < 0) { alpha = 0; }
        self.onContentOffsetY(alpha);
    }
    if (self.onShowToolOffsetY) {
        self.onShowToolOffsetY(offsetY, (self.tvFrame.origin.y-self.viewTool.height));
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollView scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.scrollView scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.scrollView scrollViewDidEndScrollingAnimation:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.scrollView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
