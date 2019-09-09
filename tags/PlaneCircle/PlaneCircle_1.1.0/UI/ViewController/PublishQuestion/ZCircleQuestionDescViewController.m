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

@interface ZCircleQuestionDescViewController ()

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) NSArray *searchTag;
@property (strong, nonatomic) NSString *questionContent;

@property (assign, nonatomic) CGRect textFrame;

@end

@implementation ZCircleQuestionDescViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"问题描述"];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"下一步"];
    
    if (self.preVC.modelQuestion.content.length == 0) {
        NSString *content = [sqlite getSysParamWithKey:kSQLITE_LAST_QUESTION_CONTENT];
        [self.preVC.modelQuestion setContent:content];
    }
    [self.textView setViewText:self.preVC.modelQuestion.content];
    
    if (self.textView.text.length > kNumberQuestionDescMaxLength) {
        [self setViewTitle:[NSString stringWithFormat:@"超长%d字符",(int)(self.textView.text.length-kNumberQuestionDescMaxLength)]];
    } else {
        [self setViewTitle:self.title];
    }
    
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
    self.textView = [[ZTextView alloc] init];
    [self.textView setReturnKeyType:(UIReturnKeyDone)];
    [self.textView setPlaceholderText:@"请写下您问题的具体描述"];
    [self.textView setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.view addSubview:self.textView];
    
    self.textFrame = VIEW_ITEM_FRAME;
    [self.textView setFrame:self.textFrame];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    ZWEAKSELF
    [self.textView setOnTextDidChange:^(NSString *content, NSRange range, int inputLength) {
        if (content.length > kNumberQuestionDescMaxLength) {
            [weakSelf setViewTitle:[NSString stringWithFormat:@"超长%d字符",(int)(content.length-kNumberQuestionDescMaxLength)]];
        } else {
            [weakSelf setViewTitle:weakSelf.title];
        }
        [sqlite setSysParam:kSQLITE_LAST_QUESTION_CONTENT value:weakSelf.textView.text];
    }];
    
    //撤销内容
    [self.textView setOnRevokeChange:^(NSRange range, int inputLength) {
        [sqlite setSysParam:kSQLITE_LAST_QUESTION_CONTENT value:weakSelf.textView.text];
    }];
}

-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.textView resignFirstResponder];
    }
}

-(void)btnRightClick
{
    [self.view endEditing:YES];
    NSString *content = self.textView.text;
    if (content.length > kNumberQuestionDescMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:@"问题描述长度限制[0-%d]字符",kNumberQuestionDescMaxLength]];
        return;
    }
    [self.preVC.modelQuestion setContent:content];
    ZCircleQuestionTagViewController *cqdVC = [[ZCircleQuestionTagViewController alloc] init];
    [cqdVC setPreVC:self.preVC];
    [self.navigationController pushViewController:cqdVC animated:YES];
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect textFrame = self.textFrame;
    textFrame.size.height -= height;
    NSLogFrame(textFrame);
    [self.textView setFrame:textFrame];
}

@end
