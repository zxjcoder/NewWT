//
//  ZUserNumberTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserNumberTVC : ZBaseTVC

///我的问题事件
@property (copy, nonatomic) void(^onQuestionClick)();
///我的粉丝事件
@property (copy, nonatomic) void(^onFansClick)();
///等我回答事件
@property (copy, nonatomic) void(^onAnswerClick)();

@end
