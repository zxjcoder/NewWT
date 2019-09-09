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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"意见反馈"];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"提交"];
    
    [self.txtView setText:[sqlite getSysParamWithKey:kSQLITE_LAST_DRAFT]];
    
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
    
    [self removeKeyboardNotification];
    
    [self.txtView resignFirstResponder];
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
    [self.txtView setPlaceholderText:@"感谢您对梧桐Live提出宝贵的改进意见"];
    [self.view addSubview:self.txtView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
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
    NSString *content = self.txtView.text;
    if ([content isEmpty]) {
        [ZProgressHUD showError:@"反馈内容不能为空"];
        [self setIsLoaded:NO];
        return;
    }
    if (content.length < 5 || content.length > kFeedbackContentLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:@"反馈内容限制在5-%d字符", kFeedbackContentLength]];
        [self setIsLoaded:NO];
        return;
    }
    NSString *lastContent = [sqlite getSysParamWithKey:kSQLITE_LAST_FEEDBACK];
    if ([content isEqualToString:lastContent]) {
        [ZProgressHUD showError:@"请不要重复提交相同的内容,谢谢!"];
        [self setIsLoaded:NO];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在提交,请稍等..."];
    [sns postFeekbackWithUserId:[AppSetting getUserDetauleId] question:content type:@"0" objId:nil resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismiss];
            [weakSelf.txtView setViewText:nil];
            [sqlite setSysParam:kSQLITE_LAST_FEEDBACK value:content];
            [sqlite setSysParam:kSQLITE_LAST_DRAFT value:kEmpty];
            [ZAlertView showWithMessage:@"感谢您宝贵的意见,我们会根据您的反馈及时处理" completion:^{
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
