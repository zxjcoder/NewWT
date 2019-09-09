//
//  ZSubscribeAlreadyImageView.h
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZSubscribeAlreadyImageView : ZView

///设置数据源
-(void)setViewDataWithModel:(ModelCurriculum *)model;

/// 设置图片坐标
-(void)setViewImageFrame:(CGRect)frame;
/// 获取图片坐标
-(CGRect)getViewImageFrame;

@end
