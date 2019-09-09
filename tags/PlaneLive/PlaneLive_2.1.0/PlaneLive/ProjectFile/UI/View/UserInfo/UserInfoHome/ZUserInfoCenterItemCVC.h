//
//  ZUserInfoCenterItemCVC.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZUserInfoCenterItemCVC : UICollectionViewCell

///CVC点击事件
@property (copy, nonatomic) void(^onUserInfoCenterItemClick)(ZUserInfoCenterItemType type);
///类型
@property (assign, nonatomic) ZUserInfoCenterItemType type;
///设置数据源
-(void)setViewDataWithType:(ZUserInfoCenterItemType)type count:(long)count;

@end
