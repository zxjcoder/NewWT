//
//  ZFeekBackContentTVC.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 反馈记录输入区域
@interface ZFeekBackContentTVC : ZBaseTVC

///文本开始编辑
@property (copy, nonatomic) void(^onBeginEditText)();

-(NSString *)getText;
-(void)setText:(NSString *)text;

@end
