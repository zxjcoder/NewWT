//
//  ZUserSelectEducationView.h
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZUserSelectEducationView : ZView

/// 选中按钮点击事件
@property (copy, nonatomic) void(^onSelectChange)(NSString *selectValue);
/// 关闭按钮点击事件
@property (copy, nonatomic) void(^onCloseClick)();
/// 设置默认选中值
-(void)setDefaultSelectValue:(NSString *)selValue;

/// 显示选择器
-(void)show;

/// 移除选择器
-(void)dismiss;

@end
