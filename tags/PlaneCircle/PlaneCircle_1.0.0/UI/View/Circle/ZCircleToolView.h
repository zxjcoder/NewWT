//
//  ZCircleToolView.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCircleToolView : UIView

///子项点击事件
@property (copy ,nonatomic) void(^onItemClick)(ZCircleToolViewItem item);

///设置选择默认子项
-(void)setViewSelectItemWithType:(ZCircleToolViewItem)item;

///设置横向偏移量
-(void)setOffsetChange:(CGFloat)offX;

@end
