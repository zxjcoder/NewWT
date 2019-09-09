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
    
    [self setTitle:[NSString stringWithFormat:@"%@业绩清单",self.modelRC.company_name]];
    
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
    self.pageNum += 1;
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:3 cpysfId:nil companyId:nil qrtype:nil type:[NSString stringWithFormat:@"%d",self.modelRC.type] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
            [weakSelf.tvMain setViewDataWithDictionary:result];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNum -= 1;
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
        {
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share];
            break;
        }
        case 1:
        {
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share];
            break;
        }
        case 2:
        {
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share];
            break;
        }
        default: break;
    }
    if (self.modelRC.isAtt) {
        ZWEAKSELF
        // TODO:ZWW备注-1.0版本 无 下载, 1.1版本 有 下载
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeDownload)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat:
                {
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
                    [weakSelf btnDownloadClick]; break;
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
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
                    switch (self.modelRC.type) {
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
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_Rank_PerformanceList_Lawyer_Share_Collection];
                type = @"0"; break;
            }
            case WTRankTypeK:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_Rank_PerformanceList_Accounting_Share_Collection];
                type = @"1"; break;
            }
            case WTRankTypeZ:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Collection];
                type = @"2"; break;
            }
            default: break;
        }
        [sns getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:kEmpty flag:3 type:type resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf.modelRC setIsAtt:YES];
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
    [sns getExportNEEQWithType:[NSString stringWithFormat:@"%d",self.modelRC.type] pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSString *strUrl = [result objectForKey:@"url"];
            if (strUrl && strUrl.length > 0) {
                NSString *localPath = [[[AppSetting getRankFilePath]
                                        stringByAppendingPathComponent:weakSelf.title]
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
        if (isSuccess) {
            [ZProgressHUD showSuccess:kCShareTitleSuccess];
        }
    }];
}

-(void)setViewDataWithModel:(ModelRankCompany *)model
{
    [self setModelRC:model];
}

@end
