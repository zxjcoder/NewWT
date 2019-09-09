//
//  ZHomeSearchView.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeSearchView.h"
#import "ZSwitchToolView.h"
#import "ZPracticeTableView.h"
#import "ZSubscribeTableView.h"
#import "ZScrollView.h"
#import "StatisticsManager.h"
#import "ZNewLawFirmHeaderView.h"
#import "ZNewPracticeItemTVC.h"
#import "ZNewCoursesItemTVC.h"

#define kSearchViewAllItemCount 3

@interface ZHomeSearchView()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) NSInteger offsetIndex;

@property (strong, nonatomic) ZSwitchToolView *viewSwitchTool;
@property (strong, nonatomic) ZScrollView *scrollView;
@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) ZPracticeTableView *tvPractice;
@property (strong, nonatomic) ZSubscribeTableView *tvSubscribe;
@property (strong, nonatomic) ZSubscribeTableView *tvSeriesCourse;

/**全部区域**/
@property (strong, nonatomic) ZNewLawFirmHeaderView *viewHeaderPractice;
@property (strong, nonatomic) ZNewLawFirmHeaderView *viewHeaderSubscribe;
@property (strong, nonatomic) ZNewLawFirmHeaderView *viewHeaderSeriesCourse;

//无数据使用的空闲View
@property (strong, nonatomic) ZView *viewSpaceHeaderDetail;
@property (strong, nonatomic) ZView *viewSpaceHeaderPractice;
@property (strong, nonatomic) ZView *viewSpaceHeaderSubscribe;
@property (strong, nonatomic) ZView *viewSpaceHeaderSeriesCourse;

@property (strong, nonatomic) ZView *viewSpaceFooterDetail;
@property (strong, nonatomic) ZView *viewSpaceFooterPractice;
@property (strong, nonatomic) ZView *viewSpaceFooterSubscribe;
@property (strong, nonatomic) ZView *viewSpaceFooterSeriesCourse;

@property (strong, nonatomic) NSArray *arrPractice;
@property (strong, nonatomic) NSArray *arrSubscribe;
@property (strong, nonatomic) NSArray *arrSeriesCourse;

@end

@implementation ZHomeSearchView

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
    [self setBackgroundColor:WHITECOLOR];
    
    ZWEAKSELF
    self.viewSwitchTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemHomeSearch)];
    [self.viewSwitchTool setFrame:CGRectMake(0, 10, APP_FRAME_WIDTH, [ZSwitchToolView getViewH])];
    [self.viewSwitchTool setOnItemClick:^(NSInteger index) {
        [weakSelf setSCViewItemChange:index];
    }];
    [self addSubview:self.viewSwitchTool];
    
    CGFloat scViewY = self.viewSwitchTool.y+self.viewSwitchTool.height;
    CGFloat scViewH = self.height-scViewY;
    self.scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, scViewY, self.width, scViewH)];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*self.viewSwitchTool.getNItemCount, self.scrollView.height)];
    [self addSubview:self.scrollView];
    
    [self setInnerInitAll];
    
    self.tvPractice = [[ZPracticeTableView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.scrollView.height)];
    self.tvPractice.scrollsToTop = NO;
    [self.scrollView addSubview:self.tvPractice];
    
    self.tvSeriesCourse = [[ZSubscribeTableView alloc] initWithFrame:CGRectMake(self.width*2, 0, self.width, self.scrollView.height)];
    self.tvSeriesCourse.scrollsToTop = NO;
    [self.scrollView addSubview:self.tvSeriesCourse];
    
    self.tvSubscribe = [[ZSubscribeTableView alloc] initWithFrame:CGRectMake(self.width*3, 0, self.width, self.scrollView.height)];
    self.tvSubscribe.scrollsToTop = NO;
    [self.scrollView addSubview:self.tvSubscribe];
    
    [self.tvPractice setOnContentOffsetChange:^(CGFloat contentOffsetY) {
        if (weakSelf.onContentOffsetChange) {
            weakSelf.onContentOffsetChange(contentOffsetY);
        }
    }];
    [self.tvSubscribe setOnContentOffsetChange:^(CGFloat contentOffsetY) {
        if (weakSelf.onContentOffsetChange) {
            weakSelf.onContentOffsetChange(contentOffsetY);
        }
    }];
    [self.tvPractice setOnRefreshFooter:^{
        if (weakSelf.onPracticeRefreshFooter) {
            weakSelf.onPracticeRefreshFooter();
        }
    }];
    [self.tvPractice setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onPracticeBackgroundClick) {
            weakSelf.onPracticeBackgroundClick();
        }
    }];
    [self.tvPractice setOnRowSelected:^(NSArray *array, NSInteger row) {
        if (weakSelf.onPracticeClick) {
            weakSelf.onPracticeClick(array, row);
        }
    }];
    
    [self.tvSubscribe setOnRefreshFooter:^{
        if (weakSelf.onSubscribeRefreshFooter) {
            weakSelf.onSubscribeRefreshFooter();
        }
    }];
    [self.tvSubscribe setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onSubscribeBackgroundClick) {
            weakSelf.onSubscribeBackgroundClick();
        }
    }];
    [self.tvSubscribe setOnRowSelected:^(ModelSubscribe *model) {
        if (weakSelf.onSubscribeClick) {
            weakSelf.onSubscribeClick(model);
        }
    }];
    
    [self.tvSeriesCourse setOnRefreshFooter:^{
        if (weakSelf.onSeriesCourseRefreshFooter) {
            weakSelf.onSeriesCourseRefreshFooter();
        }
    }];
    [self.tvSeriesCourse setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onSeriesCourseBackgroundClick) {
            weakSelf.onSeriesCourseBackgroundClick();
        }
    }];
    [self.tvSeriesCourse setOnRowSelected:^(ModelSubscribe *model) {
        if (weakSelf.onSeriesCourseClick) {
            weakSelf.onSeriesCourseClick(model);
        }
    }];
}
-(void)dealloc
{
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_viewSwitchTool);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_tvPractice);
    OBJC_RELEASE(_tvSubscribe);
    OBJC_RELEASE(_tvSeriesCourse);
}
///设置View坐标
-(void)setViewFrame:(CGRect)frame
{
    [self setFrame:frame];
    
    CGRect svFrame = self.scrollView.frame;
    svFrame.size.height = frame.size.height-self.viewSwitchTool.height;
    [self.scrollView setFrame:svFrame];
    
    CGRect tvAllFrame = self.tvMain.frame;
    tvAllFrame.size.height = svFrame.size.height;
    [self.tvMain setFrame:tvAllFrame];
    
    CGRect tvPracticeFrame = self.tvPractice.frame;
    tvPracticeFrame.size.height = svFrame.size.height;
    [self.tvPractice setFrame:tvPracticeFrame];
    
    CGRect tvSubscribeFrame = self.tvSubscribe.frame;
    tvSubscribeFrame.size.height = svFrame.size.height;
    [self.tvSubscribe setFrame:tvSubscribeFrame];
    
    CGRect tvSeriesCourseFrame = self.tvSeriesCourse.frame;
    tvSeriesCourseFrame.size.height = svFrame.size.height;
    [self.tvSeriesCourse setFrame:tvSeriesCourseFrame];
}
-(void)setSCViewItemChange:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            self.tvMain.scrollsToTop = true;
            self.tvPractice.scrollsToTop = false;
            self.tvSeriesCourse.scrollsToTop = false;
            self.tvSubscribe.scrollsToTop = false;
            break;
        }
        case 2:
        {
            self.tvMain.scrollsToTop = false;
            self.tvPractice.scrollsToTop = true;
            self.tvSeriesCourse.scrollsToTop = false;
            self.tvSubscribe.scrollsToTop = false;
            break;
        }
        case 3:
        {
            self.tvMain.scrollsToTop = false;
            self.tvPractice.scrollsToTop = false;
            self.tvSeriesCourse.scrollsToTop = true;
            self.tvSubscribe.scrollsToTop = false;
            [StatisticsManager event:kHomepage_Search_EriesCourse];
            break;
        }
        case 4:
        {
            self.tvMain.scrollsToTop = false;
            self.tvPractice.scrollsToTop = false;
            self.tvSeriesCourse.scrollsToTop = false;
            self.tvSubscribe.scrollsToTop = true;
            [StatisticsManager event:kHomepage_Search_Training];
            break;
        }
        default:
            break;
    }
    self.offsetIndex = index - 1;
    [self.scrollView setContentOffset:CGPointMake(self.offsetIndex*self.scrollView.width, 0) animated:YES];
}
-(void)setInnerInitAll
{
    ZWEAKSELF
    self.viewHeaderPractice = [[ZNewLawFirmHeaderView alloc] initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, [ZNewLawFirmHeaderView getH])) title:kLawFirmRecommendedPractice isMore:true];
    [self.viewHeaderPractice setOnMoreClick:^{
        [weakSelf setSCViewItemChange:2];
        [weakSelf.viewSwitchTool setViewSelectItemWithType:(_offsetIndex+1)];
    }];
    self.viewHeaderSeriesCourse = [[ZNewLawFirmHeaderView alloc] initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, [ZNewLawFirmHeaderView getH])) title:kLawFirmRecommendedSeriesCourse isMore:true];
    [self.viewHeaderSeriesCourse setOnMoreClick:^{
        [weakSelf setSCViewItemChange:3];
        [weakSelf.viewSwitchTool setViewSelectItemWithType:(_offsetIndex+1)];
    }];
    self.viewHeaderSubscribe = [[ZNewLawFirmHeaderView alloc] initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, [ZNewLawFirmHeaderView getH])) title:kLawFirmRecommendedSubscribe isMore:true];
    [self.viewHeaderSubscribe setOnMoreClick:^{
        [weakSelf setSCViewItemChange:4];
        [weakSelf.viewSwitchTool setViewSelectItemWithType:(_offsetIndex+1)];
    }];
    [self.viewHeaderPractice setTitleText:@"微课"];
    [self.viewHeaderSeriesCourse setTitleText:@"系列课"];
    [self.viewHeaderSubscribe setTitleText:@"培训课"];
    
    self.viewSpaceHeaderDetail = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceHeaderPractice = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceHeaderSubscribe = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceHeaderSeriesCourse = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    
    self.viewSpaceFooterDetail = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceFooterPractice = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceFooterSubscribe = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceFooterSeriesCourse = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:(CGRectMake(0, 0, self.width, self.scrollView.height))];
    self.tvMain.scrollsToTop = NO;
    self.tvMain.delegate = self;
    self.tvMain.dataSource = self;
    [self.scrollView addSubview:self.tvMain];
}
///刷新全部
-(void)setReloadAll
{
    [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
    if (self.arrPractice.count == 0 && self.arrSubscribe.count == 0 && self.arrSeriesCourse.count == 0) {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateAllNoData)];
    }
    [self.viewHeaderPractice setMoreHidden:self.arrPractice.count<=kSearchViewAllItemCount];
    [self.viewHeaderSubscribe setMoreHidden:self.arrSubscribe.count<=kSearchViewAllItemCount];
    [self.viewHeaderSeriesCourse setMoreHidden:self.arrSeriesCourse.count<=kSearchViewAllItemCount];
    
    [self.tvMain reloadData];
}
///系列课结束底部刷新
-(void)endRefreshSeriesCourseFooter
{
    [self.tvSeriesCourse endRefreshFooter];
}
///订阅结束底部刷新
-(void)endRefreshSubscribeFooter
{
    [self.tvSubscribe endRefreshFooter];
}
///微课结束底部刷新
-(void)endRefreshPracticeFooter
{
    [self.tvPractice endRefreshFooter];
}
///设置微课加载中
-(void)setPracticeBackgroundLoading
{
    [self.tvPractice setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateLoading)];
}
///设置系列课加载中
-(void)setSeriesCourseBackgroundLoading
{
    [self.tvSeriesCourse setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateLoading)];
}
///设置订阅加载中
-(void)setSubscribeBackgroundLoading
{
    [self.tvSubscribe setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateLoading)];
}
///设置微课背景状态
-(void)setPracticeBackgroundFail
{
    [self.tvPractice setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateFail)];
}
///设置系列课背景状态
-(void)setSeriesCourseBackgroundFail
{
    [self.tvSeriesCourse setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateFail)];
}
///设置订阅背景状态
-(void)setSubscribeBackgroundFail
{
    [self.tvSubscribe setViewDataWithArray:nil isHeader:YES backState:(ZBackgroundStateFail)];
}
///设置系列课数据
-(void)setViewDataSeriesCourseWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (isHeader) {
        self.arrSeriesCourse = [NSArray arrayWithArray:arrResult];
        [self setReloadAll];
    }
    ZBackgroundState state = ZBackgroundStateNone;
    if (isHeader && arrResult.count == 0) {
        state = ZBackgroundStateNull;
    }
    [self.tvSeriesCourse setViewDataWithArray:arrResult isHeader:isHeader backState:state];
}
///设置订阅数据
-(void)setViewDataSubscribeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (isHeader) {
        self.arrSubscribe = [NSArray arrayWithArray:arrResult];
        [self setReloadAll];
    }
    ZBackgroundState state = ZBackgroundStateNone;
    if (isHeader && arrResult.count == 0) {
        state = ZBackgroundStateNull;
    }
    [self.tvSubscribe setViewDataWithArray:arrResult isHeader:isHeader backState:state];
}
///设置微课数据
-(void)setViewDataPracticeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (isHeader) {
        self.arrPractice = [NSArray arrayWithArray:arrResult];
        [self setReloadAll];
    }
    ZBackgroundState state = ZBackgroundStateNone;
    if (isHeader && arrResult.count == 0) {
        state = ZBackgroundStateNull;
    }
    [self.tvPractice setViewDataWithArray:arrResult isHeader:isHeader backState:state];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewSwitchTool setOffsetChange:scrollView.contentOffset.x];
    
    if (self.onContentOffsetChange) {
        self.onContentOffsetChange(scrollView.contentOffset.y);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    GBLog(@"scrollView.contentOffset.x: %lf", scrollView.contentOffset.x);
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    GBLog(@"_offsetIndex: %lf", _offsetIndex);
    [self.viewSwitchTool setViewSelectItemWithType:(_offsetIndex+1)];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.arrPractice.count>kSearchViewAllItemCount?kSearchViewAllItemCount:self.arrPractice.count;
        case 1: return self.arrSeriesCourse.count>kSearchViewAllItemCount?kSearchViewAllItemCount:self.arrSeriesCourse.count;
        case 2: return self.arrSubscribe.count>kSearchViewAllItemCount?kSearchViewAllItemCount:self.arrSubscribe.count;
        default: break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: return [ZNewPracticeItemTVC getH];
        case 1: return [ZNewCoursesItemTVC getH];
        case 2: return [ZNewCoursesItemTVC getH];
        default: break;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.arrPractice.count>0?self.viewHeaderPractice.height:0.1;
        case 1: return self.arrSeriesCourse.count>0?self.viewHeaderSeriesCourse.height:0.1;
        case 2: return self.arrSubscribe.count>0?self.viewHeaderSubscribe.height:0.1;
        default: break;
    }
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.arrPractice.count>0?self.viewHeaderPractice:self.viewSpaceHeaderPractice;
        case 1: return self.arrSeriesCourse.count>0?self.viewHeaderSeriesCourse:self.viewSpaceHeaderSeriesCourse;
        case 2: return self.arrSubscribe.count>0?self.viewHeaderSubscribe:self.viewSpaceHeaderSubscribe;
        default: break;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat minLineHeight = 0.1;
    CGFloat maxLineHeight = 1;
    switch (section) {
        case 0: return self.arrPractice.count>0?maxLineHeight:minLineHeight;
        case 1: return self.arrSeriesCourse.count>0?maxLineHeight:minLineHeight;
        case 2: return self.arrSubscribe.count>0?maxLineHeight:minLineHeight;
        default: break;
    }
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat minLineHeight = 0.1;
    CGFloat maxLineHeight = 1;
    switch (section) {
        case 0:
        {
            CGRect footerFrame = self.viewSpaceFooterPractice.frame;
            if (self.arrPractice.count>0) {
                footerFrame.size.height = maxLineHeight;
                self.viewSpaceFooterPractice.backgroundColor = TABLEVIEWCELL_TLINECOLOR;
            } else {
                footerFrame.size.height = minLineHeight;
                self.viewSpaceFooterPractice.backgroundColor = WHITECOLOR;
            }
            self.viewSpaceFooterPractice.frame = footerFrame;
            return self.viewSpaceFooterPractice;
        }
        case 1:
        {
            CGRect footerFrame = self.viewSpaceFooterSeriesCourse.frame;
            if (self.arrSeriesCourse.count>0) {
                footerFrame.size.height = maxLineHeight;
                self.viewSpaceFooterSeriesCourse.backgroundColor = TABLEVIEWCELL_TLINECOLOR;
            } else {
                footerFrame.size.height = minLineHeight;
                self.viewSpaceFooterSeriesCourse.backgroundColor = WHITECOLOR;
            }
            self.viewSpaceFooterSeriesCourse.frame = footerFrame;
            return self.viewSpaceFooterSeriesCourse;
        }
        case 2:
        {
            CGRect footerFrame = self.viewSpaceFooterSubscribe.frame;
            if (self.arrSubscribe.count>0) {
                footerFrame.size.height = maxLineHeight;
                self.viewSpaceFooterSubscribe.backgroundColor = TABLEVIEWCELL_TLINECOLOR;
            } else {
                footerFrame.size.height = minLineHeight;
                self.viewSpaceFooterSubscribe.backgroundColor = WHITECOLOR;
            }
            self.viewSpaceFooterSubscribe.frame = footerFrame;
            return self.viewSpaceFooterSubscribe;
        }
        default: break;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellSeriesCourseId = @"cellPracticeId";
            ZNewPracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellSeriesCourseId];
            if (!cell) {
                cell = [[ZNewPracticeItemTVC alloc] initWithReuseIdentifier:cellSeriesCourseId];
            }
            ModelPractice *model = [self.arrPractice objectAtIndex:indexPath.row];
            if (self.arrPractice.count < kSearchViewAllItemCount) {
                [cell setHiddenLine:self.arrPractice.count==(indexPath.row+1)];
            } else {
                [cell setHiddenLine:kSearchViewAllItemCount==(indexPath.row+1)];
            }
            [cell setCellDataWithModel:model];
            
            return cell;
        }
        case 1:
        {
            static NSString *cellSubscribeId = @"cellSeriesCourseId";
            ZNewCoursesItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellSubscribeId];
            if (!cell) {
                cell = [[ZNewCoursesItemTVC alloc] initWithReuseIdentifier:cellSubscribeId];
            }
            ModelSubscribe *model = [self.arrSeriesCourse objectAtIndex:indexPath.row];
            if (self.arrSeriesCourse.count < kSearchViewAllItemCount) {
                [cell setHiddenLine:self.arrSeriesCourse.count==(indexPath.row+1)];
            } else {
                [cell setHiddenLine:kSearchViewAllItemCount==(indexPath.row+1)];
            }
            [cell setCellDataWithModel:model];
            
            return cell;
        }
        case 2:
        {
            static NSString *cellPracticeId = @"cellSubscribeId";
            ZNewCoursesItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellPracticeId];
            if (!cell) {
                cell = [[ZNewCoursesItemTVC alloc] initWithReuseIdentifier:cellPracticeId];
            }
            ModelSubscribe *model = [self.arrSubscribe objectAtIndex:indexPath.row];
            if (self.arrSubscribe.count < kSearchViewAllItemCount) {
                [cell setHiddenLine:self.arrSubscribe.count==(indexPath.row+1)];
            } else {
                [cell setHiddenLine:kSearchViewAllItemCount==(indexPath.row+1)];
            }
            [cell setCellDataWithModel:model];
            
            return cell;
        }
        default:break;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (self.onPracticeClick) {
                self.onPracticeClick(self.arrPractice, indexPath.row);
            }
            break;
        }
        case 1:
        {
            if (self.onSeriesCourseClick) {
                ModelSubscribe *model = [self.arrSeriesCourse objectAtIndex:indexPath.row];
                self.onSeriesCourseClick(model);
            }
            break;
        }
        case 2:
        {
            if (self.onSubscribeClick) {
                ModelSubscribe *model = [self.arrSubscribe objectAtIndex:indexPath.row];
                self.onSubscribeClick(model);
            }
            break;
        }
        default: break;
    }
}

@end
