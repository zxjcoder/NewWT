//
//  ZSubscribeAlreadyImageView.h
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZSubscribeAlreadyImageView : ZView

@property (copy, nonatomic) void(^onShowSubscribeDetail)(BOOL show);

///设置数据源
-(CGFloat)setViewDataWithModel:(ModelCurriculum *)model;

///显示详情按钮
-(void)setShowDetailButton;
///隐藏详情按钮
-(void)setDismissDetailButton;

///// 设置图片坐标
//-(void)setViewImageFrame:(CGRect)frame;
///// 获取图片坐标
//-(CGRect)getViewImageFrame;
+(CGFloat)getH;

@end
