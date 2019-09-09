//
//  ZNewHomeButtonView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

/// 导航显示区域
@interface ZNewHomeButtonView : ZView

///查看全部点击事件
@property (copy, nonatomic) void(^onAllClick)();
///描述文本点击事件
@property (copy, nonatomic) void(^onDescClick)();

///初始化
-(instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc isMore:(BOOL)isMore;

+(CGFloat)getH;

@end
