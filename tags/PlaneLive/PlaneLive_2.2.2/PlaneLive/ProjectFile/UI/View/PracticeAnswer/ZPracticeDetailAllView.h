//
//  ZPracticeDetailAllView.h
//  PlaneCircle
//
//  Created by Daniel on 8/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPracticeDetailAllView : ZView

///查看全部
@property (copy, nonatomic) void(^onAllClick)();

///获取高度
+(CGFloat)getViewH;

@end
