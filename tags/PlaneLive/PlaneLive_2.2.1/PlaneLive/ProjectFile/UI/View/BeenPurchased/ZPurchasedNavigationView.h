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

///改变索引
-(void)setChangeItemIndex:(NSInteger)index;

///设置横向偏移量
-(void)setOffsetChange:(CGFloat)offX;
-(int)getNItemCount;

-(void)setSubscriptionPoint:(int)unReadTotalCount;
-(void)setCurriculumPoint:(int)unReadTotalCount;

@end
