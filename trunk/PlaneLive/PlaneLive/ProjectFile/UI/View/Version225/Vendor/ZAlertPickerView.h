//
//  ZAlertPickerView.h
//  PlaneLive
//
//  Created by Daniel on 09/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZAlertPickerView : ZView

///子项改变事件
@property (copy, nonatomic) void(^onItemChange)(NSString *value);
///隐藏事件
@property (copy, nonatomic) void(^onDismissEvent)();

/// 初始化
-(instancetype)initWithType:(ZAlertPickerViewType)type;

/// 设置默认性别数据
- (void)setViewSex:(WTSexType)type;
/// 设置默认行业数据
- (void)setViewEducation:(NSString *)value;
/// 设置默认时间数据
- (void)setViewTime:(NSString *)time;
/// 设置默认省市区数据
- (void)setViewArea:(NSString *)area;
/// 获取内容高度
- (CGFloat)getContentH;
///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
