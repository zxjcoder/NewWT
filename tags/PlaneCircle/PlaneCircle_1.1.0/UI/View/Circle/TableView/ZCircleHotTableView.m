//
//  ZCircleHotTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleHotTableView.h"
#import "ZCircleHotItemTVC.h"
#import "ZCircleBannerView.h"
#import "ZCircleHotArticleView.h"

@interface ZCircleHotTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *viewHeader;
///广告
@property (strong, nonatomic) ZCircleBannerView *viewBanner;
///新闻
@property (strong, nonatomic) ZCircleHotArticleView *viewHotArticle;
///用于计算高度
@property (strong, nonatomic) ZCircleHotItemTVC *tvcHotItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZCircleHotTableView

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
    
    self.tvcHotItem = [[ZCircleHotItemTVC alloc] initWithReuseIdentifier:@"tvcHotItem"];
    
    self.viewHeader = [[UIView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.viewBanner = [[ZCircleBannerView alloc] init];
    [self.viewBanner setOnBannerClick:^(ModelBanner *model) {
        if (weakSelf.onBannerClick) {
            weakSelf.onBannerClick(model);
        }
    }];
    
    self.viewHotArticle = [[ZCircleHotArticleView alloc] init];
    [self.viewHotArticle setOnHotArticleViewClick:^(ModelHotArticle *model) {
        if (weakSelf.onHotArticleViewClick) {
            weakSelf.onHotArticleViewClick(model);
        }
    }];
    
    [self.viewHeader addSubview:self.viewBanner];
    [self.viewHeader addSubview:self.viewHotArticle];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setTableHeaderView:nil];
    
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    self.width = APP_FRAME_WIDTH;
    if (IsIPadDevice) {
        [self.viewBanner setFrame:CGRectMake(0, 0, self.width, kZBannerViewIPadHeight)];
    } else {
        [self.viewBanner setFrame:CGRectMake(0, 0, self.width, kZBannerViewHeight)];
    }
    [self.viewHotArticle setFrame:CGRectMake(0, self.viewBanner.height, self.width, [ZCircleHotArticleView getViewH])];
    [self.viewHeader setFrame:CGRectMake(0, 0, self.width, self.viewBanner.height+self.viewHotArticle.height)];
    [self setSectionHeaderHeight:self.viewHeader.height];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    @synchronized (self) {
        [super setViewDataWithDictionary:dicResult];
        
        if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
            BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
            NSArray *arrBanner = [dicResult objectForKey:@"resultRmd"];
            if (arrBanner && [arrBanner isKindOfClass:[NSArray class]]) {
                NSMutableArray *arrModelBanner = [NSMutableArray array];
                for (NSDictionary *dic in arrBanner) {
                    ModelBanner *model = [[ModelBanner alloc] initWithCustom:dic];
                    [arrModelBanner addObject:model];
                }
                [self.viewBanner setViewDataWithArray:arrModelBanner];
            }
            NSDictionary *dicHot = [dicResult objectForKey:@"resultNewsInfo"];
            if (dicHot) {
                ModelHotArticle *modelHot = [[ModelHotArticle alloc] initWithCustom:dicHot];
                [self.viewHotArticle setViewDataWithModel:modelHot];
            }
            NSArray *arrList = [dicResult objectForKey:kResultKey];
            
            NSMutableArray *arrHot = [NSMutableArray array];
            for (NSDictionary *dic in arrList) {
                ModelCircleHot *model = [[ModelCircleHot alloc] initWithCustom:dic];
                [arrHot addObject:model];
            }
            __weak typeof(self) weakSelf = self;
            if (isHeader) {
                [self.arrMain removeAllObjects];
                if (arrBanner.count > 0 || dicHot != nil) {
                    if (!self.tableHeaderView) {
                        [self setTableHeaderView:self.viewHeader];
                    }
                    [self setViewFrame];
                    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
                } else {
                    [self setTableHeaderView:nil];
                    [self setSectionHeaderHeight:0];
                }
                if (arrBanner.count == 0 && dicHot == nil && arrList.count == 0) {
                    [self setBackgroundViewWithState:(ZBackgroundStateNull)];
                } else {
                    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
                }
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
        }
        [self reloadData];
    }
}

-(void)setFontSizeChange
{
    [self reloadData];
}

-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_viewBanner);
    OBJC_RELEASE(_viewHotArticle);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_tvcHotItem);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleHot *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcHotItem getHWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZCircleHotItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCircleHotItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelCircleHot *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    [cell setOnAnswerClick:^(ModelCircleHot *model) {
        if (weakSelf.onAnswerClick) {
            weakSelf.onAnswerClick(model);
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleHot *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
}

@end
