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

@interface ZUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZUserHeaderTVC *tvcHead;
@property (strong, nonatomic) ZUserNumberTVC *tvcNumber;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace0;
@property (strong, nonatomic) ZUserAnswerTVC *tvcAnswerCount;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZUserItemTVC *tvcCollection;
@property (strong, nonatomic) ZUserItemTVC *tvcMyAnswer;
@property (strong, nonatomic) ZUserItemTVC *tvcAttention;
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
    
    [self setTitle:@"个人"];
    
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
    
    self.tvcSpace2 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    self.tvcFeedback = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcFeedback" cellType:(ZUserItemTVCTypeFeedback)];
    self.tvcSetting = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcSetting" cellType:(ZUserItemTVCTypeSetting)];
    self.tvcSpace3 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace3"];
    
    // TODO:ZWW备注-1.0版本 无 通知中心和答案数量, 1.1版本 有 通知中心和答案数量
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
                         self.tvcCollection,self.tvcAttention,self.tvcMyAnswer,self.tvcSpace2,
                         self.tvcNoticeCenter,self.tvcFeedback,self.tvcSetting,self.tvcSpace3];
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
    [self.tvcMyAnswer setCellDataWithModel:resultModel];
    [self.tvcAnswerCount setCellDataWithModel:resultModel];
    [self.tvcNoticeCenter setCellDataWithModel:resultModel];
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
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_User_MYQuestion];
    
    ZMyQuestionViewController *itemVC = [[ZMyQuestionViewController alloc] init];
    [itemVC setTitle:@"我的问题"];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnFansClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_User_MYFans];
    
    ZMyFansViewController *itemVC = [[ZMyFansViewController alloc] init];
    [itemVC setTitle:@"我的粉丝"];
    [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnWaitAnswerClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_User_MYWaitAAnswer];
    
    ZUserWaitAnswerViewController *itemVC = [[ZUserWaitAnswerViewController alloc] init];
    [itemVC setTitle:@"等我回答"];
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
        //TODO:ZWW备注-添加友盟统计事件
        [MobClick event:kEvent_User_Edit];
        
        [self showEditUserInfoVC];
    } else if ([cell isKindOfClass:[ZUserItemTVC class]]){
        ZUserItemTVCType type = [(ZUserItemTVC*)cell type];
        switch (type) {
            case ZUserItemTVCTypeCollection://收藏
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_MYCollection];
                
                ZMyCollectionViewController *itemVC = [[ZMyCollectionViewController alloc] init];
                [itemVC setTitle:@"我的收藏"];
                [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeAnswer://回答
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_MYAnswer];
                
                ZMyAnswerViewController *itemVC = [[ZMyAnswerViewController alloc] init];
                [itemVC setTitle:@"我的回答"];
                [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeAttention://关注
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_MYAtt];
                
                ZMyAttentionViewController *itemVC = [[ZMyAttentionViewController alloc] init];
                [itemVC setTitle:@"我的关注"];
                [itemVC setViewDataWithModel:[AppSetting getUserLogin]];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeFeedback://反馈
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_FeebBack];
                
                ZUserFeedbackViewController *itemVC = [[ZUserFeedbackViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeSetting://设置
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting];
                
                ZUserSettingViewController *itemVC = [[ZUserSettingViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeAgreement://协议
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_Agreement];
                
                ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                [itemVC setTitle:kCUseAgreement];
                [itemVC setWebUrl:kApp_ProtocolUrl];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserItemTVCTypeNoticeCenter://通知中心
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_NoticeCenter];
                
                ZNoticeListViewController *itemVC = [[ZNoticeListViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            default: break;
        }
    }
}

@end
