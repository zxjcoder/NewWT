//
//  ZCircleSearchContentTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchContentTableView.h"
#import "ZCircleSearchTagView.h"
#import "ZCircleSearchContentTVC.h"

@interface ZCircleSearchContentTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ZCircleSearchTagView *viewSearchTag;

@property (strong, nonatomic) ZCircleSearchContentTVC *tvcSearchContent;

@property (strong, nonatomic) NSString *keyword;

@end

@implementation ZCircleSearchContentTableView

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
    
    self.tvcSearchContent = [[ZCircleSearchContentTVC alloc] initWithReuseIdentifier:@"tvcSearchContent"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setTableHeaderView:nil];
    
    __weak typeof(self) weakSelf = self;
    self.viewSearchTag = [[ZCircleSearchTagView alloc] init];
    [self.viewSearchTag setOnSearchTagClick:^(ModelTag *model) {
        if (weakSelf.onTagSelected) {
            weakSelf.onTagSelected(model);
        }
    }];
}

-(void)setViewFrame
{
    self.width = APP_FRAME_WIDTH;
    [self.viewSearchTag setFrame:CGRectMake(0, 0, self.width, [ZCircleSearchTagView getViewH])];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewKeyword:(NSString *)keyword
{
    [self setKeyword:keyword];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [super setViewDataWithDictionary:dicResult];
    
    NSDictionary *dicTag = [dicResult objectForKey:kTagKey];
    if ([dicTag isKindOfClass:[NSDictionary class]]) {
        ModelTag *modelTag = [[ModelTag alloc] initWithCustom:dicTag];
        [self.viewSearchTag setViewDataWithModel:modelTag];
        [self setTableHeaderView:self.viewSearchTag];
        [self setSectionHeaderHeight:self.viewSearchTag.height];
    } else {
        [self setTableHeaderView:nil];
        [self setSectionHeaderHeight:0];
    }
    NSArray *arrList = [dicResult objectForKey:kQuestionKey];
    NSMutableArray *arrR = [NSMutableArray array];
    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in arrList) {
            ModelCircleSearchContent *model = [[ModelCircleSearchContent alloc] initWithCustom:dic];
            [model setType:0];
            [arrR addObject:model];
            NSArray *answers = [dic objectForKey:kAnswerKey];
            for (NSDictionary *dicAnswer in answers) {
                ModelCircleSearchContent *modelAnswer = [[ModelCircleSearchContent alloc] initWithCustom:dicAnswer];
                [modelAnswer setType:1];
                [arrR addObject:modelAnswer];
            }
        }
    }
    BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
    if (isHeader) { [self.arrMain removeAllObjects]; }
    __weak typeof(self) weakSelf = self;
    if (arrR.count >= kPAGE_MAXCOUNT) {
        [self addRefreshFooterWithEndBlock:^{
            if (weakSelf.onRefreshFooter) {
                weakSelf.onRefreshFooter();
            }
        }];
    } else {
        [self removeRefreshFooter];
    }
    [self.arrMain addObjectsFromArray:arrR];
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_tvcSearchContent);
    OBJC_RELEASE(_keyword);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_viewSearchTag);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleSearchContent *model = [self.arrMain objectAtIndex:indexPath.row];
    return [self.tvcSearchContent getHWithModel:model];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZCircleSearchContentTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCircleSearchContentTVC alloc] initWithReuseIdentifier:cellid];
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
