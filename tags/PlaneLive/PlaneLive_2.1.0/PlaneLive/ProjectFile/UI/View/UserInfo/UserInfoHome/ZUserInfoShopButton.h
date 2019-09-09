//
//  ZUserInfoShopButton.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButton.h"

#define ZUserInfoShopButtonWidth 55
#define ZUserInfoShopButtonHeight 50

@interface ZUserInfoShopButton : ZButton

///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZUserInfoCenterItemType)type;

@end
