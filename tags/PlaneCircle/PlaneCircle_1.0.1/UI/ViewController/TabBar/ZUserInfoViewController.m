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
#import "ZUserNoticeViewController.h"

@interface ZUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZUserHeaderTVC *tvcHead;
@property (strong, nonatomic) ZUserNumberTVC *tvcNumber;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZUserItemTVC *tvcCollection;
@property (strong, nonatomic) ZUserItemTVC *tvcAnswer;
@property (strong, nonatomic) ZUserItemTVC *tvcAttention;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace2;
@property (strong, nonatomic) ZUserItemTVC *tvcFeedback;
@property (strong, nonatomic) ZUserItemTVC *tvcSetting;
@property (strong, nonatomic) ZUserItemTVC *tvcNoticeCenter;
//@property (strong, nonatomic) ZUserItemTVC *tvcAgreement;

@property (strong, nonatomic) ZTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZUserInfoViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"个人"];
    
    [self registerLoginChangeNotification];
    
    [self registerUserInfoChangeNotification];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerData];
}

-(void)setViewFrame
{
    [self.tvMain setFrame:VIEW_TABB_FRAME];
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
    OBJC_RELEASE(_tvcHead);
    OBJC_RELEASE(_tvcNumber);
    OBJC_RELEASE(_tvcSpace1);
    OBJC_RELEASE(_tvcCollection);
    OBJC_RELEASE(_tvcAnswer);
    OBJC_RELEASE(_tvcAttention);
    OBJC_RELEASE(_tvcSpace2);
    OBJC_RELEASE(_tvcFeedback);
    OBJC_RELEASE(_tvcSetting);
    OBJC_RELEASE(_tvcNoticeCenter);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcHead = [[ZUserHeaderTVC alloc] initWithReuseIdentifier:@"tvcHead"];
    self.tvcNumber = [[ZUserNumberTVC alloc] initWithReuseIdentifier:@"tvcNumber"];
    self.tvcSpace1 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcCollection = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcCollection" cellType:(ZUserItemTVCTypeCollection)];
    self.tvcAnswer = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcAnswer" cellType:(ZUserItemTVCTypeAnswer)];
    self.tvcAttention = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcAttention" cellType:(ZUserItemTVCTypeAttention)];
    self.tvcSpace2 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    self.tvcFeedback = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcFeedback" cellType:(ZUserItemTVCTypeFeedback)];
    self.tvcSetting = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcSetting" cellType:(ZUserItemTVCTypeSetting)];
    
    // TODO:ZWW备注-1.0版本 无 通知中心, 1.1版本 有 通知中心
    if ([Utils isVersion100]) {
        self.arrMain = @[self.tvcHead,self.tvcNumber,self.tvcSpace1,
                         self.tvcCollection,self.tvcAnswer,self.tvcAttention,self.tvcSpace2,
                         self.tvcFeedback,self.tvcSetting];
    } else {
        self.tvcNoticeCenter = [[ZUserItemTVC alloc] initWithReuseIdentifier:@"tvcNoticeCenter" cellType:(ZUserItemTVCTypeNoticeCenter)];
        self.arrMain = @[self.tvcHead,self.tvcNumber,self.tvcSpace1,
                         self.tvcCollection,self.tvcAnswer,self.tvcAttention,self.tvcSpace2,
                         self.tvcNoticeCenter,self.tvcFeedback,self.tvcSetting];
    }
    
    ZNavigationBarView *barView = [[ZNavigationBarView alloc] initWithFrame:VIEW_NAVV_FRAME];
    [barView setTitle:self.title];
    [barView setHiddenBackButton:YES];
    [barView setTag:10001000];
    [self.view addSubview:barView];
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    [self innerEvent];
}

-(void)innerData
{
    [self setUserInfoChange];
    ZWEAKSELF
    [sns postGetUserInfoWithUserId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:kResultKey]];
            if (dicUser && [dicUser isKindOfClass:[NSDictionary class]]) {
                
                NSString *myWaitAnsCount = [result objectForKey:@"myWaitAnsCount"];
                NSString *myQuesCount = [result objectForKey:@"myQuesCount"];
                NSString *myFunsCount = [result objectForKey:@"myFunsCount"];
                NSString *myWaitAnsCountBy = [result objectForKey:@"myWaitAnsCountBy"];
                
                if (myWaitAnsCount && ![myWaitAnsCount isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:myWaitAnsCount forKey:@"myWaitAnsCount"];
                }
                if (myQuesCount && ![myQuesCount isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:myQuesCount forKey:@"myQuesCount"];
                }
                if (myFunsCount && ![myFunsCount isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:myFunsCount forKey:@"myFunsCount"];
                }
                if (myWaitAnsCountBy && ![myWaitAnsCountBy isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:myWaitAnsCountBy forKey:@"myWaitAnsCountBy"];
                }
                
                ModelUser *modelUser = [[ModelUser alloc] initWithCustom:dicUser];
                
                [AppSetting setUserLogin:modelUser];
                [AppSetting save];
                
                [weakSelf.tvcHead setCellDataWithModel:modelUser];
                [weakSelf.tvcNumber setCellDataWithModel:modelUser];
            }
        });
    } errorBlock:nil];
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
}

-(void)setLoginChange
{
    [self setUserInfoChange];
}

-(void)setUserInfoChange
{
    [self.tvcHead setCellDataWithModel:[AppSetting getUserLogin]];
    [self.tvcNumber setCellDataWithModel:[AppSetting getUserLogin]];
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
        
        ZEditUserInfoViewController *uiVC = [[ZEditUserInfoViewController alloc] init];
        [uiVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:uiVC animated:YES];
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
                
                ZUserNoticeViewController *itemVC = [[ZUserNoticeViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            default: break;
        }
    }
}

@end
