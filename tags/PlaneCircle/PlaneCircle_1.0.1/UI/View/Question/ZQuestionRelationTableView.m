//
//  ZQuestionRelationTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionRelationTableView.h"
#import "ZQuestionRelationTVC.h"
#import "ZCircleSearchTagView.h"

@interface ZQuestionRelationTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ZCircleSearchTagView *viewSearchTag;

@property (strong, nonatomic) ZQuestionRelationTVC *tvcItem;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) NSString *keyword;

@end

@implementation ZQuestionRelationTableView

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
    
    self.arrMain = [NSMutableArray array];
    
    self.tvcItem = [[ZQuestionRelationTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    __weak typeof(self) weakSelf = self;
    self.viewSearchTag = [[ZCircleSearchTagView alloc] init];
    [self.viewSearchTag setOnSearchTagClick:^(ModelTag *model) {
        if (weakSelf.onTagSelected) {
            weakSelf.onTagSelected(model);
        }
    }];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
}

-(void)setViewFrame
{
    self.width = APP_FRAME_WIDTH;
    [self.viewSearchTag setFrame:CGRectMake(0, 0, self.width, [ZCircleSearchTagView getViewH])];
    [self.viewLine setFrame:CGRectMake(0, 0, self.width, 0.8)];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [self.arrMain removeAllObjects];
    
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        [super setViewDataWithDictionary:dicResult];
        NSDictionary *dicTag = [dicResult objectForKey:kTagKey];
        if (dicTag && [dicTag isKindOfClass:[NSDictionary class]]) {
            [self setViewFrame];
            ModelTag *modelTag = [[ModelTag alloc] initWithCustom:dicTag];
            [self.viewSearchTag setViewDataWithModel:modelTag];
            [self setTableHeaderView:self.viewSearchTag];
            [self setSectionHeaderHeight:self.viewSearchTag.height];
        } else {
            [self setTableHeaderView:self.viewLine];
            [self setSectionHeaderHeight:self.viewLine.height];
        }
        NSArray *arrList = [dicResult objectForKey:kResultKey];
        NSMutableArray *arrHot = [NSMutableArray array];
        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrList) {
                ModelCircleSearchContent *model = [[ModelCircleSearchContent alloc] initWithCustom:dic];
                [arrHot addObject:model];
            }
        }
        [self.arrMain addObjectsFromArray:arrHot];
    }
    [self reloadData];
}

-(void)setViewKeyword:(NSString *)keyword
{
    [self setKeyword:keyword];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_onRowSelected);
    OBJC_RELEASE(_onTagSelected);
    OBJC_RELEASE(_onOffsetChange);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_viewSearchTag);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_keyword);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleSearchContent *model = [self.arrMain objectAtIndex:indexPath.row];
    return [self.tvcItem getHWithModel:model];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZQuestionRelationTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZQuestionRelationTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setCellKeyword:self.keyword];
    ModelCircleSearchContent *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleSearchContent *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onOffsetChange) {
        self.onOffsetChange(scrollView.contentOffset.y);
    }
}

@end
