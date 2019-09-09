//
//  ZHomeCurriculumTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZHomeCurriculumTVC.h"
#import "ZHomeItemNavView.h"
#import "ZHomeSubscribeItemTVC.h"
#import "ZBaseTableView.h"

static NSString* kZHomeCurriculumTVCCellId = @"kZHomeCurriculumTVCCellId";

@interface ZHomeCurriculumTVC()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) UIImageView *imgLine1;
@property (strong, nonatomic) UIImageView *imgLine2;

@property (strong, nonatomic) NSArray *mainArray;

@end

@implementation ZHomeCurriculumTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZHomeCurriculumTVC getH];
    
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR2];
    
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, kZHomeItemNavViewHeight) title:kWonderfulSeries desc:kWhatIsSeriesOfLessons alignment:NSTextAlignmentLeft];
    [self.viewHeader setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewHeader];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.cellW, [ZHomeSubscribeItemTVC getH])];
    [self.tvMain setBackgroundColor:WHITECOLOR];
    [self.tvMain setRowHeight:[ZHomeSubscribeItemTVC getH]];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setScrollsToTop:NO];
    [self.tvMain setScrollEnabled:NO];
    [self.tvMain setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.tvMain];
    
    self.imgLine1 = [UIImageView getDLineView];
    [self.imgLine1 setFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.cellW, kLineHeight)];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-6, self.cellW, 6)];
    [self.viewMain addSubview:self.imgLine2];
    
    ZWEAKSELF
    [self.viewHeader setOnAllClick:^{
        if (weakSelf.onAllCurriculumClick) {
            weakSelf.onAllCurriculumClick();
        }
    }];
    [self.viewHeader setOnDescClick:^{
        if (weakSelf.onDescClick) {
            weakSelf.onDescClick();
        }
    }];
}
///设置数据源
-(void)setViewDataWithArray:(NSArray*)array
{
    [self setMainArray:array];
    
    [self.tvMain reloadData];
}
-(void)setViewNil
{
    _tvMain.delegate = nil;
    _tvMain.dataSource = nil;
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_viewHeader);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return 178;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomeSubscribeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:kZHomeCurriculumTVCCellId];
    if (!cell) {
        cell = [[ZHomeSubscribeItemTVC alloc] initWithReuseIdentifier:kZHomeCurriculumTVCCellId];
    }
    ModelSubscribe *modelS = [self.mainArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:modelS];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onCurriculumClick) {
        ModelSubscribe *modelS = [self.mainArray objectAtIndex:indexPath.row];
        self.onCurriculumClick(modelS);
    }
}

@end
