//
//  ZUserConsumerViewController.m
//  PlaneLive
//
//  Created by Daniel on 13/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserConsumerViewController.h"
#import "ZUserInfoConsumption.h"

@interface ZUserConsumerViewController ()

@property (strong, nonatomic) ZUserInfoConsumption *viewMain;
///已购买
@property (assign, nonatomic) int pageNumPay;
///已充值
@property (assign, nonatomic) int pageNumRecharge;
///打赏
@property (assign, nonatomic) int pageNumReward;

@end

@implementation ZUserConsumerViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kPurchaseRecord];
    
    [self innerInit];
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
    OBJC_RELEASE(_viewMain);
    
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
    self.viewMain = [[ZUserInfoConsumption alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.viewMain setOnBackgroundPayClick:^(ZBackgroundState state) {
        [weakSelf setRefreshPayHeader];
    }];
    [self.viewMain setOnRefreshPayHeader:^{
        [weakSelf setRefreshPayHeader];
    }];
    [self.viewMain setOnRefreshPayFooter:^{
        [weakSelf setRefreshPayFooter];
    }];
    
    [self.viewMain setOnBackgroundRechargeClick:^(ZBackgroundState state) {
        [weakSelf setRefreshRechargeHeader];
    }];
    [self.viewMain setOnRefreshRechargeHeader:^{
        [weakSelf setRefreshRechargeHeader];
    }];
    [self.viewMain setOnRefreshRechargeFooter:^{
        [weakSelf setRefreshRechargeFooter];
    }];
    
    [self.viewMain setOnBackgroundRewardClick:^(ZBackgroundState state) {
        [weakSelf setRefreshRewardHeader];
    }];
    [self.viewMain setOnRefreshRewardHeader:^{
        [weakSelf setRefreshRewardHeader];
    }];
    [self.viewMain setOnRefreshRewardFooter:^{
        [weakSelf setRefreshRewardFooter];
    }];
    [self.view addSubview:self.viewMain];
    
    [super innerInit];
    
    [self innerData];
}

-(void)innerData
{
    NSArray *arrPay = [sqlite getLocalSubscribePlayArrayWithUserId:[AppSetting getUserDetauleId]];
    if (arrPay && arrPay.count > 0) {
        [self.viewMain setPayViewDataWithArray:arrPay isHeader:YES];
    } else {
        [self.viewMain setPayBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    NSArray *arrRecharge = [sqlite getLocalRechargeRecordArrayWithUserId:[AppSetting getUserDetauleId]];
    if (arrRecharge && arrRecharge.count > 0) {
        [self.viewMain setRechargeViewDataWithArray:arrRecharge isHeader:YES];
    } else {
        [self.viewMain setRechargeBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    
    NSArray *arrReward = [sqlite getLocalRewardRecordArrayWithUserId:[AppSetting getUserDetauleId]];
    if (arrReward && arrReward.count > 0) {
        [self.viewMain setRewardViewDataWithArray:arrReward isHeader:YES];
    } else {
        [self.viewMain setRewardBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    
    [self setRefreshPayHeader];
    
    [self setRefreshRechargeHeader];
    
    [self setRefreshRewardHeader];
}
///刷新已购买顶部数据
-(void)setRefreshPayHeader
{
    ZWEAKSELF
    self.pageNumPay = 1;
    [snsV2 getMySubscribePlayArrayWithPageNum:self.pageNumPay resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain endRefreshPayHeader];
        [weakSelf.viewMain setPayViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalSubscribePlayWithArray:arrResult userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshPayHeader];
        [weakSelf.viewMain setPayViewDataWithArray:nil isHeader:YES];
    }];
}
///刷新已购买底部数据
-(void)setRefreshPayFooter
{
    ZWEAKSELF
    [snsV2 getMySubscribePlayArrayWithPageNum:self.pageNumPay+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNumPay += 1;
        [weakSelf.viewMain endRefreshPayFooter];
        [weakSelf.viewMain setPayViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshPayFooter];
    }];
}
///刷新已充值顶部数据
-(void)setRefreshRechargeHeader
{
    ZWEAKSELF
    self.pageNumRecharge = 1;
    [snsV2 getMyRechargeRecordArrayWithPageNum:self.pageNumRecharge resultBlock:^(NSArray *arrResult, NSDictionary *result) {
       
        [weakSelf.viewMain endRefreshRechargeHeader];
        [weakSelf.viewMain setRechargeViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalRechargeRecordWithArray:arrResult userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshRechargeHeader];
        [weakSelf.viewMain setRechargeViewDataWithArray:nil isHeader:YES];
    }];
}
///刷新已充值底部数据
-(void)setRefreshRechargeFooter
{
    ZWEAKSELF
    [snsV2 getMyRechargeRecordArrayWithPageNum:self.pageNumRecharge+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNumRecharge += 1;
        [weakSelf.viewMain endRefreshRechargeFooter];
        [weakSelf.viewMain setRechargeViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshRechargeFooter];
    }];
}
///刷新打赏顶部数据
-(void)setRefreshRewardHeader
{
    ZWEAKSELF
    self.pageNumReward = 1;
    [snsV2 getMyRewardRecordArrayWithPageNum:self.pageNumReward resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.viewMain endRefreshRewardHeader];
        [weakSelf.viewMain setRewardViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalRewardRecordWithArray:arrResult userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshRewardHeader];
        [weakSelf.viewMain setRewardViewDataWithArray:nil isHeader:YES];
    }];
}
///刷新打赏底部数据
-(void)setRefreshRewardFooter
{
    ZWEAKSELF
    [snsV2 getMyRewardRecordArrayWithPageNum:self.pageNumReward+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNumReward += 1;
        [weakSelf.viewMain endRefreshRewardFooter];
        [weakSelf.viewMain setRewardViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewMain endRefreshRewardFooter];
    }];
}

@end
