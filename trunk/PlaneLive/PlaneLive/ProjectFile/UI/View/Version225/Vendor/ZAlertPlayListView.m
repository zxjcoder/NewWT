//
//  ZAlertPlayListView.m
//  PlaneLive
//
//  Created by Daniel on 27/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertPlayListView.h"
#import "ZBaseTableView.h"
#import "ZLabel.h"
#import "ZAlertPlayListTVC.h"
#import "ZPlayerViewController.h"

@interface ZAlertPlayListView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZBaseTableView *tvMain;
@property (strong, nonatomic) ZView *viewClose;
@property (strong, nonatomic) ZAlertPlayListTVC *tvcItem;

@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;
@property (assign, nonatomic) NSArray *arrayMain;
@property (assign, nonatomic) NSInteger playIndex;
@property (assign, nonatomic) CGRect closeFrame;
@property (assign, nonatomic) CGRect tvFrame;
@property (assign, nonatomic) BOOL isPlaying;

@end

@implementation ZAlertPlayListView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
///初始化
-(instancetype)initWithPlayListArray:(NSArray *)playListArray index:(NSInteger)index
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        self.arrayMain = playListArray;
        self.playIndex = index;
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.contentH = [self getMaxHeight];
    self.tvcItem = [[ZAlertPlayListTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    if (!self.viewBack) {
        self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
        [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR5];
        [self.viewBack setAlpha:kBackgroundOpacity];
        [self addSubview:self.viewBack];
        
        UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
        [self.viewBack addGestureRecognizer:viewBGTapGesture];
    }
    self.contentFrame = CGRectMake(10, self.height, self.width-20, self.contentH);
    if (!self.viewContent) {
        self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
        [[self.viewContent layer] setMasksToBounds:true];
        [self.viewContent setBackgroundColor:WHITECOLOR];
        [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
        [self addSubview:self.viewContent];
    }
    [self sendSubviewToBack:self.viewBack];
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(0, 17, self.viewContent.width, 21))];
        [self.lbTitle setText:@"音频列表"];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self.viewContent addSubview:self.lbTitle];
    }
    CGFloat mainY = self.lbTitle.y+self.lbTitle.height+15;
    CGFloat mainHeight = self.contentH-mainY-46;
    self.tvFrame = CGRectMake(0, mainY, self.viewContent.width, mainHeight);
    if (!self.tvMain) {
        self.tvMain = [[ZBaseTableView alloc] initWithFrame:(self.tvFrame)];
        [self.tvMain setDelegate:self];
        [self.tvMain setDataSource:self];
        [self.tvMain setScrollsToTop:false];
        [self.tvMain setClipsToBounds:true];
        [self.viewContent addSubview:self.tvMain];
    }
    self.closeFrame = CGRectMake(0, self.tvMain.y+self.tvMain.height, self.viewContent.width, 46);
    if (!self.viewClose) {
        self.viewClose = [[ZView alloc] initWithFrame:(self.closeFrame)];
        [self.viewContent addSubview:self.viewClose];
        
        UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btnClose setTitle:kCancel forState:(UIControlStateNormal)];
        [btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
        [[btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
        btnClose.userInteractionEnabled = true;
        btnClose.backgroundColor = CLEARCOLOR;
        btnClose.frame = self.viewClose.bounds;
        [self.viewClose addSubview:btnClose];
        
        UIImageView *imageLine = [UIImageView getDLineView];
        imageLine.frame = CGRectMake(0, 0, self.viewClose.width, kLineHeight);
        [self.viewClose addSubview:imageLine];
    }
    [self setViewContentFrame];
}
///获取显示视图不包括列表的高度
-(CGFloat)getNotTVMainHeight
{
    return 91;
}
///获取显示内容最大高度
-(CGFloat)getMaxHeight
{
    return 400;
}
///设置数据源
-(void)setPlayListArray:(NSArray *)playListArray index:(NSInteger)index
{
    self.playIndex = index;
    self.arrayMain = playListArray;
    
    [self.tvMain reloadData];
}
///设置内容坐标
-(void)setViewContentFrame
{
//    if (self.arrayMain && self.arrayMain.count > 0) {
//        CGFloat tvMainHeight = 0;
//        for (ModelTrack *model in self.arrayMain) {
//            tvMainHeight += [self.tvcItem setCellDataWithModel:model];
//        }
//        if ((tvMainHeight+[self getNotTVMainHeight]) > [self getMaxHeight]) {
//            tvMainHeight = [self getMaxHeight]-[self getNotTVMainHeight];
//        }
//        CGRect tvFrame = self.tvFrame;
//        tvFrame.size.height = tvMainHeight;
//        self.tvMain.frame = tvFrame;
//
//        CGRect closeFrame = self.closeFrame;
//        closeFrame.origin.y = self.tvMain.y+self.tvMain.height;
//        self.viewClose.frame = closeFrame;
//    } else {
//        self.tvMain.frame = self.tvFrame;
//        self.viewClose.frame = self.closeFrame;
//    }
//    self.contentH = self.viewClose.y+self.viewClose.height;
//    CGRect contentFrame = self.contentFrame;
//    contentFrame.size.height = self.contentH+20;
//    contentFrame.origin.y = self.height;
//    self.contentFrame = contentFrame;
//    self.viewContent.frame = contentFrame;
}
///改变播放列表
-(void)setChangePlayIndex:(NSInteger)index
{
    self.playIndex = index;
    [self.tvMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:true];
    [self.tvMain reloadData];
}
///设置是否播放中
-(void)setPlayStatus:(BOOL)isPlaying
{
    self.isPlaying = isPlaying;
}
-(void)btnCloseEvent
{
    [self dismiss];
}
-(void)viewBGTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
-(void)setOnPlayNextChange:(NSNotification *)sender
{
    NSDictionary *dicOjbect = (NSDictionary *)sender.object;
    NSNumber *rowIndex = (NSNumber*)[dicOjbect objectForKey:@"playIndex"];
    //ModelTrack *modelT = (ModelTrack *)[dicOjbect objectForKey:@"modelT"];
    [self setChangePlayIndex:[rowIndex integerValue]];
}
///显示
-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.viewBack.alpha = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOnPlayNextChange:) name:@"onPlayNextChange" object:nil];
//    [[ZPlayerViewController sharedSingleton] setOnPlayNextChange:^(ModelTrack *model, NSInteger rowIndex) {
//        [self setChangePlayIndex:rowIndex];
//    }];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewBack.alpha = kBackgroundOpacity;
        CGRect contentFrame = self.contentFrame;
        if (IsIPhoneX) {
            contentFrame.origin.y -= (self.contentH+10+kIPhoneXButtonHeight);
        } else {
            contentFrame.origin.y -= (self.contentH+10);
        }
        self.viewContent.frame = contentFrame;
    } completion:^(BOOL finished) {
        
    }];
}
///隐藏
-(void)dismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onPlayNextChange" object:nil];
//    [[ZPlayerViewController sharedSingleton] setOnPlayNextChange:nil];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContent.frame = self.contentFrame;
        self.viewBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelTrack *model = [self.arrayMain objectAtIndex:indexPath.row];
    return [self.tvcItem setCellDataWithModel:model];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZAlertPlayListTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZAlertPlayListTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelTrack *model = [self.arrayMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    if ([ZPlayerViewController sharedSingleton].isPlaying) {
        [cell setStartPlay:self.playIndex==indexPath.row];
    } else {
        [cell setStartPlay:false];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onPlayItemClick) {
        self.onPlayItemClick([self.arrayMain objectAtIndex:indexPath.row], indexPath.row);
    }
    [self dismiss];
}

@end
