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
    //刷新数据
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshData];
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
    
    [self innerData];
}

-(void)innerData
{
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
    ZRankCompanyViewController *itemVC = [[ZRankCompanyViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnShowDetail:(ModelRankCompany *)model
{
    ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)btnShowUser:(ModelRankUser *)model
{
    ZRankUserViewController *itemVC = [[ZRankUserViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end




