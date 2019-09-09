//
//  ZPracticeQuestionTableView.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeQuestionTableView.h"
#import "ZPracticeQuestionInfoTVC.h"
#import "ZPracticeDetailButtonView.h"
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

@property (strong, nonatomic) ZPracticeQuestionInfoTVC *tvcInfo;
@property (strong, nonatomic) ZPracticeDetailButtonView *viewInfoFooter;

@property (strong, nonatomic) ZPracticeQuestionItemTVC *tvcItem;

@property (strong, nonatomic) UIView *viewInfo;
@property (strong, nonatomic) UIView *viewHotFooter;
@property (strong, nonatomic) UIView *viewNewFooter;

@property (strong, nonatomic) ZPracticeDetailHotView *viewHotHeader;
@property (strong, nonatomic) ZPracticeDetailAllView *viewAllFooter;
@property (strong, nonatomic) ZPracticeDetailNewView *viewNewHeader;

@property (strong, nonatomic) ZPracticeDetailButtonView *viewButton;
@property (strong, nonatomic) ZPracticeDetailHotView *viewHot;
@property (strong, nonatomic) ZPracticeDetailNewView *viewNew;

@property (strong, nonatomic) ModelPractice *modelP;

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
    
    self.tvcInfo = [[ZPracticeQuestionInfoTVC alloc] initWithReuseIdentifier:@"tvcInfo"];
    
    self.viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewHotFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    self.viewNewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.1)];
    
    __weak typeof(self) weakSelf = self;
    self.viewInfoFooter = [[ZPracticeDetailButtonView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailButtonView getViewLineH])];
    [self.viewInfoFooter setOnTextClick:^{
        if (weakSelf.onTextClick) {
            weakSelf.onTextClick();
        }
    }];
    [self.viewInfoFooter setOnPPTClick:^{
        if (weakSelf.onPPTClick) {
            weakSelf.onPPTClick();
        }
    }];
    [self.viewInfoFooter setOnPraiseClick:^{
        if (weakSelf.onPraiseClick) {
            weakSelf.onPraiseClick();
        }
    }];
    [self.viewInfoFooter setOnCollectionClick:^{
        if (weakSelf.onCollectionClick) {
            weakSelf.onCollectionClick();
        }
    }];
    
    self.viewButton = [[ZPracticeDetailButtonView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailButtonView getViewH])];
    [self.viewButton setIsShowLine:NO];
    [self.viewButton setHidden:YES];
    [self.viewButton setOnTextClick:^{
        if (weakSelf.onTextClick) {
            weakSelf.onTextClick();
        }
    }];
    [self.viewButton setOnPPTClick:^{
        if (weakSelf.onPPTClick) {
            weakSelf.onPPTClick();
        }
    }];
    [self.viewButton setOnPraiseClick:^{
        if (weakSelf.onPraiseClick) {
            weakSelf.onPraiseClick();
        }
    }];
    [self.viewButton setOnCollectionClick:^{
        if (weakSelf.onCollectionClick) {
            weakSelf.onCollectionClick();
        }
    }];
    [self addSubview:self.viewButton];
    
    self.viewHotHeader = [[ZPracticeDetailHotView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailHotView getViewH])];
    self.viewNewHeader = [[ZPracticeDetailNewView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailNewView getViewH])];
    
    self.viewAllFooter = [[ZPracticeDetailAllView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZPracticeDetailAllView getViewH])];
    [self.viewAllFooter setOnAllClick:^{
        if (weakSelf.onHotAllClick) {
            weakSelf.onHotAllClick();
        }
    }];
    
    _viewHotFrame = CGRectMake(0, self.viewButton.height, APP_FRAME_WIDTH, [ZPracticeDetailHotView getViewH]);
    self.viewHot = [[ZPracticeDetailHotView alloc] initWithFrame:_viewHotFrame];
    [self.viewHot setHidden:YES];
    [self addSubview:self.viewHot];
    
    self.viewNew = [[ZPracticeDetailNewView alloc] initWithFrame:CGRectMake(0, self.viewButton.height, APP_FRAME_WIDTH, [ZPracticeDetailNewView getViewH])];
    [self.viewNew setHidden:YES];
    [self addSubview:self.viewNew];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:self.bounds style:(UITableViewStyleGrouped)];
    [self.tvMain innerInit];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self addSubview:self.tvMain];
    
    [self sendSubviewToBack:self.tvMain];
    [self bringSubviewToFront:self.viewButton];
    
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)endRefreshHeader
{
    [self.tvMain endRefreshHeader];
}

-(void)endRefreshFooter
{
    [self.tvMain endRefreshFooter];
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    @synchronized (self) {
        
        [self setModelP:model];
        
        [self.tvMain endRefreshHeader];
        
        [self.tvcInfo setCellDataWithModel:model];
        
        [self.viewInfoFooter setViewDataWithModel:model];
        
        [self.viewButton setViewDataWithModel:model];
        
        [self setViewHotHeaderCount];
        
        [self setViewNewHeaderCount];
        
        [self.tvMain reloadData];
    }
}
///设置最新问题数据源
-(void)setViewNewDataWithModel:(ModelPracticeQuestion *)model
{
    @synchronized (self) {
        [self.arrNew addObject:model];
        
        [self.tvMain reloadData];
        
        [self.tvMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
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
    @synchronized (self) {
        
        [self.arrHot removeAllObjects];
        
        _pageSizeHot = pageSizeHot;
        
        self.modelP.question_hot = questionCount;
        [self setViewHotHeaderCount];
        
        if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
            [self.arrHot addObjectsFromArray:arrResult];
        }
        
        [self.tvMain reloadData];
    }
}
///设置最新数据源
-(void)setViewNewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader questionCount:(NSInteger)questionCount
{
    @synchronized (self) {
        
        self.modelP.question_new = questionCount;
        [self setViewNewHeaderCount];
        
        if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
            
            if (isHeader) {
                [self.arrNew removeAllObjects];
            } else {
                [self.tvMain endRefreshFooter];
            }
            __weak typeof(self) weakSelf = self;
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
            [self.tvMain endRefreshFooter];
            
            [self.arrNew removeAllObjects];
        }
        [self.tvMain reloadData];
    }
}

-(void)dealloc
{
    [self.tvMain setDataSource:nil];
    [self.tvMain setDelegate:nil];
    OBJC_RELEASE(_arrHot);
    OBJC_RELEASE(_arrNew);
    
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_tvcInfo);
    
    OBJC_RELEASE(_viewHot);
    OBJC_RELEASE(_viewNew);
    OBJC_RELEASE(_viewButton);
    
    OBJC_RELEASE(_viewAllFooter);
    OBJC_RELEASE(_viewNewFooter);
    OBJC_RELEASE(_viewHotFooter);
    
    OBJC_RELEASE(_viewHotHeader);
    OBJC_RELEASE(_viewNewHeader);
    
    OBJC_RELEASE(_tvMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.arrHot.count;
        case 2: return self.arrNew.count;
        default: break;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    switch (section) {
        case 1:
        {
            if (self.arrHot.count > 0) {
                height = self.viewHotHeader.height;
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
        case 1:
        {
            if (self.arrHot.count > 0) {
                return self.viewHotHeader;
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.viewInfoFooter.height;
        case 1:
        {
            if (self.arrHot.count >= _pageSizeHot) {
                return self.viewAllFooter.height;
            } else {
                return 0.1;
            }
        }
        default: break;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.viewInfoFooter;
        case 1:
        {
            if (self.arrHot.count >= _pageSizeHot) {
                return self.viewAllFooter;
            } else {
                return self.viewHotFooter;
            }
        }
        default: break;
    }
    return self.viewNewFooter;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            if (self.arrHot.count > 0) {
                ModelPracticeQuestion *model = [self.arrHot objectAtIndex:indexPath.row];
                [self.tvcItem setCellDataWithModel:model];
                return [self.tvcItem getHWithModel:model];
            }
            return 0.1;
        }
        case 2:
        {
            if (self.arrNew.count > 0) {
                ModelPracticeQuestion *model = [self.arrNew objectAtIndex:indexPath.row];
                [self.tvcItem setCellDataWithModel:model];
                return [self.tvcItem getHWithModel:model];
            }
            return 0.1;
        }
        default: break;
    }
    return [self.tvcInfo getH];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            static NSString *cellid = @"tvcHotCellId";
            ZPracticeQuestionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZPracticeQuestionItemTVC alloc] initWithReuseIdentifier:cellid];
            }
            
            [cell setTag:indexPath.row];
            ModelPracticeQuestion *model = [self.arrHot objectAtIndex:indexPath.row];
            [cell setCellDataWithModel:model];
            
            __weak typeof(self) weakSelf = self;
            [cell setOnAnswerClick:^(ModelPracticeQuestion *model) {
                if (weakSelf.onAnswerRowClick) {
                    weakSelf.onAnswerRowClick(model);
                }
            }];
            
            return cell;
        }
        case 2:
        {
            static NSString *cellid = @"tvcNewCellId";
            ZPracticeQuestionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZPracticeQuestionItemTVC alloc] initWithReuseIdentifier:cellid];
            }
            
            [cell setTag:indexPath.row];
            ModelPracticeQuestion *model = [self.arrNew objectAtIndex:indexPath.row];
            [cell setCellDataWithModel:model];
            
            __weak typeof(self) weakSelf = self;
            [cell setOnAnswerClick:^(ModelPracticeQuestion *model) {
                if (weakSelf.onAnswerRowClick) {
                    weakSelf.onAnswerRowClick(model);
                }
            }];
            
            return cell;
        }
        default: break;
    }
    return self.tvcInfo;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            ModelPracticeQuestion *model = [self.arrHot objectAtIndex:indexPath.row];
            if (self.onQuestionRowClick) {
                self.onQuestionRowClick(model);
            }
            break;
        }
        case 2:
        {
            ModelPracticeQuestion *model = [self.arrNew objectAtIndex:indexPath.row];
            if (self.onQuestionRowClick) {
                self.onQuestionRowClick(model);
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
    ///已经到达热门分区
    if (offsetY > self.tvcInfo.height && (self.arrHot.count > 0 || self.arrNew.count > 0)) {
        CGRect hotFrame = [self.tvMain rectForHeaderInSection:1];
        CGRect newFrame = [self.tvMain rectForHeaderInSection:2];
        CGFloat hotY = hotFrame.origin.y-self.viewButton.height;
        ///最新有数据的时候
        if (self.arrNew.count > 0) {
            CGFloat newB = (newFrame.origin.y-self.viewButton.height);
            ///热门有数据的时候
            if (self.arrHot.count > 0) {
                ///偏移量在热门区域
                if (offsetY < newB && offsetY > hotY) {
                    [self.viewHot setHidden:NO];
                    [self.viewNew setHidden:YES];
                }
                ///偏移量在刚到最新区域
                else if (offsetY < hotY) {
                    [self.viewHot setHidden:YES];
                    [self.viewNew setHidden:YES];
                }
                ///偏移量在最新区域
                else {
                    [self.viewHot setHidden:YES];
                    [self.viewNew setHidden:NO];
                }
            } else {
                [self.viewHot setHidden:YES];
                if (offsetY > newB) {
                    [self.viewNew setHidden:NO];
                } else {
                    [self.viewNew setHidden:YES];
                }
            }
        } else {
            ///热门有数据最新无数据
            if (self.arrHot.count > 0) {
                if (offsetY > hotY) {
                    [self.viewHot setHidden:NO];
                    [self.viewNew setHidden:YES];
                } else {
                    [self.viewNew setHidden:YES];
                    [self.viewHot setHidden:YES];
                }
            } else {
                [self.viewNew setHidden:YES];
                [self.viewHot setHidden:YES];
            }
        }
        [self.viewButton setHidden:NO];
    } else {
        [self.viewNew setHidden:YES];
        [self.viewHot setHidden:YES];
        [self.viewButton setHidden:YES];
    }
    if (self.onOffsetChange) {
        self.onOffsetChange(offsetY);
    }
}

@end
