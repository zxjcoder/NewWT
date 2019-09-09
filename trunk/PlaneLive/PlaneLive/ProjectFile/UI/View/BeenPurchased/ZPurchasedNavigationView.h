//
//  ZPurchasedNavigationView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPurchasedNavigationView : ZView

///子项点击事件
@property (copy ,nonatomic) void(^onItemClick)(NSInteger index);
///搜索按钮点击事件
@property (copy ,nonatomic) void(^onSearchClick)();

///改变索引
-(void)setChangeItemIndex:(NSInteger)index;

///设置横向偏移量
-(void)setOffsetChange:(CGFloat)offX;
-(int)getNavItemCount;
-(void)setLineFrame;

-(void)setAllPoint:(int)unReadTotalCount;
-(void)setPracticePoint:(int)unReadTotalCount;
-(void)setSubscriptionPoint:(int)unReadTotalCount;
-(void)setCurriculumPoint:(int)unReadTotalCount;

@end
