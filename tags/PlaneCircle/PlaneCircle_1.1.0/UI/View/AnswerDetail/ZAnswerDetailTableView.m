//
//  ZAnswerDetailTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailTableView.h"
#import "ZCommentTVC.h"
#import "ZAnswerDetailCommentView.h"
#import "ZAnswerDetailContentTVC.h"
#import "ZAnswerDetailUserTVC.h"

@interface ZAnswerDetailTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) ZAnswerDetailUserTVC *tvcUser;
@property (strong, nonatomic) ZAnswerDetailContentTVC *tvcContent;
///评论顶部
@property (strong, nonatomic) ZAnswerDetailCommentView *viewCommentHeader;
///用于计算高度
@property (strong, nonatomic) ZCommentTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) NSMutableDictionary *dicDefaultH;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@end

@implementation ZAnswerDetailTableView

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
    self.dicDefaultH = [NSMutableDictionary dictionary];
    
    self.tvcItem = [[ZCommentTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    __weak typeof(self) weakSelf = self;
    self.tvcUser = [[ZAnswerDetailUserTVC alloc] initWithReuseIdentifier:@"tvcUser"];
    [self.tvcUser setOnAgreeClick:^(ModelAnswerBase *model) {
        if (weakSelf.onAgreeClick) {
            weakSelf.onAgreeClick(model);
        }
    }];
    [self.tvcUser setOnImagePhotoClick:^(ModelAnswerBase *model) {
        if (weakSelf.onImagePhotoClick) {
            weakSelf.onImagePhotoClick(model);
        }
    }];
    self.tvcContent = [[ZAnswerDetailContentTVC alloc] initWithReuseIdentifier:@"tvcContent"];
    [self.tvcContent setOnImageClick:^(UIImage *image, NSURL *imgUrl, CGSize size) {
        if (weakSelf.onImageClick) {
            weakSelf.onImageClick(image, imgUrl, size);
        }
    }];
    self.viewCommentHeader = [[ZAnswerDetailCommentView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 45)];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    [self.tvcContent setOnRefreshTVC:^{
        dispatch_async(dispatch_get_main_queue(), ^ {
            [weakSelf reloadData];
        });
    }];
}

-(void)setViewDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    [self.tvcUser setCellDataWithModel:model];
    [self.tvcContent setCellDataWithModel:model];
    [self.viewCommentHeader setViewDataWithModel:model];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
    NSArray *arrList = [dicResult objectForKey:kResultKey];
    NSMutableArray *arrHot = [NSMutableArray array];
    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in arrList) {
            ModelComment *model = [[ModelComment alloc] initWithCustom:dic];
            [arrHot addObject:model];
        }
    }
    __weak typeof(self) weakSelf = self;
    if (isHeader) {
        [self.dicDefaultH removeAllObjects];
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

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_modelAB);
    OBJC_RELEASE(_dicDefaultH);
    OBJC_RELEASE(_viewCommentHeader);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_tvcUser);
    OBJC_RELEASE(_tvcContent);
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return self.viewCommentHeader.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return self.viewCommentHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1: return self.tvcContent.getH;
            default: return self.tvcUser.getH;
        }
    }
    ModelComment *model = [self.arrMain objectAtIndex:indexPath.row];
    BOOL isMaxH = [[self.dicDefaultH objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]] boolValue];
    [self.tvcItem setCellIsDefaultH:!isMaxH];
    CGFloat rowH = [self.tvcItem getHWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1: return self.tvcContent;
            default: return self.tvcUser;
        }
    }
    static NSString *cellid = @"tvcellid";
    ZCommentTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCommentTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    ModelComment *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    __weak typeof(self) weakSelf = self;
    [cell setOnImagePhotoClick:^(ModelComment *model) {
        if (weakSelf.onCommentPhotoClick) {
            weakSelf.onCommentPhotoClick(model);
        }
    }];
    [cell setOnRowHeightChange:^(NSInteger tag, BOOL isDefaultH) {
        [weakSelf.dicDefaultH setObject:[NSString stringWithFormat:@"%d",!isDefaultH] forKey:[NSString stringWithFormat:@"%d",(int)tag]];
        GCDMainBlock(^{
            [weakSelf reloadData];
        })
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.onCommentRowClick) {
            ModelComment *model = [self.arrMain objectAtIndex:indexPath.row];
            self.onCommentRowClick(model);
        }
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
