//
//  ZHomeQuestionTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZHomeQuestionTVC.h"
#import "ZHomeItemNavView.h"
#import "ZHomeQuestionItemTVC.h"
#import "ZBaseTableView.h"

static NSString* kZHomeQuestionTVCCellId = @"kZHomeQuestionTVCCellId";

@interface ZHomeQuestionTVC()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _tvHeight;
}
@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) ZHomeQuestionItemTVC *tvcItem;

@property (strong, nonatomic) UIImageView *imgLine1;

@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZHomeQuestionTVC

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
    
    self.cellH = [ZHomeQuestionTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.tvcItem = [[ZHomeQuestionItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, kZHomeItemNavViewHeight) title:@"精品问答" desc:@"每周推送10条" alignment:NSTextAlignmentRight];
    [self addSubview:self.viewHeader];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.cellW, 0)];
    [self.tvMain setBackgroundColor:WHITECOLOR];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setScrollsToTop:NO];
    [self.tvMain setScrollEnabled:NO];
    [self.tvMain setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.tvMain];
    
    self.imgLine1 = [UIImageView getDLineView];
    [self.imgLine1 setFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.cellW, kLineHeight)];
    [self.viewMain addSubview:self.imgLine1];
    
    ZWEAKSELF
    [self.viewHeader setOnAllClick:^{
        if (weakSelf.onAllQuestionClick) {
            weakSelf.onAllQuestionClick();
        }
    }];
}
-(void)setViewFrame
{
    [self.tvMain setFrame:CGRectMake(0, self.tvMain.y, self.cellW, _tvHeight)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
///设置数据源
-(void)setViewDataWithArray:(NSArray*)array
{
    [self setArrMain:array];
    
    _tvHeight = 0;
    for (ModelQuestionBoutique *model in array) {
        CGFloat rowH = [self.tvcItem setCellDataWithModel:model];
        _tvHeight += rowH;
    }
    self.cellH = _tvHeight+self.viewHeader.height;
    [self setViewFrame];
    if (self.onChangeRowHeight) {
        self.onChangeRowHeight(self.cellH);
    }
    [self.tvMain reloadData];
}
-(void)setViewNil
{
    _tvMain.delegate = nil;
    _tvMain.dataSource = nil;
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_imgLine1);
    
    OBJC_RELEASE(_onQuestionClick);
    OBJC_RELEASE(_onChangeRowHeight);
    OBJC_RELEASE(_onAllQuestionClick);
    
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
    return 45;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelQuestionBoutique *model = [self.arrMain objectAtIndex:indexPath.row];
    return [self.tvcItem setCellDataWithModel:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomeQuestionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:kZHomeQuestionTVCCellId];
    if (!cell) {
        cell = [[ZHomeQuestionItemTVC alloc] initWithReuseIdentifier:kZHomeQuestionTVCCellId];
    }
    ModelQuestionBoutique *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onQuestionClick) {
        ModelQuestionBoutique *model = [self.arrMain objectAtIndex:indexPath.row];
        self.onQuestionClick(model);
    }
}

@end
