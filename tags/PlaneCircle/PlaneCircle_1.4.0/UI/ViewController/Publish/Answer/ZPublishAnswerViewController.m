//
//  ZPublishAnswerViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPublishAnswerViewController.h"
#import "ZTextView.h"
#import "ZQuestionToolbar.h"
#import "ZImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ZTaskCompleteView.h"

static NSString *kCodeString = @"\uFFFC";

@interface ZPublishAnswerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZActionSheetDelegate>

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) ZQuestionToolbar *toolBar;

@property (assign, nonatomic) CGRect textFrame;

@property (assign, nonatomic) NSRange lastRange;

@property (strong, nonatomic) ModelAnswerBase *modelAB;
///是否编辑过数据
@property (assign, nonatomic) BOOL isUpdate;

@end

@implementation ZPublishAnswerViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.modelAB.ids && self.modelAB.ids.length > 0) {
        [self setTitle:kEditAnswer];
    } else {
        [self setTitle:kAddAnswer];
    }
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:kDone];
    
    [self registerKeyboardNotification];
    
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [self.textView resignFirstResponder];
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
    OBJC_RELEASE(_toolBar);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.toolBar = [[ZQuestionToolbar alloc] init];
    
    self.textFrame = VIEW_ITEM_FRAME;
    self.textView = [[ZTextView alloc] init];
    [self.textView setFrame:self.textFrame];
    [self.textView setPlaceholderText:kPleaseWriteDownYourValuableReply];
    [self.textView setInputAccessoryView:self.toolBar];
    [self.textView setIsInputNewLine:YES];
    [self.textView setReturnKeyType:UIReturnKeyDefault];
    [self.textView setFont:kTextView_FontWithName];
    [self.textView setTextColor:BLACKCOLOR1];
    [self.textView setMaxLength:kNumberQuestionAnswerMaxLength];
    [self.view addSubview:self.textView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [self innerEvent];
    
    [self innerData];
}

-(void)innerData
{
    if (self.modelAB.ids && self.modelAB.ids.length > 0) {
        NSArray *imageArray = [Utils getRegularImg:self.modelAB.title];
        if (imageArray.count > 0) {
            [ZProgressHUD showMessage:kBeingProcesseding];
            
            NSMutableArray *arrImageFile = [NSMutableArray array];
            __block NSString *newString = self.modelAB.title;
            __block NSString *strLastTitle = newString;
            NSString *valueRow = @"#$#$*";
            [imageArray enumerateObjectsUsingBlock:^(NSTextCheckingResult *ele, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *theLastString = [self.modelAB.title substringWithRange:[ele rangeAtIndex:idx]];
                NSString *value = [NSString stringWithFormat:@"%@%d",valueRow,(int)idx];
                NSString *key = [NSString stringWithFormat:@"&%@&",value];
                newString = [newString stringByReplacingOccurrencesOfString:theLastString withString:key];
                
                strLastTitle = [strLastTitle stringByReplacingOccurrencesOfString:theLastString withString:@" "];
                
                [arrImageFile addObject:theLastString];
            }];
            //获取图片数据集合
            NSArray *arrSepValue = [newString componentsSeparatedByString:@"&"];
            
            NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:newString];
            ZWEAKSELF
            //替换内容成对应图片
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                int index = 0;
                for (NSString *sepValue in arrSepValue) {
                    NSString *value = [NSString stringWithFormat:@"%@%d",valueRow,index];
                    if ([sepValue isEqualToString:value]) {
                        if (arrImageFile.count > index) {
                            NSString *imgHtml = [arrImageFile objectAtIndex:index];
                            NSString *imgPath = [Utils getTrimImg:imgHtml];
                            
                            NSString *strFileName = [NSString stringWithFormat:@"%@.jpeg",[Utils stringMD5:imgPath]];
                            NSString *strCachePath = [[AppSetting getAnswerFilePath] stringByAppendingPathComponent:strFileName];
                            UIImage *image = nil;
                            if ([[NSFileManager defaultManager] fileExistsAtPath:strCachePath]) {
                                image = [UIImage imageWithContentsOfFile:strCachePath];
                            } else {
                                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgPath]]];
                            }
                            if (image) {
                                CGFloat scale = weakSelf.textView.frame.size.width/image.size.width;
                                CGFloat imgW = weakSelf.textView.frame.size.width-10;
                                CGFloat imgH = image.size.height * scale;
                                
                                UIImage *newImage = [Utils resizedTransformtoSize:CGSizeMake(imgW, imgH) image:image];
                                
                                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                                attachment.image = newImage;
                                [attachment setBounds:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
                                
                                NSAttributedString *text = [NSAttributedString attributedStringWithAttachment:attachment];
                                NSRange range = [[strAttributed string] rangeOfString:[NSString stringWithFormat:@"&%@&",value]];
                                [strAttributed replaceCharactersInRange:range withAttributedString:text];
                            } else {
                                NSAttributedString *text = [[NSAttributedString alloc] initWithString:kEmpty];
                                NSRange range = [[strAttributed string] rangeOfString:[NSString stringWithFormat:@"&%@&",value]];
                                [strAttributed replaceCharactersInRange:range withAttributedString:text];
                            }
                            index++;
                        }
                    }
                }
                [strAttributed addAttribute:NSFontAttributeName value:kTextView_FontWithName range:NSMakeRange(0, strAttributed.length)];
                [strAttributed addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR1 range:NSMakeRange(0, strAttributed.length)];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 5;
                [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
                GCDMainBlock(^{
                    [weakSelf.textView setAttributedText:strAttributed];
                    
                    [ZProgressHUD dismiss];
                });
            });
        } else {
            NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:self.modelAB.title];
            
            [strAttributed addAttribute:NSFontAttributeName value:kTextView_FontWithName range:NSMakeRange(0, strAttributed.length)];
            [strAttributed addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR1 range:NSMakeRange(0, strAttributed.length)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
            
            [self.textView setAttributedText:strAttributed];
        }
    } else {
        NSString *content =  [sqlite getSysParamWithKey:kSQLITE_LAST_ANSWER_CONTENT];
        [self.textView setViewText:content];
    }
}

-(void)innerEvent
{
    ZWEAKSELF
    [self.toolBar setOnDoneClick:^{
        [weakSelf.view endEditing:YES];
    }];
    [self.toolBar setOnPhotoClick:^{
        [weakSelf setPhotoClick];
    }];
    //结束编辑的时候
    [self.textView setOnEndEditText:^(NSString *text, NSRange selectedRange) {
        [weakSelf setLastRange:selectedRange];
    }];
    //编辑的时候
    [self.textView setOnTextDidChange:^(NSString *content, NSRange range) {
        
        [weakSelf setIsUpdate:YES];
    }];
    //撤销的时候
    [self.textView setOnRevokeChange:^(NSString *content, NSRange range) {
        
        [weakSelf setIsUpdate:YES];
    }];
}
-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.textView resignFirstResponder];
    }
}
-(void)btnRightClick
{
    [self.view endEditing:YES];
    
    if (!self.isUpdate && self.modelAB.ids && self.modelAB.ids.length > 0) {
        [ZProgressHUD showSuccess:kEditorSuccessful];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSArray *arrImages = [Utils getRegularImg:self.textView.text];
    if (arrImages.count > 1) {
        [ZProgressHUD showError:kAnswerTheContentCanNotHaveIMGTags];
        return;
    }
    if (self.textView.text.toTrim.length == 0) {
        [ZProgressHUD showError:kAnswerTheContentCanNotBeEmpty];
        return;
    }
    if (self.textView.text.length < kNumberQuestionAnswerMinLength || self.textView.text.length > kNumberQuestionAnswerMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kAnswerTheContentLengthLimitCharacter, kNumberQuestionAnswerMinLength, kNumberQuestionAnswerMaxLength]];
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
    if (arrImage.count > kNumberQuestionAnswerPicturecMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kAnswerThePictureLengthLimitNumber, kNumberQuestionAnswerPicturecMaxLength]];
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
    
    NSString *questionId = self.modelAB.question_id;
    ///有问题关联
    if (questionId && questionId.length > 0) {
        NSString *answerId = self.modelAB.ids;
        //编辑答案
        if (answerId && answerId.length > 0) {
            ZWEAKSELF
            NSString *userId = [AppSetting getUserDetauleId];
            [ZProgressHUD showMessage:kCMsgEditing];
            [sns postUpdAnswerWithQuestionId:questionId answerId:answerId content:strContent userId:userId answerImg:arrImage resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showSuccess:kEditorSuccessful];
                    
                    [weakSelf postPublishQuestionNotification];
                    
                    [sqlite setSysParam:kSQLITE_LAST_ANSWER_CONTENT value:kEmpty];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            ZWEAKSELF
            NSString *userId = [AppSetting getUserDetauleId];
            [ZProgressHUD showMessage:kCMsgAnswering];
            [sns postAddAnswerWithQuestionId:questionId content:strContent userId:userId answerImg:arrImage resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf postPublishQuestionNotification];
                    
                    [sqlite setSysParam:kSQLITE_LAST_ANSWER_CONTENT value:kEmpty];
                    
                    if (![_modelAB.userIdQ isEqualToString:[AppSetting getUserDetauleId]]) {
                        ///编辑任务
                        ModelTask *modelTask = [sqlite getLocalTaskModelWithUserId:[AppSetting getUserDetauleId] rule:ZTaskTypeAnswerOtherUserQuestion];
                        if (modelTask && modelTask.status == 0) {
                            [DataOper140 updMyTaskWithUserId:[AppSetting getUserDetauleId] taskId:modelTask.ids resultBlock:^(NSDictionary *result) {
                                GCDMainBlock(^{
                                    [ZProgressHUD dismiss];
                                    
                                    NSString *resultVal = [result objectForKey:kResultKey];
                                    if (resultVal && ![resultVal isKindOfClass:[NSNull class]] && [resultVal intValue] == 0) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:ZTaskCompleteNotification object:modelTask.speech_id];
                                    }
                                    [modelTask setStatus:1];
                                    [sqlite setLocalTaskModelWithModel:modelTask userId:[AppSetting getUserDetauleId]];
                                    
                                    ZTaskCompleteView *taskCompleteView = [[ZTaskCompleteView alloc] init];
                                    [taskCompleteView setOnSubmitClick:^{
                                        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:ZChangeTabbarItem object:@"1"];
                                    }];
                                    [taskCompleteView setOnCancelClick:^{
                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                    }];
                                    [taskCompleteView show];
                                });
                            } errorBlock:^(NSString *msg) {
                                GCDMainBlock(^{
                                    [ZProgressHUD dismiss];
                                    [ZProgressHUD showSuccess:kSuccessAnswersQuestions];
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                });
                            }];
                        } else {
                            [ZProgressHUD dismiss];
                            [ZProgressHUD showSuccess:kSuccessAnswersQuestions];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                    } else {
                        [ZProgressHUD dismiss];
                        [ZProgressHUD showSuccess:kSuccessAnswersQuestions];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    } else {
        [ZProgressHUD showError:kNoProblemCanNotAnswer];
    }
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect textFrame = self.textFrame;
    textFrame.size.height -= height;
    [self.textView setFrame:textFrame];
}

-(BOOL)checkMaxSelectImage
{
    NSMutableArray *arrImage = [NSMutableArray array];
    NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [strAttributed enumerateAttributesInRange:NSMakeRange(0, strAttributed.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *attText = [attrs objectForKey:@"NSAttachment"];
        if (attText && [attText isKindOfClass:[NSTextAttachment class]]) {
            [arrImage addObject:kEmpty];
        }
    }];
    if (arrImage. count > kNumberQuestionAnswerPicturecMaxLength) {
        return YES;
    }
    return NO;
}

-(void)showAlbum
{
    if ([ZImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        ZImagePickerController *imagepicker = [[ZImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagepicker.delegate = self;
        [self presentViewController:imagepicker animated:YES completion:nil];
        
        [[ZDragButton shareDragButton] dismiss];
    } else {
        [ZAlertView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
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
        [self presentViewController:imagepicker animated:YES completion:nil];
        
        [[ZDragButton shareDragButton] dismiss];
    } else {
        [ZAlertView showWithMessage:kYourDeviceDoesNotSupportTheCamera];
    }
}

-(void)setPhotoClick
{
    if ([self checkMaxSelectImage]) {
        [ZProgressHUD showError:[NSString stringWithFormat:kAnswerThePictureLengthLimitNumber, kNumberQuestionAnswerPicturecMaxLength]];
        return;
    }
    [self.view endEditing:YES];
    ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithPictureSelectionDelegate:self];
    [actionSheet setTag:11];
    [actionSheet show];
}

-(void)setNewAnswerWithModel:(ModelAnswerBase *)model
{
    if (self.preVC) {
        [self.preVC performSelector:@selector(setNewAnswerWithModel:) withObject:model afterDelay:0];
    }
}

-(void)setViewDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
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
    [self setIsUpdate:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [ZProgressHUD showMessage:kBeingInserteding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *originalimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (originalimage != nil) {
                CGFloat scale = weakSelf.textView.frame.size.width/originalimage.size.width;
                CGFloat imgW = weakSelf.textView.frame.size.width-10;
                CGFloat imgH = originalimage.size.height * scale;
                
                UIImage *newImage = [Utils resizedTransformtoSize:CGSizeMake(imgW, imgH) image:originalimage];
                if (newImage) {
                    NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
                    attachment.image = newImage;
                    [attachment setBounds:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
                    
                    NSAttributedString *attText = [NSAttributedString attributedStringWithAttachment:attachment];
                    NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
                    [strAttributed insertAttributedString:attText atIndex:weakSelf.lastRange.location];
                    
                    [strAttributed addAttribute:NSFontAttributeName value:kTextView_FontWithName range:NSMakeRange(0, strAttributed.length)];
                    [strAttributed addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR1 range:NSMakeRange(0, strAttributed.length)];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = 5;
                    [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
                    GCDMainBlock(^{
                        [weakSelf.textView setAttributedText:strAttributed];
                        
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
    });
    
    if ([[AudioPlayerView shareAudioPlayerView] isPlay]) {
        [[ZDragButton shareDragButton] show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([[AudioPlayerView shareAudioPlayerView] isPlay]) {
        [[ZDragButton shareDragButton] show];
    }
}

@end
