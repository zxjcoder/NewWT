//
//  ZMyCollectionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionViewController.h"
#import "ZMyCollectionTVC.h"

#import "ZRankDetailViewController.h"
#import "ZRankUserViewController.h"
#import "ZRankCompanyViewController.h"
#import "ZPracticeDetailViewController.h"
#import "ZUserProfileViewController.h"

@interface ZMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ModelUserBase *modelUB;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZMyCollectionViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}

- (void)setViewFrame
{
    [self.tvMain setFrame:VIEW_ITEM_FRAME];
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
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_modelUB);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    
    self.tvMain = [[ZBaseTableView alloc] init];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZMyCollectionTVC getH]];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setRefreshData:YES];
    }];
    
    [self innerData];
}

-(void)innerData
{
    NSString *localKey = [NSString stringWithFormat:@"MyCollectionKey%@",self.modelUB.userId];
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:localKey];
    BOOL isRefresh = YES;
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        isRefresh = NO;
        [self setViewDataWithDictionary:dicLocal isHeader:YES isRefresh:isRefresh];
    }
    [self setRefreshData:isRefresh];
}
///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult isHeader:(BOOL)isHeader isRefresh:(BOOL)isRefresh
{
    ZWEAKSELF
    NSString *localKey = [NSString stringWithFormat:@"MyCollectionKey%@",self.modelUB.userId];
    NSArray *arr = [dicResult objectForKey:kResultKey];
    if (arr && [arr isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrR = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            ModelCollection *model = [[ModelCollection alloc] initWithCustom:dic];
            [arrR addObject:model];
        }
        if (isHeader) {
            [self.arrMain removeAllObjects];
            [self.tvMain addRefreshHeaderWithEndBlock:^{
                [weakSelf setRefreshHeader];
            }];
            [sqlite setLocalCacheDataWithDictionary:dicResult pathKay:localKey];
        }
        if (arrR.count > kPAGE_MAXCOUNT) {
            [self.tvMain addRefreshFooterWithEndBlock:^{
                [weakSelf setRefreshFooter];
            }];
        } else {
            [self.tvMain removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrR];
        [self.tvMain reloadData];
        if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];}
    } else {
        if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];}
    }
}

-(void)setRefreshData:(BOOL)isRefresh
{
    ZWEAKSELF
    self.pageNum = 1;
    if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns postMyGetCollectionWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
            [weakSelf setViewDataWithDictionary:result isHeader:YES isRefresh:isRefresh];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if(isRefresh){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];}
        });
    }];
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [sns postMyGetCollectionWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            [weakSelf setViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}

-(void)setRefreshFooter
{
    ZWEAKSELF
    self.pageNum += 1;
    [sns postMyGetCollectionWithUserId:self.modelUB.userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
            [weakSelf setViewDataWithDictionary:result isHeader:YES isRefresh:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
///取消收藏
-(void)deleteCollectionClick:(ModelCollection *)model row:(NSInteger)row
{
    [self.arrMain removeObjectAtIndex:row];
    [self.tvMain deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [sns getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:model.hotspot_id type:model.type resultBlock:nil errorBlock:nil];
}

-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModelUB:model];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcid";
    ZMyCollectionTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyCollectionTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    
    if ([self.modelUB.userId isEqualToString:[AppSetting getUserId]]) {
        [cell setViewIsDelete:YES];
    } else {
        [cell setViewIsDelete:NO];
    }
    
    ModelCollection *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnDeleteClick:^(ModelCollection *model, NSInteger row) {
        [weakSelf deleteCollectionClick:model row:row];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCollection *model = [self.arrMain objectAtIndex:indexPath.row];
    //0:律所 1:会计 2证券 3:语音 4:人 5 机构
    switch ([model.type integerValue]) {
        case 0://律师
        {
            ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
            [modelRC setIds:model.hotspot_id];
            [modelRC setCompany_name:@"律师事务所"];
            [modelRC setType:1];
            
            ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
            [itemVC setViewDataWithModel:modelRC];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:itemVC animated:YES];
            break;
        }
        case 1://会计
        {
            ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
            [modelRC setIds:model.hotspot_id];
            [modelRC setCompany_name:@"会计事务所"];
            [modelRC setType:3];
            
            ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
            [itemVC setViewDataWithModel:modelRC];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:itemVC animated:YES];
            break;
        }
        case 2://证券
        {
            ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
            [modelRC setIds:model.hotspot_id];
            [modelRC setCompany_name:@"证券公司"];
            [modelRC setType:2];
            
            ZRankDetailViewController *itemVC = [[ZRankDetailViewController alloc] init];
            [itemVC setViewDataWithModel:modelRC];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:itemVC animated:YES];
            break;
        }
        case 3://语音
        {
            ModelPractice *modelP = [sqlite getLocalPracticeModelWithId:model.hotspot_id];
            if (modelP) {
                ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
                [itemVC setNavigationBarHidden:YES];
                [itemVC setViewDataWithModel:modelP];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:itemVC animated:YES];
            } else {
                ZWEAKSELF
                [ZProgressHUD showMessage:@"正在获取,请稍等..." toView:self.view];
                [sns getQuerySpeechDetailWithSpeechId:model.hotspot_id userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
                    GCDMainBlock(^{
                        [ZProgressHUD dismissForView:weakSelf.view];
                        
                        NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                        if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                            ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dicReuslt];
                            
                            [sqlite setLocalPracticeWithModel:modelP];
                            
                            ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
                            [itemVC setNavigationBarHidden:YES];
                            [itemVC setViewDataWithModel:modelP];
                            [itemVC setHidesBottomBarWhenPushed:YES];
                            [weakSelf.navigationController pushViewController:itemVC animated:YES];
                        } else {
                            [ZProgressHUD showError:@"获取语音信息失败" toView:weakSelf.view];
                        }
                        
                    });
                } errorBlock:^(NSString *msg) {
                    GCDMainBlock(^{
                        [ZProgressHUD dismissForView:weakSelf.view];
                        [ZProgressHUD showError:msg toView:weakSelf.view];
                    });
                }];
            }
            break;
        }
        case 4://人
        {
            ModelRankUser *modelRB = [[ModelRankUser alloc] init];
            [modelRB setIds:model.hotspot_id];
            [modelRB setNickname:model.title];
            [modelRB setOperator_img:model.img];
            
            ZRankUserViewController *itemVC = [[ZRankUserViewController alloc] init];
            [itemVC setViewDataWithModel:modelRB];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:itemVC animated:YES];
            break;
        }
        case 5://机构
        {
            ModelRankCompany *modelRC = [[ModelRankCompany alloc] init];
            [modelRC setIds:model.hotspot_id];
            [modelRC setCompany_img:model.img];
            [modelRC setCpy_name:model.title];
            [modelRC setCompany_name:model.title];
            
            ZRankCompanyViewController *itemVC = [[ZRankCompanyViewController alloc] init];
            [itemVC setViewDataWithModel:modelRC];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:itemVC animated:YES];
            break;
        }
        default: break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
