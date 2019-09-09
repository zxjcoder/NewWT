//
//  ZQuestionEditViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionEditViewController.h"
#import "ZTextView.h"
#import "ZTopicLabel.h"
#import "ZQuestionEditTagViewController.h"

#define kQuestion_TextView_Font [UIFont fontWithName:@"HelveticaNeue" size:kFont_Middle_Size]

@interface ZQuestionEditViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *viewTitle;

@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) ZTextView *textTitle;

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UILabel *lbContent;
@property (strong, nonatomic) ZTextView *textContent;

@property (strong, nonatomic) UIView *viewTopic;
@property (strong, nonatomic) UIView *viewTopicContent;

@property (strong, nonatomic) UILabel *lbTopic;
@property (strong, nonatomic) UIButton *btnAdd;

@property (assign, nonatomic) CGRect svFrame;
@property (assign, nonatomic) CGFloat svContentH;
@property (assign, nonatomic) CGFloat svTopicItemH;
///选中话题集合
@property (strong, nonatomic) NSMutableArray *arrSelTag;

@property (strong, nonatomic) ModelQuestionDetail *modelQD;

@end

@implementation ZQuestionEditViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"编辑问题"];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"完成"];
    
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
    OBJC_RELEASE(_lbTopic);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_textTitle);
    OBJC_RELEASE(_textContent);
    OBJC_RELEASE(_btnAdd);
    OBJC_RELEASE(_arrSelTag);
    OBJC_RELEASE(_modelQD);
    OBJC_RELEASE(_scrollView);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrSelTag = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.viewTitle = [[UIView alloc] init];
    [self.scrollView addSubview:self.viewTitle];
    
    self.viewContent = [[UIView alloc] init];
    [self.scrollView addSubview:self.viewContent];
    
    self.viewTopic = [[UIView alloc] init];
    [self.scrollView addSubview:self.viewTopic];
    
    self.viewTopicContent = [[UIView alloc] init];
    [self.viewTopic addSubview:self.viewTopicContent];
    
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
    
    self.lbTopic = [[UILabel alloc] init];
    [self.lbTopic setText:@"话题:"];
    [self.lbTopic setTextColor:MAINCOLOR];
    [self.lbTopic setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTopic addSubview:self.lbTopic];
    
    self.textTitle = [[ZTextView alloc] init];
    [self.textTitle setText:self.modelQD.title];
    [self.textTitle setBackgroundColor:RGBCOLOR(244, 245, 246)];
    [self.textTitle setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.textTitle setFont:kQuestion_TextView_Font];
    [self.textTitle setScrollsToTop:NO];
    [self.viewTitle addSubview:self.textTitle];
    
    self.textContent = [[ZTextView alloc] init];
    [self.textContent setText:self.modelQD.qContent];
    [self.textContent setBackgroundColor:RGBCOLOR(244, 245, 246)];
    [self.textContent setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.textContent setFont:kQuestion_TextView_Font];
    [self.textContent setScrollsToTop:NO];
    [self.viewContent addSubview:self.textContent];
    
    self.btnAdd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAdd setImage:[SkinManager getImageWithName:@"btn_tianjiahuati"] forState:(UIControlStateNormal)];
    [self.btnAdd setImage:[SkinManager getImageWithName:@"btn_tianjiahuati"] forState:(UIControlStateHighlighted)];
    [self.btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnAdd setTag:1000];
    [self.viewTopicContent addSubview:self.btnAdd];
    
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
    [self.lbTopic setFrame:CGRectMake(space, space, self.svFrame.size.width, lbH)];
    
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
    
    [self setViewTopicFrame];
}
///设置话题区域坐标
-(void)setViewTopicFrame
{
    [self.viewTopicContent setFrame:CGRectMake(0, self.lbTopic.y+self.lbTopic.height, self.svFrame.size.width, self.svTopicItemH)];
    
    [self.viewTopic setFrame:CGRectMake(0, self.viewContent.y+self.viewContent.height, self.svFrame.size.width, self.viewTopicContent.y+self.viewTopicContent.height)];
    
    self.svContentH = self.viewTopic.y+self.viewTopic.height;
    [self.scrollView setContentSize:CGSizeMake(self.svFrame.size.width, self.svContentH)];
}
///设置文本内容
-(void)setViewContent
{
    [self.textTitle setText:self.modelQD.title];
    
    [self.textContent setText:self.modelQD.qContent];
    
    [self.arrSelTag removeAllObjects];
    for (NSDictionary *dicT in self.modelQD.arrTopic) {
        ModelTag *modelT = [[ModelTag alloc] initWithCustom:dicT];
        [modelT setIsCheck:YES];
        [self.arrSelTag addObject:modelT];
    }
    [self setViewTopicContent];
}

-(void)btnAddClick
{
    ZQuestionEditTagViewController *itemVC = [[ZQuestionEditTagViewController alloc] init];
    ModelQuestion *modelQ = [[ModelQuestion alloc] init];
    [modelQ setIds:self.modelQD.ids];
    [modelQ setTitle:self.modelQD.title];
    [modelQ setContent:self.modelQD.qContent];
    [modelQ setArrSelTag:self.arrSelTag];
    [itemVC setViewDataWithModel:modelQ];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
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
///设置话题内容
-(void)setViewTopicContent
{
    for (UIView *view in self.viewTopicContent.subviews) {
        if (view.tag < 1000) {
            [view removeFromSuperview];
        }
    }
    CGFloat itemX = 10;
    CGFloat itemY = 10;
    ZWEAKSELF
    int index = 0;
    for (ModelTag *modelTopic in self.arrSelTag) {
        ZTopicLabel *lbTopic = [[ZTopicLabel alloc] init];
        [lbTopic setTopicWithModel:modelTopic];
        CGFloat itemW = [lbTopic getW];
        CGFloat itemH = lbTopic.getH;
        if ((itemX+itemW)>(APP_FRAME_WIDTH-20)) {
            itemY = itemY+itemH;
            itemX = 10;
        }
        [lbTopic setTag:index];
        [lbTopic setFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        [lbTopic setOnDeleteClick:^(ModelTag *model) {
            [weakSelf deleteTopicClick:model];
        }];
        [self.viewTopicContent addSubview:lbTopic];
        itemX = itemX+itemW+10;
        index++;
    }
    CGFloat addW = 40;
    if ((itemX+addW)>(APP_FRAME_WIDTH-20)) {
        itemY = itemY+45;
        itemX = 10;
    }
    [self.btnAdd setFrame:CGRectMake(itemX, itemY+13, addW, 35)];
    self.svTopicItemH = itemY+[ZTopicLabel getH]+30;
}
///删除话题
-(void)deleteTopicClick:(ModelTag *)model
{
    [self.view endEditing:YES];
    if (self.arrSelTag.count <= 1) {
        [ZProgressHUD showError:@"请至少选择一个话题" toView:self.view];
        return;
    } else {
        int row = 0;
        BOOL isRemove = NO;
        for (ModelTag *modelT in self.arrSelTag) {
            if ([modelT.tagId isEqualToString:model.tagId]) {
                isRemove = YES;
                break;
            }
            row++;
        }
        if (isRemove) {[self.arrSelTag removeObjectAtIndex:row];}
        [self setViewTopicContent];
        [self setViewTopicFrame];
    }
}

-(void)setTagViewChange:(NSArray *)arrTag
{
    GCDMainBlock(^{
        [self.arrSelTag removeAllObjects];
        [self.arrSelTag addObjectsFromArray:arrTag];
        [self setViewTopicContent];
        [self setViewTopicFrame];
    });
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    CGRect svFrame = self.svFrame;
    svFrame.size.height -= height;
    [self.scrollView setFrame:svFrame];
}
-(void)setQuestionInfoChange
{
    
}
//完成编辑
-(void)btnRightClick
{
    [self.view endEditing:YES];
    NSString *newTitle = self.textTitle.text;
    if ([newTitle isEmpty]) {
        [ZProgressHUD showError:@"问题不能为空,说点什么吧" toView:self.view];
        return;
    }
    if (newTitle.length < kNumberQuestionMinLength || newTitle.length > kNumberQuestionMaxLength) {
        [ZProgressHUD showError:@"问题长度限制[5-50]字符" toView:self.view];
        return;
    }
    NSString *newContent = self.textContent.text;
    if (newContent.length > kNumberQuestionDescMaxLength) {
        [ZProgressHUD showError:@"问题描述长度限制[0-1000]字符" toView:self.view];
        return;
    }
    if (self.arrSelTag.count == 0) {
        [ZProgressHUD showError:@"请至少选择一个话题" toView:self.view];
        return;
    }
    if (self.arrSelTag.count > 5) {
        [ZProgressHUD showError:@"最多只能选择5个话题" toView:self.view];
        return;
    }
    NSMutableArray *selTagId = [NSMutableArray array];
    for (ModelTag *model in self.arrSelTag) {
        [selTagId addObject:model.tagId];
    }
    ZWEAKSELF
    NSString *strTpoicArr = selTagId.toString;
    [ZProgressHUD showMessage:@"正在编辑,请稍等..." toView:self.view];
    [sns postCircleUpdateQuestionWithUserId:[AppSetting getUserDetauleId] questionId:self.modelQD.ids question:newTitle quizDetail:newContent articles:strTpoicArr resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
            [ZProgressHUD showSuccess:@"问题编辑成功"];
            if (weakSelf.preVC) {
                [weakSelf.preVC performSelector:@selector(setQuestionInfoChange) withObject:nil];
            }
            [weakSelf postPublishQuestionNotification];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
            [ZProgressHUD showError:msg toView:weakSelf.view];
        });
    }];
}

-(void)setViewDataWithModel:(ModelQuestionDetail *)model
{
    [self setModelQD:model];
}

@end
