//
//  ZCircleSearchViewController.m
//  PlaneLive
//
//  Created by Daniel on 13/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchViewController.h"
#import "ZCircleSearchView.h"
#import "ZCircleSearchTableView.h"
#import "ZTopicListViewController.h"

@interface ZCircleSearchViewController ()<UISearchBarDelegate>
{
    CGRect _tvSearchFrame;
}
///左边展示搜索框
@property (strong, nonatomic) UISearchBar *searchBar;
///取消
@property (strong, nonatomic) UIButton *btnCancel;
///输入框
@property (weak, nonatomic) UITextField *textField;
///搜索内容区域
@property (strong, nonatomic) ZCircleSearchTableView *tvSearch;

///搜索内容
@property (assign, nonatomic) int pageSearchContnet;
///搜索用户
@property (assign, nonatomic) int pageSearchUser;
///搜索内容
@property (strong, nonatomic) NSString *lastSearchContent;

@end

@implementation ZCircleSearchViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self registerKeyboardNotification];

    [self registerTextFieldTextDidChangeNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self removeKeyboardNotification];

    [self removeTextFieldTextDidChangeNotification];
    
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
- (void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    _searchBar.delegate = nil;
    OBJC_RELEASE(_searchBar);
    OBJC_RELEASE(_tvSearch);
    OBJC_RELEASE(_lastSearchContent);
    OBJC_RELEASE(_btnCancel);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    [viewTitle setBackgroundColor:WHITECOLOR];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, viewTitle.width-60, viewTitle.height)];
    [self.searchBar setBarTintColor:CLEARCOLOR];
    [self.searchBar setBackgroundColor:CLEARCOLOR];
    [self.searchBar setDelegate:self];
    [self.searchBar setShowsCancelButton:NO];
    [self setSearchTextFiled];
    [viewTitle addSubview:self.searchBar];
    
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel setTitle:kCancel forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.btnCancel setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnCancel setFrame:CGRectMake(viewTitle.width-60, 0, 55, viewTitle.height)];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [viewTitle addSubview:self.btnCancel];
    
    [self.navigationItem setTitleView:viewTitle];
    [self.navigationItem setHidesBackButton:YES];
    
    ZWEAKSELF
    _tvSearchFrame = VIEW_ITEM_FRAME;
    self.tvSearch = [[ZCircleSearchTableView alloc] initWithFrame:_tvSearchFrame];
    //搜索话题点击事件
    [self.tvSearch setOnTagClick:^(ModelTag *model) {
        [weakSelf showTagDetailVC:model];
    }];
    //搜索内容底部刷新
    [self.tvSearch setOnRefreshContentFooter:^{
        [weakSelf setSearchContentRefreshFooter];
    }];
    //搜索用户底部刷新
    [self.tvSearch setOnRefreshUserFooter:^{
        [weakSelf setSearchUserRefreshFooter];
    }];
    ///选中搜索用户
    [self.tvSearch setOnUserItemClick:^(ModelUserBase *model) {
        [weakSelf showUserProfileVCWithModel:model];
    }];
    ///选中搜索内容
    [self.tvSearch setOnContentItemClick:^(ModelQuestionBase *model) {
        [weakSelf.view endEditing:YES];
        [weakSelf showQuestionDetailVC:model];
    }];
    ///开始滑动
    [self.tvSearch setOnOffsetChange:^(CGFloat y) {
        [weakSelf.searchBar resignFirstResponder];
    }];
    [self.tvSearch setOnUserBackgoundClick:^{
        [weakSelf setSearchUserRefreshHeader];
    }];
    [self.tvSearch setOnContentBackgoundClick:^{
        [weakSelf setSearchContentRefreshHeader];
    }];
    [self.view addSubview:self.tvSearch];
    
    [super innerInit];
    
    [self innerData];
}
-(void)innerData
{
    [self setSearchWithContent:kEmpty];
}
///设置搜索按钮是否可用
-(void)setSearchTextFiled
{
    UITextField *textField = nil;
    for (UIView *view in self.searchBar.subviews) {
        if (view.subviews.count > 0) {
            for (UIView *item in view.subviews) {
                if ([item isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                    textField = (UITextField *)item;
                }
                if ([item isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [item removeFromSuperview];
                }
            }
        }
    }
    if (textField) {
        [textField setReturnKeyType:(UIReturnKeyDone)];
        [textField setBackgroundColor:SEARCHBACKCOLOR];
        [[textField layer] setMasksToBounds:YES];
        [textField setViewRound:14 borderWidth:0 borderColor:CLEARCOLOR];
        self.textField = textField;
        [self setSearchPlaceholder:kClickSearchQuestionOrAnswerOrUser];
    }
}
-(void)setSearchPlaceholder:(NSString *)placeholder
{
    [self.textField setPlaceholder:placeholder];
    [self.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{NSForegroundColorAttributeName:SEARCHTINTCOLOR,NSFontAttributeName:[ZFont systemFontOfSize:kFont_Least_Size]}]];
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldTextDidChange:(UITextField *)textField
{
    NSString *content = textField.text.toTrim;
    if (![content isIncludingEmoji]) {
        if (content.length > kSearchContentMaxLength) {
            [textField setText:[content substringToIndex:kSearchContentMaxLength]];
        }
        [self setSearchWithContent:content];
    } else {
        [textField setText:[content removedEmojiString]];
    }
}
///搜索内容
-(void)setSearchWithContent:(NSString *)content
{
    if (![content isEqualToString:self.lastSearchContent]) {
        [self setLastSearchContent:content];
        
        [self.tvSearch setViewCircleKeyword:content];
        
        [self setSearchContentRefreshHeader];
        
        [self setSearchUserRefreshHeader];
    }
}
///搜索内容顶部刷新
-(void)setSearchContentRefreshHeader
{
    ZWEAKSELF
    weakSelf.pageSearchContnet = 1;
    [snsV1 getCircleQueryQuestionAnswerWithUserId:kLoginUserId content:self.lastSearchContent pageNum:weakSelf.pageSearchContnet resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvSearch setViewCircleContentWithDictionary:dicResult];
        });
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvSearch setViewCircleContentWithDictionary:nil];
    }];
}
///搜索用户顶部刷新
-(void)setSearchUserRefreshHeader
{
    ZWEAKSELF
    weakSelf.pageSearchUser = 1;
    [snsV1 getCircleSearchUserWithUserId:kLoginUserId content:self.lastSearchContent pageNum:weakSelf.pageSearchUser resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvSearch setViewCircleUserWithDictionary:dicResult];
        });
    }  errorBlock:^(NSString *msg) {
        [weakSelf.tvSearch setViewCircleUserWithDictionary:nil];
    }];
}
///搜索内容底部刷新
-(void)setSearchContentRefreshFooter
{
    ZWEAKSELF
    [snsV1 getCircleQueryQuestionAnswerWithUserId:kLoginUserId content:self.lastSearchContent pageNum:weakSelf.pageSearchContnet+1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            
            weakSelf.pageSearchContnet += 1;
            [weakSelf.tvSearch setViewCircleContentWithDictionary:result];
        });
    } errorBlock:nil];
}
///搜索用户底部刷新
-(void)setSearchUserRefreshFooter
{
    ZWEAKSELF
    [snsV1 getCircleSearchUserWithUserId:kLoginUserId content:self.lastSearchContent pageNum:weakSelf.pageSearchUser+1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            
            weakSelf.pageSearchUser += 1;
            [weakSelf.tvSearch setViewCircleUserWithDictionary:result];
        });
    } errorBlock:nil];
}
///键盘改变事件
-(void)keyboardFrameChange:(CGFloat)height
{
    CGRect tvSearchFrame = _tvSearchFrame;
    tvSearchFrame.size.height -= height;
    [self.tvSearch setFrame:tvSearchFrame];
}
///显示他人用户界面
-(void)showUserProfileVCWithModel:(ModelUserBase *)model
{
    if (![Utils isMyUserId:model.userId]) {
        [self showUserProfileVC:model];
    }
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
///显示答案详情界面
-(void)showCircleAnswerDetailVC:(ModelCircleSearchContent *)model
{
    [self.view endEditing:YES];
    ModelAnswerBase *modelB = [[ModelAnswerBase alloc] init];
    [modelB setIds:model.ids];
    [modelB setTitle:model.title];
    [self showAnswerDetailVC:modelB];
}

-(void)btnCancelClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

@end
