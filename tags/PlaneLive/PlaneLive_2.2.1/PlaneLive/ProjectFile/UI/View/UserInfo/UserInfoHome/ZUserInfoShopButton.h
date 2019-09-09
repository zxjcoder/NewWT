//
//  ZUserInfoShopButton.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButton.h"

#define ZUserInfoShopButtonWidth 65
#define ZUserInfoShopButtonHeight 65

@interface ZUserInfoShopButton : ZButton

///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZUserInfoCenterItemType)type;
///设置显示数量
-(void)setItemCount:(long)count;

@end
