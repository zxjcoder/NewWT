//
//  ZNoticeListViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/28/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZNoticeListViewController.h"
#import "ZUserNoticeTVC.h"
#import "ZPracticePayViewController.h"
#import "ZPlayerViewController.h"
#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"

@interface ZNoticeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) ZUserNoticeTVC *tvcItem;
@property (strong, nonatomic) ZBaseTVC *tvcSpace;
@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZNoticeListViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kMessageCenter];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [_tvMain setDelegate:nil];
    [_tvMain setDataSource:nil];
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.view setBackgroundColor:VIEW_BACKCOLOR1];
    self.arrMain = [NSMutableArray array];
    self.tvcItem = [[ZUserNoticeTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    self.tvcSpace = [[ZBaseTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    [self.tvcSpace innerInit];
    self.tvcSpace.cellH = [ZGlobalPlayView getH];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setRowHeight:[ZUserNoticeTVC getH]];
    [self.view addSubview:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf refreshData:YES];
    }];
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [super innerInit];
}

-(void)innerData
{
    BOOL isRefresh = YES;
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:@"noticelistdata"];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *arrResult = [NSMutableArray array];
        NSArray *arrR = [dicLocal objectForKey:kResultKey];
        if (arrR && [arrR isKindOfClass:[NSArray class]]) {
            isRefresh = NO;
            for (NSDictionary *dic in arrR) {
                [arrResult addObject:[[ModelNotice alloc] initWithCustom:dic]];
            }
            [self.arrMain removeAllObjects];
            [self.arrMain addObjectsFromArray:arrResult];
            [self.tvMain reloadData];
        }
    }
    [self refreshData:isRefresh];
}

-(void)refreshData:(BOOL)isRefresh
{
    if (isRefresh) {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    ZWEAKSELF
    self.pageNum = 1;
    [snsV1 getUserNoticeListWithUserId:kLoginUserId pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            if (arrResult && arrResult.count > 0) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                
                [weakSelf.arrMain removeAllObjects];
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
                
                [sqlite setLocalCacheDataWithDictionary:result pathKay:@"noticelistdata"];
            } else {
                if (weakSelf.arrMain.count == 0) {
                    [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
                } else {
                    [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                }
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isRefresh) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV1 getUserNoticeListWithUserId:kLoginUserId pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            if (arrResult && arrResult.count > 0) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                
                [weakSelf.arrMain removeAllObjects];
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
                
                [sqlite setLocalCacheDataWithDictionary:result pathKay:@"noticelistdata"];
            } else {
                if (weakSelf.arrMain.count == 0) {
                    [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
                } else {
                    [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
                }
            }
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
    [snsV1 getUserNoticeListWithUserId:kLoginUserId pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            if (arrResult && arrResult.count > 0) {
                [weakSelf.tvMain endRefreshFooter];
                [weakSelf.arrMain addObjectsFromArray:arrResult];
                [weakSelf.tvMain reloadData];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
///显示微课详情
-(void)setShowMicroVC:(ModelNoticeCourse *)modelNC
{
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在获取,请稍等..."];
    [snsV2 getPracticeDetailWithPracticeId:modelNC.ids resultBlock:^(ModelPractice *resultModel) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            if (modelNC.buystatus == 0) {
                ZPracticePayViewController *itemVC = [[ZPracticePayViewController alloc] init];
                [itemVC setViewDataWithModel:resultModel];
                [itemVC setHidesBottomBarWhenPushed:true];
                [weakSelf.navigationController pushViewController:itemVC animated:true];
            } else {
                [weakSelf showPlayVCWithPracticeArray:@[resultModel] index:0];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}
///显示系列课详情
-(void)setShowSeriesVC:(ModelNoticeCourse *)modelNC
{
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在获取,请稍等..."];
    [snsV2 getSubscribeRecommendArrayWithSubscribeId:modelNC.ids resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
        [ZProgressHUD dismiss];
        if (modelNC.buystatus == 0) {
            ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
            [itemVC setViewDataWithModelDetail:model];
            [itemVC setHidesBottomBarWhenPushed:true];
            [weakSelf.navigationController pushViewController:itemVC animated:true];
        } else {
            ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
            [itemVC setViewDataWithSubscribeModel:model];
            [itemVC setHidesBottomBarWhenPushed:true];
            [weakSelf.navigationController pushViewController:itemVC animated:true];
        }
    } errorBlock:^(NSString *msg) {
        [ZProgressHUD dismiss];
        [ZProgressHUD showError:msg];
    }];
}
///显示培训课详情
-(void)setShowTrainingVC:(ModelNoticeCourse *)modelNC
{
    [self setShowSeriesVC:modelNC];
}
///显示系列课子课程详情
-(void)setShowSeriesItemVC:(ModelNoticeCourse *)modelNC
{
    if (modelNC.buystatus == 1) {
        ZWEAKSELF
        [ZProgressHUD showMessage:@"正在获取,请稍等..."];
        [snsV2 getCurriculumDetailWithCurriculumId:modelNC.ids resultBlock:^(ModelCurriculum *resultModel, NSDictionary *result) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                
                [weakSelf showPlayVCWithCurriculumArray:@[resultModel] index:0];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:msg];
            });
        }];
    } else {
        
    }
}
///显示培训课子课程详情
-(void)setShowTrainingItemVC:(ModelNoticeCourse *)modelNC
{
    [self setShowSeriesItemVC:modelNC];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.tvcSpace.cellH;
    }
    ModelNotice *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat height = [self.tvcItem setCellDataWithModel:model];
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.tvcSpace;
    }
    static NSString *cellid = @"tvcid";
    ZUserNoticeTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZUserNoticeTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelNotice *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnCourseEvent:^(ModelNoticeCourse *model) {
        switch (model.type) {
            case ZNoticeCourseTypeMicro:
            {
                [weakSelf setShowMicroVC:model];
                break;
            }
            case ZNoticeCourseTypeSeries:
            {
                [weakSelf setShowSeriesVC:model];
                break;
            }
            case ZNoticeCourseTypeTraining:
            {
                [weakSelf setShowTrainingVC:model];
                break;
            }
            case ZNoticeCourseTypeSeriesItem:
            {
                [weakSelf setShowSeriesItemVC:model];
                break;
            }
            case ZNoticeCourseTypeTrainingItem:
            {
                [weakSelf setShowTrainingItemVC:model];
                break;
            }
            default:
                break;
        }
    }];
    return cell;
}

@end
