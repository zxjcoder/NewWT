//
//  ZHomeSubscribeView.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeSubscribeView.h"
#import "ZHomeItemNavView.h"
#import "ZHomeSubscribeTVC.h"
#import "ZBaseTableView.h"

static NSString* kZHomeSubscribeTVCId = @"kZHomeSubscribeTVCId";

@interface ZHomeSubscribeView()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _height;
}

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *mainArray;

@end

@implementation ZHomeSubscribeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    _height = self.height;
    
    [self setBackgroundColor:WHITECOLOR];
    
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.width, kZHomeItemNavViewHeight) title:kSubscribe];
    [self.viewHeader setAllButtonHidden];
    [self addSubview:self.viewHeader];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.width, 0)];
    [self.tvMain setBackgroundColor:WHITECOLOR];
    [self.tvMain setRowHeight:[ZHomeSubscribeTVC getH]];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setUserInteractionEnabled:YES];
    [self addSubview:self.tvMain];
}

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array
{
    [self setMainArray:array];
    
    CGRect tvFrame = self.tvMain.frame;
    tvFrame.size.height = array.count*self.tvMain.rowHeight;
    [self.tvMain setFrame:tvFrame];
    
    [self.tvMain reloadData];
    
    _height = self.tvMain.y+self.tvMain.height+20;
    CGRect viewFrame = self.frame;
    viewFrame.size.height = _height;
    [self setFrame:viewFrame];
}

///获取高度
-(CGFloat)getViewHeight
{
    return _height;
}

-(void)dealloc
{
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_mainArray);
    _tvMain.delegate = nil;
    _tvMain.dataSource = nil;
    OBJC_RELEASE(_tvMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomeSubscribeTVC *cell = [tableView dequeueReusableCellWithIdentifier:kZHomeSubscribeTVCId];
    if (!cell) {
        cell = [[ZHomeSubscribeTVC alloc] initWithReuseIdentifier:kZHomeSubscribeTVCId];
    }
    ModelSubscribe *modelS = [self.mainArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:modelS];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onSubscribeClick) {
        ModelSubscribe *modelS = [self.mainArray objectAtIndex:indexPath.row];
        self.onSubscribeClick(modelS);
    }
}

@end
