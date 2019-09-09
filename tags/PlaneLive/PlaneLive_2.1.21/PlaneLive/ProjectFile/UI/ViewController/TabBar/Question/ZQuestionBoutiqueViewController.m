//
//  ZQuestionBoutiqueViewController.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionBoutiqueViewController.h"
#import "ZQuestionAnswerTableView.h"

@interface ZQuestionBoutiqueViewController ()

@property (strong, nonatomic) ZQuestionAnswerTableView *tvMain;

@property (assign, nonatomic) int pageNum;

@end

@implementation ZQuestionBoutiqueViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kBoutiqueQuestionsAndAnswers];
    
    [self innerInit];
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
    self.tvMain = [[ZQuestionAnswerTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnPhotoClick:^(ModelUserBase *model) {
        [weakSelf showUserProfileVC:model];
    }];
    [self.tvMain setOnAnswerClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    [self.tvMain setOnQuestionClick:^(ModelQuestionItem *model) {
        [weakSelf showQuestionDetailVC:model];
    }];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf setRefreshHeader];
    }];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
    
    [self innerData];
}

-(void)innerData
{
    NSArray *arrQuestion = [sqlite getLocalBoutiqueQuestionArrayWithAll];
    if (arrQuestion && arrQuestion.count > 0) {
        [self.tvMain setViewDataWithArray:arrQuestion isHeader:YES];
    }
    
    [self setRefreshHeader];
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getBoutiqueQuestionAndAnswerWithPageNum:self.pageNum resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalBoutiqueQuestionWithArray:arrResult];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithArray:nil isHeader:YES];
    }];
}

-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getBoutiqueQuestionAndAnswerWithPageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNum += 1;
        [weakSelf.tvMain endRefreshFooter];
        [weakSelf.tvMain setViewDataWithArray:arrResult isHeader:YES];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshFooter];
    }];
}

@end
