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
#import "ZSettingButtonTVC.h"
#import "DownloadManager.h"

@interface ZUserSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) ZSettingItemTVC *tvcPassword;
@property (strong, nonatomic) ZSettingItemTVC *tvcClearCache;
@property (strong, nonatomic) ZSettingItemTVC *tvcNotice;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZSettingItemTVC *tvcAbout;
@property (strong, nonatomic) ZSettingItemTVC *tvcScore;
@property (strong, nonatomic) ZSettingButtonTVC *tvcExit;

@end

@implementation ZUserSettingViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kSetting];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerCell];
    [self innerData];
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
    OBJC_RELEASE(_tvcClearCache);
    OBJC_RELEASE(_tvcSpace1);
    OBJC_RELEASE(_tvcAbout);
    OBJC_RELEASE(_tvcScore);
    OBJC_RELEASE(_tvcExit);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcPassword = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcPassword" cellType:(ZSettingItemTVCTypeUpdatePwd)];
    self.tvcClearCache = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcClearCache" cellType:(ZSettingItemTVCTypeClearCache)];
    self.tvcNotice = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcNotice" cellType:(ZSettingItemTVCTypeNotice)];
    [self.tvcNotice setHiddenLine];
    
    self.tvcSpace1 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcSpace1.cellH = 10;
    [self.tvcSpace1.viewMain setBackgroundColor:COLORVIEWBACKCOLOR2];
    
    self.tvcScore = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcScore" cellType:(ZSettingItemTVCTypeScore)];
    self.tvcAbout = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcAbout" cellType:(ZSettingItemTVCTypeAbout)];
    ZWEAKSELF
    self.tvcExit = [[ZSettingButtonTVC alloc] initWithReuseIdentifier:@"tvcExit"];
    [self.tvcExit setOnSubmitClick:^{
        [weakSelf setExitUserEvent];
    }];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
}
-(void)innerCell
{
    if (kIsNeedLogin) {
        self.arrMain = @[self.tvcNotice,
                         self.tvcSpace1,
                         self.tvcScore,
                         self.tvcAbout];
    } else {
        ModelUser *modelU = [AppSetting getUserLogin];
        if (modelU.loginType == WTAccountTypePhone) {
            //手机或邮箱登录
            self.arrMain = @[self.tvcPassword,
                             self.tvcClearCache,
                             self.tvcNotice,
                             self.tvcSpace1,
                             self.tvcScore,
                             self.tvcAbout,
                             self.tvcExit];
        } else {
            //微信或QQ登录
            self.arrMain = @[self.tvcClearCache,
                             self.tvcNotice,
                             self.tvcSpace1,
                             self.tvcScore,
                             self.tvcAbout,
                             self.tvcExit];
        }
    }
    [self.tvMain reloadData];
}
-(void)innerData
{
    NSString *fileSize = [sqlite getSysParamWithKey:kSQLITE_LOCAL_FILE_SIZE];
    [self.tvcClearCache setViewFileSize:[fileSize floatValue]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///相册图片
        NSString *picturePath = [AppSetting getPictureFilePath];
        ///办公文件
        NSString *officePath = [AppSetting getOfficeFilePath];
        ///浏览器缓存
        NSString *webKit = [AppSetting getWebKitFilePath];
        ///回答图片
        NSString *answerPath = [AppSetting getAnswerFilePath];
        ///下载音频
        //NSString *downloadPath = [AppSetting getDownloadFilePath];
        
        float pictureSize = [self folderSizeAtPath:picturePath];
        float officeSize = [self folderSizeAtPath:officePath];
        float webKitSize = [self folderSizeAtPath:webKit];
        float answerSize = [self folderSizeAtPath:answerPath];
        //float downloadSize = [[DownloadManager sharedManager] getDownloadOccupationInBytes];
        
        float fileSize = pictureSize + officeSize + answerSize + webKitSize;
        NSString *strFileSize = [NSString stringWithFormat:@"%.2f",fileSize];
        GCDMainBlock(^{
            [self.tvcClearCache setViewFileSize:fileSize];
            
            [sqlite setSysParam:kSQLITE_LOCAL_FILE_SIZE value:strFileSize];
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
-(void)setExitUserEvent
{
    [StatisticsManager event:kUser_Setting_Exit dictionary:@{kObjectId: [AppSetting getUserId]}];
    ZWEAKSELF
    [ZAlertPromptView showWithTitle:kLogout message:kCMsgDoneExitLoginUser buttonText:kDetermine completionBlock:^{
        [[AppDelegate app] logout];
        [ZProgressHUD showSuccess:kCMsgLogoutSuccess];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } closeBlock:nil];
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
                [StatisticsManager event:kUser_Setting_UpdatePWD dictionary:@{kObjectId: [AppSetting getUserId]}];
                
                ZUserUpdatePwdViewController *itemVC = [[ZUserUpdatePwdViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeBlackListManager:
            {
                [StatisticsManager event:kUser_Setting_Blacklist dictionary:@{kObjectId: [AppSetting getUserId]}];
                
                ZBlackListManagerViewController *itemVC = [[ZBlackListManagerViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeClearCache:
            {
                [StatisticsManager event:kUser_Setting_Clearcache dictionary:@{kObjectId: [AppSetting getUserId]}];
                
                ZWEAKSELF
                [ZAlertPromptView showWithMessage:kCMsgDoneClearLocalCacheFile completionBlock:^{
                    [StatisticsManager event:kUser_Setting_Clearcache_Determine];
                    
                    [AppSetting removeFileDir];
                    [weakSelf.tvcClearCache setViewFileSize:0];
                    [ZProgressHUD showSuccess:kCMsgClearCacheSuccess];
                } closeBlock:nil];
                break;
            }
            case ZSettingItemTVCTypeNotice:
            {
                [StatisticsManager event:kUser_Setting_Push dictionary:@{kObjectId: [AppSetting getUserId]}];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            }
            case ZSettingItemTVCTypeExitUser:
            {
                [self setExitUserEvent];
                break;
            }
            case ZSettingItemTVCTypeAgreement:
            {
                ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                [itemVC setTitle:kMyAgreement];
                NSString *weburl = [NSString stringWithFormat:@"%@%@", kWebServerUrl, kApp_ProtocolUrl];
                [itemVC setWebUrl:weburl];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeFontSize:
            {
                [StatisticsManager event:kUser_Setting_FontSize dictionary:@{kObjectId: [AppSetting getUserId]}];
                
                ZUserFontViewController *itemVC = [[ZUserFontViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeAbout:
            {
                [StatisticsManager event:kUser_Setting_About dictionary:@{kObjectId: [AppSetting getUserId]}];
                
                ZUserAboutViewController *itemVC = [[ZUserAboutViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeScore:
            {
                [StatisticsManager event:kUser_Setting_Score dictionary:@{kObjectId: [AppSetting getUserId]}];
                
                [[AppDelegate app] gotoAppUpdate];
                break;
            }
            default: break;
        }
    }
}

@end