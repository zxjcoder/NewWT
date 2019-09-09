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
#import "ZAccountManagerViewController.h"
#import "ZPurchaseViewController.h"

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
    [self.tvMain setOnQuestionClick:^{
        [weakSelf showQuestionVC];
    }];
    [self.tvMain setOnAnswerClick:^{
        [weakSelf showWaitAnswerVC];
    }];
    [self.tvMain setOnFansClick:^{
        [weakSelf showFansVC];
    }];
    [self.tvMain setOnUserPhotoClick:^{
        [weakSelf showEditUserInfoVC];
    }];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf showLoginVC];
    }];
    [self.tvMain setOnUserInfoCenterItemClick:^(ZUserInfoCenterItemType type) {
        switch (type) {
            case ZUserInfoCenterItemTypePurchaseRecord:
                [weakSelf showPayVC];
                break;
            case ZUserInfoCenterItemTypePay:
                [weakSelf showPayVC];
                break;
            case ZUserInfoCenterItemTypeBalance:
                [weakSelf showBalanceVC];
                break;
            case ZUserInfoCenterItemTypeCollection:
                [weakSelf showCollectionVC];
                break;
            case ZUserInfoCenterItemTypeAttention:
                [weakSelf showAttentionVC];
                break;
            case ZUserInfoCenterItemTypeAnswer:
                [weakSelf showMyAnswerVC];
                break;
            case ZUserInfoCenterItemTypeComment:
                [weakSelf showCommentVC];
                break;
            case ZUserInfoCenterItemTypeTask:
                [weakSelf showTaskCenterVC];
                break;
            case ZUserInfoCenterItemTypeMessage:
                [weakSelf showMessageCenterVC];
                break;
            case ZUserInfoCenterItemTypeFeedback:
                [weakSelf showFeedbackVC];
                break;
            case ZUserInfoCenterItemTypeSetting:
                [weakSelf showSettingVC];
                break;
            case ZUserInfoCenterItemTypeShoppingCart:
                [weakSelf showShopChatVC];
                break;
            case ZUserInfoCenterItemTypeAccount:
                [weakSelf showAccountManagerVC];
                break;
            case ZUserInfoCenterItemTypeDownload:
                [weakSelf showDownloadManagerVC];
                break;
            case ZUserInfoCenterItemTypePurchase:
                [weakSelf setShowPurchaseVC];
                break;
            default: break;
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
    ZMyQuestionViewController *itemVC = [[ZMyQuestionViewController alloc] init];
    [itemVC setTitle:kMyQuestion];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的粉丝
-(void)showFansVC
{
    ZMyFansViewController *itemVC = [[ZMyFansViewController alloc] init];
    [itemVC setTitle:kMyFans];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///等我回答
-(void)showWaitAnswerVC
{
    ZUserWaitAnswerViewController *itemVC = [[ZUserWaitAnswerViewController alloc] init];
    [itemVC setTitle:kWaitAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///编辑用户信息
-(void)showEditUserInfoVC
{
    ZEditUserInfoViewController *itemVC = [[ZEditUserInfoViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///消费记录
-(void)showPayVC
{
    ZUserConsumerViewController *itemVC = [[ZUserConsumerViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///购物车
-(void)showShopChatVC
{
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
    ZUserDownloadViewController *itemVC = [[ZUserDownloadViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的余额
-(void)showBalanceVC
{
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的收藏
-(void)showCollectionVC
{
    ZMyCollectionViewController *itemVC = [[ZMyCollectionViewController alloc] init];
    [itemVC setTitle:kMyCollection];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的关注
-(void)showAttentionVC
{
    ZMyAttentionViewController *itemVC = [[ZMyAttentionViewController alloc] init];
    [itemVC setTitle:kMyAttention];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的答案
-(void)showMyAnswerVC
{
    ZMyAnswerViewController *itemVC = [[ZMyAnswerViewController alloc] init];
    [itemVC setTitle:kMyAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的评论
-(void)showCommentVC
{
    ZMyCommentViewController *itemVC = [[ZMyCommentViewController alloc] init];
    [itemVC setTitle:kMyComment];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的任务中心
-(void)showTaskCenterVC
{
    //ZTaskCenterViewController *itemVC = [[ZTaskCenterViewController alloc] init];
    //[itemVC setPreVC:self];
    //[itemVC setHidesBottomBarWhenPushed:YES];
    //[self.navigationController pushViewController:itemVC animated:YES];
}
///我的消息中心
-(void)showMessageCenterVC
{
    ZNoticeListViewController *itemVC = [[ZNoticeListViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///意见反馈
-(void)showFeedbackVC
{
    ZUserFeedbackViewController *itemVC = [[ZUserFeedbackViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///设置
-(void)showSettingVC
{
    ZUserSettingViewController *itemVC = [[ZUserSettingViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///已购
-(void)setShowPurchaseVC
{
    ZPurchaseViewController *itemVC = [[ZPurchaseViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
