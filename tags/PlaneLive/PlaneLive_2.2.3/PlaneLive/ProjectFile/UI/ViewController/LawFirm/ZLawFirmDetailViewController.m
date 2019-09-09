//
//  ZLawFirmDetailViewController.m
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmDetailViewController.h"
#import "ZLawFirmDetailView.h"
#import "ZLawFirmDetailFooterView.h"
#import "ZLawFirmDetailHeaderView.h"
#import "ZPracticeItemTVC.h"
#import "ZSubscribeItemTVC.h"
#import "ZLawFirmPracticeViewController.h"
#import "ZLawFirmSubscribeViewController.h"
#import "ZLawFirmSeriesCourseViewController.h"
#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"

///最多展现数量
#define kLawFirmItemMaxCount 4

@interface ZLawFirmDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) ZTableView *tvMain;
@property (strong, nonatomic) ZLawFirmDetailView *viewDetail;

@property (strong, nonatomic) ZLawFirmDetailHeaderView *viewHeaderPractice;
@property (strong, nonatomic) ZLawFirmDetailHeaderView *viewHeaderSubscribe;
@property (strong, nonatomic) ZLawFirmDetailHeaderView *viewHeaderSeriesCourse;

@property (strong, nonatomic) ZLawFirmDetailFooterView *viewFooterPractice;
@property (strong, nonatomic) ZLawFirmDetailFooterView *viewFooterSubscribe;
@property (strong, nonatomic) ZLawFirmDetailFooterView *viewFooterSeriesCourse;

@property (strong, nonatomic) ZView *viewSpaceDetail;
@property (strong, nonatomic) ZView *viewSpaceHeaderPractice;
@property (strong, nonatomic) ZView *viewSpaceHeaderSubscribe;
@property (strong, nonatomic) ZView *viewSpaceHeaderSeriesCourse;
@property (strong, nonatomic) ZView *viewSpaceFooterPractice;
@property (strong, nonatomic) ZView *viewSpaceFooterSubscribe;
@property (strong, nonatomic) ZView *viewSpaceFooterSeriesCourse;

@property (strong, nonatomic) ModelLawFirm *model;
@property (strong, nonatomic) NSArray *arrPractice;
@property (strong, nonatomic) NSArray *arrSubscribe;
@property (strong, nonatomic) NSArray *arrSeriesCourse;
@property (strong, nonatomic) ZLabel *lbTitleNav;

@end

@implementation ZLawFirmDetailViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRefreshHeader];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_viewDetail);
    OBJC_RELEASE(_viewHeaderPractice);
    OBJC_RELEASE(_viewHeaderSubscribe);
    OBJC_RELEASE(_viewHeaderSeriesCourse);
    OBJC_RELEASE(_viewFooterPractice);
    OBJC_RELEASE(_viewFooterSubscribe);
    OBJC_RELEASE(_viewFooterSeriesCourse);
    OBJC_RELEASE(_viewSpaceDetail);
    OBJC_RELEASE(_viewSpaceHeaderPractice);
    OBJC_RELEASE(_viewSpaceHeaderSubscribe);
    OBJC_RELEASE(_viewSpaceHeaderSeriesCourse);
    OBJC_RELEASE(_viewSpaceFooterPractice);
    OBJC_RELEASE(_viewSpaceFooterSubscribe);
    OBJC_RELEASE(_viewSpaceFooterSeriesCourse);
    OBJC_RELEASE(_arrPractice);
    OBJC_RELEASE(_arrSubscribe);
    OBJC_RELEASE(_arrSeriesCourse);
    OBJC_RELEASE(_lbTitleNav);
    _tvMain.delegate = nil;
    _tvMain.dataSource = nil;
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.viewDetail = [[ZLawFirmDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    [self.viewDetail setOnViewHeightChange:^(CGFloat viewH) {
        [weakSelf.tvMain reloadData];
    }];
    
    self.viewHeaderPractice = [[ZLawFirmDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kZLawFirmDetailHeaderViewHeight) title:kLawFirmRecommendedPractice];
    self.viewFooterSubscribe = [[ZLawFirmDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kZLawFirmDetailHeaderViewHeight) title:kLawFirmRecommendedSubscribe];
    self.viewHeaderSeriesCourse = [[ZLawFirmDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kZLawFirmDetailHeaderViewHeight) title:kLawFirmRecommendedSeriesCourse];
    
    self.viewFooterPractice = [[ZLawFirmDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kZLawFirmDetailFooterViewHeight)];
    self.viewFooterSubscribe = [[ZLawFirmDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kZLawFirmDetailFooterViewHeight)];
    self.viewFooterSeriesCourse = [[ZLawFirmDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kZLawFirmDetailFooterViewHeight)];
    
    self.viewSpaceDetail = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.01)];
    self.viewSpaceHeaderPractice = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.01)];
    self.viewSpaceHeaderSubscribe = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.01)];
    self.viewSpaceHeaderSeriesCourse = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.01)];
    self.viewSpaceFooterPractice = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.01)];
    self.viewSpaceFooterSubscribe = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.01)];
    self.viewSpaceFooterSeriesCourse = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.01)];
    
    self.tvMain = [[ZTableView alloc] initWithFrame:VIEW_MAIN_FRAME style:UITableViewStyleGrouped];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.tvMain];
    
    self.lbTitleNav = [[ZLabel alloc] initWithFrame:CGRectMake(65, 0, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setTextColor:TITLECOLOR];
    [self.lbTitleNav setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTitleNav setHidden:YES];
    [self.lbTitleNav setAlpha:0];
    [self.lbTitleNav setText:self.model.title];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    
    [self.viewDetail setViewDataWithLawFirm:self.model];
    
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    [self.viewFooterPractice setOnAllClick:^{
        ZLawFirmPracticeViewController *itemVC = [[ZLawFirmPracticeViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.viewFooterSubscribe setOnAllClick:^{
        ZLawFirmSubscribeViewController *itemVC = [[ZLawFirmSubscribeViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.viewFooterSeriesCourse setOnAllClick:^{
        ZLawFirmSeriesCourseViewController *itemVC = [[ZLawFirmSeriesCourseViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    
    [self innerData];
    
    [super innerInit];
    [self setNavBarAlpha:0];
}
-(void)innerData
{
    NSString *localKey = [NSString stringWithFormat:@"kLawFirmDetailDataKey%@", self.model.ids];
    NSDictionary *dicResult = [sqlite getLocalCacheDataWithPathKay:localKey];
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *arrayPractice = nil;
        NSArray *arrayP = [dicResult objectForKey:@"resultSpeechList"];
        if (arrayP && [arrayP isKindOfClass:[NSArray class]] && arrayP.count > 0) {
            arrayPractice = [NSMutableArray array];
            for (NSDictionary *dic in arrayP) {
                ModelPractice *model = [[ModelPractice alloc] initWithCustom:dic];
                [arrayPractice addObject:model];
            }
        }
        self.arrPractice = arrayPractice;
        NSMutableArray *arraySubscribe = nil;
        NSArray *arrayS = [dicResult objectForKey:@"resultCurriculumList"];
        if (arrayS && [arrayS isKindOfClass:[NSArray class]] && arrayS.count > 0) {
            arraySubscribe = [NSMutableArray array];
            for (NSDictionary *dic in arrayS) {
                ModelSubscribe *model = [[ModelSubscribe alloc] initWithCustom:dic];
                [arraySubscribe addObject:model];
            }
        }
        self.arrSubscribe = arraySubscribe;
        NSMutableArray *arraySeriesCourse = nil;
        NSArray *arrayC = [dicResult objectForKey:@"resultSeriesCourseList"];
        if (arrayC && [arrayC isKindOfClass:[NSArray class]] && arrayC.count > 0) {
            arraySeriesCourse = [NSMutableArray array];
            for (NSDictionary *dic in arrayC) {
                ModelSubscribe *model = [[ModelSubscribe alloc] initWithCustom:dic];
                [arraySeriesCourse addObject:model];
            }
        }
        self.arrSeriesCourse = arraySeriesCourse;
        [self.tvMain reloadData];
    }
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    NSString *localKey = [NSString stringWithFormat:@"kLawFirmDetailDataKey%@", self.model.ids];
    [snsV2 getLawFirmDetailWithLawFirmId:self.model.ids resultBlock:^(NSArray *resultPractice, NSArray *resultSubscribe, NSArray *resultSeriesCourse, NSDictionary *result) {
        weakSelf.arrPractice = resultPractice;
        weakSelf.arrSubscribe = resultSubscribe;
        weakSelf.arrSeriesCourse = resultSeriesCourse;
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain reloadData];
        [sqlite setLocalCacheDataWithDictionary:result pathKay:localKey];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
    }];
}
-(void)setViewDataWithModel:(ModelLawFirm *)model
{
    [self setModel:model];
}
///显示订阅详情
-(void)showSubscribeDetailVCWithModel:(ModelSubscribe *)model
{
    if (!model.isSubscribe) {
        ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
        [itemVC setViewDataWithSubscribeModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = scrollView.contentOffset.y/self.viewDetail.height;
    [self.lbTitleNav setHidden:alpha<=0];
    [self.lbTitleNav setAlpha:alpha];
    [self setNavBarAlpha:alpha];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrPractice.count>kLawFirmItemMaxCount?kLawFirmItemMaxCount:self.arrPractice.count;
        case 2: return self.arrSubscribe.count>kLawFirmItemMaxCount?kLawFirmItemMaxCount:self.arrSubscribe.count;
        case 3: return self.arrSeriesCourse.count>kLawFirmItemMaxCount?kLawFirmItemMaxCount:self.arrSeriesCourse.count;
        default: break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1: return [ZPracticeItemTVC getH];
        case 2: return [ZSubscribeItemTVC getH];
        case 3: return [ZSubscribeItemTVC getH];
        default: break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrPractice.count>0?self.viewHeaderPractice.height:self.viewSpaceHeaderPractice.height;
        case 2: return self.arrSubscribe.count>0?self.viewHeaderSubscribe.height:self.viewSpaceHeaderSubscribe.height;
        case 3: return self.arrSeriesCourse.count>0?self.viewHeaderSeriesCourse.height:self.viewSpaceHeaderSeriesCourse.height;
        default: break;
    }
    return self.viewDetail.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrPractice.count>kLawFirmItemMaxCount?self.viewFooterPractice.height:self.viewSpaceFooterPractice.height;
        case 2: return self.arrSubscribe.count>kLawFirmItemMaxCount?self.viewFooterSubscribe.height:self.viewSpaceFooterSubscribe.height;
        case 3: return self.arrSeriesCourse.count>kLawFirmItemMaxCount?self.viewFooterSeriesCourse.height:self.viewSpaceFooterSeriesCourse.height;
        default: break;
    }
    return self.viewSpaceDetail.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrPractice.count>0?self.viewHeaderPractice:self.viewSpaceHeaderPractice;
        case 2: return self.arrSubscribe.count>0?self.viewHeaderSubscribe:self.viewSpaceHeaderSubscribe;
        case 3: return self.arrSeriesCourse.count>0?self.viewHeaderSeriesCourse:self.viewSpaceHeaderSeriesCourse;
        default: break;
    }
    return self.viewDetail;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrPractice.count>kLawFirmItemMaxCount?self.viewFooterPractice:self.viewSpaceFooterPractice;
        case 2: return self.arrSubscribe.count>kLawFirmItemMaxCount?self.viewFooterSubscribe:self.viewSpaceFooterSubscribe;
        case 3: return self.arrSeriesCourse.count>kLawFirmItemMaxCount?self.viewFooterSeriesCourse:self.viewSpaceFooterSeriesCourse;
        default: break;
    }
    return self.viewSpaceDetail;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            static NSString *cellPracticeId = @"cellPracticeId";
            ZPracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellPracticeId];
            if (!cell) {
                cell = [[ZPracticeItemTVC alloc] initWithReuseIdentifier:cellPracticeId];
            }
            ModelPractice *model = [self.arrPractice objectAtIndex:indexPath.row];
            [cell setCellDataWithModel:model];
            
            return cell;
        }
        case 2:
        {
            static NSString *cellSubscribeId = @"cellSubscribeId";
            ZSubscribeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellSubscribeId];
            if (!cell) {
                cell = [[ZSubscribeItemTVC alloc] initWithReuseIdentifier:cellSubscribeId];
            }
            ModelSubscribe *model = [self.arrSubscribe objectAtIndex:indexPath.row];
            [cell setCellDataWithModel:model];
            
            return cell;
        }
        case 3:
        {
            static NSString *cellSeriesCourseId = @"cellSeriesCourseId";
            ZSubscribeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellSeriesCourseId];
            if (!cell) {
                cell = [[ZSubscribeItemTVC alloc] initWithReuseIdentifier:cellSeriesCourseId];
            }
            ModelSubscribe *model = [self.arrSeriesCourse objectAtIndex:indexPath.row];
            [cell setCellDataWithModel:model];
            
            return cell;
        }
        default: break;
    }
    static NSString *cellid = @"cellDetailId";
    ZBaseTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZBaseTVC alloc] initWithReuseIdentifier:cellid];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            [self showPlayVCWithPracticeArray:self.arrPractice index:indexPath.row];
            break;
        }
        case 2:
        {
            ModelSubscribe *model = [self.arrSubscribe objectAtIndex:indexPath.row];
            [self showSubscribeDetailVCWithModel:model];
            break;
        }
        case 3:
        {
            ModelSubscribe *model = [self.arrSeriesCourse objectAtIndex:indexPath.row];
            [self showSubscribeDetailVCWithModel:model];
            break;
        }
        default: break;
    }
}

@end
