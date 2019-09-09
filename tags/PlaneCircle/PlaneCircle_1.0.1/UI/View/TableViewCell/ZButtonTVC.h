//
//  ZButtonTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///一个宽屏按钮CELL
@interface ZButtonTVC : ZBaseTVC

///按钮点击
@property (copy ,nonatomic) void(^onSubmitClick)();

///设置按钮文字
-(void)setButtonText:(NSString *)text;

@end
