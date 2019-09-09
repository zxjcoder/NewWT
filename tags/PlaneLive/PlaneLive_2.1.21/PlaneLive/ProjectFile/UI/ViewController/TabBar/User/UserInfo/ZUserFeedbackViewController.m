//
//  ZUserFeedbackViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserFeedbackViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "ZImagePickerController.h"
#import "ZTextView.h"
#import "ZUserFeedbackFooter.h"

@interface ZUserFeedbackViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZActionSheetDelegate,TZImagePickerControllerDelegate>

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) ZUserFeedbackFooter *viewFooter;

@property (assign, nonatomic) CGRect textFrame;

@property (assign, nonatomic) CGRect footerFrame;

@property (assign, nonatomic) NSRange lastRange;

@property (assign, nonatomic) NSUInteger imgMaxCount;

@end

@implementation ZUserFeedbackViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kFeedback];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:kSubmit];
    
    [self registerKeyboardNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
    
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
    OBJC_RELEASE(_textView);
    OBJC_RELEASE(_viewFooter);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.view setBackgroundColor:WHITECOLOR];
    
    ZWEAKSELF
    self.footerFrame = CGRectMake(0, APP_FRAME_HEIGHT-[ZUserFeedbackFooter getViewH], APP_FRAME_WIDTH, [ZUserFeedbackFooter getViewH]);
    self.viewFooter = [[ZUserFeedbackFooter alloc] initWithFrame:self.footerFrame];
    [self.viewFooter setOnImageClick:^{
        [weakSelf setImageClick];
    }];
    [self.viewFooter setChangeTextLength:0];
    [self.view addSubview:self.viewFooter];
    
    self.textFrame = CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-[ZUserFeedbackFooter getViewH]);
    self.textView = [[ZTextView alloc] init];
    [self.textView setViewFrame:self.textFrame];
    [self.textView setReturnKeyType:(UIReturnKeyDone)];
    [self.textView setDescColorCount:4];
    [self.textView setOnTextDidChange:^(NSString *text, NSRange range) {
        [weakSelf.viewFooter setChangeTextLength:text.length];
    }];
    [self.textView setOnRevokeChange:^(NSString *text, NSRange range) {
        [weakSelf.viewFooter setChangeTextLength:text.length];
    }];
    //结束编辑的时候
    [self.textView setOnEndEditText:^(NSString *text, NSRange selectedRange) {
        [weakSelf setLastRange:selectedRange];
    }];
    [self.textView setPlaceholderText:kThankYouForYourValuableSuggestionsOnTheImprovementOfLive];
    [self.view addSubview:self.textView];
    
    [super innerInit];
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
///调用相册
-(void)showAlbum
{
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSInteger columnNumber = 4;
        if (IsIPadDevice) {
            columnNumber = 8;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.imgMaxCount delegate:self];
        imagePickerVc.isSelectOriginalPhoto = YES;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.alwaysEnableDoneBtn = YES;
        imagePickerVc.minPhotoWidthSelectable = 300;
        imagePickerVc.minPhotoHeightSelectable = 300;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } else {
        [ZAlertView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
    }
}
///调用相机
-(void)showCamera
{
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        ZImagePickerController *imagepicker = [[ZImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.delegate = self;
        imagepicker.allowsEditing = NO;
        [self presentViewController:imagepicker animated:YES completion:nil];
    } else {
        [ZAlertView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
    }
}
-(void)setImageClick
{
    [self.textView resignFirstResponder];
    __block NSUInteger imgCount = 0;
    NSUInteger imgMaxCount = kFeedbackPicturecMaxLength;
    NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [strAttributed enumerateAttributesInRange:NSMakeRange(0, strAttributed.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *attText = [attrs objectForKey:@"NSAttachment"];
        if (attText && [attText isKindOfClass:[NSTextAttachment class]]) {
            imgCount++;
        }
    }];
    if (imgCount >= imgMaxCount) {
        self.imgMaxCount = 0;
        [ZProgressHUD showError:[NSString stringWithFormat:kFeedbackPictureLengthLimitCharacter, imgMaxCount]];
    } else {
        self.imgMaxCount = imgMaxCount-imgCount;
        ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithPictureSelectionDelegate:self];
        [actionSheet setTag:11];
        [actionSheet show];
    }
}
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect txtFrame = self.textFrame;
    txtFrame.size.height -= height;
    
    [self.textView setViewFrame:txtFrame];
    
    CGRect footerFrame = self.footerFrame;
    footerFrame.origin.y -= height;
    
    [self.viewFooter setFrame:footerFrame];
}
-(void)btnRightClick
{
    [self.view endEditing:YES];
    if (self.isLoaded) {return;}
    [self setIsLoaded:YES];
    NSString *textContent = self.textView.text.toTrim;
    if ([textContent isEmpty]) {
        [ZProgressHUD showError:kFeedbackContentCanNotBeEmpty];
        [self setIsLoaded:NO];
        return;
    }
    if (textContent.length < kFeedbackContentMinLength || textContent.length > kFeedbackContentMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kFeedbackContentLengthLimitCharacter, kFeedbackContentMinLength, kFeedbackContentMaxLength]];
        [self setIsLoaded:NO];
        return;
    }
    NSMutableArray *arrImage = [NSMutableArray array];
    NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [strAttributed enumerateAttributesInRange:NSMakeRange(0, strAttributed.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *attText = [attrs objectForKey:@"NSAttachment"];
        if (attText && [attText isKindOfClass:[NSTextAttachment class]]) {
            ModelImage *modelI = [[ModelImage alloc] init];
            [modelI setImageObject:attText.image];
            [modelI setImageName:kRandomImageName];
            [modelI setLocation:range.location];
            
            [arrImage addObject:modelI];
        }
    }];
    if (arrImage.count > kFeedbackPicturecMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kFeedbackPictureLengthLimitCharacter, kFeedbackPicturecMaxLength]];
        [self setIsLoaded:NO];
        return;
    }
    NSMutableString *content = [NSMutableString stringWithString:[self.textView.text stringByReplacingOccurrencesOfString:kCodeString withString:kEmpty]];
    if (arrImage.count > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_location" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [arrImage sortUsingDescriptors:sortDescriptors];
        ///添加了多少字节
        NSInteger insertLength = 0;
        for (ModelImage *modelImage in arrImage) {
            NSString *imageSrc = [NSString stringWithFormat:@" <img src=\"%@\"/> ",modelImage.imageName];
            
            if ((modelImage.location+insertLength) < content.length) {
                [content insertString:imageSrc atIndex:modelImage.location+insertLength];
            } else {
                [content insertString:imageSrc atIndex:content.length];
            }
            insertLength = insertLength + imageSrc.length;
        }
    }
    NSString *strContent = [NSString stringWithString:content];
    if ([strContent isEmpty]) {
        [ZProgressHUD showError:kFeedbackContentCanNotBeEmpty];
        [self setIsLoaded:NO];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgSubmiting];
    [snsV2 postFeekbackWithContent:strContent imageArray:arrImage resultBlock:^(NSDictionary *result) {
        [weakSelf setIsLoaded:NO];
        [ZProgressHUD dismiss];
        [weakSelf.textView setViewText:kEmpty];
        
        [ZAlertView showWithMessage:kThankYouForYourValuableAdviceAndWeWillDealWithItInATimelyManner completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } errorBlock:^(NSString *msg) {
        [weakSelf setIsLoaded:NO];
        [ZProgressHUD dismiss];
        [ZProgressHUD showError:msg];
    }];
}
-(void)addImageToTextView:(UIImage *)originalimage
{
    if (![Utils checkImageSizeIsDefault:originalimage]) {
        GCDMainBlock(^{
            [ZProgressHUD showError:kPictureSizeDoesNotMeetTheRequirements];
        });
        return;
    }
    CGFloat scale = self.textView.frame.size.width/originalimage.size.width;
    CGFloat imgW = self.textView.frame.size.width-10;
    CGFloat imgH = originalimage.size.height * scale;
    
    UIImage *image = [Utils resizedTransformtoSize:CGSizeMake(imgW, imgH) image:originalimage];
    if (image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        if (imageData) {
            UIImage *newImage = [UIImage imageWithData:imageData];
            if (newImage) {
                NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
                attachment.image = newImage;
                [attachment setBounds:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
                
                NSAttributedString *attText = [NSAttributedString attributedStringWithAttachment:attachment];
                NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
                [strAttributed insertAttributedString:attText atIndex:self.lastRange.location];
                
                [strAttributed addAttribute:NSFontAttributeName value:kTextView_FontWithName range:NSMakeRange(0, strAttributed.length)];
                [strAttributed addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR1 range:NSMakeRange(0, strAttributed.length)];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 5;
                [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
                GCDMainBlock(^{
                    [self.textView setAttributedText:strAttributed];
                    
                    [ZProgressHUD dismiss];
                });
            } else {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                });
            }
        } else {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
            });
        }
    } else {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
        });
    }
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    GCDMainBlock(^{
        [ZProgressHUD showMessage:kBeingInserteding];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *originalimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (originalimage != nil) {
                [self addImageToTextView:originalimage];
            } else {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                });
            }
        } else {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
            });
        }
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if (assets && assets.count > 0) {
        GCDMainBlock(^{
            [ZProgressHUD showMessage:kBeingInserteding];
        });
        ZWEAKSELF
        for (PHAsset *asset in assets) {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result) {
                    [weakSelf addImageToTextView:result];
                }
            }];
        }
    }
}

@end
