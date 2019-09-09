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
    
    [self setTitle:@"问题描述"];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"下一步"];
    
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
    [self.textView setPlaceholderText:@"请输入您问题的具体描述(非必填,可跳过)"];
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
    NSString *content = self.textView.text;
    if (content.length > kNumberQuestionDescMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:@"问题描述长度限制[0-%d]字符",kNumberQuestionDescMaxLength]];
        return;
    }
    [self.modelQuestion setContent:content];
    ZCircleQuestionTagViewController *cqdVC = [[ZCircleQuestionTagViewController alloc] init];
    [cqdVC setPreVC:self.preVC];
    [cqdVC setViewDataWithModel:self.modelQuestion];
    [self.navigationController pushViewController:cqdVC animated:YES];
}

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
