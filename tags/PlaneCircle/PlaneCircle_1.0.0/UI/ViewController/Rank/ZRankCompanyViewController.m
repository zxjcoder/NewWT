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
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat: [weakSelf btnWeChatClick]; break;
                case ZShareTypeWeChatCircle: [weakSelf btnWeChatCircleClick]; break;
                case ZShareTypeQQ: [weakSelf btnQQClick]; break;
                case ZShareTypeQZone: [weakSelf btnQZoneClick]; break;
                case ZShareTypeDownload: [weakSelf btnDownloadClick]; break;
                default: break;
            }
        }];
        [shareView show];
    } else {
        ZWEAKSELF
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeCollection)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat: [weakSelf btnWeChatClick]; break;
                case ZShareTypeWeChatCircle: [weakSelf btnWeChatCircleClick]; break;
                case ZShareTypeQQ: [weakSelf btnQQClick]; break;
                case ZShareTypeQZone: [weakSelf btnQZoneClick]; break;
                case ZShareTypeDownload: [weakSelf btnDownloadClick]; break;
                case ZShareTypeCollection: [weakSelf btnCollectionClick]; break;
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
                [ZProgressHUD showSuccess:@"收藏成功" toView:weakSelf.view];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsCollectioning:NO];
                [ZProgressHUD showError:msg toView:weakSelf.view];
            });
        }];
    } else {
        [self showLoginVC];
    }
}
///下载
-(void)btnDownloadClick
{
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在下载,请稍等..." toView:self.view];
    [sns getExportOrganizationWithOrganizationId:self.modelRC.ids pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
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
        [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) { }];
    } else {
        NSString *imageUrl = self.modelRC.company_img;
        NSString *webUrl = kShare_RankOrgOrUserUrl(self.modelRC.ids,self.viewMain.selType);
        [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) { }];
    }
}

-(void)setViewDataWithModel:(ModelRankCompany *)model
{
    [self setModelRC:model];
}

@end
