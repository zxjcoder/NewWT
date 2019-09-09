//
//  ZRankDetailAchievementTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailAchievementTableView.h"
#import "ZRankDetailItemTVC.h"

@interface ZRankDetailAchievementTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZRankDetailItemTVC *tvcItem;

@property (strong, nonatomic) UIView *viewHeader;

@property (strong, nonatomic) UIButton *btnCompany;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) UIView *viewTitle;

@property (strong, nonatomic) UILabel *lbNumber;

@property (strong, nonatomic) UILabel *lbCode;

@property (strong, nonatomic) UILabel *lbName;

@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZRankDetailAchievementTableView

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
    
    self.tvcItem = [[ZRankDetailItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.viewHeader = [[UIView alloc] init];
    [self.viewHeader setBackgroundColor:WHITECOLOR];
    
    self.btnCompany = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCompany setTitle:@"新三板" forState:(UIControlStateNormal)];
    [self.btnCompany setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [self.btnCompany setTag:1];
    [[self.btnCompany titleLabel] setFont:[UIFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.viewHeader addSubview:self.btnCompany];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:MAINCOLOR];
    [self.viewHeader addSubview:self.viewLine];
    
    self.viewTitle = [[UIView alloc] init];
    [self.viewTitle setBackgroundColor:RGBCOLOR(255, 240, 228)];
    [self.viewHeader addSubview:self.viewTitle];
    
    self.lbNumber = [[UILabel alloc] init];
    [self.lbNumber setTextColor:BLACKCOLOR1];
    [self.lbNumber setText:@"排名"];
    [self.lbNumber setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbNumber setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle addSubview:self.lbNumber];
    
    self.lbCode = [[UILabel alloc] init];
    [self.lbCode setTextColor:BLACKCOLOR1];
    [self.lbCode setText:@"挂牌数量"];
    [self.lbCode setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCode setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle addSubview:self.lbCode];
    
    self.lbName = [[UILabel alloc] init];
    [self.lbName setTextColor:BLACKCOLOR1];
    [self.lbName setText:@"律师事务所"];
    [self.lbName setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbName setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle addSubview:self.lbName];
    
    [self setViewFrame];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
}

-(void)setViewFrame
{
    CGFloat viewW = APP_FRAME_WIDTH;
    
    [self.viewHeader setFrame:CGRectMake(0, 0, viewW, 62)];
    
    [self.btnCompany setFrame:CGRectMake(0, 0, viewW, 30)];
    
    [self.viewLine setFrame:CGRectMake(0, self.btnCompany.y+self.btnCompany.height, viewW, 2)];
    
    [self.viewTitle setFrame:CGRectMake(0, self.viewLine.y+self.viewLine.height, viewW, 30)];
    
    [self.lbNumber setFrame:CGRectMake(0, 5, 60, 25)];
    [self.lbCode setFrame:CGRectMake(self.lbNumber.x+self.lbNumber.width, 5, 110, 25)];
    [self.lbName setFrame:CGRectMake(self.lbCode.x+self.lbCode.width, 5, viewW-self.lbNumber.width-self.lbCode.width, 25)];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
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

-(void)setViewDataWithModel:(ModelRankCompany *)model
{
    switch (model.type) {
        case WTRankTypeL:
            [self.lbName setText:@"律师事务所"];
            break;
        case WTRankTypeK:
            [self.lbName setText:@"会计事务所"];
            break;
        case WTRankTypeZ:
            [self.lbName setText:@"证券公司"];
            break;
        default:break;
    }
}

-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_lbCode);
    OBJC_RELEASE(_lbName);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_lbNumber);
    OBJC_RELEASE(_viewTitle);
    OBJC_RELEASE(_btnCompany);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.viewHeader.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewHeader;
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
