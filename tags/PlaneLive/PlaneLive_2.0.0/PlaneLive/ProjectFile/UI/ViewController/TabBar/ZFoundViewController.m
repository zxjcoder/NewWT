//
//  ZFoundViewController.m
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZFoundViewController.h"
#import "ZFoundTableView.h"
#import "ZFoundLastPlayView.h"
#import "ZPlayViewController.h"

@interface ZFoundViewController ()

///主视图
@property (strong, nonatomic) ZFoundTableView *tvMain;
///上次播放
@property (strong, nonatomic) ZFoundLastPlayView *viewLastPlay;
///导航栏标题
@property (strong, nonatomic) ZLabel *lbTitleNav;
///是否在获取中
@property (assign, nonatomic) BOOL isGeting;

@end

@implementation ZFoundViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayDataChange:) name:ZPlayChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerData];
    
    [self.viewLastPlay setPlayButtonIsAnimation:[[ZPlayViewController sharedSingleton] isStartPlaying]];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayChangeNotification object:nil];
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_viewLastPlay);
    OBJC_RELEASE(_lbTitleNav);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvMain = [[ZFoundTableView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_TABBAR_HEIGHT)];
    ZWEAKSELF
    [self.tvMain setOnPracticeTypeClick:^(ModelPracticeType *model) {
        if (!weakSelf.isGeting) {
            [weakSelf setIsGeting:YES];
            [DataOper200 getFoundPracticeArrayWithPracticeTypeId:model.ids pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
                [weakSelf setIsGeting:NO];
                if (weakSelf.isDisappear) {
                    if (arrResult.count > 0) {
                        [weakSelf showPlayVCWithFoundArray:arrResult index:0];
                    } else {
                        [ZProgressHUD showError:kNotFoundPlayRecord];
                    }
                }
            } errorBlock:^(NSString *msg) {
                [weakSelf setIsGeting:NO];
                if (!weakSelf.isDisappear) {
                    [ZProgressHUD showError:msg];
                }
            }];
        }
    }];
    [self.tvMain setOnUserLoginClick:^{
        if (![AppSetting getAutoLogin]) {
            [weakSelf showLoginVC];
        }
    }];
    [self.view addSubview:self.tvMain];
    
    self.viewLastPlay = [[ZFoundLastPlayView alloc] initWithPoint:CGPointMake(0, APP_FRAME_HEIGHT-APP_TABBAR_HEIGHT-kZFoundLastPlayViewHeight)];
    [self.viewLastPlay setOnLastPlayViewClick:^(ModelAudio *model) {
        [weakSelf setShowPlayVC];
    }];
    [self.viewLastPlay setHidden:YES];
    [self.view addSubview:self.viewLastPlay];
    
    [super innerInit];
    
    [self.view bringSubviewToFront:self.viewLastPlay];
    
    [self setNavBarAlpha:0];
    
    self.lbTitleNav = [[ZLabel alloc] initWithFrame:CGRectMake(65, 0, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setTextColor:TITLECOLOR];
    [self.lbTitleNav setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    [self.lbTitleNav setText:kFound];
    
    NSArray *arrPT = [sqlite getLocalFoundPracticeTypeArrayWithAll];
    if (arrPT && arrPT.count > 0) {
        [self.tvMain setViewDataWithArray:arrPT];
    }
}
-(void)innerData
{
    if ([AppSetting getAutoLogin]) {
        [self.tvMain setViewDataWithModel:[AppSetting getUserLogin]];
    } else {
        [self.tvMain setViewDataWithModel:nil];
    }
    ModelAudio *modelA = [sqlite getLocalAudioModelWithNewTopOne];
    if (modelA) {
        [self.viewLastPlay setHidden:NO];
        [self.viewLastPlay setViewDataWithModel:modelA];
    } else {
        [self.viewLastPlay setHidden:YES];
    }
    ZWEAKSELF
    [DataOper200 getFoundPracticeTypeWithResultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain setViewDataWithArray:arrResult];
        
        [sqlite setLocalFoundPracticeTypeWithArray:arrResult];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain setViewDataWithArray:nil];
    }];
}
///播放改改变
-(void)setPlayDataChange:(NSNotification *)sender
{
    GCDMainBlock(^{
        [self.viewLastPlay setViewDataWithModel:sender.object];
    });
}

@end
