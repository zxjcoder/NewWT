//
//  ZRankDetailViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailViewController.h"
#import "ZRankDetailAchievementTableView.h"
#import "ZRankDownloadViewController.h"

@interface ZRankDetailViewController ()

@property (strong, nonatomic) ZRankDetailAchievementTableView *tvMain;

@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) ModelRankCompany *modelRC;

@property (assign, nonatomic) BOOL isCollectioning;

@end

@implementation ZRankDetailViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:[NSString stringWithFormat:@"%@%@", self.modelRC.company_name, kTheListOfALawFirm]];
    
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
    OBJC_RELEASE(_modelRC);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.tvMain = [[ZRankDetailAchievementTableView alloc] init];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf refreshFooter];
    }];
    [self.view addSubview:self.tvMain];
    
    [self.tvMain setViewDataWithModel:self.modelRC];
    
    [self setViewFrame];
    
    [self innerData];
}

-(void)innerData
{
    ZWEAKSELF
    self.pageNum = 1;
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:3 cpysfId:nil companyId:nil qrtype:nil type:[NSString stringWithFormat:@"%d",self.modelRC.type] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSString *resultColl = [result objectForKey:@"resultColl"];
            if (resultColl && ![resultColl isKindOfClass:[NSNull class]]) {
                [weakSelf.modelRC setIsAtt:[resultColl boolValue]];
                
                [weakSelf.tvMain setViewDataWithModel:weakSelf.modelRC];
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
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:3 cpysfId:nil companyId:nil qrtype:nil type:[NSString stringWithFormat:@"%d",self.modelRC.type] pageNum:self.pageNum+1 resultBlock:^(NSDictionary *result) {
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
        
    } else {
        [self showLoginVC];
    }
}

-(void)btnRightClick
{
    //TODO:ZWW备注-分享-榜单详情
    switch (self.modelRC.type) {
        case 0:
            //添加统计事件
            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share category:kCategory_Rank];
            break;
        case 1:
            //添加统计事件
            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share category:kCategory_Rank];
            break;
        case 2:
            //添加统计事件
            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share category:kCategory_Rank];
            break;
        default: break;
    }
    if (self.modelRC.isAtt) {
        ZWEAKSELF
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeDownload)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_WeChat category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChat category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_WeChat category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnWeChatClick];
                    break;
                }
                case ZShareTypeWeChatCircle:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_WeChatCircle category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChatCircle category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_WeChatCircle category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnWeChatCircleClick];
                    break;
                }
                case ZShareTypeQQ:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_QQ category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QQ category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_QQ category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnQQClick];
                    break;
                }
                case ZShareTypeQZone:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_QZone category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QZone category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_QZone category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnQZoneClick];
                    break;
                }
                case ZShareTypeDownload:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_Download category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Download category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_Download category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnDownloadClick]; break;
                }
                default: break;
            }
        }];
        [shareView show];
    } else {
        ZWEAKSELF
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeDownloadCollection)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_WeChat category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChat category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_WeChat category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnWeChatClick];
                    break;
                }
                case ZShareTypeWeChatCircle:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_WeChatCircle category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChatCircle category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_WeChatCircle category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnWeChatCircleClick];
                    break;
                }
                case ZShareTypeQQ:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_QQ category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QQ category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_QQ category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnQQClick];
                    break;
                }
                case ZShareTypeQZone:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_QZone category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QZone category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_QZone category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnQZoneClick];
                    break;
                }
                case ZShareTypeDownload:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_Download category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Download category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_Download category:kCategory_Rank];
                            break;
                        default: break;
                    }
                    [weakSelf btnDownloadClick];
                    break;
                }
                case ZShareTypeCollection:
                {
                    switch (self.modelRC.type) {
                        case 0:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_Collection category:kCategory_Rank];
                            break;
                        case 1:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Collection category:kCategory_Rank];
                            break;
                        case 2:
                            //添加统计事件
                            [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_Collection category:kCategory_Rank];
                            break;
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
///收藏
-(void)btnCollectionClick
{
    if ([AppSetting getAutoLogin]) {
        if(self.isCollectioning) {return;}
        ZWEAKSELF
        [self setIsCollectioning:YES];
        NSString *type = @"0";
        switch (self.modelRC.type) {
            case WTRankTypeL:
                type = @"0";
                //添加统计事件
                [StatisticsManager event:kEvent_Rank_PerformanceList_Lawyer_Share_Collection category:kCategory_Rank];
                break;
            case WTRankTypeK:
                type = @"1";
                //添加统计事件
                [StatisticsManager event:kEvent_Rank_PerformanceList_Accounting_Share_Collection category:kCategory_Rank];
                break;
            case WTRankTypeZ:
                type = @"2";
                //添加统计事件
                [StatisticsManager event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Collection category:kCategory_Rank];
                break;
            default: break;
        }
        [sns getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:kEmpty flag:3 type:type resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf.modelRC setIsAtt:YES];
                [weakSelf setIsCollectioning:NO];
                [ZProgressHUD showSuccess:kCMsgCollectionSuccess];
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
    [ZProgressHUD showDownload:kReadyDownload];
    [sns getExportNEEQWithType:[NSString stringWithFormat:@"%d",self.modelRC.type] pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSString *strUrl = [result objectForKey:@"url"];
            if (strUrl && strUrl.length > 0) {
                NSString *localPath = [[[AppSetting getOfficeFilePath]
                                        stringByAppendingPathComponent:weakSelf.title]
                                       stringByAppendingPathExtension:@"xls"];
                [ZProgressHUD changeDownload:kDownloading];
                [sns downloadFileDataWithFileUrl:strUrl localPath:localPath completionBlock:^(NSData *fileData) {
                    GCDMainBlock(^{
                        [ZProgressHUD endDownload:kDownloadSuccess isSuccess:YES];
                        [weakSelf createDocumentInteractionControllerWithLocalPath:localPath];
                    });
                } progressBlock:^(NSProgress *uploadProgress) {
                    GCDMainBlock(^{
                        [ZProgressHUD downloadForProgress:uploadProgress];
                    });
                } errorBlock:^(NSError *error) {
                    GCDMainBlock(^{
                        [ZProgressHUD endDownload:kDownloadFail isSuccess:NO];
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

///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelRC.company_name;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelRC.synopsis;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    UIImage *image = [UIImage imageNamed:@"bangdan_btn_lvsuo"];
    switch (self.modelRC.type) {
        case 0: image = [UIImage imageNamed:@"bangdan_btn_lvsuo"]; break;
        case 1: image = [UIImage imageNamed:@"bangdan_btn_kuaisuo"]; break;
        case 2: image = [UIImage imageNamed:@"bangdan_btn_zhengquangongsi"]; break;
        default: break;
    }
    NSString *webUrl = kShare_RankSectionUrl(self.modelRC.type);
    [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}

-(void)setViewDataWithModel:(ModelRankCompany *)model
{
    [self setModelRC:model];
}

@end
