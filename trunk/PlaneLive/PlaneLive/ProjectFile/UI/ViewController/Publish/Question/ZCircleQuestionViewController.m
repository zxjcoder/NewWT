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
#import "ZTopicListViewController.h"
#import "ZQuestionPromptView.h"

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
///关联实务ID
@property (strong, nonatomic) NSString *bePracticeId;
///发布的问题
@property (strong, nonatomic) ModelQuestion *modelQuestion;

@end

@implementation ZCircleQuestionViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kPutQuestion];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:kNext];
    
    if (self.modelQuestion.title.length == 0) {
        NSString *title = [sqlite getSysParamWithKey:kSQLITE_LAST_QUESTION_TITLE];;
        [self.modelQuestion setTitle:title];
    }
    [self.txtView setViewText:self.modelQuestion.title];
    
    [self registerKeyboardNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *isPublishPrompt = [sqlite getSysParamWithKey:kSQLITE_LAST_QUESTION_PUBLISH_PROMPT];
    if (isPublishPrompt == nil || isPublishPrompt.length == 0) {
        ZQuestionPromptView *viewQuestionPrompt = [[ZQuestionPromptView alloc] init];
        [viewQuestionPrompt setOnButtonClick:^{
            [sqlite setSysParam:kSQLITE_LAST_QUESTION_PUBLISH_PROMPT value:@"YES"];
        }];
        [viewQuestionPrompt show];
    } else {
        [self.txtView becomeFirstResponder];
    }
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
    OBJC_RELEASE(_modelQuestion);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.modelQuestion = [[ModelQuestion alloc] init];
    
    self.textFrame = VIEW_ITEM_FRAME;
    self.txtView = [[ZTextView alloc] init];
    [self.txtView setViewFrame:self.textFrame];
    [self.txtView setReturnKeyType:(UIReturnKeyDone)];
    [self.txtView setPlaceholderText:kPleaseEnterTheQuestionTitle];
    [self.txtView setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.txtView setMaxLength:kNumberQuestionMaxLength];
    [self.txtView setDescColorCount:4];
    [self.view addSubview:self.txtView];
    
    self.tvQuestionRelation = [[ZQuestionRelationTableView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT+40, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    [self.tvQuestionRelation setHidden:YES];
    [self.view addSubview:self.tvQuestionRelation];
    
    [self.view sendSubviewToBack:self.txtView];
    
    [super innerInit];
    
    [self innerEvent];
}

-(void)innerEvent
{
    ZWEAKSELF
    //文本内容改变
    [self.txtView setOnTextDidChange:^(NSString *text, NSRange range) {
        [weakSelf.modelQuestion setTitle:text];
        if (text.length < kSearchContentMaxLength) {
            [weakSelf getQuestionRelationWithContent:text];
        }
        if (text.length <= kNumberQuestionMaxLength) {
            [sqlite setSysParam:kSQLITE_LAST_QUESTION_TITLE value:text];
        }
    }];
    //撤销内容
    [self.txtView setOnRevokeChange:^(NSString *text, NSRange range) {
        [weakSelf.modelQuestion setTitle:text];
        if (text.length < kSearchContentMaxLength) {
            [weakSelf getQuestionRelationWithContent:text];
        }
        if (text.length <= kNumberQuestionMaxLength) {
            [sqlite setSysParam:kSQLITE_LAST_QUESTION_TITLE value:text];
        }
    }];
    //高度改变
    [self.txtView setOnContentHeightChange:^(CGFloat contentH) {
        [weakSelf setContentH:contentH];
        [weakSelf setQuestionRelationFrame];
    }];
    //关联选中
    [self.tvQuestionRelation setOnRowSelected:^(ModelQuestionBase *model) {
        [weakSelf showQuestionDetailVC:model];
    }];
    ///话题选中
    [self.tvQuestionRelation setOnTagSelected:^(ModelTag *model) {
        [weakSelf showTagDetailVC:model];
    }];
}
///显示话题界面
-(void)showTagDetailVC:(ModelTag *)model
{
    [self.view endEditing:YES];
    ZTopicListViewController *tdVC = [[ZTopicListViewController alloc] init];
    [tdVC setViewDataWithModel:model];
    [tdVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:tdVC animated:YES];
}
///搜索内容
-(void)getQuestionRelationWithContent:(NSString *)content
{
    [self.tvQuestionRelation setViewKeyword:content];
    if (content.length == 0) {
        [self setEmptyQuestionRelation];
    } else {
        ZWEAKSELF
        [snsV1 getCircleQueryQuestionAnswerWithQuestion:content pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setQuestionRelationWithDic:result];
            });
        } errorBlock:nil];
    }
}
///设置关联查询出来的数据源
-(void)setQuestionRelationWithDic:(NSDictionary *)dicResult
{
    [self.tvQuestionRelation setViewDataWithDictionary:dicResult];
}
///设置搜索内容为空
-(void)setEmptyQuestionRelation
{
    [self.tvQuestionRelation setViewDataWithDictionary:nil];
}
///右键点击事件
-(void)btnRightClick
{
    [self.view endEditing:YES];
    NSString *content = self.txtView.text.toTrim;
    if ([content isEmpty]) {
        [ZProgressHUD showError:kQuestionNotEmpty];
        return;
    }
    if (content.length < kNumberQuestionMinLength || content.length > kNumberQuestionMaxLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:kQuestionTitleLengthLimitCharacter, kNumberQuestionMinLength,kNumberQuestionMaxLength]];
        return;
    }
    [self.modelQuestion setTitle:content];
    [self.modelQuestion setBePracticeId:self.bePracticeId];
    
    ZCircleQuestionDescViewController *cqtVC = [[ZCircleQuestionDescViewController alloc] init];
    [cqtVC setPreVC:self.preVC];
    [cqtVC setViewDataWithModel:self.modelQuestion];
    [self.navigationController pushViewController:cqtVC animated:YES];
}
///键盘改变监听
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    CGRect txtFrame = self.textFrame;
    txtFrame.size.height -= height;
    
    self.keyboardH = height;
    [self.txtView setViewFrame:txtFrame];
    
    [self setQuestionRelationFrame];
}
///改变关联数据结构
-(void)setQuestionRelationFrame
{
    CGFloat qrY = self.textFrame.origin.y + 40;
    if (self.contentH > 0) {
        qrY = self.textFrame.origin.y + self.contentH + 15;
    }
    CGFloat numberPromptHeight = 25;
    CGFloat qrH = APP_FRAME_HEIGHT - qrY - self.keyboardH - numberPromptHeight;
    self.searchFrame = CGRectMake(0, qrY, self.view.width, qrH);
    [self.tvQuestionRelation setFrame:self.searchFrame];
}
///设置默认数据对象
-(void)setViewDataWithModel:(ModelQuestion *)model
{
    [self setModelQuestion:model];
}
///设置关联实务ID
-(void)setPracticeId:(NSString *)practiceId
{
    [self setBePracticeId:practiceId];
}

@end
