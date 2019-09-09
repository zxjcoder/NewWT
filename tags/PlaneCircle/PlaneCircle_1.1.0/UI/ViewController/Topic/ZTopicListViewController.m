//
//  ZTopicListViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicListViewController.h"
#import "ZTopicTableView.h"

#import "ZQuestionDetailViewController.h"

@interface ZTopicListViewController ()

@property (strong ,nonatomic) ZTopicTableView *tvMain;

@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) ModelTag *model;
///关注中
@property (assign, nonatomic) BOOL isAttentioning;

@end

@implementation ZTopicListViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"话题"];
    
    [self innerInit];
}

- (void)setViewFrame
{
    [self.tvMain setFrame:VIEW_ITEM_FRAME];
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
    OBJC_RELEASE(_tvMain);
    
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.tvMain = [[ZTopicTableView alloc] init];
    [self.tvMain setOnRowSelected:^(ModelQuestionTopic *model) {
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.ids];
        [modelQB setTitle:model.title];
        [weakSelf showQuestionDetailVC:modelQB];
    }];
    [self.tvMain setOnAnswerClick:^(ModelQuestionTopic *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setQuestion_id:model.ids];
        [modelAB setTitle:model.answerContent];
        [modelAB setUserId:model.userIdA];
        [modelAB setNickname:model.head_imgA];
        [modelAB setSign:model.signA];
        [modelAB setNickname:model.nicknameA];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf refreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf refreshFooter];
    }];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        [weakSelf reloadHeader:YES];
    }];
    [self.tvMain setOnAttentionClick:^(ModelTag *model) {
        [weakSelf setAttTopicClickWithModel:model];
    }];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    [self reloadHeader:YES];
}

-(void)reloadHeader:(BOOL)isFail
{
    ZWEAKSELF
    self.pageNum = 1;
    if(isFail){[self.tvMain setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    NSString *userId = [AppSetting getUserDetauleId];
    [sns getTopicDetailWithTopicId:self.model.tagId userId:userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            
            NSDictionary *dicTag = [result objectForKey:kTagKey];
            if (dicTag && [dicTag isKindOfClass:[NSDictionary class]]) {
                [weakSelf setModel:[[ModelTag alloc] initWithCustom:dicTag]];
                
                BOOL isAtt = [[result objectForKey:@"flag"] boolValue];
                [weakSelf.model setIsAtt:isAtt];
            }
            
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
            [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isFail) {
                [weakSelf.tvMain setBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)refreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    NSString *userId = [AppSetting getUserDetauleId];
    [sns getTopicDetailWithTopicId:self.model.tagId userId:userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            
            NSDictionary *dicTag = [result objectForKey:kTagKey];
            if (dicTag && [dicTag isKindOfClass:[NSDictionary class]]) {
                [weakSelf setModel:[[ModelTag alloc] initWithCustom:dicTag]];
                
                BOOL isAtt = [[result objectForKey:@"flag"] boolValue];
                [weakSelf.model setIsAtt:isAtt];
            }
            
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}

-(void)refreshFooter
{
    ZWEAKSELF
    self.pageNum += 1;
    NSString *userId = [AppSetting getUserDetauleId];
    if (![AppSetting getAutoLogin]) {userId = kOne;}
    [sns getTopicDetailWithTopicId:self.model.tagId userId:userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
            [weakSelf.tvMain setViewDataWithDictionary:result];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
///关注
-(void)setAttTopicClickWithModel:(ModelTag *)model
{
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        if (self.isAttentioning){return;}
        self.isAttentioning = YES;
        if (model.isAtt) {
            [weakSelf.model setIsAtt:NO];
            weakSelf.model.attCount -= 1;
            if (weakSelf.model.attCount < 0) {
                [weakSelf.model setAttCount:0];
            }
            [weakSelf.tvMain setViewDataWithModel:weakSelf.model];
            [sns postDeleteAttentionWithAId:self.model.tagId userId:[AppSetting getUserDetauleId] type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                    [weakSelf.model setIsAtt:YES];
                    weakSelf.model.attCount += 1;
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.model];
                });
            }];
        } else {
            [weakSelf.model setIsAtt:YES];
            weakSelf.model.attCount += 1;
            [weakSelf.tvMain setViewDataWithModel:weakSelf.model];
            [sns postAddAttentionWithuserId:[AppSetting getUserDetauleId] hisId:self.model.tagId type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAttentioning:NO];
                    [weakSelf.model setIsAtt:NO];
                    weakSelf.model.attCount -= 1;
                    if (weakSelf.model.attCount < 0) {
                        [weakSelf.model setAttCount:0];
                    }
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.model];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}

-(void)setViewDataWithModel:(ModelTag *)model
{
    [self setModel:model];
}

@end
