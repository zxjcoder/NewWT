//
//  ZQuestionAnswerTableView.m
//  PlaneLive
//
//  Created by Daniel on 03/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionAnswerTableView.h"
#import "ZQuestionAnswerTVC.h"

@interface ZQuestionAnswerTableView()<UITableViewDelegate,UITableViewDataSource>

///计算高度
@property (strong, nonatomic) ZQuestionAnswerTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZQuestionAnswerTableView

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
    
    self.tvcItem = [[ZQuestionAnswerTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    ZWEAKSELF
    [self setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_onPhotoClick);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_onQuestionClick);
}

-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateNull)];
            } else {
                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
        }
        ZWEAKSELF
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [self setRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrResult];
    } else {
        if (self.arrMain.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }
    [self reloadData];
}

-(void)setFontSizeChange
{
    [self reloadData];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelQuestionItem *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcItem setCellDataWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZQuestionAnswerTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZQuestionAnswerTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelQuestionItem *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    ZWEAKSELF
    [cell setOnAnswerClick:^(ModelAnswerBase *model) {
        if (weakSelf.onAnswerClick) {
            weakSelf.onAnswerClick(model);
        }
    }];
    [cell setOnPhotoClick:^(ModelUserBase *model) {
        if (weakSelf.onPhotoClick) {
            weakSelf.onPhotoClick(model);
        }
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onQuestionClick) {
        ModelQuestionItem *model = [self.arrMain objectAtIndex:indexPath.row];
        self.onQuestionClick(model);
    }
}

@end
