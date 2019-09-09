//
//  ZPracticeTypeHeaderView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPracticeTypeHeaderView : ZView

@property (copy, nonatomic) void(^onBeginEdit)();
@property (copy, nonatomic) void(^onEndEdit)();
@property (copy, nonatomic) void(^onSearchClick)(NSString *content);
@property (copy, nonatomic) void(^onCancelClick)();

-(void)setTextFieldText:(NSString *)text;
///获取试图高度
+(CGFloat)getViewH;

@end
