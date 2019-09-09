//
//  ZHomeTableView.m
//  PlaneLive
//
//  Created by Daniel on 28/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeTableView.h"
#import "ZHomeBannerView.h"
#import "ZHomePracticeTVC.h"
#import "ZHomeQuestionTVC.h"
#import "ZHomeSubscribeTVC.h"
#import "ZHomeCurriculumTVC.h"
#import "ZHomeTooolView.h"
#import "ZBaseTableView.h"
#import "ZScrollView.h"
#import "ZBackgroundView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "Utils.h"

@interface ZHomeTableView()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

///主面板
@property (strong, nonatomic) ZBaseTableView *tvMain;
///顶部区域
@property (strong, nonatomic) ZView *viewHeader;
///广告栏
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
///工具栏
@property (strong, nonatomic) ZHomeTooolView *viewTool;
///实务模块
@property (strong, nonatomic) ZHomePracticeTVC *tvcPractice;
///问答模块
@property (strong, nonatomic) ZHomeQuestionTVC *tvcQuestion;
///订阅模块
@property (strong, nonatomic) ZHomeSubscribeTVC *tvcSubscribe;
///课程模块
@property (strong, nonatomic) ZHomeCurriculumTVC *tvcCurriculum;
///广告数据
@property (strong, nonatomic) NSArray *arrBanner;
///表哥数据
@property (strong, nonatomic) NSArray *arrMain;

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
    
    self.tvcPractice = [[ZHomePracticeTVC alloc] initWithReuseIdentifier:@"tvcPractice"];
    self.tvcSubscribe = [[ZHomeSubscribeTVC alloc] initWithReuseIdentifier:@"tvcSubscribe"];
    self.tvcCurriculum = [[ZHomeCurriculumTVC alloc] initWithReuseIdentifier:@"tvcCurriculum"];
    self.tvcQuestion = [[ZHomeQuestionTVC alloc] initWithReuseIdentifier:@"tvcQuestion"];
    
    self.arrMain = @[self.tvcPractice, self.tvcSubscribe, self.tvcCurriculum, self.tvcQuestion];
    
    self.viewHeader = [[ZView alloc] init];
    [self.viewHeader setBackgroundColor:WHITECOLOR];
    
    CGFloat bannerHeight = kHomeBannerViewHeight;
    CGFloat bannerY = 0;
    self.cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, bannerY, self.width, bannerHeight)];
    [self.cycleScrollView setPlaceholderImage:[Utils resizedTransformtoSize:CGSizeMake(self.width, bannerHeight) image:[SkinManager getMaxImage]]];
    [self.cycleScrollView setShowPageControl:YES];
    [self.cycleScrollView setAutoScrollTimeInterval:kANIMATION_BANNER_TIME];
    [self.cycleScrollView setPageControlStyle:(SDCycleScrollViewPageContolStyleClassic)];
    [self.cycleScrollView setPageControlAliment:(SDCycleScrollViewPageContolAlimentCenter)];
    [self.cycleScrollView setCurrentPageDotColor:WHITECOLOR];
    [self.cycleScrollView setPageDotColor:GRAYCOLOR];
    [self.viewHeader addSubview:self.cycleScrollView];
    
    CGFloat toolHeight = 110;
    CGFloat toolY = bannerY+bannerHeight;
    self.viewTool = [[ZHomeTooolView alloc] initWithFrame:CGRectMake(0, toolY, self.width, toolHeight)];
    [self.viewHeader addSubview:self.viewTool];
    [self.viewHeader setFrame:CGRectMake(0, 0, self.width, toolY+toolHeight)];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:self.bounds];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setUserInteractionEnabled:YES];
    [self.tvMain setBackgroundColor:CLEARCOLOR];
    [self.tvMain setScrollsToTop:YES];
    [self.tvMain setTableHeaderView:self.viewHeader];
    [self.tvMain setSectionHeaderHeight:self.viewHeader.height];
    [self addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
    [self.cycleScrollView setClickItemOperationBlock:^(NSInteger index) {
        if (weakSelf.arrBanner.count > index) {
            if (weakSelf.onBannerClick) {
                weakSelf.onBannerClick([weakSelf.arrBanner objectAtIndex:index]);
            }
        }
    }];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        if (weakSelf.onToolItemClick) {
            weakSelf.onToolItemClick(index);
        }
    }];
    [self.tvcPractice setOnAllClick:^{
        if (weakSelf.onAllPracticeClick) {
            weakSelf.onAllPracticeClick();
        }
    }];
    [self.tvcPractice setOnPracticeClick:^(NSArray *array, NSInteger index) {
        if (weakSelf.onPracticeClick) {
            weakSelf.onPracticeClick(array, index);
        }
    }];
    [self.tvcSubscribe setOnAllSubscribeClick:^{
        if (weakSelf.onAllSubscribeClick) {
            weakSelf.onAllSubscribeClick();
        }
    }];
    [self.tvcSubscribe setOnSubscribeClick:^(ModelSubscribe *model) {
        if (weakSelf.onSubscribeClick) {
            weakSelf.onSubscribeClick(model);
        }
    }];
    [self.tvcCurriculum setOnAllCurriculumClick:^{
        if (weakSelf.onAllCurriculumClick) {
            weakSelf.onAllCurriculumClick();
        }
    }];
    [self.tvcCurriculum setOnCurriculumClick:^(ModelSubscribe *model) {
        if (weakSelf.onCurriculumClick) {
            weakSelf.onCurriculumClick(model);
        }
    }];
    [self.tvcQuestion setOnAllQuestionClick:^{
        if (weakSelf.onAllQuestionClick) {
            weakSelf.onAllQuestionClick();
        }
    }];
    [self.tvcQuestion setOnQuestionClick:^(ModelQuestionBoutique *model) {
        if (weakSelf.onQuestionClick) {
            weakSelf.onQuestionClick(model);
        }
    }];
    [self.tvcQuestion setOnChangeRowHeight:^(CGFloat rowH) {
        GCDMainBlock(^{
            [weakSelf.tvMain reloadData];
        });
    }];
    [self.tvcSubscribe setOnDescClick:^{
        if (weakSelf.onWhatSubscribeClick) {
            weakSelf.onWhatSubscribeClick();
        }
    }];
    [self.tvcCurriculum setOnDescClick:^{
        if (weakSelf.onWhatCurriculumClick) {
            weakSelf.onWhatCurriculumClick();
        }
    }];
}
-(void)adjustWhenControllerViewWillAppera
{
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
}
-(void)endRefreshHeader
{
    [self.tvMain endRefreshHeader];
}
-(void)dealloc
{
    self.cycleScrollView.delegate = nil;
    self.tvMain.dataSource = nil;
    self.tvMain.delegate = nil;
    OBJC_RELEASE(_cycleScrollView);
    OBJC_RELEASE(_tvcPractice);
    OBJC_RELEASE(_tvcQuestion);
    OBJC_RELEASE(_tvcSubscribe);
    OBJC_RELEASE(_tvcCurriculum);
    
    OBJC_RELEASE(_arrBanner);
    OBJC_RELEASE(_arrMain);
    
    OBJC_RELEASE(_onRefreshHeader);
    OBJC_RELEASE(_onBannerClick);
    OBJC_RELEASE(_onPracticeClick);
    OBJC_RELEASE(_onSubscribeClick);
    OBJC_RELEASE(_onCurriculumClick);
    OBJC_RELEASE(_onAllPracticeClick);
    OBJC_RELEASE(_onAllQuestionClick);
    OBJC_RELEASE(_onAllCurriculumClick);
    OBJC_RELEASE(_onContentOffsetClick);
    OBJC_RELEASE(_tvMain);
}

///设置首页数据
-(void)setViewDataWithBannerArray:(NSArray *)arrBanner
                    arrayPractice:(NSArray *)arrayPractice
                      arrQuestion:(NSArray *)arrQuestion
                     arrSubscribe:(NSArray *)arrSubscribe
                    arrCurriculum:(NSArray *)arrCurriculum
{
    if (arrBanner && arrBanner.count > 0) {
        self.arrBanner = [NSArray arrayWithArray:arrBanner];
    }
    NSMutableArray *bannerArr = [NSMutableArray arrayWithCapacity:arrBanner.count];
    for (ModelBanner *banner in arrBanner) {
        [bannerArr addObject:banner.imageUrl];
    }
    [self.cycleScrollView setImageURLStringsGroup:bannerArr];
    
    [self.tvcPractice setViewDataWithArray:arrayPractice];
    [self.tvcSubscribe setViewDataWithArray:arrSubscribe];
    [self.tvcCurriculum setViewDataWithArray:arrCurriculum];
    [self.tvcQuestion setViewDataWithArray:arrQuestion];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(ZBaseTVC*)[self.arrMain objectAtIndex:indexPath.row] getH];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrMain objectAtIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (self.onContentOffsetClick) {
        self.onContentOffsetClick(offsetY, self.cycleScrollView.height);
    }
}

@end
