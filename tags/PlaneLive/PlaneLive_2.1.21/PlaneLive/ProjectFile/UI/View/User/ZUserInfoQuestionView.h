//
//  ZUserInfoQuestionView.h
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZUserInfoQuestionView : ZView

///我的问题
@property (copy, nonatomic) void(^onQuestionClick)();
///我的粉丝
@property (copy, nonatomic) void(^onFansClick)();
///待我回答
@property (copy, nonatomic) void(^onAnswerClick)();

-(void)setViewDataWithModel:(ModelUser *)model;
+(CGFloat)getH;

@end
