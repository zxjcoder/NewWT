//
//  ZSettingBlackListTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyBaseTVC.h"

@interface ZSettingBlackListTVC : ZMyBaseTVC

///移除黑名单事件
@property (copy ,nonatomic) void(^onRemoveClick)(ModelUserBase *model, NSInteger rowIndex);

@end
