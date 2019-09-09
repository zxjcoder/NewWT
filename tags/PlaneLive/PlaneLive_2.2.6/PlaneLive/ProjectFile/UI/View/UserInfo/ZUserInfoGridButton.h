//
//  ZUserInfoGridButton.h
//  PlaneLive
//
//  Created by Daniel on 13/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZUserInfoGridButton : UIButton

///类型
@property (assign, nonatomic) ZUserInfoGridCVCType type;
///设置数据源
-(void)setViewDataWithType:(ZUserInfoGridCVCType)type count:(long)count;

@end
