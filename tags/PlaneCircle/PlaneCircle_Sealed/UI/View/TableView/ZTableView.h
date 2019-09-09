//
//  ZTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"
#import "ZBackgroundView.h"

@interface ZTableView : UITableView

///背景按钮事件
@property (copy, nonatomic) void(^onBackgroundClick)(ZBackgroundState viewBGState);

///设置背景状态
-(void)setBackgroundViewWithState:(ZBackgroundState)backState;

///设置基本功能
-(void)innerInit;

///字体改变处理的业务逻辑
-(void)setFontSizeChange;

///开始刷新顶部数据
@property (copy, nonatomic) void(^onRefreshHeader)();
///开始刷新底部数据
@property (copy, nonatomic) void(^onRefreshFooter)();

///添加刷新顶部功能
-(void)addRefreshHeaderWithEndBlock:(void (^)(void))refreshBlock;
///移除刷新顶部功能
-(void)removeRefreshHeader;
///结束顶部刷新
-(void)endRefreshHeader;

///添加刷新底部功能
-(void)addRefreshFooterWithEndBlock:(void (^)(void))refreshBlock;
///移除刷新底部功能
-(void)removeRefreshFooter;
///结束底部刷新
-(void)endRefreshFooter;

@end
