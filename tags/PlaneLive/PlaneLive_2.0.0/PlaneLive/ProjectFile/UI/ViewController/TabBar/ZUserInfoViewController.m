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
#import "ZTaskCenterViewController.h"
#import "ZAccountBalanceViewController.h"
#import "ZUserConsumerViewController.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_tvMain);
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
        [DataOper postGetUserInfoWithUserId:[AppSetting getUserDetauleId] resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
            GCDMainBlock(^{
                if (resultModel) {
                    [AppSetting setUserLogin:resultModel];
                    
                    [AppSetting save];
                    
                    [weakSelf.tvMain setViewDataWithModel:resultModel];
                    
                    [sqlite setLocalTaskArrayWithArray:[result objectForKey:@"myTask"] userId:resultModel.userId];
                    
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
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYQuestion category:kCategory_User];
    
    ZMyQuestionViewController *itemVC = [[ZMyQuestionViewController alloc] init];
    [itemVC setTitle:kMyQuestion];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的粉丝
-(void)showFansVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYFans category:kCategory_User];
    
    ZMyFansViewController *itemVC = [[ZMyFansViewController alloc] init];
    [itemVC setTitle:kMyFans];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///等我回答
-(void)showWaitAnswerVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYWaitAAnswer category:kCategory_User];
    
    ZUserWaitAnswerViewController *itemVC = [[ZUserWaitAnswerViewController alloc] init];
    [itemVC setTitle:kWaitAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///编辑用户信息
-(void)showEditUserInfoVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_Edit category:kCategory_User];
    
    ZEditUserInfoViewController *itemVC = [[ZEditUserInfoViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///消费记录
-(void)showPayVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYPay category:kCategory_User];
    
    ZUserConsumerViewController *itemVC = [[ZUserConsumerViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的余额
-(void)showBalanceVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYBalance category:kCategory_User];
    
    ZAccountBalanceViewController *itemVC = [[ZAccountBalanceViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的收藏
-(void)showCollectionVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYCollection category:kCategory_User];
    
    ZMyCollectionViewController *itemVC = [[ZMyCollectionViewController alloc] init];
    [itemVC setTitle:kMyCollection];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的关注
-(void)showAttentionVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYAtt category:kCategory_User];
    
    ZMyAttentionViewController *itemVC = [[ZMyAttentionViewController alloc] init];
    [itemVC setTitle:kMyAttention];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的答案
-(void)showMyAnswerVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYAnswer category:kCategory_User];
    
    ZMyAnswerViewController *itemVC = [[ZMyAnswerViewController alloc] init];
    [itemVC setTitle:kMyAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的评论
-(void)showCommentVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYComment category:kCategory_User];
    
    ZMyCommentViewController *itemVC = [[ZMyCommentViewController alloc] init];
    [itemVC setTitle:kMyComment];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的任务中心
-(void)showTaskCenterVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_TaskCenter category:kCategory_User];
    
    ZTaskCenterViewController *itemVC = [[ZTaskCenterViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///我的消息中心
-(void)showMessageCenterVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_NoticeCenter category:kCategory_User];
    
    ZNoticeListViewController *itemVC = [[ZNoticeListViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///意见反馈
-(void)showFeedbackVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_FeebBack category:kCategory_User];
    
    ZUserFeedbackViewController *itemVC = [[ZUserFeedbackViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///设置
-(void)showSettingVC
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_Setting category:kCategory_User];
    
    ZUserSettingViewController *itemVC = [[ZUserSettingViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
