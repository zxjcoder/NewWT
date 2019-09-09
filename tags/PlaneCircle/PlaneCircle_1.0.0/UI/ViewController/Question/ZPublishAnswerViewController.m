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

#import <MobileCoreServices/MobileCoreServices.h>

static NSString *kCodeString = @"\uFFFC";

@interface ZPublishAnswerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZActionSheetDelegate>

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) ZQuestionToolbar *toolBar;

@property (assign, nonatomic) CGRect textFrame;

@property (strong, nonatomic) NSMutableArray *arrImage;

@property (assign, nonatomic) NSRange lastRange;

@property (strong, nonatomic) NSString *lastContent;

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
        [self setTitle:@"编辑回答"];
    } else {
        [self setTitle:@"添加回答"];
    }
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"完成"];
    
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

-(void)setViewNil
{
    OBJC_RELEASE(_textView);
    OBJC_RELEASE(_arrImage);
    OBJC_RELEASE(_toolBar);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrImage = [NSMutableArray array];
    
    self.toolBar = [[ZQuestionToolbar alloc] init];
    
    self.textFrame = VIEW_ITEM_FRAME;
    self.textView = [[ZTextView alloc] init];
    [self.textView setFrame:self.textFrame];
    [self.textView setPlaceholderText:@"请写下您宝贵的回答"];
    [self.textView setInputAccessoryView:self.toolBar];
    [self.textView setIsInputNewLine:YES];
    [self.textView setReturnKeyType:UIReturnKeyDefault];
    [self.textView setFont:kTextView_FontWithName];
    [self.textView setTextColor:BLACKCOLOR1];
    [self.view addSubview:self.textView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [self innerEvent];
    
    [self innerData];
}

-(void)innerData
{
    if (self.modelAB.ids && self.modelAB.ids.length > 0) {
        
        NSString *string = [self.modelAB.title stringByReplacingOccurrencesOfString:kCodeString withString:kEmpty];
        
        NSString *strLastTitle = string;
        
        NSArray *theArray = [Utils getRegularImg:string];
        
        NSString *newString = string;
        
        NSMutableArray *arrImageFile = [NSMutableArray array];
        if (theArray.count > 0) {
            
            [ZProgressHUD showMessage:@"正在加载,请稍等..." toView:self.view];
            
            NSString *valueRow = @"@!#$@!#$@!#$@!#$";
            
            __block int row = 0;
            for (NSTextCheckingResult *ele in theArray) {
                
                NSString *theLastString = [string substringWithRange:[ele rangeAtIndex:0]];
                
                NSString *value = [NSString stringWithFormat:@"%@%d",valueRow,row];
                NSString *key = [NSString stringWithFormat:@"&%@&",value];
                newString = [newString stringByReplacingOccurrencesOfString:theLastString withString:key];
                
                strLastTitle = [strLastTitle stringByReplacingOccurrencesOfString:theLastString withString:@" "];
                
                [arrImageFile addObject:theLastString];
                
                row++;
            }
            //获取图片数据集合
            NSArray *arrSepValue = [newString componentsSeparatedByString:@"&"];
            
            NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:newString];
            //替换内容成对应图片
            row = 0;
            ZWEAKSELF
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (NSString *sepValue in arrSepValue) {
                    NSString *value = [NSString stringWithFormat:@"%@%d",valueRow,row];
                    if ([sepValue isEqualToString:value]) {
                        if (arrImageFile.count > row) {
                            NSString *imgHtml = [arrImageFile objectAtIndex:row];
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
                                
                                GCDMainBlock(^{
                                    ModelImage *modelImage = [[ModelImage alloc] init];
                                    [modelImage setImagePath:strCachePath];
                                    [modelImage setImageName:strFileName];
                                    [modelImage setLocation:range.location];
                                    [weakSelf.arrImage addObject:modelImage];
                                });
                            } else {
                                NSAttributedString *text = [[NSAttributedString alloc] initWithString:kEmpty];
                                NSRange range = [[strAttributed string] rangeOfString:[NSString stringWithFormat:@"&%@&",value]];
                                [strAttributed replaceCharactersInRange:range withAttributedString:text];
                            }
                            row++;
                        }
                    }
                }
                GCDMainBlock(^{
                    [strAttributed addAttribute:NSFontAttributeName value:kTextView_FontWithName range:NSMakeRange(0, strAttributed.length)];
                    [strAttributed addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR1 range:NSMakeRange(0, strAttributed.length)];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = 5;
                    [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
                    
                    [weakSelf.textView setAttributedText:strAttributed];
                    [weakSelf.textView setViewLastText:strLastTitle];
                    
                    [ZProgressHUD dismissForView:weakSelf.view];
                    
                    GBLog(@"EditArrayImage: %@  \n strLastTitle: %@",weakSelf.arrImage , strLastTitle);
                });
            });
        } else {
            NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:newString];
            
            [strAttributed addAttribute:NSFontAttributeName value:kTextView_FontWithName range:NSMakeRange(0, strAttributed.length)];
            [strAttributed addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR1 range:NSMakeRange(0, strAttributed.length)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
            
            [self.textView setAttributedText:strAttributed];
            [self.textView setViewLastText:strLastTitle];
            
            GBLog(@"EditArrayImage: %@  \n strLastTitle: %@",self.arrImage , strLastTitle);
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
    [self.textView setOnEndEditText:^(NSRange range) {
        GBLog(@"textView selectedRange->location: %d", (int)range.location);
        [weakSelf setLastRange:range];
    }];
    //编辑的时候
    [self.textView setOnTextDidChange:^(NSString *content, NSRange range, int inputLength) {
        
        [weakSelf setIsUpdate:YES];
        
        if (weakSelf.arrImage.count > 0) {
            [weakSelf.arrImage enumerateObjectsUsingBlock:^(ModelImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (range.location < obj.location) {
                    GBLog(@"setOnTextEditing OldLocation: %ld", (long)obj.location);
                    obj.location = obj.location + inputLength;
                    GBLog(@"setOnTextEditing NewLocation: %ld", (long)obj.location);
                }
            }];
        }
        
        [sqlite setSysParam:kSQLITE_LAST_ANSWER_CONTENT value:content];
    }];
    //撤销的时候
    [self.textView setOnRevokeChange:^(NSRange range, int inputLength) {
        
        [weakSelf setIsUpdate:YES];
        
        if (weakSelf.arrImage.count > 0) {
            [weakSelf.arrImage enumerateObjectsUsingBlock:^(ModelImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (range.location == obj.location) {
                    GBLog(@"setOnRevokeChange DeleteImage: %ld", (long)obj.location);
                    [weakSelf.arrImage removeObjectAtIndex:idx];
                } else if (range.location < obj.location) {
                    GBLog(@"setOnRevokeChange OldLocation: %ld", (long)obj.location);
                    obj.location = obj.location - inputLength;
                    GBLog(@"setOnRevokeChange NewLocation: %ld", (long)obj.location);
                }
            }];
        }
        
        [sqlite setSysParam:kSQLITE_LAST_ANSWER_CONTENT value:weakSelf.textView.text];
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
        [ZProgressHUD showSuccess:@"成功编辑回答"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSArray *arrImages = [Utils getRegularImg:self.textView.text];
    if (arrImages.count > 1) {
        [ZProgressHUD showError:@"内容不能包含IMG标签" toView:self.view];
        return;
    }
    NSMutableString *content = [NSMutableString stringWithString:[self.textView.text stringByReplacingOccurrencesOfString:kCodeString withString:kEmpty]];
    
    GBLog(@"PublishAnswer Start Content: %@", content);
    
    if (self.arrImage.count > 0) {
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_location" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [self.arrImage sortUsingDescriptors:sortDescriptors];
        
        ///添加了多少字节
        NSInteger insertLength = 0;
        for (ModelImage *modelImage in self.arrImage) {
            
            NSString *imageSrc = [NSString stringWithFormat:@" <img src=\"%@\"/> ",modelImage.imageName];
            
            if ((modelImage.location+insertLength) < content.length) {
                [content insertString:imageSrc atIndex:modelImage.location+insertLength];
            } else {
                [content insertString:imageSrc atIndex:content.length];
            }
            insertLength = insertLength + imageSrc.length;
            
            GBLog(@"PublishAnswer ArrayImage \n imagePath: %@,\n location: %ld,\n content.length: %ld,\n insertLength: %ld, \n content: %@", modelImage.imagePath,(long)modelImage.location,(long)content.length,(long)insertLength,content);
        }
        GBLog(@"PublishAnswer Changing Content: %@", content);
    }
    NSString *strContent = [NSString stringWithString:content];
    
    GBLog(@"PublishAnswer Submit Content: %@", strContent);
    
    if (strContent.length == 0) {
        [ZProgressHUD showError:@"回答内容不能为空" toView:self.view];
        return;
    }
    if (strContent.length < 5 || strContent.length > 30000) {
        [ZProgressHUD showError:@"回答内容限制[5-30000]字符" toView:self.view];
        return;
    }
    if (self.arrImage.count > 10) {
        [ZProgressHUD showError:@"内容图片太多拉,最多限制10张" toView:self.view];
        return;
    }
    
    NSString *questionId = self.modelAB.question_id;
    if (questionId && questionId.length > 0) {
        NSString *answerId = self.modelAB.ids;
        if (answerId && answerId.length > 0) {
            ZWEAKSELF
            NSString *userId = [AppSetting getUserDetauleId];
            [ZProgressHUD showMessage:@"正在编辑,请稍等..." toView:self.view];
            [sns postUpdAnswerWithQuestionId:questionId answerId:answerId content:strContent userId:userId answerImg:self.arrImage resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD dismissForView:weakSelf.view];
                    [ZProgressHUD showSuccess:@"成功编辑回答"];
                    
                    [weakSelf postPublishQuestionNotification];
                    
                    [sqlite setSysParam:kSQLITE_LAST_ANSWER_CONTENT value:kEmpty];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD dismissForView:weakSelf.view];
                    [ZProgressHUD showError:msg toView:weakSelf.view];
                });
            }];
        } else {
            ZWEAKSELF
            NSString *userId = [AppSetting getUserDetauleId];
            [ZProgressHUD showMessage:@"正在回答,请稍等..." toView:self.view];
            [sns postAddAnswerWithQuestionId:questionId content:content userId:userId answerImg:self.arrImage resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD dismissForView:weakSelf.view];
                    [ZProgressHUD showSuccess:@"成功回答问题"];
                    
                    [weakSelf postPublishQuestionNotification];
                    
                    [sqlite setSysParam:kSQLITE_LAST_ANSWER_CONTENT value:kEmpty];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD dismissForView:weakSelf.view];
                    [ZProgressHUD showError:msg toView:weakSelf.view];
                });
            }];
        }
    } else {
        [ZProgressHUD showError:@"没有关联上问题,不能提交回答信息" toView:self.view];
    }
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect textFrame = self.textFrame;
    textFrame.size.height -= height;
    [self.textView setFrame:textFrame];
}

-(void)showAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:^{}];
    } else {
        [ZAlertView showWithMessage:@"你的设备不支持相册"];
    }
}

-(void)showCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagepicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        imagepicker.mediaTypes = @[(NSString*)kUTTypeImage];
        imagepicker.delegate = self;
        imagepicker.allowsEditing = NO;
        imagepicker.showsCameraControls = YES;
        [self presentViewController:imagepicker animated:YES completion:^{}];
    } else {
        [ZAlertView showWithMessage:@"你的设备不支持相机"];
    }
}

-(void)setPhotoClick
{
    if (self.arrImage.count > 10) {
        [ZProgressHUD showError:@"内容图片太多拉,最多限制10张" toView:self.view];
        return;
    }
    [self.view endEditing:YES];
    ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@[kCAlbum,kCPhotograph]];
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
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [ZProgressHUD showMessage:@"正在处理,请稍等..." toView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *originalimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (originalimage != nil) {
                CGFloat scale = weakSelf.textView.frame.size.width/originalimage.size.width;
                CGFloat imgW = weakSelf.textView.frame.size.width-10;
                CGFloat imgH = originalimage.size.height * scale;
                
                UIImage *newImage = [Utils resizedTransformtoSize:CGSizeMake(imgW, imgH) image:originalimage];
                
                NSString *fileName = kRandomImageName;
                NSString *createFilePath=[NSString stringWithFormat:@"%@/%@",[AppSetting getTempFilePath],fileName];
                NSData *imagedata = [Utils writeImage:newImage toFileAtPath:createFilePath];
                if (imagedata != nil) {
                    
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
                        ModelImage *modelImage = [[ModelImage alloc] init];
                        [modelImage setImagePath:createFilePath];
                        [modelImage setImageName:fileName];
                        [modelImage setLocation:weakSelf.lastRange.location];
                        [weakSelf.arrImage addObject:modelImage];
                        
                        [weakSelf.textView setAttributedText:strAttributed];
                        
                        [ZProgressHUD dismissForView:weakSelf.view];
                        
                        GBLog(@"PublishAnswer TextView Content: %@   ,  ArrayImage : %@", weakSelf.textView.text, weakSelf.arrImage);
                    });
                } else {
                    GCDMainBlock(^{
                        [ZProgressHUD dismissForView:weakSelf.view];
                    });
                }
            } else {
                GCDMainBlock(^{
                    [ZProgressHUD dismissForView:weakSelf.view];
                });
            }
        } else {
            GCDMainBlock(^{
                [ZProgressHUD dismissForView:weakSelf.view];
            });
        }
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
