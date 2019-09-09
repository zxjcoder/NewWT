//
//  ZNewHomeTrainView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeTrainView.h"
#import "ZNewHomeButtonView.h"
#import "ZNewCoursesItemTVC.h"
#import "ZBaseTableView.h"

@interface ZNewHomeTrainView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZNewHomeButtonView *viewTop;
@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZNewHomeTrainView

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
    [self setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewTop = [[ZNewHomeButtonView alloc] initWithTitle:kPopularSubscription desc:kWhatIsASubscription isMore:true];
    [self addSubview:self.viewTop];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:(CGRectMake(0, self.viewTop.height, self.width, 0))];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setScrollEnabled:false];
    [self.tvMain setScrollsToTop:false];
    [self.tvMain setShowsVerticalScrollIndicator:false];
    [self.tvMain setShowsHorizontalScrollIndicator:false];
    [self.tvMain setRowHeight:[ZNewCoursesItemTVC getH]];
    [self addSubview:self.tvMain];
    
    [self innerEvent];
}
-(void)innerEvent
{
    ZWEAKSELF
    [self.viewTop setOnAllClick:^{
        if (weakSelf.onMoreClick) {
            weakSelf.onMoreClick();
        }
    }];
    [self.viewTop setOnDescClick:^{
        if (weakSelf.onDescClick) {
            weakSelf.onDescClick();
        }
    }];
}
-(CGFloat)setViewData:(NSArray *)array
{
    self.arrayMain = array;
    
    CGRect mainFrame = self.tvMain.frame;
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
        mainFrame.size.height = [ZNewCoursesItemTVC getH]*array.count;
    } else {
        mainFrame.size.height = 0;
    }
    self.tvMain.frame = mainFrame;
    [self.tvMain reloadData];
    return self.tvMain.y+self.tvMain.height+5;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZNewCoursesItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZNewCoursesItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelSubscribe *model = [self.arrayMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    [cell setHiddenLine:self.arrayMain.count==(indexPath.row+1)];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelSubscribe *model = [self.arrayMain objectAtIndex:indexPath.row];
    if (self.onCourseClick) {
        self.onCourseClick(model);
    }
}

@end
