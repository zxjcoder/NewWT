//
//  ZUserSettingViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserSettingViewController.h"
#import "ZSpaceTVC.h"
#import "ZSettingItemTVC.h"

#import "ZUserUpdatePwdViewController.h"
#import "ZBlackListManagerViewController.h"

#import "ZUserAboutViewController.h"
#import "ZUserFontViewController.h"
#import "ZWebViewController.h"

@interface ZUserSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) ZSettingItemTVC *tvcAbout;
@property (strong, nonatomic) ZSettingItemTVC *tvcScore;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZSettingItemTVC *tvcPassword;
@property (strong, nonatomic) ZSettingItemTVC *tvcClearCache;
@property (strong, nonatomic) ZSettingItemTVC *tvcManager;
@property (strong, nonatomic) ZSettingItemTVC *tvcAgreement;
@property (strong, nonatomic) ZSettingItemTVC *tvcFontSize;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace2;
@property (strong, nonatomic) ZSettingItemTVC *tvcExit;

@end

@implementation ZUserSettingViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"设置"];
    
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
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcPassword);
    OBJC_RELEASE(_tvcManager);
    OBJC_RELEASE(_tvcClearCache);
    OBJC_RELEASE(_tvcSpace1);
    OBJC_RELEASE(_tvcSpace2);
    OBJC_RELEASE(_tvcAbout);
    OBJC_RELEASE(_tvcScore);
    OBJC_RELEASE(_tvcAgreement);
    OBJC_RELEASE(_tvcFontSize);
    OBJC_RELEASE(_tvcExit);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcAbout = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcAbout" cellType:(ZSettingItemTVCTypeAbout)];
    self.tvcScore = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcScore" cellType:(ZSettingItemTVCTypeScore)];
    
    self.tvcSpace1 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcPassword = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcPassword" cellType:(ZSettingItemTVCTypeUpdatePwd)];
    self.tvcClearCache = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcClearCache" cellType:(ZSettingItemTVCTypeClearCache)];
    self.tvcManager = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcManager" cellType:(ZSettingItemTVCTypeBlackListManager)];
    self.tvcAgreement = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcAgreement" cellType:(ZSettingItemTVCTypeAgreement)];
    self.tvcFontSize = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcFontSize" cellType:(ZSettingItemTVCTypeFontSize)];
    
    self.tvcSpace2 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    self.tvcExit = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcExit" cellType:(ZSettingItemTVCTypeExitUser)];
    
    ModelUser *modelU = [AppSetting getUserLogin];
    
    // TODO:ZWW备注-1.0版本 无 字体, 1.1版本 有 字体
    if ([Utils isVersion100]) {
        //微信或QQ登录
        if ((modelU.wechat_id && ![modelU.wechat_id isKindOfClass:[NSNull class]] && modelU.wechat_id.length > 0) ||
            (modelU.qq_id && ![modelU.qq_id isKindOfClass:[NSNull class]] && modelU.qq_id.length > 0)) {
            self.arrMain = @[self.tvcManager,self.tvcClearCache,self.tvcSpace2,self.tvcAbout,self.tvcScore,self.tvcAgreement,self.tvcSpace1,self.tvcExit];
        } else {
            self.arrMain = @[self.tvcPassword,self.tvcManager,self.tvcClearCache,self.tvcSpace2,self.tvcAbout,self.tvcScore,self.tvcAgreement,self.tvcSpace1,self.tvcExit];
        }
    } else {
        //微信或QQ登录
        if ((modelU.wechat_id && ![modelU.wechat_id isKindOfClass:[NSNull class]] && modelU.wechat_id.length > 0) ||
            (modelU.qq_id && ![modelU.qq_id isKindOfClass:[NSNull class]] && modelU.qq_id.length > 0)) {
            self.arrMain = @[self.tvcManager,self.tvcClearCache,self.tvcFontSize,self.tvcSpace2,self.tvcAbout,self.tvcScore,self.tvcAgreement,self.tvcSpace1,self.tvcExit];
        } else {
            self.arrMain = @[self.tvcPassword,self.tvcManager,self.tvcFontSize,self.tvcClearCache,self.tvcSpace2,self.tvcAbout,self.tvcScore,self.tvcAgreement,self.tvcSpace1,self.tvcExit];
        }
    }
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    [self innerData];
}

-(void)innerData
{
    [self.tvcClearCache setViewFileSize:[[sqlite getSysParamWithKey:kSQLITE_LOCAL_FILE_SIZE] floatValue]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userPath = [AppSetting getPersonalFilePath];
        NSString *recvPath = [AppSetting getRecvFilePath];
        NSString *headPath = [AppSetting getHeadFilePath];
        NSString *webKit = [AppSetting getWebKitFilePath];
        NSString *audioPath = [AppSetting getAudioFilePath];
        NSString *answerPath = [AppSetting getAnswerFilePath];
        
        float userSize = [self folderSizeAtPath:userPath];
        float recvSize = [self folderSizeAtPath:recvPath];
        float headSize = [self folderSizeAtPath:headPath];
        float webKitSize = [self folderSizeAtPath:webKit];
        float audioSize = [self folderSizeAtPath:audioPath];
        float answerSize = [self folderSizeAtPath:answerPath];
        
        float fileSize = userSize + recvSize + headSize + audioSize + answerSize + webKitSize;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tvcClearCache setViewFileSize:fileSize];
            
            [sqlite setSysParam:kSQLITE_LOCAL_FILE_SIZE value:[NSString stringWithFormat:@"%.2f",fileSize]];
        });
    });
}
///遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName]; folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
///单个文件的大小
- (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
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
    if ([cell isKindOfClass:[ZSettingItemTVC class]]) {
        ZSettingItemTVCType type = [(ZSettingItemTVC*)cell type];
        switch (type) {
            case ZSettingItemTVCTypeUpdatePwd:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_UpdatePWD];
                
                ZUserUpdatePwdViewController *itemVC = [[ZUserUpdatePwdViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeBlackListManager:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_Blacklist];
                
                ZBlackListManagerViewController *itemVC = [[ZBlackListManagerViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeClearCache:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_ClearCache];
                
                ZWEAKSELF
                [ZAlertView showWithTitle:@"提示" message:@"确定清除本地缓存文件吗?" doneCompletion:^{
                    [AppSetting removeFileDir];
                    [sqlite clearHisData];
                    [weakSelf.tvcClearCache setViewFileSize:0];
                    [ZProgressHUD showSuccess:@"缓存清楚成功" toView:self.view];
                }];
                break;
            }
            case ZSettingItemTVCTypeExitUser:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_Exit];
                
                ZWEAKSELF
                [ZAlertView showWithTitle:@"注销" message:@"确定退出当前登录帐号吗?" doneCompletion:^{
                    [MobClick profileSignOff];
                    [[AppDelegate app] logout];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                break;
            }
            case ZSettingItemTVCTypeAgreement:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_Agreement];
                
                ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                [itemVC setTitle:kCUseAgreement];
                [itemVC setWebUrl:kApp_ProtocolUrl];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeFontSize:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_FontSize];
                
                ZUserFontViewController *itemVC = [[ZUserFontViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeAbout:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_About];
                
                ZUserAboutViewController *itemVC = [[ZUserAboutViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeScore:
            {
                //TODO:ZWW备注-添加友盟统计事件
                [MobClick event:kEvent_User_Setting_Score];
                
                [[AppDelegate app] gotoAppStoreScore];
                break;
            }
            default: break;
        }
    }
}

@end
