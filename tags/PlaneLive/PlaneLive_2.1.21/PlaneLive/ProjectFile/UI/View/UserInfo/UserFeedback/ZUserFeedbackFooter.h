//
//  ZUserFeedbackFooter.h
//  PlaneLive
//
//  Created by Daniel on 28/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZUserFeedbackFooter : ZView

///图片点击
@property (copy, nonatomic) void(^onImageClick)();

///设置输入多少字
-(void)setChangeTextLength:(NSInteger)textLength;

+(CGFloat)getViewH;

@end
