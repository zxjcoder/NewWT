//
//  ZQuestionRelationTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionRelationTableView.h"
#import "ZQuestionRelationTVC.h"
#import "ZQuestionRlationTagView.h"

@interface ZQuestionRelationTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ZQuestionRlationTagView *viewTag;

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
    
    self.tvcItem = [[ZQuestionRelationTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    __weak typeof(self) weakSelf = self;
    self.viewTag = [[ZQuestionRlationTagView alloc] init];
    [self.viewTag setOnSearchTagClick:^(ModelTag *model) {
        if (weakSelf.onTagSelected) {
            weakSelf.onTagSelected(model);
        }
    }];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    self.width = APP_FRAME_WIDTH;
    [self.viewTag setFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZQuestionRlationTagView getViewH])];
    [self.viewLine setFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, kLineHeight)];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [self.arrMain removeAllObjects];
    
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        [super setViewDataWithDictionary:dicResult];
        NSDictionary *dicTag = [dicResult objectForKey:@"resultArticle"];
        if (dicTag && [dicTag isKindOfClass:[NSDictionary class]]) {
            ModelTag *modelTag = [[ModelTag alloc] initWithCustom:dicTag];
            [self.viewTag setViewDataWithModel:modelTag];
            [self setTableHeaderView:self.viewTag];
            [self setSectionHeaderHeight:self.viewTag.height];
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
    if (self.arrMain.count > 0) {
        [self setHidden:NO];
    } else {
        [self setHidden:YES];
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
    OBJC_RELEASE(_viewTag);
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
    if (self.onRowSelected) {
        ModelCircleSearchContent *model = [self.arrMain objectAtIndex:indexPath.row];
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.ids];
        [modelQB setTitle:model.title];
        self.onRowSelected(modelQB);
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
