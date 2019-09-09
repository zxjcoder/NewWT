//
//  ZUserViewController.m
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZUserViewController.h"
#import "ZUserInfoCenterView.h"
#import "ZUserInfoImageView.h"
#import "ZUserInfoQuestionView.h"
#import "ZUserInfoShopView.h"
#import "ZUserInfoPromptView.h"
#import "ZScrollView.h"

#import "ZEditUserInfoViewController.h"
#import "ZWebViewController.h"
#import "ZUserFeedbackViewController.h"
#import "ZUserSettingViewController.h"

#import "ZMyAnswerViewController.h"
#import "ZMyAttentionViewController.h"
#import "ZMyCollectionViewController.h"
#import "ZMyFansViewController.h"
#import "ZMyQuestionViewController.h"
#import "ZUserWaitAnswerViewController.h"
#import "ZNoticeListViewController.h"
#import "ZMyCommentViewController.h"
#import "ZAccountBalanceViewController.h"
#import "ZUserConsumerViewController.h"
#import "ZPayCartViewController.h"
#import "ZUserDownloadViewController.h"
#import "ZAccountManagerViewController.h"
#import "ZPurchaseViewController.h"

@interface ZUserViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *viewMain;
@property (strong, nonatomic) ZUserInfoCenterView *viewCenter;
@property (strong, nonatomic) ZUserInfoImageView *viewImage;
@property (strong, nonatomic) ZUserInfoQuestionView *viewQuestion;
@property (strong, nonatomic) ZUserInfoShopView *viewShop;

@property (strong, nonatomic) ZLabel *lbTitleNav;
@property (assign, nonatomic) CGFloat navLastAlpha;

@end

@implementation ZUserViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
    
    [self innerData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setViewDataWithModel:[AppSetting getUserLogin]];
    
    [self.lbTitleNav setText:[AppSetting getUserLogin].nickname];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self setNavigationTintColor];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    OBJC_RELEASE(_viewImage);
    OBJC_RELEASE(_viewShop);
    OBJC_RELEASE(_viewCenter);
    OBJC_RELEASE(_viewQuestion);
    _viewMain.delegate = nil;
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_lbTitleNav);
    
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.viewMain = [[UIScrollView alloc] initWithFrame:VIEW_MAIN_FRAME];
    [self.viewMain setDelegate:self];
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.viewMain setScrollIndicatorInsets:(UIEdgeInsetsZero)];
    [self.view addSubview:self.viewMain];
    CGFloat viewW = APP_FRAME_WIDTH;
    self.viewImage = [[ZUserInfoImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, [ZUserInfoImageView getH])];
    [self.viewImage setOnUserPhotoClick:^{
        [weakSelf showEditUserInfoVC];
    }];
    [self.viewMain addSubview:self.viewImage];
    
    self.viewQuestion = [[ZUserInfoQuestionView alloc] initWithFrame:CGRectMake(0, self.viewImage.y+self.viewImage.height, viewW, [ZUserInfoQuestionView getH])];
    [self.viewQuestion setOnFansClick:^{
        [weakSelf showFansVC];
    }];
    [self.viewQuestion setOnAnswerClick:^{
        [weakSelf showWaitAnswerVC];
    }];
    [self.viewQuestion setOnQuestionClick:^{
        [weakSelf showQuestionVC];
    }];
    [self.viewMain addSubview:self.viewQuestion];
    
    self.viewShop = [[ZUserInfoShopView alloc] initWithFrame:CGRectMake(0, self.viewQuestion.y+self.viewQuestion.height, viewW, [ZUserInfoShopView getH])];
    [self.viewShop setOnUserInfoShoppingCartItemClick:^(ZUserInfoCenterItemType type) {
        [weakSelf setShowVCWithType:type];
    }];
    [self.viewMain addSubview:self.viewShop];
    
    self.viewCenter = [[ZUserInfoCenterView alloc] initWithFrame:CGRectMake(0, self.viewShop.y+self.viewShop.height, viewW, [ZUserInfoCenterView getH])];
    [self.viewCenter setOnUserInfoCenterItemClick:^(ZUserInfoCenterItemType type) {
        [weakSelf setShowVCWithType:type];
    }];
    [self.viewMain addSubview:self.viewCenter];
    [self.viewMain setContentSize:CGSizeMake(viewW, self.viewCenter.y+self.viewCenter.height)];
    
    ModelAppConfig *model = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION];
    if (model && model.appStatus == 0) {
        [self.viewCenter setIsAuditStatus:YES];
    } else {
        [self.viewCenter setIsAuditStatus:NO];
    }
    
    [super innerInit];
    
    [self setNavBarAlpha:0];
    
    self.lbTitleNav = [[ZLabel alloc] initWithFrame:CGRectMake(65, 0, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setTextColor:TITLECOLOR];
    [self.lbTitleNav setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    [self.lbTitleNav setHidden:YES];
    
    [self checkNickNameChange];
}
///设置导航栏颜色
-(void)setNavigationTintColor
{
    [self.navigationController.navigationBar setTintColor:NAVIGATIONTINTCOLOR];
}
///加载数据
-(void)innerData
{
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        [snsV1 postGetUserInfoWithUserId:[AppSetting getUserDetauleId] resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
            if (resultModel) {
                [AppSetting setUserLogin:resultModel];
                
                [AppSetting save];
                GCDMainBlock(^{
                    [weakSelf setViewDataWithModel:resultModel];
                });
                [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
            }
        } errorBlock:nil];
    } else {
        [self setViewDataWithModel:nil];
    }
}
-(void)setViewDataWithModel:(ModelUser *)model
{
    @synchronized (self) {
        if (model) {
            [self.viewImage setViewDataWithModel:model];
            [self.viewQuestion setViewDataWithModel:model];
            [self.viewShop setViewDataWithModel:model];
            [self.viewCenter setViewDataWithModel:model];
        }
    }
}
-(void)setShowVCWithType:(ZUserInfoCenterItemType)type
{
    switch (type) {
        case ZUserInfoCenterItemTypePurchaseRecord:
            [self showPayVC];
            break;
        case ZUserInfoCenterItemTypePay:
            [self showPayVC];
            break;
        case ZUserInfoCenterItemTypeBalance:
            [self showBalanceVC];
            break;
        case ZUserInfoCenterItemTypeCollection:
            [self showCollectionVC];
            break;
        case ZUserInfoCenterItemTypeAttention:
            [self showAttentionVC];
            break;
        case ZUserInfoCenterItemTypeAnswer:
            [self showMyAnswerVC];
            break;
        case ZUserInfoCenterItemTypeComment:
            [self showCommentVC];
            break;
        case ZUserInfoCenterItemTypeTask:
            [self showTaskCenterVC];
            break;
        case ZUserInfoCenterItemTypeMessage:
            [self showMessageCenterVC];
            break;
        case ZUserInfoCenterItemTypeFeedback:
            [self showFeedbackVC];
            break;
        case ZUserInfoCenterItemTypeSetting:
            [self showSettingVC];
            break;
        case ZUserInfoCenterItemTypeShoppingCart:
            [self showShopChatVC];
            break;
        case ZUserInfoCenterItemTypeAccount:
            [self showAccountManagerVC];
            break;
        case ZUserInfoCenterItemTypeDownload:
            [self showDownloadManagerVC];
            break;
        case ZUserInfoCenterItemTypePurchase:
            [self setShowPurchaseVC];
            break;
        default: break;
    }
}
///弹出提示修改昵称
-(void)showUserInfoPromptView
{
    ZWEAKSELF
    NSString *strNowDate = [[NSDate new] toString];
    if (strNowDate) {
        [sqlite setSysParam:kSQLITE_LAST_SOWUSERINFOPROMPTTIME value:strNowDate];
    }
    GCDMainBlock(^{
        ZUserInfoPromptView *viewUserInfoPrompt = [[ZUserInfoPromptView alloc] init];
        [viewUserInfoPrompt setOnCancelClick:^{
            [sqlite setSysParam:kSQLITE_LAST_USERINFOPROMPT value:@"YES"];
        }];
        [viewUserInfoPrompt setOnSubmitClick:^{
            [weakSelf showEditUserInfoVC];
        }];
        [viewUserInfoPrompt show];
    });
}
///检测昵称是否修改过
-(void)checkNickNameChange
{
    ZWEAKSELF
    ///处理弹出修改昵称的提示框
    ModelUser *modelU = [AppSetting getUserLogin];
    if ([modelU.account isMobile] || [modelU.account isEmail]) {
        //手机或邮箱登录
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL isNoPrompt = [[sqlite getSysParamWithKey:kSQLITE_LAST_USERINFOPROMPT] boolValue];
            if (!isNoPrompt) {
                NSString *nickName = [Utils getStringStarWithStr:modelU.account];
                ///当用户没有修改过昵称
                if ([nickName isEqualToString:modelU.nickname]) {
                    NSString *lastTime = [sqlite getSysParamWithKey:kSQLITE_LAST_SOWUSERINFOPROMPTTIME];
                    if (lastTime && lastTime.length > 0) {
                        NSDate *lastDate = [lastTime toDate];
                        if (lastDate) {
                            NSTimeInterval intervatTime = [[NSDate new] timeIntervalSinceDate:lastDate];
                            int days = ((int)intervatTime)/(3600*24);
                            //已经超过7天了
                            if (days > 7) {
                                [weakSelf showUserInfoPromptView];
                            }
                        }
                    } else {
                        ///没有弹出过提示框
                        [weakSelf showUserInfoPromptView];
                    }
                }
            }
        });
    }
}
///我的问题
-(void)showQuestionVC
{
    [StatisticsManager event:kUser_MYQuestion];
    
    ZMyQuestionViewController *itemVC = [[ZMyQuestionViewController alloc] init];
    [itemVC setTitle:kMyQuestion];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的粉丝
-(void)showFansVC
{
    [StatisticsManager event:kUser_MYFans];
    
    ZMyFansViewController *itemVC = [[ZMyFansViewController alloc] init];
    [itemVC setTitle:kMyFans];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///等我回答
-(void)showWaitAnswerVC
{
    [StatisticsManager event:kUser_MYWaitAAnswer];
    
    ZUserWaitAnswerViewController *itemVC = [[ZUserWaitAnswerViewController alloc] init];
    [itemVC setTitle:kWaitAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///编辑用户信息
-(void)showEditUserInfoVC
{
    [StatisticsManager event:kUser_Edit];
    
    ZEditUserInfoViewController *itemVC = [[ZEditUserInfoViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///支付记录
-(void)showPayVC
{
    [StatisticsManager event:kUser_ExpenseCalendar];
    
    ZUserConsumerViewController *itemVC = [[ZUserConsumerViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///购物车
-(void)showShopChatVC
{
    [StatisticsManager event:kUser_ShoppingCart];
    
    ZPayCartViewController *itemVC = [[ZPayCartViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///账户管理
-(void)showAccountManagerVC
{
    ZAccountManagerViewController *itemVC = [[ZAccountManagerViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///购物车
-(void)showDownloadManagerVC
{
    [StatisticsManager event:kUser_ExpenseCalendar];
    
    ZUserDownloadViewController *itemVC = [[ZUserDownloadViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的余额
-(void)showBalanceVC
{
    [StatisticsManager event:kUser_Balance];
    
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的收藏
-(void)showCollectionVC
{
    [StatisticsManager event:kUser_MYCollection];
    
    ZMyCollectionViewController *itemVC = [[ZMyCollectionViewController alloc] init];
    [itemVC setTitle:kMyCollection];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的关注
-(void)showAttentionVC
{
    [StatisticsManager event:kUser_MYAtt];
    
    ZMyAttentionViewController *itemVC = [[ZMyAttentionViewController alloc] init];
    [itemVC setTitle:kMyAttention];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的答案
-(void)showMyAnswerVC
{
    [StatisticsManager event:kUser_MYAnswer];
    
    ZMyAnswerViewController *itemVC = [[ZMyAnswerViewController alloc] init];
    [itemVC setTitle:kMyAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的评论
-(void)showCommentVC
{
    [StatisticsManager event:kUser_MYComment];
    
    ZMyCommentViewController *itemVC = [[ZMyCommentViewController alloc] init];
    [itemVC setTitle:kMyComment];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的任务中心
-(void)showTaskCenterVC
{
    
}
///我的消息中心
-(void)showMessageCenterVC
{
    [StatisticsManager event:kUser_NoticeCenter];
    
    ZNoticeListViewController *itemVC = [[ZNoticeListViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///意见反馈
-(void)showFeedbackVC
{
    [StatisticsManager event:kUser_FeebBack];
    
    ZUserFeedbackViewController *itemVC = [[ZUserFeedbackViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///设置
-(void)showSettingVC
{
    [StatisticsManager event:kUser_Setting];
    
    ZUserSettingViewController *itemVC = [[ZUserSettingViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///已购
-(void)setShowPurchaseVC
{
    [StatisticsManager event:kUser_Purchase];
    
    ZPurchaseViewController *itemVC = [[ZPurchaseViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat imageH = self.viewImage.height;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = offsetY / 124;
    if (alpha > 1) { alpha = 1; }
    else if (alpha < 0) { alpha = 0; }
    [self setNavLastAlpha:alpha];
    [self.lbTitleNav setHidden:alpha<0.85];
    [self setNavBarAlpha:alpha];
    
    CGFloat imageW = self.viewImage.width;
    if (offsetY < 0) {
        CGRect imageFrame = self.viewImage.getViewImageFrame;
        imageFrame.origin.y = offsetY;
        imageFrame.origin.x = offsetY;
        imageFrame.size.width = imageW - (offsetY*2);
        imageFrame.size.height = imageH - offsetY;
        [self.viewImage setViewImageFrame:imageFrame];
    } else {
        CGRect imageFrame = self.viewImage.getViewImageFrame;
        imageFrame.origin.y = 0;
        imageFrame.origin.x = 0;
        imageFrame.size.width = imageW;
        imageFrame.size.height = imageH;
        [self.viewImage setViewImageFrame:imageFrame];
    }
}

@end
