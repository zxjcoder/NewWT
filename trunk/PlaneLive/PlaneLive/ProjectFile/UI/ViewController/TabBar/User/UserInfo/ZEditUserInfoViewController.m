//
//  ZEditUserInfoViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZEditUserInfoViewController.h"
#import "ZSpaceTVC.h"
#import "ZNewUserEditSexTVC.h"
#import "ZNewUserEditSignTVC.h"
#import "ZNewUserEditPhotoTVC.h"
#import "ZNewUserEditAddressTVC.h"
#import "ZNewUserEditCompanyTVC.h"
#import "ZNewUserEditBirthdayTVC.h"
#import "ZNewUserEditIndustryTVC.h"
#import "ZNewUserEditNickNameTVC.h"
#import "ZNewUserEditEducationTVC.h"
#import "ZNewUserEditEnterTimeTVC.h"
#import "ZImagePickerController.h"
#import "ZAlbumBrowser.h"
#import "ZAlertPhotoView.h"
#import "ZAlertPickerView.h"

@interface ZEditUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
{
    CGRect _tvFrame;
    NSInteger _rowIndex;
}
@property (assign, nonatomic) NSInteger rowIndex;

@property (strong, nonatomic) ZNewUserEditPhotoTVC *tvcPhoto;
@property (strong, nonatomic) ZNewUserEditNickNameTVC *tvcNickName;
@property (strong, nonatomic) ZNewUserEditSignTVC *tvcSign;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZNewUserEditSexTVC *tvcSex;
@property (strong, nonatomic) ZNewUserEditBirthdayTVC *tvcBirthday;
@property (strong, nonatomic) ZNewUserEditEducationTVC *tvcEducation;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace2;
@property (strong, nonatomic) ZNewUserEditIndustryTVC *tvcTrade;
@property (strong, nonatomic) ZNewUserEditEnterTimeTVC *tvcJoinTime;
@property (strong, nonatomic) ZNewUserEditCompanyTVC *tvcCompany;
@property (strong, nonatomic) ZNewUserEditAddressTVC *tvcResidence;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) NSString *strPhoto;


@end

@implementation ZEditUserInfoViewController

@synthesize rowIndex = _rowIndex;

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kEditUserInfo];
    [self innerInit];
    //TODO:ZWW备注设置页面不允许全屏返回
    //[self setFd_interactivePopDisabled:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"保存"];
    [self registerKeyboardNotification];
    [self registerTextFieldTextDidChangeNotification];
    
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageUserEditUserCenterKey];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeTextFieldTextDidChangeNotification];
    [self removeKeyboardNotification];
    
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageUserEditUserCenterKey dictionary:nil];
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
    OBJC_RELEASE(_tvcPhoto);
    OBJC_RELEASE(_tvcSpace1);
    OBJC_RELEASE(_tvcSpace2);
    OBJC_RELEASE(_tvcSex);
    OBJC_RELEASE(_tvcBirthday);
    OBJC_RELEASE(_tvcEducation);
    OBJC_RELEASE(_tvcTrade);
    OBJC_RELEASE(_tvcJoinTime);
    OBJC_RELEASE(_tvcCompany);
    OBJC_RELEASE(_tvcResidence);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcPhoto = [[ZNewUserEditPhotoTVC alloc] initWithReuseIdentifier:@"tvcPhoto"];
    self.tvcNickName = [[ZNewUserEditNickNameTVC alloc] initWithReuseIdentifier:@"tvcNickName"];
    self.tvcSign = [[ZNewUserEditSignTVC alloc] initWithReuseIdentifier:@"tvcSign"];
    self.tvcSpace1 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcSpace1.cellH = 10;
    self.tvcSex = [[ZNewUserEditSexTVC alloc] initWithReuseIdentifier:@"tvcSex"];
    self.tvcBirthday = [[ZNewUserEditBirthdayTVC alloc] initWithReuseIdentifier:@"tvcBirthday"];
    self.tvcEducation = [[ZNewUserEditEducationTVC alloc] initWithReuseIdentifier:@"tvcEducation"];
    self.tvcSpace2 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    self.tvcSpace2.cellH = 10;
    self.tvcTrade = [[ZNewUserEditIndustryTVC alloc] initWithReuseIdentifier:@"tvcTrade"];
    self.tvcJoinTime = [[ZNewUserEditEnterTimeTVC alloc] initWithReuseIdentifier:@"tvcJoinTime"];
    self.tvcCompany = [[ZNewUserEditCompanyTVC alloc] initWithReuseIdentifier:@"tvcCompany"];
    self.tvcResidence = [[ZNewUserEditAddressTVC alloc] initWithReuseIdentifier:@"tvcResidence"];
    
    [self.tvcSign setLineHidden];
    [self.tvcEducation setLineHidden];
    self.arrMain = @[self.tvcPhoto,
                     self.tvcNickName,
                     self.tvcSign,
                     self.tvcSpace1,
                     self.tvcSex,
                     self.tvcBirthday,
                     self.tvcEducation,
                     self.tvcSpace2,
                     self.tvcTrade,
                     self.tvcJoinTime,
                     self.tvcCompany,
                     self.tvcResidence
                     ];
    _tvFrame = VIEW_ITEM_FRAME;
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:_tvFrame];
    [self.tvMain setBackgroundColor:COLORVIEWBACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self.tvMain reloadData];
    
    [self innerEvent];
    [self innerData];
    [super innerInit];
}

-(void)innerData
{
    ModelUser *model = [AppSetting getUserLogin];
    
    [self.tvcPhoto setCellDataWithModel:model];
    [self.tvcNickName setCellDataWithModel:model];
    [self.tvcSign setCellDataWithModel:model];
    [self.tvcSex setCellDataWithModel:model];
    [self.tvcBirthday setCellDataWithModel:model];
    [self.tvcEducation setCellDataWithModel:model];
    [self.tvcTrade setCellDataWithModel:model];
    [self.tvcJoinTime setCellDataWithModel:model];
    [self.tvcPhoto setCellDataWithModel:model];
    [self.tvcCompany setCellDataWithModel:model];
    [self.tvcResidence setCellDataWithModel:model];
}

-(void)innerEvent
{
    ModelUser *modelU = [AppSetting getUserLogin];
    ZWEAKSELF
    [self.tvcPhoto setOnPhotoClick:^{
        [weakSelf setPhotoClick];
        _rowIndex = 0;
    }];
    [self.tvcNickName setOnBeginEdit:^{
        _rowIndex = 1;
    }];
    [self.tvcSign setOnBeginEdit:^{
        _rowIndex = 2;
    }];
    [self.tvcSex setOnBeginEdit:^{
        _rowIndex = 4;
    }];
    [self.tvcBirthday setOnBeginEdit:^{
        _rowIndex = 5;
    }];
    [self.tvcEducation setOnBeginEdit:^{
        _rowIndex = 6;
    }];
    [self.tvcTrade setOnBeginEdit:^{
        _rowIndex = 8;
    }];
    [self.tvcJoinTime setOnBeginEdit:^{
        _rowIndex = 9;
    }];
    [self.tvcCompany setOnBeginEdit:^{
        _rowIndex = 10;
    }];
    [self.tvcResidence setOnBeginEdit:^{
        _rowIndex = 11;
    }];
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
    UITextField *textField = sender.object;
    int maxLength = 0;
    switch (textField.tag) {
        case ZTextFieldIndexUserEditNickName:
            maxLength = kNumberNickNameMaxLength;
            break;
        case ZTextFieldIndexUserEditTrade:
            maxLength = kNumberTradeMaxLength;
            break;
        case ZTextFieldIndexUserEditCompany:
            if ([textField.text isChinese]) {
                maxLength = kNumberCompanyCNMaxLength;
            } else {
                maxLength = kNumberCompanyENMaxLength;
            }
            break;
        case ZTextFieldIndexUserEidtResidence:
            maxLength = kNumberResidenceMaxLength;
            break;
        default: break;
    }
    NSString *content = textField.text;
    if (maxLength > 0 && content.length > maxLength) {
        [textField setText:[content substringToIndex:maxLength]];
    }
}
-(void)setUserInfoChange:(NSDictionary *)result
{
    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"result"]];
    
    ModelUser *modelUser = [[ModelUser alloc] initWithCustom:dicUser];
    
    ModelUser *model = [AppSetting getUserLogin];
    modelUser.myFunsCount = model.myFunsCount;
    modelUser.myWaitAnsCount = model.myWaitAnsCount;
    modelUser.myQuesCount = model.myQuesCount;
    
    [AppSetting setUserLogin:modelUser];
    [AppSetting save];
    
    [self postUserInfoChangeNotification];
}

-(void)btnRightClick
{
    if (self.isLoaded) {return;}
    [self.view endEditing:YES];
    ModelUser *model = [AppSetting getUserLogin];
    
    NSString *newNickName = self.tvcNickName.textField.text;
    NSString *newSign = self.tvcSign.textField.text;
    WTSexType sexType = self.tvcSex.getSelectSexType;
    NSString *newBirthday = self.tvcBirthday.textField.text;
    NSString *newEducation = self.tvcEducation.textField.text;
    NSString *newTrade = self.tvcTrade.textField.text;
    NSString *newJoinTime = self.tvcJoinTime.textField.text;
    NSString *newCompany = self.tvcCompany.textField.text;
    NSString *newAddress = self.tvcResidence.textField.text;
    if (self.strPhoto == nil && self.strPhoto.length == 0
        && [newNickName isEqualToString:model.nickname==nil?kEmpty:model.nickname]
        && [newSign isEqualToString:model.sign==nil?kEmpty:model.sign]
        && sexType == model.sex
        && [newBirthday isEqualToString:model.birthday==nil?kEmpty:model.birthday]
        && [newEducation isEqualToString:model.education==nil?kEmpty:model.education]
        && [newTrade isEqualToString:model.trade==nil?kEmpty:model.trade]
        && [newJoinTime isEqualToString:model.joinTime==nil?kEmpty:model.joinTime]
        && [newCompany isEqualToString:model.company==nil?kEmpty:model.company]
        && [newAddress isEqualToString:model.address==nil?kEmpty:model.address]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [model setNickname:newNickName];
    [model setSign:newSign];
    [model setSex:sexType];
    [model setBirthday:newBirthday];
    [model setEducation:newEducation];
    [model setTrade:newTrade];
    [model setJoinTime:newJoinTime];
    [model setCompany:newCompany];
    [model setAddress:newAddress];
    [model setHead_img:self.strPhoto];
    
    if ([newNickName isEmpty]) {
        [ZProgressHUD showError:kNickNameNotEmpty];
        return;
    }
    if (![newNickName isNickName]) {
        [ZProgressHUD showError:[NSString stringWithFormat:kNickNameLengthLimitCharacter, kNumberNickNameMaxLength]];
        return;
    }
    if (newSign.length > kNumberSignMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kSignLengthLimitCharacter, kNumberSignMaxLength]];
        return;
    }
    if (newTrade.length > kNumberTradeMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kTradeLengthLimitCharacter, kNumberTradeMaxLength]];
        return;
    }
    if ([newCompany isChinese]) {
        if (newCompany.length > kNumberCompanyCNMaxLength) {
            [ZProgressHUD showError:[NSString stringWithFormat:kCompanyNameLengthLimitCharacter, kNumberCompanyCNMaxLength]];
            return;
        }
    } else {
        if (newCompany.length > kNumberCompanyENMaxLength) {
            [ZProgressHUD showError:[NSString stringWithFormat:kCompanyNameLengthLimitCharacter, kNumberCompanyENMaxLength]];
            return;
        }
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgEditing];
    [snsV2 postUpdateUserInfoWithModel:model resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setUserInfoChange:result];
            
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:kPersonalInformationEditorSuccess];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

-(void)btnLeftClick
{
    [self.view endEditing:YES];
    ModelUser *model = [AppSetting getUserLogin];
    
    NSString *newNickName = self.tvcNickName.textField.text;
    NSString *newSign = self.tvcSign.textField.text;
    WTSexType sexType = self.tvcSex.getSelectSexType;
    NSString *newBirthday = self.tvcBirthday.textField.text;
    NSString *newEducation = self.tvcEducation.textField.text;
    NSString *newTrade = self.tvcTrade.textField.text;
    NSString *newJoinTime = self.tvcJoinTime.textField.text;
    NSString *newCompany = self.tvcCompany.textField.text;
    NSString *newAddress = self.tvcResidence.textField.text;
    if (self.strPhoto != nil || self.strPhoto.length > 0
        || ![newNickName isEqualToString:model.nickname==nil?kEmpty:model.nickname]
        || ![newSign isEqualToString:model.sign==nil?kEmpty:model.sign]
        || sexType != model.sex
        || ![newBirthday isEqualToString:model.birthday==nil?kEmpty:model.birthday]
        || ![newEducation isEqualToString:model.education==nil?kEmpty:model.education]
        || ![newTrade isEqualToString:model.trade==nil?kEmpty:model.trade]
        || ![newJoinTime isEqualToString:model.joinTime==nil?kEmpty:model.joinTime]
        || ![newCompany isEqualToString:model.company==nil?kEmpty:model.company]
        || ![newAddress isEqualToString:model.address==nil?kEmpty:model.address]) {
        ZWEAKSELF
        [ZAlertPromptView showWithMessage:kIsEditingPersonalInformationDetermineToGiveUpTheEditor completionBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } closeBlock:nil];
        return;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    if (height > kKeyboard_Min_Height) {
        CGRect tvFrame = _tvFrame;
        tvFrame.size.height -= height;
        [self.tvMain setFrame:tvFrame];
        [self.tvMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_rowIndex inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    } else {
        [self.tvMain setFrame:_tvFrame];
    }
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
            [ZAlertPromptView showWithTitle:kPrompt message:kYouDisableTheAlbumOpenTheAlbumInTheSettingsToUse buttonText:kSetting completionBlock:^{
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
///检测相机访问权限
-(void)checkCameraAuthorization
{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (author) {
        case AVAuthorizationStatusNotDetermined:
        {
            // 用户尚未做出选择这个应用程序的问候
            ZWEAKSELF
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    GCDMainBlock(^{
                        [weakSelf showCamera];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusDenied:
            // 用户已经明确否认了这一照片数据的应用程序访问
            [ZAlertPromptView showWithTitle:kPrompt message:kYouDisableTheCameraOpenTheCameraInTheSettingsToUse buttonText:kSetting completionBlock:^{
                SafariOpen(UIApplicationOpenSettingsURLString);
            } closeBlock:nil];
            break;
        case AVAuthorizationStatusRestricted:
            // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
            [ZAlertPromptView showWithMessage:kYouAreUsingParentalControl];
            break;
        case AVAuthorizationStatusAuthorized:
            // 用户已经授权应用访问照片数据
            [self showCamera];
            break;
        default:
            break;
    }
}
///调用相册
-(void)showAlbum
{
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSInteger columnNumber = 4;
        if (IsIPadDevice) {
            columnNumber = 8;
        }
        self.isSelectPhotoStart = true;
        ZAlbumBrowser *itemVC = [[ZAlbumBrowser alloc] initWithMaxImagesCount:1 delegate:nil];
        itemVC.isSelectOriginalPhoto = YES;
        itemVC.allowPickingVideo = NO;
        itemVC.minImagesCount = 0;
        itemVC.maxImagesCount = 1;
        itemVC.showSelectBtn = NO;
        itemVC.allowCrop = YES;
        itemVC.allowPickingImage = YES;
        itemVC.alwaysEnableDoneBtn = YES;
        itemVC.minPhotoWidthSelectable = 150;
        itemVC.minPhotoHeightSelectable = 150;
        ZWEAKSELF
        [itemVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (weakSelf.isSelectPhotoStart) {
                weakSelf.isSelectPhotoStart = false;
                [weakSelf saveImageToPhoto:photos.firstObject];
            }
        }];
        if (!IsIPadDevice) {
            [itemVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        }
        [self presentViewController:itemVC animated:YES completion:nil];
    } else {
        [ZAlertPromptView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
    }
}
///调用相机
-(void)showCamera
{
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        ZImagePickerController *itemVC = [[ZImagePickerController alloc] init];
        itemVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        itemVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        itemVC.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        itemVC.delegate = self;
        itemVC.allowsEditing = YES;
        if (!IsIPadDevice) {
            [itemVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        }
        [self presentViewController:itemVC animated:YES completion:nil];
    } else {
        [ZAlertPromptView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
    }
}
///显示选择照片
-(void)setPhotoClick
{
    [self.view endEditing:YES];
    ZAlertPhotoView *alertView = [[ZAlertPhotoView alloc] init];
    ZWEAKSELF
    [alertView setOnButtonClick:^(int buttonIndex) {
        switch (buttonIndex) {
            case 0: [self checkAlbumAuthorization]; break;
            case 1: [self checkCameraAuthorization]; break;
            default: break;
        }
    }];
    [alertView show];
}
/// 保持图片到头像
-(void)saveImageToPhoto:(UIImage *)editedImage
{
    if (editedImage) {
        if (![Utils checkImageSizeIsDefault:editedImage]) {
            [ZProgressHUD showError:kPictureSizeDoesNotMeetTheRequirements];
            return;
        }
        NSString *createFilePath=[NSString stringWithFormat:@"%@/%@",[AppSetting getTempFilePath],kRandomImageName];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imagedata = [Utils writeImage:editedImage toFileAtPath:createFilePath];
            if (imagedata != nil) {
                [self setStrPhoto:createFilePath];
                GCDMainBlock(^(void){
                    [self.tvcPhoto setUserPhoto:imagedata];
                });
            }
        });
    } else {
        [ZProgressHUD showError:kThePhotosYouHaveSelectedHaveBeenCorrupted];
    }
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
    [self.view endEditing:true];
    self.rowIndex = indexPath.row;
    ZBaseTVC *cell = [self.arrMain objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[ZNewUserEditSexTVC class]]) {
        ZWEAKSELF
        ZAlertPickerView *alertView = [[ZAlertPickerView alloc] initWithType:(ZAlertPickerViewTypeSex)];
        [alertView setViewSex:[self.tvcSex getSelectSexType]];
        [alertView setOnItemChange:^(NSString *value) {
            [weakSelf.tvcSex setCellDataWithText:value];
        }];
        [alertView setOnDismissEvent:^{
            [weakSelf keyboardFrameChange:0];
        }];
        [alertView show];
        [self keyboardFrameChange:[alertView getContentH]];
    } else if ([cell isKindOfClass:[ZNewUserEditBirthdayTVC class]]) {
        ZWEAKSELF
        ZAlertPickerView *alertView = [[ZAlertPickerView alloc] initWithType:(ZAlertPickerViewTypeTime)];
        [alertView setViewTime:[self.tvcBirthday getText]];
        [alertView setOnItemChange:^(NSString *value) {
            [weakSelf.tvcBirthday setCellDataWithText:value];
        }];
        [alertView setOnDismissEvent:^{
            [weakSelf keyboardFrameChange:0];
        }];
        [alertView show];
        [self keyboardFrameChange:[alertView getContentH]];
    } else if ([cell isKindOfClass:[ZNewUserEditAddressTVC class]]) {
        ZWEAKSELF
        ZAlertPickerView *alertView = [[ZAlertPickerView alloc] initWithType:(ZAlertPickerViewTypeArea)];
        [alertView setViewArea:[self.tvcResidence getText]];
        [alertView setOnItemChange:^(NSString *value) {
            [weakSelf.tvcResidence setCellDataWithText:value];
        }];
        [alertView setOnDismissEvent:^{
            [weakSelf keyboardFrameChange:0];
        }];
        [alertView show];
        [self keyboardFrameChange:[alertView getContentH]];
    } else if ([cell isKindOfClass:[ZNewUserEditEnterTimeTVC class]]) {
        ZWEAKSELF
        ZAlertPickerView *alertView = [[ZAlertPickerView alloc] initWithType:(ZAlertPickerViewTypeTime)];
        [alertView setViewTime:[self.tvcJoinTime getText]];
        [alertView setOnItemChange:^(NSString *value) {
            [weakSelf.tvcJoinTime setCellDataWithText:value];
        }];
        [alertView setOnDismissEvent:^{
            [weakSelf keyboardFrameChange:0];
        }];
        [alertView show];
        [self keyboardFrameChange:[alertView getContentH]];
    } else if ([cell isKindOfClass:[ZNewUserEditEducationTVC class]]) {
        ZWEAKSELF
        ZAlertPickerView *alertView = [[ZAlertPickerView alloc] initWithType:(ZAlertPickerViewTypeEducation)];
        [alertView setViewEducation:[self.tvcEducation getText]];
        [alertView setOnItemChange:^(NSString *value) {
            [weakSelf.tvcEducation setCellDataWithText:value];
        }];
        [alertView setOnDismissEvent:^{
            [weakSelf keyboardFrameChange:0];
        }];
        [alertView show];
        [self keyboardFrameChange:[alertView getContentH]];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    ZWEAKSELF
    [picker dismissViewControllerAnimated:YES completion:^() {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if (mediaType && [mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
            [weakSelf saveImageToPhoto:editedImage];
        } else {
            [ZProgressHUD showError:kThePhotosYouHaveSelectedHaveBeenCorrupted];
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    for (UIImage *editedImage in photos) {
        [self saveImageToPhoto:editedImage];
    }
}

@end
