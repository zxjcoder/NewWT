//
//  ZRankDetailViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailViewController.h"
#import "ZRankDetailAchievementTableView.h"

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
        NSString *type = @"0";
        switch (self.modelRC.type) {
            case WTRankTypeL: type = @"0"; break;
            case WTRankTypeK: type = @"1"; break;
            case WTRankTypeZ: type = @"2"; break;
            default: break;
        }
        [sns getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:kEmpty flag:3 type:type resultBlock:^(NSDictionary *result) {
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
    [sns getExportNEEQWithType:[NSString stringWithFormat:@"%d",self.modelRC.type] pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
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
        case 1: image = [UIImage imageNamed:@"bangdan_btn_kuaisuo"]; break;
        case 2: image = [UIImage imageNamed:@"bangdan_btn_zhengquangongsi"]; break;
        default: break;
    }
    NSString *webUrl = kShare_RankSectionUrl(self.modelRC.type);
    [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) { }];
}

-(void)setViewDataWithModel:(ModelRankCompany *)model
{
    [self setModelRC:model];
}


@end
