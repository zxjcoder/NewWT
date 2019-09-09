//
//  ZNewHomeRecommendView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeRecommendView.h"
#import "ZBaseTableView.h"
#import "ZNewCommonCourseTVC.h"
#import "ZNewHomeButtonView.h"

@interface ZNewHomeRecommendView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZNewHomeButtonView *viewTop;
@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZNewHomeRecommendView

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
    self.viewTop = [[ZNewHomeButtonView alloc] initWithTitle:@"每日推荐" desc:kEmpty isMore:false];
    [self addSubview:self.viewTop];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:(CGRectMake(0, self.viewTop.height, self.width, 0))];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setScrollEnabled:false];
    [self.tvMain setScrollsToTop:false];
    [self.tvMain setShowsVerticalScrollIndicator:false];
    [self.tvMain setShowsHorizontalScrollIndicator:false];
    [self.tvMain setRowHeight:[ZNewCommonCourseTVC getH]];
    [self addSubview:self.tvMain];
}
-(CGFloat)setViewData:(NSArray *)array
{
    self.arrayMain = array;
    
    CGRect mainFrame = self.tvMain.frame;
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
        mainFrame.size.height = [ZNewCommonCourseTVC getH]*array.count;
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
    ZNewCommonCourseTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZNewCommonCourseTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelEntity *model = [self.arrayMain objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[ModelPractice class]]) {
        [cell setCellDataWithPracticeModel:model];
    } else {
        [cell setCellDataWithCourseModel:model];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelEntity *model = [self.arrayMain objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[ModelPractice class]]) {
        if (self.onPracticeClick) {
            self.onPracticeClick(model);
        }
    } else {
        if (self.onSubscribeClick) {
            self.onSubscribeClick(model);
        }
    }
}

@end
