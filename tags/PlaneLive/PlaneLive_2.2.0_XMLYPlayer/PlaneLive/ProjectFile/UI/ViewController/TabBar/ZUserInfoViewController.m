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
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerData];
    [self.lbTitleNav setText:[AppSetting getUserLogin].nickname];
    [self setNavigationTintColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTintColor:NAVIGATIONTINTCOLOR];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        //[self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_lbTitleNav);
    
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.tvMain = [[ZUserInfoTableView alloc] initWithFrame:VIEW_MAIN_FRAME];
    [self.tvMain setOnContentOffsetY:^(CGFloat alpha) {
        [weakSelf setNavLastAlpha:alpha];
        
        [weakSelf.lbTitleNav setHidden:alpha<0.85];
        
        [weakSelf setNavBarAlpha:alpha];
        
        [weakSelf setNavigationTintColor];
    }];
    [self.tvMain setOnUserPhotoClick:^{
        [weakSelf showEditUserInfoVC];
    }];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf showLoginVC];
    }];
    [self.tvMain setOnBalanceClick:^{
        [weakSelf setShowAccountBalanceVC];;
    }];
    [self.tvMain setOnPurchaseRecordClick:^{
        [weakSelf setShowConsumerVC];
    }];
    [self.tvMain setOnShopCartClick:^{
        [weakSelf showShopChatVC];
    }];
    [self.tvMain setOnUserInfoGridClick:^(ZUserInfoGridCVCType type) {
        switch (type) {
            case ZUserInfoGridCVCTypeColl:
                [weakSelf showCollectionVC];
                break;
            case ZUserInfoGridCVCTypeAtt:
                [weakSelf showAttentionVC];
                break;
            case ZUserInfoGridCVCTypeDownload:
                [weakSelf showDownloadManagerVC];
                break;
            case ZUserInfoGridCVCTypeMessage:
                [weakSelf showMessageListVC];
                break;
            case ZUserInfoGridCVCTypeWaitAnswer:
                [weakSelf showWaitAnswerVC];
                break;
            case ZUserInfoGridCVCTypeMessageCenter:
                [weakSelf showMessageCenterVC];
                break;
            default:
                break;
        }
    }];
    [self.tvMain setOnUserInfoItemClick:^(ZUserInfoItemTVCType type) {
        switch (type) {
            case ZUserInfoItemTVCQuestion:
                [weakSelf showQuestionVC];
                break;
            case ZUserInfoItemTVCAnswer:
                [weakSelf showMyAnswerVC];
                break;
            case ZUserInfoItemTVCComment:
                [weakSelf showCommentVC];
                break;
            case ZUserInfoItemTVCFans:
                [weakSelf showFansVC];
                break;
            case ZUserInfoItemTVCFeedback:
                [weakSelf showFeedbackVC];
                break;
            case ZUserInfoItemTVCServer:
                [weakSelf showContactServiceVC];
                break;
            case ZUserInfoItemTVCAccount:
                [weakSelf showAccountManagerVC];
                break;
            case ZUserInfoItemTVCSetting:
                [weakSelf showSettingVC];
                break;
            default:
                break;
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
    
    [self checkNickNameChange];
}
///设置导航栏颜色
-(void)setNavigationTintColor
{
    
}
///加载数据
-(void)innerData
{
    if ([AppSetting getAutoLogin]) {
        [self.tvMain setViewDataWithModel:[AppSetting getUserLogin]];
        ZWEAKSELF
        [snsV1 postGetUserInfoWithUserId:[AppSetting getUserDetauleId] resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
            GCDMainBlock(^{
                if (resultModel) {
                    [AppSetting setUserLogin:resultModel];
                    [AppSetting save];
                    [weakSelf.tvMain setViewDataWithModel:resultModel];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
                }
            });
        } errorBlock:nil];
    } else {
        [self.tvMain setViewDataWithModel:nil];
    }
}
-(void)setUserInfoChange
{
    [super setUserInfoChange];
    
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
///联系客服
-(void)showContactServiceVC
{
    ZContactServiceViewController *itemVC = [[ZContactServiceViewController alloc] init];
    [itemVC setTitle:kCustomerService];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///留言
-(void)showMessageListVC
{
    ZMessageListViewController *itemVC = [[ZMessageListViewController alloc] init];
    [itemVC setTitle:kMessage];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
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
///消费记录
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
///下载管理
-(void)showDownloadManagerVC
{
    [StatisticsManager event:kUser_ExpenseCalendar];
    
    ZUserDownloadViewController *itemVC = [AppDelegate getViewControllerWithIdentifier:@"VCUserDownloadSID"];
    //[[ZUserDownloadViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的余额
-(void)setShowAccountBalanceVC
{
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
///购买记录
-(void)setShowConsumerVC
{
    ZUserConsumerViewController *itemVC = [[ZUserConsumerViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
