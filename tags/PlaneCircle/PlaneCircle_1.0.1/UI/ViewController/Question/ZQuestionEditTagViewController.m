//
//  ZQuestionEditTagViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionEditTagViewController.h"
#import "ZQuestionSelectTagTVC.h"
#import "ZAlertEditView.h"

@interface ZQuestionEditTagViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *_lastText;
}
///顶部区域
@property (strong, nonatomic) UIView *viewHeader;
///搜索区域
@property (strong, nonatomic) UIView *viewSearch;
///搜索输入框
@property (strong, nonatomic) UITextField *textField;
///搜索Icon
@property (strong, nonatomic) UIImageView *imgSearch;
///还没有相关话题
@property (strong, nonatomic) UILabel *lbAddTag;
///点击添加
@property (strong, nonatomic) UIButton *btnAddTag;
///点击添加下划线
@property (strong, nonatomic) UIView *viewAddTagLine;
///选中的话题
@property (strong, nonatomic) UIView *viewSelTag;
///关联话题TV
@property (strong, nonatomic) ZTableView *tvMain;
///列表话题集合
@property (strong, nonatomic) NSMutableArray *arrMain;
///选中话题集合
@property (strong, nonatomic) NSMutableArray *arrSelTag;
///问题内容
@property (strong, nonatomic) NSString *questionContent;
///搜索话题关键字
@property (strong, nonatomic) NSString *searchTag;
///选中话题高度
@property (assign, nonatomic) CGFloat tagViewH;
///话题点击添加坐标
@property (assign, nonatomic) CGRect tagLBFrame;
///选中话题区域坐标
@property (assign, nonatomic) CGRect tagViewFrame;
///主视图坐标
@property (assign, nonatomic) CGRect tvFrame;
///弹出编辑视图
@property (strong, nonatomic) ZAlertEditView *alertEditView;
///创建话题ID
@property (strong, nonatomic) NSString *createTagId;
///创建过话题
@property (assign, nonatomic) BOOL isCreateTag;

@property (strong, nonatomic) ModelQuestion *modelQD;

@end

@implementation ZQuestionEditTagViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"编辑话题"];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"完成"];
   
    [self registerKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_viewSearch);
    OBJC_RELEASE(_viewSelTag);
    OBJC_RELEASE(_lbAddTag);
    OBJC_RELEASE(_btnAddTag);
    OBJC_RELEASE(_viewAddTagLine);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_arrSelTag);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    self.arrSelTag = [NSMutableArray array];
    
    self.tvFrame = VIEW_ITEM_FRAME;
    
    self.viewHeader = [[UIView alloc] init];
    [self.viewHeader setBackgroundColor:WHITECOLOR];
    
    self.viewSearch = [[UIView alloc] init];
    [self.viewSearch setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewSearch setBackgroundColor:RGBCOLOR(246, 246, 246)];
    [self.viewHeader addSubview:self.viewSearch];
    
    self.textField = [[UITextField alloc] init];
    [self.textField setDelegate:self];
    [self.textField setPlaceholder:@"搜索话题关键字"];
    [self.textField setContentMode:(UIViewContentModeLeft)];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewSearch addSubview:self.textField];
    
    self.imgSearch = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_quanzi_huatiyaoqing_search"]];
    [self.viewSearch addSubview:self.imgSearch];
    
    self.lbAddTag = [[UILabel alloc] init];
    [self.lbAddTag setTextColor:MAINCOLOR];
    [self.lbAddTag setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbAddTag setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbAddTag setText:@"还没有相关话题，点击添加"];
    [self.viewHeader addSubview:self.lbAddTag];
    
    self.btnAddTag = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAddTag setUserInteractionEnabled:YES];
    [self.btnAddTag setBackgroundColor:CLEARCOLOR];
    [self.btnAddTag setTitle:@"   " forState:(UIControlStateNormal)];
    [self.btnAddTag addTarget:self action:@selector(btnAddTagClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewHeader addSubview:self.btnAddTag];
    
    self.viewAddTagLine = [[UIView alloc] init];
    [self.viewAddTagLine setBackgroundColor:MAINCOLOR];
    [self.lbAddTag addSubview:self.viewAddTagLine];
    
    self.viewSelTag = [[UIView alloc] init];
    [self.viewHeader addSubview:self.viewSelTag];
    
    [self.viewHeader sendSubviewToBack:self.lbAddTag];
    [self.viewHeader bringSubviewToFront:self.btnAddTag];
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setRowHeight:[ZQuestionSelectTagTVC getH]];
    [self.view addSubview:self.tvMain];
    
    [self.view sendSubviewToBack:self.tvMain];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [self setViewFrame];
    
    [self innerData];
}
-(void)setViewFrame
{
    [self.viewSearch setFrame:CGRectMake(10, 10, self.view.width-20, 40)];
    CGFloat imgW = 28/2;
    CGFloat imgH = 32/2;
    [self.textField setFrame:CGRectMake(10, 1, self.viewSearch.width-20-imgW-5, 38)];
    [self.imgSearch setFrame:CGRectMake(self.viewSearch.width-imgW-10, self.viewSearch.height/2-imgH/2, imgW, imgH)];
    
    [self.lbAddTag setFrame:CGRectMake(0, self.viewSearch.height+self.viewSearch.y+10, self.view.width, 26)];
    [self.btnAddTag setFrame:CGRectMake(self.lbAddTag.width/2+29, self.lbAddTag.y, 61, self.lbAddTag.height)];
    
    [self.viewAddTagLine setFrame:CGRectMake(self.btnAddTag.x, self.lbAddTag.height-1.2, self.btnAddTag.width, 1.2)];
    
    [self.viewSelTag setFrame:CGRectMake(0, self.lbAddTag.y+self.lbAddTag.height+5, self.view.width, self.tagViewH)];
    
    [self.viewHeader setFrame:CGRectMake(0, 0, self.view.width, self.viewSelTag.height+self.viewSelTag.y)];
    
    [self.tvMain setTableHeaderView:self.viewHeader];
    [self.tvMain setSectionHeaderHeight:self.viewHeader.height];
    [self.tvMain setFrame:self.tvFrame];
}
///禁止点击创建标签
-(void)setTagLBDisable
{
    [self.view endEditing:YES];
    [self setIsCreateTag:YES];
    [self.lbAddTag setTextColor:DESCCOLOR];
    [self.viewAddTagLine setBackgroundColor:DESCCOLOR];
    [self.alertEditView dismiss];
}
///键盘高度
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    CGRect tvFrame = self.tvFrame;
    tvFrame.size.height -= height;
    [self.tvMain setFrame:tvFrame];
    
    [self.alertEditView setViewContentFrameWithKeyboardH:height];
}
-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}
-(void)innerData
{
    [self.arrSelTag addObjectsFromArray:self.modelQD.arrSelTag];
    
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:@"CircleQueryArticleArrayKey"];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        [self setTagArrayWithDictionary:dicLocal];
    } else {
        [self.arrMain addObjectsFromArray:self.arrSelTag];
        [self.tvMain reloadData];
    }
    ZWEAKSELF
    [sns getCircleQueryArticleWithArtName:weakSelf.modelQD.title pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [sqlite setLocalCacheDataWithDictionary:result pathKay:@"CircleQueryArticleArrayKey"];
            [weakSelf setTagArrayWithDictionary:result];
        });
    } errorBlock:nil];
}
///修改话题
-(void)btnRightClick
{
    [self.view endEditing:YES];
    if (self.arrSelTag.count == 0) {
        [ZProgressHUD showError:@"请至少选择一个话题" toView:self.view];
        return;
    }
    if (self.arrSelTag.count > 5) {
        [ZProgressHUD showError:@"最多只能选择5个话题" toView:self.view];
        return;
    }
    if (self.arrSelTag.count == 1) {
        if ([[(ModelTag*)self.arrSelTag.firstObject tagId] isEqualToString:self.createTagId]) {
            [ZProgressHUD showError:@"请再多关联一个话题,才能修改哦" toView:self.view];
            return;
        }
    }
    if (self.preVC) {
        [self.preVC performSelector:@selector(setTagViewChange:) withObject:self.arrSelTag];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTagViewChange:(NSArray *)arrTag
{
    
}
///设置话题搜索数据源
-(void)setTagArrayWithDictionary:(NSDictionary *)dicResult
{
    @synchronized (self) {
        NSArray *arrArticles = [dicResult objectForKey:kResultKey];
        NSMutableArray *arrArticle = [NSMutableArray array];
        if (arrArticles && [arrArticles isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrArticles) {
                ModelTag *model = [[ModelTag alloc] initWithCustom:dic];
                BOOL isAdd = YES;
                for (ModelTag *modelTag in self.arrSelTag) {
                    if ([model.tagId isEqualToString:modelTag.tagId]) {
                        isAdd = NO;
                        break;
                    }
                }
                if(isAdd) {[arrArticle addObject:model];}
            }
        }
        [self.arrMain removeAllObjects];
        [self.arrMain addObjectsFromArray:self.arrSelTag];
        [self.arrMain addObjectsFromArray:arrArticle];
        
        [self.tvMain reloadData];
    }
}
///设置话题空搜索数据源
-(void)setTagArrayWithSelArray
{
    @synchronized (self) {
        [self.arrMain removeAllObjects];
        [self.arrMain addObjectsFromArray:self.arrSelTag];
        
        [self.tvMain reloadData];
    }
}
///添加话题
-(void)btnAddTagClick
{
    [self.view endEditing:YES];
    if (self.isCreateTag) { return; }
    OBJC_RELEASE(_alertEditView);
    self.alertEditView = [[ZAlertEditView alloc] init];
    [self.alertEditView setDefaultText:self.textField.text];
    ZWEAKSELF
    NSString *userId = [AppSetting getUserId];
    [self.alertEditView setOnSubmitClick:^(NSString *content) {
        GCDMainBlock(^{
            [weakSelf.view endEditing:YES];
            [ZProgressHUD showMessage:@"正在添加,请稍等..." toView:weakSelf.alertEditView];
            [sns getCircleSaveArticleWithUserId:userId artName:content resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD dismissForView:weakSelf.alertEditView];
                    NSDictionary *dicTag = [result objectForKey:kResultKey];
                    if (dicTag) {
                        ModelTag *modelTag = [[ModelTag alloc] initWithCustom:dicTag];
                        [modelTag setIsCheck:YES];
                        [weakSelf setCreateTagId:modelTag.tagId];
                        [weakSelf.arrSelTag insertObject:modelTag atIndex:0];
                        [weakSelf.arrMain insertObject:modelTag atIndex:0];
                        [weakSelf.tvMain reloadData];
                        [weakSelf setTagLBDisable];
                        [ZProgressHUD showSuccess:@"话题添加成功" toView:weakSelf.alertEditView];
                    } else {
                        [ZProgressHUD showError:@"话题数据解析错误" toView:weakSelf.alertEditView];
                    }
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsCreateTag:NO];
                    [ZProgressHUD dismissForView:weakSelf.alertEditView];
                    [ZProgressHUD showError:msg toView:weakSelf.alertEditView];
                });
            }];
        });
    }];
    [self.alertEditView setOnCancelClick:^{
        [weakSelf setIsCreateTag:NO];
    }];
    [self.alertEditView show];
}
///选中数据
-(void)setTagCheckWithModel:(ModelTag *)model selTagTVC:(ZQuestionSelectTagTVC *)selTagTVC
{
    if (model.isCheck) {//已选中变未选中
        [selTagTVC setTVCCheckTag:NO];
        int delRow = 0;
        BOOL isDel = NO;
        for (ModelTag *modelTag in self.arrSelTag) {
            if ([modelTag.tagId isEqualToString:model.tagId]) {
                isDel = YES;
                break;
            }
            delRow++;
        }
        if (isDel) {[self.arrSelTag removeObjectAtIndex:delRow];}
    } else {//未选中变已选中
        [selTagTVC setTVCCheckTag:YES];
        [self.arrSelTag addObject:model];
    }
    [self.modelQD setArrSelTag:self.arrSelTag];
}

-(void)setViewDataWithModel:(ModelQuestion *)model
{
    [self setModelQD:model];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(NSNotification *)sender
{
    if (![_lastText isEqualToString:self.textField.text.toTrim]) {
        _lastText = self.textField.text.toTrim;
        
        if ([Utils isContainsEmoji:self.textField.text.toTrim]) {
            [self.textField setText:[self.textField.text stringByReplacingOccurrencesOfString:_lastText withString:kEmpty]];
        }
        
        ZWEAKSELF
        [sns getCircleQueryArticleWithArtName:self.textField.text.toTrim pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setTagArrayWithDictionary:result];
            });
        } errorBlock:nil];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZQuestionSelectTagTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZQuestionSelectTagTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelTag *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnCheckClick:^(ZQuestionSelectTagTVC *selTagTVC, ModelTag *model) {
        [weakSelf setTagCheckWithModel:model selTagTVC:selTagTVC];
    }];
    
    return cell;
}

@end
