//
//  ZTaskAlertView.h
//  PlaneCircle
//
//  Created by Daniel on 9/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZTaskAlertView : ZView

///初始化内容
-(id)initWithContent:(NSString *)content;

///确定点击
@property (copy, nonatomic) void(^onSubmitClick)();
///取消点击
@property (copy, nonatomic) void(^onCancelClick)();

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
