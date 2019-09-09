//
//  ZMyCommentReplyTableView.m
//  PlaneCircle
//
//  Created by Daniel on 8/30/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCommentReplyTableView.h"
#import "ZMyCommentReplyTVC.h"

@interface ZMyCommentReplyTableView()<UITableViewDelegate,UITableViewDataSource>

///用于计算高度
@property (strong, nonatomic) ZMyCommentReplyTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyCommentReplyTableView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.arrMain = [NSMutableArray array];
    
    self.tvcItem = [[ZMyCommentReplyTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setTableHeaderView:nil];
    
    __weak typeof(self) weakSelf = self;
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [super setViewDataWithDictionary:dicResult];
    
    NSArray *arrList = [dicResult objectForKey:kResultKey];
    NSMutableArray *arrResult = [NSMutableArray array];
    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in arrList) {
            ModelQuestionMyAnswerComment *model = [[ModelQuestionMyAnswerComment alloc] initWithCustom:dic];
            [arrResult addObject:model];
        }
    }
    __weak typeof(self) weakSelf = self;
    BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
    if (isHeader) {
        [self.arrMain removeAllObjects];
        if (arrResult.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateNull)];
        } else {
            [self setBackgroundViewWithState:(ZBackgroundStateNone)];
        }
    }
    if (arrResult.count >= kPAGE_MAXCOUNT) {
        [self addRefreshFooterWithEndBlock:^{
            if (weakSelf.onRefreshFooter) {
                weakSelf.onRefreshFooter();
            }
        }];
    } else {
        [self removeRefreshFooter];
    }
    [self.arrMain addObjectsFromArray:arrResult];
    [self reloadData];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self setIsDelete:isDel];
}
-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_arrMain);
    
    OBJC_RELEASE(_tvcItem);
    
    OBJC_RELEASE(_onUserInfoClick);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_onCommentClick);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelQuestionMyAnswerComment *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcItem getHWithModel:model];
    return rowH;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZMyCommentReplyTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyCommentReplyTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelQuestionMyAnswerComment *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    [cell setOnPhotoClick:^(ModelQuestionMyAnswerComment *model) {
        if (weakSelf.onUserInfoClick) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:model.userid];
            [modelUB setNickname:model.nickname];
            [modelUB setHead_img:model.head_img];
            weakSelf.onUserInfoClick(modelUB);
        }
    }];
    [cell setOnAnswerClick:^(ModelQuestionMyAnswerComment *model) {
        if (model.type == 0) {
            if (weakSelf.onAnswerClick) {
                ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
                [modelAB setQuestion_id:model.qid];
                [modelAB setIds:model.aid];
                [modelAB setTitle:model.acontent];
                weakSelf.onAnswerClick(modelAB);
            }
        } else {
            if (weakSelf.onCommentClick) {
                ModelAnswerComment *modelAC = [[ModelAnswerComment alloc] init];
                [modelAC setIds:model.ids];
                [modelAC setContent:model.content];
                [modelAC setUserId:model.userid];
                [modelAC setNickname:model.nickname];
                [modelAC setHead_img:model.head_img];
                
                ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
                [modelAB setQuestion_id:model.qid];
                [modelAB setIds:model.aid];
                [modelAB setTitle:model.acontent];
                
                weakSelf.onCommentClick(modelAB, modelAC);
            }
        }
    }];
    [cell setOnCommentClick:^(ModelQuestionMyAnswerComment *model) {
        if (weakSelf.onCommentClick) {
            ModelAnswerComment *modelAC = [[ModelAnswerComment alloc] init];
            [modelAC setIds:model.ids];
            [modelAC setContent:model.content];
            [modelAC setUserId:model.userid];
            [modelAC setNickname:model.nickname];
            [modelAC setHead_img:model.head_img];
            
            ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
            [modelAB setQuestion_id:model.qid];
            [modelAB setIds:model.aid];
            [modelAB setTitle:model.acontent];
            
            weakSelf.onCommentClick(modelAB, modelAC);
        }
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelQuestionMyAnswerComment *model = [self.arrMain objectAtIndex:indexPath.row];
    model.status = 1;
    if (self.onCommentClick) {
        ModelAnswerComment *modelAC = [[ModelAnswerComment alloc] init];
        [modelAC setIds:model.ids];
        if (model.type == 0) {
            [modelAC setContent:model.content];
        } else {
            [modelAC setContent:model.acontent];
        }
        
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setQuestion_id:model.qid];
        [modelAB setIds:model.aid];
        [modelAB setTitle:model.acontent];
        
        self.onCommentClick(modelAB, modelAC);
    }
}

@end
