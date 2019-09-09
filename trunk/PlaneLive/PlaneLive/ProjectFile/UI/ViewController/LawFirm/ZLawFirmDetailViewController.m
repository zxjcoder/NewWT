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
#import "ZNewPracticeItemTVC.h"
#import "ZNewCoursesItemTVC.h"
#import "ZLawFirmPracticeViewController.h"
#import "ZLawFirmSubscribeViewController.h"
#import "ZLawFirmSeriesCourseViewController.h"
#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"
#import "ZNewLawFirmHeaderView.h"
#import "ZLawFirmDetailTVC.h"
#import "ZShowLawFirmInfoView.h"

///最多展现数量
#define kLawFirmItemMaxCount 4

@interface ZLawFirmDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) ZLawFirmDetailTVC *tvcDetail;

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

@property (strong, nonatomic) ModelLawFirm *model;
@property (strong, nonatomic) NSArray *arrPractice;
@property (strong, nonatomic) NSArray *arrSubscribe;
@property (strong, nonatomic) NSArray *arrSeriesCourse;
@property (strong, nonatomic) ZLabel *lbTitleNav;
@property (assign, nonatomic) CGRect tvFrame;

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
    if (self.isShowPlayerView) {
        CGRect tvFrame = self.tvFrame;
        tvFrame.size.height -= [ZGlobalPlayView getH];
        [self.tvMain setFrame:tvFrame];
    } else {
        [self.tvMain setFrame:self.tvFrame];
    }
    [self setRefreshHeader];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
    OBJC_RELEASE(_viewHeaderSubscribe);
    OBJC_RELEASE(_viewHeaderSeriesCourse);
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
    self.tvcDetail = [[ZLawFirmDetailTVC alloc] initWithReuseIdentifier:@"tvcDetail"];
    [self.tvcDetail setOnShowDetailEvent:^(ModelLawFirm *model) {
        ZShowLawFirmInfoView *showDetailView = [[ZShowLawFirmInfoView alloc] initWithModel:model];
        [showDetailView show];
    }];
    
    self.viewHeaderPractice = [[ZNewLawFirmHeaderView alloc] initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, [ZNewLawFirmHeaderView getH])) title:kLawFirmRecommendedPractice isMore:true];
    [self.viewHeaderPractice setOnMoreClick:^{
        ZLawFirmPracticeViewController *itemVC = [[ZLawFirmPracticeViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    
    self.viewHeaderSubscribe = [[ZNewLawFirmHeaderView alloc] initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, [ZNewLawFirmHeaderView getH])) title:kLawFirmRecommendedSubscribe isMore:true];
    [self.viewHeaderSubscribe setOnMoreClick:^{
        ZLawFirmSubscribeViewController *itemVC = [[ZLawFirmSubscribeViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    
    self.viewHeaderSeriesCourse = [[ZNewLawFirmHeaderView alloc] initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, [ZNewLawFirmHeaderView getH])) title:kLawFirmRecommendedSeriesCourse isMore:true];
    [self.viewHeaderSeriesCourse setOnMoreClick:^{
        ZLawFirmSeriesCourseViewController *itemVC = [[ZLawFirmSeriesCourseViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    
    self.viewSpaceHeaderDetail = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceHeaderPractice = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceHeaderSubscribe = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceHeaderSeriesCourse = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    
    self.viewSpaceFooterDetail = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceFooterPractice = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceFooterSubscribe = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewSpaceFooterSeriesCourse = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    
    self.tvFrame = VIEW_MAIN_FRAME;
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:self.tvFrame style:UITableViewStyleGrouped];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.view addSubview:self.tvMain];
    
    self.lbTitleNav = [[ZLabel alloc] initWithFrame:CGRectMake(65, 0, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.lbTitleNav setAlpha:0];
    [self.lbTitleNav setHidden:true];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setTextColor:COLORTEXT1];
    [self.lbTitleNav setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTitleNav setText:self.model.title];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    
    [self.tvcDetail setViewDataWithLawFirm:self.model];
    
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshHeader];
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
        [self.viewHeaderPractice setMoreHidden:self.arrPractice.count<kLawFirmItemMaxCount];
        
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
        [self.viewHeaderSubscribe setMoreHidden:self.arrSubscribe.count<kLawFirmItemMaxCount];
        
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
        [self.viewHeaderSeriesCourse setMoreHidden:self.arrSeriesCourse.count<kLawFirmItemMaxCount];
        [self.tvMain reloadData];
    }
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    NSString *localKey = [NSString stringWithFormat:@"kLawFirmDetailDataKey%@", self.model.ids];
    [snsV2 getLawFirmDetailWithLawFirmId:self.model.ids resultBlock:^(NSArray *resultPractice, NSArray *resultSubscribe, NSArray *resultSeriesCourse, NSDictionary *result) {
        weakSelf.arrPractice = resultPractice;
        [weakSelf.viewHeaderPractice setMoreHidden:weakSelf.arrPractice.count<kLawFirmItemMaxCount];
        weakSelf.arrSubscribe = resultSubscribe;
        [weakSelf.viewHeaderSubscribe setMoreHidden:weakSelf.arrSubscribe.count<kLawFirmItemMaxCount];
        weakSelf.arrSeriesCourse = resultSeriesCourse;
        [weakSelf.viewHeaderSeriesCourse setMoreHidden:weakSelf.arrSeriesCourse.count<kLawFirmItemMaxCount];
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
    [self.tvMain scrollViewDidScroll:scrollView];
    
    CGFloat alpha = scrollView.contentOffset.y/[self.tvcDetail getH];
    
    [self.lbTitleNav setAlpha:alpha];
    if (alpha>0.5) {
        [self.lbTitleNav setHidden:false];
        [self setBackButtonWithLeft];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [self.lbTitleNav setHidden:true];
        [self setBackButtonWithLeftWhite];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [self setNavBarAlpha:alpha];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tvMain scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.tvMain scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.tvMain scrollViewDidEndScrollingAnimation:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tvMain scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrPractice.count>kLawFirmItemMaxCount?kLawFirmItemMaxCount:self.arrPractice.count;
        case 2: return self.arrSubscribe.count>kLawFirmItemMaxCount?kLawFirmItemMaxCount:self.arrSubscribe.count;
        case 3: return self.arrSeriesCourse.count>kLawFirmItemMaxCount?kLawFirmItemMaxCount:self.arrSeriesCourse.count;
        case 4: return 0;
        default: break;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1: return [ZNewPracticeItemTVC getH];
        case 2: return [ZNewCoursesItemTVC getH];
        case 3: return [ZNewCoursesItemTVC getH];
        case 4: return 0;
        default: break;
    }
    return [self.tvcDetail getH];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrPractice.count>0?self.viewHeaderPractice.height:0.1;
        case 2: return self.arrSubscribe.count>0?self.viewHeaderSubscribe.height:0.1;
        case 3: return self.arrSeriesCourse.count>0?self.viewHeaderSeriesCourse.height:0.1;
        case 4: return [ZGlobalPlayView getH];
        default: break;
    }
    return self.viewSpaceHeaderDetail.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrPractice.count>0?self.viewHeaderPractice:self.viewSpaceHeaderPractice;
        case 2: return self.arrSubscribe.count>0?self.viewHeaderSubscribe:self.viewSpaceHeaderSubscribe;
        case 3: return self.arrSeriesCourse.count>0?self.viewHeaderSeriesCourse:self.viewSpaceHeaderSeriesCourse;
        case 4: return nil;
        default: break;
    }
    return self.viewSpaceHeaderDetail;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat minLineHeight = 0.1;
    CGFloat maxLineHeight = 1;
    switch (section) {
        case 1: return self.arrPractice.count>0?maxLineHeight:minLineHeight;
        case 2: return self.arrSubscribe.count>0?maxLineHeight:minLineHeight;
        case 3: return self.arrSeriesCourse.count>0?maxLineHeight:minLineHeight;
        default: break;
    }
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat minLineHeight = 0.1;
    CGFloat maxLineHeight = 1;
    switch (section) {
        case 1:
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
        case 3:
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
        case 4: return nil;
        default: break;
    }
    return self.viewSpaceFooterDetail;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            static NSString *cellSeriesCourseId = @"cellPracticeId";
            ZNewPracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellSeriesCourseId];
            if (!cell) {
                cell = [[ZNewPracticeItemTVC alloc] initWithReuseIdentifier:cellSeriesCourseId];
            }
            ModelPractice *model = [self.arrPractice objectAtIndex:indexPath.row];
            if (self.arrPractice.count < kLawFirmItemMaxCount) {
                [cell setHiddenLine:self.arrPractice.count==(indexPath.row+1)];
            } else {
                [cell setHiddenLine:kLawFirmItemMaxCount==(indexPath.row+1)];
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
            if (self.arrSubscribe.count < kLawFirmItemMaxCount) {
                [cell setHiddenLine:self.arrSubscribe.count==(indexPath.row+1)];
            } else {
                [cell setHiddenLine:kLawFirmItemMaxCount==(indexPath.row+1)];
            }
            [cell setCellDataWithModel:model];
            
            return cell;
        }
        case 3:
        {
            static NSString *cellSubscribeId = @"cellSeriesCourseId";
            ZNewCoursesItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellSubscribeId];
            if (!cell) {
                cell = [[ZNewCoursesItemTVC alloc] initWithReuseIdentifier:cellSubscribeId];
            }
            ModelSubscribe *model = [self.arrSeriesCourse objectAtIndex:indexPath.row];
            if (self.arrSeriesCourse.count < kLawFirmItemMaxCount) {
                [cell setHiddenLine:self.arrSeriesCourse.count==(indexPath.row+1)];
            } else {
                [cell setHiddenLine:kLawFirmItemMaxCount==(indexPath.row+1)];
            }
            [cell setCellDataWithModel:model];
            
            return cell;
        }
        default:break;
    }
    return self.tvcDetail;
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
        default:
        {
            break;
        }
    }
}

@end
