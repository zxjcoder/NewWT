//
//  ZRankUserViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankUserViewController.h"
#import "ZRankDetailUserTableView.h"

#import "ZRankEditViewController.h"
#import "ZRankDownloadViewController.h"

@interface ZRankUserViewController ()

@property (strong, nonatomic) ZRankDetailUserTableView *tvMain;

@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) ModelRankUser *modelRU;

@property (assign, nonatomic) BOOL isCollectioning;

@end

@implementation ZRankUserViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewControllerTitle];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithShare];
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
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_modelRU);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.tvMain = [[ZRankDetailUserTableView alloc] init];
    [self.tvMain setOnUpdRankUserClick:^(ModelRankUser *model) {
        [weakSelf btnUpdRankUserClick:model];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf refreshFooter];
    }];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    [self.tvMain setViewDataWithModel:self.modelRU];
    
    [self innerData];
}

-(void)setViewControllerTitle
{
    switch (self.modelRU.type) {
        case 1: [self setTitle:@"会计详情"]; break;
        case 2: [self setTitle:@"券商详情"]; break;
        default: [self setTitle:@"律师详情"]; break;
    }
}

-(void)innerData
{
    ZWEAKSELF
    self.pageNum = 1;
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:1 cpysfId:self.modelRU.ids companyId:nil qrtype:nil type:nil pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            
            NSString *resultColl = [result objectForKey:@"resultColl"];
            if (resultColl && ![resultColl isKindOfClass:[NSNull class]]) {
                
                NSDictionary *dicUser = [result objectForKey:kResultKey];
                if (dicUser && [dicUser isKindOfClass:[NSDictionary class]]) {
                    ModelRankUser *model = [[ModelRankUser alloc] initWithCustom:dicUser];
                    [weakSelf setModelRU:model];
                }
                [weakSelf.modelRU setIsAtt:[resultColl boolValue]];
                
                [weakSelf setViewControllerTitle];
                
                [weakSelf.tvMain setViewDataWithModel:weakSelf.modelRU];
            }
            
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
        });
    } errorBlock:nil];
}

-(void)refreshFooter
{
    ZWEAKSELF
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:1 cpysfId:self.modelRU.ids companyId:nil qrtype:nil type:nil pageNum:self.pageNum+1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            [weakSelf.tvMain endRefreshFooter];
            [weakSelf.tvMain setViewDataWithDictionary:result];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}

-(void)btnUpdRankUserClick:(ModelRankUser *)model
{
    if ([AppSetting getAutoLogin]) {
        ZRankEditViewController *itemVC = [[ZRankEditViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        [self showLoginVC];
    }
}
///分享事件
-(void)btnRightClick
{
    //TODO:ZWW备注-分享-榜单人员详情
    if (self.modelRU.isAtt) {
        ZWEAKSELF
        // TODO:ZWW备注-1.0版本 无 下载, 1.1版本 有 下载
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeDownload)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_WeChat];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChat];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_WeChat];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnWeChatClick];
                    break;
                }
                case ZShareTypeWeChatCircle:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_WeChatCircle];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChatCircle];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_WeChatCircle];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnWeChatCircleClick];
                    break;
                }
                case ZShareTypeQQ:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_QQ];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QQ];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_QQ];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnQQClick];
                    break;
                }
                case ZShareTypeQZone:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_QZone];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QZone];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_QZone];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnQZoneClick];
                    break;
                }
                case ZShareTypeDownload:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_Download];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Download];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_Download];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnDownloadClick];
                    break;
                }
                default: break;
            }
        }];
        [shareView show];
    } else {
        ZWEAKSELF
        // TODO:ZWW备注-1.0版本 无 下载, 1.1版本 有 下载
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeDownloadCollection)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_WeChat];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChat];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_WeChat];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnWeChatClick];
                    break;
                }
                case ZShareTypeWeChatCircle:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_WeChatCircle];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChatCircle];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_WeChatCircle];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnWeChatCircleClick];
                    break;
                }
                case ZShareTypeQQ:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_QQ];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QQ];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_QQ];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnQQClick];
                    break;
                }
                case ZShareTypeQZone:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_QZone];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QZone];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_QZone];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnQZoneClick];
                    break;
                }
                case ZShareTypeDownload:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_Download];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Download];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_Download];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnDownloadClick];
                    break;
                }
                case ZShareTypeCollection:
                {
                    switch (self.modelRU.type) {
                        case 0:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_Collection];
                            break;
                        }
                        case 1:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Collection];
                            break;
                        }
                        case 2:
                        {
                            //TODO:ZWW备注-添加友盟统计事件
                            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_Collection];
                            break;
                        }
                        default: break;
                    }
                    [weakSelf btnCollectionClick];
                    break;
                }
                default: break;
            }
        }];
        [shareView show];
    }
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelRU.nickname;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelRU.company_name;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    if (self.modelRU.operator_img == nil || self.modelRU.operator_img.length == 0) {
        UIImage *image = [UIImage imageNamed:@"new_user_photo"];
        NSString *webUrl = kShare_RankUserUrl(self.modelRU.ids);
        [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
            if (!isSuccess && msg) {
                [ZProgressHUD showError:msg];
            }
        }];
    } else {
        NSString *imageUrl = [Utils getMinPicture:self.modelRU.operator_img];
        NSString *webUrl = kShare_RankUserUrl(self.modelRU.ids);
        [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
            if (!isSuccess && msg) {
                [ZProgressHUD showError:msg];
            }
        }];
    }
}
///收藏
-(void)btnCollectionClick
{
    if ([AppSetting getAutoLogin]) {
        if(self.isCollectioning) {return;}
        ZWEAKSELF
        [self setIsCollectioning:YES];
        [sns getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelRU.ids flag:2 type:@"4" resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf.modelRU setIsAtt:YES];
                [weakSelf setIsCollectioning:NO];
                [ZProgressHUD showSuccess:@"收藏成功"];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsCollectioning:NO];
                [ZProgressHUD showError:msg];
            });
        }];
    } else {
        [self showLoginVC];
    }
}
///创建一个打开文本的内容
-(void)createDocumentInteractionControllerWithLocalPath:(NSString *)localPath
{
    ZRankDownloadViewController *itemVC = [[ZRankDownloadViewController alloc] init];
    [itemVC setXlsUrl:localPath];
    [itemVC setTitle:self.title];
    [self presentViewController:itemVC animated:YES completion:nil];
}
///下载
-(void)btnDownloadClick
{
    ZWEAKSELF
    [ZProgressHUD showDownload:@"准备下载中"];
    [sns getExportPeopleWithUserId:self.modelRU.ids pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSString *strUrl = [result objectForKey:@"url"];
            if (strUrl && strUrl.length > 0) {
                NSString *localPath = [[[AppSetting getOfficeFilePath]
                                        stringByAppendingPathComponent:weakSelf.modelRU.nickname]
                                       stringByAppendingPathExtension:@"xls"];
                [ZProgressHUD changeDownload:@"正在下载中"];
                [sns downloadFileDataWithFileUrl:strUrl localPath:localPath completionBlock:^(NSData *fileData) {
                    GCDMainBlock(^{
                        [ZProgressHUD endDownload:@"下载成功" isSuccess:YES];
                        [weakSelf createDocumentInteractionControllerWithLocalPath:localPath];
                    });
                } progressBlock:^(NSProgress *uploadProgress) {
                    GCDMainBlock(^{
                        [ZProgressHUD downloadForProgress:uploadProgress];
                    });
                } errorBlock:^(NSError *error) {
                    GCDMainBlock(^{
                        [ZProgressHUD endDownload:@"下载失败" isSuccess:NO];
                    });
                }];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD endDownload:msg isSuccess:NO];
        });
    }];
}

-(void)setViewDataWithModel:(ModelRankUser *)model
{
    [self setModelRU:model];
}

@end
