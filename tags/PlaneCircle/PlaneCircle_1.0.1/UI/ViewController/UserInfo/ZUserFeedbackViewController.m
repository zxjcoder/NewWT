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

- (void)setViewFrame
{
    [self.txtView setFrame:VIEW_ITEM_FRAME];
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
    self.txtView = [[ZTextView alloc] init];
    [self.txtView setReturnKeyType:(UIReturnKeyDone)];
    [self.txtView setOnTextDidChange:^(NSString *text,NSRange range, int inputLength) {
        if (text.length < kFeedbackContentLength) {
            [sqlite setSysParam:kSQLITE_LAST_DRAFT value:text];
        }
    }];
    [self.txtView setPlaceholderText:@"感谢您对梧桐树下提出宝贵的改进意见"];
    [self.view addSubview:self.txtView];
    
    [self setViewFrame];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.txtView resignFirstResponder];
    }
}

-(void)btnRightClick
{
    if (self.isLoaded) {return;}
    [self.view endEditing:YES];
    NSString *content = self.txtView.text;
    if ([content isEmpty]) {
        [ZProgressHUD showError:@"反馈内容不能为空" toView:self.view];
        return;
    }
    if (content.length < 5 || content.length > kFeedbackContentLength) {
        [ZProgressHUD showError:@"反馈内容限制在5-140字符" toView:self.view];
        return;
    }
    NSString *lastContent = [sqlite getSysParamWithKey:kSQLITE_LAST_FEEDBACK];
    if ([content isEqualToString:lastContent]) {
        [ZProgressHUD showError:@"请不要重复提交相同的内容,谢谢!" toView:self.view];
        return;
    }
    ZWEAKSELF
    [self setIsLoaded:YES];
    [ZProgressHUD showMessage:@"正在提交,请稍等..." toView:self.view];
    [sns postFeekbackWithUserId:[AppSetting getUserDetauleId] question:content type:@"0" objId:nil resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismissForView:weakSelf.view];
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
            [ZProgressHUD dismissForView:weakSelf.view];
            [ZProgressHUD showError:msg toView:weakSelf.view];
        });
    }];
}

@end
