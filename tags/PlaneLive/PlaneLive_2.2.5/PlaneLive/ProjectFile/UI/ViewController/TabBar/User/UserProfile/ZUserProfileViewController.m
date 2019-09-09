//
//  ZUserProfileViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/10/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserProfileViewController.h"
#import "ZUserProfileAttentionTVC.h"
#import "ZUserProfileCollectionTVC.h"
#import "ZUserProfileHeaderTVC.h"
#import "ZUserProfileResidenceTVC.h"
#import "ZUserProfileSignTVC.h"
#import "ZUserProfileTradeTVC.h"
#import "ZUserProfileButtonTVC.h"

#import "ZMyAnswerViewController.h"
#import "ZMyAttentionViewController.h"
#import "ZMyCollectionViewController.h"
#import "ZMyFansViewController.h"
#import "ZMyQuestionViewController.h"

@interface ZUserProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZUserProfileHeaderTVC *tvcHeader;
@property (strong, nonatomic) ZUserProfileSignTVC *tvcSign;
@property (strong, nonatomic) ZUserProfileTradeTVC *tvcTrade;
@property (strong, nonatomic) ZUserProfileResidenceTVC *tvcResidence;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace;
@property (strong, nonatomic) ZUserProfileCollectionTVC *tvcCollection;
@property (strong, nonatomic) ZUserProfileAttentionTVC *tvcAttention;
@property (strong, nonatomic) ZUserProfileButtonTVC *tvcButton;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (assign, nonatomic) BOOL isAtting;

@property (strong, nonatomic) ModelUserBase *model;

@property (strong, nonatomic) ModelUserProfile *modelUser;

@end

@implementation ZUserProfileViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:self.model.nickname];
    
    [self innerInit];
    
    [self innerData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isShowLogin) {
        [self setIsShowLogin:NO];
        
        [self innerData];
    }
    [self setRightShareButton];
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
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_modelUser);
    OBJC_RELEASE(_tvcSign);
    OBJC_RELEASE(_tvcSpace);
    OBJC_RELEASE(_tvcTrade);
    OBJC_RELEASE(_tvcButton);
    OBJC_RELEASE(_tvcHeader);
    OBJC_RELEASE(_tvcAttention);
    OBJC_RELEASE(_tvcResidence);
    OBJC_RELEASE(_tvcCollection);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcHeader = [[ZUserProfileHeaderTVC alloc] initWithReuseIdentifier:@"tvcHeader"];
    self.tvcSign = [[ZUserProfileSignTVC alloc] initWithReuseIdentifier:@"tvcSign"];
    self.tvcTrade = [[ZUserProfileTradeTVC alloc] initWithReuseIdentifier:@"tvcTrade"];
    self.tvcResidence = [[ZUserProfileResidenceTVC alloc] initWithReuseIdentifier:@"tvcResidence"];
    [self.tvcResidence setHiddenLine];
    self.tvcSpace = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    self.tvcCollection = [[ZUserProfileCollectionTVC alloc] initWithReuseIdentifier:@"tvcCollection"];
    self.tvcAttention = [[ZUserProfileAttentionTVC alloc] initWithReuseIdentifier:@"tvcAttention"];
    [self.tvcAttention setHiddenLine];
    self.tvcButton = [[ZUserProfileButtonTVC alloc] initWithReuseIdentifier:@"tvcButton"];
    
    self.arrMain = @[self.tvcHeader,self.tvcSign,self.tvcTrade,self.tvcResidence,self.tvcSpace,
                     self.tvcAttention,self.tvcButton];
                     //self.tvcCollection,self.tvcAttention,self.tvcButton];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self innerEvent];
    
    [super innerInit];
}

-(void)innerData
{
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgEditing];
    [snsV1 postGetUserInfoWithUserId:kLoginUserId hisId:self.model.userId resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:kUserKey]];
            NSString *hisAttention = [result objectForKey:@"hisAttention"];
            NSString *hisFuns = [result objectForKey:@"hisFuns"];
            NSString *hisAnswer = [result objectForKey:@"hisAnswer"];
            NSString *hisCollect = [result objectForKey:@"hisCollect"];
            NSString *hisQues = [result objectForKey:@"hisQues"];
            if (hisAttention && ![hisAttention isKindOfClass:[NSNull class]]) {
                [dicUser setObject:hisAttention forKey:@"hisAttention"];
            }
            if (hisFuns && ![hisFuns isKindOfClass:[NSNull class]]) {
                [dicUser setObject:hisFuns forKey:@"hisFuns"];
            }
            if (hisAnswer && ![hisAnswer isKindOfClass:[NSNull class]]) {
                [dicUser setObject:hisAnswer forKey:@"hisAnswer"];
            }
            if (hisCollect && ![hisCollect isKindOfClass:[NSNull class]]) {
                [dicUser setObject:hisCollect forKey:@"hisCollect"];
            }
            NSString *isAtt = [result objectForKey:@"flag"];
            if (isAtt && ![isAtt isKindOfClass:[NSNull class]]) {
                [dicUser setObject:isAtt forKey:@"isAtt"];
            }
            NSString *isBlack = [result objectForKey:@"isBlack"];
            if (isBlack && ![isBlack isKindOfClass:[NSNull class]]) {
                [dicUser setObject:isBlack forKey:@"isBlack"];
            }
            if (hisQues && ![hisQues isKindOfClass:[NSNull class]]) {
                [dicUser setObject:hisQues forKey:@"hisQues"];
            }
            
            ModelUserProfile *modelResult = [[ModelUserProfile alloc] initWithCustom:dicUser];
            [weakSelf setModelUser:modelResult];
            if (weakSelf.modelUser) {
                [weakSelf.tvcHeader setCellDataWithModel:weakSelf.modelUser];
                [weakSelf.tvcSign setCellDataWithModel:weakSelf.modelUser];
                [weakSelf.tvcTrade setCellDataWithModel:weakSelf.modelUser];
                [weakSelf.tvcResidence setCellDataWithModel:weakSelf.modelUser];
                [weakSelf.tvcCollection setCellDataWithModel:weakSelf.modelUser];
                [weakSelf.tvcAttention setCellDataWithModel:weakSelf.modelUser];
                [weakSelf.tvcButton setCellDataWithModel:weakSelf.modelUser];
            }
            if ([isBlack boolValue]) {
                [weakSelf.tvcButton setButtonHidden:YES];
            }
            [weakSelf.tvMain reloadData];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

-(void)innerEvent
{
    ZWEAKSELF
    [self.tvcButton setOnOperClick:^{
        [weakSelf btnAttClick];
    }];
    [self.tvcHeader setOnItemClick:^(ZUserProfileHeaderItemType type, NSString *title) {
        switch (type) {
            case ZUserProfileHeaderItemTypeQuestion:
            {
                ZMyQuestionViewController *itemVC = [[ZMyQuestionViewController alloc] init];
                [itemVC setTitle:title];
                [itemVC setViewDataWithModel:weakSelf.model];
                [itemVC setViewDataWithUserProfileModel:weakSelf.modelUser];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserProfileHeaderItemTypeFans:
            {
                ZMyFansViewController *itemVC = [[ZMyFansViewController alloc] init];
                [itemVC setTitle:title];
                [itemVC setViewDataWithModel:weakSelf.model];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZUserProfileHeaderItemTypeAnswer:
            {
                ZMyAnswerViewController *itemVC = [[ZMyAnswerViewController alloc] init];
                [itemVC setTitle:title];
                [itemVC setViewDataWithModel:weakSelf.model];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            default: break;
        }
    }];
}
///删除用户的行
-(void)setDeleteUserWithRow:(NSNumber *)row
{
    
}
///关注
-(void)btnAttClick
{
    if (![AppSetting getAutoLogin]) {
        [self showLoginVC];
        return;
    }
    if (self.isAtting) {return;}
    [self setIsAtting:YES];
    ///已经关注
    if (self.modelUser.isAtt) {
        [self.tvcButton setButtonState:NO];
        [self.modelUser setIsAtt:NO];
        [self.tvcButton setCellDataWithModel:self.modelUser];
        ZWEAKSELF
        [snsV1 postDeleteAttentionWithAId:self.model.userId userId:kLoginUserId type:@"1" resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setIsAtting:NO];
                
                weakSelf.modelUser.hisFuns -= 1;
                if (weakSelf.modelUser.hisFuns <= 0) {
                    weakSelf.modelUser.hisFuns = 0;
                }
                [weakSelf.tvcHeader setCellDataWithModel:weakSelf.modelUser];
                if (weakSelf.preVC != nil) {
                    [weakSelf.preVC performSelector:@selector(setDeleteUserWithRow:) withObject:[NSNumber numberWithBool:NO] afterDelay:NO];
                }
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsAtting:NO];
                [weakSelf.tvcButton setButtonState:YES];
                [weakSelf.modelUser setIsAtt:YES];
                [weakSelf.tvcButton setCellDataWithModel:weakSelf.modelUser];
                [ZProgressHUD showError:msg];
            });
        }];
    } else {
        if (self.modelUser.isBlackList) {
            [ZProgressHUD showError:kAddBlackListAlready];
            [self setIsAtting:NO];
            return;
        }
        [self.tvcButton setButtonState:YES];
        [self.modelUser setIsAtt:YES];
        [self.tvcButton setCellDataWithModel:self.modelUser];
        ZWEAKSELF
        [snsV1 postAddAttentionWithuserId:kLoginUserId hisId:self.model.userId type:@"1" resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setIsAtting:NO];
                
                weakSelf.modelUser.hisFuns += 1;
                [weakSelf.tvcHeader setCellDataWithModel:weakSelf.modelUser];
                if (weakSelf.preVC != nil) {
                    [weakSelf.preVC performSelector:@selector(setDeleteUserWithRow:) withObject:[NSNumber numberWithBool:YES] afterDelay:NO];
                }
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsAtting:NO];
                [weakSelf.tvcButton setButtonState:NO];
                [weakSelf.modelUser setIsAtt:NO];
                [weakSelf.tvcButton setCellDataWithModel:weakSelf.modelUser];
                [ZProgressHUD showError:msg];
            });
        }];
    }
}
///加入黑名单
-(void)btnBlackListClick
{
    if ([AppSetting getAutoLogin] && [[AppSetting getUserId] isEqualToString:kUserAuditId]) {
        ZWEAKSELF
        [snsV1 postAddBlackListWithUserId:kLoginUserId addUserId:self.model.userId resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf.tvcButton setButtonHidden:YES];
                [ZProgressHUD showSuccess:kAddBlackListSuccess];
                [weakSelf.modelUser setIsBlackList:YES];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [ZProgressHUD showError:msg];
            });
        }];
    } else {
        [self showLoginVC];
    }
}
///举报
-(void)btnReportClick
{
    [self btnReportClickWithId:self.model.userId type:ZReportTypePersion];
}
///显示分享
-(void)btnShareClick
{
    ZWEAKSELF
    ///如果添加了黑名单或者关注了。都不能再添加黑名单了
//    ZShareView *shareView =nil;
//    if (self.modelUser.isBlackList || self.modelUser.isAtt) {
//        shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeOnlyReport)];
//    } else {
//        shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeOnlyReportBlacklist)];
//    }
    ZAlertShareView *shareView = [[ZAlertShareView alloc] init];
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat: [weakSelf btnWeChatClick]; break;
            case ZShareTypeWeChatCircle: [weakSelf btnWeChatCircleClick]; break;
            case ZShareTypeQQ: [weakSelf btnQQClick]; break;
            case ZShareTypeQZone: [weakSelf btnQZoneClick]; break;
            case ZShareTypeReport: [weakSelf btnReportClick]; break;
            case ZShareTypeBlackList: [weakSelf btnBlackListClick]; break;
            default: break;
        }
    }];
    [shareView show];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelUser.nickname;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelUser.sign;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.modelUser.head_img];
    NSString *webUrl = kShare_UserInfoUrl(self.model.userId);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
///设置数据模型
-(void)setViewDataWithModel:(ModelUserBase *)model
{
    [self setModel:model];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.arrMain objectAtIndex:indexPath.row];
    return [cell getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrMain objectAtIndex:indexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.arrMain objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[ZUserProfileCollectionTVC class]]) {
        ZMyCollectionViewController *itemVC = [[ZMyCollectionViewController alloc] init];
        [itemVC setTitle:[(ZUserProfileCollectionTVC*)cell getTitleText]];
        [itemVC setViewDataWithModel:self.model];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else if ([cell isKindOfClass:[ZUserProfileAttentionTVC class]]) {
        ZMyAttentionViewController *itemVC = [[ZMyAttentionViewController alloc] init];
        [itemVC setTitle:[(ZUserProfileAttentionTVC*)cell getTitleText]];
        [itemVC setViewDataWithModel:self.model];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}

@end
