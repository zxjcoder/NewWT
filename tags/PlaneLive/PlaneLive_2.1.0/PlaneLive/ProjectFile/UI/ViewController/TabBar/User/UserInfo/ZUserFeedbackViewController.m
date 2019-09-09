//
//  ZUserFeedbackViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserFeedbackViewController.h"
#import "ZTextView.h"

#define kFeedbackContentLength 140

@interface ZUserFeedbackViewController ()

@property (strong, nonatomic) ZTextView *txtView;

@property (assign, nonatomic) CGRect textFrame;

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
    
    [self.txtView setViewText:[sqlite getSysParamWithKey:kSQLITE_LAST_DRAFT]];
    
    [self registerKeyboardNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.txtView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.txtView resignFirstResponder];
    
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
    OBJC_RELEASE(_txtView);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.view setBackgroundColor:WHITECOLOR];
    
    self.textFrame = VIEW_ITEM_FRAME;
    self.txtView = [[ZTextView alloc] initWithFrame:self.textFrame];
    [self.txtView setReturnKeyType:(UIReturnKeyDone)];
    [self.txtView setMaxLength:kFeedbackContentLength];
    [self.txtView setDescColorCount:4];
    [self.txtView setOnTextDidChange:^(NSString *text, NSRange range) {
        if (text.length <= kFeedbackContentLength) {
            [sqlite setSysParam:kSQLITE_LAST_DRAFT value:text];
        }
    }];
    [self.txtView setOnRevokeChange:^(NSString *text, NSRange range) {
        if (text.length <= kFeedbackContentLength) {
            [sqlite setSysParam:kSQLITE_LAST_DRAFT value:text];
        }
    }];
    [self.txtView setPlaceholderText:kThankYouForYourValuableSuggestionsOnTheImprovementOfLive];
    [self.view addSubview:self.txtView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [super innerInit];
}

-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.txtView resignFirstResponder];
    }
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect txtFrame = self.textFrame;
    txtFrame.size.height -= height;
    
    [self.txtView setViewFrame:txtFrame];
}

-(void)btnRightClick
{
    [self.view endEditing:YES];
    if (self.isLoaded) {return;}
    [self setIsLoaded:YES];
    NSString *content = self.txtView.text.toTrim;
    if ([content isEmpty]) {
        [ZProgressHUD showError:kFeedbackContentCanNotBeEmpty];
        [self setIsLoaded:NO];
        return;
    }
    if (content.length < 5 || content.length > kFeedbackContentLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kFeedbackContentLengthLimitCharacter, kFeedbackContentLength]];
        [self setIsLoaded:NO];
        return;
    }
    NSString *lastContent = [sqlite getSysParamWithKey:kSQLITE_LAST_FEEDBACK];
    if ([content isEqualToString:lastContent]) {
        [ZProgressHUD showError:kPleaseDoNotRepeatTheSameContent];
        [self setIsLoaded:NO];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgSubmiting];
    [snsV1 postFeekbackWithUserId:[AppSetting getUserDetauleId] question:content type:@"0" objId:nil resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismiss];
            [weakSelf.txtView setViewText:kEmpty];
            [sqlite setSysParam:kSQLITE_LAST_FEEDBACK value:content];
            [sqlite setSysParam:kSQLITE_LAST_DRAFT value:kEmpty];
            [ZAlertView showWithMessage:kThankYouForYourValuableAdviceAndWeWillDealWithItInATimelyManner completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

@end
