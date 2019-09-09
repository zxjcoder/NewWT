//
//  ZRankViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankViewController.h"
#import "ZRankSearchView.h"
#import "ZRankTableView.h"
#import "ZRankSearchTableView.h"

#import "ZRankDetailViewController.h"
#import "ZRankUserViewController.h"
#import "ZRankCompanyViewController.h"

static NSString *kRankLocalKey = @"RankHotKey";

@interface ZRankViewController ()
{
    int _rankStatus;
}
@property (strong, nonatomic) NSString *lastContent;

@property (strong, nonatomic) ZRankSearchView *viewSearch;

@property (strong, nonatomic) ZRankTableView *tvMain;

@property (strong, nonatomic) ZRankSearchTableView *tvSearch;

@property (assign, nonatomic) CGRect mainFrame;

@property (assign, nonatomic) CGRect searchFrame;

@end

@implementation ZRankViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"榜单"];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
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
    OBJC_RELEASE(_viewSearch);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_tvSearch);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    /// 榜单状态
    _rankStatus = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION].rankStatus;
    if (_rankStatus == 0) {
        self.viewSearch = [[ZRankSearchView alloc] initWithFrame:VIEW_NAVV_FRAME];
        //取消搜索
        [self.viewSearch setOnClearClick:^{
            [weakSelf.tvMain setScrollsToTop:YES];
            [weakSelf.tvSearch setScrollsToTop:NO];
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [weakSelf.tvSearch setAlpha:0];
            } completion:^(BOOL finished) {
                [weakSelf.tvSearch setHidden:YES];
            }];
        }];
        //开始搜索
        [self.viewSearch setOnBeginEditClick:^{
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_Rank_Search];
            
            [weakSelf.tvMain setScrollsToTop:NO];
            [weakSelf.tvSearch setScrollsToTop:YES];
            
            [weakSelf.tvSearch setHidden:NO];
            [weakSelf.tvSearch setAlpha:0];
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [weakSelf.tvSearch setAlpha:1];
            } completion:^(BOOL finished) {
                if (weakSelf.lastContent.length == 0) {
                    [weakSelf btnSearchWithContent:kEmpty];
                }
            }];
        }];
        //搜索按钮点击
        [self.viewSearch setOnSearchClick:^(NSString *content) {
            [weakSelf setLastContent:content];
            [weakSelf btnSearchWithContent:content];
        }];
        [self.view addSubview:self.viewSearch];
    } else {
        ZNavigationBarView *barView = [[ZNavigationBarView alloc] initWithFrame:VIEW_NAVV_FRAME];
        [barView setTitle:self.title];
        [barView setHiddenBackButton:YES];
        [barView setTag:10001000];
        [self.view addSubview:barView];
    }
    
    self.mainFrame = VIEW_TABB_FRAME;
    self.tvMain = [[ZRankTableView alloc] initWithFrame:self.mainFrame];
    //公司点中
    [self.tvMain setOnRankCompanyClick:^(ModelRankCompany *model) {
        [weakSelf btnShowCompany:model];
    }];
    //人员点中
    [self.tvMain setOnRankUserClick:^(ModelRankUser *model) {
        [weakSelf btnShowUser:model];
    }];
    //律师事务所点中
    [self.tvMain setOnLawyerClick:^{
        ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
        [modelRC setCompany_name:@"律师事务所"];
        [modelRC setType:WTRankTypeL];
        [weakSelf btnShowDetail:modelRC];
    }];
    //证券公司点中
    [self.tvMain setOnSecuritiesClick:^{
        ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
        [modelRC setCompany_name:@"证券公司"];
        [modelRC setType:WTRankTypeZ];
        [weakSelf btnShowDetail:modelRC];
    }];
    //会计事务所点中
    [self.tvMain setOnAccountingClick:^{
        ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
        [modelRC setCompany_name:@"会计事务所"];
        [modelRC setType:WTRankTypeK];
        [weakSelf btnShowDetail:modelRC];
    }];
    [self.tvMain setScrollsToTop:YES];
    [self.view addSubview:self.tvMain];
    
    self.searchFrame = VIEW_ITEM_FRAME;
    self.tvSearch = [[ZRankSearchTableView alloc] initWithFrame:self.searchFrame];
    //人员点中
    [self.tvSearch setOnRankUserClick:^(ModelRankUser *model) {
        [weakSelf btnShowUser:model];
    }];
    //公司点中
    [self.tvSearch setOnRankCompanyClick:^(ModelRankCompany *model) {
        [weakSelf btnShowCompany:model];
    }];
    [self.tvSearch setHidden:YES];
    [self.tvSearch setScrollsToTop:NO];
    [self.view addSubview:self.tvSearch];
    
    [self.view sendSubviewToBack:self.tvMain];
    
    if (_rankStatus == 0) {
        //刷新数据
        [self.tvMain setOnRefreshHeader:^{
            [weakSelf setRefreshData];
        }];
    }
    
    [self innerData];
}

-(void)innerData
{
    if (_rankStatus == 0) {
        NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:kRankLocalKey];
        if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
            [self.tvMain setViewDataWithDictionary:dicLocal];
        }
        ZWEAKSELF
        [sns getHotBillBoardArrayWithResultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf.tvMain setViewDataWithDictionary:result];
                
                [sqlite setLocalCacheDataWithDictionary:result pathKay:kRankLocalKey];
            });
        } errorBlock:nil];
    }
}

-(void)setRefreshData
{
    ZWEAKSELF
    [sns getHotBillBoardArrayWithResultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            
            [weakSelf.tvMain setViewDataWithDictionary:result];
            
            [sqlite setLocalCacheDataWithDictionary:result pathKay:kRankLocalKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}

-(void)btnSearchWithContent:(NSString *)content
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Rank_Search_User];
    [MobClick event:kEvent_Rank_Search_Organization];
    ZWEAKSELF
    [sns getSearchBillBoardArrayWithParam:content pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvSearch setViewDataWithDictionary:result];
        });
    } errorBlock:nil];
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect searchFrame = self.searchFrame;
    searchFrame.size.height -= height;
    if (height == 0) {
        searchFrame.size.height = searchFrame.size.height-APP_TABBAR_HEIGHT;
    }
    [self.tvSearch setFrame:searchFrame];
}

-(void)btnShowCompany:(ModelRankCompany *)model
{
    //TODO:ZWW备注-添加友盟统计事件
    if (model.ids && model.company_name) {
        NSDictionary *dicAttrib = @{kEvent_Rank_HotSearchTag_OID:model.ids,kEvent_Rank_HotSearchTag_OName:model.company_name};
        [MobClick event:kEvent_Rank_HotSearchTag attributes:dicAttrib];
    } else {
        [MobClick event:kEvent_Rank_HotSearchTag];
    }
    
    ZRankCompanyViewController *itemVC = [[ZRankCompanyViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnShowDetail:(ModelRankCompany *)model
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Rank_HotSearchTag];
    
    if (_rankStatus == 0) {
        ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        [ZAlertView showWithMessage:@"暂未开通,敬请期待"];
    }
}

-(void)btnShowUser:(ModelRankUser *)model
{
    //TODO:ZWW备注-添加友盟统计事件
    if (model.ids && model.nickname) {
        NSDictionary *dicAttrib = @{kEvent_Rank_HotSearchTag_UID:model.ids,kEvent_Rank_HotSearchTag_UName:model.nickname};
        [MobClick event:kEvent_Rank_HotSearchTag attributes:dicAttrib];
    } else {
        [MobClick event:kEvent_Rank_HotSearchTag];
    }
    
    ZRankUserViewController *itemVC = [[ZRankUserViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end




