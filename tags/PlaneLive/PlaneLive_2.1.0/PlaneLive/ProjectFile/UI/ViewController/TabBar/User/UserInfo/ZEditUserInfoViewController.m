//
//  ZEditUserInfoViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZEditUserInfoViewController.h"
#import "ZUserEditCompanyTVC.h"
#import "ZUserEditHeaderTVC.h"
#import "ZUserEditSexTVC.h"
#import "ZUserEditTradeTVC.h"
#import "ZUserEidtResidenceTVC.h"
#import "ZSpaceTVC.h"
#import "ZUserEditBirthdayTVC.h"
#import "ZUserEditSignTVC.h"
#import "ZUserEditJoinTimeTVC.h"
#import "ZUserEditNickNameTVC.h"
#import "ZUserEditEducationTVC.h"
#import "ZUserEditPhotoTVC.h"

#import "ZImagePickerController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "ZTaskCompleteView.h"

#import "ZCutImageViewController.h"

@interface ZEditUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZActionSheetDelegate,ZCutImageViewControllerDelegate>
{
    CGRect _tvFrame;
    NSInteger _rowIndex;
}
@property (assign, nonatomic) NSInteger rowIndex;

@property (strong, nonatomic) ZUserEditPhotoTVC *tvcPhoto;
@property (strong, nonatomic) ZUserEditNickNameTVC *tvcNickName;
@property (strong, nonatomic) ZUserEditSignTVC *tvcSign;
@property (strong, nonatomic) ZUserEditSexTVC *tvcSex;
@property (strong, nonatomic) ZUserEditBirthdayTVC *tvcBirthday;
///学历
@property (strong, nonatomic) ZUserEditEducationTVC *tvcEducation;
@property (strong, nonatomic) ZUserEditTradeTVC *tvcTrade;
@property (strong, nonatomic) ZUserEditJoinTimeTVC *tvcJoinTime;
@property (strong, nonatomic) ZUserEditCompanyTVC *tvcCompany;
///居住地
@property (strong, nonatomic) ZUserEidtResidenceTVC *tvcResidence;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) NSString *strPhoto;

@property (assign, nonatomic) BOOL isSetBirthday;

@property (assign, nonatomic) BOOL isSetJoinTime;

@end

@implementation ZEditUserInfoViewController

@synthesize rowIndex = _rowIndex;

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kEditUserInfo];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:kDone];
    
    [self registerKeyboardNotification];
    
    [self registerTextFieldTextDidChangeNotification];
    
    [self setLeftButtonWithDefault];
    
    [self innerData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
    OBJC_RELEASE(_tvcNickName);
    OBJC_RELEASE(_tvcSign);
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
    _tvcPhoto = [[ZUserEditPhotoTVC alloc] initWithReuseIdentifier:@"_tvcPhoto"];
    _tvcNickName = [[ZUserEditNickNameTVC alloc] initWithReuseIdentifier:@"_tvcNickName"];
    _tvcSign = [[ZUserEditSignTVC alloc] initWithReuseIdentifier:@"_tvcSign"];
    _tvcSex = [[ZUserEditSexTVC alloc] initWithReuseIdentifier:@"_tvcSex"];
    _tvcBirthday = [[ZUserEditBirthdayTVC alloc] initWithReuseIdentifier:@"_tvcBirthday"];
    _tvcEducation = [[ZUserEditEducationTVC alloc] initWithReuseIdentifier:@"_tvcEducation"];
    _tvcTrade = [[ZUserEditTradeTVC alloc] initWithReuseIdentifier:@"_tvcTrade"];
    _tvcJoinTime = [[ZUserEditJoinTimeTVC alloc] initWithReuseIdentifier:@"_tvcJoinTime"];
    _tvcCompany = [[ZUserEditCompanyTVC alloc] initWithReuseIdentifier:@"_tvcCompany"];
    _tvcResidence = [[ZUserEidtResidenceTVC alloc] initWithReuseIdentifier:@"_tvcResidence"];
    
    self.arrMain = @[_tvcPhoto,
                     _tvcNickName,
                     _tvcSign,
                     _tvcSex,
                     _tvcBirthday,
                     _tvcEducation,
                     _tvcTrade,
                     _tvcJoinTime,
                     _tvcCompany,
                     _tvcResidence,
                     ];
    
    _tvFrame = VIEW_ITEM_FRAME;
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:_tvFrame];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self innerEvent];
    
    [super innerInit];
}

-(void)innerData
{
    ModelUser *model = [AppSetting getUserLogin];
    
    [_tvcPhoto setCellDataWithModel:model];
    [_tvcNickName setCellDataWithModel:model];
    [_tvcSign setCellDataWithModel:model];
    [_tvcSex setCellDataWithModel:model];
    [_tvcBirthday setCellDataWithModel:model];
    [_tvcEducation setCellDataWithModel:model];
    [_tvcTrade setCellDataWithModel:model];
    [_tvcJoinTime setCellDataWithModel:model];
    [_tvcPhoto setCellDataWithModel:model];
    [_tvcCompany setCellDataWithModel:model];
    [_tvcResidence setCellDataWithModel:model];
}

-(void)innerEvent
{
    ZWEAKSELF
    [self.tvcPhoto setOnPhotoClick:^{
        [weakSelf setPhotoClick];
    }];
    [self.tvcNickName setOnBeginEdit:^{
        _rowIndex = 1;
    }];
    [self.tvcSign setOnBeginEdit:^{
        _rowIndex = 2;
    }];
    [self.tvcSex setOnBeginEdit:^{
        _rowIndex = 3;
    }];
    [self.tvcBirthday setOnBeginEdit:^{
        if (!weakSelf.isSetBirthday) {
            [weakSelf setIsSetBirthday:YES];
            [weakSelf.tvcBirthday setCellDateTimeWithModel:[AppSetting getUserLogin]];
        }
        _rowIndex = 4;
    }];
    [self.tvcEducation setOnBeginEdit:^{
        _rowIndex = 5;
    }];
    [self.tvcTrade setOnBeginEdit:^{
        _rowIndex = 6;
    }];
    [self.tvcJoinTime setOnBeginEdit:^{
        if (!weakSelf.isSetJoinTime) {
            [weakSelf setIsSetJoinTime:YES];
            [weakSelf.tvcJoinTime setCellDateTimeWithModel:[AppSetting getUserLogin]];
        }
        _rowIndex = 7;
    }];
    [self.tvcCompany setOnBeginEdit:^{
        _rowIndex = 8;
    }];
    [self.tvcResidence setOnBeginEdit:^{
        _rowIndex = 9;
    }];
    [self.tvcResidence setOnSelectCity:^(NSString *resultString) {
        [weakSelf.tvcResidence.textField setText:resultString];
    }];
    [self.tvcResidence setOnDoneClick:^(NSString *resultString) {
        [weakSelf.view endEditing:YES];
        [weakSelf.tvcResidence.textField setText:resultString];
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
    
    NSString *newNickName = _tvcNickName.getText;
    NSString *newSign = _tvcSign.getSign;
    WTSexType sexType = _tvcSex.getSelectSexType;
    NSString *newBirthday = _tvcBirthday.getText;
    NSString *newEducation = _tvcEducation.getText;
    NSString *newTrade = _tvcTrade.getText;
    NSString *newJoinTime = _tvcJoinTime.getText;
    NSString *newCompany = _tvcCompany.getText;
    NSString *newAddress = _tvcResidence.getText;
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
    
    NSString *newNickName = _tvcNickName.getText;
    NSString *newSign = _tvcSign.getSign;
    WTSexType sexType = _tvcSex.getSelectSexType;
    NSString *newBirthday = _tvcBirthday.getText;
    NSString *newEducation = _tvcEducation.getText;
    NSString *newTrade = _tvcTrade.getText;
    NSString *newJoinTime = _tvcJoinTime.getText;
    NSString *newCompany = _tvcCompany.getText;
    NSString *newAddress = _tvcResidence.getText;
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
        [ZAlertView showWithMessage:kIsEditingPersonalInformationDetermineToGiveUpTheEditor doneCompletion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
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
            [ZAlertView showWithMessage:kYouDisableTheAlbumOpenTheAlbumInTheSettingsToUse completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                switch (selectIndex) {
                    case 1:
                    {
                        SafariOpen(UIApplicationOpenSettingsURLString);
                        break;
                    }
                    default:
                        break;
                }
            } cancelTitle:kClose doneTitle:kSetting];
            break;
        case PHAuthorizationStatusRestricted:
            // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
            [ZAlertView showWithMessage:kYouAreUsingParentalControl];
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
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        ZImagePickerController *imagepicker = [[ZImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagepicker.delegate = self;
        [self presentViewController:imagepicker animated:YES completion:nil];
    } else {
        [ZAlertView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
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
            [ZAlertView showWithMessage:kYouDisableTheCameraOpenTheCameraInTheSettingsToUse completion:^(ZAlertView *alertView, NSInteger selectIndex) {
                switch (selectIndex) {
                    case 1:
                    {
                        SafariOpen(UIApplicationOpenSettingsURLString);
                        break;
                    }
                    default:
                        break;
                }
            } cancelTitle:kClose doneTitle:kSetting];
            break;
        case AVAuthorizationStatusRestricted:
            // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
            [ZAlertView showWithMessage:kYouAreUsingParentalControl];
            break;
        case AVAuthorizationStatusAuthorized:
            // 用户已经授权应用访问照片数据
            [self showCamera];
            break;
        default:
            break;
    }
}
///调用相机
-(void)showCamera
{
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        ZImagePickerController *imagepicker = [[ZImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagepicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        imagepicker.mediaTypes = @[(NSString*)kUTTypeImage];
        imagepicker.delegate = self;
        [self presentViewController:imagepicker animated:YES completion:nil];
    } else {
        [ZAlertView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
    }
}

-(void)setPhotoClick
{
    ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithPictureSelectionDelegate:self];
    [actionSheet setTag:11];
    [actionSheet show];
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

#pragma mark - ZActionSheetDelegate

-(void)actionSheet:(ZActionSheet *)actionSheet didButtonClickWithIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 11:
        {
            switch (buttonIndex) {
                case 0: [self checkAlbumAuthorization]; break;
                case 1: [self checkCameraAuthorization]; break;
                default: break;
            }
            break;
        }
        default:break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if (mediaType && [mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            if (originalImage) {
                if (![Utils checkImageSizeIsDefault:originalImage]) {
                    GCDMainBlock(^{
                        [ZProgressHUD showError:kPictureSizeDoesNotMeetTheRequirements];
                    });
                    return;
                }
                ZCutImageViewController *itemVC = [[ZCutImageViewController alloc] initWithImage:originalImage];
                [itemVC setDelegate:self];
                GCDMainBlock(^{
                    [self presentViewController:itemVC animated:YES completion:nil];
                });
            } else {
                GCDMainBlock(^{
                    [ZProgressHUD showError:kThePhotosYouHaveSelectedHaveBeenCorrupted];
                });
            }
        } else {
            GCDMainBlock(^{
                [ZProgressHUD showError:kThePhotosYouHaveSelectedHaveBeenCorrupted];
            });
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZCutImageViewControllerDelegate

-(void)cutImageViewController:(ZCutImageViewController *)cutImageVC finishClipImage:(UIImage *)editImage
{
    [cutImageVC dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (editImage != nil) {
            UIImage *newImage = [[UIImage alloc] initWithCGImage:editImage.CGImage scale:1 orientation:UIImageOrientationRight];
            NSString *createFilePath=[NSString stringWithFormat:@"%@/%@",[AppSetting getTempFilePath],kRandomImageName];
            NSData *imagedata = [Utils writeImage:newImage toFileAtPath:createFilePath];
            if (imagedata != nil) {
                GCDMainBlock(^(void){
                    [self setStrPhoto:createFilePath];
                    [self.tvcPhoto setUserPhoto:imagedata];
                });
            }
        } else {
            GCDMainBlock(^(void){
                [ZProgressHUD showError:kThePhotosYouHaveCutHaveBeenCorrupted];
            });
        }
    });
}

-(void)cutImageViewControllerDidCancel:(ZCutImageViewController *)cutImageVC
{
    [cutImageVC dismissViewControllerAnimated:YES completion:nil];
}

@end
