//
//  ZFoundCardItemView.h
//  PlaneLive
//
//  Created by Daniel on 01/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFoundCardItemView : UIView

///开始播放
@property (copy, nonatomic) void(^onStartPlayEvent)(ModelPracticeType *type);

@property (assign, nonatomic) CGFloat cvcW;
@property (assign, nonatomic) CGFloat cvcH;
///创建控件
-(void)innerInit;

///设置数据对象
-(void)setViewDataWithModel:(ModelPracticeType *)model;

+(CGFloat)getW;
+(CGFloat)getH;

@end
