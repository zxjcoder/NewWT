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

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) ZSettingItemTVC *tvcAbout;
@property (strong, nonatomic) ZSettingItemTVC *tvcScore;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZSettingItemTVC *tvcPassword;
@property (strong, nonatomic) ZSettingItemTVC *tvcClearCache;
@property (strong, nonatomic) ZSettingItemTVC *tvcManager;
@property (strong, nonatomic) ZSettingItemTVC *tvcFontSize;
@property (strong, nonatomic) ZSettingItemTVC *tvcNotice;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace2;
@property (strong, nonatomic) ZSettingItemTVC *tvcExit;

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
    OBJC_RELEASE(_tvcManager);
    OBJC_RELEASE(_tvcClearCache);
    OBJC_RELEASE(_tvcSpace1);
    OBJC_RELEASE(_tvcSpace2);
    OBJC_RELEASE(_tvcAbout);
    OBJC_RELEASE(_tvcScore);
    OBJC_RELEASE(_tvcFontSize);
    OBJC_RELEASE(_tvcExit);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcPassword = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcPassword" cellType:(ZSettingItemTVCTypeUpdatePwd)];
    self.tvcClearCache = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcClearCache" cellType:(ZSettingItemTVCTypeClearCache)];
    self.tvcManager = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcManager" cellType:(ZSettingItemTVCTypeBlackListManager)];
    self.tvcFontSize = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcFontSize" cellType:(ZSettingItemTVCTypeFontSize)];
    self.tvcNotice = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcNotice" cellType:(ZSettingItemTVCTypeNotice)];
    [self.tvcNotice setHiddenLine];
    self.tvcSpace1 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcScore = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcScore" cellType:(ZSettingItemTVCTypeScore)];
    self.tvcAbout = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcAbout" cellType:(ZSettingItemTVCTypeAbout)];
    [self.tvcAbout setHiddenLine];
    self.tvcSpace2 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    self.tvcExit = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcExit" cellType:(ZSettingItemTVCTypeExitUser)];
    
    ModelUser *modelU = [AppSetting getUserLogin];
    if ([modelU.account isMobile] || [modelU.account isEmail]) {
        //手机或邮箱登录
        self.arrMain = @[self.tvcPassword,self.tvcManager,self.tvcClearCache,self.tvcFontSize,self.tvcNotice,self.tvcSpace1
                         ,self.tvcScore,self.tvcAbout,self.tvcSpace2
                         ,self.tvcExit];
    } else {
        //微信或QQ登录
        self.arrMain = @[self.tvcManager,self.tvcClearCache,self.tvcFontSize,self.tvcNotice,self.tvcSpace1
                         ,self.tvcScore,self.tvcAbout,self.tvcSpace2
                         ,self.tvcExit];
    }
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
}

-(void)innerData
{
    NSString *fontSize = [AppSetting getFontSize];
    [self.tvcFontSize setViewFontSize:fontSize.intValue];
    
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
        
        float pictureSize = [self folderSizeAtPath:picturePath];
        float officeSize = [self folderSizeAtPath:officePath];
        float webKitSize = [self folderSizeAtPath:webKit];
        float answerSize = [self folderSizeAtPath:answerPath];
        
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
                [StatisticsManager event:kUser_Setting_UpdatePWD];
                
                ZUserUpdatePwdViewController *itemVC = [[ZUserUpdatePwdViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeBlackListManager:
            {
                [StatisticsManager event:kUser_Setting_Blacklist];
                
                ZBlackListManagerViewController *itemVC = [[ZBlackListManagerViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeClearCache:
            {
                ZWEAKSELF
                [ZAlertView showWithTitle:kPrompt message:kCMsgDoneClearLocalCacheFile doneCompletion:^{
                    
                    [AppSetting removeFileDir];
                    
                    [weakSelf.tvcClearCache setViewFileSize:0];
                    
                    [ZProgressHUD showSuccess:kCMsgClearCacheSuccess];
                }];
                break;
            }
            case ZSettingItemTVCTypeNotice:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            }
            case ZSettingItemTVCTypeExitUser:
            {
                [StatisticsManager event:kUser_Setting_Exit];
                ZWEAKSELF
                [ZAlertView showWithTitle:kLogout message:kCMsgDoneExitLoginUser doneCompletion:^{
                    
                    [[AppDelegate app] logout];
                    
                    [ZProgressHUD showSuccess:kCMsgLogoutSuccess];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                break;
            }
            case ZSettingItemTVCTypeAgreement:
            {
                ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                [itemVC setTitle:kMyAgreement];
                [itemVC setWebUrl:kApp_ProtocolUrl];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeFontSize:
            {
                [StatisticsManager event:kUser_Setting_FontSize];
                
                ZUserFontViewController *itemVC = [[ZUserFontViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeAbout:
            {
                [StatisticsManager event:kUser_Setting_About];
                
                ZUserAboutViewController *itemVC = [[ZUserAboutViewController alloc] init];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeScore:
            {
                [StatisticsManager event:kUser_Setting_Score];
                
                [[AppDelegate app] gotoAppStoreScore];
                break;
            }
            default: break;
        }
    }
}

@end
