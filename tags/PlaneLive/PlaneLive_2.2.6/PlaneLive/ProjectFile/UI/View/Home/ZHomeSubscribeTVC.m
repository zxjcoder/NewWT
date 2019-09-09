//
//  ZHomeSubscribeTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZHomeSubscribeTVC.h"
#import "ZHomeItemNavView.h"
#import "ZHomeSubscribeItemTVC.h"
#import "ZBaseTableView.h"

static NSString* kZHomeSubscribeTVCCellId = @"kZHomeSubscribeTVCCellId";

@interface ZHomeSubscribeTVC()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) ZBaseTableView *tvMain;

//@property (strong, nonatomic) UIImageView *imgLine1;
@property (strong, nonatomic) UIImageView *imgLine2;

@property (strong, nonatomic) NSArray *mainArray;

@end

@implementation ZHomeSubscribeTVC

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
    
    self.cellH = [ZHomeSubscribeTVC getH];
    
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR2];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, kZHomeItemNavViewHeight) title:kPopularSubscription desc:kWhatIsASubscription alignment:NSTextAlignmentLeft];
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
    
//    self.imgLine1 = [UIImageView getDLineView];
//    [self.imgLine1 setFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.cellW, kLineHeight)];
//    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-kLineMaxHeight, self.cellW, kLineMaxHeight)];
    [self.viewMain addSubview:self.imgLine2];
    
    ZWEAKSELF
    [self.viewHeader setOnAllClick:^{
        if (weakSelf.onAllSubscribeClick) {
            weakSelf.onAllSubscribeClick();
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
    
    CGRect tvFrame = self.tvMain.frame;
    if (array.count == 0) {
        tvFrame.size.height = [ZHomeSubscribeItemTVC getH];
    } else {
        tvFrame.size.height = [ZHomeSubscribeItemTVC getH]*array.count;
    }
    [self.tvMain setFrame:tvFrame];
    self.cellH = self.tvMain.y+self.tvMain.height+kLineMaxHeight;
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-kLineMaxHeight, self.cellW, kLineMaxHeight)];
    [self.viewMain setFrame:self.getMainFrame];
    
    [self.tvMain reloadData];
}
-(void)setViewNil
{
    _tvMain.delegate = nil;
    _tvMain.dataSource = nil;
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_imgLine2);
//    OBJC_RELEASE(_imgLine1);
    
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
    return kZHomeItemNavViewHeight+[ZHomeSubscribeItemTVC getH]+kLineMaxHeight;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomeSubscribeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:kZHomeSubscribeTVCCellId];
    if (!cell) {
        cell = [[ZHomeSubscribeItemTVC alloc] initWithReuseIdentifier:kZHomeSubscribeTVCCellId];
    }
    ModelSubscribe *modelS = [self.mainArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:modelS];
    [cell setImageTotalHidden:YES];
    
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
