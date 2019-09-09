//
//  ZUserInfoTableView.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZUserInfoTableView : ZBaseTableView

///偏移量
@property (copy, nonatomic) void(^onContentOffsetY)(CGFloat alpha);
///我的头像
@property (copy, nonatomic) void(^onUserPhotoClick)();

@property (copy ,nonatomic) void(^onShopCartClick)();
@property (copy ,nonatomic) void(^onPurchaseRecordClick)();
@property (copy ,nonatomic) void(^onBalanceClick)();

@property (copy, nonatomic) void(^onUserInfoGridClick)(ZUserInfoGridCVCType type);
@property (copy, nonatomic) void(^onUserInfoItemClick)(ZUserInfoItemTVCType type);

///设置数据源
-(void)setViewDataWithModel:(ModelUser *)model;

@end
