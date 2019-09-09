//
//  ZSwitchToolView.h
//  PlaneCircle
//
//  Created by Daniel on 7/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

///切换工具栏
@interface ZSwitchToolView : UIView

///初始化
-(id)initWithType:(ZSwitchToolViewItem)type;

///子项点击事件
@property (copy ,nonatomic) void(^onItemClick)(NSInteger index);

///设置选择默认子项
-(void)setViewSelectItemWithType:(NSInteger)item;

///设置按钮文字
-(void)setButtonText:(NSString *)text index:(NSInteger)index;

///设置横向偏移量
-(void)setOffsetChange:(CGFloat)offX;

///设置对应子项显示数量
-(void)setItemCount:(int)count index:(NSInteger)index;

///获取高度
+(CGFloat)getViewH;

///获取子项
-(UIButton *)getItemButtonWithItem:(NSInteger)index;

/// 获取当前索引
-(int)getNItemCount;

@end
