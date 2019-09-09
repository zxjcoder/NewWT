//
//  ZButton.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kButtonShareW 70
#define kButtonShareH 80

@interface ZButton : UIButton

@property (assign, nonatomic) ZShareType type;

///初始化
-(id)initWithShareType:(ZShareType)type;

///设置坐标
-(void)setBtnPoint:(CGPoint)point;

///设置按钮文字
-(void)setButtonText:(NSString *)text;

@end
