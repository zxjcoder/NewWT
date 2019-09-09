//
//  ZTopicTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicTableView.h"
#import "ZTopicItemTVC.h"
#import "ZTopicHeaderView.h"
#import "ZBackgroundView.h"

@interface ZTopicTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZTopicHeaderView *viewHeader;

@property (strong, nonatomic) ModelTag *modelTag;

///用于计算高度
@property (strong, nonatomic) ZTopicItemTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZTopicTableView

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
    
    self.tvcItem = [[ZTopicItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    __weak typeof(self) weakSelf = self;
    self.viewHeader = [[ZTopicHeaderView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZTopicHeaderView getViewH])];
    [self.viewHeader setOnAttentionClick:^(ModelTag *model) {
        if (weakSelf.onAttentionClick) {
            weakSelf.onAttentionClick(model);
        }
    }];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setTableHeaderView:nil];
}
-(void)setViewDataWithModel:(ModelTag *)model
{
    [self setModelTag:model];
    
    [self.viewHeader setViewDataWithModel:model];
}
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [super setViewDataWithDictionary:dicResult];
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
        NSArray *arrList = [dicResult objectForKey:kQuestionAllKey];
        NSMutableArray *arrHot = [NSMutableArray array];
        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrList) {
                ModelQuestionTopic *model = [[ModelQuestionTopic alloc] initWithCustom:dic];
                [arrHot addObject:model];
            }
        }
        ZWEAKSELF
        if (isHeader) {
            NSDictionary *dicTopic = [dicResult objectForKey:kTagKey];
            if (dicTopic && [dicTopic isKindOfClass:[NSDictionary class]]) {
                BOOL isAtt = [[dicResult objectForKey:@"flag"] boolValue];
                ModelTag *model = [[ModelTag alloc] initWithCustom:dicTopic];
                [model setIsAtt:isAtt];
                [self setViewDataWithModel:model];
            }
            
            [self.arrMain removeAllObjects];
            [self addRefreshHeaderWithEndBlock:^{
                if (weakSelf.onRefreshHeader) {
                    weakSelf.onRefreshHeader();
                }
            }];
        }
        if (arrHot.count >= kPAGE_MAXCOUNT) {
            [self addRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrHot];
        [self reloadData];
    }
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_onAttentionClick);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_modelTag);
    OBJC_RELEASE(_onRowSelected);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [ZTopicHeaderView getViewH];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelQuestionTopic *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcItem getHWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZTopicItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZTopicItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelQuestionTopic *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    ZWEAKSELF
    [cell setOnAnswerClick:^(ModelAnswerBase *model) {
        if (weakSelf.onAnswerClick) {
            weakSelf.onAnswerClick(model);
        }
    }];
    [cell setOnImagePhotoClick:^(ModelUserBase *model) {
        if (weakSelf.onImagePhotoClick) {
            weakSelf.onImagePhotoClick(model);
        }
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onRowSelected) {
        ModelQuestionTopic *model = [self.arrMain objectAtIndex:indexPath.row];
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.ids];
        [modelQB setTitle:model.title];
        self.onRowSelected(modelQB);
    }
}

@end
