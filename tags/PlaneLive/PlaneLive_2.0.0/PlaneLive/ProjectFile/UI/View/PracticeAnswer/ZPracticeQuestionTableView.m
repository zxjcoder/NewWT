//
//  ZPracticeQuestionTableView.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeQuestionTableView.h"
#import "ZPracticeDetailHotView.h"
#import "ZPracticeDetailNewView.h"
#import "ZPracticeQuestionItemTVC.h"
#import "ZPracticeDetailAllView.h"

#import "ZBaseTableView.h"

@interface ZPracticeQuestionTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    CGRect _viewHotFrame;
    int _pageSizeHot;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) ZBaseTableView *tvMain;


@property (strong, nonatomic) ZPracticeQuestionItemTVC *tvcItem;

@property (strong, nonatomic) UIView *viewInfo;

@property (strong, nonatomic) ZPracticeDetailHotView *viewHotHeader;
@property (strong, nonatomic) ZPracticeDetailAllView *viewAllFooter;
@property (strong, nonatomic) ZPracticeDetailNewView *viewNewHeader;

@property (strong, nonatomic) ZPracticeDetailHotView *viewHot;
@property (strong, nonatomic) ZPracticeDetailNewView *viewNew;

@property (strong, nonatomic) ModelPractice *modelP;

@property (strong, nonatomic) ModelPracticeQuestion *modelPQAdd;

@property (strong, nonatomic) NSMutableArray *arrHot;
@property (strong, nonatomic) NSMutableArray *arrNew;

@end

@implementation ZPracticeQuestionTableView

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

-(void)innerInit
{
    _pageSizeHot = 5;
    
    self.arrHot = [NSMutableArray array];
    self.arrNew = [NSMutableArray array];
    
    self.tvcItem = [[ZPracticeQuestionItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    
    self.viewHotHeader = [[ZPracticeDetailHotView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailHotView getViewH])];
    self.viewNewHeader = [[ZPracticeDetailNewView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailNewView getViewH])];
    
    ZWEAKSELF
    self.viewAllFooter = [[ZPracticeDetailAllView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailAllView getViewH])];
    [self.viewAllFooter setOnAllClick:^{
        if (weakSelf.onHotAllClick) {
            weakSelf.onHotAllClick();
        }
    }];
    
    _viewHotFrame = CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailHotView getViewH]);
    self.viewHot = [[ZPracticeDetailHotView alloc] initWithFrame:_viewHotFrame];
    
    self.viewNew = [[ZPracticeDetailNewView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailNewView getViewH])];
    [self.viewNew setHidden:YES];
    [self addSubview:self.viewNew];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:self.bounds];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self addSubview:self.tvMain];
    
    [self.tvMain setSectionFooterHeight:0.01];
    [self.tvMain setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)]];
    
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
    [self.tvMain setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onViewBackgroundClick) {
            weakSelf.onViewBackgroundClick(state);
        }
    }];
}

///设置背景状态
-(void)setViewBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvMain setBackgroundViewWithState:backState];
}

-(void)endRefreshHeader
{
    [self.tvMain endRefreshHeader];
}

-(void)endRefreshFooter
{
    [self.tvMain endRefreshFooter];
}
///设置最新问题数据源
-(void)setViewDataWithModel:(ModelPractice *)model
{
    @synchronized (self) {
        
        [self setModelP:model];
        
        [self.tvMain endRefreshHeader];
        
        [self setViewHotHeaderCount];
        
        [self setViewNewHeaderCount];
        
        [self.tvMain reloadData];
    }
}
///设置最新问题数据源
-(void)setViewNewDataWithModel:(ModelPracticeQuestion *)model
{
    if (model) {
        [self setModelPQAdd:model];
        
        [self.arrNew addObject:self.modelPQAdd];
        
        [self.tvMain reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        
        CGRect newFrame = [self.tvMain rectForHeaderInSection:2];
        [self.tvMain setContentOffset:CGPointMake(0, newFrame.origin.y) animated:NO];
    }
}
///设置热门顶部数量
-(void)setViewHotHeaderCount
{
    [self.viewHotHeader setViewDataWithModel:self.modelP];
    
    [self.viewHot setViewDataWithModel:self.modelP];
}
///设置最新顶部数量
-(void)setViewNewHeaderCount
{
    [self.viewNewHeader setViewDataWithModel:self.modelP];
    
    [self.viewNew setViewDataWithModel:self.modelP];
}
///设置热门数据源
-(void)setViewHotDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader pageSizeHot:(int)pageSizeHot questionCount:(NSInteger)questionCount
{
    if (isHeader) {
        [self endRefreshHeader];
    }
    [self.arrHot removeAllObjects];
    
    _pageSizeHot = pageSizeHot;
    
    self.modelP.question_hot = questionCount;
    [self setViewHotHeaderCount];
    
    if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
        [self.arrHot addObjectsFromArray:arrResult];
    }
    if (self.arrHot.count == 0 && self.arrNew.count == 0) {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
    }
    [self.tvMain reloadData];
}
///设置最新数据源
-(void)setViewNewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader questionCount:(NSInteger)questionCount
{
    if (isHeader) {
        [self endRefreshHeader];
    } else {
        [self endRefreshFooter];
    }
    self.modelP.question_new = questionCount;
    [self setViewNewHeaderCount];
    
    if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
        if (isHeader) {
            [self.arrNew removeAllObjects];
        } else {
            [self.tvMain endRefreshFooter];
        }
        ZWEAKSELF
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [self.tvMain addRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self.tvMain removeRefreshFooter];
        }
        [self.arrNew addObjectsFromArray:arrResult];
    } else {
        [self.arrNew removeAllObjects];
    }
    if (self.arrHot.count == 0 && self.arrNew.count == 0) {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNull)];
    } else {
        [self.tvMain setBackgroundViewWithState:(ZBackgroundStateNone)];
    }
    [self.tvMain reloadData];
}

///删除问题回调方法
-(void)setDeleteQuestion:(ModelQuestionBase *)model
{
    BOOL isDel = NO;
    NSInteger row = 0;
    for (ModelPracticeQuestion *modelPQ in self.arrHot) {
        if ([modelPQ.ids isEqualToString:model.ids]) {
            isDel = YES;
            break;
        }
        row++;
    }
    if (isDel) {
        [self.arrHot removeObjectAtIndex:row];
    }
    isDel = NO;
    row = 0;
    for (ModelPracticeQuestion *modelPQ in self.arrNew) {
        if ([modelPQ.ids isEqualToString:model.ids]) {
            isDel = YES;
            break;
        }
        row++;
    }
    if (isDel) {
        [self.arrNew removeObjectAtIndex:row];
    }
    [self.tvMain reloadData];
}

-(void)dealloc
{
    [self.tvMain setDataSource:nil];
    [self.tvMain setDelegate:nil];
    OBJC_RELEASE(_arrHot);
    OBJC_RELEASE(_arrNew);
    
    OBJC_RELEASE(_tvcItem);
    
    OBJC_RELEASE(_viewHot);
    OBJC_RELEASE(_viewNew);
    
    OBJC_RELEASE(_viewAllFooter);
    
    OBJC_RELEASE(_viewHotHeader);
    OBJC_RELEASE(_viewNewHeader);
    
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_modelPQAdd);
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.arrHot.count;
        case 2: return self.arrNew.count;
        default: break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    switch (section) {
        case 0:
        {
            if (self.arrHot.count > 0) {
                height = self.viewHotHeader.height;
            }
            break;
        }
        case 1:
        {
            if (self.arrHot.count > 0 && self.arrHot.count >= _pageSizeHot) {
                height = self.viewAllFooter.height;
            }
            break;
        }
        case 2:
        {
            if (self.arrNew.count > 0) {
                height = self.viewNewHeader.height;
            }
            break;
        }
        default: break;
    }
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (self.arrHot.count > 0) {
                return self.viewHotHeader;
            }
            break;
        }
        case 1:
        {
            if (self.arrHot.count > 0 && self.arrHot.count >= _pageSizeHot) {
                return self.viewAllFooter;
            }
            break;
        }
        case 2:
        {
            if (self.arrNew.count > 0) {
                return self.viewNewHeader;
            }
            break;
        }
        default: break;
    }
    return self.viewInfo;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (self.arrHot.count > 0) {
                ModelPracticeQuestion *model = [self.arrHot objectAtIndex:indexPath.row];
                return [self.tvcItem getHWithModel:model];
            }
            return 0.1;
        }
        case 2:
        {
            if (self.arrNew.count > 0) {
                ModelPracticeQuestion *model = [self.arrNew objectAtIndex:indexPath.row];
                return [self.tvcItem getHWithModel:model];
            }
            break;
        }
        default: break;
    }
    return 0.1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0://热门
        {
            static NSString *cellid = @"tvcHotCellId";
            ZPracticeQuestionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZPracticeQuestionItemTVC alloc] initWithReuseIdentifier:cellid];
            }
            
            [cell setTag:indexPath.row];
            ModelPracticeQuestion *model = [self.arrHot objectAtIndex:indexPath.row];
            [cell setCellDataWithModel:model];
            
            ZWEAKSELF
            [cell setOnAnswerClick:^(ModelAnswerBase *model) {
                if (weakSelf.onAnswerRowClick) {
                    weakSelf.onAnswerRowClick(model);
                }
            }];
            [cell setOnImagePhotoClick:^(ModelUserBase *model) {
                if (weakSelf.onImagePhotoClick) {
                    weakSelf.onImagePhotoClick(model);
                }
            }];
            
            return cell;
        }
        case 2:
        {
            //最新
            static NSString *cellid = @"tvcNewCellId";
            ZPracticeQuestionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZPracticeQuestionItemTVC alloc] initWithReuseIdentifier:cellid];
            }
            
            [cell setTag:indexPath.row];
            ModelPracticeQuestion *model = [self.arrNew objectAtIndex:indexPath.row];
            [cell setCellDataWithModel:model];
            
            ZWEAKSELF
            [cell setOnAnswerClick:^(ModelAnswerBase *model) {
                if (weakSelf.onAnswerRowClick) {
                    weakSelf.onAnswerRowClick(model);
                }
            }];
            [cell setOnImagePhotoClick:^(ModelUserBase *model) {
                if (weakSelf.onImagePhotoClick) {
                    weakSelf.onImagePhotoClick(model);
                }
            }];
            
            return cell;
        }
        default: break;
    }
    static NSString *cellid = @"tvcCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellid];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (self.onQuestionRowClick) {
                ModelPracticeQuestion *model = [self.arrHot objectAtIndex:indexPath.row];
                ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
                [modelQB setIds:model.ids];
                [modelQB setTitle:model.title];
                self.onQuestionRowClick(modelQB);
            }
            break;
        }
        case 2:
        {
            if (self.onQuestionRowClick) {
                ModelPracticeQuestion *model = [self.arrNew objectAtIndex:indexPath.row];
                ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
                [modelQB setIds:model.ids];
                [modelQB setTitle:model.title];
                self.onQuestionRowClick(modelQB);
            }
            break;
        }
        default: break;
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.onOffsetChange) {
        self.onOffsetChange(offsetY);
    }
}

@end
