//
//  ZSubscribeAlreadyViewController.m
//  PlaneLive
//
//  Created by Daniel on 11/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyHasViewController.h"
#import "ZSubscribeAlreadyMainView.h"
#import "ZWebContentViewController.h"

@interface ZSubscribeAlreadyHasViewController ()

@property (strong, nonatomic) ZSubscribeAlreadyMainView *viewMain;

@property (strong, nonatomic) NSString *subscribeId;

@property (strong, nonatomic) ModelCurriculum *model;
@property (strong, nonatomic) ModelSubscribe *modelSubscribe;
@property (strong, nonatomic) ZLabel *lbTitleNav;

@end

@implementation ZSubscribeAlreadyHasViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightShareButtonOnly];
    
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageChargeCourseDetailKey];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageChargeCourseDetailKey dictionary:nil];
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
    OBJC_RELEASE(_lbTitleNav);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_subscribeId);
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
        [weakSelf showCurriculumDetailVC:model];
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
    
    [self setNavBarAlpha:0];
}

-(void)innerData
{
    NSArray *arrayE = [sqlite getLocalCurriculumEachWatchArrayWithSubscribeId:self.subscribeId userId:kLoginUserId];
    if (arrayE && arrayE.count > 0) {
        [self.viewMain setViewDataWithEachWatchArray:arrayE isHeader:YES];
    } else {
        [self.viewMain setEachWatchBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    
    NSArray *arrayC = [sqlite getLocalCurriculumContinuousSowingArrayWithSubscribeId:self.subscribeId userId:kLoginUserId];
    if (arrayC && arrayC.count > 0) {
        [self.viewMain setViewDataWithContinuousSowingArray:arrayC isHeader:YES];
    } else {
        [self.viewMain setContinuousSowingBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    ModelSubscribeDetail *modelSD = [sqlite getLocalSubscribeDetailWithUserId:kLoginUserId subscribeId:self.subscribeId];
    if (modelSD && modelSD.ids) {
        [self setModelSubscribe:modelSD];
        [self.viewMain setViewDataWithSubscribeModel:modelSD];
    }
    ZWEAKSELF
    [snsV2 getSubscribeRecommendArrayWithSubscribeId:self.subscribeId resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
        [weakSelf setModelSubscribe:model];
        [weakSelf.viewMain setViewDataWithSubscribeModel:model];
        [sqlite setLocalSubscribeDetailWithModel:model userId:kLoginUserId];
    } errorBlock:nil];
    
    [self setRefreshEachWatchHeader];
    
    [self setRefreshContinuousSowingHeader];
}
///显示已订阅Web详情
-(void)showCurriculumDetailVC:(ModelCurriculum *)model
{
    ZWebContentViewController *itemVC = [[ZWebContentViewController alloc] init];
    [itemVC setViewDataWithModel:model isCourse:NO];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///每期看
-(void)setRefreshEachWatchHeader
{
    ZWEAKSELF
    [snsV2 getCurriculumArrayWithSubscribeId:self.subscribeId type:0 pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain setViewDataWithEachWatchArray:arrResult isHeader:YES];
        
        [sqlite setLocalCurriculumEachWatchWithArray:arrResult subscribeId:weakSelf.subscribeId userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithEachWatchArray:nil isHeader:YES];
    }];
}
///每期看
-(void)setRefreshEachWatchFooter
{
    ZWEAKSELF
    [snsV2 getCurriculumArrayWithSubscribeId:self.subscribeId type:0 pageNum:weakSelf.viewMain.getPageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain setViewDataWithEachWatchArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithEachWatchArray:nil isHeader:NO];
    }];
}
///连续播
-(void)setRefreshContinuousSowingHeader
{
    ZWEAKSELF
    [snsV2 getCurriculumArrayWithSubscribeId:self.subscribeId type:1 pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain setViewDataWithContinuousSowingArray:arrResult isHeader:YES];
        
        [sqlite setLocalCurriculumContinuousSowingWithArray:arrResult subscribeId:weakSelf.subscribeId userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithContinuousSowingArray:nil isHeader:YES];
    }];
}
///连续播
-(void)setRefreshContinuousSowingFooter
{
    ZWEAKSELF
    [snsV2 getCurriculumArrayWithSubscribeId:self.subscribeId type:1 pageNum:weakSelf.viewMain.getPageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain setViewDataWithContinuousSowingArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain setViewDataWithContinuousSowingArray:nil isHeader:NO];
    }];
}

-(void)setViewDataWithModel:(ModelCurriculum *)model
{
    [self setSubscribeId:model.subscribeId];
    [self setModel:model];
}

-(void)setViewDataWithSubscribeModel:(ModelSubscribe *)model
{
    if (model.is_series_course == 0) {
        [StatisticsManager event: kTraining_ListItem dictionary:@{kObjectId: model.ids, kObjectTitle: model.title, kObjectUser: kUserDefaultId}];
    } else {
        [StatisticsManager event: kEriesCourse_ListItem dictionary:@{kObjectId: model.ids, kObjectTitle: model.title, kObjectUser: kUserDefaultId}];
    }
    [self setModelSubscribe:model];
    [self setSubscribeId:model.ids];
    
    ModelCurriculum *modelC = [[ModelCurriculum alloc] init];
    [modelC setSubscribeId:model.ids];
    [modelC setTitle:model.title];
    [modelC setCourse_picture:model.course_picture];
    [modelC setIllustration:model.illustration];
    [modelC setTeam_name:model.team_name];
    [modelC setTeam_intro:model.team_info];
    [modelC setPrice:model.price];
    
    [self setModel:modelC];
}
///分享按钮点击事件
-(void)btnShareClick
{
    if (self.model.is_series_course == 0) {
        [StatisticsManager event:kTraining_Detail_Share];
    } else {
        [StatisticsManager event:kEriesCourse_Detail_Share];
    }
    ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
    ZWEAKSELF
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                if (self.model.is_series_course == 0) {
                    [StatisticsManager event:kTraining_Detail_Share_Wechat];
                } else {
                    [StatisticsManager event:kEriesCourse_Detail_Share_Wechat];
                }
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                if (self.model.is_series_course == 0) {
                    [StatisticsManager event:kTraining_Detail_Share_WechatCircle];
                } else {
                    [StatisticsManager event:kEriesCourse_Detail_Share_WechatCircle];
                }
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                [weakSelf btnQZoneClick];
                break;
            default: break;
        }
    }];
    [shareView show];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelSubscribe.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelSubscribe.theme_intro;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.modelSubscribe.illustration];
    NSString *webUrl = kApp_SubscribeContentUrl(self.modelSubscribe.ids);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}

@end
