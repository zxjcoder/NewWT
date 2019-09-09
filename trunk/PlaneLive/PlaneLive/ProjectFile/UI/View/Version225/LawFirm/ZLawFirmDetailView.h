//
//  ZLawFirmDetailView.h
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZLawFirmDetailView : ZView

///视图高度发生改变
@property (copy, nonatomic) void(^onViewHeightChange)(CGFloat viewH);

-(void)setViewDataWithLawFirm:(ModelLawFirm *)model;

///查看全部点击事件
@property (copy, nonatomic) void(^onMoreClick)();

///标题设置
-(void)setTitleText:(NSString *)text;
///隐藏更多按钮
-(void)setMoreHidden:(BOOL)hidden;

@end
