//
//  ZUserInfoImageTVC.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///用户头像
@interface ZUserInfoImageTVC : ZBaseTVC

///我的头像
@property (copy, nonatomic) void(^onUserPhotoClick)();

/// 设置图片坐标
-(void)setViewImageFrame:(CGRect)frame;
/// 获取图片坐标
-(CGRect)getViewImageFrame;

/// 获取CELL宽度
-(CGFloat)getW;

@end
