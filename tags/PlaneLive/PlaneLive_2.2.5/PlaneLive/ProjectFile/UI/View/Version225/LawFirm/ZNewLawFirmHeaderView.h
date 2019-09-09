//
//  ZNewLawFirmHeaderView.h
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZNewLawFirmHeaderView : ZView

///查看全部点击事件
@property (copy, nonatomic) void(^onMoreClick)();

///初始化
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title isMore:(BOOL)isMore;

///标题设置
-(void)setTitleText:(NSString *)text;
///隐藏更多按钮
-(void)setMoreHidden:(BOOL)hidden;

///获取高度
+(CGFloat)getH;

@end
