//
//  ZCurriculumMessageViewController.m
//  PlaneLive
//
//  Created by Daniel on 16/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCurriculumMessageViewController.h"
#import "ZTextView.h"

@interface ZCurriculumMessageViewController ()

@property (strong, nonatomic) ZTextView *txtView;

@property (strong, nonatomic) ModelCurriculum *model;

@property (assign, nonatomic) CGRect textFrame;

@end

@implementation ZCurriculumMessageViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kMessage];
    
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
    OBJC_RELEASE(_model);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.textFrame = VIEW_ITEM_FRAME;
    self.txtView = [[ZTextView alloc] init];
    [self.txtView setViewFrame:self.textFrame];
    [self.txtView setReturnKeyType:(UIReturnKeyDefault)];
    [self.txtView setPlaceholderText:kWhatYouSay];
    [self.txtView setMaxLength:kNumberSubscribeMessageMaxLength];
    [self.txtView setIsInputNewLine:YES];
    [self.view addSubview:self.txtView];
    
    [super innerInit];
}

-(void)btnRightClick
{
    [self.view endEditing:YES];
    NSString *content = self.txtView.text.toTrim;
    if (content.length == 0) {
        [ZProgressHUD showError:kMessageContentCanNotBeEmpty];
        return;
    }
    if (content.length < 1 || content.length > kNumberSubscribeMessageMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kMessageContentLengthLimitCharacter, 1, kNumberSubscribeMessageMaxLength]];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgMessaging];
    [snsV2 postAddMessageContentWithSubscribe:content cId:self.model.ids resultBlock:^(NSString *messageId, NSDictionary *result) {
        [ZProgressHUD dismiss];
        if (weakSelf.preVC) {
            [weakSelf.preVC performSelector:@selector(sendMessageSuccess:) withObject:@{@"messageId":messageId,@"content":content} afterDelay:0];
        }
        [ZProgressHUD showSuccess:kCMsgMessageSuccess];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } errorBlock:^(NSString *msg) {
        [ZProgressHUD dismiss];
        [ZProgressHUD showError:msg];
    }];
}
///留言成功回调
-(void)sendMessageSuccess:(NSDictionary *)dicResult
{
    
}
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect txtFrame = self.textFrame;
    txtFrame.size.height -= height;
    
    [self.txtView setViewFrame:txtFrame];
}

-(void)setViewDataWithModel:(ModelCurriculum *)model
{
    [self setModel:model];
}

@end
