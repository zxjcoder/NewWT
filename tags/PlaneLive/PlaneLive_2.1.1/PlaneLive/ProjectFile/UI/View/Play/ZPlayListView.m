//
//  ZPlayListView.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayListView.h"
#import "ZBaseTableView.h"
#import "ZPlayListTVC.h"

@interface ZPlayListView()<UITableViewDelegate, UITableViewDataSource>

///背景
@property (strong, nonatomic) UIView *viewBG;

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) ZPlayListTVC *tvcItem;
///顶部区域
@property (strong, nonatomic) UIView *viewHeader;
///顶部标题
@property (strong, nonatomic) UILabel *lbHeader;
///底部区域
@property (strong, nonatomic) UIView *viewFooter;
///底部按钮
@property (strong, nonatomic) UIButton *btnFooter;

@property (strong, nonatomic) NSArray *arrayMain;
///内容坐标
@property (assign, nonatomic) CGRect contentFrame;
///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;

@property (assign, nonatomic) NSInteger rowIndex;

@end


@implementation ZPlayListView

///初始化
-(instancetype)initWithPlayListArray:(NSArray *)playListArray index:(NSInteger)index
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self setRowIndex:index];
        [self setArrayMain:playListArray];
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    [self getBgView];
    
    self.contentFrame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT*0.7);
    self.viewContent = [[UIView alloc] initWithFrame:self.contentFrame];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewContent];
    
    self.viewHeader = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, self.viewContent.width+2, 40)];
    [self.viewHeader setViewRound:0 borderWidth:1 borderColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewHeader setBackgroundColor:WHITECOLOR];
    
    self.lbHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.viewHeader.width, 20)];
    [self.lbHeader setText:[NSString stringWithFormat:@"%@(%d)", kPlayList, (int)self.arrayMain.count]];
    [self.lbHeader setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbHeader setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewHeader addSubview:self.lbHeader];
    
    [self.viewContent addSubview:self.viewHeader];
    
    self.viewFooter = [[UIView alloc] initWithFrame:CGRectMake(-1, self.viewContent.height-40, self.viewContent.width+2, 40)];
    [self.viewFooter setViewRound:0 borderWidth:1 borderColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewFooter setBackgroundColor:WHITECOLOR];
    
    self.btnFooter = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnFooter setTitle:kClose forState:(UIControlStateNormal)];
    [self.btnFooter setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[self.btnFooter titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnFooter addTarget:self action:@selector(btnFooterClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnFooter setFrame:CGRectMake(0, 0, self.viewFooter.width, self.viewFooter.height)];
    [self.viewFooter addSubview:self.btnFooter];
    
    [self.viewContent addSubview:self.viewFooter];
    
    self.tvcItem = [[ZPlayListTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:CGRectMake(0, 40, self.viewContent.width, self.viewContent.height-80)];
    [self.tvMain setBackgroundColor:WHITECOLOR];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.viewContent addSubview:self.tvMain];
}
///设置数据源
-(void)setPlayListArray:(NSArray *)playListArray index:(NSInteger)index
{
    [self setRowIndex:index];
    [self setArrayMain:playListArray];
    [self.lbHeader setText:[NSString stringWithFormat:@"%@(%d)", kPlayList, (int)self.arrayMain.count]];
    [self.tvMain reloadData];
}
-(void)setChangePlayIndex:(NSInteger)index
{
    [self setRowIndex:index];
    
    [self.tvMain reloadData];
}
-(void)getBgView
{
    self.viewBG = [[UIView alloc] initWithFrame:self.bounds];
    [self.viewBG setBackgroundColor:BLACKCOLOR];
    [self.viewBG setAlpha:0.4f];
    [self addSubview:self.viewBG];
    
    UITapGestureRecognizer *viewBGTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTap:)];
    [self.viewBG addGestureRecognizer:viewBGTap];
}
-(void)viewBGTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
-(void)btnFooterClick
{
    [self dismiss];
}
-(void)setViewNil
{
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_lbHeader);
    OBJC_RELEASE(_btnFooter);
    OBJC_RELEASE(_arrayMain);
    _tvMain.dataSource = nil;
    _tvMain.delegate = nil;
    OBJC_RELEASE(_tvMain);
}
-(void)dealloc
{
    [self setViewNil];
}
///显示
-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.viewBG setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        CGRect cFrame = self.contentFrame;
        cFrame.origin.y = cFrame.origin.y-cFrame.size.height;
        [self.viewBG setAlpha:0.4f];
        [self.viewContent setFrame:cFrame];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}
///隐藏
-(void)dismiss
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.viewBG setAlpha:0];
        [self.viewContent setFrame:CGRectMake(0, self.viewBG.height, self.tvMain.width, self.tvMain.height)];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
        [self setViewNil];
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
    ModelAudio *modelA = [self.arrayMain objectAtIndex:indexPath.row];
    return [self.tvcItem setCellDataWithModel:modelA];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZPlayListTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZPlayListTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelAudio *model = [self.arrayMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    if (self.rowIndex == indexPath.row) {
        [cell setViewTitleColor:MAINCOLOR];
    } else {
        [cell setViewTitleColor:BLACKCOLOR];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onPlayItemClick) {
        ModelAudio *model = [self.arrayMain objectAtIndex:indexPath.row];
        self.onPlayItemClick(model, indexPath.row);
    }
    self.rowIndex = indexPath.row;
    [tableView reloadData];
}

@end
