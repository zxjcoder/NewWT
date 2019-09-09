//
//  ZRankEditViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankEditViewController.h"
#import "ZTextView.h"

@interface ZRankEditViewController ()

@property (strong, nonatomic) ZTextView *txtView;

@property (assign, nonatomic) CGRect textFrame;

@property (strong, nonatomic) ModelEntity *modelE;

@end

@implementation ZRankEditViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kCorrection];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:kSubmit];
    
    [self.txtView setViewText:[sqlite getSysParamWithKey:kSQLITE_LAST_UPDRANK]];
    
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
    
    [self.view endEditing:YES];
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
    [self.txtView setMaxLength:kNumberRankEditContentLength];
    [self.txtView setDescColorCount:4];
    
    [self.txtView setOnTextDidChange:^(NSString *text, NSRange range) {
        if (text.length <= kNumberRankEditContentLength) {
            [sqlite setSysParam:kSQLITE_LAST_UPDRANK value:text];
        }
    }];
    [self.txtView setOnRevokeChange:^(NSString *text, NSRange range) {
        if (text.length <= kNumberRankEditContentLength) {
            [sqlite setSysParam:kSQLITE_LAST_UPDRANK value:text];
        }
    }];
    [self.txtView setPlaceholderText:kPleaseDescribeWhatYouWantToFixInDetailAsMuchAsPossible];
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
    if (self.isLoaded) {return;}
    [self.view endEditing:YES];
    NSString *content = self.txtView.text;
    if ([content isEmpty]) {
        [ZProgressHUD showError:kCorrectedContentCannotBeEmpty];
        return;
    }
    if (content.length == 0 || content.length > kNumberRankEditContentLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kFixedContentLengthLimitCharacter, kNumberRankEditContentLength]];
        return;
    }
    NSString *lastContent = [sqlite getSysParamWithKey:kSQLITE_LAST_UPDRANKCONTENT];
    if ([content isEqualToString:lastContent]) {
        [ZProgressHUD showError:kPleaseDoNotRepeatTheSameContent];
        return;
    }
    ZWEAKSELF
    [self setIsLoaded:YES];
    [ZProgressHUD showMessage:kCMsgSubmiting];
    NSString *type = @"1";
    NSString *objId = kEmpty;
    if ([self.modelE isKindOfClass:[ModelRankUser class]]) {
        type = @"1";
        objId = [(ModelRankUser*)self.modelE ids];
    } else if ([self.modelE isKindOfClass:[ModelRankCompany class]]) {
        type = @"2";
        objId = [(ModelRankCompany*)self.modelE ids];
    }
    [sns postFeekbackWithUserId:[AppSetting getUserDetauleId] question:content type:type objId:objId resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismiss];
            [weakSelf.txtView setViewText:nil];
            [sqlite setSysParam:kSQLITE_LAST_UPDRANKCONTENT value:content];
            [sqlite setSysParam:kSQLITE_LAST_UPDRANK value:kEmpty];
            [ZAlertView showWithMessage:kFixedContentHasBeenSuccessfullySubmitted completion:^{
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

-(void)setViewDataWithModel:(ModelEntity *)model
{
    [self setModelE:model];
}

@end
