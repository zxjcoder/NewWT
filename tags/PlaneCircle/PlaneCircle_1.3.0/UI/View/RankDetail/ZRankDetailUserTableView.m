//
//  ZRankDetailUserTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailUserTableView.h"
#import "ZRankDetailItemTVC.h"
#import "ZRankDetailHeaderView.h"

@interface ZRankDetailUserTableView()<UITableViewDelegate,UITableViewDataSource>

///顶部详情区域
@property (strong, nonatomic) ZRankDetailHeaderView *viewInfo;
///计算高度
@property (strong, nonatomic) ZRankDetailItemTVC *tvcItem;
///业绩清单区域
@property (strong, nonatomic) UIView *viewHeader;
///公司名称
@property (strong, nonatomic) UIButton *btnCompany;
///名称分割线
@property (strong, nonatomic) UIView *viewLine;
///业绩清单标题
@property (strong, nonatomic) UIView *viewTitle;
///公司编码
@property (strong, nonatomic) UILabel *lbNumber;
///公司代码
@property (strong, nonatomic) UILabel *lbCode;
///公司名称
@property (strong, nonatomic) UILabel *lbName;

@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZRankDetailUserTableView

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
    
    self.tvcItem = [[ZRankDetailItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.viewHeader = [[UIView alloc] init];
    [self.viewHeader setBackgroundColor:WHITECOLOR];
    
    __weak typeof(self) weakSelf = self;
    self.viewInfo = [[ZRankDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, self.viewInfo.getH)];
    [self.viewInfo setOnUpdRankUserClick:^(ModelRankUser *model) {
        if (weakSelf.onUpdRankUserClick) {
            weakSelf.onUpdRankUserClick(model);
        }
    }];
    [self.viewHeader addSubview:self.viewInfo];
    
    self.btnCompany = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCompany setTitle:@"业绩清单" forState:(UIControlStateNormal)];
    [self.btnCompany setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnCompany setTag:1];
    [[self.btnCompany titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewHeader addSubview:self.btnCompany];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:MAINCOLOR];
    [self.viewHeader addSubview:self.viewLine];
    
    self.viewTitle = [[UIView alloc] init];
    [self.viewTitle setBackgroundColor:RGBCOLOR(255, 240, 228)];
    [self.viewHeader addSubview:self.viewTitle];
    
    self.lbNumber = [[UILabel alloc] init];
    [self.lbNumber setTextColor:BLACKCOLOR1];
    [self.lbNumber setText:@"序号"];
    [self.lbNumber setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbNumber setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle addSubview:self.lbNumber];
    
    self.lbCode = [[UILabel alloc] init];
    [self.lbCode setTextColor:BLACKCOLOR1];
    [self.lbCode setText:@"公司代码"];
    [self.lbCode setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCode setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle addSubview:self.lbCode];
    
    self.lbName = [[UILabel alloc] init];
    [self.lbName setTextColor:BLACKCOLOR1];
    [self.lbName setText:@"公司名称"];
    [self.lbName setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbName setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle addSubview:self.lbName];
    
    [self setViewFrame];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setTableHeaderView:self.viewHeader];
    [self setSectionHeaderHeight:self.viewHeader.height];
}

-(void)setViewFrame
{
    CGFloat viewW = APP_FRAME_WIDTH;
    
    [self.viewHeader setFrame:CGRectMake(0, 0, viewW, 62+self.viewInfo.getH)];
    
    [self.btnCompany setFrame:CGRectMake(0, self.viewInfo.getH, viewW, 30)];
    
    [self.viewLine setFrame:CGRectMake(0, self.btnCompany.y+self.btnCompany.height, viewW, 2)];
    
    [self.viewTitle setFrame:CGRectMake(0, self.viewLine.y+self.viewLine.height, viewW, 30)];
    
    [self.lbNumber setFrame:CGRectMake(0, 5, 50, 25)];
    [self.lbCode setFrame:CGRectMake(self.lbNumber.x+self.lbNumber.width, 5, 110, 25)];
    [self.lbName setFrame:CGRectMake(self.lbCode.x+self.lbCode.width, 5, viewW-self.lbNumber.width-self.lbCode.width, 25)];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    @synchronized (self) {
        NSArray *arrList = [dicResult objectForKey:@"resultAvm"];
        NSMutableArray *arrR = [NSMutableArray array];
        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrList) {
                ModelRankCompany *model = [[ModelRankCompany alloc] initWithCustom:dic];
                [arrR addObject:model];
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
}

-(void)setViewDataWithModel:(ModelRankUser *)model
{
    @synchronized (self) {
        [self.viewInfo setViewDataWithModel:model];
        
        [self.viewHeader setFrame:CGRectMake(0, 0, self.viewHeader.width, 62+self.viewInfo.getH)];
        
        [self setTableHeaderView:self.viewHeader];
        [self setSectionHeaderHeight:self.viewHeader.height];
        
        [self reloadData];
    }
}

-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_btnCompany);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewTitle);
    OBJC_RELEASE(_viewInfo);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelRankCompany *model = [self.arrMain objectAtIndex:indexPath.row];
    return [self.tvcItem getHWithModel:model];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZRankDetailItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZRankDetailItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row+1];
    ModelRankCompany *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

@end
