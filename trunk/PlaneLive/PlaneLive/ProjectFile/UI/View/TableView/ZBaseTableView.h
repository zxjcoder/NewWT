//
//  ZBaseTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"
#import "ZBackgroundView.h"
#import "ModelAudio.h"
#import "ZScrollView.h"

@interface ZBaseTableView : UITableView

///背景按钮事件
@property (copy, nonatomic) void(^onBackgroundClick)(ZBackgroundState viewBGState);
///开始偏移量
@property (assign, nonatomic) int oldOffsetY;
///原始数据
@property (strong, nonatomic) NSDictionary *dicRawData;
///开始刷新顶部数据
@property (copy, nonatomic) void(^onRefreshHeader)();
///开始刷新底部数据
@property (copy, nonatomic) void(^onRefreshFooter)();

///设置背景状态
-(void)setBackgroundViewWithState:(ZBackgroundState)backState;
///设置基本功能
-(void)innerInit;
///字体改变处理的业务逻辑
-(void)setFontSizeChange;
///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult;
///设置数据源
-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

///设置关键字
-(void)setViewKeyword:(NSString *)keyword;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
