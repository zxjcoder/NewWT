//
//  ZPracticeTypeViewController.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeTypeViewController.h"
#import "ZPracticeTypeTableView.h"
#import "ZPracticeListViewController.h"

@interface ZPracticeTypeViewController ()
{
    CGRect _tvFrame;
}
@property (strong, nonatomic) ZPracticeTypeTableView *tvMain;
@property (assign, nonatomic) ZPracticeTypeSort sort;
@property (assign, nonatomic) int pageNum;
@property (strong, nonatomic) NSString *strSearchContent;

@end

@implementation ZPracticeTypeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kPractice];
    [self innerInit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCartPaySuccess:) name:ZCartPaySuccessNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
    [self registerTextFieldTextDidChangeNotification];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeTextFieldTextDidChangeNotification];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZCartPaySuccessNotification object:nil];
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_strSearchContent);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    _tvFrame = VIEW_ITEM_FRAME;
    self.tvMain = [[ZPracticeTypeTableView alloc] initWithFrame:_tvFrame];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnPracticeClick:^(NSArray *array, NSInteger row) {
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.tvMain setOnPracticeAllClick:^(ModelPracticeType *model) {
        ZPracticeListViewController *itemVC = [[ZPracticeListViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    [self.tvMain setOnSearchClick:^(NSString *content) {
        int maxLength = kSearchContentMaxLength;
        if (maxLength > 0 && content.length > maxLength) {
            [weakSelf.tvMain setTextFieldText:content];
        }
        [weakSelf setStrSearchContent:content];
        [weakSelf setSearchContentWithValue:content];
    }];
    [self.tvMain setOnSortClick:^(ZPracticeTypeSort sort) {
        [weakSelf setSortClick:sort];
    }];
    [self.tvMain setOnCancelClick:^{
        [weakSelf setStrSearchContent:kEmpty];
        [weakSelf innerLocalPracticeData];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self setSort:self.tvMain.getSortValue];
    [self innerLocalPracticeTypeData];
    [self innerLocalPracticeData];
    [self setRefreshType];
    [self setRefreshHeader];
}
-(void)innerLocalPracticeData
{
    NSString *userId = kLoginUserId;
    NSArray *arrP = [sqlite getLocalPracticeTypePracticeListArrayWithUserId:userId];
    if (arrP && arrP.count > 0) {
        [self.tvMain setViewPracticeDataWithArray:arrP isHeader:YES];
    }
}
-(void)innerLocalPracticeTypeData
{
    NSString *userId = kLoginUserId;
    NSArray *arrPT = [sqlite getLocalPracticeTypeArrayWithUserId:userId];
    if (arrPT && arrPT.count > 0) {
        [self.tvMain setViewTypeDataWithArray:arrPT];
    }
}
///购买成功刷新数据对象
-(void)setCartPaySuccess:(NSNotification *)sender
{
    if (sender.object && [sender.object isKindOfClass:[ModelPractice class]]) {
        [self.tvMain setPayPracticeSuccess:sender.object];
    }
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
    UITextField *textField = sender.object;
    int maxLength = kSearchContentMaxLength;
    NSString *content = textField.text;
    if (maxLength > 0 && content.length > maxLength) {
        [textField setText:[content substringToIndex:maxLength]];
    }
    [self setStrSearchContent:textField.text];
}
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    if (height > kKeyboard_Min_Height) {
        CGRect tvFrame = _tvFrame;
        tvFrame.size.height -= height;
        [self.tvMain setFrame:tvFrame];
    } else {
        [self.tvMain setFrame:_tvFrame];
    }
}
-(void)setSortClick:(ZPracticeTypeSort)sort
{
    if (self.sort != sort) {
        [self setSort:sort];
        
        [self setRefreshHeader];
    }
}
-(void)setRefreshType
{
    ZWEAKSELF
    [snsV2 getPracticeTypeArrayWithPageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewTypeDataWithArray:arrResult];
        
        [sqlite setLocalPracticeTypeWithArray:arrResult userId:kLoginUserId];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewTypeDataWithArray:nil];
    }];
}
-(void)setSearchContentWithValue:(NSString *)content
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getPracticeTypePracticeArrayWithParam:content pageNum:self.pageNum sort:self.sort resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain setViewPracticeDataWithArray:arrResult isHeader:YES];
    } errorBlock:^(NSString *msg) {
        
    }];
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getPracticeTypePracticeArrayWithParam:self.strSearchContent pageNum:self.pageNum sort:self.sort resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewPracticeDataWithArray:arrResult isHeader:YES];
        if (weakSelf.strSearchContent.length == 0) {
            [sqlite setLocalPracticeTypePracticeListWithArray:arrResult userId:kLoginUserId];
        }
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewPracticeDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getPracticeTypePracticeArrayWithParam:self.strSearchContent pageNum:self.pageNum+1 sort:self.sort resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewPracticeDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

@end
