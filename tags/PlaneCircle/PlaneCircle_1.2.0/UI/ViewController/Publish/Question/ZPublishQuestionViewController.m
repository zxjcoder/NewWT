//
//  ZPublishQuestionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 8/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPublishQuestionViewController.h"
#import "ZSelectTopicViewController.h"
#import "ZTextView.h"
#import "ZTopicLabel.h"

@interface ZPublishQuestionViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *viewTitle;

@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) ZTextView *textTitle;

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UILabel *lbContent;
@property (strong, nonatomic) ZTextView *textContent;

@property (assign, nonatomic) CGRect svFrame;
@property (assign, nonatomic) CGFloat svContentH;

@end

@implementation ZPublishQuestionViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"提问"];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"下一步"];
    
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
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_textTitle);
    OBJC_RELEASE(_textContent);
    OBJC_RELEASE(_modelQuestion);
    OBJC_RELEASE(_scrollView);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.viewTitle = [[UIView alloc] init];
    [self.scrollView addSubview:self.viewTitle];
    
    self.viewContent = [[UIView alloc] init];
    [self.scrollView addSubview:self.viewContent];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:@"问题:"];
    [self.lbTitle setTextColor:MAINCOLOR];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setText:@"问题描述:"];
    [self.lbContent setTextColor:MAINCOLOR];
    [self.lbContent setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewContent addSubview:self.lbContent];
    
    self.textTitle = [[ZTextView alloc] init];
    [self.textTitle setText:self.modelQuestion.title];
    [self.textTitle setBackgroundColor:RGBCOLOR(244, 245, 246)];
    [self.textTitle setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.textTitle setFont:kQuestion_TextView_Font];
    [self.textTitle setScrollsToTop:NO];
    [self.viewTitle addSubview:self.textTitle];
    
    self.textContent = [[ZTextView alloc] init];
    [self.textContent setText:self.modelQuestion.content];
    [self.textContent setBackgroundColor:RGBCOLOR(244, 245, 246)];
    [self.textContent setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.textContent setFont:kQuestion_TextView_Font];
    [self.textContent setScrollsToTop:NO];
    [self.viewContent addSubview:self.textContent];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [self setViewContent];
    
    [self setViewFrame];
    
    [self setInnerEvent];
}
-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}
///设置文本坐标
-(void)setViewFrame
{
    [self setViewContent];
    
    self.svFrame = VIEW_ITEM_FRAME;
    [self.scrollView setFrame:self.svFrame];
    CGFloat lbH = 23;
    CGFloat space = 10;
    [self.lbTitle setFrame:CGRectMake(space, space, self.svFrame.size.width, lbH)];
    [self.lbContent setFrame:CGRectMake(space, space, self.svFrame.size.width, lbH)];
    
    [self setViewContentFrame];
}
///设置内容区域坐标
-(void)setViewContentFrame
{
    CGFloat space = 10;
    
    CGFloat contentW = self.svFrame.size.width-space*2;
    CGSize titleSize = [self.textTitle sizeThatFits:CGSizeMake(contentW, FLT_MAX)];
    CGFloat titleH = titleSize.height;
    [self.textTitle setFrame:CGRectMake(space, self.lbTitle.y+self.lbTitle.height+space, contentW, titleH)];
    [self.viewTitle setFrame:CGRectMake(0, 0, self.svFrame.size.width, self.textTitle.y+self.textTitle.height)];
    
    CGSize contentSize = [self.textContent sizeThatFits:CGSizeMake(contentW, FLT_MAX)];
    CGFloat contentH = contentSize.height;
    [self.textContent setFrame:CGRectMake(space, self.lbContent.y+self.lbContent.height+space, contentW, contentH)];
    [self.viewContent setFrame:CGRectMake(0, self.viewTitle.y+self.viewTitle.height, self.svFrame.size.width, self.textContent.y+self.textContent.height)];
}
///设置文本内容
-(void)setViewContent
{
    [self.textTitle setText:self.modelQuestion.title];
    
    [self.textContent setText:self.modelQuestion.content];
}

-(void)setInnerEvent
{
    ZWEAKSELF
    [self.textTitle setOnTextDidChange:^(NSString *content, NSRange range, int inputLength) {
        [weakSelf setViewContentFrame];
    }];
    [self.textContent setOnTextDidChange:^(NSString *content, NSRange range, int inputLength) {
        [weakSelf setViewContentFrame];
    }];
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    CGRect svFrame = self.svFrame;
    svFrame.size.height -= height;
    [self.scrollView setFrame:svFrame];
}

//下一步
-(void)btnRightClick
{
    [self.view endEditing:YES];
    NSString *title = self.textTitle.text;
    if ([title isEmpty]) {
        [ZProgressHUD showError:@"问题不能为空,说点什么吧"];
        return;
    }
    if (title.length < kNumberQuestionMinLength || title.length > kNumberQuestionMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:@"问题长度限制[%d-%d]字符",kNumberQuestionMinLength,kNumberQuestionMaxLength]];
        return;
    }
    if (!self.modelQuestion) {
        self.modelQuestion = [[ModelQuestion alloc] init];
    }
    [self.modelQuestion setTitle:title];
    
    NSString *content = self.textContent.text;
    if (content.length > kNumberQuestionDescMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:@"问题描述长度限制[0-%d]字符",kNumberQuestionDescMaxLength]];
        return;
    }
    [self.modelQuestion setContent:content];
    ZSelectTopicViewController *itemVC = [[ZSelectTopicViewController alloc] init];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)setViewDataWithModel:(ModelQuestion *)model
{
    [self setModelQuestion:model];
}

@end
