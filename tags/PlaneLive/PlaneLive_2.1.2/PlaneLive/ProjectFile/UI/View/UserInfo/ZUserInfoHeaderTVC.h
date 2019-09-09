//
//  ZUserInfoHeaderTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserInfoHeaderTVC : ZBaseTVC

@property (copy ,nonatomic) void(^onUserPhotoClick)();

@property (copy ,nonatomic) void(^onShopCartClick)();

@property (copy ,nonatomic) void(^onPurchaseRecordClick)();

@property (copy ,nonatomic) void(^onBalanceClick)();

@end
