//
//  ZSubscribeAlreadyViewController.m
//  PlaneLive
//
//  Created by Daniel on 11/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyHasViewController.h"
#import "ZSubscribeAlreadyMainView.h"

#import "ZCurriculumDetailViewController.h"

@interface ZSubscribeAlreadyHasViewController ()

@property (strong, nonatomic) ZSubscribeAlreadyMainView *viewMain;

@property (strong, nonatomic) ModelCurriculum *model;

@property (strong, nonatomic) ZLabel *lbTitleNav;

@end

@implementation ZSubscribeAlreadyHasViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
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
    OBJC_RELEASE(_viewMain);
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
    self.viewMain = [[ZSubscribeAlreadyMainView alloc] initWithFrame:VIEW_MAIN_FRAME];
    [self.viewMain setOnEachWatchClick:^(ModelCurriculum *model) {
        ZCurriculumDetailViewController *itemVC = [[ZCurriculumDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.viewMain setOnContinuousSowingClick:^(NSArray *array, NSInteger row) {
        [weakSelf showPlayVCWithCurriculumArray:array index:row];
    }];
    [self.viewMain setOnRefreshEachWatchHeader:^{
        [weakSelf setRefreshEachWatchHeader];
    }];
    [self.viewMain setOnRefreshEachWatchFooter:^{
        [weakSelf setRefreshEachWatchFooter];
    }];
    [self.viewMain setOnRefreshContinuousSowingHeader:^{
        [weakSelf setRefreshContinuousSowingHeader];
    }];
    [self.viewMain setOnRefreshContinuousSowingFooter:^{
        [weakSelf setRefreshContinuousSowingFooter];
    }];
    [self.viewMain setOnContentOffsetY:^(CGFloat alpha) {
        [weakSelf.lbTitleNav setHidden:alpha==0];
        [weakSelf.lbTitleNav setAlpha:alpha];
        
        [weakSelf setNavBarAlpha:alpha];
    }];
    [self.view addSubview:self.viewMain];
    
    [super innerInit];
    
    [self setNavBarAlpha:0];
    
    self.lbTitleNav = [[ZLabel alloc] initWithFrame:CGRectMake(65, 0, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setTextColor:TITLECOLOR];
    [self.lbTitleNav setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    [self.lbTitleNav setHidden:YES];
    [self.lbTitleNav setAlpha:0];
    [self.lbTitleNav setText:self.model.title];
    
    [self.viewMain setViewDataWithModel:self.model];
    
    [self innerData];
}

-(void)innerData
{
    NSArray *arrayE = [sqlite getLocalCurriculumEachWatchArrayWithSubscribeId:self.model.subscribeId userId:[AppSetting getUserDetauleId]];
    if (arrayE && arrayE.count > 0) {
        [self.viewMain setViewDataWithEachWatchArray:arrayE isHeader:YES];
    } else {
        [self.viewMain setEachWatchBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    
    NSArray *arrayC = [sqlite getLocalCurriculumContinuousSowingArrayWithSubscribeId:self.model.subscribeId userId:[AppSetting getUserDetauleId]];
    if (arrayC && arrayC.count > 0) {
        [self.viewMain setViewDataWithContinuousSowingArray:arrayC isHeader:YES];
    } else {
        [self.viewMain setContinuousSowingBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    
    [self setRefreshEachWatchHeader];
    
    [self setRefreshContinuousSowingHeader];
}
///每期看
-(void)setRefreshEachWatchHeader
{
    ZWEAKSELF
    [DataOper200 getCurriculumArrayWithSubscribeId:self.model.subscribeId curriculumId:self.model.ids type:0 pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain setViewDataWithEachWatchArray:arrResult isHeader:YES];
        
        [sqlite setLocalCurriculumEachWatchWithArray:arrResult subscribeId:weakSelf.model.subscribeId userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithEachWatchArray:nil isHeader:YES];
    }];
}
///每期看
-(void)setRefreshEachWatchFooter
{
    ZWEAKSELF
    [DataOper200 getCurriculumArrayWithSubscribeId:self.model.subscribeId curriculumId:self.model.ids type:0 pageNum:weakSelf.viewMain.getPageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain setViewDataWithEachWatchArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithEachWatchArray:nil isHeader:NO];
    }];
}
///连续播
-(void)setRefreshContinuousSowingHeader
{
    ZWEAKSELF
    [DataOper200 getCurriculumArrayWithSubscribeId:self.model.subscribeId curriculumId:self.model.ids type:1 pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain setViewDataWithContinuousSowingArray:arrResult isHeader:YES];
        
        [sqlite setLocalCurriculumContinuousSowingWithArray:arrResult subscribeId:weakSelf.model.subscribeId userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithContinuousSowingArray:nil isHeader:YES];
    }];
}
///连续播
-(void)setRefreshContinuousSowingFooter
{
    ZWEAKSELF
    [DataOper200 getCurriculumArrayWithSubscribeId:self.model.subscribeId curriculumId:self.model.ids type:1 pageNum:weakSelf.viewMain.getPageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain setViewDataWithContinuousSowingArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithContinuousSowingArray:nil isHeader:NO];
    }];
}

-(void)setViewDataWithModel:(ModelCurriculum *)model
{
    [self setModel:model];
}

@end
