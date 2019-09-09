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

-(NSString *)getText;

@end
