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
    ///榜单状态 0 可用 1不可用
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
    
    [self setTitle:kRank];
    
    [self innerInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppRankStateChange:) name:ZAppRankStateChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setAppRankStateChange:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZAppRankStateChangeNotification object:nil];
    OBJC_RELEASE(_viewSearch);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_tvSearch);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    _rankStatus = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION].rankStatus;
    ZWEAKSELF
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
        [modelRC setCompany_name:kLawFirm];
        [modelRC setType:WTRankTypeL];
        [weakSelf btnShowDetail:modelRC];
    }];
    //证券公司点中
    [self.tvMain setOnSecuritiesClick:^{
        ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
        [modelRC setCompany_name:kSecuritiesCompany];
        [modelRC setType:WTRankTypeZ];
        [weakSelf btnShowDetail:modelRC];
    }];
    //会计事务所点中
    [self.tvMain setOnAccountingClick:^{
        ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
        [modelRC setCompany_name:kAccountingFirm];
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
    
    //刷新数据
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshData];
    }];
    
    [self loadHeaderView];
    
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:kRankLocalKey];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        [self.tvMain setViewDataWithDictionary:dicLocal];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    
    [self innerData];
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
    UITextField *textField = sender.object;
    NSString *content = textField.text;
    if (content.length > kSearchContentMaxLength) {
        [textField setText:[content substringToIndex:kSearchContentMaxLength]];
    }
    [self setLastContent:content];
    [self btnSearchWithContent:content];
}
///加载顶部
-(void)loadHeaderView
{
    if (_rankStatus == 0) {
        ZNavigationBarView *viewNav = [self.view viewWithTag:10001000];
        if (viewNav) {
            [viewNav removeFromSuperview];
        }
        [self setNavigationBarHidden:YES];
        ZWEAKSELF
        self.viewSearch = [[ZRankSearchView alloc] initWithFrame:VIEW_NAVV_FRAME];
        [self.viewSearch setTag:10001111];
        //取消搜索
        [self.viewSearch setOnClearClick:^{
            [weakSelf setLastContent:kEmpty];
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
            //添加统计事件
            [StatisticsManager event:kEvent_Rank_Search category:kCategory_Rank];
            
            [weakSelf.tvMain setScrollsToTop:NO];
            [weakSelf.tvSearch setScrollsToTop:YES];
            
            [weakSelf.tvSearch setHidden:NO];
            [weakSelf.tvSearch setAlpha:0];
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [weakSelf.tvSearch setAlpha:1];
            } completion:^(BOOL finished) {
                [weakSelf setLastContent:kEmpty];
                [weakSelf btnSearchWithContent:kEmpty];
            }];
        }];
        //搜索按钮点击
//        [self.viewSearch setOnSearchClick:^(NSString *content) {
//            [weakSelf setLastContent:content];
//            [weakSelf btnSearchWithContent:content];
//        }];
        [self.view addSubview:self.viewSearch];
    } else {
        ZRankSearchView *viewNav = [self.view viewWithTag:10001111];
        if (viewNav) {
            [viewNav removeFromSuperview];
        }
        [self setNavigationBarHidden:NO];
//        ZNavigationBarView *barView = [[ZNavigationBarView alloc] initWithFrame:VIEW_NAVV_FRAME];
//        [barView setTitle:self.title];
//        [barView setHiddenBackButton:YES];
//        [barView setTag:10001000];
//        [self.view addSubview:barView];
    }
}
///榜单配置改变的时候
-(void)setAppRankStateChange:(NSNotification *)sender
{
    int rankStatus = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION].rankStatus;
    if (_rankStatus != rankStatus) {
        _rankStatus = rankStatus;
        
        [self loadHeaderView];
        
        [self innerData];
    }
}
///加载数据
-(void)innerData
{
    if (_rankStatus == 0) {
        ZWEAKSELF
        [sns getHotBillBoardArrayWithResultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                
                [weakSelf.tvMain setViewDataWithDictionary:result];
                
                [sqlite setLocalCacheDataWithDictionary:result pathKay:kRankLocalKey];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            });
        }];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
        [self.tvMain setViewDataWithDictionary:nil];
    }
}

-(void)setRefreshData
{
    if (_rankStatus == 1) {
        [self.tvMain endRefreshHeader];
        return;
    }
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
    //添加统计事件
    [StatisticsManager event:kEvent_Rank_Search_User category:kCategory_Rank];
    [StatisticsManager event:kEvent_Rank_Search_Organization category:kCategory_Rank];
    
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
    if (model.ids && model.company_name) {
        //添加统计事件
        NSDictionary *dicAttrib = @{kEvent_Rank_HotSearchTag_OID:model.ids,kEvent_Rank_HotSearchTag_OName:model.company_name};
        [StatisticsManager event:kEvent_Rank_HotSearchTag category:kCategory_Rank dictionary:dicAttrib];
    } else {
        //添加统计事件
        [StatisticsManager event:kEvent_Rank_HotSearchTag category:kCategory_Rank];
    }
    
    ZRankCompanyViewController *itemVC = [[ZRankCompanyViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnShowDetail:(ModelRankCompany *)model
{
    //添加统计事件
    [StatisticsManager event:kEvent_Rank_HotSearchTag category:kCategory_Rank];
    
    if (_rankStatus == 0) {
        ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        [ZAlertView showWithMessage:kYetOpenedPleaseLookForwardTo];
    }
}

-(void)btnShowUser:(ModelRankUser *)model
{
    //TODO:ZWW备注-添加友盟统计事件
    if (model.ids && model.nickname) {
        //添加统计事件
        NSDictionary *dicAttrib = @{kEvent_Rank_HotSearchTag_UID:model.ids,kEvent_Rank_HotSearchTag_UName:model.nickname};
        [StatisticsManager event:kEvent_Rank_HotSearchTag category:kCategory_Rank dictionary:dicAttrib];
    } else {
        //添加统计事件
        [StatisticsManager event:kEvent_Rank_HotSearchTag category:kCategory_Rank];
    }
    
    ZRankUserViewController *itemVC = [[ZRankUserViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end




