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

@property (assign, nonatomic) CGRect textFrame;

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
    
    [self registerKeyboardNotification];
    
    [self setRightButtonWithText:kSubmit];
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
    OBJC_RELEASE(_ids);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.textFrame = VIEW_ITEM_FRAME;
    self.txtView = [[ZTextView alloc] init];
    [self.txtView setViewFrame:self.textFrame];
    [self.txtView setReturnKeyType:(UIReturnKeyDone)];
    [self.txtView setPlaceholderText:kPleaseYourReportDesc];
    [self.txtView setMaxLength:kReportContentMaxLength];
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

-(void)btnRightClick
{
    [self.view endEditing:YES];
    NSString *content = self.txtView.text.toTrim;
    if (content.length == 0) {
        [ZProgressHUD showError:kReportContentNotEmpty];
        return;
    }
    ///TODO:ZWW备注-举报内容字数限制
    if (content.length < kReportContentMinLength || content.length > kReportContentMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kReportContentLengthLimitCharacter, kReportContentMinLength, kReportContentMaxLength]];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgReporting];
    [snsV1 postAddReportWithUserId:kLoginUserId objId:self.ids type:self.rtype content:content resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:kReportSuccess];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect txtFrame = self.textFrame;
    txtFrame.size.height -= height;
    
    [self.txtView setViewFrame:txtFrame];
}

-(void)setViewDataWithIds:(NSString *)ids type:(ZReportType)type
{
    [self setIds:ids];
    
    [self setRtype:type];
}

@end
