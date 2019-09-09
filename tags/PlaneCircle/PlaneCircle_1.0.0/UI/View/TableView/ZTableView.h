//
//  ZTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

@interface ZTableView : UITableView

///设置基本功能
-(void)innerInit;

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
