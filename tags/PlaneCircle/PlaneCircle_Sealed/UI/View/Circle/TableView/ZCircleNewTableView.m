//
//  ZCircleNewTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleNewTableView.h"
#import "ZCircleNewItemTVC.h"

@interface ZCircleNewTableView()<UITableViewDelegate,UITableViewDataSource>

///用于计算高度
@property (strong, nonatomic) ZCircleNewItemTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZCircleNewTableView

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
    
    self.tvcItem = [[ZCircleNewItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
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
    @synchronized (self) {
        [super setViewDataWithDictionary:dicResult];
        
        if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
            BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
            NSArray *arrList = [dicResult objectForKey:kResultKey];
            NSMutableArray *arrResult = [NSMutableArray array];
            if (arrList && [arrList isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in arrList) {
                    ModelCircleNew *model = [[ModelCircleNew alloc] initWithCustom:dic];
                    [arrResult addObject:model];
                }
            }
            __weak typeof(self) weakSelf = self;
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
        }
        [self reloadData];
    }
}
///添加一条最新的问题
-(void)addViewModelWithNewQuestion:(ModelQuestion *)modelQ
{
    ModelCircleNew *modelCN = [[ModelCircleNew alloc] init];
    [modelCN setIds:modelQ.ids];
    [modelCN setTitle:modelQ.title];
    [modelCN setTime:kJust];
    [modelCN setCount:@"0"];
    
    ModelUser *modelU = [AppSetting getUserLogin];
    [modelCN setUserIdQ:modelU.userId];
    [modelCN setNicknameQ:modelU.nickname];
    [modelCN setHead_imgQ:modelU.head_img];
    
    [self.arrMain insertObject:modelCN atIndex:0];
    
    [self reloadData];
}

-(void)setFontSizeChange
{
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_onImagePhotoClick);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_onRowSelected);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleNew *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcItem getHWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZCircleNewItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCircleNewItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelCircleNew *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    [cell setOnImagePhotoClick:^(ModelCircleNew *model) {
        if (weakSelf.onImagePhotoClick) {
            weakSelf.onImagePhotoClick(model);
        }
    }];
    [cell setOnAnswerClick:^(ModelCircleNew *model) {
        if (weakSelf.onAnswerClick) {
            weakSelf.onAnswerClick(model);
        }
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleNew *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
}

@end
