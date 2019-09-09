//
//  ZCircleQuestionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleQuestionViewController.h"
#import "ZTextView.h"
#import "ZQuestionRelationTableView.h"

#import "ZCircleQuestionDescViewController.h"
#import "ZQuestionDetailViewController.h"
#import "ZAnswerDetailViewController.h"

@interface ZCircleQuestionViewController ()

@property (assign, nonatomic) CGRect textFrame;
///输入内容区域
@property (strong, nonatomic) ZTextView *txtView;
///描述个数
@property (strong, nonatomic) UILabel *lbDescCount;
///关联内容坐标
@property (assign, nonatomic) CGRect searchFrame;
///内容高度
@property (assign ,nonatomic) CGFloat contentH;
///键盘高度
@property (assign ,nonatomic) CGFloat keyboardH;
///关联内容
@property (strong, nonatomic) ZQuestionRelationTableView *tvQuestionRelation;

@end

@implementation ZCircleQuestionViewController

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
    
    if (self.modelQuestion.title.length == 0) {
        NSString *lastTitle = [sqlite getSysParamWithKey:kSQLITE_LAST_QUESTION_TITLE];
        [self.modelQuestion setTitle:lastTitle];
        
        if (lastTitle.length > 0) {
            [self getQuestionRelationWithContent:lastTitle];
        }
    }
    [self.txtView setViewText:self.modelQuestion.title];
    
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
    [self.txtView setPlaceholderText:@"请写下您的问题"];
    [self.txtView setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.view addSubview:self.txtView];
    
    self.textFrame = CGRectMake(10, APP_TOP_HEIGHT+10, APP_FRAME_WIDTH-20, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-10);
    [self.txtView setFrame:self.textFrame];
    
    self.tvQuestionRelation = [[ZQuestionRelationTableView alloc] init];
    [self.tvQuestionRelation setHidden:YES];
    [self.tvQuestionRelation setFrame:CGRectMake(0, APP_TOP_HEIGHT+100, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    [self.view addSubview:self.tvQuestionRelation];
    
    [self.view sendSubviewToBack:self.txtView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [self innerEvent];
}

-(void)innerEvent
{
    ZWEAKSELF
    //文本内容改变
    [self.txtView setOnTextDidChange:^(NSString *content, NSRange range, int inputLength) {
        if (content.length > kNumberQuestionMaxLength) {
            [weakSelf setViewTitle:[NSString stringWithFormat:@"超长%d字符",(int)(content.length-kNumberQuestionMaxLength)]];
        } else {
            [weakSelf setViewTitle:weakSelf.title];
        }
        [weakSelf getQuestionRelationWithContent:content];
        
        [sqlite setSysParam:kSQLITE_LAST_QUESTION_TITLE value:content];
    }];
    //撤销内容
    [self.txtView setOnRevokeChange:^(NSRange range, int inputLength) {
        [sqlite setSysParam:kSQLITE_LAST_QUESTION_TITLE value:weakSelf.txtView.text];
    }];
    //高度改变
    [self.txtView setOnContentHeightChange:^(CGFloat contentH) {
        [weakSelf setContentH:contentH];
        [weakSelf setQuestionRelationFrame];
    }];
    //关联选中
    [self.tvQuestionRelation setOnRowSelected:^(ModelCircleSearchContent *model) {
        if (model.type == 0) {
            ModelQuestionBase *modelB = [[ModelQuestionBase alloc] init];
            [modelB setIds:model.ids];
            [modelB setTitle:model.title];
            [weakSelf showQuestionDetailVC:modelB];
        } else {
            ModelAnswerBase *modelB = [[ModelAnswerBase alloc] init];
            [modelB setIds:model.ids];
            [modelB setTitle:model.title];
            [weakSelf showAnswerDetailVC:modelB];
        }
    }];
    //隐藏键盘
    [self.tvQuestionRelation setOnOffsetChange:^(CGFloat y) {
        [weakSelf.view endEditing:YES];
    }];
}
///搜索内容
-(void)getQuestionRelationWithContent:(NSString *)content
{
    [self.tvQuestionRelation setViewKeyword:content];
    if (content.length == 0) {
        [self setEmptyQuestionRelation];
    } else {
        ZWEAKSELF
        [sns getCircleQueryQuestionAnswerWithQuestion:content pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setQuestionRelationWithDic:result];
            });
        } errorBlock:^(NSString *msg) {
            
        }];
    }
}
-(void)setQuestionRelationWithDic:(NSDictionary *)dicResult
{
    [self.tvQuestionRelation setViewDataWithDictionary:dicResult];
}
///设置搜索内容为空
-(void)setEmptyQuestionRelation
{
    [self.tvQuestionRelation setHidden:YES];
    [self.tvQuestionRelation setViewDataWithDictionary:nil];
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
    if ([content isEmpty]) {
        [ZProgressHUD showError:@"问题不能为空,说点什么吧" toView:self.view];
        return;
    }
    if (content.length < kNumberQuestionMinLength || content.length > kNumberQuestionMaxLength) {
        [ZProgressHUD showError:@"问题长度限制[5-50]字符" toView:self.view];
        return;
    }
    if (!self.modelQuestion) {
        self.modelQuestion = [[ModelQuestion alloc] init];
    }
    [self.modelQuestion setTitle:content];
    ZCircleQuestionDescViewController *cqtVC = [[ZCircleQuestionDescViewController alloc] init];
    [cqtVC setPreVC:self];
    [self.navigationController pushViewController:cqtVC animated:YES];
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    CGRect txtFrame = self.textFrame;
    txtFrame.size.height -= height;
    [self.txtView setFrame:txtFrame];
    
    self.keyboardH = height;
    [self setQuestionRelationFrame];
}

-(void)setQuestionRelationFrame
{
    if (self.keyboardH >= kKeyboard_Min_Height) {
        CGFloat qrY = self.textFrame.origin.y+65;
        if (self.contentH > 0) {
            qrY = self.textFrame.origin.y + self.contentH + 45;
        }
        CGFloat qrH = APP_FRAME_HEIGHT - qrY - self.keyboardH;
        self.searchFrame = CGRectMake(0, qrY, self.view.width, qrH);
        [self.tvQuestionRelation setFrame:self.searchFrame];
        [self.tvQuestionRelation setHidden:NO];
    } else {
        [self.tvQuestionRelation setHidden:YES];
    }
}

-(void)setViewDataWithModel:(ModelQuestion *)model
{
    [self setModelQuestion:model];
}

@end
