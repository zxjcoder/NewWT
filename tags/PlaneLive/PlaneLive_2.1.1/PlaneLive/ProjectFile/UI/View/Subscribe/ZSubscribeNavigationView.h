//
//  ZSubscribeNavigationView.h
//  PlaneLive
//
//  Created by Daniel on 08/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZSubscribeNavigationView : ZView

///子项点击事件
@property (copy ,nonatomic) void(^onItemClick)(NSInteger index);

///设置默认选中子项 0 , 1
-(void)setItemDefaultSelect:(NSInteger)index;

///设置横向偏移量
-(void)setOffsetChange:(CGFloat)offX;

@end
