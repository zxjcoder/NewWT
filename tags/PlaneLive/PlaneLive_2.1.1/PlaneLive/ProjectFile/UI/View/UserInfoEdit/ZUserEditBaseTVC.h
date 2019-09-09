//
//  ZUserEditBaseTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "ZTextField.h"

@interface ZUserEditBaseTVC : ZBaseTVC<UITextFieldDelegate>

@property (strong, nonatomic) UILabel *lbTitle;

@property (retain, nonatomic) ZTextField *textField;

@property (copy ,nonatomic) void(^onBeginEdit)();

///获取最大输入值
-(int)getMaxTextLength;
///设置最大输入值
-(void)setMaxTextLength:(int)length;
///获取文本
-(NSString *)getText;

@end
