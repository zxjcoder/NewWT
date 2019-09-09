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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRefreshType];
    [self setRefreshHeader];
    
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
    OBJC_RELEASE(_tvMain);
    
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
    [self.tvMain setOnSearchClick:^{
        
    }];
    [self.tvMain setOnCancelClick:^{
        [weakSelf setStrSearchContent:kEmpty];
        [weakSelf innerLocalPracticeData];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerLocalPracticeTypeData];
    
    [self innerLocalPracticeData];
}
-(void)innerLocalPracticeData
{
    NSString *userId = [AppSetting getUserDetauleId];
    NSArray *arrP = [sqlite getLocalPracticeTypePracticeListArrayWithUserId:userId];
    if (arrP && arrP.count > 0) {
        [self.tvMain setViewPracticeDataWithArray:arrP isHeader:YES];
    }
}
-(void)innerLocalPracticeTypeData
{
    NSString *userId = [AppSetting getUserDetauleId];
    NSArray *arrPT = [sqlite getLocalPracticeTypeArrayWithUserId:userId];
    if (arrPT && arrPT.count > 0) {
        [self.tvMain setViewTypeDataWithArray:arrPT];
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
    [self setSearchContentWithValue:textField.text];
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
-(void)setRefreshType
{
    ZWEAKSELF
    [snsV2 getPracticeTypeArrayWithPageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewTypeDataWithArray:arrResult];
        
        [sqlite setLocalPracticeTypeWithArray:arrResult userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewTypeDataWithArray:nil];
    }];
}
-(void)setSearchContentWithValue:(NSString *)content
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getPracticeTypePracticeArrayWithParam:content pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain setViewPracticeDataWithArray:arrResult isHeader:YES];
        
    } errorBlock:^(NSString *msg) {
        
    }];
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getPracticeTypePracticeArrayWithParam:self.strSearchContent pageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewPracticeDataWithArray:arrResult isHeader:YES];
        if (weakSelf.strSearchContent.length == 0) {
            [sqlite setLocalPracticeTypePracticeListWithArray:arrResult userId:[AppSetting getUserDetauleId]];
        }
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewPracticeDataWithArray:nil isHeader:YES];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getPracticeTypePracticeArrayWithParam:self.strSearchContent pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewPracticeDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

@end
