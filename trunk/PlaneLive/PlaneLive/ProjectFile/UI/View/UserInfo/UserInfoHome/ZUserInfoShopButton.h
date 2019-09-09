//
//  ZUserInfoShopButton.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButton.h"

#define ZUserInfoShopButtonWidth 60
#define ZUserInfoShopButtonHeight 70

/// 我的-购物车-支付记录-余额-下载管理
@interface ZUserInfoShopButton : ZButton

///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZUserInfoCenterItemType)type;
///设置显示数量
-(void)setItemCount:(long)count;

@end
