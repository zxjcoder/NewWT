//
//  ZRankCompanyViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankCompanyViewController.h"
#import "ZRankDetailCompanyView.h"

#import "ZRankEditViewController.h"
#import "ZRankDownloadViewController.h"

@interface ZRankCompanyViewController ()

@property (strong, nonatomic) ZRankDetailCompanyView *viewMain;

@property (strong, nonatomic) ModelRankCompany *modelRC;

@property (assign, nonatomic) int pageNumCompany;
@property (assign, nonatomic) int pageNumUser;

@property (assign, nonatomic) BOOL isCollectioning;

@end

@implementation ZRankCompanyViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"机构详情"];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithShare];
}

- (void)setViewFrame
{
    [self.viewMain setFrame:VIEW_ITEM_FRAME];
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
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_modelRC);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.viewMain = [[ZRankDetailCompanyView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.viewMain setOnUpdRankCompanyClick:^(ModelRankCompany *model) {
        [weakSelf btnUpdRankUserClick:model];
    }];
    [self.viewMain setOnRefreshUserFooter:^{
        [weakSelf setRefreshUserFooter];
    }];
    [self.viewMain setOnRefreshCompanyFooter:^{
        [weakSelf setRefreshCompanyFooter];
    }];
    [self.view addSubview:self.viewMain];
    
    [self setViewFrame];
    
    [self.viewMain setViewDataWithModel:self.modelRC];
    
    [self innerData];
}

-(void)innerData
{
    ZWEAKSELF
    self.pageNumUser = 1;
    ///查询人
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:2 cpysfId:nil companyId:self.modelRC.ids qrtype:@"0" type:nil pageNum:self.pageNumUser resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSString *resultColl = [result objectForKey:@"resultColl"];
            if (resultColl && ![resultColl isKindOfClass:[NSNull class]]) {
                
                NSDictionary *dicCompany = [result objectForKey:@"resultCompany"];
                if (dicCompany && [dicCompany isKindOfClass:[NSDictionary class]]) {
                    ModelRankCompany *model = [[ModelRankCompany alloc] initWithCustom:dicCompany];
                    [weakSelf setModelRC:model];
                }
                [weakSelf.modelRC setIsAtt:[resultColl boolValue]];
                
                [weakSelf.viewMain setViewDataWithModel:weakSelf.modelRC];
            }
            
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [dicResult setObject:@"YES" forKey:@"isUserObj"];
            
            [weakSelf.viewMain setViewUserWithDictionary:dicResult];
        });
    } errorBlock:nil];
    self.pageNumCompany = 1;
    ///查询业绩清单
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:2 cpysfId:nil companyId:self.modelRC.ids qrtype:@"1" type:nil pageNum:self.pageNumCompany resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            
            NSString *resultColl = [result objectForKey:@"resultColl"];
            if (resultColl && ![resultColl isKindOfClass:[NSNull class]]) {
                [weakSelf.modelRC setIsAtt:[resultColl boolValue]];
                
                [weakSelf.viewMain setViewDataWithModel:weakSelf.modelRC];
            }
            
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            
            [weakSelf.viewMain setViewCompanyWithDictionary:dicResult];
        });
    } errorBlock:nil];
}

-(void)setRefreshCompanyFooter
{
    ZWEAKSELF
    self.pageNumCompany += 1;
    ///查询业绩清单
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:2 cpysfId:nil companyId:self.modelRC.ids qrtype:@"1" type:nil pageNum:self.pageNumCompany resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshCompanyFooter];
            [weakSelf.viewMain setViewCompanyWithDictionary:result];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumCompany -= 1;
            [weakSelf.viewMain endRefreshCompanyFooter];
        });
    }];
}

-(void)setRefreshUserFooter
{
    ZWEAKSELF
    self.pageNumUser += 1;
    ///查询人
    [sns getBillBoardDetailWithUserId:[AppSetting getUserDetauleId] flag:2 cpysfId:nil companyId:self.modelRC.ids qrtype:@"0" type:nil pageNum:self.pageNumUser resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.viewMain endRefreshUserFooter];
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:@"isUserObj"];
            [weakSelf.viewMain setViewUserWithDictionary:dicResult];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumUser -= 1;
            [weakSelf.viewMain endRefreshUserFooter];
        })
    }];
}
///分享
-(void)btnRightClick
{
    //TODO:ZWW备注-分享-榜单公司详情
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
        [sns getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelRC.ids flag:2 type:@"5" resultBlock:^(NSDictionary *result) {
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
    [sns getExportOrganizationWithOrganizationId:self.modelRC.ids pageNum:1 resultBlock:^(NSDictionary *result) {
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

-(void)btnUpdRankUserClick:(ModelRankCompany *)model
{
    if ([AppSetting getAutoLogin]) {
        ZRankEditViewController *itemVC = [[ZRankEditViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        [self showLoginVC];
    }
}

///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelRC.company_name;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelRC.synopsis;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    if (self.modelRC.company_img == nil || self.modelRC.company_img.length == 0) {
        UIImage *image = [UIImage imageNamed:@"icon_orgnazation"];
        NSString *webUrl = kShare_RankOrgOrUserUrl(self.modelRC.ids,self.viewMain.selType);
        [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
            if (isSuccess) {
                [ZProgressHUD showSuccess:kCShareTitleSuccess];
            }
        }];
    } else {
        NSString *imageUrl = self.modelRC.company_img;
        NSString *webUrl = kShare_RankOrgOrUserUrl(self.modelRC.ids,self.viewMain.selType);
        [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
            if (isSuccess) {
                [ZProgressHUD showSuccess:kCShareTitleSuccess];
            }
        }];
    }
}

-(void)setViewDataWithModel:(ModelRankCompany *)model
{
    [self setModelRC:model];
}

@end
