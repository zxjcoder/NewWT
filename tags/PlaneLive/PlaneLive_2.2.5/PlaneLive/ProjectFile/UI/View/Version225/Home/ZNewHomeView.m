//
//  ZNewHomeView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ZBaseTableView.h"
#import "ZView.h"
#import "ZHomeTooolView.h"
#import "ZScrollView.h"
#import "ZNewHomeRecommendView.h"
#import "ZNewHomeFreeView.h"
#import "ZNewHomeTinyView.h"
#import "ZNewHomeTrainView.h"
#import "ZNewHomeSeriesView.h"
#import "ZNewHomeLawView.h"
#import "ZNewHomeButtonView.h"

#define kNewHomeBannerViewHeight (APP_FRAME_WIDTH*0.48)

@interface ZNewHomeView()<UIScrollViewDelegate>

///主面板
@property (strong, nonatomic) ZScrollView *viewMain;
///顶部区域
@property (strong, nonatomic) ZView *viewHeader;
///广告栏
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
///工具栏
@property (strong, nonatomic) ZHomeTooolView *viewTool;
///每日推荐
@property (strong, nonatomic) ZNewHomeRecommendView *viewRecommend;
///免费专区
@property (strong, nonatomic) ZNewHomeFreeView *viewFree;
///热门培训
@property (strong, nonatomic) ZNewHomeTrainView *viewTrain;
///系列课
@property (strong, nonatomic) ZNewHomeSeriesView *viewSeries;
///微课
@property (strong, nonatomic) ZNewHomeTinyView *viewTiny;
///律所
@property (strong, nonatomic) ZNewHomeLawView *viewLaw;

///广告数据
@property (strong, nonatomic) NSArray *arrBanner;
///每日推荐
@property (strong, nonatomic) NSArray *arrRecommend;
///免费专区
@property (strong, nonatomic) NSArray *arrFree;
///律所
@property (strong, nonatomic) NSArray *arrLawFirm;
///热门培训
@property (strong, nonatomic) NSArray *arrS;
///系列课
@property (strong, nonatomic) NSArray *arrC;
///微课
@property (strong, nonatomic) NSArray *arrP;

@end

@implementation ZNewHomeView

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
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewMain = [[ZScrollView alloc] initWithFrame:self.bounds];
    [self.viewMain setBackgroundColor:CLEARCOLOR];
    [self.viewMain setDelegate:self];
    [self.viewMain setShowsVerticalScrollIndicator:false];
    [self.viewMain setShowsHorizontalScrollIndicator:false];
    [self addSubview:self.viewMain];
    
    CGFloat bannerHeight = kNewHomeBannerViewHeight;
    CGFloat toolHeight = 100;
    self.viewHeader = [[ZView alloc] init];
    [self.viewHeader setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewHeader];
    
    CGFloat bannerY = 0;
    self.cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, bannerY, self.width, bannerHeight)];
    [self.cycleScrollView setPlaceholderImage:[Utils resizedTransformtoSize:CGSizeMake(self.width, bannerHeight) image:[SkinManager getMaxImage]]];
    [self.cycleScrollView setShowPageControl:YES];
    [self.cycleScrollView setBannerImageViewContentMode:UIViewContentModeScaleAspectFill];
    [self.cycleScrollView setAutoScrollTimeInterval:kANIMATION_BANNER_TIME];
    [self.cycleScrollView setPageControlBottomOffset:10];
    [self.cycleScrollView setPageDotImage:[SkinManager getImageWithName:@"page_g"]];
    [self.cycleScrollView setCurrentPageDotImage:[SkinManager getImageWithName:@"page_w"]];
    [self.cycleScrollView setPageControlAliment:(SDCycleScrollViewPageContolAlimentCenter)];
    [self.cycleScrollView setPageControlStyle:(SDCycleScrollViewPageContolStyleAnimated)];
    //[self.cycleScrollView setCurrentPageDotColor:WHITECOLOR];
    //[self.cycleScrollView setPageDotColor:GRAYCOLOR];
    [self.viewHeader addSubview:self.cycleScrollView];
    
    CGFloat toolY = bannerY+bannerHeight-10;
    self.viewTool = [[ZHomeTooolView alloc] initWithFrame:CGRectMake(0, toolY, self.width, toolHeight)];
    [self.viewHeader addSubview:self.viewTool];
    [self.viewHeader setFrame:CGRectMake(0, 0, self.width, toolY+toolHeight)];
    [self.viewHeader sendSubviewToBack:self.cycleScrollView];
    
    CGFloat itemDefault = [ZNewHomeButtonView getH];
    self.viewRecommend = [[ZNewHomeRecommendView alloc] initWithFrame:(CGRectMake(0, self.viewTool.y+self.viewTool.height+5, self.viewMain.width, itemDefault))];
    [self.viewMain addSubview:self.viewRecommend];
    
    self.viewFree = [[ZNewHomeFreeView alloc] initWithFrame:(CGRectMake(0, self.viewRecommend.y+self.viewRecommend.height+5, self.viewMain.width, itemDefault))];
    [self.viewMain addSubview:self.viewFree];
    
    self.viewTrain = [[ZNewHomeTrainView alloc] initWithFrame:(CGRectMake(0, self.viewFree.y+self.viewFree.height+5, self.viewMain.width, itemDefault))];
    [self.viewMain addSubview:self.viewTrain];
    
    self.viewSeries = [[ZNewHomeSeriesView alloc] initWithFrame:(CGRectMake(0, self.viewTrain.y+self.viewTrain.height+5, self.viewMain.width, itemDefault))];
    [self.viewMain addSubview:self.viewSeries];
    
    self.viewTiny = [[ZNewHomeTinyView alloc] initWithFrame:(CGRectMake(0, self.viewSeries.y+self.viewSeries.height+5, self.viewMain.width, itemDefault))];
    [self.viewMain addSubview:self.viewTiny];
    
    self.viewLaw = [[ZNewHomeLawView alloc] initWithFrame:(CGRectMake(0, self.viewTiny.y+self.viewTiny.height+5, self.viewMain.width, itemDefault))];
    [self.viewMain addSubview:self.viewLaw];
    
    self.viewRecommend.hidden = true;
    self.viewFree.hidden = true;
    self.viewTrain.hidden = true;
    self.viewSeries.hidden = true;
    self.viewTiny.hidden = true;
    self.viewLaw.hidden = true;
    
    [self innerEvent];
}
-(void)innerEvent
{
    ZWEAKSELF
    [self.viewMain setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
    [self.cycleScrollView setClickItemOperationBlock:^(NSInteger currentIndex) {
        if (currentIndex < self.arrBanner.count) {
            if (weakSelf.onBannerClick) {
                weakSelf.onBannerClick([weakSelf.arrBanner objectAtIndex:currentIndex]);
            }
        }
    }];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        switch (index) {
            case 2:
                if (weakSelf.onAllCurriculumClick) {
                    weakSelf.onAllCurriculumClick();
                }
                break;
            case 3:
                if (weakSelf.onAllSubscribeClick) {
                    weakSelf.onAllSubscribeClick();
                }
                break;
            case 4:
                if (weakSelf.onAllLawFirmClick) {
                    weakSelf.onAllLawFirmClick();
                }
                break;
            default:
                if (weakSelf.onAllPracticeClick) {
                    weakSelf.onAllPracticeClick();
                }
                break;
        }
    }];
    [self.viewRecommend setOnPracticeClick:^(ModelPractice *model) {
        if (weakSelf.onPracticeClick) {
            weakSelf.onPracticeClick(@[model], 0);
        }
    }];
    [self.viewRecommend setOnSubscribeClick:^(ModelSubscribe *model) {
        if (weakSelf.onSubscribeClick) {
            weakSelf.onSubscribeClick(model);
        }
    }];
    [self.viewFree setOnPracticeClick:^(NSArray *array, NSInteger row) {
        if (weakSelf.onFreeItemClick) {
            weakSelf.onFreeItemClick(array, row);
        }
    }];
    [self.viewFree setOnMoreClick:^{
        if (weakSelf.onAllFreeClick) {
            weakSelf.onAllFreeClick();
        }
    }];
    [self.viewTrain setOnCourseClick:^(ModelSubscribe *model) {
        if (weakSelf.onSubscribeClick) {
            weakSelf.onSubscribeClick(model);
        }
    }];
    [self.viewTrain setOnMoreClick:^{
        if (weakSelf.onAllSubscribeClick) {
            weakSelf.onAllSubscribeClick();
        }
    }];
    [self.viewTrain setOnDescClick:^{
        if (weakSelf.onWhatSubscribeClick) {
            weakSelf.onWhatSubscribeClick();
        }
    }];
    [self.viewSeries setOnCourseClick:^(ModelSubscribe *model) {
        if (weakSelf.onCurriculumClick) {
            weakSelf.onCurriculumClick(model);
        }
    }];
    [self.viewSeries setOnMoreClick:^{
        if (weakSelf.onAllCurriculumClick) {
            weakSelf.onAllCurriculumClick();
        }
    }];
    [self.viewSeries setOnDescClick:^{
        if (weakSelf.onWhatCurriculumClick) {
            weakSelf.onWhatCurriculumClick();
        }
    }];
    [self.viewTiny setOnPracticeClick:^(NSArray *array, NSInteger row) {
        if (weakSelf.onPracticeClick) {
            weakSelf.onPracticeClick(array, row);
        }
    }];
    [self.viewTiny setOnMoreClick:^{
        if (weakSelf.onAllPracticeClick) {
            weakSelf.onAllPracticeClick();
        }
    }];
    [self.viewLaw setOnMoreClick:^{
        if (weakSelf.onAllLawFirmClick) {
            weakSelf.onAllLawFirmClick();
        }
    }];
    [self.viewLaw setOnLawFirmClick:^(ModelLawFirm *model) {
        if (weakSelf.onLawFirmClick) {
            weakSelf.onLawFirmClick(model);
        }
    }];
}
///设置首页数据
-(void)setViewData:(NSDictionary *)dicData
{
    NSDictionary *dicResult = [dicData objectForKey:kResultKey];
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        // 广告
        NSArray *arrayBanner = [dicResult objectForKey:@"resultBanner"];
        if (arrayBanner && [arrayBanner isKindOfClass:[NSArray class]] && arrayBanner.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *arrayImage = [NSMutableArray array];
            for (NSDictionary *dic in arrayBanner) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    ModelBanner *model = [[ModelBanner alloc] initWithCustom:dic];
                    [array addObject:model];
                    [arrayImage addObject:model.imageUrl];
                }
            }
            self.arrBanner = nil;
            if (array.count > 0) {
                self.arrBanner = [NSArray arrayWithArray:array];
            }
            [self.cycleScrollView setImageURLStringsGroup:arrayImage];
        }
        // 每日推荐
        NSDictionary *dicRecommend = [dicResult objectForKey:@"recommendCourse"];
        if (dicRecommend && [dicRecommend isKindOfClass:[NSDictionary class]]) {
            int type = [[dicRecommend objectForKey:@"type"] intValue];
            self.arrRecommend = nil;
            switch (type) {
                case 1://系列课
                {
                    NSArray *arrayRecommend = [dicRecommend objectForKey:@"seriesCourses"];
                    if (arrayRecommend && [arrayRecommend isKindOfClass:[NSArray class]] && arrayRecommend.count > 0) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (NSDictionary *dic in arrayRecommend) {
                            if ([dic isKindOfClass:[NSDictionary class]]) {
                                ModelSubscribe *model = [[ModelSubscribe alloc] initWithCustom:dic];
                                [array addObject:model];
                            }
                        }
                        self.arrRecommend = [NSArray arrayWithArray:array];
                    }
                    break;
                }
                case 2://培训课
                {
                    NSArray *arrayRecommend = [dicRecommend objectForKey:@"courses"];
                    if (arrayRecommend && [arrayRecommend isKindOfClass:[NSArray class]] && arrayRecommend.count > 0) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (NSDictionary *dic in arrayRecommend) {
                            if ([dic isKindOfClass:[NSDictionary class]]) {
                                ModelSubscribe *model = [[ModelSubscribe alloc] initWithCustom:dic];
                                [array addObject:model];
                            }
                        }
                        self.arrRecommend = [NSArray arrayWithArray:array];
                    }
                    break;
                }
                default: //实务
                {
                    NSArray *arrayRecommend = [dicRecommend objectForKey:@"speechs"];
                    if (arrayRecommend && [arrayRecommend isKindOfClass:[NSArray class]] && arrayRecommend.count > 0) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (NSDictionary *dic in arrayRecommend) {
                            if ([dic isKindOfClass:[NSDictionary class]]) {
                                ModelPractice *model = [[ModelPractice alloc] initWithCustom:dic];
                                [array addObject:model];
                            }
                        }
                        self.arrRecommend = [NSArray arrayWithArray:array];
                    }
                    break;
                }
            }
        }
        self.viewRecommend.hidden = self.arrRecommend.count==0;
        // 免费专区
        NSArray *arrayFree = [dicResult objectForKey:@"resultFreeSpeech"];
        if (arrayFree && [arrayFree isKindOfClass:[NSArray class]] && arrayFree.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in arrayFree) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    ModelPractice *model = [[ModelPractice alloc] initWithCustom:dic];
                    [array addObject:model];
                }
            }
            self.arrFree = nil;
            self.arrFree = [NSArray arrayWithArray:array];
        }
        self.viewFree.hidden = self.arrFree.count==0;
        // 热门培训
        NSArray *arrayC = [dicResult objectForKey:@"resultCurriculum"];
        if (arrayC && [arrayC isKindOfClass:[NSArray class]] && arrayC.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in arrayC) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    ModelSubscribe *model = [[ModelSubscribe alloc] initWithCustom:dic];
                    [array addObject:model];
                }
            }
            self.arrC = nil;
            self.arrC = [NSArray arrayWithArray:array];
        }
        
        self.viewTrain.hidden = self.arrC.count==0;
        // 系列课
        NSArray *arrayS = [dicResult objectForKey:@"resultSeriesCourse"];
        if (arrayS && [arrayS isKindOfClass:[NSArray class]] && arrayS.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in arrayS) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    ModelSubscribe *model = [[ModelSubscribe alloc] initWithCustom:dic];
                    [array addObject:model];
                }
            }
            self.arrS = nil;
            self.arrS = [NSArray arrayWithArray:array];
        }
        
        self.viewSeries.hidden = self.arrS.count==0;
        // 微课
        NSArray *arrayP = [dicResult objectForKey:@"resultSpeech"];
        if (arrayP && [arrayP isKindOfClass:[NSArray class]] && arrayP.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in arrayP) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    ModelPractice *model = [[ModelPractice alloc] initWithCustom:dic];
                    [array addObject:model];
                }
            }
            self.arrP = nil;
            self.arrP = [NSArray arrayWithArray:array];
        }
        
        self.viewTiny.hidden = self.arrP.count==0;
        // 律所
        NSArray *arrayLawFirm = [dicResult objectForKey:@"resultLawFirm"];
        if (arrayLawFirm && [arrayLawFirm isKindOfClass:[NSArray class]] && arrayLawFirm.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in arrayLawFirm) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    ModelLawFirm *model = [[ModelLawFirm alloc] initWithCustom:dic];
                    [array addObject:model];
                }
            }
            self.arrLawFirm = nil;
            self.arrLawFirm = [NSArray arrayWithArray:array];
        }
        self.viewLaw.hidden = self.arrLawFirm.count==0;
    }
    [self setViewFrame];
}
///设置视图坐标
-(void)setViewFrame
{
    CGFloat itemSpace = 5;
    CGFloat viewRecommendHeight = [self.viewRecommend setViewData:self.arrRecommend];
    if (self.arrRecommend.count==0) {
        viewRecommendHeight = 0;
        self.viewRecommend.frame = CGRectMake(self.viewRecommend.x, self.viewHeader.y+self.viewHeader.height, self.viewRecommend.width, viewRecommendHeight);
    } else {
        self.viewRecommend.frame = CGRectMake(self.viewRecommend.x, self.viewHeader.y+self.viewHeader.height+itemSpace, self.viewRecommend.width, viewRecommendHeight);
    }
    CGFloat viewFreeHeight = [self.viewFree setViewData:self.arrFree];
    if (self.arrFree.count==0) {
        viewFreeHeight = 0;
        self.viewFree.frame = CGRectMake(self.viewFree.x, self.viewRecommend.y+self.viewRecommend.height, self.viewFree.width, viewFreeHeight);
    } else {
        self.viewFree.frame = CGRectMake(self.viewFree.x, self.viewRecommend.y+self.viewRecommend.height+itemSpace, self.viewFree.width, viewFreeHeight);
    }
    CGFloat viewTrainHeight = [self.viewTrain setViewData:self.arrC];
    if (self.arrS.count==0) {
        viewTrainHeight = 0;
        self.viewTrain.frame = CGRectMake(self.viewTrain.x, self.viewFree.y+self.viewFree.height, self.viewTrain.width, viewTrainHeight);
    } else {
        self.viewTrain.frame = CGRectMake(self.viewTrain.x, self.viewFree.y+self.viewFree.height+itemSpace, self.viewTrain.width, viewTrainHeight);
    }
    CGFloat viewSeriesHeight = [self.viewSeries setViewData:self.arrS];
    if (self.arrS.count==0) {
        viewSeriesHeight = 0;
        self.viewSeries.frame = CGRectMake(self.viewSeries.x, self.viewTrain.y+self.viewTrain.height, self.viewSeries.width, viewSeriesHeight);
    } else {
        self.viewSeries.frame = CGRectMake(self.viewSeries.x, self.viewTrain.y+self.viewTrain.height+itemSpace, self.viewSeries.width, viewSeriesHeight);
    }
    CGFloat viewTinyHeight = [self.viewTiny setViewData:self.arrP];
    if (self.arrP.count==0) {
        viewTinyHeight = 0;
        self.viewTiny.frame = CGRectMake(self.viewTiny.x, self.viewSeries.y+self.viewSeries.height, self.viewTiny.width, viewTinyHeight);
    } else {
        self.viewTiny.frame = CGRectMake(self.viewTiny.x, self.viewSeries.y+self.viewSeries.height+itemSpace, self.viewTiny.width, viewTinyHeight);
    }
    CGFloat viewLawHeight = [self.viewLaw setViewData:self.arrLawFirm];
    if (self.arrLawFirm.count==0) {
        viewLawHeight = 0;
        self.viewLaw.frame = CGRectMake(self.viewLaw.x, self.viewTiny.y+self.viewTiny.height, self.viewLaw.width, viewLawHeight);
    } else {
        self.viewLaw.frame = CGRectMake(self.viewLaw.x, self.viewTiny.y+self.viewTiny.height+itemSpace, self.viewLaw.width, viewLawHeight);
    }
    CGFloat bottomHeight = 50;
    CGFloat contentHeight = self.viewLaw.y+self.viewLaw.height+bottomHeight;
    
    [self.viewMain setContentSize:(CGSizeMake(self.viewMain.width, contentHeight))];
}
///重置广告位置-放置轮播一半的情况
-(void)adjustWhenControllerViewWillAppera
{
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
}
///刷新顶部数据
-(void)endRefreshHeader
{
    [self.viewMain endRefreshHeader];
}
///设置播放对象
-(void)setPlayObject:(ModelTrack *)model isPlaying:(BOOL)isPlaying;
{
    [self.viewFree setPlayObject:model isPlaying:isPlaying];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewMain scrollViewDidScroll:scrollView];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.onContentOffsetClick) {
        self.onContentOffsetClick(offsetY, self.cycleScrollView.height);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.viewMain scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.viewMain scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.viewMain scrollViewDidEndScrollingAnimation:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.viewMain scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
