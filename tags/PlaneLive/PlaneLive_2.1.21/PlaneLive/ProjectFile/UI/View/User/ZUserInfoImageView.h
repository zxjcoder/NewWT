//
//  ZUserInfoImageView.h
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZUserInfoImageView : ZView

///我的头像
@property (copy, nonatomic) void(^onUserPhotoClick)();

/// 设置图片坐标
-(void)setViewImageFrame:(CGRect)frame;
/// 获取图片坐标
-(CGRect)getViewImageFrame;

+(CGFloat)getH;

-(void)setViewDataWithModel:(ModelUser *)model;

@end
