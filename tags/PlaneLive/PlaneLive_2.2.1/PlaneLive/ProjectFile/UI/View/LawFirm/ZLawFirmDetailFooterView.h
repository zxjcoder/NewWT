//
//  ZLawFirmDetailFooterView.h
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

#define kZLawFirmDetailFooterViewHeight 40

@interface ZLawFirmDetailFooterView : ZView

///查看更多按钮事件
@property (copy, nonatomic) void(^onAllClick)();

@end
