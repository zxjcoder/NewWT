//
//  ZUserInfoShopView.h
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZUserInfoShopView : ZView

@property (copy, nonatomic) void(^onUserInfoShoppingCartItemClick)(ZUserInfoCenterItemType type);

-(void)setViewDataWithModel:(ModelUser *)model;
+(CGFloat)getH;

@end
