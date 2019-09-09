//
//  ZUserInfoQuestionButton.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButton.h"

@interface ZUserInfoQuestionButton : ZButton

///设置数据
-(void)setViewDataWithTitle:(NSString *)title maxCount:(long)maxCount minCount:(long)minCount;

@end
