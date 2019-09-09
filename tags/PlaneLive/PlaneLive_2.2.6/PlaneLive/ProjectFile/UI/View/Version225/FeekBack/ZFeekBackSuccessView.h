//
//  ZFeekBackSuccessView.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

/// 反馈记录成功界面
@interface ZFeekBackSuccessView : ZView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;

/// 查看记录
@property (copy, nonatomic) void(^onSayRecordClick)();

/// 设置提示语
-(void)setPromptText:(NSString *)prompt;

@end
