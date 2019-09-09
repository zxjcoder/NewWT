//
//  ZCircleQuestionDescViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleQuestionDescViewController.h"
#import "ZTextView.h"

#import "ZCircleQuestionTagViewController.h"
#import "ZCircleQuestionViewController.h"

@interface ZCircleQuestionDescViewController ()

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) NSArray *searchTag;
@property (strong, nonatomic) NSString *questionContent;

@property (assign, nonatomic) CGRect textFrame;

///数据源
@property (strong, nonatomic) ModelQuestion *modelQuestion;

@end

@implementation ZCircleQuestionDescViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kQuestionDesc];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.modelQuestion.bePracticeId.length > 0) {
        [self setRightButtonWithText:kRelease];
    } else {
        [self setRightButtonWithText:kNext];
    }
    
    [self.textView setViewText:self.modelQuestion.content];
    
    [self registerKeyboardNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [self.view endEditing:YES];
    
    if (self.preVC) {
        [(ZCircleQuestionViewController*)self.preVC setViewDataWithModel:self.modelQuestion];
    }
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
    OBJC_RELEASE(_textView);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.textFrame = VIEW_ITEM_FRAME;
    self.textView = [[ZTextView alloc] init];
    [self.textView setViewFrame:self.textFrame];
    [self.textView setReturnKeyType:(UIReturnKeyDone)];
    [self.textView setPlaceholderText:kPleaseEnterTheQuestionDesc];
    [self.textView setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.textView setMaxLength:kNumberQuestionDescMaxLength];
    [self.textView setDescColorCount:5];
    [self.view addSubview:self.textView];
    
    [self.textView setOnTextDidChange:^(NSString *text, NSRange range) {
        if (text.length <= kNumberQuestionDescMaxLength) {
            [sqlite setSysParam:kSQLITE_LAST_QUESTION_CONTENT value:text];
        }
    }];
    //撤销内容
    [self.textView setOnRevokeChange:^(NSString *text, NSRange range) {
        if (text.length <= kNumberQuestionDescMaxLength) {
            [sqlite setSysParam:kSQLITE_LAST_QUESTION_CONTENT value:text];
        }
    }];
}

-(void)btnRightClick
{
    [self.view endEditing:YES];
    NSString *content = self.textView.text.toTrim;
    if (content.length > kNumberQuestionDescMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kkQuestionDescLengthLimitCharacter, kNumberQuestionDescMaxLength]];
        return;
    }
    [self.modelQuestion setContent:content];
    NSString *bePracticeId = self.modelQuestion.bePracticeId;
    if (bePracticeId.length > 0) {
        ZWEAKSELF
        NSString *title = self.modelQuestion.title.toTrim;
        [ZProgressHUD showMessage:kCMsgReleaseing];
        [DataOper130 postCirclePublishQuestionWithUserId:[AppSetting getUserDetauleId] question:title quizDetail:content articles:nil speechId:bePracticeId resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                [ZProgressHUD showSuccess:kCMsgQuestionAddSuccess];
                
                [sqlite setSysParam:kSQLITE_LAST_QUESTION_TITLE value:kEmpty];
                
                NSString *pqIds = [result objectForKey:kResultKey];
                [weakSelf.modelQuestion setIds:pqIds];
                [weakSelf postPublishQuestionNotificationWithModel:weakSelf.modelQuestion];
                id preVC = [(ZCircleQuestionViewController*)weakSelf.preVC preVC];
                if (pqIds && preVC) {
                    ModelPracticeQuestion *modelPQ = [[ModelPracticeQuestion alloc] init];
                    [modelPQ setIds:pqIds];
                    [modelPQ setTitle:title];
                    [modelPQ setPid:bePracticeId];
                    
                    ModelUserBase *modelUB = [AppSetting getUserLogin];
                    
                    [modelPQ setUserId:modelUB.userId];
                    [modelPQ setNickname:modelUB.nickname];
                    [modelPQ setSign:modelUB.sign];
                    [modelPQ setHead_img:modelUB.head_img];
                    
                    [preVC performSelectorOnMainThread:@selector(setPublishPracticeQuestion:) withObject:modelPQ waitUntilDone:NO];
                    [weakSelf.navigationController popToViewController:preVC animated:YES];
                } else {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:msg];
            });
        }];
    } else {
        ZCircleQuestionTagViewController *cqdVC = [[ZCircleQuestionTagViewController alloc] init];
        [cqdVC setPreVC:self.preVC];
        [cqdVC setViewDataWithModel:self.modelQuestion];
        [self.navigationController pushViewController:cqdVC animated:YES];
    }
}
///添加问题成功
-(void)setPublishPracticeQuestion:(ModelQuestion *)model
{
    
}
///键盘高度改变事件
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect textFrame = self.textFrame;
    textFrame.size.height -= height;
    
    [self.textView setViewFrame:textFrame];
}

-(void)setViewDataWithModel:(ModelQuestion *)model
{
    [self setModelQuestion:model];
}

@end
