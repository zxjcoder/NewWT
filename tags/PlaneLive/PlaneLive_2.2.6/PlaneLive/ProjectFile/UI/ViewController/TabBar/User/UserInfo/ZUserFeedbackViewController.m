//
//  ZUserFeedbackViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserFeedbackViewController.h"
#import "ZAlbumBrowser.h"
#import "ZImagePickerController.h"
#import "ZBaseTableView.h"
#import "ZFeekBackOtherTypeTVC.h"
#import "ZFeekBackContentTVC.h"
#import "ZFeekBackImagesTVC.h"
#import "ZFeekBackPhoneTVC.h"
#import "ZFeekBackButtonTVC.h"
#import "ZContactServiceViewController.h"
#import "ZFeekBackSuccessViewController.h"
#import "ZFeekBackRecordViewController.h"
#import "ZWebViewController.h"

@interface ZUserFeedbackViewController ()<
//UIImagePickerControllerDelegate,
//UINavigationControllerDelegate,
//ZActionSheetDelegate,
TZImagePickerControllerDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) ZFeekBackOtherTypeTVC *tvcOtherType;
@property (strong, nonatomic) ZFeekBackContentTVC *tvcContent;
@property (strong, nonatomic) ZFeekBackImagesTVC *tvcImages;
@property (strong, nonatomic) ZFeekBackPhoneTVC *tvcPhone;
@property (strong, nonatomic) ZFeekBackButtonTVC *tvcButton;

@property (strong, nonatomic) NSArray *arrayMain;
@property (assign, nonatomic) CGRect tvFrame;
@property (assign, nonatomic) NSInteger indexRow;

@end

@implementation ZUserFeedbackViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kFeedback];
    [self innerInit];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerKeyboardNotification];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
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
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.view setBackgroundColor:WHITECOLOR];
    
    self.tvcOtherType = [[ZFeekBackOtherTypeTVC alloc] initWithReuseIdentifier:@"tvcOtherType"];
    self.tvcContent = [[ZFeekBackContentTVC alloc] initWithReuseIdentifier:@"tvcContent"];
    self.tvcImages = [[ZFeekBackImagesTVC alloc] initWithReuseIdentifier:@"tvcImages"];
    self.tvcPhone = [[ZFeekBackPhoneTVC alloc] initWithReuseIdentifier:@"tvcPhone"];
    self.tvcButton = [[ZFeekBackButtonTVC alloc] initWithReuseIdentifier:@"tvcButton"];
    
    self.arrayMain = @[self.tvcOtherType,
                       self.tvcContent,
                       self.tvcImages,
                       self.tvcPhone,
                       self.tvcButton];
    
    self.tvFrame = VIEW_ITEM_FRAME;
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:self.tvFrame];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    [self innerEvent];
    [self innerData];
}
-(void)innerEvent
{
    ZWEAKSELF
    /// 微信客服
    [self.tvcOtherType setOnWeChatClick:^{
        //ZContactServiceViewController *itemVC = [[ZContactServiceViewController alloc] init];
        ZWebViewController *itemVC = [[ZWebViewController alloc] init];
        [itemVC setTitle:kCustomerService];
        [itemVC setWebUrl:[NSString stringWithFormat:@"%@%@", kWebServerUrl, kApp_WeChatServiceUrl]];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    }];
    /// 摇一摇反馈
    [self.tvcOtherType setOnShakeClick:^{
        ZWebViewController *itemVC = [[ZWebViewController alloc] init];
        [itemVC setTitle:kFeedback];
        [itemVC setWebUrl:[NSString stringWithFormat:@"%@%@", kWebServerUrl, kApp_BugShakeUrl]];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    /// 内容即将开始
    [self.tvcContent setOnBeginEditText:^{
        weakSelf.indexRow = 1;
    }];
    /// 图片点击
    [self.tvcImages setOnAddImageClick:^{
        [weakSelf showAlbum];
    }];
    [self.tvcPhone setOnBeginEditText:^{
        weakSelf.indexRow = 3;
    }];
    /// 提交反馈
    [self.tvcButton setOnSubmitEvent:^{
        [weakSelf btnSubmitClick];
    }];
    /// 反馈记录
    [self.tvcButton setOnRecordEvent:^{
        if (kIsNeedLogin) {
            [self showLoginVC];
            return;
        }
        ZFeekBackRecordViewController *itemVC = [[ZFeekBackRecordViewController alloc] init];
        [weakSelf.navigationController pushViewController:itemVC animated:true];
    }];
    UITapGestureRecognizer *viewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGesture:)];
    [self.view addGestureRecognizer:viewTapGesture];
}
-(void)innerData
{
    ModelUser *modelU = [AppSetting getUserLogin];
    if (modelU.feekbackPhone.length > 0) {
        [self.tvcPhone setText:modelU.feekbackPhone];
    } else {
        [self.tvcPhone setText:modelU.phone];
        ZWEAKSELF
        [snsV2 getV6FeedBackPhoneWithResultBlock:^(NSDictionary *result) {
            NSDictionary *dicResult = [result objectForKey:kResultKey];
            if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
                NSString *feekPhone = [dicResult objectForKey:@"contactPhone"];
                if (feekPhone && [feekPhone isKindOfClass:[NSString class]]) {
                    [self.tvcPhone setText:feekPhone];
                    modelU.feekbackPhone = feekPhone;
                    [AppSetting setUserLogin:modelU];
                    [AppSetting save];
                }
            }
        } errorBlock:^(NSString *msg) {
            
        }];
    }
}
-(void)viewTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:true];
    }
}
/// 反馈成功
-(void)showSubmitSuccess:(NSString *)prompt
{
    ZFeekBackSuccessViewController *itemVC = [[ZFeekBackSuccessViewController alloc] init];
    [itemVC setPromptText:prompt];
    [self.navigationController pushViewController:itemVC animated:true];
}
///检测相册访问权限
-(void)checkAlbumAuthorization
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    switch (author) {
        case PHAuthorizationStatusNotDetermined:
        {
            // 用户尚未做出选择这个应用程序的问候
            ZWEAKSELF
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    GCDMainBlock(^{
                        [weakSelf showAlbum];
                    });
                }
            }];
            break;
        }
        case PHAuthorizationStatusDenied:
            // 用户已经明确否认了这一照片数据的应用程序访问
            [ZAlertPromptView showWithMessage:kYouDisableTheAlbumOpenTheAlbumInTheSettingsToUse buttonText:kSetting completionBlock:^{
                SafariOpen(UIApplicationOpenSettingsURLString);
            } closeBlock:nil];
            break;
        case PHAuthorizationStatusRestricted:
            // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
            [ZAlertPromptView showWithMessage:kYouAreUsingParentalControl];
            break;
        case PHAuthorizationStatusAuthorized:
            // 用户已经授权应用访问照片数据
            [self showAlbum];
            break;
        default:
            break;
    }
}
///调用相册
-(void)showAlbum
{
    if (kIsNeedLogin) {
        [self showLoginVC];
        return;
    }
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSInteger columnNumber = 4;
        if (IsIPadDevice) {
            columnNumber = 8;
        }
        NSInteger maxImagesCount = kFeedbackPicturecMaxLength-self.tvcImages.getImagesArray.count;
        if (maxImagesCount > 0) {
            self.isSelectPhotoStart = true;
            ZAlbumBrowser *itemVC = [[ZAlbumBrowser alloc] initWithMaxImagesCount:maxImagesCount delegate:nil];
            itemVC.isSelectOriginalPhoto = true;
            itemVC.allowPickingVideo = false;
            itemVC.allowPickingImage = true;
            itemVC.alwaysEnableDoneBtn = true;
            itemVC.allowPickingOriginalPhoto = false;
            itemVC.minPhotoWidthSelectable = 300;
            itemVC.minPhotoHeightSelectable = 300;
            ZWEAKSELF
            [itemVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (weakSelf.isSelectPhotoStart) {
                    weakSelf.isSelectPhotoStart = false;
                    [weakSelf.tvcImages setCellDataImage:photos];
                }
            }];
            if (!IsIPadDevice) {
                [itemVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            }
            [self presentViewController:itemVC animated:YES completion:nil];
        }
    } else {
        [ZAlertPromptView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
    }
}
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    if (height > 0) {
        CGRect tvFrame = self.tvFrame;
        tvFrame.size.height -= height;
        self.tvMain.frame = tvFrame;
        
        [self.tvMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexRow inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:false];
    } else {
        self.tvMain.frame = self.tvFrame;
    }
}
///提交意见反馈
-(void)btnSubmitClick
{
    [self.view endEditing:YES];
    if (kIsNeedLogin) {
        [self showLoginVC];
        return;
    }
    if (self.isLoaded) {return;}
    self.isLoaded = true;
    NSString *textContent = self.tvcContent.getText.toTrim;
    if ([textContent isEmpty]) {
        [ZProgressHUD showError:kFeedbackContentCanNotBeEmpty];
        self.isLoaded = false;
        return;
    }
    if (textContent.length < kFeedbackContentMinLength || textContent.length > kFeedbackContentMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kFeedbackContentLengthLimitCharacter, kFeedbackContentMinLength, kFeedbackContentMaxLength]];
        self.isLoaded = false;
        return;
    }
    NSMutableArray *arrImage = [NSMutableArray array];
    int index = 0;
    for (UIImage *image in self.tvcImages.getImagesArray) {
        ModelImage *modelI = [[ModelImage alloc] init];
        [modelI setImageObject:image];
        [modelI setImageName:kRandomImageName];
        [modelI setLocation:index];
        [modelI setFileName:@"feedbackImg"];
        
        [arrImage addObject:modelI];
        index++;
    }
    if (arrImage.count > kFeedbackPicturecMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kFeedbackPictureLengthLimitCharacter, kFeedbackPicturecMaxLength]];
        self.isLoaded = false;
        return;
    }
    NSString *phone = self.tvcPhone.getText;
    if ([phone isEmpty]) {
        [ZProgressHUD showError:@"联系手机号不能为空"];
        self.isLoaded = false;
        return;
    }
    if (![phone isMobile]) {
        [ZProgressHUD showError:@"请输入正确的手机号"];
        self.isLoaded = false;
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgSubmiting];
    [snsV2 getV6AddFeekBackWithFiles:arrImage content:textContent contact:phone resultBlock:^(NSDictionary *result) {
        [weakSelf setIsLoaded:NO];
        [ZProgressHUD dismiss];
        [weakSelf.tvcContent setText:kEmpty];
        [weakSelf.tvcImages removeImageArray];
        /// 更新反馈手机号码
        ModelUser *modelU = [AppSetting getUserLogin];
        modelU.feekbackPhone = phone;
        [AppSetting setUserLogin:modelU];
        [AppSetting save];
        /// 处理反馈成功提示语
        NSString *content = [result objectForKey:kResultKey];
        if (content && [content isKindOfClass:[NSString class]]) {
            [weakSelf showSubmitSuccess:content];
        } else {
            [weakSelf showSubmitSuccess:kEmpty];
        }
    } errorBlock:^(NSString *msg) {
        [weakSelf setIsLoaded:NO];
        [ZProgressHUD dismiss];
        [ZProgressHUD showError:msg];
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(ZBaseTVC*)[self.arrayMain objectAtIndex:indexPath.row] getH];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ZBaseTVC*)[self.arrayMain objectAtIndex:indexPath.row];
}

@end
