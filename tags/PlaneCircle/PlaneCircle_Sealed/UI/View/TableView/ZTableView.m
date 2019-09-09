//
//  ZTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTableView.h"
#import "MJRefresh.h"

@interface ZTableView()

///背景
@property (strong, nonatomic) ZBackgroundView *viewBG;
///背景状态
@property (assign, nonatomic) ZBackgroundState viewBGState;

@end

@implementation ZTableView

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}

-(void)innerInit
{
    if([self respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
    __weak typeof(self) weakSelf = self;
    self.viewBG = [[ZBackgroundView alloc] initWithFrame:self.bounds];
    [self.viewBG setOnButtonClick:^{
        if (weakSelf.onBackgroundClick) {
            weakSelf.onBackgroundClick(weakSelf.viewBGState);
        }
    }];
    if (APP_SYSTEM_VERSION > 8) {
        [self setBackgroundView:self.viewBG];
    } else {
        // TODO:ZWW备注-兼容TableView_BackgroundView在iOS7下不响应事件
        [self addSubview:self.viewBG];
    }
}

-(void)setFontSizeChange
{
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.viewBG setFrame:self.bounds];
}

-(void)setBackgroundViewWithState:(ZBackgroundState)backState
{
    [self setViewBGState:backState];
    [self.viewBG setViewStateWithState:(self.viewBGState)];
    [self setViewFrame];
}

-(void)addRefreshHeaderWithEndBlock:(void (^)(void))refreshBlock
{
    self.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    NSMutableArray *arrWillImage = [NSMutableArray array];
    for (int i = 51; i < 77; i++) {
        [arrWillImage addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_header%d",i]]];
    }
    NSMutableArray *arrIdleImage = [NSMutableArray array];
    [arrIdleImage addObject:[UIImage imageNamed:@"refresh_header76"]];
    for (int i = 1; i < 20; i++) {
        [arrIdleImage addObject:[UIImage imageNamed:@"refresh_header1"]];
    }
    for (int i = 1; i < 52; i++) {
        [arrIdleImage addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_header%d",i]]];
    }
    [(MJRefreshGifHeader*)self.mj_header setImages:arrIdleImage forState:(MJRefreshStateIdle)];
    [(MJRefreshGifHeader*)self.mj_header setImages:arrWillImage duration:2.5f forState:(MJRefreshStateRefreshing)];
    
    [[(MJRefreshGifHeader*)self.mj_header stateLabel] setHidden:YES];
    [[(MJRefreshGifHeader*)self.mj_header lastUpdatedTimeLabel] setHidden:YES];
    
//    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (refreshBlock) {
//            refreshBlock();
//        }
//    }];
}

-(void)removeRefreshHeader
{
    if (self.mj_header) {
        [self.mj_header removeFromSuperview];
    }
}

-(void)endRefreshHeader
{
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
}

-(void)addRefreshFooterWithEndBlock:(void (^)(void))refreshBlock
{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
}

-(void)removeRefreshFooter
{
    if (self.mj_footer) {
        [self.mj_footer removeFromSuperview];
    }
}

-(void)endRefreshFooter
{
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_onRefreshFooter);
    OBJC_RELEASE(_onRefreshHeader);
    OBJC_RELEASE(_onBackgroundClick);
}

@end
