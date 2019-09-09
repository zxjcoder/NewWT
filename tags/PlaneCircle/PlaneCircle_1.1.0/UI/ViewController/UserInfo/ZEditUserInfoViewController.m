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

#import "ZImagePickerController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ZEditUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZActionSheetDelegate>
{
    CGRect _tvFrame;
    NSInteger _rowIndex;
}

@property (strong, nonatomic) ZUserEditHeaderTVC *tvcHeader;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace;
@property (strong, nonatomic) ZUserEditSexTVC *tvcEditSex;
@property (strong, nonatomic) ZUserEditTradeTVC *tvcEditTrade;
@property (strong, nonatomic) ZUserEditCompanyTVC *tvcEditCompany;
@property (strong, nonatomic) ZUserEidtResidenceTVC *tvcEidtResidence;

@property (strong, nonatomic) ZTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) NSString *strPhoto;

@end

@implementation ZEditUserInfoViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"编辑个人资料"];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"完成"];
    
    [self registerKeyboardNotification];
    
    ZNavigationBarView *barView = [self.view viewWithTag:10001000];
    if (barView) {
        ZWEAKSELF
        [barView setBackButtonClick:^(UIButton *button) {
            [weakSelf btnBackClick];
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

- (void)setViewFrame
{
    _tvFrame = VIEW_ITEM_FRAME;
    [self.tvMain setFrame:_tvFrame];
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
    OBJC_RELEASE(_tvcHeader);
    OBJC_RELEASE(_tvcSpace);
    OBJC_RELEASE(_tvcEditSex);
    OBJC_RELEASE(_tvcEditTrade);
    OBJC_RELEASE(_tvcEditCompany);
    OBJC_RELEASE(_tvcEidtResidence);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcHeader = [[ZUserEditHeaderTVC alloc] initWithReuseIdentifier:@"tvcHeader"];
    self.tvcSpace = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    self.tvcEditSex = [[ZUserEditSexTVC alloc] initWithReuseIdentifier:@"tvcEditSex"];
    self.tvcEditTrade = [[ZUserEditTradeTVC alloc] initWithReuseIdentifier:@"tvcEditTrade"];
    self.tvcEditCompany = [[ZUserEditCompanyTVC alloc] initWithReuseIdentifier:@"tvcEditCompany"];
    self.tvcEidtResidence = [[ZUserEidtResidenceTVC alloc] initWithReuseIdentifier:@"tvcEidtResidence"];
    
    self.arrMain = @[self.tvcHeader,self.tvcSpace,self.tvcEditSex,self.tvcEditTrade,self.tvcEditCompany,self.tvcEidtResidence];
    
    self.tvMain = [[ZTableView alloc] initWithFrame:_tvFrame style:(UITableViewStylePlain)];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    [self innerData];
    
    [self innerEvent];
}

-(void)innerData
{
    ModelUser *model = [AppSetting getUserLogin];
    [self.tvcHeader setCellDataWithModel:model];
    [self.tvcEditSex setCellDataWithModel:model];
    [self.tvcEditTrade setCellDataWithModel:model];
    [self.tvcEditCompany setCellDataWithModel:model];
    [self.tvcEidtResidence setCellDataWithModel:model];
}

-(void)innerEvent
{
    ZWEAKSELF
    [self.tvcHeader setOnPhotoClick:^{
        [weakSelf setPhotoClick];
    }];
    [self.tvcEditTrade setOnBeginEdit:^{
        _rowIndex = 3;
    }];
    [self.tvcEditCompany setOnBeginEdit:^{
        _rowIndex = 4;
    }];
    [self.tvcEidtResidence setOnBeginEdit:^{
        _rowIndex = 5;
    }];
    [self.tvcEidtResidence setOnSelectCity:^(NSString *resultString) {
        [weakSelf.tvcEidtResidence.textField setText:resultString];
    }];
    [self.tvcEidtResidence setOnDoneClick:^(NSString *resultString) {
        [weakSelf.view endEditing:YES];
        [weakSelf.tvcEidtResidence.textField setText:resultString];
    }];
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
    NSString *newNickName = self.tvcHeader.getNickName;
    NSString *newSign = self.tvcHeader.getSign;
    WTSexType sexType = self.tvcEditSex.getSelectSexType;
    NSString *newTrade = self.tvcEditTrade.getText;
    NSString *newCompany = self.tvcEditCompany.getText;
    NSString *newAddress = self.tvcEidtResidence.getText;
    if (self.strPhoto == nil && self.strPhoto.length == 0
        && [newNickName isEqualToString:model.nickname==nil?kEmpty:model.nickname]
        && [newSign isEqualToString:model.sign==nil?kEmpty:model.sign]
        && sexType == model.sex
        && [newTrade isEqualToString:model.trade==nil?kEmpty:model.trade]
        && [newCompany isEqualToString:model.company==nil?kEmpty:model.company]
        && [newAddress isEqualToString:model.address==nil?kEmpty:model.address]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([newNickName isEmpty]) {
        [ZProgressHUD showError:@"昵称不能为空"];
        return;
    }
    if (![newNickName isNickName]) {
        [ZProgressHUD showError:@"昵称[1-12]的字母,数字,汉字"];
        return;
    }
    if (newSign.length > 30) {
        [ZProgressHUD showError:@"个性签名[<=30]字符,你输入太多了"];
        return;
    }
    if (newTrade.length > 10) {
        [ZProgressHUD showError:@"行业内容[<=10]字符,你输入太多了"];
        return;
    }
    if ([newCompany isChinese]) {
        if (newCompany.length > 20) {
            [ZProgressHUD showError:@"公司名称[<=20]文字,你输入的太多了"];
            return;
        }
    } else {
        if (newCompany.length > 60) {
            [ZProgressHUD showError:@"公司名称[<=60]字符,你输入的太多了"];
            return;
        }
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在编辑,请稍等..."];
    [sns postUpdateUserInfoWithAccount:[AppSetting getUserDetauleId] headImg:self.strPhoto nickname:newNickName signature:newSign sex:sexType trade:newTrade company:newCompany address:newAddress resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            
            [weakSelf setUserInfoChange:result];
            
            [ZAlertView showWithMessage:@"个人资料编辑成功" doneCompletion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

-(void)btnBackClick
{
    [self.view endEditing:YES];
    ModelUser *model = [AppSetting getUserLogin];
    NSString *newNickName = self.tvcHeader.getNickName;
    NSString *newSign = self.tvcHeader.getSign;
    WTSexType sexType = self.tvcEditSex.getSelectSexType;
    NSString *newTrade = self.tvcEditTrade.getText;
    NSString *newCompany = self.tvcEditCompany.getText;
    NSString *newAddress = self.tvcEidtResidence.getText;
    if (self.strPhoto != nil || self.strPhoto.length > 0
        || ![newNickName isEqualToString:model.nickname]
        || ![newSign isEqualToString:model.sign]
        || sexType != model.sex
        || ![newTrade isEqualToString:model.trade]
        || ![newCompany isEqualToString:model.company]
        || ![newAddress isEqualToString:model.address]) {
        ZWEAKSELF
        [ZAlertView showWithMessage:@"正在编辑个人资料,确定放弃编辑吗?" doneCompletion:^{
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

-(void)showAlbum
{
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        ZImagePickerController *imagepicker = [[ZImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagepicker.delegate = self;
        imagepicker.allowsEditing = YES;
        if (APP_SYSTEM_VERSION > 8) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            imagepicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:imagepicker animated:YES completion:nil];
    } else {
        [ZAlertView showWithMessage:@"你的设备不支持相册"];
    }
}

-(void)showCamera
{
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        ZImagePickerController *imagepicker = [[ZImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagepicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        imagepicker.mediaTypes = @[(NSString*)kUTTypeImage];
        imagepicker.delegate = self;
        imagepicker.allowsEditing = YES;
        if (APP_SYSTEM_VERSION > 8) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            imagepicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:imagepicker animated:YES completion:nil];
    } else {
        [ZAlertView showWithMessage:@"你的设备不支持相机"];
    }
}

-(void)setPhotoClick
{
    [self.view endEditing:YES];
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
                case 0: [self showAlbum]; break;
                case 1: [self showCamera]; break;
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
    ZWEAKSELF
    [self.view setNeedsDisplay];
//    [picker dismissViewControllerAnimated:YES completion:^{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//            if (image != nil) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    ZCutImageViewController *cutImageVC = [[ZCutImageViewController alloc] initWithImage:image];
//                    [cutImageVC setDelegate:weakSelf];
//                    [weakSelf.navigationController pushViewController:cutImageVC animated:YES];
//                });
//            }
//        });
//    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *editimage = [info objectForKey:UIImagePickerControllerEditedImage];
            if (editimage != nil) {
                NSString *createFilePath=[NSString stringWithFormat:@"%@/%@",[AppSetting getTempFilePath],kRandomImageName];
                NSData *imagedata = [Utils writeImage:editimage toFileAtPath:createFilePath];
                if (imagedata != nil) {
                    GCDMainBlock(^(void){
                        [weakSelf setStrPhoto:createFilePath];
                        [weakSelf.tvcHeader setUserPhoto:imagedata];
                    });
                }
            }
        }
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark - ZCutImageViewControllerDelegate
//
//-(void)cutImageViewController:(ZCutImageViewController *)cutImageVC finishClipImage:(UIImage *)editImage
//{
//    ZWEAKSELF
//    [self.view setNeedsDisplay];
//    if (editImage != nil) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *createFilePath=[NSString stringWithFormat:@"%@/%@",[AppSetting getTempFilePath],kRandomImageName];
//            NSData *imagedata = [Utils writeImage:editImage toFileAtPath:createFilePath];
//            if (imagedata != nil) {
//                GCDMainBlock(^(void){
//                    [weakSelf setStrPhoto:createFilePath];
//                    [weakSelf.tvcHeader setUserPhoto:imagedata];
//                });
//            }
//        });
//    }
//    [cutImageVC.navigationController popViewControllerAnimated:YES];
//}

@end
