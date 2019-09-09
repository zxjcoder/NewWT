//
//  ZUserInfoHeaderTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 我的-顶部头像区域
@interface ZUserInfoHeaderTVC : ZBaseTVC

@property (copy ,nonatomic) void(^onUserPhotoClick)();
@property (copy ,nonatomic) void(^onShopCartClick)();
@property (copy ,nonatomic) void(^onPurchaseRecordClick)();
@property (copy ,nonatomic) void(^onBalanceClick)();
@property (copy ,nonatomic) void(^onDownloadClick)();

@end
