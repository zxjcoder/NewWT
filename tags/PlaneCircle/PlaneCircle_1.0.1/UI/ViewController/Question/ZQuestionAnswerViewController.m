//
//  ZQuestionAnswerViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionAnswerViewController.h"
#import "ZTextView.h"
#import "ZQuestionToolbar.h"
#import "ZTextAttachment.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ZQuestionAnswerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZActionSheetDelegate>

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) ZQuestionToolbar *toolBar;

@property (assign, nonatomic) CGRect textFrame;

@property (strong, nonatomic) NSMutableArray *arrImage;

@property (assign, nonatomic) NSRange lastRange;

@property (strong, nonatomic) NSString *lastContent;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@end

@implementation ZQuestionAnswerViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"添加回答"];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"提交"];
    
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
    
    self.textView = [[ZTextView alloc] init];
    [self.textView setPlaceholderText:@"|请写下您宝贵的回答"];
    [self.textView setInputAccessoryView:self.toolBar];
    [self.textView setIsInputNewLine:YES];
    [self.textView setReturnKeyType:UIReturnKeyDefault];
    [self.textView setFont:kTextView_FontWithName];
    [self.textView setTextColor:BLACKCOLOR1];
    [self.view addSubview:self.textView];
    
    self.textFrame = CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT);
    [self.textView setFrame:self.textFrame];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [self innerEvent];
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
    [self.textView setOnTextEditing:^(NSString *content, NSRange range) {
        if (weakSelf.arrImage.count > 0) {
            [weakSelf.arrImage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"NSDictionary : %@,   content:  %@  ,  range : %d",obj, content,  (int)range.location);
            }];
//            int delRowIndex = 0;
//            BOOL isFound = NO;
//            for (NSDictionary *dic in weakSelf.arrImage) {
//                if (range.location == [[dic objectForKey:@"location"] integerValue]) {
//                    isFound = YES;
//                    break;
//                }
//                delRowIndex++;
//            }
//            if (isFound) {[weakSelf.arrImage removeObjectAtIndex:delRowIndex];}
        }
    }];
    [self.textView setOnRevokeChange:^(NSRange range) {
        [weakSelf.arrImage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"NSDictionary : %@,   range : %d",obj, (int)range.location);
        }];
//        NSMutableArray *arrNewImage = [NSMutableArray array];
//        for (NSDictionary *dic in weakSelf.arrImage) {
//            NSDictionary *dicNew = [NSDictionary dictionaryWithDictionary:dic];
//            if (range.location < [[dicNew objectForKey:@"location"] integerValue]) {
//                NSString *location = [dic objectForKey:@"location"];
//                [dicNew setValue:[NSString stringWithFormat:@"%ld",(long)([location integerValue]-1)] forKey:@"location"];
//            }
//            [arrNewImage addObject:dicNew];
//        }
//        [weakSelf.arrImage removeAllObjects];
//        [weakSelf.arrImage addObjectsFromArray:arrNewImage];
    }];
}

-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.textView resignFirstResponder];
    }
}
///用于上级获取新问题
-(void)setNewAnswerWithAnswerId:(NSString *)answerId
{
    
}
///提交
-(void)btnRightClick
{
    [self.view endEditing:YES];
    NSMutableString *content = [NSMutableString stringWithString:self.textView.text];
    ///添加了多少字节
    NSInteger insertLength = 0;
    for (NSDictionary *dicImage in self.arrImage) {
        NSString *imageName = [dicImage objectForKey:@"imageName"];
        NSInteger location = [[dicImage objectForKey:@"location"] integerValue];
        NSString *imageSrc = [NSString stringWithFormat:@" <img src='%@' /> ",imageName];
        [content insertString:imageSrc atIndex:location+insertLength];
        insertLength = insertLength + imageSrc.length;
    }
    if (content.length == 0) {
        [ZProgressHUD showError:@"回答内容不能为空" toView:self.view];
        return;
    }
    if (content.length < 5 || content.length > 30000) {
        [ZProgressHUD showError:@"回答内容限制[5-30000]字符" toView:self.view];
        return;
    }
    if (self.arrImage.count > 10) {
        [ZProgressHUD showError:@"内容图片太多拉,最多限制10张" toView:self.view];
        return;
    }
    NSString *questionId = self.modelAB.question_id;
    if (questionId && [questionId integerValue] > 0) {
        ZWEAKSELF
        NSString *userId = [AppSetting getUserDetauleId];
        [ZProgressHUD showMessage:@"正在回答,请稍等..." toView:self.view];
        [sns postAddAnswerWithQuestionId:questionId content:content userId:userId answerImg:self.arrImage resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [ZProgressHUD dismissForView:weakSelf.view];
                [ZProgressHUD showSuccess:@"成功回答问题"];
                [weakSelf postPublishQuestionNotification];
                if (weakSelf.preVC) {
                    [weakSelf.preVC performSelector:@selector(setNewAnswerWithAnswerId:) withObject:[result objectForKey:kResultKey]];
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [ZProgressHUD dismissForView:weakSelf.view];
                [ZProgressHUD showError:msg toView:weakSelf.view];
            });
        }];
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
    NSLog(@"selectedRange->location: %d", (int)self.textView.selectedRange.location);
    [self setLastRange:self.textView.selectedRange];
    
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
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *originalimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (originalimage != nil) {
                NSString *fileName = kRandomImageName;
                NSString *createFilePath=[NSString stringWithFormat:@"%@/%@",[AppSetting getTempFilePath],fileName];
                NSData *imagedata = [Utils writeImage:originalimage toFileAtPath:createFilePath];
                if (imagedata != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *dicImage = [NSMutableDictionary dictionary];
                        [dicImage setObject:createFilePath forKey:@"imagePath"];
                        [dicImage setObject:fileName forKey:@"imageName"];
                        [dicImage setObject:[NSNumber numberWithInteger:self.lastRange.location+1] forKey:@"location"];
                        [self.arrImage addObject:dicImage];
                        
                        ZTextAttachment *attachment = [[ZTextAttachment alloc]initWithData:nil ofType:nil];
                        UIImage *image = [UIImage imageWithData:imagedata];
                        attachment.image = image;
                        
                        NSAttributedString *attText = [NSAttributedString attributedStringWithAttachment:attachment];
                        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
                        [strAttributed appendAttributedString:attText];
                        
                        [strAttributed addAttribute:NSFontAttributeName value:kTextView_FontWithName range:NSMakeRange(0, strAttributed.length)];
                        [strAttributed addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR1 range:NSMakeRange(0, strAttributed.length)];
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.lineSpacing = 5;
                        [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
                        
                        [self.textView setAttributedText:strAttributed];
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

@end
