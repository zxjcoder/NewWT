//
//  ZDownloadItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "XMCacheTrack.h"

@interface ZDownloadItemTVC : ZBaseTVC

///选中点击
@property (copy, nonatomic) void(^onCheckedClick)(BOOL check, NSInteger row);
///是否勾选过程中
@property (assign, nonatomic) BOOL isChecking;
///是否勾选中
@property (assign, nonatomic) BOOL isChecked;

///设置数据源
-(CGFloat)setCellDataWithModel:(XMCacheTrack *)model;

///设置选中状态
-(void)setCheckedStatus:(BOOL)isCheck;
///设置勾选中
-(void)setIsCheckingStatus:(BOOL)isCheck;

@end
