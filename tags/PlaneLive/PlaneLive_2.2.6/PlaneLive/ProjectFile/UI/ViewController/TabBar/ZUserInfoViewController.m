//
//  ZUserInfoViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoViewController.h"
#import "ZUserInfoTableView.h"
#import "ZUserInfoPromptView.h"
#import "ZAlertHintView.h"

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
#import "ZPurchaseViewController.h"
#import "ZAccountManagerViewController.h"
#import "ZUserConsumerViewController.h"
#import "ZContactServiceViewController.h"
#import "ZMessageListViewController.h"

@interface ZUserInfoViewController ()

@property (strong, nonatomic) ZUserInfoTableView *tvMain;
@property (strong, nonatomic) ZLabel *lbTitleNav;
@property (assign, nonatomic) CGFloat navLastAlpha;

@end

@implementation ZUserInfoViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kMyInfo];
    [self registerLoginChangeNotification];
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kIsNeedLogin) {
        [self.tvMain removeRefreshHeader];
    } else {
        ZWEAKSELF
        [self.tvMain setRefreshHeaderWithRefreshBlock:^{
            [weakSelf setRefreshHeader];
        }];
    }
    [self innerData];
    [self.lbTitleNav setText:[AppSetting getUserLogin].nickname];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:false];
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageUserKey];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTintColor:NAVIGATIONTINTCOLOR];
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageUserKey dictionary:nil];
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removeLoginChangeNotification];
    
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_lbTitleNav);
    
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    CGRect tvFrame = VIEW_MAIN_FRAME;
    self.tvMain = [[ZUserInfoTableView alloc] initWithFrame:tvFrame];
    [self.tvMain setOnContentOffsetY:^(CGFloat alpha) {
        [weakSelf setNavLastAlpha:alpha];
        
        [weakSelf.lbTitleNav setHidden:alpha<0.85];
        
        [weakSelf setNavBarAlpha:alpha];
    }];
    [self.tvMain setOnUserPhotoClick:^{
        if (kIsNeedLogin) {
            [weakSelf showLoginVC];
        } else {
            [weakSelf showEditUserInfoVC];
        }
    }];
    [self.tvMain setOnBalanceClick:^{
        if (![AppSetting getAutoLogin]) {
            [weakSelf showLoginVC];
        } else {
            [weakSelf setShowAccountBalanceVC];
        }
    }];
    [self.tvMain setOnPurchaseRecordClick:^{
        if (![AppSetting getAutoLogin]) {
            [weakSelf showLoginVC];
        } else {
            [weakSelf setShowConsumerVC];
        }
    }];
    [self.tvMain setOnShopCartClick:^{
        if (![AppSetting getAutoLogin]) {
            [weakSelf showLoginVC];
        } else {
            [weakSelf showShopChatVC];
        }
    }];
    [self.tvMain setOnDownloadClick:^{
        if (![AppSetting getAutoLogin]) {
            [weakSelf showLoginVC];
        } else {
            [weakSelf showDownloadManagerVC];
        }
    }];
    [self.tvMain setOnUserInfoItemClick:^(ZUserInfoItemTVCType type) {
        if (kIsNeedLogin) {
            switch (type) {
                case ZUserInfoItemTVCTypeFeedback:
                    [weakSelf showFeedbackVC];
                    break;
                case ZUserInfoItemTVCTypeServer:
                    [weakSelf showContactServiceVC];
                    break;
                case ZUserInfoItemTVCTypeSetting:
                    [weakSelf showSettingVC];
                    break;
                default: [weakSelf showLoginVC]; break;
            }
        } else {
            switch (type) {
                case ZUserInfoItemTVCTypeQuestion:
                    [weakSelf showQuestionVC];
                    break;
                case ZUserInfoItemTVCTypeAnswer:
                    [weakSelf showMyAnswerVC];
                    break;
                case ZUserInfoItemTVCTypeComment:
                    [weakSelf showCommentVC];
                    break;
                case ZUserInfoItemTVCTypeFans:
                    [weakSelf showFansVC];
                    break;
                case ZUserInfoItemTVCTypeFeedback:
                    [weakSelf showFeedbackVC];
                    break;
                case ZUserInfoItemTVCTypeServer:
                    [weakSelf showContactServiceVC];
                    break;
                case ZUserInfoItemTVCTypeAccount:
                    [weakSelf showAccountManagerVC];
                    break;
                case ZUserInfoItemTVCTypeSetting:
                    [weakSelf showSettingVC];
                    break;
                case ZUserInfoItemTVCTypeCollection:
                    [weakSelf showCollectionVC];
                    break;
                case ZUserInfoItemTVCTypeBind:
                    [weakSelf showAccountManagerVC];
                    break;
                case ZUserInfoItemTVCTypeNews:
                    [weakSelf showMessageCenterVC];
                    break;
                case ZUserInfoItemTVCTypeMessage:
                    [weakSelf showMessageListVC];
                    break;
                default:
                    break;
            }
        }
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self setNavBarAlpha:0];
    
    self.lbTitleNav = [[ZLabel alloc] initWithFrame:CGRectMake(65, 0, APP_FRAME_WIDTH-130, APP_NAVIGATION_HEIGHT)];
    [self.lbTitleNav setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleNav setTextColor:TITLECOLOR];
    [self.lbTitleNav setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [[self navigationItem] setTitleView:self.lbTitleNav];
    [self.lbTitleNav setHidden:YES];
}
-(void)setLoginChange
{
    [self.tvMain setContentOffset:(CGPointZero)];
}
-(void)setRefreshHeader
{
    if (self.isLoaded) {
        return;
    }
    self.isLoaded = true;
    ZWEAKSELF
    [snsV1 postGetUserInfoWithUserId:kLoginUserId resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.isLoaded = false;
            [weakSelf.tvMain endRefreshHeader];
            if (resultModel) {
                [AppSetting setUserLogin:resultModel];
                [AppSetting save];
                [weakSelf.tvMain setViewDataWithModel:resultModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
            }
        });
    } errorBlock:^(NSString *msg) {
        weakSelf.isLoaded = false;
        [weakSelf.tvMain endRefreshHeader];
    }];
}
///加载数据
-(void)innerData
{
    [self.tvMain setViewDataWithModel:[AppSetting getUserLogin]];
    if (!kIsNeedLogin) {
        [self setRefreshHeader];
    }
}
///联系客服
-(void)showContactServiceVC
{
    [StatisticsManager event:kUser_Customer dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    //ZContactServiceViewController *itemVC = [[ZContactServiceViewController alloc] init];
    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    [itemVC setTitle:kCustomerService];
    [itemVC setWebUrl:[NSString stringWithFormat:@"%@%@", kWebServerUrl, kApp_WeChatServiceUrl]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///留言
-(void)showMessageListVC
{
    [StatisticsManager event:kUser_Message dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZMessageListViewController *itemVC = [[ZMessageListViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的问题
-(void)showQuestionVC
{
    [StatisticsManager event:kUser_MYQuestion dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZMyQuestionViewController *itemVC = [[ZMyQuestionViewController alloc] init];
    [itemVC setTitle:kMyQuestion];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的粉丝
-(void)showFansVC
{
    [StatisticsManager event:kUser_MYFans dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZMyFansViewController *itemVC = [[ZMyFansViewController alloc] init];
    [itemVC setTitle:kMyFans];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///等我回答
-(void)showWaitAnswerVC
{
    [StatisticsManager event:kUser_MYWaitAnswer dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZUserWaitAnswerViewController *itemVC = [[ZUserWaitAnswerViewController alloc] init];
    [itemVC setTitle:kWaitAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///编辑用户信息
-(void)showEditUserInfoVC
{
    [StatisticsManager event:kUser_Edit dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZEditUserInfoViewController *itemVC = [[ZEditUserInfoViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///消费记录
-(void)showPayVC
{
    [StatisticsManager event:kUser_ExpenseCalendar dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZUserConsumerViewController *itemVC = [[ZUserConsumerViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///购物车
-(void)showShopChatVC
{
    [StatisticsManager event:kUser_ShoppingCart dictionary:@{kObjectId: [AppSetting getUserId]}];
    
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
///下载管理
-(void)showDownloadManagerVC
{
    [StatisticsManager event:kUser_Download dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZUserDownloadViewController *itemVC = [AppDelegate getViewControllerWithIdentifier:@"VCUserDownloadSID"];
    //[[ZUserDownloadViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的余额
-(void)setShowAccountBalanceVC
{
    [StatisticsManager event:kUser_Balance dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的收藏
-(void)showCollectionVC
{
    [StatisticsManager event:kUser_MYCollection dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZMyCollectionViewController *itemVC = [[ZMyCollectionViewController alloc] init];
    [itemVC setTitle:kMyCollection];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的关注
-(void)showAttentionVC
{
    [StatisticsManager event:kUser_MYAtt dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZMyAttentionViewController *itemVC = [[ZMyAttentionViewController alloc] init];
    [itemVC setTitle:kMyAttention];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的答案
-(void)showMyAnswerVC
{
    [StatisticsManager event:kUser_MYAnswer dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZMyAnswerViewController *itemVC = [[ZMyAnswerViewController alloc] init];
    [itemVC setTitle:kMyAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的评论
-(void)showCommentVC
{
    [StatisticsManager event:kUser_MYComment dictionary:@{kObjectId: [AppSetting getUserId]}];
    
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
    [StatisticsManager event:kUser_NoticeCenter dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZNoticeListViewController *itemVC = [[ZNoticeListViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///意见反馈
-(void)showFeedbackVC
{
    [StatisticsManager event:kUser_FeebBack dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    //ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    //[itemVC setTitle:kFeedback];
    //[itemVC setWebUrl:[NSString stringWithFormat:@"%@%@", kWebServerUrl, kApp_BugShakeUrl]];
    ZUserFeedbackViewController *itemVC = [[ZUserFeedbackViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///设置
-(void)showSettingVC
{
    [StatisticsManager event:kUser_Setting dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZUserSettingViewController *itemVC = [[ZUserSettingViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///已购
-(void)setShowPurchaseVC
{
    [StatisticsManager event:kUser_Purchase dictionary:@{kObjectId: [AppSetting getUserId]}];
    
    ZPurchaseViewController *itemVC = [[ZPurchaseViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///购买记录
-(void)setShowConsumerVC
{
    
    ZUserConsumerViewController *itemVC = [[ZUserConsumerViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
