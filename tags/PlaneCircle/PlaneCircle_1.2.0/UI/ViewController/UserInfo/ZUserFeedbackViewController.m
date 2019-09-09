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
    ZWEAKSELF
    self.txtView = [[ZTextView alloc] init];
    [self.txtView setReturnKeyType:(UIReturnKeyDone)];
    [self.txtView setOnTextDidChange:^(NSString *content, NSRange range, int inputLength) {
        if (content.length > kFeedbackContentLength) {
            [weakSelf setViewTitle:[NSString stringWithFormat:@"超长%d字符",(int)(content.length-kFeedbackContentLength)]];
        } else {
            [weakSelf setViewTitle:weakSelf.title];
        }
        if (content.length < kFeedbackContentLength) {
            [sqlite setSysParam:kSQLITE_LAST_DRAFT value:content];
        }
    }];
    [self.txtView setOnRevokeChange:^(NSRange range, int inputLength) {
        NSString *content = weakSelf.txtView.text;
        if (content.length > kFeedbackContentLength) {
            [weakSelf setViewTitle:[NSString stringWithFormat:@"超长%d字符",(int)(content.length-kFeedbackContentLength)]];
        } else {
            [weakSelf setViewTitle:weakSelf.title];
        }
        if (content.length < kFeedbackContentLength) {
            [sqlite setSysParam:kSQLITE_LAST_DRAFT value:content];
        }
    }];
    [self.txtView setPlaceholderText:@"感谢您对梧桐Live提出宝贵的改进意见"];
    [self.view addSubview:self.txtView];
    
    [self setViewFrame];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
}

- (void)setViewFrame
{
    [self.txtView setFrame:VIEW_ITEM_FRAME];
}

-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.txtView resignFirstResponder];
    }
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
