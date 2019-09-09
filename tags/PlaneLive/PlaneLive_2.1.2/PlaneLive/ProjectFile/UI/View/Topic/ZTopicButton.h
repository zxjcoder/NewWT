//
//  ZTopicButton.h
//  PlaneCircle
//
//  Created by Daniel on 7/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

@interface ZTopicButton : UIButton

///初始化对象
-(id)initWithPoint:(CGPoint)point;

///数据对象
@property (strong, nonatomic) ModelTag *modelT;
///设置数据源
-(void)setButtonModel:(ModelTag *)model;

///获取宽度
+(CGFloat)getBtnW;

@end
