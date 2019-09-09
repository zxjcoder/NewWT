//
//  ZUserInfoGridCVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZUserInfoGridCVC : UICollectionViewCell

///CVC点击事件
@property (copy, nonatomic) void(^onUserInfoCenterItemClick)(ZUserInfoGridCVCType type);
///类型
@property (assign, nonatomic) ZUserInfoGridCVCType type;
///设置数据源
-(void)setViewDataWithType:(ZUserInfoGridCVCType)type count:(long)count;

@end
