//
//  ZQuestionDetailTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionDetailTableView.h"
#import "ZQuestionDetailAnswerView.h"
#import "ZQuestionDetailAnswerTVC.h"
#import "ZQuestionDetailAttTVC.h"
#import "ZQuestionDetailInfoTVC.h"
#import "ZQuestionDetailTagTVC.h"

@interface ZQuestionDetailTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZQuestionDetailAnswerView *viewAnswerHeader;

@property (strong, nonatomic) ZQuestionDetailAnswerTVC *tvcAnswerItem;

@property (strong, nonatomic) ZQuestionDetailInfoTVC *tvcInfo;
@property (strong, nonatomic) ZQuestionDetailTagTVC *tvcTopic;
@property (strong, nonatomic) ZQuestionDetailAttTVC *tvcAtt;
///问题
@property (strong, nonatomic) NSArray *arrQuestion;
///答案
@property (strong, nonatomic) NSMutableArray *arrAnswer;

@property (strong, nonatomic) ModelQuestionDetail *model;

@end

@implementation ZQuestionDetailTableView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.tvcAnswerItem = [[ZQuestionDetailAnswerTVC alloc] initWithReuseIdentifier:@"tvcAnswerItem"];
    
    __weak typeof(self) weakSelf = self;
    self.tvcInfo = [[ZQuestionDetailInfoTVC alloc] initWithReuseIdentifier:@"tvcInfo"];
    [self.tvcInfo setOnHeightClick:^(CGFloat rowH) {
        GCDMainBlock(^{
            [weakSelf reloadData];
        });
    }];
    [self.tvcInfo setOnImagePhotoClick:^(ModelQuestionDetail *model) {
        if (weakSelf.onImagePhotoClick) {
            ModelUserBase *modelB = [[ModelUserBase alloc] init];
            [modelB setUserId:model.userId];
            [modelB setNickname:model.nickname];
            [modelB setHead_img:model.head_img];
            [modelB setSign:model.sign];
            weakSelf.onImagePhotoClick(modelB);
        }
    }];
    self.tvcTopic = [[ZQuestionDetailTagTVC alloc] initWithReuseIdentifier:@"tvcTopic"];
    [self.tvcTopic setOnTopicClick:^(ModelTag *model) {
        if (weakSelf.onTopicSelected) {
            weakSelf.onTopicSelected(model);
        }
    }];
    self.tvcAtt = [[ZQuestionDetailAttTVC alloc] initWithReuseIdentifier:@"tvcAtt"];
    [self.tvcAtt setOnAttentionClick:^(ModelQuestionDetail *model) {
        if (weakSelf.onAttentionClick) {
            weakSelf.onAttentionClick(model);
        }
    }];
    self.viewAnswerHeader = [[ZQuestionDetailAnswerView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZQuestionDetailAnswerView getViewH])];
    [self.viewAnswerHeader setOnAddAnswerClick:^(ModelQuestionDetail *model) {
        if (weakSelf.onAddAnswerClick) {
            weakSelf.onAddAnswerClick(model);
        }
    }];
    [self.viewAnswerHeader setOnInvitationClick:^(ModelQuestionDetail *model) {
        if (weakSelf.onInvitationClick) {
            weakSelf.onInvitationClick(model);
        }
    }];
    
    self.arrAnswer = [NSMutableArray array];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
}

-(void)setDeleteRowWithRow:(NSInteger )row
{
    if (row < self.arrAnswer.count) {
        [self.arrAnswer removeObjectAtIndex:row];
        [self reloadData];
    }
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
    NSArray *arrList = [dicResult objectForKey:kResultKey];
    NSMutableArray *arrA = [NSMutableArray array];
    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in arrList) {
            ModelAnswerBase *modelB = [[ModelAnswerBase alloc] initWithCustom:dic];
            [arrA addObject:modelB];
        }
    }
    __weak typeof(self) weakSelf = self;
    if (isHeader) {
        [self.arrAnswer removeAllObjects];
        [self addRefreshHeaderWithEndBlock:^{
            if (weakSelf.onRefreshHeader) {
                weakSelf.onRefreshHeader();
            }
        }];
    }
    if (arrA.count >= kPAGE_MAXCOUNT) {
        [self addRefreshFooterWithEndBlock:^{
            if (weakSelf.onRefreshFooter) {
                weakSelf.onRefreshFooter();
            }
        }];
    } else {
        [self removeRefreshFooter];
    }
    [self.arrAnswer addObjectsFromArray:arrA];
    [self reloadData];
}

-(void)setViewDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    
    [self.tvcAtt setCellDataWithModel:model];
    [self.tvcTopic setCellDataWithModel:model];
    [self.tvcInfo setCellDataWithModel:model];
    [self.viewAnswerHeader setViewDataWithModel:model];
    
    if (self.arrQuestion.count == 0) { self.arrQuestion = @[self.tvcInfo,self.tvcTopic,self.tvcAtt]; }
    
    [self reloadData];
}

-(void)addViewDataWithAnswerId:(NSString *)answerId
{
    [self.model setAnswerQuestion:answerId];
    [self.viewAnswerHeader setViewDataWithModel:self.model];
}

-(void)dealloc
{
    OBJC_RELEASE(_tvcAtt);
    OBJC_RELEASE(_viewAnswerHeader);
    OBJC_RELEASE(_tvcInfo);
    OBJC_RELEASE(_tvcTopic);
    OBJC_RELEASE(_tvcAnswerItem);
    OBJC_RELEASE(_arrAnswer);
    OBJC_RELEASE(_arrQuestion);
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.arrQuestion.count;
    }
    return self.arrAnswer.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return [ZQuestionDetailAnswerView getViewH];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return self.viewAnswerHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZBaseTVC *cell = [self.arrQuestion objectAtIndex:indexPath.row];
        return [cell getH];
    }
    ModelAnswerBase *modelB = [self.arrAnswer objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcAnswerItem getHWithModel:modelB];
    return rowH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self.arrQuestion objectAtIndex:indexPath.row];
    }
    
    static NSString *cellid = @"tvcellid";
    ZQuestionDetailAnswerTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZQuestionDetailAnswerTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    __weak typeof(self) weakSelf = self;
    ModelAnswerBase *model = [self.arrAnswer objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    [cell setOnImagePhotoClick:^(ModelAnswerBase *model) {
        if (weakSelf.onImagePhotoClick) {
            ModelUserBase *modelB = [[ModelUserBase alloc] init];
            [modelB setUserId:model.userId];
            [modelB setNickname:model.nickname];
            [modelB setHead_img:model.head_img];
            [modelB setSign:model.sign];
            weakSelf.onImagePhotoClick(modelB);
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.onRowSelected) {
            ModelAnswerBase *modelB = [self.arrAnswer objectAtIndex:indexPath.row];
            self.onRowSelected(modelB, indexPath.row);
        }
    }
}

@end
