//
//  ZBaseViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "ZLoginViewController.h"
#import "ZWebViewController.h"
#import "ZReportView.h"
#import "ZReportViewController.h"
#import "ZAnswerDetailViewController.h"
#import "ZQuestionDetailViewController.h"
#import "ZUserProfileViewController.h"
#import "ZPracticePayViewController.h"
#import "ZHomeViewController.h"
#import "ZFoundViewController.h"
#import "ZUserInfoViewController.h"
#import "ZTabBarViewController.h"
#import "ZPhotoBrowser.h"
#import "GifManager.h"
#import "ZPlayerViewController.h"
#import "ZBeenPurchasedViewController.h"

#import "ZMyCollectionViewController.h"
#import "ZMessageListViewController.h"
#import "ZNoticeListViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"
#import "ZPracticeFreeViewController.h"
#import "ZPracticeListViewController.h"
#import "ZPracticeTypeViewController.h"
#import "ZWebContentViewController.h"
#import "ZSearchViewController.h"
#import "ZSearchResultViewController.h"
#import "ZCurriculumListViewController.h"
#import "ZSubscribeTypeViewController.h"
#import "ZLawFirmListViewController.h"
#import "ZLawFirmDetailViewController.h"
#import "ZLawFirmPracticeViewController.h"
#import "ZLawFirmSeriesCourseViewController.h"
#import "ZLawFirmSubscribeViewController.h"
#import "ZAccountBalanceViewController.h"
#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeProbationViewController.h"

@interface ZBaseViewController ()<UIScrollViewDelegate>
{
    ///导航栏背景
    UIView *_navBackView;
    ///最后一次导航栏背景透明度
    CGFloat _navBackAlpha;
}
/// 导航条ViewLine
@property (nonatomic, weak) UIView *navBarViewLine;
/// 数据模型
@property (strong, nonatomic) ModelEntity *model;

@end

@implementation ZBaseViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerBaseInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setIsDisappear:NO];
    [[AppDelegate app] setRefreshAppConfig];
    [StatisticsManager beginRecordPage:NSStringFromClass(self.class)];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:false];
    
    [self innerPlayInit];
    [self setPlayVCBlock];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self delPlayVCBlock];
    [self setIsDisappear:YES];
    [StatisticsManager endRecordPage:NSStringFromClass(self.class)];
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.view.y = 0;
    self.view.height = [[UIScreen mainScreen] bounds].size.height;
}

#pragma mark - PrivateMethod

-(void)innerBaseInit
{
    [self setIsShowPlayerView:false];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    if (@available(iOS 11.0, *)) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.viewRespectsSystemMinimumLayoutMargins = false;
        [self setExtendedLayoutIncludesOpaqueBars:false];
    } else {
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    [self.view setBackgroundColor:VIEW_BACKCOLOR1];
    
    if ([self isMemberOfClass:[ZHomeViewController class]] ||
        [self isMemberOfClass:[ZBeenPurchasedViewController class]] ||
        [self isMemberOfClass:[ZFoundViewController class]] ||
        [self isMemberOfClass:[ZUserInfoViewController class]] ||
        [self isMemberOfClass:[ZLoginViewController class]]) {
        [self.navigationItem setLeftBarButtonItem:nil];
    } else if ([self isMemberOfClass:[ZSearchViewController class]] ||
               [self isMemberOfClass:[ZSearchResultViewController class]] ||
               [self isMemberOfClass:[ZPlayerViewController class]]) {
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationItem setLeftBarButtonItem:nil];
    } else if ([self isMemberOfClass:[ZAccountBalanceViewController class]] ||
               [self isMemberOfClass:[ZLawFirmDetailViewController class]] ||
               [self isMemberOfClass:[ZSubscribeDetailViewController class]]) {
        [self setBackButtonWithLeftWhite];
    } else {
        [self setBackButtonWithLeft];
    }
}
-(void)innerPlayInit
{
    if ([AppDelegate app].isPlay) {
        NSString *playCloseView = [sqlite getSysParamWithKey:kSQLITE_CLOSE_PLAY_VIEW];
        if ([playCloseView boolValue]) {
            [self.viewPlay removeFromSuperview];
            self.viewPlay = nil;
            return;
        }
        /// 处理播放列表
        //[self setHistoryPlay];
        if (!self.viewPlay) {
            /// 处理页面
            if ([self isMemberOfClass:[ZHomeViewController class]] ||
                [self isMemberOfClass:[ZBeenPurchasedViewController class]] ||
                [self isMemberOfClass:[ZFoundViewController class]] ||
                [self isMemberOfClass:[ZUserInfoViewController class]]) {
                self.viewPlay = [[ZGlobalPlayView alloc] initWithFrame:(CGRectMake(0, APP_FRAME_HEIGHT-APP_TABBAR_HEIGHT-[ZGlobalPlayView getMinH], APP_FRAME_WIDTH, [ZGlobalPlayView getMinH]))];
                [self setIsShowPlayerView:true];
            } else if ([self isMemberOfClass:[ZMyCollectionViewController class]] ||
                       [self isMemberOfClass:[ZMessageListViewController class]] ||
                       [self isMemberOfClass:[ZNoticeListViewController class]] ||
                       [self isMemberOfClass:[ZSubscribeAlreadyHasViewController class]] ||
                       [self isMemberOfClass:[ZPracticeFreeViewController class]] ||
                       [self isMemberOfClass:[ZPracticeListViewController class]] ||
                       [self isMemberOfClass:[ZPracticeTypeViewController class]] ||
                       [self isMemberOfClass:[ZWebContentViewController class]] ||
                       [self isMemberOfClass:[ZCurriculumListViewController class]] ||
                       [self isMemberOfClass:[ZSubscribeTypeViewController class]] ||
                       [self isMemberOfClass:[ZSubscribeProbationViewController class]] ||
                       [self isMemberOfClass:[ZLawFirmListViewController class]] ||
                       [self isMemberOfClass:[ZLawFirmDetailViewController class]] ||
                       [self isMemberOfClass:[ZLawFirmPracticeViewController class]] ||
                       [self isMemberOfClass:[ZLawFirmSeriesCourseViewController class]] ||
                       [self isMemberOfClass:[ZLawFirmSubscribeViewController class]]) {
                self.viewPlay = [[ZGlobalPlayView alloc] initWithFrame:(CGRectMake(0, APP_FRAME_HEIGHT-[ZGlobalPlayView getH], APP_FRAME_WIDTH, [ZGlobalPlayView getH]))];
                [self setIsShowPlayerView:true];
            }
        }
        ZWEAKSELF
        [self.viewPlay setViewData:[ZPlayerViewController sharedSingleton].modelTrack row:[ZPlayerViewController sharedSingleton].playIndex];
        [self.viewPlay setOnCloseClick:^{
            [sqlite setSysParam:kSQLITE_CLOSE_PLAY_VIEW value:@"true"];
            [weakSelf.viewPlay setHidden:true];
            [weakSelf.viewPlay removeFromSuperview];
            weakSelf.viewPlay = nil;
        }];
        [self.viewPlay setOnPlayViewClick:^(ModelTrack *modelT, NSInteger row) {
            ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
            [weakSelf setShowPlayVC:itemVC animated:true];
        }];
        [self.viewPlay setOnPlayStatusClick:^(BOOL isPlay) {
            if (isPlay) {
                [[ZPlayerViewController sharedSingleton] setPausePlay];
            } else {
                [[ZPlayerViewController sharedSingleton] setStartPlay];
            }
        }];
        [self.viewPlay setPlayStatus:[ZPlayerViewController sharedSingleton].isPlaying];
        [self.view addSubview:self.viewPlay];
        [self.view bringSubviewToFront:self.viewPlay];
    } else {
        [self.viewPlay removeFromSuperview];
        self.viewPlay = nil;
    }
}
-(void)setOnTrackWillPlaying:(NSNotification *)sender
{
    if (self.viewPlay) {
        [self.viewPlay setPlayStatus:true];
    }
}
-(void)setOnTrackPlayNotifyProcess:(NSNotification *)sender
{
    NSDictionary *dicObject = (NSDictionary *)sender.object;
    CGFloat percent = (CGFloat)[(NSNumber *)[dicObject objectForKey:@"percent"] floatValue];
    if (self.viewPlay) {
        [self.viewPlay setPlayStatus:true];
        [self.viewPlay setPlayProgress:percent];
    }
}
-(void)setOnTrackPlayFailed:(NSNotification *)sender
{
    if (self.viewPlay) {
        [self.viewPlay setPlayStatus:false];
    }
}
-(void)setOnTrackPlayStatusChange:(NSNotification *)sender
{
    NSNumber *numObject = (NSNumber *)sender.object;
    if (self.viewPlay) {
        [self.viewPlay setPlayStatus:[numObject boolValue]];
    }
}
-(void)setOnPlayNextChange:(NSNotification *)sender
{
    NSDictionary *dicOjbect = (NSDictionary *)sender.object;
    NSNumber *rowIndex = (NSNumber*)[dicOjbect objectForKey:@"playIndex"];
    ModelTrack *modelT = (ModelTrack *)[dicOjbect objectForKey:@"modelT"];
    [self.viewPlay setViewData:modelT row:[rowIndex integerValue]];
}
/// 设置播放回调
-(void)setPlayVCBlock
{
    if (self.viewPlay) {
        [self.viewPlay setPlayStatus:[ZPlayerViewController sharedSingleton].isPlaying];
        [self.viewPlay setViewData:[ZPlayerViewController sharedSingleton].modelTrack row:[ZPlayerViewController sharedSingleton].playIndex];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOnTrackWillPlaying:) name:@"onTrackWillPlaying" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOnTrackPlayNotifyProcess:) name:@"onTrackPlayNotifyProcess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOnTrackPlayFailed:) name:@"onTrackPlayFailed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOnTrackPlayStatusChange:) name:@"onTrackPlayStatusChange" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOnPlayNextChange:) name:@"onPlayNextChange" object:nil];
        
        [self addScrollViewNotification];
    }
}
/// 销毁播放回调
-(void)delPlayVCBlock
{
    if (self.viewPlay) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTrackWillPlaying" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTrackPlayNotifyProcess" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTrackPlayFailed" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTrackPlayStatusChange" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onPlayNextChange" object:nil];
        
        [self removeScrollViewNotification];
    }
}
/// 添加滑动通知
-(void)addScrollViewNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDelegateNotification:) name:ZScrollViewDelegateNotification object:nil];
}
/// 删除滑动通知
-(void)removeScrollViewNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZScrollViewDelegateNotification object:nil];
}
/// 初始化
-(void)innerInit
{
    
}
-(void)setNavBarAlpha:(CGFloat)alpha
{
    self.navBarView.alpha = alpha;
    self.navBarViewLine.alpha = alpha;
}

-(void)setNavBarLineAlpha:(CGFloat)alpha
{
    self.navBarViewLine.alpha = alpha;
}

#pragma mark - PublicMethod

-(void)setViewNil
{
    OBJC_RELEASE(_navBackView);
}

-(void)setViewDataWithModel:(ModelEntity *)model
{
    [self setModel:model];
}

- (UIView *)navBarView
{
    if (!_navBarView) {
        UIView *navBarView = [[UIView alloc] initWithFrame:VIEW_NAVV_FRAME];
        navBarView.backgroundColor = NAVIGATIONCOLOR;
        
        self.navBarView = navBarView;
        [self.view addSubview:self.navBarView];
    }
    return _navBarView;
}
- (UIView *)navBarViewLine
{
    if (!_navBarViewLine) {
        UIImageView *navBarViewLine = [UIImageView getSLineView];
        navBarViewLine.frame = CGRectMake(0, APP_TOP_HEIGHT-1, APP_FRAME_WIDTH, 1);
        
        self.navBarViewLine = navBarViewLine;
        [self.navBarView addSubview:self.navBarViewLine];
    }
    return _navBarViewLine;
}
-(void)showPhotoBrowserWithArray:(NSArray *)array index:(NSInteger)index
{
    ZPhotoBrowser *itemVC = [[ZPhotoBrowser alloc] initWithPhotos:array index:index];
    UINavigationController *itemRVC = [[UINavigationController alloc] initWithRootViewController:itemVC];
    if (!IsIPadDevice) {
        [itemRVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    }
    [self presentViewController:itemRVC animated:YES completion:nil];
}
///显示登录界面
-(void)showLoginVC
{
    [self.view endEditing:YES];
    [self setIsShowLogin:YES];
    
    [[AppDelegate getTabBarVC] setShowLoginVCWithAnimated:YES];
}
///设置历史播放列表
-(void)setHistoryPlay
{
    if ([ZPlayerViewController sharedSingleton].arrayRawdata.count <= 0) {
        NSString *strPlayType =  [sqlite getSysParamWithKey:kSQLITEPlayViewLastPlayType];
        switch (strPlayType.intValue) {
            case ZPlayTabBarViewTypeSubscribe:
            {
                NSArray *arraySubscribeCurriculumPlay = [sqlite getLocalPlayListSubscribeCurriculumWithUserId:kLoginUserId];
                if (arraySubscribeCurriculumPlay && arraySubscribeCurriculumPlay.count > 0) {
                    [sqlite setSysParam:kSQLITEPlayViewLastPlayIndex value:[NSString stringWithFormat:@"%d", (int)index]];
                    NSInteger playIndex = [[sqlite getSysParamWithKey:kSQLITEPlayViewLastPlayIndex] integerValue];
                    if (playIndex >= arraySubscribeCurriculumPlay.count) {
                        playIndex = 0;
                    }
                    ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
                    [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypeSubscribe)];
                    [itemVC setRawdataWithArray:arraySubscribeCurriculumPlay index:playIndex];
                }
                break;
            }
            default:
            {
                NSArray *arrayPracticePlay = [sqlite getLocalPlayListPracticeWithUserId:kLoginUserId];
                if (arrayPracticePlay && arrayPracticePlay.count > 0) {
                    NSInteger playIndex = [[sqlite getSysParamWithKey:kSQLITEPlayViewLastPlayIndex] integerValue];
                    if (playIndex >= arrayPracticePlay.count) {
                        playIndex = 0;
                    }
                    ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
                    [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
                    [itemVC setRawdataWithArray:arrayPracticePlay index:playIndex];
                }
                break;
            }
        }
    }
}
///显示播放界面
-(void)setShowPlayVC
{
    [self setShowPlayVC:YES];
}
///显示播放界面
-(void)setShowPlayVC:(BOOL)animated
{
    [self.view endEditing:YES];
    if ([ZPlayerViewController sharedSingleton].arrayRawdata.count > 0) {
        ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
        [self setShowPlayVC:itemVC animated:animated];
    } else {
        /// 处理播放列表
        //[self setHistoryPlay];
        if ([ZPlayerViewController sharedSingleton].arrayRawdata.count > 0) {
            ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
            [self setShowPlayVC:itemVC animated:animated];
        } else {
            [ZProgressHUD showError:kNotFoundPlayRecord];
        }
    }
}
///显示播放界面
-(void)setShowPlayVC:(ZPlayerViewController *)itemVC animated:(BOOL)animated
{
    [[AppDelegate app] setIsPlay:YES];
    
    itemVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [itemVC setModalPresentationStyle:(UIModalPresentationCustom)];
    if(![self.navigationController.topViewController isKindOfClass:[ZPlayerViewController class]]) {
        __block BOOL isPushPlay = YES;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[ZPlayerViewController class]]) {
                isPushPlay = NO;
                *stop = YES;
            }
        }];
        [itemVC setHidesBottomBarWhenPushed:YES];
        if (isPushPlay) {
            [self.navigationController pushViewController:itemVC animated:animated];
        } else {
            [self.navigationController popToViewController:itemVC animated:animated];
        }
    }
}
///显示播放界面-实务
-(void)showPlayVCWithPracticeArray:(NSArray *)array index:(NSInteger)index
{
    [self.view endEditing:YES];
    if (array && array.count > 0 && array.count > index) {
        ModelPractice *modelP = [array objectAtIndex:index];
        ///该实务需要购买,并且未购买状态
        if (modelP && modelP.unlock == 1 && modelP.buyStatus == 0) {
            ZPracticePayViewController *itemVC = [[ZPracticePayViewController alloc] init];
            [itemVC setViewDataWithModel:modelP];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:itemVC animated:YES];
        } else {
            //处理列表中未购买需要付费的实务
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
            for (ModelPractice *model in array) {
                if (model.unlock == 1 && model.buyStatus == 0) {
                    [newArray removeObject:model];
                }
            }
            int newRow = -1;
            for (ModelPractice *model in newArray) {
                newRow++;
                if ([modelP.ids isEqualToString:model.ids]) {
                    break;
                }
            }
            if (newArray.count > 0) {
                //添加处理完成之后的实务列表
                [sqlite setSysParam:kSQLITEPlayViewLastPlayIndex value:[NSString stringWithFormat:@"%d", (int)newRow]];
                [sqlite setSysParam:kSQLITEPlayViewLastPlayType value:[NSString stringWithFormat:@"%ld", (long)ZPlayTabBarViewTypePractice]];
                [sqlite setLocalPlayListPracticeWithArray:newArray userId:kLoginUserId];
                
                ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
                [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
                [itemVC setRawdataWithArray:newArray index:newRow];
                
                [self setShowPlayVC:itemVC animated:YES];
            }
        }
    } else {
        [ZProgressHUD showError:kNotFoundPlayRecord];
    }
}
///显示播放界面-订阅
-(void)showPlayVCWithCurriculumArray:(NSArray *)array index:(NSInteger)index
{
    [self.view endEditing:YES];
    if (array && array.count > 0 && array.count > index) {
        [sqlite setSysParam:kSQLITEPlayViewLastPlayIndex value:[NSString stringWithFormat:@"%d", (int)index]];
        [sqlite setSysParam:kSQLITEPlayViewLastPlayType value:[NSString stringWithFormat:@"%ld", (long)ZPlayTabBarViewTypeSubscribe]];
        [sqlite setLocalPlayListSubscribeCurriculumWithArray:array userId:kLoginUserId];
        
        ZPlayerViewController *itemVC = [ZPlayerViewController sharedSingleton];
        [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypeSubscribe)];
        [itemVC setRawdataWithArray:array index:index];
        
        [self setShowPlayVC:itemVC animated:YES];
    } else {
        [ZProgressHUD showError:kNotFoundPlayRecord];
    }
}
///显示网页界面
-(void)showWebVCWithUrl:(NSString *)url title:(NSString *)title
{
    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    [itemVC setWebUrl:url];
    [itemVC setTitle:title];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///显示网页界面
-(void)showWebVCWithModel:(ModelBanner *)model
{
    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    [itemVC setModel:model];
    [itemVC setWebUrl:model.url];
    [itemVC setTitle:model.share_title];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///显示问题详情
-(void)showQuestionDetailVC:(ModelQuestionBase *)model
{
    ZQuestionDetailViewController *itemVC = [[ZQuestionDetailViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///删除问题回调方法
-(void)setDeleteQuestion:(ModelQuestionBase *)model
{
    
}
///显示答案详情
-(void)showAnswerDetailVC:(ModelAnswerBase *)model
{
    ZAnswerDetailViewController *itemVC = [[ZAnswerDetailViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///显示答案详情-默认显示带有评论的
-(void)showAnswerDetailVC:(ModelAnswerBase *)model defaultCommentModel:(ModelAnswerComment *)modelAC
{
    ZAnswerDetailViewController *itemVC = [[ZAnswerDetailViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [itemVC setDefaultCommentModel:modelAC];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///删除回答回调
-(void)setDeleteAnswer:(ModelAnswerBase *)model
{
    
}
///显示他人用户信息
-(void)showUserProfileVC:(ModelUserBase *)model
{
    ZUserProfileViewController *itemVC = [[ZUserProfileViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///显示他人用户信息-PreVC用来处理事件回调的
-(void)showUserProfileVC:(ModelUserBase *)model preVC:(id)preVC
{
    ZUserProfileViewController *itemVC = [[ZUserProfileViewController alloc] init];
    [itemVC setPreVC:preVC];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - NavigationButtonMethod

-(UIButton *)getCartButton
{
    UIButton *btnRight = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnRight setTag:100];
    [btnRight setImageEdgeInsets:(UIEdgeInsetsMake(11, 11, 8, 0))];
    [btnRight addTarget:self action:@selector(btnCartClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnRight setImage:[SkinManager getImageWithName:@"cart01"] forState:(UIControlStateNormal)];
    [btnRight setImage:[SkinManager getImageWithName:@"cart01"] forState:(UIControlStateHighlighted)];
    [btnRight setUserInteractionEnabled:YES];
    [btnRight setFrame:CGRectMake(0, 0, 44, 44)];
    
    CGFloat countS = 16;
    UILabel *lbCount = [[UILabel alloc] initWithFrame:CGRectMake(btnRight.width-countS, btnRight.y+3, countS, countS)];
    [lbCount setFont:[ZFont systemFontOfSize:kFont_Minimum_Size-1]];
    [lbCount setTextColor:WHITECOLOR];
    [lbCount setTag:100];
    [lbCount setBackgroundColor:COLORCOUNTBG];
    [lbCount setTextAlignment:(NSTextAlignmentCenter)];
    ModelUser *modelU = [AppSetting getUserLogin];
    [lbCount setHidden:modelU.shoppingCartCount==0];
    if (modelU.shoppingCartCount > kNumberMaxCount) {
        [lbCount setText:[NSString stringWithFormat:@"%d", kNumberMaxCount]];
    } else {
        [lbCount setText:[NSString stringWithFormat:@"%d", modelU.shoppingCartCount]];
    }
    [lbCount setViewRoundNoBorder];
    [btnRight addSubview:lbCount];
    return btnRight;
}
-(void)setBackButtonWithLeft
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnBack setFrame:CGRectMake(0, 0, 55, 44)];
    [btnBack setImage:[UIImage imageNamed:@"arrow_left"] forState:(UIControlStateNormal)];
    [btnBack setImage:[UIImage imageNamed:@"arrow_left"] forState:(UIControlStateHighlighted)];
    [btnBack setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    //[btnBack setTitleEdgeInsets:(UIEdgeInsetsMake(0, 8, 0, 0))];
    //[btnBack setContentEdgeInsets:(UIEdgeInsetsMake(0, -5, 0, 0))];
    [[btnBack titleLabel] setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *btnBackItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:btnBackItem];
}
-(void)setBackButtonWithLeftWhite
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnBack setFrame:CGRectMake(0, 0, 55, 44)];
    [btnBack setImage:[UIImage imageNamed:@"arrow_left_white"] forState:(UIControlStateNormal)];
    [btnBack setImage:[UIImage imageNamed:@"arrow_left_white"] forState:(UIControlStateHighlighted)];
    [btnBack setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    //[btnBack setTitleEdgeInsets:(UIEdgeInsetsMake(0, 8, 0, 0))];
    //[btnBack setContentEdgeInsets:(UIEdgeInsetsMake(0, -5, 0, 0))];
    [[btnBack titleLabel] setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *btnBackItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:btnBackItem];
}
-(void)setBackButtonWithClose
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:kClose style:(UIBarButtonItemStyleDone) target:self action:@selector(btnBackClick)];
    [[self navigationItem] setLeftBarButtonItem:btnItem];
}
-(void)setRightShareButton
{
    /// TODO: ZWW 方便测试暂时注释,发布之前需要恢复屏蔽
    if ([Utils isWXAppInstalled] || [Utils isQQAppInstalled]) {
        UIButton *btnShare = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btnShare setFrame:(CGRectMake(0, 0, 44, 44))];
        [btnShare setImageEdgeInsets:(UIEdgeInsetsMake(11, 11, 8, 0))];
        [btnShare addTarget:self action:@selector(btnShareClick) forControlEvents:(UIControlEventTouchUpInside)];
        [btnShare setImage:[SkinManager getImageWithName:@"share"] forState:(UIControlStateNormal)];
        [btnShare setImage:[SkinManager getImageWithName:@"share"] forState:(UIControlStateHighlighted)];
        [btnShare setUserInteractionEnabled:YES];
        
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnShare]];
    } else {
        [[self navigationItem] setRightBarButtonItem:nil];
    }
}
-(void)setRightShareButtonWhite
{
    /// TODO: ZWW 方便测试暂时注释,发布之前需要恢复屏蔽
    if ([Utils isWXAppInstalled] || [Utils isQQAppInstalled]) {
        UIButton *btnShare = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btnShare setFrame:(CGRectMake(0, 0, 44, 44))];
        [btnShare setImageEdgeInsets:(UIEdgeInsetsMake(11, 11, 8, 0))];
        [btnShare addTarget:self action:@selector(btnShareClick) forControlEvents:(UIControlEventTouchUpInside)];
        [btnShare setImage:[SkinManager getImageWithName:@"share_w"] forState:(UIControlStateNormal)];
        [btnShare setImage:[SkinManager getImageWithName:@"share_w"] forState:(UIControlStateHighlighted)];
        [btnShare setUserInteractionEnabled:YES];
        
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnShare]];
    } else {
        [[self navigationItem] setRightBarButtonItem:nil];
    }
}
-(void)setRightShareCartButton
{
    [[self navigationItem] setRightBarButtonItem:nil];
    if (![Utils isWXAppInstalled] && ![Utils isQQAppInstalled]) {
        UIView *viewRight = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 44, 44))];
        [viewRight setTag:100];
        
        UIButton *btnCart = [self getCartButton];
        [viewRight addSubview:btnCart];
        
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:viewRight]];
    } else {
        UIView *viewRight = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 88, 44))];
        [viewRight setTag:100];
        
        UIButton *btnShare = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btnShare setFrame:(CGRectMake(44, 0, 44, 44))];
        [btnShare setTag:101];
        [btnShare setImageEdgeInsets:(UIEdgeInsetsMake(11, 11, 8, 0))];
        [btnShare addTarget:self action:@selector(btnShareClick) forControlEvents:(UIControlEventTouchUpInside)];
        [btnShare setImage:[SkinManager getImageWithName:@"share"] forState:(UIControlStateNormal)];
        [btnShare setImage:[SkinManager getImageWithName:@"share"] forState:(UIControlStateHighlighted)];
        [btnShare setUserInteractionEnabled:YES];
        [viewRight addSubview:btnShare];
        
        UIButton *btnCart = [self getCartButton];
        [viewRight addSubview:btnCart];
        
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:viewRight]];
    }
}
-(void)setRightButtonWithSearch
{
    UIButton *btnSearch = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSearch setFrame:(CGRectMake(0, 0, 44, 44))];
    [btnSearch setImageEdgeInsets:(UIEdgeInsetsMake(11, 11, 8, 0))];
    [btnSearch addTarget:self action:@selector(btnSearchClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSearch setImage:[SkinManager getImageWithName:@"search"] forState:(UIControlStateNormal)];
    [btnSearch setImage:[SkinManager getImageWithName:@"search"] forState:(UIControlStateHighlighted)];
    [btnSearch setUserInteractionEnabled:YES];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnSearch]];
}
-(void)setRightButtonWithImage:(NSString*)image
{
    [[self navigationItem] setRightBarButtonItem:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image] style:(UIBarButtonItemStyleDone) target:self action:@selector(btnRightClick)];
    [[self navigationItem] setRightBarButtonItem:btnItem];
}
-(void)setRightButtonWithText:(NSString*)text
{
    [[self navigationItem] setRightBarButtonItem:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStyleDone) target:self action:@selector(btnRightClick)];
    [[self navigationItem] setRightBarButtonItem:btnItem];
}
-(void)setLeftButtonWithImage:(NSString*)image
{
    [self setLeftButtonWithImage:image width:55 offX:5];
}
-(void)setLeftButtonWithImage:(NSString*)image width:(CGFloat)width offX:(CGFloat)offX
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnBack setFrame:CGRectMake(0, 0, width, 44)];
    [btnBack setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [btnBack setImage:[UIImage imageNamed:image] forState:(UIControlStateHighlighted)];
    [btnBack setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [btnBack setImageEdgeInsets:(UIEdgeInsetsMake(0, offX, 0, 0))];
    [[btnBack titleLabel] setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [btnBack addTarget:self action:@selector(btnLeftClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [[self navigationItem] setLeftBarButtonItem:btnItem];
}
-(void)setLeftButtonWithText:(NSString*)text
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStyleDone) target:self action:@selector(btnRightClick)];
    [[self navigationItem] setLeftBarButtonItem:btnItem];
}

-(void)btnRightClick
{
    
}
-(void)btnShareClick
{

}
-(void)btnCartClick
{
    
}
-(void)btnLeftClick
{
    
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnSearchClick
{
    ZSearchViewController *itemVC = [[ZSearchViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:true];
    [self.navigationController pushViewController:itemVC animated:true];
}

#pragma mark - ShareEvent

///微信分享
-(void)btnWeChatClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![Utils isWXAppInstalled]) {
        SafariOpen([WXApi getWXAppInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeWeChatSession];
}
///微信朋友圈分享
-(void)btnWeChatCircleClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![Utils isWXAppInstalled]) {
        SafariOpen([WXApi getWXAppInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeWeChatTimeline];
}
///QQ好友分享
-(void)btnQQClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![Utils isQQAppInstalled]) {
        SafariOpen([QQApiInterface getQQInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeQQFriend];
}
///QQ空间分享
-(void)btnQZoneClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![Utils isQQAppInstalled]) {
        SafariOpen([QQApiInterface getQQInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeQzone];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    
}
///有道云笔记
-(void)btnYouDaoClick
{
    [self shareNotePlatform:SSDKPlatformTypeYouDaoNote];
}
///印象笔记
-(void)btnYinXiangClick
{
    [self shareNotePlatform:SSDKPlatformTypeYinXiang];
}
///分享笔记平台
-(void)shareNotePlatform:(SSDKPlatformType)type
{
    ModelPractice *modelP = (ModelPractice*)self.model;
    if (modelP) {
        if ([ShareSDK hasAuthorized:type]) {
            NSArray *imagesArr = nil;
            if (modelP.speech_img == nil || modelP.speech_img.length == 0) {
                imagesArr = @[[SkinManager getDefaultImage]];
            } else {
                imagesArr = @[modelP.speech_img];
            }
            NSString *url = kApp_PracticeContentUrl(modelP.ids);
            NSString *text = [NSString stringWithFormat:@"%@ \n %@: %@",modelP.share_content, kFilePath, url];
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:text
                                             images:imagesArr
                                                url:[NSURL URLWithString:url]
                                              title:modelP.title
                                               type:SSDKContentTypeAuto];
            
            [ShareSDK setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
            [SSUIEditorViewStyle setStatusBarStyle:(UIStatusBarStyleLightContent)];
            [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:MAINCOLOR];
            [SSUIEditorViewStyle setiPadNavigationBarBackgroundColor:MAINCOLOR];
            [SSUIEditorViewStyle setCancelButtonLabelColor:WHITECOLOR];
            [SSUIEditorViewStyle setShareButtonLabelColor:WHITECOLOR];
            [SSUIEditorViewStyle setTitleColor:WHITECOLOR];
            [SSUIEditorViewStyle setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
            
            [ShareSDK showShareEditor:type
                   otherPlatformTypes:@[@(type)]
                          shareParams:shareParams
                  onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
             {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         GCDMainBlock(^{
                             [ZProgressHUD showSuccess:kCShareTitleSuccess];
                         });
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         GCDMainBlock(^{
                             if (error.code == 205) {
                                 [ZProgressHUD showError:kCShareTitleNoAuthorizeError];
                             } else {
                                 [ZProgressHUD showError:kCShareTitleError];
                             }
                         });
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         GCDMainBlock(^{
                             [ZProgressHUD showError:kCShareTitleCancel];
                         });
                         break;
                     }
                     default: break;
                 }
             }];
        } else {
            [ShareSDK setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
            [SSDKAuthViewStyle setStatusBarStyle:(UIStatusBarStyleLightContent)];
            [SSDKAuthViewStyle setNavigationBarBackgroundColor:MAINCOLOR];
            [SSDKAuthViewStyle setCancelButtonLabelColor:WHITECOLOR];
            [SSDKAuthViewStyle setTitleColor:WHITECOLOR];
            [SSDKAuthViewStyle setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
            
            ZWEAKSELF
            [ShareSDK authorize:type
                       settings:nil
                 onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess:
                         {
                             GCDMainBlock(^{
                                 [ZProgressHUD showSuccess:kAuthorSuccess];
                                 [weakSelf shareNotePlatform:type];
                             });
                             break;
                         }
                         case SSDKResponseStateFail:
                         {
                             GCDMainBlock(^{
                                 [ZProgressHUD showError:kAuthorFail];
                             });
                             break;
                         }
                         case SSDKResponseStateCancel:
                         {
                             GCDMainBlock(^{
                                 [ZProgressHUD showError:kAuthorCancel];
                             });
                             break;
                         }
                         default: break;
                     }
                 }];
        }
    }
}
///举报
-(void)btnReportClickWithId:(NSString *)ids type:(ZReportType)type
{
    if ([AppSetting getAutoLogin] && ![[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        ZReportView *reportView = [[ZReportView alloc] init];
        [reportView setOnSubmitClick:^(NSString *content) {
            [snsV1 postAddReportWithUserId:kLoginUserId objId:ids type:type content:content resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:kReportSuccess];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        }];
        ZWEAKSELF
        [reportView setOnOtherClick:^{
            ZReportViewController *itemVC = [[ZReportViewController alloc] init];
            switch (type) {
                case ZReportTypeAnswer:
                    [itemVC setTitle:kReportAnswer];
                    break;
                case ZReportTypePersion:
                    [itemVC setTitle:kReportUser];
                    break;
                case ZReportTypeQuestion:
                    [itemVC setTitle:kReportQuestion];
                    break;
                case ZReportTypeComment:
                    [itemVC setTitle:kReportComment];
                    break;
                default:
                    break;
            }
            [itemVC setViewDataWithIds:ids type:type];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:itemVC animated:YES];
        }];
        [reportView show];
    } else {
        [self showLoginVC];
    }
}
#pragma mark - KeyboardNotification

-(void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - KeyboardNotificationMethod

-(void)keyboardWillShow:(NSNotification*)sender
{
    [self keyboardFrameChange:[[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height];
}

-(void)keyboardWillHide:(NSNotification*)sender
{
    [self keyboardFrameChange:0];
}

-(void)keyboardFrameChange:(CGFloat)height
{
    
}

#pragma mark - TextFieldTextDidChangeNotification

-(void)registerTextFieldTextDidChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)removeTextFieldTextDidChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - TextFieldTextDidChangeNotificationMethod

-(void)textFieldDidChange:(NSNotification *)sender
{
    [self textFieldTextDidChange:sender.object];
}

-(void)textFieldTextDidChange:(UITextField *)textField
{
    
}

#pragma mark - LoginChangeNotification

-(void)registerLoginChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginChange) name:ZLoginChangeNotification object:nil];
}

-(void)removeLoginChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZLoginChangeNotification object:nil];
}

-(void)postLoginChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLoginChangeNotification object:nil];
}

-(void)setLoginChange
{
    
}

#pragma mark - UserInfoChangeNotification

-(void)registerUserInfoChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserInfoChange) name:ZUserInfoChangeNotification object:nil];
}

-(void)removeUserInfoChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZUserInfoChangeNotification object:nil];
}

-(void)postUserInfoChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZUserInfoChangeNotification object:nil];
}

-(void)setUserInfoChange
{
    
}

#pragma mark - FontSizeChangeNotification

-(void)registerFontSizeChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFontSizeChange) name:ZFontSizeChangeNotification object:nil];
}

-(void)removeFontSizeChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPublishQuestionNotification object:nil];
}

-(void)postFontSizeChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPublishQuestionNotification object:nil];
}

-(void)setFontSizeChange
{
    
}

#pragma mark - PublishQuestionNotification

-(void)registerPublishQuestionNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPublishQuestion:) name:ZPublishQuestionNotification object:nil];
}

-(void)removePublishQuestionNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPublishQuestionNotification object:nil];
}

-(void)postPublishQuestionNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPublishQuestionNotification object:nil];
}

-(void)postPublishQuestionNotificationWithModel:(ModelQuestion *)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPublishQuestionNotification object:model];
}

-(void)setPublishQuestion:(NSNotification *)sender
{
    [self setPublishQuestion];
}

-(void)setPublishQuestion
{
    
}

#pragma mark - UIScrollViewDelegate

/// 滑动的通知 1 开始滑动 2 减速滑动 3 结束滑动
- (void)scrollViewDelegateNotification:(NSNotification *)sender
{
    GBLog(@"scrollViewDelegateNotification %@", sender.object);
    switch ([sender.object intValue]) {
        case 1:
            if (self.viewPlay) {
                [self.viewPlay dismiss];
            }
            break;
        default:
            if (self.viewPlay) {
                [self.viewPlay show];
            }
            break;
    }
}

@end
