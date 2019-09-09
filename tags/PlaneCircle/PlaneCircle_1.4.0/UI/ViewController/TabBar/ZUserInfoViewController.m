//
//  ZUserInfoViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoViewController.h"
#import "ZUserHeaderTVC.h"
#import "ZUserItemTVC.h"
#import "ZUserNumberTVC.h"
#import "ZSpaceTVC.h"
#import "ZUserAnswerTVC.h"
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

@interface ZUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZUserHeaderTVC *tvcHead;
@property (strong, nonatomic) ZUserNumberTVC *tvcNumber;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace0;
@property (strong, nonatomic) ZUserAnswerTVC *tvcAnswerCount;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZUserItemTVC *tvcCollection;
@property (strong, nonatomic) ZUserItemTVC *tvcMyAnswer;
@property (strong, nonatomic) ZUserItemTVC *tvcAttention;
@property (strong, nonatomic) ZUserItemTVC *tvcComment;
@property (strong, nonatomic) ZUserItemTVC *tvcTaskCenter;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace2;
@property (strong, nonatomic) ZUserItemTVC *tvcFeedback;
@property (strong, nonatomic) ZUserItemTVC *tvcSetting;
@property (strong, nonatomic) ZUserItemTVC *tvcNoticeCenter;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace3;

@property (strong, nonatomic) ZTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;
///是否设置
@property (assign, nonatomic) BOOL isLoginOut;

@end

@implementation ZUserInfoViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kIndividual];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _isLoginOut = ![AppSetting getUserLogin];
    
    [self setTableViewData];
    
    if (!_isLoginOut) {
        
        [self innerData];
    }
}

- (void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    OBJC_RELEASE(_tvcHead);
    OBJC_RELEASE(_tvcNumber);
    OBJC_RELEASE(_tvcSpace0);
    OBJC_RELEASE(_tvcAnswerCount);
    OBJC_RELEASE(_tvcSpace1);
    OBJC_RELEASE(_tvcCollection);
    OBJC_RELEASE(_tvcMyAnswer);
    OBJC_RELEASE(_tvcAttention);
    OBJC_RELEASE(_tvcComment);
    OBJC_RELEASE(_tvcTaskCenter);
    OBJC_RELEASE(_tvcSpace2);
    OBJC_RELEASE(_tvcFeedback);
    OBJC_RELEASE(_tvcSetting);
    OBJC_RELEASE(_tvcNoticeCenter);
    OBJC_RELEASE(_tvcSpace3);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZNavigationBarView *barView = [[ZNavigationBarView alloc] initWithFrame:VIEW_NAVV_FRAME];
    [barView setTitle:self.title];
    [barView setHiddenBackButton:YES];
    [barView setTag:10001000];
    [self.view addSubview:barView];
    
    self.tvcHead = [[ZUserHeaderTVC alloc] initWithReuseIdentifier:@"tvcHead"];
    self.tvcNumber = [[ZUserNumberTVC alloc] initWithReuseIdentifier:@"tvcNumber"];
    self.tvcSpace0 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace0"];
    
    self.tvcSpace1 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcCollection = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcCollection" cellType:(ZUserItemTVCTypeCollection)];
    self.tvcMyAnswer = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcMyAnswer" cellType:(ZUserItemTVCTypeAnswer)];
    self.tvcAttention = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcAttention" cellType:(ZUserItemTVCTypeAttention)];
    self.tvcComment = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcComment" cellType:(ZUserItemTVCTypeComment)];
    self.tvcTaskCenter = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcTaskCenter" cellType:(ZUserItemTVCTypeTaskCenter)];
    
    self.tvcSpace2 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    self.tvcFeedback = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcFeedback" cellType:(ZUserItemTVCTypeFeedback)];
    self.tvcSetting = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcSetting" cellType:(ZUserItemTVCTypeSetting)];
    self.tvcSpace3 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace3"];
    
    self.tvcAnswerCount = [[ZUserAnswerTVC alloc] initWithReuseIdentifier:@"tvcAnswerCount"];
    self.tvcNoticeCenter = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcNoticeCenter" cellType:(ZUserItemTVCTypeNoticeCenter)];
    
    self.tvMain = [[ZTableView alloc] initWithFrame:VIEW_TABB_FRAME];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        switch (state) {
            case ZBackgroundStateLoginNull:
            {
                [weakSelf showLoginVC];
                break;
            }
            default: break;
        }
    }];
    
    [self innerEvent];
}

-(void)setTableViewData
{
    if (!_isLoginOut) {
        self.arrMain = @[self.tvcHead,self.tvcNumber,self.tvcSpace0,
                         self.tvcAnswerCount,self.tvcSpace1,
                         self.tvcCollection,self.tvcAttention,self.tvcMyAnswer,self.tvcComment,self.tvcSpace2,
                         self.tvcTaskCenter,self.tvcNoticeCenter,self.tvcFeedback,self.tvcSetting,self.tvcSpace3];
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
    } else {
        self.arrMain = nil;
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    }
    GCDMainBlock(^{
        [self.tvMain reloadData];
    });
}

-(void)innerData
{
    [self setUserInfoChange:[AppSetting getUserLogin]];
    
    ZWEAKSELF
    [sns postGetUserInfoWithUserId:[AppSetting getUserDetauleId] resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
        GCDMainBlock(^{
            if (resultModel) {
                [AppSetting setUserLogin:resultModel];
                [AppSetting save];
                
                [weakSelf setUserInfoChange:resultModel];
                
                [sqlite setLocalTaskArrayWithArray:[result objectForKey:@"myTask"] userId:resultModel.userId];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ZAppNumberChangeNotification object:nil];
            }
        });
    } errorBlock:nil];
}
///注销设置UI
-(void)setChangeUserLogin:(NSNumber *)isLoginOut
{
    _isLoginOut = isLoginOut.boolValue;
}

-(void)setUserInfoChange:(ModelUser *)resultModel
{
    [self.tvcHead setCellDataWithModel:resultModel];
    [self.tvcNumber setCellDataWithModel:resultModel];
    [self.tvcAnswerCount setCellDataWithModel:resultModel];
    [self.tvcNoticeCenter setCellDataWithModel:resultModel];
    [self.tvcComment setCellDataWithModel:resultModel];
}
-(void)innerEvent
{
    ZWEAKSELF
    ///我的问题
    [self.tvcNumber setOnQuestionClick:^{
        [weakSelf btnQuestionClick];
    }];
    //我的粉丝
    [self.tvcNumber setOnFansClick:^{
        [weakSelf btnFansClick];
    }];
    //我的回答
    [self.tvcNumber setOnAnswerClick:^{
        [weakSelf btnWaitAnswerClick];
    }];
    
    [self checkNickNameChange];
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

-(void)btnQuestionClick
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYQuestion category:kCategory_User];
    
    ZMyQuestionViewController *itemVC = [[ZMyQuestionViewController alloc] init];
    [itemVC setTitle:kMyQuestion];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnFansClick
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYFans category:kCategory_User];
    
    ZMyFansViewController *itemVC = [[ZMyFansViewController alloc] init];
    [itemVC setTitle:kMyFans];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnWaitAnswerClick
{
    //添加统计事件
    [StatisticsManager event:kEvent_User_MYWaitAAnswer category:kCategory_User];
    
    ZUserWaitAnswerViewController *itemVC = [[ZUserWaitAnswerViewController alloc] init];
    [itemVC setTitle:kWaitAnswer];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [self.navigationController pushViewController:itemVC animated:YES];
}
-(void)showEditUserInfoVC
{
    ZEditUserInfoViewController *itemVC = [[ZEditUserInfoViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.arrMain objectAtIndex:indexPath.row];
    return [cell getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrMain objectAtIndex:indexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.arrMain objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[ZUserHeaderTVC class]]) {
        //添加统计事件
        [StatisticsManager event:kEvent_User_Edit category:kCategory_User];
        
        [self showEditUserInfoVC];
    } else if ([cell isKindOfClass:[ZUserItemTVC class]]){
        ZUserItemTVCType type = [(ZUserItemTVC*)cell type];
        switch (type) {
            case ZUserItemTVCTypeCollection://收藏
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_MYCollection category:kCategory_User];
                
                ZMyCollectionViewController *itemVC = [[ZMyCollectionViewController alloc] init];
                [itemVC setTitle:kMyCollection];
                [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeAnswer://回答
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_MYAnswer category:kCategory_User];
                
                ZMyAnswerViewController *itemVC = [[ZMyAnswerViewController alloc] init];
                [itemVC setTitle:kMyAnswer];
                [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeAttention://关注
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_MYAtt category:kCategory_User];
                
                ZMyAttentionViewController *itemVC = [[ZMyAttentionViewController alloc] init];
                [itemVC setTitle:kMyAttention];
                [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeComment://评论
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_MYComment category:kCategory_User];
                
                ZMyCommentViewController *itemVC = [[ZMyCommentViewController alloc] init];
                [itemVC setTitle:kMyComment];
                [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeFeedback://反馈
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_FeebBack category:kCategory_User];
                
                ZUserFeedbackViewController *itemVC = [[ZUserFeedbackViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeSetting://设置
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_Setting category:kCategory_User];
                
                ZUserSettingViewController *itemVC = [[ZUserSettingViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeAgreement://协议
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_Setting_Agreement category:kCategory_User];
                
                ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                [itemVC setTitle:kMyAgreement];
                [itemVC setWebUrl:kApp_ProtocolUrl];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeNoticeCenter://通知中心
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_NoticeCenter category:kCategory_User];
                
                ZNoticeListViewController *itemVC = [[ZNoticeListViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeTaskCenter://任务中心
            {
                ZTaskCenterViewController *itemVC = [[ZTaskCenterViewController alloc] init];
                [itemVC setPreVC:self];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            default: break;
        }
    }
}

@end
