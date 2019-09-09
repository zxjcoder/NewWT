//
//  ZReportViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZReportViewController.h"
#import "ZTextView.h"

@interface ZReportViewController ()

@property (strong, nonatomic) ZTextView *txtView;

@property (strong, nonatomic) NSString *ids;

@property (strong, nonatomic) NSString *oldTitle;

@property (assign, nonatomic) ZReportType rtype;

@end

@implementation ZReportViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setOldTitle:self.title];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"提交"];
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
    OBJC_RELEASE(_ids);
    [super setViewNil];
}

#pragma mark - PrivateMethod

#define kReportContentLength 140

-(void)innerInit
{
    self.txtView = [[ZTextView alloc] init];
    [self.txtView setReturnKeyType:(UIReturnKeyDone)];
    [self.txtView setPlaceholderText:@"请对您的举报进行详细的描述"];
    [self.view addSubview:self.txtView];
    
    ZWEAKSELF
    [self.txtView setOnTextDidChange:^(NSString *content, NSRange range, int inputLength) {
        if (content.length > kReportContentLength) {
            [weakSelf setViewTitle:[NSString stringWithFormat:@"超长%d字符",(int)(content.length-kReportContentLength)]];
        } else {
            [weakSelf setViewTitle:weakSelf.title];
        }
    }];
    [self.txtView setOnRevokeChange:^(NSRange range, int inputLength) {
        NSString *content = weakSelf.txtView.text;
        if (content.length > kReportContentLength) {
            [weakSelf setViewTitle:[NSString stringWithFormat:@"超长%d字符",(int)(content.length-kReportContentLength)]];
        } else {
            [weakSelf setViewTitle:weakSelf.title];
        }
    }];
    
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
    NSString *content = self.txtView.text;
    if (content.length == 0) {
        [ZProgressHUD showError:@"举报内容不能为空"];
        return;
    }
    ///TODO:ZWW备注-举报内容字数限制
    if (content.length < 5 || content.length > kReportContentLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:@"举报内容限制[5-%d]字符", kReportContentLength]];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在举报,请稍等..."];
    [sns postAddReportWithUserId:[AppSetting getUserDetauleId] objId:self.ids type:self.rtype content:content resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:@"举报成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

-(void)setViewDataWithIds:(NSString *)ids type:(ZReportType)type
{
    [self setIds:ids];
    
    [self setRtype:type];
}

@end
