//
//  ZNewHomeFreeView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeFreeView.h"
#import "ZNewHomeFreeItemTVC.h"
#import "ZBaseTableView.h"
#import "ZNewHomeButtonView.h"

@interface ZNewHomeFreeView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZNewHomeButtonView *viewTop;
@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) ModelTrack *modelT;
@property (strong, nonatomic) NSArray *arrayMain;
@property (assign, nonatomic) BOOL isPlaying;

@end

@implementation ZNewHomeFreeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [self setBackgroundColor:WHITECOLOR];
    if (!self.viewTop) {
        self.viewTop = [[ZNewHomeButtonView alloc] initWithTitle:@"免费专区" desc:kEmpty isMore:true];
        [self addSubview:self.viewTop];
    }
    if (!self.tvMain) {
        self.tvMain = [[ZBaseTableView alloc] initWithFrame:(CGRectMake(0, self.viewTop.height+8, self.width, 0))];
        [self.tvMain setDelegate:self];
        [self.tvMain setDataSource:self];
        [self.tvMain setScrollEnabled:false];
        [self.tvMain setScrollsToTop:false];
        [self.tvMain setShowsVerticalScrollIndicator:false];
        [self.tvMain setShowsHorizontalScrollIndicator:false];
        [self.tvMain setRowHeight:[ZNewHomeFreeItemTVC getH]];
        [self addSubview:self.tvMain];
    }
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
}
-(CGFloat)setViewData:(NSArray *)array
{
    self.arrayMain = array;
    
    CGRect mainFrame = self.tvMain.frame;
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
        mainFrame.size.height = [ZNewHomeFreeItemTVC getH]*array.count;
    } else {
        mainFrame.size.height = 0;
    }
    self.tvMain.frame = mainFrame;
    [self.tvMain reloadData];
    return self.tvMain.y+self.tvMain.height+15;
}
-(void)setPlayObject:(ModelTrack *)model isPlaying:(BOOL)isPlaying
{
    if (model.source == ZDownloadTypePractice) {
        [self setIsPlaying:isPlaying];
        self.modelT = model;
        [self.tvMain reloadData];
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZNewHomeFreeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZNewHomeFreeItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelPractice *model = [self.arrayMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    if ([model.ids isEqualToString:self.modelT.ids]) {
        [cell setIsPlaying:self.isPlaying];
    } else {
        [cell setIsPlaying:false];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onPracticeClick) {
        self.onPracticeClick(self.arrayMain, indexPath.row);
    }
}

@end
