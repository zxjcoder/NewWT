//
//  ZFeekBackPhoneTVC.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 输入手机号
@interface ZFeekBackPhoneTVC : ZBaseTVC

///文本开始编辑
@property (copy, nonatomic) void(^onBeginEditText)();

-(NSString *)getText;
-(void)setText:(NSString *)text;

@end
